ARG MAINTAINER
FROM olbat/cupsd
MAINTAINER $MAINTAINER

COPY ./drivers /home/drivers

RUN dpkg -i /home/drivers/pantum-2200_1.1.99.deb
