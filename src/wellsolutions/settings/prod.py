from .base import *

DEBUG = False 

ALLOWED_HOSTS = ['www.wellsolutions.com.mx', 'wellsolutions.com.mx']

INSTALLED_APPS = DJANGO_APPS + APPS_THIRD_PARTY + APPS

# Email

EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
EMAIL_HOST = environ.get("EMAIL_HOST", None)
EMAIL_HOST_USER = environ.get("EMAIL_HOST_USER", None)
EMAIL_HOST_PASSWORD = environ.get("EMAIL_HOST_PASSWORD", None)
EMAIL_PORT = environ.get("EMAIL_PORT", None)
EMAIL_USE_TLS = environ.get("EMAIL_USE_TLS", True)