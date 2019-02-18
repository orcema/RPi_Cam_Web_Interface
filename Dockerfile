FROM debian:jessie
MAINTAINER "Orce MARINKOVSKI" <orce00@gmail.com>
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV PATH="$PATH:/opt/vc/bin/raspimjpeg"
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/vc/lib
RUN apt-get update -y && apt-get install -y curl wget git sudo psmisc dialog nginx php5-fpm php5-cli php5-common php-apc apache2-utils gpac motion zip libav-tools gstreamer1.0-tools net-tools nano
RUN mkdir -p /rpi-cam-web
WORKDIR /opt
RUN git clone https://github.com/orcema/RPi_Cam_Web_Interface.git && chmod u+x RPi_Cam_Web_Interface/*.sh && RPi_Cam_Web_Interface/install.sh q
WORKDIR /opt/RPi_Cam_Web_Interface
CMD ./start.sh;tail -f /dev/null
