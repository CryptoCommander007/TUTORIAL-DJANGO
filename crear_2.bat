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

:: Instalar Django
echo Instalando Django...
pip install django

:: Crear proyecto Django
echo Creando el proyecto Django %nombre_proyecto%...
django-admin startproject %nombre_proyecto%

:: Navegar al directorio del proyecto
cd %nombre_proyecto%

:: Crear la aplicación de hola_mundo
echo Creando la aplicación de hola_mundo...
python manage.py startapp hola_mundo

:: Crear la vista que muestra "Hola Mundo"
echo Creando la vista hola_mundo...
(
echo from django.http import HttpResponse
echo def hola_mundo(request):
echo     return HttpResponse("Hola Mundo")
) > hola_mundo\views.py

:: Configurar las URLs de la aplicación hola_mundo
echo Configurando las URLs...
(
echo from django.urls import path
echo from .views import hola_mundo
echo urlpatterns = [
echo     path('', hola_mundo, name='hola_mundo'),
echo ]
) > hola_mundo\urls.py

:: Agregar la aplicación hola_mundo a settings.py
echo Agregando hola_mundo a settings.py...
(
echo from pathlib import Path
echo BASE_DIR = Path(__file__).resolve().parent.parent
echo SECRET_KEY = 'your-secret-key'
echo DEBUG = True
echo ALLOWED_HOSTS = []
echo INSTALLED_APPS = [
echo     'django.contrib.admin',
echo     'django.contrib.auth',
echo     'django.contrib.contenttypes',
echo     'django.contrib.sessions',
echo     'django.contrib.messages',
echo     'django.contrib.staticfiles',
echo     'hola_mundo',
echo ]
echo MIDDLEWARE = [
echo     'django.middleware.security.SecurityMiddleware',
echo     'django.contrib.sessions.middleware.SessionMiddleware',
echo     'django.middleware.common.CommonMiddleware',
echo     'django.middleware.csrf.CsrfViewMiddleware',
echo     'django.contrib.auth.middleware.AuthenticationMiddleware',
echo     'django.contrib.messages.middleware.MessageMiddleware',
echo     'django.middleware.clickjacking.XFrameOptionsMiddleware',
echo ]
echo ROOT_URLCONF = '%nombre_proyecto%.urls'
echo TEMPLATES = [
echo     {
echo         'BACKEND': 'django.template.backends.django.DjangoTemplates',
echo         'DIRS': [],
echo         'APP_DIRS': True,
echo         'OPTIONS': {
echo             'context_processors': [
echo                 'django.template.context_processors.debug',
echo                 'django.template.context_processors.request',
echo                 'django.contrib.auth.context_processors.auth',
echo                 'django.contrib.messages.context_processors.messages',
echo             ],
echo         },
echo     },
echo ]
echo WSGI_APPLICATION = '%nombre_proyecto%.wsgi.application'
echo DATABASES = {
echo     'default': {
echo         'ENGINE': 'django.db.backends.sqlite3',
echo         'NAME': BASE_DIR / 'db.sqlite3',
echo     }
echo }
echo AUTH_PASSWORD_VALIDATORS = [
echo     {
echo         'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
echo     },
echo     {
echo         'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
echo     },
echo     {
echo         'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
echo     },
echo     {
echo         'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
echo     },
echo ]
echo LANGUAGE_CODE = 'es-es'
echo TIME_ZONE = 'UTC'
echo USE_I18N = True
echo USE_L10N = True
echo USE_TZ = True
echo STATIC_URL = '/static/'
) > %nombre_proyecto%\settings.py

:: Incluir las URLs de hola_mundo en el proyecto principal
echo Configurando las URLs del proyecto principal...
(
echo from django.contrib import admin
echo from django.urls import path, include
echo urlpatterns = [
echo     path('admin/', admin.site.urls),
echo     path('', include('hola_mundo.urls')),
echo ]
) > %nombre_proyecto%\urls.py

:: Aplicar migraciones y ejecutar el servidor de desarrollo
echo Aplicando migraciones iniciales...
python manage.py migrate

echo Iniciando el servidor de desarrollo de Django...
python manage.py runserver

endlocal
