# Forked from github.com/nickstenning/dockerfiles/graphite
FROM	crosswise/base
RUN	apt-get -y update
RUN	apt-get -y install python-ldap python-cairo python-django python-twisted python-django-tagging python-simplejson python-memcache python-pysqlite2 python-support python-pip gunicorn supervisor nginx-light
RUN	pip install whisper
RUN	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/lib" carbon
RUN	pip install --install-option="--prefix=/var/lib/graphite" --install-option="--install-lib=/var/lib/graphite/webapp" graphite-web
ADD	./nginx.conf /etc/nginx/nginx.conf
ADD	./supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD	./initial_data.json /var/lib/graphite/webapp/graphite/initial_data.json
ADD	./local_settings.py /var/lib/graphite/webapp/graphite/local_settings.py
ADD	./carbon.conf /var/lib/graphite/conf/carbon.conf
ADD	./storage-schemas.conf /var/lib/graphite/conf/storage-schemas.conf

RUN	mkdir -p /var/lib/graphite/storage/whisper
RUN	touch /var/lib/graphite/storage/graphite.db /var/lib/graphite/storage/index
RUN	chown -R www-data /var/lib/graphite/storage
RUN	chmod 0775 /var/lib/graphite/storage /var/lib/graphite/storage/whisper
RUN	chmod 0664 /var/lib/graphite/storage/graphite.db
RUN	cd /var/lib/graphite/webapp/graphite && python manage.py syncdb --noinput
VOLUME  /var/lib/graphite

VOLUME [ "/data" ]
VOLUME [ "/logs" ]


EXPOSE	:80
EXPOSE	:2003
EXPOSE	:2004
EXPOSE	:7002
CMD	["/usr/bin/supervisord", "-n"]
