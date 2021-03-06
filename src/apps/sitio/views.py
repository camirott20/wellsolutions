from django.core.mail import BadHeaderError, send_mail
from django.http import HttpResponseRedirect
from django.conf import settings
from django.template.loader import render_to_string
from django.template.response import TemplateResponse
from django.urls import reverse_lazy
from django.views.generic.base import TemplateView
from django.views.generic import FormView
from .forms import ContactForm


class PageView(TemplateView):
    template_name = 'sitio/index.html'


class SendEmailView(FormView):
    form_class = ContactForm
    template_name = 'sitio/index.html'
    success_url = reverse_lazy('sitio:index')
    message_sent = False

    def get_success_url(self):
        return super().get_success_url() + '?sent=True'

    def get_error_url(self):
        return super().get_success_url() + "?fail=True"

    def form_valid(self, form):
        self.enviar_email(form)

        if not self.message_sent:
            return HttpResponseRedirect(self.get_error_url())
        return super().form_valid(form)

    def form_invalid(self, form):
        return HttpResponseRedirect(self.get_error_url())

    def enviar_email(self, form):
        subject = 'Te estan intentando contactar'
        message = form.cleaned_data['mensaje']
        from_email = form.cleaned_data['email']
        nombre = form.cleaned_data['nombre']

        if subject and message and from_email:
            try:
                context = { 'subject': subject, 'message': message, 'from_email': from_email, 'nombre': nombre }
                html_body = render_to_string("sitio/email_contact.html", context)
                send_mail(subject, message, settings.EMAIL_HOST_USER, [settings.EMAIL_HOST_USER], html_message=html_body)
                self.message_sent = True
            except BadHeaderError:
                pass


def handler404(request, *args, **kwargs):
    context = { 'codigo': 404, 'descripcion': 'No se encontró la página que busca.'}
    response = TemplateResponse(request, 'http/status_code.html', context)
    response.status_code = 404
    return response

def handler500(request, *args, **kwargs):
    context = { 'codigo': 500, 'descripcion': 'Ocurrio un error en el servidor, vuelva a intentarlo mas tarde.'}
    response = TemplateResponse(request, 'http/status_code.html', context)
    response.status_code = 500
    return response