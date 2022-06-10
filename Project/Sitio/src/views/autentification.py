from .libraries import *

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

def obtener_cuentas():
    if clienteEstaLogueado():
        cuenta = consultaBaseDatos("ObtenerCuentaUsuario "+str(session["id_usuario"]))
        acceso_cuentas = consultaBaseDatos("ObtenerCuentasAccesoUsuario "+str(session["id_usuario"]))
        cuenta = [] if len(cuenta) and cuenta[0] in acceso_cuentas else cuenta
        return cuenta + acceso_cuentas
    return []

def cuentaEstaSeleccionada():
    return "id_cuenta" in session and session["id_cuenta"] and type(session["id_cuenta"])==type(0)

def obtener_auth():
    return {
        "clienteEstaLogueado": clienteEstaLogueado(),
        "adminEstaLogueado": adminEstaLogueado(),
        "mensaje": obtenerMensaje(),
        "cuentas": obtener_cuentas(),
        "cuentaEstaSeleccionada": cuentaEstaSeleccionada()
    }