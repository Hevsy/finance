from etc/config.py import config
for item in config:
    exec('{KEY} = {VALUE}'.format(KEY = item, VALUE = repr(config[item])))

print (db_username)
print (db_file)