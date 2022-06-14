from .libraries import *
from .authentication import *


@app.route("/admin/createSupplier", methods=["GET", "POST"])
def adminCreate():
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
