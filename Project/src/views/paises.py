from .libraries import *

@app.route("/Scotland")
def scotland():
    if clienteEstaLogueado():
        beneficiarios = consultaBaseDatos("ObtenerBeneficiariosCuenta "+str(session["id_cuenta"]))
        formato_beneficiarios = []
        for beneficiario in beneficiarios:
            id_beneficiario = beneficiario[0]
            fb = {"id":id_beneficiario,"activo":beneficiario[1],"datos":beneficiario[2:]}
            fb["telefonos"] = consultaBaseDatos("ObtenerTelefonosBeneficiario "+str(id_beneficiario))
            formato_beneficiarios += [fb]
        porcentaje_beneficiarios = consultaBaseDatos("SumaPorcentajesBeneficiariosCuenta "+str(session["id_usuario"]))[0][0]
        porcentaje_beneficiarios = "La suma de los porcentajes de sus beneficiarios no suma 100, favor corregir" if porcentaje_beneficiarios!=100 else ""
        return render_template(
            "beneficiarios.html",
            beneficiarios = formato_beneficiarios,
            auth = obtener_auth(),
            porcentaje_beneficiarios = porcentaje_beneficiarios,
        )
    else:
          return render_template(
            "Scotland.html",
            auth = obtener_auth())

@app.route("/Ireland", methods=["GET", "POST"])
def ireland():
    if clienteEstaLogueado():
        beneficiarios = consultaBaseDatos("ObtenerBeneficiariosCuenta "+str(session["id_cuenta"]))
        formato_beneficiarios = []
        for beneficiario in beneficiarios:
            id_beneficiario = beneficiario[0]
            fb = {"id":id_beneficiario,"activo":beneficiario[1],"datos":beneficiario[2:]}
            fb["telefonos"] = consultaBaseDatos("ObtenerTelefonosBeneficiario "+str(id_beneficiario))
            formato_beneficiarios += [fb]
        porcentaje_beneficiarios = consultaBaseDatos("SumaPorcentajesBeneficiariosCuenta "+str(session["id_usuario"]))[0][0]
        porcentaje_beneficiarios = "La suma de los porcentajes de sus beneficiarios no suma 100, favor corregir" if porcentaje_beneficiarios!=100 else ""
        return render_template(
            "beneficiarios.html",
            beneficiarios = formato_beneficiarios,
            auth = obtener_auth(),
            porcentaje_beneficiarios = porcentaje_beneficiarios,
        )
    else:
          return render_template(
            "ireland.html",
            auth = obtener_auth())

@app.route("/UnitedStates", methods=["GET", "POST"])
def usa():
    if clienteEstaLogueado():
        if request.method=="POST":
            nombre = request.form["nombre"]
            tipo_documento_identidad = request.form["tipo_documento_identidad"]
            documento_identidad = request.form["documento_identidad"]
            fecha_nacimiento = request.form["fecha_nacimiento"]
            email = request.form["email"]
            porcentaje = request.form["porcentaje"]
            parentesco = request.form["parentesco"]
            telefono_1 = request.form["telefono_1"]
            telefono_2 = request.form["telefono_2"]
            consultaBaseDatos("InsertarBeneficiarioCuenta "+str(session["id_cuenta"])+",'"+nombre+"',"+tipo_documento_identidad+",'"+documento_identidad+"','"+fecha_nacimiento+"','"+email+"',"+porcentaje+","+parentesco+",'"+telefono_1+"','"+telefono_2+"'")
            session["mensaje"] = "Beneficiario creado"
            return redirect(url_for(".beneficiarios"))
        return render_template(
            "beneficiario.html",
            tipos_documento_identidad = consultaBaseDatos("ObtenerTiposDocumentoIdentidad"),
            parentescos = consultaBaseDatos("ObtenerParentescos"),
            auth = obtener_auth()
        )
    else:
        return render_template(
            "unitedstates.html",
            auth = obtener_auth()
        )

@app.route("/beneficiarios/editar/<id_beneficiario>", methods=["GET", "POST"])
def editar_beneficiario(id_beneficiario):
    if clienteEstaLogueado():
        beneficiario = consultaBaseDatos("ObtenerBeneficiario "+id_beneficiario)[0]
        nombre = beneficiario[0]
        id_tipo_documento_identidad = beneficiario[1]
        tipo_documento_identidad = beneficiario[2]
        documento_identidad = beneficiario[3]
        fecha_nacimiento = beneficiario[4]
        email = beneficiario[5]
        porcentaje = beneficiario[6]
        id_parentesco = beneficiario[7]
        parentesco = beneficiario[8]
        telefono_1 = ""
        telefono_2 = ""
        telefonos = consultaBaseDatos("ObtenerTelefonosBeneficiario "+id_beneficiario)
        if telefonos:
            telefono_1 = telefonos[0][1]
            telefono_2 = telefonos[1][1]
        if request.method=="POST":
            nombre = request.form["nombre"]
            tipo_documento_identidad = request.form["tipo_documento_identidad"]
            documento_identidad = request.form["documento_identidad"]
            fecha_nacimiento = request.form["fecha_nacimiento"]
            email = request.form["email"]
            porcentaje = request.form["porcentaje"]
            parentesco = request.form["parentesco"]
            telefono_1 = request.form["telefono_1"]
            telefono_2 = request.form["telefono_2"]
            telefonos = consultaBaseDatos("ObtenerTelefonosBeneficiario "+id_beneficiario)
            consultaBaseDatos("ModificarTelefono "+str(telefonos[0][0])+",'"+telefono_1+"'")
            consultaBaseDatos("ModificarTelefono "+str(telefonos[1][0])+",'"+telefono_2+"'")
            consultaBaseDatos("ModificarBeneficiario "+id_beneficiario+",'"+nombre+"',"+tipo_documento_identidad+",'"+documento_identidad+"','"+fecha_nacimiento+"','"+email+"',"+porcentaje+","+parentesco)
            session["mensaje"] = "Beneficiario modificado"
            return redirect(url_for(".beneficiarios"))
        return render_template(
            "beneficiario.html",
            nombre = nombre,
            id_tipo_documento_identidad = id_tipo_documento_identidad,
            tipo_documento_identidad = tipo_documento_identidad,
            documento_identidad = documento_identidad,
            fecha_nacimiento = fecha_nacimiento,
            email = email,
            porcentaje = porcentaje,
            id_parentesco = id_parentesco,
            parentesco = parentesco,
            telefono_1 = telefono_1,
            telefono_2 = telefono_2,
            parentescos = consultaBaseDatos("ObtenerParentescos"),
            tipos_documento_identidad = consultaBaseDatos("ObtenerTiposDocumentoIdentidad"),
            auth = obtener_auth()
        )
    else:
        return redirect(url_for(".index"))

@app.route("/beneficiarios/eliminar/<id_beneficiario>", methods=["GET", "POST"])
def eliminarBeneficiario(id_beneficiario):
    if clienteEstaLogueado():
        consultaBaseDatos("EliminarBeneficiario "+id_beneficiario)
        session["mensaje"] = "Beneficiario eliminado"
        return redirect(url_for(".beneficiarios"))
    else:
        return redirect(url_for(".index"))

@app.route("/beneficiarios/cambiarEstado/<id_beneficiario>")
def cambiarEstadoBeneficiario(id_beneficiario):
    if clienteEstaLogueado():
        consultaBaseDatos("CambiarEstadoActivoBeneficiario "+id_beneficiario)
        session["mensaje"] = "Estado de beneficiario cambiado"
        return redirect(url_for(".beneficiarios"))
    else:
        return redirect(url_for(".index"))