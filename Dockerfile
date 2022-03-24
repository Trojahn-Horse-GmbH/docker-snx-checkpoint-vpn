FROM ubuntu:18.04

ADD scripts/snx_install.sh /root

RUN dpkg --add-architecture i386 && apt-get update && apt-get install -y bzip2 kmod libpam0g:i386 libx11-6:i386 libstdc++6:i386 libstdc++5:i386 libnss3-tools expect python-pip

RUN cd /root && bash -x snx_install.sh

RUN pip install snxvpn

ADD scripts/snx.sh /root

RUN chmod +x /root/snx.sh

CMD ["/root/snx.sh"]
