FROM ubuntu:12.04

RUN	echo 'deb http://us.archive.ubuntu.com/ubuntu/ precise universe' >> /etc/apt/sources.list

# this forces dpkg not to call sync() after package extraction and speeds up install
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
# we don't need and apt cache in a container
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache

RUN apt-get update
RUN apt-get install -y wget  zsh tmux vim curl software-properties-common
# python
RUN apt-get install -y python-setuptools python-dev python-pip python-apt  python-software-properties

# ansible
RUN apt-add-repository ppa:rquillo/ansible && apt-get update
RUN apt-get install -y ansible

# awx
#RUN wget http://ansibleworks.com/releases/awx/setup/awx-setup-latest.tar.gz
#RUN tar -zxvf awx-setup-latest.tar.gz && cd awx* &&  ./setup.sh
