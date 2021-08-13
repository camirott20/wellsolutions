#!/bin/bash
# Shell hacer deploy de una aplicacion Django en CPanel

readonly HOME_USER="${HOME}"
readonly VIRTUAL_ENV="$HOME_USER/virtualenv/wellsolutions"
readonly WORkING_DIR="$HOME_USER/wellsolutions"
readonly REPO_GIT="https://github.com/camirott20/wellsolutions.git"
readonly DJANGO_STATIC_DIR="$WORkING_DIR/static"
readonly APP_STATIC_ROOT="$HOME_USER/public_html"
readonly APP_STATIC_DIR="$APP_STATIC_ROOT/static"

function validar_entorno_virtual {
  if [[ ! -d $VIRTUAL_ENV ]]; then
    echo "No existe el entorno virtual configurado en: $VIRTUAL_ENV"
    exit 1
  fi
}

function binario_instalado {
  local readonly name="$1"

  if [[ ! $(command -v ${name}) ]]; then
    echo "El binario ${name} is requerido y no esta instalado"
    exit 1
  fi  
}

function verificar_binarios {
    binario_instalado "git"
    binario_instalado "pip"
    binario_instalado "python"
}

function eliminar_archivo {
  local readonly file="$1"
  echo "eliminiar archivo: $file"
  if [[ -f $file ]]; then
    echo "Elimiminando archivo: ${file}"
    rm $file
  fi

  if [[ -d $file ]]; then
    echo "Eliminando directorio: ${file}"
    rm -rf $file
  fi
}

function limpiar_directorio_trabajo {
  eliminar_archivo "README.md"
  eliminar_archivo "LICENSE"
  eliminar_archivo ".gitignore"
  eliminar_archivo ".git"
  eliminar_archivo "requirements"
  eliminar_archivo "deploy.sh"
}

function mover_archivos_estaticos {
  if [[ -d $APP_STATIC_ROOT ]]; then
    if [[ -d $APP_STATIC_DIR ]]; then
      rm -rf $APP_STATIC_DIR
    fi

    mv $DJANGO_STATIC_DIR $APP_STATIC_ROOT
  fi
}

function deploy {
    if [[ -d $WORkING_DIR ]]; then
        rm -rf $WORkING_DIR
        echo "Eliminando directorio: $WORkING_DIR"
    fi
    
    local GIT="$(which git)"
    local PIP="$(which pip)"
    local PYTHON="$(which python)"

    # Clona el repositorio de github
    $GIT clone $REPO_GIT

    # Establece el directorio de trabajo
    cd $WORkING_DIR

    # Instala las dependencias
    $PIP install -r requirements/prod.txt

    # Elimina los archivos que no son necesario en el directorio de trabajo
    limpiar_directorio_trabajo
    mv $WORkING_DIR/src/*  $WORkING_DIR
    eliminar_archivo "src"
    echo "from wellsolutions.wsgi import application" > passenger_wsgi.py

    # Configuracion de los archivos estaticos
    $PYTHON manage.py collectstatic
    mover_archivos_estaticos
}

validar_entorno_virtual
verificar_binarios
deploy
