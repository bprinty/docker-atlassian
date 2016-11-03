# ~
#
# Installs all software required for bamboo server. Several
# pieces of this file were inspired by the great work done
# for the cptactionhank/atlassian-bamboo image.
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
ENV BAMBOO_HOME     /var/atlassian/bamboo
ENV BAMBOO_INSTALL  /opt/atlassian/bamboo
ENV BAMBOO_VERSION  5.14.0.2


# install
# -------
RUN apt-get update --quiet
RUN apt-get install --yes --no-install-recommends libtcnative-1 git-core xmlstarlet
RUN echo "Creating application directories." \
    && mkdir -p                "${BAMBOO_HOME}" \
    && mkdir -p                "${BAMBOO_INSTALL}"

RUN echo "Installing Bamboo and MySQL connector." \
    && curl -L               "https://www.atlassian.com/software/bamboo/downloads/binary/atlassian-bamboo-${BAMBOO_VERSION}.tar.gz" | tar -zx --directory  "${BAMBOO_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -L                "https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.38.tar.gz" | tar -xz --directory "${BAMBOO_INSTALL}/lib" --strip-components=1 --no-same-owner "mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar" \
    && sed --in-place         's/^# umask 0027$/umask 0027/g' "${BAMBOO_INSTALL}/bin/setenv.sh" \
    && xmlstarlet             ed --inplace \
        --delete              "Server/Service/Engine/Host/@xmlValidation" \
        --delete              "Server/Service/Engine/Host/@xmlNamespaceAware" \
                              "${BAMBOO_INSTALL}/conf/server.xml" \
    && touch -d "@0"          "${BAMBOO_INSTALL}/conf/server.xml"

 RUN echo "Updating permissions for installed components."\
    && chmod -R 700            "${BAMBOO_HOME}" \
    && chmod -R 700            "${BAMBOO_INSTALL}" \
    && chown -R daemon:daemon  "${BAMBOO_HOME}" \
    && chown -R daemon:daemon  "${BAMBOO_INSTALL}"


# clean
# -----
RUN apt-get clean


# exposure
# --------
USER daemon:daemon
EXPOSE 8085 54663
WORKDIR /var/atlassian/bamboo


# boot
# ----
CMD ["/opt/atlassian/bamboo/bin/start-bamboo.sh", "-fg"]
