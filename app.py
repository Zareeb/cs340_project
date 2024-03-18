"""

Authors: Marina Hampton, Zareeb Lorenzana, & Skyler Santos
Date: 03.18.2024

Modified from OSU Flask starter app on GitHub
Source URL: https://github.com/osu-cs340-ecampus/flask-starter-app

"""

from flask import Flask, render_template, redirect, request
from flask_mysqldb import MySQL
import subprocess
import os
from credentials import *

# Import blueprints
from blueprints.users_blueprint import users_page
from blueprints.posts_blueprint import posts_page
from blueprints.followers_blueprint import followers_page
from blueprints.likes_blueprint import likes_page
from blueprints.tags_blueprint import tags_page

app = Flask(__name__)

mysql = MySQL(app)

# Imported from credentials.py
app.config["MYSQL_HOST"] = MYSQL_HOST
app.config["MYSQL_USER"] = MYSQL_USER
app.config["MYSQL_PASSWORD"] = MYSQL_PASSWORD
app.config["MYSQL_DB"] = MYSQL_DB
app.config["MYSQL_CURSORCLASS"] = "DictCursor"

# Registers blueprints
app.register_blueprint(users_page, url_prefix='/users')
app.register_blueprint(posts_page, url_prefix='/posts')
app.register_blueprint(followers_page, url_prefix='/followers')
app.register_blueprint(likes_page, url_prefix='/likes')
app.register_blueprint(tags_page, url_prefix='/tags')

# Routes 
@app.route('/')
def root():
    return render_template("main.jinja2", page_title = "Home")

@app.route('/reset')
def reset_database():
    """
    Resets database based on /src/db/sql/DDL.sql file
    """
    # Get working directory
    get_wd = os.getcwd()
    
    # Calls mysql and executes source to reset database
    
    mysql_string = f"mysql -u {MYSQL_USER} -h {MYSQL_HOST} --password={MYSQL_PASSWORD} {MYSQL_DB} -e \"source {get_wd}/src/db/sql/DDL.sql\""
    subprocess.run(mysql_string, shell=True)

    return redirect(request.referrer)

if __name__ == "__main__":
    
    app.run(port=3793, debug=True)