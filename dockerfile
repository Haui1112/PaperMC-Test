# Dockerfile Minecraft Server

FROM alpine

ENV MC_VERSION="latest" \
    PAPER_BUILD="latest" \
    MC_RAM="" \
    JAVA_OPTS=""

LABEL Hauis "PaperMC"
RUN apk add openjdk17 --no-cache &&\
    apk add jq --no-cache &&\ 
    mkdir /var/minecraft &&\
    mkdir /var/minecraft/updater &&\
    adduser -D minecraft
COPY updater /var/minecraft/updater
RUN chown -R minecraft:minecraft /var/minecraft/
USER minecraft 
WORKDIR /var/minecraft/updater
#ENTRYPOINT ["sh", "/var/minecraft/updater/startup.sh"] didnt work
#ENTRYPOINT [ "/bin/sh" ] #did work
ENTRYPOINT [ "sh" , "./startup.sh" ]
EXPOSE 25565/tcp
EXPOSE 25565/udp
VOLUME /minecraft