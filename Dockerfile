FROM ubuntu:12.10

RUN apt-get update

# add source for webupd8 java
RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu quantal main" | tee -a /etc/apt/sources.list.d/java.sources.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886
RUN apt-get update -o Dir::Etc::sourcelist="sources.list.d/java.sources.list" -o Dir::Etc::sourceparts="-" -o APT::Get::List-Cleanup="0"

# install java
RUN echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get install -yq oracle-java7-installer

# install elastic search
RUN apt-get install -yq wget
RUN wget --no-check-certificate -q https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.13.deb
RUN dpkg -i elasticsearch-0.90.13.deb
RUN rm elasticsearch-0.90.13.deb

# add marvel for monitoring
RUN /usr/share/elasticsearch/bin/plugin -i elasticsearch/marvel/latest

# configure init script to run in the foreground (I don't like this, but the start script does lots of useful config/setup)
RUN sed -i.bak 's/--start -b/--start/' /etc/init.d/elasticsearch
RUN sed -i.bak 's/^DAEMON_OPTS="/DAEMON_OPTS="-f /' /etc/init.d/elasticsearch

VOLUME ["/var/lib/elasticsearch", "/var/log/elasticsearch"]
EXPOSE 9200 9300

ADD start.sh /usr/local/bin/start.sh
CMD /usr/local/bin/start.sh
