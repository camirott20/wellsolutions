from .base import *

DEBUG = False 

ALLOWED_HOSTS = ['www.wellsolutions.com.mx']

DATABASES = {     
    'default': { 
        'ENGINE': 'django.db.backends.mysql',
        'NAME': environ.get('MYSQL_DATABASE', None),  
        'USER': environ.get('MYSQL_USER', None), 
        'PASSWORD': environ.get('MYSQL_PASSWORD', None),   
        'HOST': environ.get('MYSQL_HOST', None), 
        'PORT': '3306'
    }, 
}

INSTALLED_APPS = DJANGO_APPS + APPS_THIRD_PARTY + APPS



