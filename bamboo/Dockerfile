# ~
#
# Installs all software required for bamboo server.
#
# @author <bprinty@gmail.com.com>
# @version 0.0.1
# ----------------------------------------------------


# meta
# ----
FROM ubuntu:trusty
MAINTAINER bprinty@gmail.com


# environment
# -----------
ENV PATH /sbin:/usr/sbin:/usr/lib:/usr/bin:/bin:/usr/local/bin
ENV HOME /home


# install
# -------
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 51716619E084DAB9
RUN dpkg --configure -a --force-all
RUN echo "deb http://us.archive.ubuntu.com/ubuntu precise main universe" >> /etc/apt/sources.list
RUN apt-get --force-yes -y update


# clean
# -----
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# boot
# ----
CMD []

