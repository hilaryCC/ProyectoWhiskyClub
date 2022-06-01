import pyodbc

server = 'KEVIN-PC'
bd = 'ConexionPython'
usuario = 'sa'
contrasena = 'BasesI2021'

try:
    conexion = pyodbc.connect('DRIVER={ODBC Driver 17 for SQL server}; SERVER='+server+';DATABASE='+bd+';UID='+usuario+';PWD='+contrasena)
    print("CONEXION EXITOSA")
except:
    print('error al intentar conectarse')

cursor = conexion.cursor()
cursor.execute("SELECT * FROM dbo.Tabla1")

persona = cursor.fetchone()

# while persona:
#     print(persona)
#     persona=cursor.fetchone()

cursor.close()
conexion.close()