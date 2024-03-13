"""
TODO:
- Prevent users from following themselves (added to GitHuB repo issues) 
- Prevent users from following users they already follow (added to GitHuB repo issues)
"""

from flask import Blueprint, render_template, request, redirect
from flask_mysqldb import MySQL
from datetime import date

mysql = MySQL()

followers_page = Blueprint('followers', __name__, url_prefix='/followers')

# Reads database, allows creation of new follower relationship(s)
@followers_page.route('/', methods=["POST", "GET"])
def followers():  
    if request.method == "GET":
        query1 = """
                SELECT 
                    f.userRelationshipID,
                    u1.username AS followeeUsername,
                    f.followeeID,
                    f.followerID,
                    u2.username AS followerUsername,
                    f.followedSince
                FROM 
                    followers f
                JOIN 
                    users u1 ON f.followeeID = u1.userID
                JOIN 
                    users u2 ON f.followerID = u2.userID
                """
        
        cur = mysql.connection.cursor()
        cur.execute(query1)
        data = cur.fetchall()

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
        userdata = cur.fetchall()
        
        current_date = date.today().isoformat()
        
        return render_template("followers.jinja2", followers=data, userdata=userdata, page_title = "Followers", current_date = current_date)
    
    elif request.method == "POST":
        followeeID = request.form["followeeID"]
        followerID = request.form["followerID"]
        followedSince = request.form["followedSince"]

        query = """INSERT INTO followers (
                followeeID, 
                followerID, 
                followedSince)
                VALUES (%s, %s, %s)
                """

        cur = mysql.connection.cursor()

        values = (followeeID, followerID, followedSince)

        cur.execute(query, values)

        mysql.connection.commit()
    
    return redirect("/followers")

# Deletes relationship between two users
@followers_page.route('/followers_delete/<int:userRelationshipID>')
def followers_delete(userRelationshipID: int):

    query = "DELETE FROM followers WHERE userRelationshipID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (userRelationshipID,))
    mysql.connection.commit()
    
    return redirect('/followers')