from .libraries import *
from .authentication import *
from .admin import *

@app.route("/", methods=["GET", "POST"])
def index():
    print(get_auth())
    if request.method=="POST":
        user = request.form["user"]
        password = request.form["password"]
        login = dataBaseQuery("SignIn '"+user+"','"+password+"'")
       
        if(login[0][0]!=0):
            if isAdmin(user):
                session["message"] = "Welcome Admin"
                session["isAdmin"] = True
                session["user"] = user
                session["id"]=login[0][0]
                return redirect(url_for(".adminHome"))
            
            session["message"] = "Log In Succesfull"
            session["isAdmin"] = False
            session["user"] = user
            session["id"]=login[0][0]
            return redirect(url_for(".countries"))

        else:   
            session["message"] = "Unvalid User"
    
    return render_template(
        "index.html",
        auth = get_auth()
    )



@app.route("/signup", methods=["GET", "POST"])
def signUp():
    if request.method=="POST":
        name = request.form["name"]
        adress= request.form["adress"]
        id = request.form["ident"]
        phone = request.form["phone"]
        email = request.form["email"]
        user = request.form["user"]
        password = request.form["password"]
       
        result=(MysqlUsers(name,adress,id,phone,email))
        
        if result==1:
            result2=(dataBaseQuery("InsertCredentials '"+id+"','"+user+"','"+password+"'"))
            session["id"]=id
            session["email"]=email
            dataBaseQueryScotland("GeneratePurchase '"+id+"'")
            session["message"] = "Account Succesfully Created!"
            session["isAdmin"] = False
            session["user"] = user
            return render_template(
                "index.html",
                auth = get_auth()
    )
    session["message"] = "Account Succesfully Created!"
    return render_template(
        "signup.html",
        auth = get_auth()
    )
    
@app.route("/admin/create", methods=["GET", "POST"])
def adminCreate():
    if request.method=="POST":
        name = request.form["name"]
        typed = request.form["type"]
        aged = request.form["age"]
        price = request.form["price"]
        supplier = request.form["supplier"]
        special = request.form["special"]
        result=(dataBaseQuery("CreateWhiskey '"+name+"','"+typed+"','"+aged+"','"+price+"','"+supplier+"','"+special+"'"))
        if result[0][0]==1:
            session["message"] = "Item Succesfully Created!"
            return render_template(
            "admin-create.html",auth = get_auth())
        else:
            session["message"] = "Item Could not be Created!"
            return render_template(
            "admin-create.html",auth = get_auth())
    return render_template(
            "admin-create.html",auth = get_auth())


@app.route("/admin/createWhiskeyType", methods=["GET", "POST"])
def adminCreateWhiskeyType():
    if request.method=="POST":
        name = request.form["name"]
        result=(dataBaseQuery("CreateWhiskeyType '"+name+"'"))
        if result[0][0]==1:
            session["message"] = "Whiskey Type Succesfully Created!"
            return render_template(
            "admin-create-whiskey-type.html",auth = get_auth())
        else:
            session["message"] = "Whiskey Type Could not be Created!"
            return render_template(
            "admin-create-whiskey-type.html",auth = get_auth())
    return render_template(
            "admin-create-whiskey-type.html",auth = get_auth())
""""
CREATE WHISKEYS AGED
"""

@app.route("/admin/createWhiskeyAged", methods=["GET", "POST"])
def adminCreateWhiskeyAge():
    if request.method=="POST":
        aged = request.form["aged"]
        result=(dataBaseQuery("CreateWhiskeyAged '"+aged+"'"))
        if result[0][0]==1:
            session["message"] = "Whiskey Age Succesfully Created!"
            return render_template(
            "admin-create-whiskey-age.html",auth = get_auth())
        else:
            session["message"] = "Whiskey Type Could not be Created!"
            return render_template("admin-create-whiskey-age.html",auth = get_auth())
    return render_template("admin-create-whiskey-age.html",auth = get_auth())









