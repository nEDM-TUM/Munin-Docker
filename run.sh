#!/bin/sh

rm /etc/munin/plugins/*
ln -s /usr/share/munin/plugins/couchdb /etc/munin/plugins/couchdb
DBS=`python3 /get_all_dbs.py`

cat << EOF >> /etc/munin/plugin-conf.d/couchdb
[couchdb]
env.uri   http://$DB_PORT_5983_TCP_ADDR:5983
env.monitor_active_tasks  yes
env.monitor_users  yes
env.monitor_databases yes
env.databases $DBS

EOF

service munin-node start

export NODES="local:127.0.0.1"
start-munin
