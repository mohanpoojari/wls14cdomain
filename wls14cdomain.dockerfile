#Author: Mohan Poojari
# Configure wls14c image first

ARG REPO
FROM ${REPO}some/tag/wls14c

# Build Arguments
# (Put build arguments first and set defaults)
# ARG VERSION=1.0

ENV DOMAIN_CONFIG ${ORACLE_BASE}/config
ENV DOMAIN_NAME wlsdomain
ENV DOMAIN_HOME  ${DOMAIN_CONFIG}/domains/${DOMAIN_NAME}
ENV PROPERTIES_FILE ${ORACLE_BASE}/boot.properties
ENV HEALTH_SCRIPT_FILE ${ORACLE_BASE}/healthcheck.sh

COPY resources/properties/boot.properties ${ORACLE_BASE}
COPY resources/properties/create-wls-domain.py ${ORACLE_BASE}
COPY resources/scripts/entrypoint.sh ${ORACLE_BASE}
COPY resources/scripts/healthcheck.sh ${ORACLE_BASE}

RUN mkdir -p ${DOMAIN_CONFIG} && \
    mkdir -p ${DOMAIN_HOME} && \
    cd ${MW_HOME}/oracle_common/common/bin && \
    ./commEnv.sh && \
    ./wlst.sh -skipWLSModuleScanning -loadProperties $PROPERTIES_FILE  ${ORACLE_BASE}/create-wls-domain.py && \
    mkdir -p ${DOMAIN_HOME}/servers/AdminServer/security && \
    chown ${o_user}:${o_group} ${ORACLE_BASE}/entrypoint.sh ${ORACLE_BASE}/healthcheck.sh && \
    chmod -R  g+w  ${DOMAIN_HOME} && \
    USER=`awk '{print $1}' $PROPERTIES_FILE | grep username | cut -d "=" -f2` && \
    PASS=`awk '{print $1}' $PROPERTIES_FILE | grep password | cut -d "=" -f2` && \
    echo "username=${USER}" >> $DOMAIN_HOME/servers/AdminServer/security/boot.properties && \
    echo "password=${PASS}" >> $DOMAIN_HOME/servers/AdminServer/security/boot.properties && \
    ${DOMAIN_HOME}/bin/setDomainEnv.sh

USER ${o_user}
HEALTHCHECK --start-period=10s --timeout=30s --retries=10 CMD curl -k -s --fail `$HEALTH_SCRIPT_FILE` || exit 1

#EXPOSE 7001 7002
CMD ["/u01/app/oracle/entrypoint.sh"]
