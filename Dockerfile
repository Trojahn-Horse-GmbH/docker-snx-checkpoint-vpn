FROM i386/ubuntu:18.04

SHELL ["/usr/bin/linux32", "/bin/sh", "-c"]

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Berlin

ADD scripts/snx_install.sh /root

RUN apt-get update && apt-get install -y bzip2 kmod libpam0g:i386 libx11-6:i386 libstdc++6:i386 libstdc++5:i386 libnss3-tools expect iproute2 iptables iputils-ping net-tools 

RUN cd /root && bash -x snx_install.sh

ADD scripts/snx.sh /root

RUN chmod +x /root/snx.sh

CMD ["/root/snx.sh"]
