#!/bin/bash

if [ "$ADMINISTRATION_PORT_ENABLED" = "true" ] ; then
   echo "https://{localhost:$ADMINISTRATION_PORT}/weblogic/ready" ;
else
   echo "http://{localhost:$ADMIN_LISTEN_PORT}/weblogic/ready" ;
fi

exit;