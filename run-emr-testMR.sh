#!/bin/bash

# config
# if changing machine type, also change mapred config file
MASTER_INSTANCE_TYPE="m1.large"
SLAVE_INSTANCE_TYPE="c1.xlarge"
INSTANCES=5
export JOBNAME="MyMR"
export TIMESTAMP=$(date +%Y%m%d-%H%M%S)
# end config

echo "==========================================="
echo $(date +%Y%m%d.%H%M%S) " > $0 : starting...."


export t1=$(date +%s)

#if the line breaks don't work, join the following lines and remove all '\'
export JOBID=$(elastic-mapreduce --plain-output  --create --name "${JOBNAME}__${TIMESTAMP}"   --num-instances "$INSTANCES"  --master-instance-type "$MASTER_INSTANCE_TYPE"  --slave-instance-type "$SLAVE_INSTANCE_TYPE"  --jar s3://my_bucket/my.jar --main-class my.TestMR  --log-uri s3://my_bucket/emr-logs/ )

export JOBID=$(elastic-mapreduce --plain-output  --create --name "${JOBNAME}__${TIMESTAMP}"\
--num-instances "$INSTANCES"  --master-instance-type "$MASTER_INSTANCE_TYPE"  --slave-instance-type "$SLAVE_INSTANCE_TYPE" \
--jar s3://my_bucket/my.jar \
--main-class my.TestMR --log-uri s3://my_bucket/emr_logs/  \
--bootstrap-action s3://elasticmapreduce/bootstrap-actions/configure-hadoop \
--args "--core-config-file,s3://my_bucket/config-core-site.xml,\
--mapred-config-file,s3://my_bucket/config-mapred-site-m1-xl.xml")


sh ./emr-wait-for-completion.sh
