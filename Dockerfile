FROM i386/ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Berlin

ADD scripts/snx_install.sh /root

RUN apt-get update && apt-get install -y bzip2 kmod libpam0g:i386 libx11-6:i386 libstdc++6:i386 libstdc++5:i386 libnss3-tools expect build-essential linux-headers-$(uname -r)

RUN mkdir faketun && cd faketun \
    && echo -e "#include\nstatic int start__module(void) {return 0;}\nstatic void end__module(void){return;}\nmodule_init(start__module);\nmodule_exit(end__module);">tun.c \
    %% echo -e "obj-m += tun.o\nall:\n\tmake -C /lib/modules/\$(shell uname -r)/build/ M=\$(PWD) modules\nclean:\n\tmake -C /lib/modules/\$(shell uname -r)/build/ M=\$(PWD) clean\nclean-files := Module.symvers">Makefile \
    && make \
    && install tun.ko /lib/modules/$(uname -r)/kernel/net/tun.ko \
    && depmod -a \
    && modprobe tun

RUN cd /root && bash -x snx_install.sh

ADD scripts/snx.sh /root

RUN chmod +x /root/snx.sh

CMD ["/root/snx.sh"]
