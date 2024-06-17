Los archivos en esta carpeta contienen los scripts necesarios para crear los objetos de la base de datos

Se deben de utilizar en el siguiente orden

1. CreacionModeloDB.sql

Este script genera las tablas, índices y na vista del modelo de la tienda On-line

Los índices creados son los siguientes:

En la tabla CUSTOMERS
Se crea un índice compuesto por FIRSTNAME y LASTNAME

Esto es debido a que generalmente se hacen busquedas por el nombre del cliente
Por lo que este índice puede ayudar a que las busquedas sean mas eficientes

En la tabla ORDERS
Se crea un índice por ORDERDATE

Esto es debido a que además de ser parte de uno de los puntos del requerimiento
Es muy comun realizar análisis de las órdenes por la fecha y este índice ayuda a que estos análisis sean más rápidos

En la tabla ORDERDETAILS
Se crea un índice por ORDERID

Esto es debido a que esta tabla tiene una relacion muy estrecha con la tabla de ORDERS
Por lo que será consultada haciendo un cruce por la tabla de ORDERS y este índice ayudará hará el cruce mas eficiente

Por ultimo, se crea una vista llamada vw_CustomerOrders
Esta vista muestra el CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, el número de pedidos realizados y el total gastado por cada cliente en el último año (2023)


2. sp_MonthlySalesReport.sql

Este script crea un store procedure que ayuda a generar un reporte de ventas mensual.
El store recibe dos parámetros de entreda (FECHA_INICIO, FECHA_FIN)

Debido a que este script es un store procedure, se crea una tabla de reporte de ventas
MONTHLYSALESREPORT

Para que cuando se ejecute el store, se puedan consultar los datos
Por el momento se tiene la funcionalidad de que cuando el store sea ejecutado, borre los datos de la tabla del periodo consultado


3. CheckQuantity.sql

Este script genera un trigger llamado tr_CheckQuantity que valida que en el campo de QUANTITY en la tabla ORDERDETAILS no acepte cantidades menores a cero.
Para que el trigger realice la acción requerida se crea una función llamada fn_CheckQuantity 


4. fn_CalculateDiscount.sql

Este script crea una función llamada fn_CalculateDiscount, que ayuda a calcular posibles descuentos
De acuerdo con las siguientes reglas:

Si la cantidad es mayor o igual a 10, aplica un 10% de descuento.
Si la cantidad es mayor o igual a 20, aplica un 20% de descuento.
Si la cantidad es mayor o igual a 50, aplica un 25% de descuento.


5. fn_ActiveCustomers.sql

Este script crea una función de tabla llamada fn_ActiveCustomers, que devuelve los clientes que han realizado al menos un pedido en los últimos 6 meses.


6. CTECategories.sql

Este script contiene una consulta CTE, que obtiene las categorías de productos junto con el número total de productos vendidos y el ingreso total generado por cada categoría en el último año (2023).


7. sp_ProcessUpdateData.sql

Este script contiene un store procedure que realiza una actualizacion de los montos totales a la tabla ORDERS, procesando la información por lotes de 10000 registros para evitar un possible deadlock.

