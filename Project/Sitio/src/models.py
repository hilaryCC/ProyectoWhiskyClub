import pyodbc
import MySQLdb
from flask_mysqldb import MySQL


def dataBaseQuery(consult):
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




def dataBaseQueryUSA(consult):
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



    
def dataBaseQueryUsersMysql(query):

    mysql = MySQLdb.connect( host='localhost', user= 'root', passwd='123456', db='User' )
    cursor = mysql.cursor()
    cursor.callproc(query)
    data=[]
    try:
        for i in cursor:
            data += [i]
          
    except:
        pass
    mysql.close()
    return data



