@echo off
setlocal

:: Verifica que se haya proporcionado un nombre de proyecto
if "%~1"=="" (
    echo Por favor, proporciona un nombre de proyecto.
    echo Uso: create_project_django.bat nombre_proyecto
    exit /b 1
)

set "nombre_proyecto=%~1"
set "nombre_entorno_virtual=%nombre_proyecto%_env"

:: Crear entorno virtual
echo Creando el entorno virtual %nombre_entorno_virtual%...
python -m venv %nombre_entorno_virtual%

:: Activar entorno virtual
echo Activando el entorno virtual...
call %nombre_entorno_virtual%\Scripts\activate

:: Instalar Django y python-decouple
echo Instalando Django y python-decouple...
pip install django python-decouple

:: Crear proyecto Django
echo Creando el proyecto Django %nombre_proyecto%...
django-admin startproject %nombre_proyecto%

:: Navegar al directorio del proyecto
cd %nombre_proyecto%

:: Crear la aplicación de contacto
echo Creando la aplicación de contacto...
python manage.py startapp contacto

:: Crear directorio de plantillas y archivos de plantilla
mkdir contacto\templates\contacto

:: Crear home.html
echo Creando la plantilla home.html...
(
echo ^<!DOCTYPE html^>
echo ^<html^>
echo ^<head^>
echo ^    ^<title^>Página de Inicio^</title^>
echo ^</head^>
echo ^<body^>
echo ^    ^<h1^>Bienvenido a la Página de Inicio^</h1^>
echo ^    ^<p^>^<a href="^{% url 'contact' %^}"^>Ir al formulario de contacto^</a^>^</p^>
echo ^</body^>
echo ^</html^>
) > contacto\templates\contacto\home.html

:: Crear contact.html
echo Creando la plantilla contact.html...
(
echo ^<!DOCTYPE html^>
echo ^<html^>
echo ^<head^>
echo ^    ^<title^>Formulario de Contacto^</title^>
echo ^</head^>
echo ^<body^>
echo ^    ^<h1^>Formulario de Contacto^</h1^>
echo ^    ^<form method="post"^>
echo ^        ^{% csrf_token %^}
echo ^        ^{{ form.as_p }}^
echo ^        ^<button type="submit"^>Enviar^</button^>
echo ^    ^</form^>
echo ^</body^>
echo ^</html^>
) > contacto\templates\contacto\contact.html

:: Crear success.html
echo Creando la plantilla success.html...
(
echo ^<!DOCTYPE html^>
echo ^<html^>
echo ^<head^>
echo ^    ^<title^>Formulario Enviado^</title^>
echo ^</head^>
echo ^<body^>
echo ^    ^<h1^>Gracias por tu mensaje!^</h1^>
echo ^    ^<p^>Nos pondremos en contacto contigo pronto.^</p^>
echo ^</body^>
echo ^</html^>
) > contacto\templates\contacto\success.html

:: Crear forms.py en la aplicación de contacto
echo Creando el formulario en forms.py...
(
echo from django import forms
echo class ContactForm(forms.Form):
echo     name = forms.CharField(max_length=100, label='Nombre')
echo     email = forms.EmailField(label='Correo electr\xc3\xb3nico')
echo     message = forms.CharField(widget=forms.Textarea, label='Mensaje')
) > contacto\forms.py

:: Crear urls.py en la aplicación de contacto
echo Configurando las URLs en urls.py...
(
echo from django.urls import path
echo from .views import contact_view, success_view, home_view
echo urlpatterns = [
echo     path('', home_view, name='home'),
echo     path('contact/', contact_view, name='contact'),
echo     path('success/', success_view, name='success'),
echo ]
) > contacto\urls.py

:: Crear views.py en la aplicación de contacto
echo Creando las vistas en views.py...
(
echo from django.core.mail import send_mail
echo from django.shortcuts import render, redirect
echo from django.conf import settings
echo from .forms import ContactForm
echo def contact_view(request):
echo     if request.method == 'POST':
echo         form = ContactForm(request.POST)
echo         if form.is_valid():
echo             name = form.cleaned_data['name']
echo             email = form.cleaned_data['email']
echo             message = form.cleaned_data['message']
echo             send_mail(
echo                 f'Mensaje de ^{name^}',
echo                 message,
echo                 settings.EMAIL_HOST_USER,
echo                 ['Rolaasdasd77@gmail.com'],
echo                 fail_silently=False,
echo             )
echo             return redirect('success')
echo     else:
echo         form = ContactForm()
echo     return render(request, 'contacto/contact.html', {'form': form})
echo def success_view(request):
echo     return render(request, 'contacto/success.html')
echo def home_view(request):
echo     return render(request, 'contacto/home.html')
) > contacto\views.py

:: Crear el archivo .env en el directorio del proyecto
echo Creando el archivo .env...
(
echo EMAIL_HOST_USER=Rolaasdasd77@gmail.com
echo EMAIL_HOST_PASSWORD=nzko kgea udvv gkdv
) > .env

:: Instrucciones para el usuario
echo Por favor, modifica el archivo settings.py para incluir las configuraciones de correo:
echo.
echo from decouple import config
echo.
echo EMAIL_BACKEND = 'django.core.mail.backends.smtp.EmailBackend'
echo EMAIL_HOST = 'smtp.gmail.com'
echo EMAIL_PORT = 587
echo EMAIL_USE_TLS = True
echo EMAIL_HOST_USER = config('EMAIL_HOST_USER')
echo EMAIL_HOST_PASSWORD = config('EMAIL_HOST_PASSWORD')
echo.
echo No olvides agregar 'contacto' a INSTALLED_APPS:
echo.
echo INSTALLED_APPS = [
echo     ...,
echo     'contacto',
echo ]
echo.
echo Asegúrate de incluir las URLs de la aplicación contacto en el archivo urls.py del proyecto:
echo.
echo from django.contrib import admin
echo from django.urls import path, include
echo urlpatterns = [
echo     path('admin/', admin.site.urls),
echo     path('', include('contacto.urls')),
echo ]

:: Iniciar el servidor de desarrollo de Django
echo Iniciando el servidor de desarrollo de Django...
python manage.py runserver

endlocal
