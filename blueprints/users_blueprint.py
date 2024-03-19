"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

Implements Create, Read, Update, and Delete operations

"""

from imports import *

mysql = MySQL()

users_page = Blueprint('users', __name__, url_prefix='/users')

# Reads users database and allows creation of new user
@users_page.route('/', methods=["POST", "GET"])
def users():   

    # Read operation
    if request.method == "GET":
        query = "SELECT * FROM users"

        cur = mysql.connection.cursor()
        cur.execute(query)
        data = cur.fetchall()
        
        current_date = date.today().isoformat()

        return render_template("users.jinja2", users = data, page_title = "Users", current_date = current_date)
    
    # Insert operation
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

        # Catches exception from duplicate entries
        try:
            cur = mysql.connection.cursor()
            values = (username, firstName, lastName, email, phoneNumber, signupDate)
            cur.execute(query, values)
            mysql.connection.commit()
                
        except IntegrityError as e:
            if "username" in str(e):
                warning = "This username is not available."
                
            elif "email" in str(e):
                warning = "This email is not available."
                
            elif "phoneNumber" in str(e):
                warning = "This phone number is not available"
                
            return render_template("error.jinja2", warning=warning)

    return redirect("/users")

# Deletes an entry from users table
@users_page.route('/users_delete/<int:userID>')
def users_delete(userID: int):
    query = "DELETE FROM users WHERE userID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (userID,))
    mysql.connection.commit()

    return redirect('/users')

# Queries database for specific ID. Edits user entry and allows modification of user information
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

        query = """
                UPDATE 
                    users
                SET 
                    username = %s,
                    firstName = %s,
                    lastName = %s,
                    email = %s,
                    phoneNumber = %s,
                    signupDate = %s
                WHERE
                    userID = %s                
                """
        
        # Catches exception from duplicate entries
        try:
            cur = mysql.connection.cursor()
            values = (username, firstName, lastName, email, phoneNumber, signupDate, userID)
            cur.execute(query, values)
            mysql.connection.commit()
            
        except IntegrityError as e:
            if "username" in str(e):
                warning = "This username is not available."
                
            elif "email" in str(e):
                warning = "This email is not available."
                
            elif "phoneNumber" in str(e):
                warning = "This phone number is not available"
                
            return render_template("error.jinja2", warning=warning)


        return redirect('/users')