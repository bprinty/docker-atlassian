# ~
#
# Installs all software required for confluence server. Several
# pieces of this file were inspired by the great work done
# for the cptactionhank/atlassian-confluence image.
#
# @author <bprinty@gmail.com>
# @version 0.0.1
# ----------------------------------------------------


# meta
# ----
FROM openjdk:8
MAINTAINER bprinty@gmail.com


# environment
# -----------
ENV CONF_HOME     /var/atlassian/confluence
ENV CONF_INSTALL  /opt/atlassian/confluence
ENV CONF_VERSION  5.10.8


# install
# -------
RUN apt-get update --quiet
RUN apt-get install --yes --no-install-recommends libtcnative-1 xmlstarlet
RUN echo "Creating application directories." \
    && mkdir -p                "${CONF_HOME}" \
    && mkdir -p                "${CONF_INSTALL}"

RUN echo "Installing Confluence and MySQL connector." \
    && curl -L                "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz" | tar -xz --directory "${CONF_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -L                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${CONF_INSTALL}/confluence/WEB-INF/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && echo -e                 "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
                               "${CONF_INSTALL}/conf/server.xml" \
    && touch -d "@0"           "${CONF_INSTALL}/conf/server.xml"

 RUN echo "Updating permissions for installed components."\
    && chmod -R 700            "${CONF_HOME}" \
    && chmod -R 700            "${CONF_INSTALL}" \
    && chown -R daemon:daemon  "${CONF_HOME}" \
    && chown -R daemon:daemon  "${CONF_INSTALL}"


# clean
# -----
RUN apt-get clean


# exposure
# --------
USER daemon:daemon
EXPOSE 8090
WORKDIR /var/atlassian/confluence


# boot
# ----
CMD ["/opt/atlassian/confluence/bin/catalina.sh", "run"]
