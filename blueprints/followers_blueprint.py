"""
TODO:
- Better frontend to enforce uniqueness?
"""

"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from imports import *

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
        try:
            followeeID = request.form["followeeID"]
            followerID = request.form["followerID"]
            followedSince = request.form["followedSince"]
            
            if followeeID == followerID:
                warning = "You cannot follow yourself."
                raise IntegrityError
            else:
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
        
        except IntegrityError as e:
            if "Duplicate entry" in str(e):
                warning = "You are already following that user."
                
            return render_template("error.jinja2", warning=warning)

    return redirect("/followers")

# Deletes relationship between two users
@followers_page.route('/followers_delete/<int:userRelationshipID>')
def followers_delete(userRelationshipID: int):

    query = "DELETE FROM followers WHERE userRelationshipID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (userRelationshipID,))
    mysql.connection.commit()
    
    return redirect('/followers')