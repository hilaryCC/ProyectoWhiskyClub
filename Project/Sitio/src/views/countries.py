from .libraries import *

@app.route("/Scotland",  methods=["GET", "POST"])
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


@app.route("/admin/update/scotland", methods=["GET", "POST"])
def adminUpdtateScotland():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]

        result=(dataBaseQueryScotland("ModifyAmountWhiskey '"+name+"','"+amount+"'"))
        if result[0][0]==1:
            session["message"] = "Stock Succesfully Updated!"
            return render_template(
            "admin-update-scotland.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "admin-update-scotland.html",auth = get_auth())


    return render_template(
        "admin-update-scotland.html",
        auth = get_auth())



@app.route("/admin/update/usa", methods=["GET", "POST"])
def adminUpdtateUsa():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]

        result=(dataBaseQueryScotland("ModifyAmountWhiskey '"+name+"','"+amount+"'"))
        if result[0][0]==1:
            session["message"] = "Stock Succesfully Updated!"
            return render_template(
            "admin-update-usa.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "admin-update-usa.html",auth = get_auth())


    return render_template(
        "admin-update-usa.html",
        auth = get_auth())


