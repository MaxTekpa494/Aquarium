import psycopg2
import psycopg2.extras


def connect():
  conn = psycopg2.connect(
    dbname = 'max.tekpa_db',
    host = 'sqletud.u-pem.fr',
    password = 'Flora93?',
    cursor_factory = psycopg2.extras.NamedTupleCursor
  )
  conn.autocommit = True
  return conn
