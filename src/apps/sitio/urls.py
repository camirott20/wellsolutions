from django.urls import path
from . import views

app_name = 'sitio'

urlpatterns = [
    path('', views.PageView.as_view(), name='index'),
]