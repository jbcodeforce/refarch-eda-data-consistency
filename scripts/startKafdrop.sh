cd $(dirname $0)
pwd
source ../.env

 TGT_PROP_FILE=./kafdrop.properties
 TMPL_PROP_FILE=./es-cloud.properties
 echo "############################################################"
 echo "1. modify properties file : $TMPL_PROP_FILE to $TGT_PROP_FILE"
 echo "############################################################"
 

if [[ "$1" == "es-ic" ]]
then
    echo " Prepare of Event Streams on IBM Cloud"
    cat  $TMPL_PROP_FILE | sed -e  "s/KAFKA_PASSWORD/$ES_IC_PASSWORD/g" \
    -e  "s/KAFKA_USER/$ES_IC_USER/g" \
    -e  "s/LOGIN_MODULE/$ES_IC_LOGIN_MODULE/g" \
    -e  "s/KAFKA_SASL_MECHANISM/$ES_IC_SASL_MECHANISM/g" > $TGT_PROP_FILE
    docker run -d --rm -p 9000:9000 \
            --name kafdrop \
            -e KAFKA_BROKERCONNECT=$ES_IC_BROKERS \
            -e KAFKA_PROPERTIES=$(cat $TGT_PROP_FILE | base64) \
            -e JVM_OPTS="-Xms32M -Xmx64M" \
            -e SERVER_SERVLET_CONTEXTPATH="/" \
            obsidiandynamics/kafdrop
else
   if [[ "$1" == "es-ocp" ]]
   then
        echo " Prepare of Event Streams on OpenShift"
        cat  $TMPL_PROP_FILE | sed -e  "s/KAFKA_PASSWORD/$ES_OCP_PASSWORD/g" \
        -e  "s/KAFKA_USER/$ES_OCP_USER/g" \
        -e  "s/LOGIN_MODULE/$ES_OCP_LOGIN_MODULE/g" \
        -e  "s/KAFKA_SASL_MECHANISM/$ES_OCP_SASL_MECHANISM/g" > $TGT_PROP_FILE
 
        docker run -d --rm -p 9000:9000 \
            --name kafdrop \
            -e KAFKA_BROKERCONNECT=$ES_OCP_BROKERS \
            -e KAFKA_PROPERTIES=$(cat $TGT_PROP_FILE | base64) \
            -e JVM_OPTS="-Xms32M -Xmx64M" \
            -e SERVER_SERVLET_CONTEXTPATH="/" \
            obsidiandynamics/kafdrop
   else
        docker run -d --rm -p 9000:9000 \
            --network kafkanet \
            --name kafdrop \
            -e KAFKA_BROKERCONNECT=$KAFKA_LOCAL_BROKERS \
            -e JVM_OPTS="-Xms32M -Xmx64M" \
            -e SERVER_SERVLET_CONTEXTPATH="/" \
            obsidiandynamics/kafdrop
    fi
fi

