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
        shop = request.form["shop_name"]

        result=(dataBaseQueryScotland("ModifyAmountWhiskey '"+name+"','"+amount+"','"+shop+"'"))
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



@app.route("/admin/update/ireland", methods=["GET", "POST"])
def adminUpdtateIreland():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        shop = request.form["shop_name"]

        result=(dataBaseQueryIreland("ModifyAmountWhiskey '"+name+"','"+amount+"','"+shop+"'"))
        if result[0][0]==1:
            session["message"] = "Stock Succesfully Updated!"
            return render_template(
            "admin-update-ireland.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "admin-update-ireland.html",auth = get_auth())


    return render_template(
        "admin-update-ireland.html",
        auth = get_auth())

@app.route("/admin/update/usa", methods=["GET", "POST"])
def adminUpdtateUsa():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        shop = request.form["shop_name"]

        result=(dataBaseQueryUSA("ModifyAmountWhiskey '"+name+"','"+amount+"','"+shop+"'"))
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


@app.route("/Scotland/store1", methods=["GET", "POST"])
def adminAddCartScotlandStore1():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "admin-update-usa.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "scotland-store1.html",auth = get_auth())


    return render_template(
        "scotland-store1.html",
        auth = get_auth())


@app.route("/Scotland/store2", methods=["GET", "POST"])
def adminAddCartScotlandStore2():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num=3

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "admin-update-usa.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "scotland-store1.html",auth = get_auth())


    return render_template(
        "scotland-store1.html",
        auth = get_auth())


@app.route("/Scotland/store3", methods=["GET", "POST"])
def adminAddCartScotlandStore3():
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num=3

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "admin-update-usa.html",auth = get_auth())
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "scotland-store1.html",auth = get_auth())


    return render_template(
        "scotland-store1.html",
        auth = get_auth())


@app.route("/Suscribe")
def Suscribe():
    (dataBaseQueryScotland("FinishPurchase"))
   

    return render_template(
        "suscribe.html",
        auth = get_auth())



@app.route("/Purchase", methods=["GET", "POST"])
def Purchase():
    (dataBaseQueryScotland("FinishPurchase"))
   

    return render_template(
        "purchase.html",
        auth = get_auth())






