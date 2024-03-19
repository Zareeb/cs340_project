"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

Implements Create, Read, and Delete operations

"""

from imports import *

mysql = MySQL()

tags_page = Blueprint('tags', __name__, url_prefix='/tags')

# Reads tags database and allows creation of new tags
@tags_page.route('/', methods=["POST", "GET"])
def tags():
    
    # Read operation
    if request.method == "GET":
        query1 = """
                SELECT * FROM tags
                """
                
        cur = mysql.connection.cursor()
        cur.execute(query1)
        tags_data = cur.fetchall()
        
        current_date = date.today().isoformat()
        
        return render_template("tags.jinja2", tags = tags_data, page_title = "Tags", current_date = current_date)
    
    # Insert operation
    elif request.method == "POST":
        tag = request.form["tag"]

        query = """
                INSERT INTO tags (tag)
                VALUES (%s)
                """
        
        # Catches exception from duplicate entries        
        try:
            cur = mysql.connection.cursor()
            values = (tag,)
            cur.execute(query, values)
            mysql.connection.commit()
            
            
        except IntegrityError as e:
            return render_template("error.jinja2", warning="Tag already exists in database.")
    
    return redirect("/tags")

# Deletes an entry from tags table
@tags_page.route('/tags_delete/<int:tagID>')
def tags_delete(tagID: int):

    query = "DELETE FROM tags WHERE tagID = %s"
    cur = mysql.connection.cursor()
    cur.execute(query, (tagID,))
    mysql.connection.commit()
    
    return redirect('/tags')