@app.route("/admin/createSupplier", methods=["GET", "POST"])
def adminCreateSupplier():
    if request.method=="POST":
        name = request.form["name"]

        result=(dataBaseQuery("CreateSupplier '"+name+"'"))
        if result[0][0]==1:
            session["message"] = "Supplier Succesfully Created!"
            return render_template(
            "admin-createSupplier.html",auth = get_auth())
        else:
            session["message"] = "Supplier Could not be Created!"
            return render_template(
            "admin-createSupplier.html",auth = get_auth())



    return render_template(
            "admin-createSupplier.html",auth = get_auth())



@app.route("/admin/update", methods=["GET", "POST"])
def adminUpdate():
    if request.method=="POST":
        name = request.form["name"]


    return render_template(
            "admin-update.html",auth = get_auth())


@app.route("/admin/UpdateWhiskeySupplier", methods=["GET", "POST"])
def adminUpdateWhiskeySupplier():
    if request.method=="POST":
        name = request.form["name"]
        supplier= request.form["supplier"]
        result=(dataBaseQuery("ModifyWhiskeySupplier '"+name+"','"+supplier+"'"))
        if result[0][0]==1:
            session["message"] = "Supplier Succesfully Updated!"
            return render_template(
            "admin-update-whiskey-supplier.html",auth = get_auth())
        else:
            session["message"] = "Supplier Could not be Updated!"
            return render_template(
            "admin-update-whiskey-supplier.html",auth = get_auth())

    return render_template(
            "admin-update-whiskey-supplier.html",auth = get_auth())


@app.route("/admin/ModifyWhiskeyType", methods=["GET", "POST"])
def adminUpdateWhiskeyTyped():
    if request.method=="POST":
        name = request.form["name"]
        type= request.form["type"]
        result=(dataBaseQuery("ModifyWhiskeyType '"+name+"','"+type+"'"))
        if result[0][0]==1:
            session["message"] = "Type Succesfully Updated!"
            return render_template(
            "admin-update-whiskey-type.html",auth = get_auth())
        else:
            session["message"] = "Type Could not be Updated!"
            return render_template(
            "admin-update-whiskey-type.html",auth = get_auth())

    return render_template("admin-update-whiskey-type.html",auth = get_auth())



@app.route("/admin/ModifyWhiskeyAge", methods=["GET", "POST"])
def adminUpdateWhiskeyAged():
    if request.method=="POST":
        name = request.form["name"]
        aged= request.form["aged"]
        result=(dataBaseQuery("ModifyWhiskeyAge '"+name+"','"+aged+"'"))
        if result[0][0]==1:
            session["message"] = "Aged Succesfully Updated!"
            return render_template(
            "admin-update-whiskey-age.html",auth = get_auth())
        else:
            session["message"] = "Aged Could not be Updated!"
            return render_template(
            "admin-update-whiskey-age.html",auth = get_auth())

    return render_template("admin-update-whiskey-age.html",auth = get_auth())

@app.route("/admin/DeleteWhiskey", methods=["GET", "POST"])
def adminDeleteWhiskey():
    if request.method=="POST":
        name = request.form["name"]
        result=(dataBaseQuery("DeleteWhiskey '"+name+"'"))
        if result[0][0]==1:
            session["message"] = "Whiskey Succesfully Deleted!"
            return render_template(
            "admin-delete-whiskey.html",auth = get_auth())
        else:
            session["message"] = "Whiskey Couldn't be Deleted!"
            return render_template(
            "admin-delete-whiskey.html",auth = get_auth())

    return render_template("admin-delete-whiskey.html",auth = get_auth())



@app.route("/admin/DeleteSupplier", methods=["GET", "POST"])
def adminDeletesSupplier():
    if request.method=="POST":
        name = request.form["name"]
        result=(dataBaseQuery("DeleteSupplier '"+name+"'"))
        if result[0][0]==1:
            session["message"] = "Supplier Succesfully Deleted!"
            return render_template(
            "admin-delete-supplier.html",auth = get_auth())
        else:
            session["message"] = "Supplier Couldn't be Deleted!"
            return render_template(
            "admin-delete-supplier.html",auth = get_auth())

    return render_template("admin-delete-supplier.html",auth = get_auth())





