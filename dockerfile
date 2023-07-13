# Dockerfile Minecraft Server

FROM alpine
LABEL Hauis "PaperMC"
RUN apk update && \
    apk add openjdk17 && \
    mkdir /minecraft && \
    cd /minecraft && \
    wget https://api.papermc.io/v2/projects/paper/versions/1.20.1/builds/71/downloads/paper-1.20.1-71.jar
WORKDIR /minecraft    
RUN java -server -jar paper-1.20.1-71.jar && sed -i 's/false/true/g' eula.txt
ENTRYPOINT java -server -jar paper-1.20.1-71.jar nogui
EXPOSE 25565/tcp
EXPOSE 25565/udp
