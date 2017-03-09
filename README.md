# couchdb-install
CouchDB 2.0 Debian 8 installation script with proxy option and systemd. Based on https://github.com/afiskon/install-couchdb
For usage just download/copy script and run it in target directory. After installation make check:

```
# curl -X GET http://127.0.0.1:5984
{"couchdb":"Welcome","version":"2.0.0","vendor":{"name":"The Apache Software Foundation"}}

```

Tested on Debian 8.4 LXC