@app.route("/admin/DeleteType", methods=["GET", "POST"])
def adminDeletesType():
    if request.method=="POST":
        name = request.form["name"]
        result=(dataBaseQuery("DeleteWhiskeyType '"+name+"'"))
        if result[0][0]==1:
            session["message"] = "Type Succesfully Deleted!"
            return render_template(
            "admin-delete-type.html",auth = get_auth())
        else:
            session["message"] = "Type Couldn't be Deleted!"
            return render_template(
            "admin-delete-type.html",auth = get_auth())

    return render_template("admin-delete-type.html",auth = get_auth())



@app.route("/admin/DeleteAge", methods=["GET", "POST"])
def adminDeletesAged():
    if request.method=="POST":
        aged = request.form["aged"]
        result=(dataBaseQuery("DeleteWhiskeyAge '"+aged+"'"))
        if result[0][0]==1:
            session["message"] = "Aged Succesfully Deleted!"
            return render_template(
            "admin-delete-age.html",auth = get_auth())
        else:
            session["message"] = "Aged Couldn't be Deleted!"
            return render_template(
            "admin-delete-age.html",auth = get_auth())

    return render_template("admin-delete-age.html",auth = get_auth())


@app.route("/admin/EmployeesMenu")
def adminMenuEmployee():
    

    return render_template("admin-menu-employees.html",auth = get_auth())



@app.route("/admin/createEmployee", methods=["GET", "POST"])
def adminCreateEmployee():
    if request.method=="POST":
        name = request.form["name"]
        shop_id = request.form["shop_id"]
        adress = request.form["adress"]
        ident = request.form["ident"]
        phone = request.form["phone"]
        email = request.form["email"]
        salary = request.form["salary"]
        id_pos = request.form["position_id"]
        country = request.form["country"]


        result=dataBaseQueryEmployeesMysql(name,adress,ident,phone,email,shop_id,country,salary,id_pos)
        if result[0][0]==0:
            session["message"] = "Employee added Succesfully!"
            return render_template(
            "admin-create-employee.html",auth = get_auth())
        else:
            session["message"] = "Employee Couldn't be added!"
            return render_template(
            "admin-create-employee.html",auth = get_auth())

    return render_template("admin-create-employee.html",auth = get_auth())


@app.route("/admin/updateEmployee", methods=["GET", "POST"])
def adminUpdateEmployee():
    if request.method=="POST":
        name = request.form["name"]
        adress = request.form["adress"]
        ident = request.form["ident"]
        phone = request.form["phone"]
        email = request.form["email"]
        salary = request.form["salary"]
        id_pos = request.form["position_id"]
        result=dataBaseQueryEmployeesUpdateMysql(name,adress,ident,phone,email,salary,id_pos)
        if result[0][0]==0:
            session["message"] = "Employee Updated Succesfully!"
            return render_template(
            "admin-update-employee.html",auth = get_auth())
        else:
            session["message"] = "Employee Couldn't be Updated!"
            return render_template(
            "admin-update-employee.html",auth = get_auth())

    return render_template("admin-update-employee.html",auth = get_auth())





@app.route("/admin/deleteEmployee", methods=["GET", "POST"])
def adminDeleteEmployee():
    if request.method=="POST": 

        ident = request.form["ident"]

        result=dataBaseQueryEmployeesDeleteMysql(ident)
        if result[0][0]==0:
            session["message"] = "Employee Deleted Succesfully!"
            return render_template(
            "admin-delete-employee.html",auth = get_auth())
        else:
            session["message"] = "Employee Couldn't be Deleted!"
            return render_template(
            "admin-delete-employee.html",auth = get_auth())

    return render_template("admin-delete-employee.html",auth = get_auth())


@app.route("/countries", methods=["GET", "POST"])
def countries():
    query = "productsInfo"
    if request.method == "POST":
        type = request.form["types"]
        name = request.form["name"]
        if name == "":
            name = "NULL"
        else:
            name = "'%"+name+"%'"
        age = request.form["age"]
        priceMin = request.form["min"]
        priceMax = request.form["max"]
        query += " "+str(type)+", "+str(age)+", NULL, "+str(priceMin)+", "+str(priceMax)+", "+str(name)
        
    information = dataBaseQuery(query)
    types = dataBaseQuery("getTypes")
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        whisky[0] = photo.decode('utf-8') 

    return render_template(
        "countries.html",
        auth = get_auth(),
        photos = information,
        types = types
    )


