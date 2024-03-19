"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from imports import *

mysql = MySQL()

tags_page = Blueprint('tags', __name__, url_prefix='/tags')

@tags_page.route('/', methods=["POST", "GET"])
def tags():  
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
        postsHasTags_data = cur.fetchall()
        
        query2 = """
                SELECT * from tags
                ORDER BY tag
                """
                
        cur = mysql.connection.cursor()
        cur.execute(query2)
        tags_data = cur.fetchall()
        
        current_date = date.today().isoformat()
        
        return render_template("tags.jinja2", postsHasTags = postsHasTags_data, tags = tags_data, page_title = "Tags", current_date = current_date)
    
    elif request.method == "POST":
        postTagID = request.form["postTagID"]
        tagID = request.form["tagID"]
        postID = request.form["postID"]
        dateTagged = request.form["dateTagged"]

        query = """INSERT INTO postHasTags (
                postTagID, 
                tagID, 
                postID,
                dateTagged)
                VALUES (%s, %s, %s, %s)
                """

        cur = mysql.connection.cursor()

        values = (postTagID, tagID, postID, dateTagged)
        cur.execute(query, values)
        mysql.connection.commit()
    
    return redirect("/tags")

@tags_page.route('/tags_delete/<int:postTagID>')
def tags_delete(postTagID: int):

    query = "DELETE FROM postsHasTags WHERE postTagID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (postTagID,))
    mysql.connection.commit()
    
    return redirect('/tags')