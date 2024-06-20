# online_store_sqlserver

## Prerequisites

To undertake this project successfully, ensure you have the following software installed beforehand:

- SQL Server
- ODBC Driver for SQL Server
- Python

This project is considered to run on a Windows operating system.

### SQL Server

This database will be used to create tables, views, functions, procedures, and triggers. A user with necessary permissions to perform these actions is also required.

The scripts required to create the database can be found in the database folder. A readme.txt file within this folder provides detailed instructions for creating all database objects.

### ODBC Driver for SQL Server

ODBC Driver 17 is required to connect with the SQL Server.

### Python

Python 3.8 or higher is required to generate test datasets for the model's created tables.

## Project creation

Open a Windows terminal, in the path where you want to create this project, run the following commands
> [!NOTE]
> The next step must be done if you have not done it before with the steps in the postgres folder, this is because it only has to be executed once.

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

If you already have the project with the steps in the postgres folder. Open a Windows terminal, in the online_store folder.
If you don't have an virtual environment, you need to run the following commands:

```
cd sqlserver
python -m venv sqlvenv
sqlvenv\Scripts\activate
```

If you have an virtual environment, you must run the following commands:

```
cd sqlserver
sqlvenv\Scripts\activate
```

Once the environment has been activated, you must run the following command

```
pip install -r requirements.txt
```

This command will install the necessary packages to be able to load the data sets into the previously created tables.

With the following command you can see the list of packages installed in the virtual environment

```
pip list
```

This command should display the following list, with the same or similar versions of the installed packages

```
Package         Version
--------------- -----------
Faker           25.8.0
pip             24.0
pyodbc          5.1.0
python-dateutil 2.9.0.post0
python-decouple 3.8
python-dotenv   1.0.1
setuptools      65.5.0
six             1.16.0
```

If you want to deactivate the virtual environment, you must execute the following command:

```
deactivate
```

> [!NOTE]
> Because the project is divided into two, it is necessary to disable the virtual environment if you want to run the Postgres part or open a new terminal and enable the other virtual environment.

A file called .env must be generated in the same path

This file must contain the following

```
DB_HOST = localhost
DB_NAME = database_name
DB_USR = database_user
DB_PWD = database_password
```

The first row can remain the same, but in the rest you must enter the database values ​​as well as the username and password created in SQL Server.

Once you have completed these steps and the steps that indicate the Readme.txt file in the database folder. The following commands must be run in the order in which they are given, otherwise loading the data sets will not work.

```
cd dataset
python CustomerDataSetSQLServer.py
python ProductDataSetSQLServer.py
python OrderDataSetSQLServer.py
python OrderDetailDataSetSQLServer.py
```

Finally, the following command must be executed to update some columns of amounts, since they are loaded with zeros.

```
python UpdateAmountSQLServer.py
```
