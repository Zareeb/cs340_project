"""

Modified from OSU Flask starter app on GitHub
Date: 02.29.2024
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from flask import Flask, render_template, json, redirect
from flask_mysqldb import MySQL
from flask import request
import os

app = Flask(__name__)

# Configuration

# database connection info
app.config["MYSQL_HOST"] = "classmysql.engr.oregonstate.edu"
app.config["MYSQL_USER"] = "cs340_lorenzaz"
app.config["MYSQL_PASSWORD"] = "t3k1r7"
app.config["MYSQL_DB"] = "cs340_lorenzaz"
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

mysql = MySQL(app)

# Routes 

@app.route('/')
def root():
    return render_template("main.jinja2")

@app.route('/users', methods=["POST", "GET"])
def users():

    if request.method == "GET":
        query = "SELECT * from Users"

        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()

        return render_template("users.jinja2", Users=data)
    
    elif request.method == "POST":
        username = request.form["username"]
        firstName = request.form["firstName"]
        lastName = request.form["lastName"]
        email = request.form["email"]
        phoneNumber = request.form["phoneNumber"]
        signupDate = request.form["signupDate"]

        query = "INSERT INTO Users (username, firstName, lastName, email, phoneNumber, signupDate) VALUES (%s, %s, %s, %s, %s, %s)"

        cur = mysql.connection.cursor()

        values = (username, firstName, lastName, email, phoneNumber, signupDate)

        cur.execute(query, values)

        mysql.connection.commit()
    
    return redirect("/users")


# Listener

if __name__ == "__main__":
    
    app.run(port=3793, debug=True)