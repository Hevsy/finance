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
db_port = None
# Assign variables from db_config
for item in db_config:
    exec('{KEY} = {VALUE}'.format(KEY = item, VALUE = repr(db_config[item])))
# Create db URL & engine
db_url = URL.create(db_type, database = db_file, username = db_username, password = db_pass, host = db_port)

engine = create_engine(db_url)

# Hardcoded API key into config
# Make sure API key is set
# if not os.environ.get("API_KEY"):
#    raise RuntimeError("API_KEY not set")


@app.after_request
def after_request(response):
    """Ensure responses aren't cached"""
    response.headers["Cache-Control"] = "no-cache, no-store, must-revalidate"
    response.headers["Expires"] = 0
    response.headers["Pragma"] = "no-cache"
    return response


@app.route("/")
@login_required
def index():
    """Show portfolio of stocks"""
    with engine.begin() as db:
        assets = db.execute(text(
            "SELECT symbol, amount FROM assets WHERE user_id= :id"), {"id": session["user_id"]}).all()
        # initalise the counter and portfolio
        portfolio = []
        grand_total = 0
        for row in assets:
            lookup_data = lookup(row["symbol"])
            amount = int(row["amount"])
            symbol_total = float(lookup_data["price"]) * amount
            grand_total += symbol_total
            portfolio.append({"symbol": lookup_data['symbol'], "name": lookup_data['name'], "price": usd(
                lookup_data['price']), "amount": amount, 'total': usd(symbol_total)})
        cash = float(db.execute(text("SELECT cash FROM users WHERE id = :id"),
                                {"id": session["user_id"]}).all()[0]["cash"])
        grand_total += cash
        return render_template("index.html", portfolio=portfolio, cash=usd(cash), grand_total=usd(grand_total))


@ app.route("/buy", methods=["GET", "POST"])
@ login_required
def buy():
    """Buy shares of stock"""
    if request.method == "GET":
        return render_template("/buy.html")
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if not request.form.get("shares").isdigit():
            return apology("Ivalid share amount")
        shares = int(request.form.get("shares"))
        if shares < 1:
            return apology("Amount of shares must be a positive number!")
        quote = lookup(symbol)
        if not symbol or not quote:
            return apology("Must provide a valid stock symbol")

        # Check how much cash on the users account and whether it's enough
        with engine.begin() as db:
            cash = float(db.execute(text(
                "SELECT cash FROM users WHERE id = :id"), {"id": session["user_id"]}).all()[0]["cash"])
            ppu = float(quote["price"])
            # Debugging: print (cash, shares, shares*float(quote["price"]))
            if shares*ppu > cash:
                return apology("Insufficient funds for this operation")

            # add transaction
            db.execute(text("INSERT INTO transactions (user_id, datetime, symbol, amount, ppu) VALUES (:id, datetime('now'), :sy, :am, :ppu)"),
                       {"id": session["user_id"], "sy": symbol, "am": shares, "ppu": ppu})

            # add asset
            # !!!! this will create duplicate rows for same assets - need to check for existing asset and update if required!!!
            a = db.execute(text(
                "SELECT amount FROM assets WHERE user_id = :id AND symbol=:sy"), {"id": session["user_id"], "sy": symbol}).all()
            if not a:
                db.execute(text("INSERT INTO assets (user_id, symbol, amount) VALUES (:id, :sy, :am)"),
                           {"id": session["user_id"], "sy": symbol, "am": shares})
            else:
                a = int(a[0]['amount']) + shares
                db.execute(text("UPDATE assets SET amount = :am WHERE symbol = :sy AND user_id = :id"),
                           {"id": session["user_id"], "sy": symbol, "am": shares})
            # subtract cash
            db.execute(text("UPDATE users SET cash = :c WHERE id = :id"),
                       {"c": cash-shares*ppu, "id": session["user_id"]})
            # redirect to main page when everything was done
            return redirect("/")


@ app.route("/history")
@ login_required
def history():
    """Show history of transactions"""
    with engine.begin() as db:
        history = db.execute(text(
            "SELECT symbol, amount, ppu, datetime FROM transactions WHERE user_id = :id"), {"id": session["user_id"]}).all()
        # print(history)
        return render_template("history.html", history=history)


@ app.route("/login", methods=["GET", "POST"])
def login():
    """Log user in"""

    # Forget any user_id
    session.clear()

    # User reached route via POST (as by submitting a form via POST)
    if request.method == "POST":

        # Ensure username was submitted
        if not request.form.get("username"):
            return apology("must provide username", 403)

        # Ensure password was submitted
        elif not request.form.get("password"):
            return apology("must provide password", 403)

        # Query database for username
        with engine.begin() as db:
            rows = db.execute(text("SELECT id, hash FROM users WHERE username = :u"),
                              {"u": request.form.get("username")}).all()
            # Ensure username exists and password is correct
            if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
                return apology("invalid username and/or password", 403)

            # Remember which user has logged in
            session["user_id"] = rows[0]["id"]

            # Redirect user to home page
            return redirect("/")

    # User reached route via GET (as by clicking a link or via redirect)
    else:
        return render_template("login.html")


