import boto3


def param_get(param_name):
    # Create a client for the SSM service
    ssm = boto3.client('ssm')

    # Get the value of the parameter
    return = ssm.get_parameter(
        Name=param_name
    )


db_config = {
    "db_type": "postgresql+psycopg2",
    "db_username": "postgres",
    "db_pass": "postgres-fin",
    "db_host": "db-finance1.cxhmztea6vcv.us-east-1.rds.amazonaws.com",
    "db_file": "finance"
}

API_KEY = param_get('API_KEY')

db_config_test = {
    "db_type": "sqlite",
    "db_username": None,
    "db_pass": None,
    "db_host": None,
    "db_file": "finance.db"
}
