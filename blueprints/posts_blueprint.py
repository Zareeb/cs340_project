from flask import Blueprint, render_template, request, redirect
from flask_mysqldb import MySQL
import sys

mysql = MySQL()

posts_page = Blueprint('posts', __name__, url_prefix='/posts')

# Reads database, allows creation of new post(s)
@posts_page.route('/', methods=["POST", "GET"])
def posts():   

    if request.method == "GET":
        query1 = """SELECT p.postID,
                CONCAT(u.userID, '-', u.username) AS 'userID-username',
                p.postDate,
                p.postBody
                FROM posts p
                JOIN users u ON p.userID = u.userID;
                """
        
        cur = mysql.connection.cursor()
        cur.execute(query1)
        data = cur.fetchall()
        # print(data, file=sys.stderr )

        query2 = "SELECT userID, CONCAT(userID, '-', username) AS 'userID-username' FROM users"

        cur = mysql.connection.cursor()
        cur.execute(query2)
        userdata = cur.fetchall()

        return render_template("posts.jinja2", posts=data, userdata=userdata, page_title = "Posts")
    
    elif request.method == "POST":
        userID = request.form["userID"]
        postDate = request.form["postDate"]
        postBody = request.form["postBody"]

        query = """INSERT INTO posts (
                userID, 
                postDate, 
                postBody)
                VALUES (%s, %s, %s)
                """

        cur = mysql.connection.cursor()

        values = (userID, postDate, postBody)

        cur.execute(query, values)

        mysql.connection.commit()
    
    return redirect("/posts")

# Deletes a user's post
@posts_page.route('/posts_delete/<int:postID>')
def posts_delete(postID: int):

    query = "DELETE FROM posts WHERE postID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (postID,))
    mysql.connection.commit()
    
    return redirect('/posts')

# Edits a user's post
@posts_page.route('posts_edit/<int:postID>', methods=["POST", "GET"])
def posts_edit(postID: int):
    
    if request.method == "GET":
        query1 = """SELECT p.postID, 
                p.userID,
                CONCAT(u.userID, '-', u.username) AS 'userID-username',
                p.postDate,
                p.postBody
                FROM posts p
                JOIN users u ON p.userID = u.userID
                WHERE postID = %s
                """ % (postID)
        cur = mysql.connection.cursor()
        cur.execute(query1)
        data = cur.fetchall()

        return render_template("posts_edit.jinja2", posts=data, page_title = "Edit posts")

    if request.method == "POST":
        postID = request.form["postID"]
        userID = request.form["userID"]
        postDate = request.form["postDate"]
        postBody = request.form["postBody"]

        query = """UPDATE posts SET 
                userID = %s,
                postDate = %s,
                postBody = %s
                WHERE postID = %s                
                """
        
        cur = mysql.connection.cursor()
        values = (userID, postDate, postBody, postID)
        cur.execute(query, values)
        mysql.connection.commit()

        return redirect('/posts')