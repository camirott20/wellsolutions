#!/bin/bash
# Shell hacer deploy de una aplicacion Django en CPanel

readonly HOME_USER="${HOME}"
readonly WORkING_DIR="$HOME_USER/AssuredVaguePaintprogram/wellsolutions"
readonly REPO_GIT="https://github.com/yrrodriguezb/wellsolutions.git"
readonly DJANGO_STATIC_DIR="$WORkING_DIR/static"
readonly APP_STATIC_ROOT="$HOME_USER/public_html"
readonly APP_STATIC_DIR="$APP_STATIC_ROOT/static"

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
}

function eliminar_archivo {
  local readonly file="$1"

  if [[ -f $file ]]; then
    echo "Elimiminando archivo: ${file}"
    rm $file
  fi

  if [[ -d $file ]]; then
    echo "Elimiminando directorio: ${file}"
    rm -rf $file
  fi
}

function limpiar_directorio_trabajo {
  eliminar_archivo "README.md"
  eliminar_archivo "LICENSE"
  eliminar_archivo ".gitignore"
  eliminar_archivo ".git"
  eliminar_archivo "requirements"
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
    if [[ ! -d $WORkING_DIR ]]; then
        rm -rf $WORkING_DIR
    fi
    
    local GIT="$(which git)"
    local PIP="$(which pip)"
    local PYTHON="$(which python)"

    $GIT clone $REPO_GIT

    cd $WORkING_DIR

    $PIP install -r requirements/prod.txt

    limpiar_directorio_trabajo

    mv $WORkING_DIR/src/*  $WORkING_DIR

    eliminar_archivo "src"

    echo "import wellsolutions.wsgi import application" > passenger_wsgi.py

    $PYTHON manage.py collectstatic

    mover_archivos_estaticos
}

verificar_binarios
deploy


