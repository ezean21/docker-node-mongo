#!/usr/bin/env bash

# Wait until Mongo is ready to accept connections, exit if this does not happen within 30 seconds
MONGO_HOST="$1"
shift
CMD="$@"
COUNTER=0

until mongo --host ${MONGO_HOST} --eval "printjson(db.serverStatus())"
do
  sleep 1
  COUNTER=$((COUNTER+1))
  if [[ ${COUNTER} -eq 60 ]]; then
    echo "MongoDB did not initialize within 60 seconds, exiting"
    exit 1
  fi
  echo "Waiting for MongoDB to initialize... ${COUNTER}/30"
done

>&2 echo "Postgres is up - executing command"
exec $CMD