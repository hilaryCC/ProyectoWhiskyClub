from .libraries import *
from flask import render_template, request, session, redirect, url_for

def loggedInUser():
    return "usuario" in session and session["user"] and type(session["user"])==type(0)

def loggedInClient():
    return loggedInUser() and not ("isAdmin" in session and session["isAdmin"])

def loggedInAdmin():
    return loggedInUser() and "isAdmin" in session and session["isAdmin"]

def getMessage():
    message = "" if "message" not in session else session["message"]
    session["message"] = ""
    return message

@app.route("/logOut")
def logOut():
    session["identification"] = 0
    session["message"] = "Logged out"
    return redirect(url_for(".index"))


def get_auth():
    return {
        "clientLogged": loggedInClient(),
        "adminLogged": loggedInAdmin(),
        "message": getMessage()
    }