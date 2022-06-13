from .libraries import *
from flask import render_template, request, session, redirect, url_for

def usuarioEstaLogueado():
    return "usuario" in session and session["usuario"] and type(session["usuario"])==type(0)

def clienteEstaLogueado():
    return usuarioEstaLogueado() and not ("esAdmin" in session and session["esAdmin"])

def adminEstaLogueado():
    return usuarioEstaLogueado() and "esAdmin" in session and session["esAdmin"]

def obtenerMensaje():
    mensaje = "" if "mensaje" not in session else session["mensaje"]
    session["mensaje"] = ""
    return mensaje

@app.route("/cerrarSesion")
def cerrarSesion():
    session["id_cuenta"] = 0
    session["id_usuario"] = 0
    session["mensaje"] = "Saliste del sistema"
    return redirect(url_for(".index"))


def obtener_auth():
    return {
        "clienteEstaLogueado": clienteEstaLogueado(),
        "adminEstaLogueado": adminEstaLogueado(),
        "mensaje": obtenerMensaje()
    }