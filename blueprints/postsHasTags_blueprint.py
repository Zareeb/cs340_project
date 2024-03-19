"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

Implements Create, Read, Update, and Delete operations

"""

from imports import *

mysql = MySQL()

postsHasTags_page = Blueprint('postsHasTags', __name__, url_prefix='/postsHasTags')

# Reads postsHasTags database and allows tagging of existing posts
@postsHasTags_page.route('/', methods=["POST", "GET"])
def postsHasTags():  
    
    # Read operation
    if request.method == "GET":
        query1 = """
                SELECT
                    p.postTagID,
                    p.postID,
                    p.tagID,
                    t.tag,
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
                SELECT * 
                FROM
                    tags
                ORDER BY 
                    tag
                """
                
        cur = mysql.connection.cursor()
        cur.execute(query2)
        tags_data = cur.fetchall()
                
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
        post_data = cur.fetchall()
        
        current_date = date.today().isoformat()
        
        return render_template("postsHasTags.jinja2", postsHasTags = postsHasTags_data, tags = tags_data, posts = post_data, page_title = "postsHasTags", current_date = current_date)
    
    # Insert operation
    elif request.method == "POST":
        tagID = request.form["tagID"]
        postID = request.form["postID"]
        dateTagged = request.form["dateTagged"]

        query = """
                INSERT INTO postsHasTags (
                    postID,
                    tagID,
                    dateTagged)
                VALUES (%s, %s, %s)
                """
                
        # Catches exception from duplicate entries        
        try:
            cur = mysql.connection.cursor()
            values = (postID, tagID, dateTagged)
            cur.execute(query, values)
            mysql.connection.commit()
            
        except IntegrityError as e:
            return render_template("error.jinja2", warning="Tags must be unique to a post.")
    
    return redirect("/postsHasTags")

# Deletes an entry from postsHasTags table
@postsHasTags_page.route('/postsHasTags_delete/<int:postTagID>')
def postsHasTags_delete(postTagID: int):

    query = "DELETE FROM postsHasTags WHERE postTagID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (postTagID,))
    mysql.connection.commit()
    
    return redirect('/postsHasTags')

# Queries database for specific ID. Edits postsHasTags entry and allows association of existing post with a different tag
@postsHasTags_page.route('postsHasTags_edit/<int:postTagID>', methods=["POST", "GET"])
def postsHasTags_edit(postTagID: int):
    
    if request.method == "GET":
        query1 = """
                SELECT
                    p.postTagID,
                    p.postID,
                    p.tagID,
                    t.tag,
                    p.dateTagged
                FROM
                    postsHasTags AS p
                JOIN 
                    tags AS t ON p.tagID = t.tagID
                JOIN 
                    posts ON p.postID = posts.postID
                WHERE
                    postTagID = %s
                """ % (postTagID)
        
        query2 = """
                SELECT *
                FROM
                    tags
                """
                
        cur = mysql.connection.cursor()
        cur.execute(query1)
        postsHasTags_data = cur.fetchall()

        cur.execute(query2)
        tags_data = cur.fetchall()    
        
        return render_template("postsHasTags_edit.jinja2", postsHasTags=postsHasTags_data, tags=tags_data, page_title = "Edit Post's Tags")
    
    if request.method == "POST":
        postTagID = request.form["postTagID"]
        postID = request.form["postID"]
        tagID = request.form["tagID"]
        dateTagged = request.form["dateTagged"]
        
        query2 = """
                UPDATE
                    postsHasTags
                SET
                    postID = %s,
                    tagID = %s,
                    dateTagged = %s
                WHERE
                    postTagID = %s
                """
        # Catches exception from duplicate entries        
        try:
            cur = mysql.connection.cursor()
            values = (postID, tagID, dateTagged, postTagID)
            cur.execute(query2, values)
            mysql.connection.commit()
            
        except IntegrityError as e:
            return render_template("error.jinja2", warning="Post is already tagged with selected tag.")
        
        return redirect('/postsHasTags')
    
