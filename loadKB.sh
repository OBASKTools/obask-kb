#!/bin/sh
echo "set read only = ${NEOREADONLY} then launch neo4j service"
sed -i s/read_only=.*/read_only=${NEOREADONLY}/ ${NEOSERCONF} && \

echo 'Allow new neo4j2owl plugin to make changes..'
echo 'dbms.security.procedures.unrestricted=ebi.spot.neo4j2owl.*,apoc.*,gds.*' >> ${NEOSERCONF}

# Add your data loading logic here
#if [ -n "${BACKUPFILE}" ]; then
#  if [ ! -f /data/databases/neo4j/neostore ]; then
#    # Download backup
#    if [ ! -f /backup/neo4j.dump ]; then
#      echo 'Restore KB from archive backup'
#      cd /backup/
#      wget https://github.com/hkir-dev/brain_data_standards_kb/raw/main/backup/neo4j.dump
#      cd -
#    fi
#
#    echo 'Restore KB from given backup'
#    /var/lib/neo4j/bin/neo4j-admin load --from=/backup/neo4j.dump --verbose --force
#  fi
#fi

echo -e '\nSTARTING BDS KB SERVER\n' >> /var/lib/neo4j/logs/query.log

#Output the query log to docker log:
tail -f /var/lib/neo4j/logs/query.log >/proc/1/fd/1 &
exec /docker-entrypoint.sh neo4j
