# online_store_postgres

## Prerequisites

To undertake this project successfully, ensure you have the following software installed beforehand:

- PostgreSQL
- Python

This project is considered to run on a Windows operating system.

### PostgreSQL

This database will be used to create tables, views, functions, procedures, and triggers. A user with necessary permissions to perform these actions is also required.

The scripts required to create the database can be found in the database folder. A readme.txt file within this folder provides detailed instructions for creating all database objects.

### Python

Python 3.8 or higher is required to generate test datasets for the model's created tables.

## Creación del proyecto

Open a Windows terminal, in the path where you want to create this project, run the following command

```
git clone https://github.com/ArmandoAv/online_store.git
```

This will create a folder named online_store in that location.

You have to move to that new folder created with the command:

```
cd online_store
```

If you don't have pip (Package Installer for Python) tool, you need to run the following commands:

```
cd pip
python get-pip.py
cd ..
```

This tool helps you install and manage Python packages.

Whenever Python is used in a project, it is recommended to create a virtual environment so that the necessary packages can be installed to run Python scripts. This is also done to have control of the packages that are needed and not install extra packages from other developments.

To create and activate the virtual environment, you need to run the following commands:

```
cd postgres
python -m venv pvenv
pvenv\Scripts\activate

```

Once the environment has been activated, you must run the following command

```
pip install -r requirements.txt
```

This command will install the necessary packages to be able to load the data sets into the previously created tables.

A file called .env must be generated in the same path

This file must contain the following

```
DB_HOST = localhost
DB_NAME = database_name
DB_USR = database_user
DB_PWD = database_password
```

The first row can remain the same, but in the rest you must enter the database values ​​as well as the username and password created in PostgreSQL.

Once you have completed these steps and the steps that indicate the Readme.txt file in the database folder. The following commands must be run in the order in which they are given, otherwise loading the data sets will not work.

```
cd dataset
python CustomerDataSet.py
python ProductDataSet.py
python OrderDataSet.py
python OrderDetailDataSet.py
```

Finally, the following command must be executed to update some columns of amounts, since they are loaded with zeros.

```
python UpdateSQL.py
```
