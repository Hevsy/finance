from distutils.command.config import config
import os
import psycopg2

# from cs50 import SQL
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL
from flask import Flask, redirect, render_template, request, session
from flask_session import Session
from werkzeug.security import check_password_hash, generate_password_hash

from helpers import apology, login_required, lookup, usd

# Configure application
app = Flask(__name__)

# Ensure templates are auto-reloaded
app.config["TEMPLATES_AUTO_RELOAD"] = True

# Custom filter
app.jinja_env.filters["usd"] = usd

# Configure session to use filesystem (instead of signed cookies)
app.config["SESSION_PERMANENT"] = False
app.config["SESSION_TYPE"] = "filesystem"
Session(app)

# import db config from etc/config
from etc.config import db_config
db_type = None
db_file = None
db_username = None
db_pass = None 
db_host = None
# Assign variables from db_config
for item in db_config:
    exec('{KEY} = {VALUE}'.format(KEY = item, VALUE = repr(db_config[item])))
# Create db URL & engine
db_url = URL.create(db_type, database = db_file, username = db_username, password = db_pass, host = db_host)
print (db_url)

engine = create_engine(db_url)

print(engine)

username = "Paul"
password = "123"

confirmation = "123"
if not username or not password or not confirmation:
   print("Must provide username and password!")
elif password != confirmation:
    print("Passwords do not match!")

# Check if username already exists
with engine.begin() as db:
    result = db.execute(text('SELECT id FROM users WHERE username = :u'),
                           {'u': username})
    print (result.rowcount)
    if result.rowcount > 0:
        # return apology("Username already exists")
        print ("Exists")
    else:
        print ("Nope!")


    
