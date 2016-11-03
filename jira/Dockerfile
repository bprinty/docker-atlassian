# ~
#
# Installs all software required for jira server. Several
# pieces of this file were inspired by the great work done
# for the cptactionhank/atlassian-jira image.
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
ENV JIRA_HOME     /var/atlassian/jira
ENV JIRA_INSTALL  /opt/atlassian/jira
ENV JIRA_VERSION  7.2.3


# install
# -------
RUN apt-get update --quiet
RUN apt-get install --yes --no-install-recommends libtcnative-1 xmlstarlet
RUN echo "Creating application directories." \
    && mkdir -p                "${JIRA_HOME}" \
    && mkdir -p                "${JIRA_INSTALL}"

RUN echo "Installing JIRA and MySQL connector." \
    && curl -L                "https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-core-${JIRA_VERSION}.tar.gz" | tar -xz --directory "${JIRA_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -L                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${JIRA_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && sed --in-place          "s/java version/openjdk version/g" "${JIRA_INSTALL}/bin/check-java.sh" \
    && echo -e                 "\njira.home=$JIRA_HOME" >> "${JIRA_INSTALL}/atlassian-jira/WEB-INF/classes/jira-application.properties" \
    && touch -d "@0"           "${JIRA_INSTALL}/conf/server.xml"

 RUN echo "Updating permissions for installed components."\
    && chmod -R 700            "${JIRA_HOME}" \
    && chmod -R 700            "${JIRA_INSTALL}" \
    && chown -R daemon:daemon  "${JIRA_HOME}" \
    && chown -R daemon:daemon  "${JIRA_INSTALL}"


# clean
# -----
RUN apt-get clean


# exposure
# --------
USER daemon:daemon
EXPOSE 8080
WORKDIR /var/atlassian/jira


# boot
# ----
CMD ["/opt/atlassian/jira/bin/catalina.sh", "run"]
