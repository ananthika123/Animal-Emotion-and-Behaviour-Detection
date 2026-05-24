"""animal URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path


from myapp import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('adminhome',views.adminhome),
    path('',views.login__),
    path('login_post__',views.login_post__),
    path('addAnimal__',views.addAnimal__),
    path('addanimal_post',views.addanimal_post),
    path('editAnimal__/<id>',views.editAnimal__),
    path('edit_animal_post/<id>',views.edit_animal_post),
    path('delete_animal/<id>',views.delete_animal),
    path('viewAnimal__', views.viewAnimal__),
    path('addBreed__/<id>', views.addBreed__),
    path('add_breed_post/<id>',views.add_breed_post),
    path('editBreed__/<id>', views.editBreed__),
    path('editBreed_post__/<id>',views.editBreed_post__),
    path('viewBreed__/<id>', views.viewBreed__),
    path('viewUser__', views.viewUser__),
    path('changePassword__', views.changePassword__),
    path('changePassword_post__',views.changePassword_post__),
    path('viewRating__', views.viewRating__),
















    #-----------------USER-----------------------------

    path('user_register',views.user_register),
    path('login_user',views.login_user),
    path('rate_review',views.rate_review),
    path('view_user',views.view_user),
    path('view_animal',views.view_animal),
    path('view_breed',views.view_breed),
    path('load_breed',views.load_breed),
    path('add_pet',views.add_pet),
    path('view_my_pet',views.view_my_pet),
    path('user_delete_pet',views.user_delete_pet),
    path('add_vaccination',views.add_vaccination),
    path('check_vaccine_notification',views.check_vaccine_notification),
    path('user_view_vaccination',views.user_view_vaccination),
    path('user_delete_vaccination',views.user_delete_vaccination),
    path('process_audio',views.process_audio),
    path('process_video',views.process_video),

]
urlpatterns+=static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)