#!/bin/bash
source ../.env

if [[ "$1" == "es-ic" ]]
then
    docker run -ti -v $(pwd):/home --rm -e KAFKA_BROKERS=$ES_IC_BROKERS \
    -e KAFKA_PWD=$ES_IC_PASSWORD \
    -e KAFKA_USER=$ES_IC_USER \
    -e KAFKA_SASL_MECHANISM=$ES_IC_SASL_MECHANISM \
    -v $(pwd):/home \
    ibmcase/kcontainer-python:itgtests python /home/SendProductToKafka.py --file /home/data/products.json
else
   if [[ "$1" == "es-ocp" ]]
   then
     docker run -ti -v $(pwd):/home --rm -e KAFKA_BROKERS=$ES_OCP_BROKERS \
    -e KAFKA_PWD=$ES_OCP_PASSWORD \
    -e KAFKA_USER=$ES_OCP_USER \
    -e KAFKA_CERT=$ES_OCP_CERT \
     -v $(pwd):/home \
    -e KAFKA_SASL_MECHANISM=$ES_OCP_SASL_MECHANISM \
    ibmcase/kcontainer-python:itgtests python /home/SendProductToKafka.py --file /home/data/products.json

   fi
fi
