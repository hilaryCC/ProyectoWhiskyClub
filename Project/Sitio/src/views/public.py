from .libraries import *
from .authentication import *

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method=="POST":
        user = request.form["user"]
        password = request.form["password"]
        login = dataBaseQuery("SignIn '"+user+"','"+password+"'")
       
        if(login[0][0]==1):
            if isAdmin(user):
                session["mmessage"] = "Welcome Admin"
                return render_template("admin.html",auth = get_auth())
            
            session["message"] = "Log In Succesfull"
            return render_template("countries.html",auth = get_auth())
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
            session["mensaje"] = "Account Succesfully Created!"
            return render_template(
                "index.html",
                auth = get_auth()
    )
    session["message"] = "Account Succesfully Created!"
    return render_template(
        "signup.html",
        auth = get_auth()
    )

@app.route("/countries", methods=["GET", "POST"])
def countries():
    return render_template(
        "countries.html",
        auth = get_auth()
    )

def isAdmin(user):
    login =dataBaseQuery("IsAdmin '"+user+"'")

    if login[0][0]==1:
        return True
    else:
        return False
    return ""

