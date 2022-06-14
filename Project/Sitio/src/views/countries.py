from .libraries import *
from .authentication import *

@app.route("/Scotland")
def scotland():
    return render_template(
        "Scotland.html",
        auth = get_auth())

@app.route("/Ireland", methods=["GET", "POST"])
def ireland():
    return render_template(
        "ireland.html",
        auth = get_auth())

@app.route("/UnitedStates", methods=["GET", "POST"])
def usa():
    return render_template(
        "unitedstates.html",
        auth = get_auth())

