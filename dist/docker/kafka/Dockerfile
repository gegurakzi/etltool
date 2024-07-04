FROM openjdk:11-jre-slim

ARG SCALA_VERSION=2.12
ARG SCALA_FULL_VERSION=2.12.19

#ARG KAFKA_VERSION=3.7.0

ARG CONFLUENT_VERSION=7.0
ARG CONFLUENT_FULL_VERSION=7.0.1

ENV SCALA_HOME=/opt/scala-${SCALA_VERSION}
ENV PATH=$PATH:$SCALA_HOME/bin
#ENV KAFKA_HOME=/opt/kafka-${KAFKA_VERSION}
#ENV PATH=$PATH:$KAFKA_HOME/bin

ENV CONFLUENT_HOME=/opt/confluent-${CONFLUENT_FULL_VERSION}
ENV PATH=$PATH:$CONFLUENT_HOME/bin

# install utils
RUN \
    apt-get -qq update && \
    apt-get -qq upgrade -y && \
    apt-get -qq install -y git wget curl

# install Scala
RUN \
    wget https://downloads.lightbend.com/scala/${SCALA_FULL_VERSION}/scala-${SCALA_FULL_VERSION}.tgz && \
    tar -xzf scala-${SCALA_FULL_VERSION}.tgz && \
    mv scala-${SCALA_FULL_VERSION} ${SCALA_HOME} && \
    ln -s ${SCALA_HOME} /opt/scala

# install Kafka
#RUN \
#    wget https://downloads.apache.org/kafka/${KAFKA_VERSION}/kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
#    tar -xzf kafka_${SCALA_VERSION}-${KAFKA_VERSION}.tgz && \
#    mv kafka_${SCALA_VERSION}-${KAFKA_VERSION} ${KAFKA_HOME} && \
#    ln -s ${KAFKA_HOME} /opt/kafka

# install Kafka Connect \
RUN \
    wget http://packages.confluent.io/archive/${CONFLUENT_VERSION}/confluent-community-${CONFLUENT_FULL_VERSION}.tar.gz && \
    tar -xzf confluent-community-${CONFLUENT_FULL_VERSION}.tar.gz && \
    mv confluent-${CONFLUENT_FULL_VERSION} ${CONFLUENT_HOME} && \
    ln -s ${CONFLUENT_HOME} /opt/confluent

# copy or download connector jars \
RUN \
    mkdir -p ${CONFLUENT_HOME}/share/connectors && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.7.0.Final/debezium-connector-mysql-2.7.0.Final-plugin.tar.gz && \
    tar -xzf debezium-connector-mysql-2.7.0.Final-plugin.tar.gz && \
    mv debezium-connector-mysql ${CONFLUENT_HOME}/share/connectors
