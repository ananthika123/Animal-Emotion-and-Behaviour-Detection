from django.contrib.auth.models import User
from django.db import models

# Create your models here.


class animal(models.Model):
    name=models.CharField(max_length=100)
    photo=models.CharField(max_length=100)
    detail=models.CharField(max_length=5000)

class user(models.Model):
    name=models.CharField(max_length=100)
    email=models.CharField(max_length=100)
    phone=models.CharField(max_length=100)
    LOGIN=models.ForeignKey(User,on_delete=models.CASCADE)

class rating_review(models.Model):
    USER=models.ForeignKey(user,on_delete=models.CASCADE)
    rating=models.CharField(max_length=100)
    review=models.CharField(max_length=5000)
    date=models.CharField(max_length=100)

class prediction(models.Model):
    pet=models.CharField(max_length=100)
    file=models.CharField(max_length=100)
    type=models.CharField(max_length=100)
    result=models.CharField(max_length=100)
    date=models.CharField(max_length=100)

class breeds(models.Model):
    ANIMAL=models.ForeignKey(animal,on_delete=models.CASCADE)
    breed=models.CharField(max_length=100)
    photo=models.CharField(max_length=100)
    details=models.CharField(max_length=5000)



class pet(models.Model):
    USER = models.ForeignKey(user, on_delete=models.CASCADE)
    BREEDS=models.ForeignKey(breeds,on_delete=models.CASCADE)
    photo=models.CharField(max_length=100)
    age=models.CharField(max_length=100)
    description=models.CharField(max_length=5000)


class vaccination(models.Model):
    title=models.CharField(max_length=100)
    date=models.CharField(max_length=100)
    description=models.CharField(max_length=5000)
    PET=models.ForeignKey(pet,on_delete=models.CASCADE)





