#!/bin/bash

echo "=== $JOBID started...."

LOGDIR="/var/www/hadoop-logs/${JOBNAME}__${JOBID}__${TIMESTAMP}"
mkdir -p "${LOGDIR}"

## stuff below is to wait till the jobs is done

STATUS=$(elastic-mapreduce  --describe  $JOBID | ruby job-status-parse.rb)

#while  [ "$STATUS" != "\"RUNNING\"" ]
while  [  "$STATUS" = "\"STARTING\""  -o   "$STATUS" = "\"BOOTSTRAPPING\""   ]
do
    sleep 60
    STATUS=$(elastic-mapreduce  --describe  $JOBID | ruby job-status-parse.rb)
done
t2=$(date +%s)
echo "=== Job started RUNNING in " $(expr $t2 - $t1) " seconds.  status : $STATUS"



while [ "$STATUS" =  "\"RUNNING\""  ]
do
    sleep 60
    STATUS=$(elastic-mapreduce  --describe  $JOBID | ruby job-status-parse.rb)
    s3cmd sync "s3://my_bucket/emr-logs/${JOBID}/" "${LOGDIR}/"  > /dev/null 2> /dev/null
    cp -f "${LOGDIR}/steps/1/syslog" "${LOGDIR}/mapreduce.log" 2> /dev/null
done

t3=$(date +%s)
diff=$(expr $t3 - $t1)
elapsed="$(expr $diff / 3600)-hours-$(expr $diff % 60)-mins"

s3cmd sync "s3://my_bucket/emr-logs/${JOBID}/" "${LOGDIR}/"  > /dev/null 2> /dev/null
cp "${LOGDIR}/steps/1/syslog" "${LOGDIR}/mapreduce.log" 2> /dev/null
s3cmd del -r  "s3://my_bucket/emr-logs/${JOBID}/"   > /dev/null 2> /dev/null

echo $(date +%Y%m%d.%H%M%S) " > $0 : finished in $elapsed.  status: $STATUS"
touch "${LOGDIR}/job-finished-in-$elapsed"
echo "==========================================="