@ app.route("/logout")
def logout():
    """Log user out"""

    # Forget any user_id
    session.clear()

    # Redirect user to login form
    return redirect("/")


@ app.route("/quote", methods=["GET", "POST"])
@ login_required
def quote():
    """Get stock quote."""
    if request.method == "GET":
        return render_template("quote.html")
    else:
        symbol = request.form.get("symbol")
        quote = lookup(symbol)
        if not quote:
            return apology("Must provide a valid stock symbol")
        quote.update({"price": usd(quote["price"])})
        return render_template("quoted.html", quote=quote)


@ app.route("/register", methods=["GET", "POST"])
def register():
    """Register user"""
    if request.method == "GET":
        return render_template("register.html")
    else:
        username = request.form.get("username")
        password = request.form.get("password")
        confirmation = request.form.get("confirmation")
        if not username or not password or not confirmation:
            return apology("Must provide username and password!")
        elif password != confirmation:
            return apology("Passwords do not match!")

        # Check if username already exists
        with engine.begin() as db:
            try:
                db.execute(text("SELECT id FROM users WHERE username = :u"),
                           {"u": request.form.get("username")}).one()
            except:
                return apology("Username already exists")
            hash = generate_password_hash(password)
            db.execute(text(
                "INSERT INTO users (username, hash) VALUES (:u, :h)"), {"u": username, "h": hash})
            return redirect("/login")


@ app.route("/sell", methods=["GET", "POST"])
@ login_required
def sell():
    """Sell shares of stock"""
    if request.method == "GET":
        with engine.begin() as db:
            assets = db.execute(text(
                "SELECT symbol FROM assets WHERE user_id= :id"), {"id": session["user_id"]}).all()
            return render_template("/sell.html", symbols=[row["symbol"] for row in assets])
    if request.method == "POST":
        symbol = request.form.get("symbol")
        if not request.form.get("shares").isdigit():
            return apology("Ivalid share amount")
        shares = int(request.form.get("shares"))
        if shares < 1:
            return apology("Amount of shares must be a positive number!")

        # Check how much shares user have
        with engine.begin() as db:
            a = db.execute(text(
                "SELECT amount FROM assets WHERE user_id = :id AND symbol=:sy"), {"id": session["user_id"], "sy": symbol}).all()
            if not a:
                return apology("You don't own these shares")

            # Check if user owns enough shares
            a = int(a[0]['amount'])
            if (a < shares):
                return apology("Not enough shares for this operation")

            # Check how much cash on the users account and the price of the shares
            quote = lookup(symbol)
            if not symbol or not quote:
                return apology("Invalid stock symbol")
            cash = float(db.execute(text(
                "SELECT cash FROM users WHERE id = :id"), {"id": session["user_id"]}).all()[0]["cash"])
            ppu = float(quote["price"])

            # add transaction
            db.execute(text("INSERT INTO transactions (user_id, datetime, symbol, amount, ppu) VALUES (:id, datetime('now'), :sy, :am, :ppu)"),
                       {"id": session["user_id"], "sy": symbol, "am": -shares, "ppu": ppu})

            #  update asset list
            if (a-shares == 0):
                db.execute(text("DELETE FROM assets WHERE symbol = :sy AND user_id = :id"), {
                           "sy": symbol, "id": session["user_id"]})
            else:
                db.execute(text("UPDATE assets SET amount = :am WHERE symbol = :sy AND user_id = :id"),
                       {"am": a - shares, "sy": symbol, "id": session["user_id"]})
            # add cash
            db.execute(text("UPDATE users SET cash = :c WHERE id = :id"),
                       {"c": cash + shares * ppu, "id": session["user_id"]})
            # redirect to main page when everything was done
            return redirect("/")


@ app.route("/pwdchange", methods=["GET", "POST"])
def pwdchange():
    """Change user's password"""
    if request.method == "GET":
        return render_template("pwdchange.html")
    else:
        with engine.begin() as db:
            hash = db.execute(text("SELECT hash FROM users WHERE id = :id"),
                              {"id": session["user_id"]}).all()[0]['hash']
            old_password = request.form.get("old_password")
            new_password = request.form.get("new_password")
            confirmation = request.form.get("confirmation")
            if not old_password or not new_password or not confirmation:
                return apology("Must provide old and new passwords", 403)
            elif not check_password_hash(hash, old_password):
                return apology("Invalid password", 403)
            elif new_password != confirmation:
                return apology("Passwords do not match!", 403)
            new_hash = generate_password_hash(new_password)
            db.execute(text(
                "UPDATE users SET hash = :h WHERE id = :id"), {"h": new_hash, "id": session["user_id"]})
            return redirect("/")
