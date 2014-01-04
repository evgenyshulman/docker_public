FROM crosswise/oracle-java7

ENV VERSION 3.3.6

RUN apt-get update
RUN apt-get install -y git curl build-essential make gcc wget

RUN wget http://mirror.nexcess.net/apache/zookeeper/zookeeper-$VERSION/zookeeper-$VERSION.tar.gz
RUN tar xzf zookeeper-$VERSION.tar.gz
RUN ln -sfn zookeeper-$VERSION zookeeper

ADD zoo.cfg /zookeeper/conf/zoo.cfg
ADD log4j.properties /zookeeper/conf/log4j.properties

VOLUME [ "/data" ]
VOLUME [ "/logs" ]

EXPOSE 2181

CMD ["zookeeper/bin/zkServer.sh", "start-foreground"]

