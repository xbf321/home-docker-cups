ARG MAINTAINER
FROM debian:testing-slim
MAINTAINER $MAINTAINER

# Install Packages (basic tools, cups, basic drivers, HP drivers)
RUN apt-get update \
&& apt-get install -y \
  vim \
  sudo \
  whois \
  usbutils \
  cups \
  cups-client \
  cups-bsd \
  cups-filters \
  foomatic-db-compressed-ppds \
  printer-driver-all \
  openprinting-ppds \
  hpijs-ppds \
  hp-ppd \
  hplip \
  smbclient \
  printer-driver-cups-pdf \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Add user and disable sudo password checking
RUN useradd \
  --groups=sudo,lp,lpadmin \
  --create-home \
  --home-dir=/home/print \
  --shell=/bin/bash \
  --password=$(mkpasswd print) \
  print \
&& sed -i '/%sudo[[:space:]]/ s/ALL[[:space:]]*$/NOPASSWD:ALL/' /etc/sudoers

COPY ./drivers /home/drivers
RUN dpkg -i /home/drivers/pantum-2200_1.1.99.deb

# Copy the default configuration file
COPY --chown=root:lp cupsd.conf /etc/cups/cupsd.conf
COPY --chown=root:lp printers.conf /etc/cups/printers.conf

# Default shell
CMD ["/usr/sbin/cupsd", "-f"]