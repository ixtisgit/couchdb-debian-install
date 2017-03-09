#!/bin/bash

set -e

sudo apt-get update || true
apt-get --no-install-recommends -y install \
    build-essential pkg-config runit erlang \
    libicu-dev libmozjs185-dev libcurl4-openssl-dev

wget -e use_proxy=yes -e http_proxy=http://10.0.0.110:3128 \
    http://apache-mirror.rbc.ru/pub/apache/couchdb/source/2.0.0/apache-couchdb-2.0.0.tar.gz

tar -xvzf apache-couchdb-2.0.0.tar.gz
cd apache-couchdb-2.0.0/
./configure && make release

adduser --system \
        --no-create-home \
        --shell /bin/bash \
        --group --gecos \
        "CouchDB Administrator" couchdb

cp -R rel/couchdb /opt/couchdb
chown -R couchdb:couchdb /opt/couchdb
find /opt/couchdb -type d -exec chmod 0770 {} \;
sh -c 'chmod 0644 /opt/couchdb/etc/*'

cat <<EOT >> /etc/systemd/system/couchdb
[Unit]
Description=Couchdb service
After=network.target

[Service]
User=couchdb
ExecStart=/opt/couchdb/bin/couchdb -o /dev/stdout -e /dev/stderr
Restart=always

[Install]
WantedBy=multi-user.target
EOT

systemctl daemon-reload
systemctl start couchdb
systemctl enable couchdb
