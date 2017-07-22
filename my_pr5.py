#_*_coding:utf-8_*_
# 
import numpy

fd=open('d3.dat','r')
lstm=fd.readlines()
fd.close()
print (lstm)
# Введена жорданова матрица
m=len(lstm)
print (m)
lst1=lstm[0].split(' ')
print (lst1)
n=len(lst1)-1
print (n)
# Определены её размеры
a=numpy.zeros([m,n])
# Создана "нулевая" форма
for i in range(m):
    str=lstm[i]
    lst2=str.split(' ')
    for j in range(n):
        a[i,j]=float(lst2[j])
print (a)
# Заполнена "нулевая" форма
r=numpy.linalg.matrix_rank(a)
print (r)
# Найден ранг матрицы
y=[]
for i in range(m):
    b=i+1
    y.append(b)
print (y)	
x=[]
for j in range(n):
    b=-(j+1)
    x.append(b)
print (x)
# Созданы списки иксов и игреков	
# Создана жорданова таблица
k=0
while k<r :
  print (k,k,a[k,k])
  if (y[k]>0)and(x[k]<0)and(a[k,k]!=0):	
     ir=k
     jr=k
     kr=a[k,k]
  print (ir,jr,kr)
# Найден разрешающий элемент
  for i in range(m):
    for j in range(n):
        if (i!=ir)and(j!=jr):
           a[i,j]=a[i,j]-a[ir,j]*a[i,jr]/kr
        else:
           a[ir,jr]=1/kr		
  print (a)
  for i in range(m):
    for j in range(n):
        if (i==ir)and(j!=jr):
           a[i,j]=-a[i,j]*a[ir,jr]
        else:
           if (i!=ir)and(j==jr):
              a[i,j]=a[i,j]*a[ir,jr]
  print (a)
# Сделано жорданово исключение
  yr=y[ir]
  xr=x[jr]
  y [ir]=xr
  x [jr]=yr 
  print (y)
  print (x)
# Завершено жорданово исключение
  k=k+1
