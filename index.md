---
title: Munin docker container
layout: basic
---

## Munin docker container 

The docker container encapsulates a munin server that queries a CouchDB
server and saves particular metrics.  This uses the munin script [detailed
here](http://gws.github.io/munin-plugin-couchdb/guide-to-couchdb-monitoring.html). 

The script that runs on the docker container is:

{% highlight sh %}
#!/bin/sh

rm /etc/munin/plugins/*
ln -s /usr/share/munin/plugins/couchdb /etc/munin/plugins/couchdb
DBS=`python3 /get_all_dbs.py`

cat << EOF > /etc/munin/plugin-conf.d/couchdb
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
{% endhighlight %}

The command `python3 /get_all_dbs.py` gets all the `nedm` databases available
on the server.  This means that the munin server would need to be restarted if
new databases are deployed.

This queries the CouchDB at the URL `$DB_PORT_5983_TCP_ADDR:5983`, which is a
port that should have administrative access to the CouchDB server (to be able
to save admin-only metrics).  In the nEDM systems, the 
[File-Server docker]({{ site.url }}/FileServer-Docker) exports this port (_not
publicly!_) already.

### Starting the container

Use the command:

{% highlight sh %}
docker run -d -p [exported_port]:80\
  --name munin --link [NameOfCouchDBServer]:db \
  registry.hub.docker.com/mgmarino/munin-docker:latest
{% endhighlight %}

`[NameOfCouchDBServer]` should be the name of the container that hosts the
CouchDB server (or provides a proxy to the CouchDB server.

_Note_: to ensure that the data is persistant between starting/stopping the
container, use a 
[data container](https://docs.docker.com/userguide/dockervolumes/#creating-and-mounting-a-data-volume-container)
and add the appropriate flags to the above command.

