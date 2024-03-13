from flask import Blueprint, render_template, request, redirect
from flask_mysqldb import MySQL
from datetime import date

mysql = MySQL()

users_page = Blueprint('users', __name__, url_prefix='/users')

# Reads database, allows creation of new user(s)
@users_page.route('/', methods=["POST", "GET"])
def users():   

    if request.method == "GET":
        query = "SELECT * FROM users"

        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        current_date = date.today().isoformat()

        return render_template("users.jinja2", users = data, page_title = "Users", current_date = current_date)
    
    elif request.method == "POST":
        username = request.form["username"]
        firstName = request.form["firstName"]
        lastName = request.form["lastName"]
        email = request.form["email"]
        phoneNumber = request.form["phoneNumber"]
        signupDate = request.form["signupDate"]

        query = """INSERT INTO users (
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

# Deletes user from database
@users_page.route('/users_delete/<int:userID>')
def users_delete(userID: int):
    query = "DELETE FROM users WHERE userID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (userID,))
    mysql.connection.commit()

    return redirect('/users')

# Edits user entry
@users_page.route('/users_edit/<int:userID>', methods=["POST", "GET"])
def users_edit(userID: int):

    if request.method == "GET":
        query = "SELECT * FROM users WHERE userID = %s" % (userID)
        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        return render_template("users_edit.jinja2", users=data, page_title = "Edit users")

    if request.method == "POST":
        userID = request.form["userID"]
        username = request.form["username"]
        firstName = request.form["firstName"]
        lastName = request.form["lastName"]
        email = request.form["email"]
        phoneNumber = request.form["phoneNumber"]
        signupDate = request.form["signupDate"]

        query = """UPDATE users SET 
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