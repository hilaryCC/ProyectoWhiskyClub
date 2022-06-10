from .libraries import *

@app.route("/administrador")
def administrador():
    if adminEstaLogueado():
        return render_template(
            "administrador.html",
            auth = obtener_auth(),
            cuentas = consultaBaseDatos("ObtenerCuentas")
        )
    else:
        return redirect(url_for(".index"))

@app.route("/administrador/cosSinDebito")
def cos_sin_debito():
    if adminEstaLogueado():
        consultaBaseDatos("COsSinDebito")
        datos = consultaBaseDatos("ObtenerTempCOsSinDebito")
        consultaBaseDatos("LimpiarTempCOsSinDebito")
        return render_template(
            "cos-sin-debito.html",
            auth = obtener_auth(),
            matriz = datos
        )
    else:
        return redirect(url_for("index"))

@app.route("/administrador/excesoATM", methods = ["GET","POST"])
def exceso_ATM():
    if adminEstaLogueado():
        matriz = []
        if request.method=="POST":
            cant_dias = request.form["cant_dias"]
            consultaBaseDatos("ExcesoOpsCajeroAuto "+cant_dias)
            matriz = consultaBaseDatos("ObtenerExcesoOpsCajeroAuto")
            consultaBaseDatos("LimpiarTempExcesoOpsCajeroAuto")
        return render_template(
            "exceso-ATM.html",
            matriz = matriz,
            auth = obtener_auth()
        )
    else:
        return render_template("index.html")

@app.route("/administrador/pagoBeneficiarios")
def pago_beneficiarios():
    if adminEstaLogueado():
        consultaBaseDatos("PagoBeneficiarios")
        matriz = consultaBaseDatos("ObtenerTempPagoBeneficiarios")
        consultaBaseDatos("LimpiarTempPagoBeneficiarios")
        return render_template(
            "pago-beneficiarios.html",
            matriz = matriz,
            auth = obtener_auth()
        )
    else:
        return render_template("index.html")