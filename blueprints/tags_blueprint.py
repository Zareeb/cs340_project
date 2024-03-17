"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from flask import Blueprint, render_template, request, redirect
from flask_mysqldb import MySQL
from datetime import date

mysql = MySQL()

tags_page = Blueprint('likes', __name__, url_prefix='/likes')

#
#
#
@tags_page.route('/', methods=["POST", "GET"])
def likes():  
    if request.method == "GET":
        query1 = """
                SELECT
                    p.postTagID,
                    p.tagID,
                    t.tag,
                    p.postID,
                    p.dateTagged
                FROM
                    postsHasTags AS p
                JOIN 
                    tags AS t ON p.tagID = t.tagID
                JOIN 
                    posts ON p.postID = posts.postID
                """
                
        cur = mysql.connection.cursor()
        cur.execute(query1)
        tags_data = cur.fetchall()
        
        # Gets users data
        query2 = """
                SELECT 
                    userID, 
                    username 
                FROM
                    users
                ORDER BY
                    username
                """
        
        cur = mysql.connection.cursor()
        cur.execute(query2)
        user_data = cur.fetchall()

        # Gets posts data
        query3 = """
                SELECT 
                    postID 
                FROM 
                    posts 
                ORDER BY 
                    postID
                """
        
        cur = mysql.connection.cursor()
        cur.execute(query3)
        posts_data = cur.fetchall()
        
        current_date = date.today().isoformat()
        
        return render_template("tags.jinja2", tags = tags_data, users = user_data, posts = posts_data, page_title = "Tags", current_date = current_date)
    
    elif request.method == "POST":
        postID = request.form["postID"]
        likedByUserID = request.form["likedByUserID"]
        dateLiked = request.form["dateLiked"]

        query = """INSERT INTO likes (
                postID, 
                likedByUserID, 
                dateLiked)
                VALUES (%s, %s, %s)
                """

        cur = mysql.connection.cursor()

        values = (postID, likedByUserID, dateLiked)

        cur.execute(query, values)

        mysql.connection.commit()
    
    return redirect("/likes")

# Deletes relationship between two users
@tags_page.route('/likes_delete/<int:likeID>')
def tags_delete(likeID: int):

    query = "DELETE FROM likes WHERE likeID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (likeID,))
    mysql.connection.commit()
    
    return redirect('/likes')