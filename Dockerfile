FROM maven:3.6-jdk-11
LABEL org.opencontainers.image.authors="arturhooks@gmail.com"
RUN apt-get update && apt-get install -y wget curl nano

WORKDIR /usr/src/app
ARG VERSION
ARG JAVA_OPTS
ARG REQUEST_TIMEOUT
ARG MAX_THREADS

# Build server
WORKDIR /usr/src/app/brouter-${VERSION}
RUN wget https://github.com/abrensch/brouter/archive/refs/tags/v${VERSION}.tar.gz \
&& tar xzvf v${VERSION}.tar.gz && rm v${VERSION}.tar.gz \
&& ./gradlew clean build fatJar

# Create default profiles
RUN ./misc/scripts/generate_profile_variants.sh && cp -R ./misc/profiles2/* /data/profiles/

# Run server
WORKDIR /data
CMD java ${JAVA_OPTS} -DmaxRunningTime=${REQUEST_TIMEOUT} -cp /usr/src/app/brouter-${VERSION}/brouter-server/build/libs/brouter-${VERSION}-all.jar btools.server.RouteServer segments profiles ../customprofiles 17777 ${MAX_THREADS}