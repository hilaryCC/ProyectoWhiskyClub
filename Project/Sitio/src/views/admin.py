from .libraries import *
from .authentication import *

@app.route("/admin")
def adminHome():
    return render_template("admin.html", auth=get_auth())

@app.route("/admin/consult")
def adminConsult():
    return render_template("admin-consult.html", auth=get_auth())

@app.route("/admin/consult/products")
def adminConsultProducts():
    return render_template("admin.html", auth=get_auth())

@app.route("/admin/consult/client")
def adminConsultClient():
    return render_template("admin.html", auth=get_auth())

