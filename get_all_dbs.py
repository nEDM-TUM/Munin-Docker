import urllib.request
import json
import os


list_of_dbs = json.loads(
  urllib.request.urlopen(
    "http://{}:5983/_all_dbs".format(os.environ["DB_PORT_5983_TCP_ADDR"])
                        )
                        .read()
                        .decode(encoding='UTF-8')
 )

start = "nedm"
print(', '.join([x for x in list_of_dbs if x[:len(start)] == start]))
