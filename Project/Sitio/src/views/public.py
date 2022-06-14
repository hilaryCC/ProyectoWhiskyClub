from .libraries import *
from .authentication import *
import base64
import io 
from PIL import Image

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method=="POST":
        user = request.form["user"]
        password = request.form["password"]
        login = dataBaseQuery("SignIn '"+user+"','"+password+"'")
       
        if(login[0][0]==1):
            if isAdmin(user):
                session["message"] = "Welcome Admin"
                return render_template("admin.html",auth = get_auth())
            
            session["message"] = "Log In Succesfull"
            return redirect(url_for(".countries",auth = get_auth()))

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
            session["message"] = "Account Succesfully Created!"
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
        result=(dataBaseQuery("CreateWhiskey '"+name+"','"+typed+"','"+aged+"','"+price+"','"+supplier+"'"))
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
            "admin-update.html",auth = get_auth())



@app.route("/countries", methods=["GET", "POST"])
def countries():
    information = dataBaseQuery("productsInfo")
    photos = []
    for whisky in information:
        photo = base64.b64encode(whisky[0])
        photos += [[photo.decode('utf-8')]] 

    return render_template(
        "countries.html",
        auth = get_auth(),
        photos = photos,
        information = information[1:]
    )

def isAdmin(user):
    login =dataBaseQuery("IsAdmin '"+user+"'")

    if login[0][0]==1:
        return True
    else:
        return False
    return ""

