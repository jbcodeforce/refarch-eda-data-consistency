cd $(dirname $0)
pwd

source ../.env
echo $KAFKA_SOURCE_BROKERS

 TGT_PROP_FILE=../mirror-maker-2/es-to-local/mm2.properties
 TMPL_PROP_FILE=../mirror-maker-2/es-to-local/mm2-tmpl.properties
 echo "############################################################"
 echo "1. modify properties file : $TMPL_PROP_FILE to $TGT_PROP_FILE"
 echo "############################################################"
 
 cat  $TMPL_PROP_FILE | sed  -e "s/KAFKA_SOURCE_BROKERS/$ES_IC_BROKERS/g" \
 -e "s/KAFKA_TARGET_BROKERS/$KAFKA_LOCAL_BROKERS/g" \
 -e  "s/KAFKA_SOURCE_USER/$ES_IC_USER/g" \
 -e  "s/KAFKA_SOURCE_PASSWORD/$ES_IC_PASSWORD/g" \
 -e  "s/LOGIN_MODULE/$ES_IC_LOGIN_MODULE/g" \
 -e  "s/KAFKA_SASL_MECHANISM/$ES_IC_SASL_MECHANISM/g" > $TGT_PROP_FILE
 cat $TGT_PROP_FILE
 export LOG_DIR=/tmp/logs

echo "############################################################"
echo "2. start a new container with mirror maker 2"
echo "############################################################"
 
 docker run -ti --network kafkanet --rm --name mm2 -v $(pwd)/..:/home -v $(pwd)/mirror-maker-2/logs:/opt/kafka/logs strimzi/kafka:latest-kafka-2.5.0 /bin/bash -c "/opt/kafka/bin/connect-mirror-maker.sh /home/mirror-maker-2/es-to-local/mm2.properties"
 