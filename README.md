# tienda_online

Para realizar este proyecto se deben de tener instalado previamente los siguientes programas:

- Base de datos PostgreSQL
- Python

Esta considerado para ejecutarse en un sistema operativo Windows.

## PostgreSQL

Se debe de tener una base de datos para poder crear, tablas, vistas, funciones, procedures y triggers, asi como un usuario que tenga los permisos necesarios para realizar estas acciones.

Los scripts necesarios para crear la base de datos estan en a carpeta Base_Datos. Ahi hay un archivo llamado readme.txt que contiene la información necesaria para crear los todos los objetos.

## Python

Se debe de tener instalado python 3.8 o superior. Esto se hace para realizar set datos de prueba de las tablas creadas del modelo.

## Instalación python

Una vez que se tiene el instalador de Python, al momento de realizar la instalación se debe de indicar que se desea cargar las variables de Python en las variables de ambiente del sistema.

En la carpeta Python se encuentra un archivo llamado get-pip.py el cual se debe de ejecutar de la siguinete manera:

En una terminal de Windows, se debe de ejecutar el siguiente comando

```
python get-pip.py
```

Esto es para que se pueda ejecutar posteriormente la instalación de paquetes con de Python con el comando pip

## Creación del proyecto

En una terminal de Windows, en una ruta en donde se desea crear este proyecto ejecutar el siguiente comando

```
git clone https://github.com/ArmandoAv/tienda_online.git
```

Esto creará en esa ubicación una carpeta con el nombre tienda_online.

Hay que moverse a esa nueva carpeta creada con el comando:

```
cd tienda_online
```

Una vez en esa nueva carpeta hay que ejecutar los siguientes comandos:

```
python -m venv venv
venv\Scripts\activate

```

Estos comandos crearan un ambiente virtual de python y lo activarán. Una vez que el mabiente ya ha sido activado hay que ejecutar el siguiente comando

```
pip install -r requirements.txt
```

Este comando instalará los paquetes necesarios para poder cargar los set de datos en las tablas creadas previemente.

Se debe de generar un archivo llamado .env en la misma ruta

Este archivo debe de contener lo siguiente

```
DB_HOST = localhost
DB_NAME = nombre_base_datos
DB_USR = usuario_base_datos
DB_PWD = password_base_datos
```

El primer renglón puede quedarse igual, pero en los demas se debe de poner los valores de la base de datos así como el usuario y el password creado en PostgreSQL.

Una vez realizado estos pasos y los pasos que indica el archvo Readme.txt en la carpeta Base_Datos. Se deben de ejecutar los siguientes comandos en el orden en que se ponen de lo contrario no funcionara la carga de los set de datos.

```
cd Crea_Set_datos
python SetDatosCustomer.py
python SetDatosProduct.py
python SetDatosOrder.py
python SetDatosOrderDetail.py
```

Finalmente, se debe de ejecutar el siguiente comando para actualizar algunas columnas de montos, ya que se cargan en ceros.

```
python UpdateSQL.py
```
