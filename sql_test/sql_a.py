from sqlalchemy import create_engine, text, select, insert, MetaData
from sqlalchemy.sql.expression import exists

engine = create_engine("sqlite:///finance_copy.db")


with engine.connect() as db:
    id = "1"
    with db.begin():
        assets = db.execute(
            text("SELECT symbol, amount FROM assets WHERE user_id= :id"), {"id": id}).all()
        #print(assets.all())
        for row in assets:
            print(row["symbol"])
            print(row["amount"])
        print(assets)
        print(assets)
        print(assets[0]["symbol"])
        cash = float(db.execute(text("SELECT cash FROM users WHERE id = :id"), {"id": id}).all()[0]["cash"])
        print(cash)
        # cash = float(db.execute(text("SELECT cash FROM users WHERE id = :id"), {"id": id})[0]["cash"])
        print(cash)

with engine.begin() as db:
    username = "Bob"
    try: 
        db.execute(text("SELECT id FROM users WHERE username = :u"), {"u": username}).one()
        print("Username", username, "exists")
    except:
        print("Username", username, "not exists")

with engine.begin() as db:
    username = "Bob"
    try: 
        db.execute(text("SELECT id FROM users WHERE username = :u"), {"u": username}).one()
        print("Username", username, "exists")
    except:
        print("Username", username, "not exists")

with engine.begin() as db:
    username = "Paul"
    rows = db.execute(text("SELECT id, hash FROM users WHERE username = :u"),
                        {"u": username}).all()
    # Ensure username exists and password is correct
    print(len(rows))
    #if len(rows) != 1 or not check_password_hash(rows[0]["hash"], request.form.get("password")):
    #    return apology("invalid username and/or password", 403)

    # Remember which user has logged in
    print(rows[0]["id"])
    