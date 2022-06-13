import pyodbc
import MySQLdb
from flask_mysqldb import MySQL


def consultaBaseDatos(consult):
    server = 'CANIS-MAJORIS'
    database = 'MasterBase' 
    username = '' 
    password = '' 
    conexion = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
    cursor = conexion.cursor()
    cursor.execute(consult)
    data = []
    try:
        for i in cursor:
            data += [i]
          
    except:
        pass
    cursor.commit()
    cursor.close()
    conexion.close()

    return data




def consultaBaseDatosUSA(consult):
    server = 'DESKTOP-94UDDNK'
    database = 'USA' 
    username = 'sa' 
    password = '4321' 
    conexion = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
    cursor = conexion.cursor()
    cursor.execute(consult)
    data = []
    try:
        for i in cursor:
            data += [i]
          
    except:
        pass
    cursor.commit()
    cursor.close()
    conexion.close()

    return data



    
def consultaBaseDatosUsersMysql(query):

    mysql = MySQLdb.connect( host='localhost', user= 'root', passwd='123456', db='User' )
    cur = mysql.cursor()
    cur.callproc(query)
    data=[]
    try:
        for i in cur:
            data += [i]
          
    except:
        pass
    mysql.close()
    return data
name="gabriel"
adress="guada"
id="112221221"
phone="22987768"
email="hila@gmail.com"
#print(consultaBaseDatosUsersMysql('InsertClient'+"[name,adress,id,phone,email]"))

#print(consultaBaseDatosUsersMysql("(SELECT * FROM userdata)"))


