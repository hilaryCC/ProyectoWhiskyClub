import pyodbc
import MySQLdb
from flask_mysqldb import MySQL
import mysql.connector

import smtplib
from email.mime.multipart import MIMEMultipart
from email.mime.text import MIMEText

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
    server = 'CANIS-MAJORIS'
    database = 'USA' 
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

def dataBaseQueryScotland(consult):
    server = 'CANIS-MAJORIS'
    database = 'Scotland' 
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


def dataBaseQueryIreland(consult):
    server = 'CANIS-MAJORIS'
    database = 'Ireland' 
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


    
def dataBaseQueryUsersMysql(query):

    mysql = MySQLdb.connect( host='localhost', user= 'root', passwd='123456', db='user' )
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

def MysqlUsers(name,adress,id,phone,email):
    connection = mysql.connector.connect( host='localhost',database='user', user= 'root', password='123456' )
    cursor=connection.cursor()
    cursor.callproc("InsertClient",[name,adress,id,phone,email])
    data=[]
    for result in cursor.stored_results():
        data+=result.fetchall()

    cursor.close()
    connection.close()
    return data[0][0]