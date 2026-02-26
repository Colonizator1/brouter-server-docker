FROM maven:3.6-jdk-11
LABEL org.opencontainers.image.authors="arturhooks@gmail.com"
RUN echo "deb [trusted=yes] http://archive.debian.org/debian buster main non-free contrib" > /etc/apt/sources.list
RUN echo "deb-src [trusted=yes] http://archive.debian.org/debian buster main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb [trusted=yes] http://archive.debian.org/debian-security buster/updates main non-free contrib" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y wget curl nano

WORKDIR /usr/src/app
ARG VERSION
ARG JAVA_OPTS
ARG REQUEST_TIMEOUT
ARG MAX_THREADS

# Build server
RUN wget https://github.com/abrensch/brouter/archive/refs/tags/v${VERSION}.tar.gz \
&& tar xzvf v${VERSION}.tar.gz && rm v${VERSION}.tar.gz \
&& cd brouter-${VERSION} && ./gradlew clean build fatJar

# Run server
WORKDIR /data
CMD java ${JAVA_OPTS} -DmaxRunningTime=${REQUEST_TIMEOUT} -cp /usr/src/app/brouter-${VERSION}/brouter-server/build/libs/brouter-${VERSION}-all.jar btools.server.RouteServer segments profiles ../customprofiles 17777 ${MAX_THREADS}