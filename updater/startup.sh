#!/bin/bash

# Enter server directory
cd ..

# Get version information and build download URL and jar name
URL=https://papermc.io/api/v2/projects/paper
if [ ${MC_VERSION} = latest ] || [ -z "${MC_VERSION}" ];  
then
  # Get the latest MC version
  MC_VERSION=$(wget -qO - $URL | jq -r '.versions[-1]') # "-r" is needed because the output has quotes otherwise
fi
URL=${URL}/versions/${MC_VERSION}
if [ ${PAPER_BUILD} = latest ]
then
  # Get the latest build
  PAPER_BUILD=$(wget -qO - $URL | jq '.builds[-1]')
fi

JAR_NAME=paper-${MC_VERSION}-${PAPER_BUILD}.jar
URL=${URL}/builds/${PAPER_BUILD}/downloads/${JAR_NAME}

# Update if necessary
if [ ! -e ${JAR_NAME} ]
then
  # Remove old server jar(s)
  rm -f *.jar
  # Download new server jar
  wget ${URL} -O ${JAR_NAME}
  
  # If this is the first run, accept the EULA
  if [ ! -e eula.txt ]
  then
    # Run the server once to generate eula.txt
    java -jar ${JAR_NAME}
    # Edit eula.txt to accept the EULA
    sed -i 's/false/true/g' eula.txt
  fi
fi

#Plugins places to check in chron order: Hangar, Modrinth, Spigot, Bukkit, Source (github etc)
#Check Plugins (after first run so plugins folder exists)
#1. get plugin list
while IFS= read -r line; do
    echo "Text read from file: $line"
done < plugins.txt
#cd plugins #change directory since the plugins are somewhere else

#2. check plugin folder for stuff to add to the list
#3. check list against mod databases 
#cd .. # change back to main folder

# Add RAM options to Java options if necessary
if [ ! -z "${MC_RAM}" ]
then
  JAVA_OPTS="-Xms${MC_RAM} -Xmx${MC_RAM} ${JAVA_OPTS}"
fi

# Start server
exec java -server ${JAVA_OPTS} -jar ${JAR_NAME} nogui
