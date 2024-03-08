"""

Authors: Marina Hampton & Zareeb Lorenzana
Modified from OSU Flask starter app on GitHub
Date: 02.29.2024
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from flask import Flask, render_template
from flask_mysqldb import MySQL
from credentials import *
from blueprints.users_blueprint import users_page
from blueprints.posts_blueprint import posts_page

app = Flask(__name__)

mysql = MySQL(app)

# database connection info
app.config["MYSQL_HOST"] = MYSQL_HOST
app.config["MYSQL_USER"] = MYSQL_USER
app.config["MYSQL_PASSWORD"] = MYSQL_PASSWORD
app.config["MYSQL_DB"] = MYSQL_DB
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

# Register blueprints
app.register_blueprint(users_page, url_prefix='/users')
app.register_blueprint(posts_page, url_prefix='/posts')

# Routes 

@app.route('/')
def root():
    return render_template("main.jinja2", page_title = "Home")

# @app.route('/users', methods=["POST", "GET"])
# def users():   

#     if request.method == "GET":
#         query = "SELECT * FROM users"

#         cur = mysql.connection.cursor()
#         cur.execute(query)
#         data = cur.fetchall()

#         return render_template("users.jinja2", users=data, page_title = "users")
    
#     elif request.method == "POST":
#         username = request.form["username"]
#         firstName = request.form["firstName"]
#         lastName = request.form["lastName"]
#         email = request.form["email"]
#         phoneNumber = request.form["phoneNumber"]
#         signupDate = request.form["signupDate"]

#         query = """INSERT INTO users (
#                 username, 
#                 firstName, 
#                 lastName, 
#                 email, 
#                 phoneNumber, 
#                 signupDate) 
#                 VALUES (%s, %s, %s, %s, %s, %s)
#                 """

#         cur = mysql.connection.cursor()

#         values = (username, firstName, lastName, email, phoneNumber, signupDate)

#         cur.execute(query, values)

#         mysql.connection.commit()
    
#     return redirect("/users")

# @app.route('/delete_users/<int:userID>')
# def users_delete(userID: int):

#     query = "DELETE FROM users WHERE userID = %s"

#     cur = mysql.connection.cursor()

#     cur.execute(query, (userID,))

#     mysql.connection.commit()

#     return redirect('/users')

# @app.route('/users_edit/<int:userID>', methods=["POST", "GET"])
# def users_edit(userID: int):

#     if request.method == "GET":
#         query = "SELECT * FROM users WHERE userID = %s" % (userID)
        
#         cur = mysql.connection.cursor()

#         cur.execute(query)

#         data = cur.fetchall()

#         return render_template("users_edit.jinja2", data=data, page_title = "Edit users")

#     if request.method == "POST":
#         userID = request.form["userID"]
#         username = request.form["username"]
#         firstName = request.form["firstName"]
#         lastName = request.form["lastName"]
#         email = request.form["email"]
#         phoneNumber = request.form["phoneNumber"]
#         signupDate = request.form["signupDate"]

#         query = """UPDATE users SET 
#                 username = %s,
#                 firstName = %s,
#                 lastName = %s,
#                 email = %s,
#                 phoneNumber = %s,
#                 signupDate = %s
#                 WHERE userID = %s                
#                 """
        
#         cur = mysql.connection.cursor()

#         values = (username, firstName, lastName, email, phoneNumber, signupDate, userID)

#         cur.execute(query, values)

#         mysql.connection.commit()

#     return redirect('/users')

# @app.route('/posts', methods=["POST", "GET"])
# def posts():
#     if request.method == "GET":
#         query = "SELECT * FROM posts"

#         cur = mysql.connection.cursor()
#         cur.execute(query)
#         data = cur.fetchall()

#         return render_template("posts.jinja2", posts=data, page_title = "posts")
    
#     elif request.method == "POST":
#         userID = request.form["userID"]
#         postDate = request.form["postDate"]
#         postBody = request.form["postBody"]

#         query = """INSERT INTO posts (
#                 userID, 
#                 postDate, 
#                 postBody) 
#                 VALUES (%s, %s, %s)
#                 """

#         cur = mysql.connection.cursor()

#         values = (userID, postDate, postBody)

#         cur.execute(query, values)

#         mysql.connection.commit()
    
#     return redirect("/posts")


# @app.route('/followers')
# def followers():    

#     return render_template("followers.jinja2", page_title="followers")

# @app.route('/likes')
# def likes():    

#     return render_template("likes.jinja2", page_title="likes")

# @app.route('/tags')
# def tags():    

#     return render_template("tags.jinja2", page_title="tags")

# Listener



if __name__ == "__main__":
    
    app.run(port=3793, debug=True)