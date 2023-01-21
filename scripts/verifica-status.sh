#!/bin/sh

PROCESSO=httpd
mkdir /Erik/
# NUMERO DE VEZES QUE O PROCESSO ESTA RODANDO #
OCORRENCIAS=`ps ax | grep $PROCESSO | grep -v grep| wc -l`
if [ $OCORRENCIAS -eq 0 ]; then
         date>>/Erik/Offline
         echo "Serviço: ${PROCESSO} status:Offline">>/Erik/Offline
         systemctl restart httpd
else
         date>>/Erik/Online
         echo "Serviço: ${PROCESSO} status:Online">>/Erik/Online
fi

