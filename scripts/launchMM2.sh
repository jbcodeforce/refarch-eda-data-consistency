 TGT_PROP_FILE=./mirror-maker-2/es-to-local/mm2.properties
 TMPL_PROP_FILE=./mirror-maker-2/es-to-local/mm2-tmpl.properties
 echo "#########################"
 echo "1. modify properties file : $TMPL_PROP_FILE to $TGT_PROP_FILE"

 cat  $TMPL_PROP_FILE | sed  -e "s/KAFKA_SOURCE_BROKERS/$KAFKA_SOURCE_BROKERS/g" \
 -e  "s/KAFKA_SOURCE_APIKEY/$KAFKA_SOURCE_APIKEY/g" > $TGT_PROP_FILE
 cat $TGT_PROP_FILE
 export LOG_DIR=/tmp/logs

 echo "2. start a new container with mirror maker 2"
 docker run -ti --network kafkanet --name mm2 -v $(pwd):/home -v $(pwd)/mirror-maker-2/logs:/opt/kafka/logs strimzi/kafka:latest-kafka-2.5.0 /bin/bash -c "/opt/kafka/bin/connect-mirror-maker.sh /home/mirror-maker-2/es-to-local/mm2.properties"
 