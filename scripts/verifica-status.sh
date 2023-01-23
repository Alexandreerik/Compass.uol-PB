#!/bin/sh
PROCESSO=httpd
# NUMERO DE VEZES QUE O PROCESSO ESTA RODANDO #
OCORRENCIAS=`ps ax | grep $PROCESSO | grep -v grep| wc -l`
if [ $OCORRENCIAS -eq 0 ]; then
         date>>/mnt/nfs/Erik/Offline
         echo "Serviço: ${PROCESSO} status:Offline">>/mnt/nfs/Erik/Offline
         systemctl restart httpd
else
         date>>/mnt/nfs/Erik/Online
         echo "Serviço: ${PROCESSO} status:Online">>/mnt/nfs/Erik/Online
fi

