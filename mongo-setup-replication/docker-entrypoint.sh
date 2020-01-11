#!/bin/bash

echo "Waiting for startup.."
until curl http://mongodb0:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1; do
  printf '.'
  sleep 2
done

echo curl http://mongodb0:27017/serverStatus\?text\=1 2>&1 | grep uptime | head -1
echo "Started.."

sleep 15

echo SETUP time now: `date +"%T" `
mongo --host "mongodb0" <<EOF
   rs.initiate({
    _id : "rs0",
    members: [
        { _id: 0, host: "mongodb0:27017", priority: 2 },
        { _id: 1, host: "mongodb1:27017" },
        { _id: 2, host: "mongodb2:27017" }
    ]
  }, { force: true })
EOF

echo "rs.isMaster()" > is_master_check
is_master_result=`mongo --host "mongodb0" < is_master_check`

expected_result="\"ismaster\" : true"

while true;
do
  if [ "${is_master_result/$expected_result}" = "$is_master_result" ] ; then
    echo "Waiting for Mongod node to assume primary status..."
    sleep 3
    is_master_result=`mongo --host "mongodb0" < is_master_check`
    echo ${is_master_result}
  else
    echo "Mongod node is now primary"
    break;
  fi
done

exec "$@"
