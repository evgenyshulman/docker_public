#/bin/bash
set -x

DIR="$( cd "$( dirname "$0" )" && pwd )"
APPS=${APPS:-/mnt/apps}

killz(){
	echo "Killing all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker kill
	echo $ids | xargs docker rm
}

stop(){
	echo "Stopping all docker containers:"
	docker ps
	ids=`docker ps | tail -n +2 |cut -d ' ' -f 1`
	echo $ids | xargs docker stop
	echo $ids | xargs docker rm
}

start(){
	mkdir -p $APPS/zookeeper/data
	mkdir -p $APPS/zookeeper/logs
	sudo docker rm zookeeper > /dev/null 2>&1
        ZOOKEEPER=$(docker run \
            -d \
            -p 2181:2181 \
            -v $APPS/zookeeper/logs:/logs \
            -name zookeeper \
            crosswise/zookeeper)
	echo "Started ZOOKEEPER in container $ZOOKEEPER"

	mkdir -p $APPS/redis/data
	mkdir -p $APPS/redis/logs
	REDIS=$(docker run \
		-p 6379:6379 \
		-v $APPS/redis/data:/data \
		-v $APPS/redis/logs:/logs \
		-d \
		crosswise/redis)
	echo "Started REDIS in container $REDIS"

#	mkdir -p $APPS/cassandra/data
#	mkdir -p $APPS/cassandra/logs
#	CASSANDRA=$(docker run \
#		-p 7000:7000 \
#		-p 7001:7001 \
#		-p 7199:7199 \
#		-p 9160:9160 \
#		-p 9042:9042 \
#		-v $APPS/cassandra/data:/data \
#		-v $APPS/cassandra/logs:/logs \
#		-d \
#		crosswise/cassandra)
#	echo "Started CASSANDRA in container $CASSANDRA"

	mkdir -p $APPS/elasticsearch/data
	mkdir -p $APPS/elasticsearch/logs
	ELASTICSEARCH=$(docker run \
		-p 9200:9200 \
		-p 9300:9300 \
		-v $APPS/elasticsearch/data:/data \
		-v $APPS/elasticsearch/logs:/logs \
		-d \
		crosswise/elasticsearch)
	echo "Started ELASTICSEARCH in container $ELASTICSEARCH"


	mkdir -p $APPS/kafka/data
	mkdir -p $APPS/kafka/logs
	sudo docker rm kafka > /dev/null 2>&1
	KAFKA=$(docker run \
		-d \
		-p 9092:9092 \
		-v $APPS/kafka/data:/data \
		-v $APPS/kafka/logs:/logs \
		-name kafka \
		-link zookeeper:zookeeper \
		crosswise/kafka)
	echo "Started KAFKA in container $KAFKA"

	SHIPYARD=$(docker run \
		-p 8005:8000 \
		-d \
		shipyard/shipyard)

    GRAPHITE=$(docker run \
		-p 2003:2003   \
		-p 41080:80  \
		-p 41022:22 \
		-p 41826:25826 \
		-d crosswise/graphite)


	sleep 1

}

update(){
	apt-get update
	apt-get install -y lxc-docker
	cp /vagrant/etc/docker.conf /etc/init/docker.conf

	docker pull crosswise/zookeeper
	docker pull crosswise/redis
	docker pull crosswise/elasticsearch
	docker pull crosswise/kafka
	docker pull crosswise/graphite

	docker pull shipyard/shipyard
}

case "$1" in
	restart)
		killz
		start
		;;
	start)
		start
		;;
	stop)
		stop
		;;
	kill)
		killz
		;;
	update)
		update
		;;
	status)
		docker ps
		;;
	*)
		echo $"Usage: $0 {start|stop|kill|update|restart|status|ssh}"
		RETVAL=1
esac
