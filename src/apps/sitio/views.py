
from django.core.mail import BadHeaderError, send_mail
from django.template.response import TemplateResponse
from django.views.generic.base import TemplateView
from django.views.generic import FormView
from django.urls import reverse_lazy
from .forms import ContactForm
from django.http import HttpResponseRedirect


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

        if subject and message and from_email:
            try:
                send_mail(subject, message, from_email, ['admin@wellsolutions.com'])
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