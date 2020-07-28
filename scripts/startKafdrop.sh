cd $(dirname $0)
pwd

if [[ "$1" == "es-cloud.properties" ]]
then
    source ../.env
    export KAFKA_BROKERS=$KAFKA_SOURCE_BROKERS
    sed 's/APIKEY/'$KAFKA_SOURCE_APIKEY'/g' es-cloud.properties > output.properties
else
   cp local-kafka.properties output.properties
   KAFKA_BROKERS=kafka1:9092,kafka2:9093,kafka3:9094
fi

docker run -d --rm -p 9000:9000 \
    --network kafkanet \
    --name kafdrop \
    -e KAFKA_BROKERCONNECT=$KAFKA_BROKERS \
    -e KAFKA_PROPERTIES=$(cat output.properties | base64) \
    -e JVM_OPTS="-Xms32M -Xmx64M" \
    -e SERVER_SERVLET_CONTEXTPATH="/" \
    obsidiandynamics/kafdrop