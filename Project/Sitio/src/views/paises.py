from .libraries import *
from .authentication import *

@app.route("/Scotland")
def scotland():
    return render_template(
        "Scotland.html",
        auth = obtener_auth())

@app.route("/Ireland", methods=["GET", "POST"])
def ireland():
    return render_template(
        "ireland.html",
        auth = obtener_auth())

@app.route("/UnitedStates", methods=["GET", "POST"])
def usa():
    return render_template(
        "unitedstates.html",
        auth = obtener_auth())

