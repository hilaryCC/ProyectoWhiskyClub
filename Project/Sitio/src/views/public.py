from .libraries import *
from .authentication import *

@app.route("/", methods=["GET", "POST"])
def index():
    if request.method=="POST":
        user = request.form["usuario"]
        password = request.form["contrasenna"]
        login = consultaBaseDatos("SignIn '"+user+"','"+password+"'")[0][0]
       
        if(login==1):
            
            session["mensaje"] = "Log In Succesfull"
            return render_template("paises.html",auth = obtener_auth())
        else:   
            session["mensaje"] = "Unvalid User"
            

    
    return render_template(
        "index.html",
        auth = obtener_auth()
    )



@app.route("/registro", methods=["GET", "POST"])
def registro():
    if request.method=="POST":
        name = request.form["name"]
        adress= request.form["adress"]
        id = request.form["ident"]
        phone = request.form["phone"]
        email = request.form["email"]
        user = request.form["user"]
        password = request.form["password"]
       
        consultaBaseDatosUsersMysql("Call InsertClient("+name+"','"+adress+"','"+id+"','"+phone+"','"+email+"');")
       
        return render_template(
        "index.html",
        auth = obtener_auth()
    )
    session["mensaje"] = "Account Succesfully Created!"
    return render_template(
        "registro.html",
        auth = obtener_auth()
    )