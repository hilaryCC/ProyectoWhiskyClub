from .libraries import *
from .authentication import *

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method=="POST":
        user = request.form["user"]
        password = request.form["password"]
        login = dataBaseQuery("SignIn '"+user+"','"+password+"'")[0][0]
       
        if(login==1):
            
            session["message"] = "Log In Succesfull"
            return redirect(url_for(".countries", auth = get_auth()))
        else:   
            session["message"] = "Unvalid User"
            

    
    return render_template(
        "index.html",
        auth = get_auth()
    )



@app.route("/signUp", methods=["GET", "POST"])
def signUp():
    if request.method=="POST":
        name = request.form["name"]
        adress= request.form["adress"]
        id = request.form["ident"]
        phone = request.form["phone"]
        email = request.form["email"]
        user = request.form["user"]
        password = request.form["password"]
       
        dataBaseQueryUsersMysql("Call InsertClient("+name+"','"+adress+"','"+id+"','"+phone+"','"+email+"');")
       
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