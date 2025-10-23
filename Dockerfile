FROM tomcat:9-jdk11

# Install required packages
RUN apt-get update && \
    apt-get install -y curl jq wget unzip postgresql-client && \
    rm -rf /var/lib/apt/lists/*

# Environment variables
ENV DHIS2_HOME=/opt/dhis2
ENV CATALINA_OPTS="-Xms2000m -Xmx4000m"

# Create directories
RUN mkdir -p ${DHIS2_HOME}/apps ${DHIS2_HOME}/files

# Download DHIS2 WAR file (version 2.40.6 - stable)
RUN wget -O /usr/local/tomcat/webapps/ROOT.war \
    https://releases.dhis2.org/2.40/dhis2-stable-2.40.6.war

# Copy configuration
COPY dhis.conf ${DHIS2_HOME}/

# Copy your malaria metadata JSON file
COPY malaria-metadata.json /tmp/

# Copy metadata import script
COPY install-malaria-package.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/install-malaria-package.sh

EXPOSE 8080

# Start Tomcat and install malaria package in background
CMD ["/bin/bash", "-c", "catalina.sh run & /usr/local/bin/install-malaria-package.sh && tail -f /dev/null"]
