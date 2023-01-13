from etc.config import db_config
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

for item in db_config:
    exec('{KEY} = {VALUE}'.format(KEY = item, VALUE = repr(db_config[item])))

print (db_username)
print (db_file)

db_url = URL.create(db_type, database = db_file, username = db_username, password = db_pass, host = db_host)
print(db_url)
# Configure SQLALchemy instead
engine = create_engine(db_url)
print(engine)

with engine.begin() as db:
    id = "1"
    assets = db.execute(text("SELECT symbol, amount FROM assets WHERE user_id= :id"), {"id": id}).all()
    #print(assets.all())
    for row in assets:
        print(row["symbol"])
        print(row["amount"])
