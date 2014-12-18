#Sistemas y Tecnologías Web

###Nombre del Proyecto
  Libook

###Descripción

> Se trata de una aplicación web en la cual puedes organizar tus libros, introduciendo el ISBN del mismo. La aplicación consultará la API de Google y nos devolverá toda la información relacionada con ese ISBN. 


###Instalación
Pasos ha seguir para la utilización de la aplicación.
- Necesitarás LiBook 
```sh
$ git clone [url repo]
```
- Actualizamos en gemas
```sh
$ bundle install --without production
```
-  Ejecutar la aplicación
```sh
$ rackup
```

###Breve explicación
La página principal de la aplicación, muestra un mensaje de bienvenida al usuario, en la esquina superior derecha veremos los link para poder logearnos en la aplicación.

Al logearnos, por ejemplo con Google, podemos ver los libros que tenemos ya en nuestra base de datos. 

Para guardar otro libro en nuestra base de datos sólo tendremos que introducir el ISBN y automáticamente nos mostrará los campos de la tabla.

Para tener más información sobre el libro sólo tendremos que hacer click en en alguno de los enlaces de la tabla.



###Proyecto

Enlaces: 
- Despliege en [GitHub](https://github.com/alu4421/LiBook.git)
- Despliege en [Heroku](http://libook.herokuapp.com)
- Despliege en Travis [![Build Status](https://travis-ci.org/alu4421/LiBook.svg?branch=master)](https://travis-ci.org/alu4421/LiBook)
- Despliege en Coveralls [![Coverage Status](https://coveralls.io/repos/alu4421/LiBook/badge.png?branch=master)](https://coveralls.io/r/alu4421/LiBook?branch=master)

-------

###Componentes de equipo
- Haniel Martin Arteaga
- Karen Mercedes Curro Díaz
- Jonay Suárez Armas
