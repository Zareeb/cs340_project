"""

Authors: Marina Hampton & Zareeb Lorenzana
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
        query = "SELECT * FROM Users"

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

        query = """INSERT INTO Users (
                username, 
                firstName, 
                lastName, 
                email, 
                phoneNumber, 
                signupDate) 
                VALUES (%s, %s, %s, %s, %s, %s)
                """

        cur = mysql.connection.cursor()

        values = (username, firstName, lastName, email, phoneNumber, signupDate)

        cur.execute(query, values)

        mysql.connection.commit()
    
    return redirect("/users")

@app.route('/delete_users/<int:userID>')
def delete_users(userID: int):

    query = "DELETE FROM Users WHERE userID = %s"

    cur = mysql.connection.cursor()

    cur.execute(query, (userID,))

    mysql.connection.commit()

    return redirect('/users')

@app.route('/users_edit/<int:userID>', methods=["POST", "GET"])
def users_edit(userID: int):
    if request.method == "GET":
        query = "SELECT * FROM Users WHERE userID = %s" % (userID)
        
        cur = mysql.connection.cursor()

        cur.execute(query)

        data = cur.fetchall()

        return render_template("users_edit.jinja2", data=data)
        # return json.dumps(data)
        
    if request.method == "POST":
        userID = request.form["userID"]
        username = request.form["username"]
        firstName = request.form["firstName"]
        lastName = request.form["lastName"]
        email = request.form["email"]
        phoneNumber = request.form["phoneNumber"]
        signupDate = request.form["signupDate"]

        query = """UPDATE Users SET 
                username = %s,
                firstName = %s,
                lastName = %s,
                email = %s,
                phoneNumber = %s,
                signupDate = %s
                WHERE userID = %s                
                """
        
        cur = mysql.connection.cursor()

        values = (username, firstName, lastName, email, phoneNumber, signupDate, userID)

        cur.execute(query, values)

        mysql.connection.commit()

    return redirect('/users')

@app.route('/posts')
def posts():
    return render_template("posts.jinja2")

@app.route('/followers')
def followers():
    return render_template("followers.jinja2")

@app.route('/likes')
def likes():
    return render_template("likes.jinja2")

@app.route('/tags')
def tags():
    return render_template("tags.jinja2")

# Listener

if __name__ == "__main__":
    
    app.run(port=3792, debug=True)