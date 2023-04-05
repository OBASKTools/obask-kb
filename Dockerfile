FROM neo4j:4.2-community

# Fix for log4j vulnerability
ENV LOG4J_FORMAT_MSG_NO_LOOKUPS=true
ENV NEO4J_dbms_jvm_additional="-Dlog4j2.formatMsgNoLookups=true -Dlog4j2.disable.jmx=true"

VOLUME /input
ENV CSV_IMPORTS=/input/dumps/csv_imports

# Location of config files (separate in v2)
ENV NEOCONF="/var/lib/neo4j/conf/neo4j.conf"
ENV NEOSERCONF=${NEOCONF}

ENV NEOREADONLY=false

ENV BACKUPFILE="neo4j.dump"

# Enable upgrading of DB:
ENV NEO4J_ALLOW_STORE_UPGRADE=true
ENV NEO4J_dbms_allow__upgrade=true

ENV NEO4J_dbms_memory_heap_maxSize=5G
ENV NEO4J_dbms_memory_pagecache_size=4G
ENV NEO4J_dbms_memory_heap_initial__size=1G
ENV NEO4J_dbms_read__only=false
ENV NEO4J_dbms_security_procedures_unrestricted=ebi.spot.neo4j2owl.*,apoc.*,gds.*
# Add apoc tools
ENV NEO4J_apoc_export_file_enabled=true
ENV NEO4J_apoc_import_file_enabled=true
ENV NEO4J_apoc_import_file_use__neo4j__config=true
ENV NEO4JLABS_PLUGINS=[]

# Addditional configs for community based image
ENV NEO4J_dbms_read__only=false
ENV NEO4J_dbms_security_auth__enabled=false
ENV NEO4J_AUTH=neo4j/neo
ENV NEO4J_ACCEPT_LICENSE_AGREEMENT=yes
ENV NEO4J_dbms_directories_import=import
ENV NEO4J_dbms_security_allow_csv_import_from_file_urls=true

RUN apt-get -qq update || apt-get -qq update && \
apt-get -qq -y install tar gzip curl wget zip unzip

COPY loadKB.sh /opt/VFB/
#COPY /backup /backup/

##### NEO4J TO OWL TOOLS #####
ENV NEO4J2OWL_VERSION=1.1.24-PRE
ARG NEO4J2OWL_JAR=https://github.com/VirtualFlyBrain/neo4j2owl/releases/download/$NEO4J2OWL_VERSION/neo4j2owl.jar
RUN wget $NEO4J2OWL_JAR -O /var/lib/neo4j/plugins/neo4j2owl.jar

###### APOC TOOLS ######
ENV APOC_VERSION=4.2.0.2
ARG APOC_JAR=https://github.com/neo4j-contrib/neo4j-apoc-procedures/releases/download/$APOC_VERSION/apoc-$APOC_VERSION-all.jar
ENV APOC_JAR=${APOC_JAR}
RUN wget $APOC_JAR -O /var/lib/neo4j/plugins/apoc.jar

###### GDS TOOLS ######
ENV GDS_VERSION=1.5.1
ARG GDS_JAR=https://s3-eu-west-1.amazonaws.com/com.neo4j.graphalgorithms.dist/graph-data-science/neo4j-graph-data-science-$GDS_VERSION-standalone.zip
ENV GDS_JAR ${GDS_JAR}
RUN wget $GDS_JAR -O /var/lib/neo4j/plugins/gds.zip && cd /var/lib/neo4j/plugins/ && unzip gds.zip && rm gds.zip

RUN chmod +x /opt/VFB/loadKB.sh

ENTRYPOINT ["/opt/VFB/loadKB.sh"]