@app.route("/Reviews", methods=["GET", "POST"])
def reviews():
    reviews = dataBaseQuery("whiskyReviews")
    return render_template(
        "reviews.html",
        auth = get_auth(),
        data= reviews
    )
    


def isAdmin(user):
    login =dataBaseQuery("IsAdmin '"+user+"'")

    if login[0][0]==1:
        return True
    else:
        return False
    return ""



@app.route("/employeesReviews", methods=["GET", "POST"])
def employeesReviews():
    if request.method=="POST":
        employee_id = request.form["ident"]
        cal = request.form["calification"]
        review = request.form["review"]
        result=(dataBaseQueryMysqlReview(session["id"],employee_id,review,cal))
        if result[0][0]==0:
            session["message"] = "Review Succesfully adedd!"
            return render_template(
            "employees-reviews.html",auth = get_auth())
        else:
            session["message"] = "Review Couldn't be adedd!"
            return render_template(
            "employees-reviews.html",auth = get_auth())

    return render_template("employees-reviews.html",auth = get_auth())






@app.route("/admin/employeesConsult", methods=["GET", "POST"])
def employeesConsult():
    if request.method=="POST":
        employee_id = request.form["ident"]
        cal = request.form["calification"]
        review = request.form["review"]
        result=(dataBaseQueryMysqlReview(session["id"],employee_id,review,cal))
        if result[0][0]==0:
            session["message"] = "Review Succesfully adedd!"
            return render_template(
            "employees-reviews.html",auth = get_auth())
        else:
            session["message"] = "Review Couldn't be adedd!"
            return render_template(
            "employees-reviews.html",auth = get_auth())

    return render_template("employees-reviews.html",auth = get_auth())





@app.route("/admin/createWhiskeyPresentation", methods=["GET", "POST"])
def adminCreatePresentation():
    if request.method=="POST":
        presentation = request.form["presentation"]

        result=(dataBaseQuery("CreateWhiskeyPresentation '"+presentation+"'"))
        if result[0][0]==1:
            session["message"] = "Presentation Succesfully Created!"
            return render_template(
            "admin-create-whiskey-presentation.html",auth = get_auth())
        else:
            session["message"] = "Presentation Could not be Created!"
            return render_template(
            "admin-create-whiskey-presentation.html",auth = get_auth())



    return render_template(
            "admin-create-whiskey-presentation.html",auth = get_auth())




@app.route("UpdateWhiskeyPresentation", methods=["GET", "POST"])
def updatePresentation():
    if request.method=="POST":
        presentation = request.form["presentation"]
        new_presentation=request.form["new_presentation"]

        result=(dataBaseQuery("UpdateWhiskeyPresentation '"+presentation+"','"+new_presentation+"'"))
        if result[0][0]==1:
            session["message"] = "Presentation Succesfully Updated!"
            return render_template(
            "admin-update-presentation.html",auth = get_auth())
        else:
            session["message"] = "Presentation Could not be Updated!"
            return render_template(
            "admin-update-presentation.html",auth = get_auth())



    return render_template(
            "admin-update-presentation.html",auth = get_auth())


@app.route("/admin/DeleteWhiskeyPresentation", methods=["GET", "POST"])
def DeletePresentation():
    if request.method=="POST":
        presentation = request.form["presentation"]

        result=(dataBaseQuery("DeleteWhiskeyPresentation '"+presentation+"'"))
        if result[0][0]==1:
            session["message"] = "Presentation Succesfully Deleted!"
            return render_template(
            "admin-delete-presentation.html",auth = get_auth())
        else:
            session["message"] = "Presentation Could not be Deleted!"
            return render_template(
            "admin-delete-presentation.html",auth = get_auth())



    return render_template(
            "admin-delete-presentation.html",auth = get_auth())

