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

if __name__ == "__main__":
    
    app.run(port=3793, debug=True)