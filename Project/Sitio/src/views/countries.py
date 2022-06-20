from .libraries import *

@app.route("/Scotland",  methods=["GET", "POST"])
def scotland():
    information = dataBaseQueryScotland('getWhiskys')
    name = dataBaseQueryScotland('getStoreNames')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8') 
    return render_template(
        "Scotland.html",
        photos = information,
        names = name,
        auth = get_auth())

@app.route("/Ireland", methods=["GET", "POST"])
def ireland():
    information = dataBaseQueryIreland('getWhiskys')
    name = dataBaseQueryIreland('getStoreNames')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    return render_template(
        "ireland.html",
        photos = information,
        names = name,
        auth = get_auth())

@app.route("/UnitedStates", methods=["GET", "POST"])
def usa():
    information = dataBaseQueryUSA('getWhiskys')
    name = dataBaseQueryUSA('getStoreNames')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    return render_template(
        "unitedstates.html",
        photos = information,
        names = name,
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

"""
Function for boughting in stores Scotland

"""
@app.route("/Scotland/store1", methods=["GET", "POST"])
def adminAddCartScotlandStore1():
    information = dataBaseQueryScotland('getWhiskysStore 1')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "scotland-store1.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "scotland-store1.html",auth = get_auth(), photos = information)


    return render_template(
        "scotland-store1.html",
        auth = get_auth(),
        photos = information)


@app.route("/Scotland/store2", methods=["GET", "POST"])
def adminAddCartScotlandStore2():
    information = dataBaseQueryScotland('getWhiskysStore 2')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="3"

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "scotland-store2.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "scotland-store2.html",auth = get_auth(), photos = information)


    return render_template(
        "scotland-store2.html",
        auth = get_auth(),
        photos = information)


@app.route("/Scotland/store3", methods=["GET", "POST"])
def adminAddCartScotlandStore3():
    information = dataBaseQueryScotland('getWhiskysStore 3')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="3"

        result=(dataBaseQueryScotland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "scotland-store3.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Stock Could not be Updated!"
            return render_template(
            "scotland-store3.html",auth = get_auth(), photos = information)


    return render_template(
        "scotland-store3.html",
        auth = get_auth(),
        photos = information)

""""
Function for boughting in stores USA

"""
@app.route("/Usa/store1", methods=["GET", "POST"])
def adminAddCartUsaStore1():
    information = dataBaseQueryUSA('getWhiskysStore 1')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryUSA("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "usa-store1.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "usa-store1.html",auth = get_auth(), photos = information)


    return render_template(
        "usa-store1.html",
        auth = get_auth(),
         photos = information)


@app.route("/Usa/store2", methods=["GET", "POST"])
def adminAddCartUsaStore2():
    information = dataBaseQueryUSA('getWhiskysStore 2')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryUSA("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "usa-store2.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "usa-store2.html",auth = get_auth(), photos = information)


    return render_template(
        "usa-store2.html",
        auth = get_auth(), photos = information)

@app.route("/Usa/store3", methods=["GET", "POST"])
def adminAddCartUsaStore3():
    information = dataBaseQueryUSA('getWhiskysStore 3')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"
        result=(dataBaseQueryUSA("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "usa-store3.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item CSouldn't be added to Cart!"
            return render_template(
            "usa-store3.html",auth = get_auth(), photos = information)


    return render_template("usa-store3.html",auth = get_auth(), photos = information)


""""
Function for boughting in stores Ireland

"""
@app.route("/Ireland/store1", methods=["GET", "POST"])
def adminAddCartIrelandStore1():
    information = dataBaseQueryIreland('getWhiskysStore 1')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryIreland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "ireland-store1.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "ireland-store1.html",auth = get_auth(), photos = information)


    return render_template(
        "ireland-store1.html",
        auth = get_auth(), photos = information)

@app.route("/Ireland/store2", methods=["GET", "POST"])
def adminAddCartIrelandStore2():
    information = dataBaseQueryIreland('getWhiskysStore 2')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryIreland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "ireland-store2.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "ireland-store2.html",auth = get_auth(), photos = information)


    return render_template(
        "ireland-store2.html",
        auth = get_auth(), photos = information)

@app.route("/Ireland/store3", methods=["GET", "POST"])
def adminAddCartIrelandStore3():
    information = dataBaseQueryIreland('getWhiskysStore 3')
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8')
    if request.method=="POST":
        name = request.form["name"]
        amount = request.form["amount"]
        num="1"

        result=(dataBaseQueryIreland("AddKart '"+name+"','"+amount+"','"+num+"','"+session["id"]+"'"))
        print(result)
        if result[0][0]==1:
            session["message"] = "Item added to Cart!"
            return render_template(
            "ireland-store3.html",auth = get_auth(), photos = information)
        else:
            session["message"] = "Item Couldn't be added to Cart!"
            return render_template(
            "ireland-store3.html",auth = get_auth(), photos = information)


    return render_template(
        "ireland-store3.html",
        auth = get_auth(), photos = information)


@app.route("/SuscriptionMenu")
def SuscriptionMenu():

    return render_template(
        "suscriptionMenu.html",
        auth = get_auth())

@app.route("/Suscribe", methods=["GET", "POST"])
def Suscribe():
    if request.method=="POST":
        type = request.form["type"]
        card = request.form["card"]
        print(session["id"])
        result=(dataBaseQuery("SuscribeClub '"+type+"','"+card+"','"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Suscribe Succesfull!"
            return render_template(
           "suscribe.html",auth = get_auth())
        else:
            session["message"] = "Suscribe Failed!"
            return render_template(
           "suscribe.html",auth = get_auth())

    
    return render_template(
        "suscribe.html",
        auth = get_auth())

@app.route("/UpdateSuscription", methods=["GET", "POST"])
def UpdateSuscription():
    if request.method=="POST":
        club_id = request.form["club_id"]
        result=(dataBaseQuery("UpdateSuscription '"+session["id"]+"','"+club_id+"'"))
        if result[0][0]==1:
            session["message"] = "Update Succesfull!"
            return render_template(
           "update-suscription.html",auth = get_auth())
        else:
            session["message"] = "Update Failed!"
            return render_template(
           "update-suscription.html",auth = get_auth())

    
    return render_template(
        "update-suscription.html",
        auth = get_auth())


@app.route("/DeleteSuscription", methods=["GET", "POST"])
def DeleteSuscription():
    if request.method=="POST":
        result=(dataBaseQuery("DeleteSuscription '"+session["id"]+"'"))
        if result[0][0]==1:
            session["message"] = "Delete Succesfull!"
            return render_template(
           "delete-suscription.html",auth = get_auth())
        else:
            session["message"] = "Delete Failed!"
            return render_template(
           "delete-suscription.html",auth = get_auth())

    
    return render_template(
        "delete-suscription.html",
        auth = get_auth())



@app.route("/Purchase", methods=["GET", "POST"])
def Purchase():
    dataBaseQueryScotland("FinishPurchase '"+session["id"]+"'")
    body="Pagina web ya manda correos ;)"

    email=(dataBaseQuery("ObtainClientEmail '"+session["id"]+"'")[0][0])
    (dataBaseQuery("SendEmail '"+email+"','"+body+"'"))
    if request.method=="POST":
        name = request.form["name"]
        review = request.form["review"]
        result=dataBaseQuery("InsertWhiskeyReview '"+name+"','"+review+"','"+session["id"]+"'")
        if result[0][0]==1:
             session["message"] = "Review added!"
             return render_template("purchase.html",auth = get_auth())
        else:
            session["message"] = "Whiskey Doesn't Exist!"
            return render_template("purchase.html",auth = get_auth())
            
   

    return render_template(
        "purchase.html",
        auth = get_auth())

