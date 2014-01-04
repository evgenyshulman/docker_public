#!/bin/bash

SCRIPT_HOME="$( cd "$( dirname "$0" )" && pwd )"

for image_name in graphite elasticsearch kafka logstash  redis riemann zookeeper
do
    dir=$SCRIPT_HOME/../images/$image_name
	#image_name=${PWD##*/} && # to assign to a variable
	cd $dir &&
	echo "Building $image_name from $dir" &&
	docker build -t crosswise/$image_name .
done
