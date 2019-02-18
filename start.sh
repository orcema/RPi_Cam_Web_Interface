#!/bin/bash

# Copyright (c) 2015, Bob Tidey
# All rights reserved.

# Redistribution and use, with or without modification, are permitted provided
# that the following conditions are met:
#    * Redistributions of source code must retain the above copyright
#      notice, this list of conditions and the following disclaimer.
#    * Neither the name of the copyright holder nor the
#      names of its contributors may be used to endorse or promote products
#      derived from this software without specific prior written permission.

# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY
# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

# Description
# This script stops a running RPi_Cam interface
# Based on RPI_Cam_Web_Interface installer by Silvan Melchior
# Edited by jfarcher to work with github
# Edited by slabua to support custom installation folder
# Additions by btidey, miraaz, gigpi
# Split up and refactored by Bob Tidey 

# config folder external to docker
configFolder="/opt/config/rpi_web_cam"

#Debug enable next 3 lines
exec 5> start.txt
BASH_XTRACEFD="5"
set -x

cd $(dirname $(readlink -f $0))

source ./config.txt
fn_servicesUp()
{
	sudo service php5-fpm start
	sudo service nginx start
}

fn_init()
{
	echo /opt/vc/lib > /etc/ld.so.conf.d/pi_vc_core.conf && ldconfig

	# init file raspimjpeg in config folder external to docker
	if [[ ! -f "$configFolder"/raspimjpeg ]]; then
			sudo cp etc/raspimjpeg/raspimjpeg.1 "$configFolder"/raspimjpeg
	fi	
	sudo cp "$configFolder"/raspimjpeg /etc/raspimjpeg

	# init file motion.conf in config folder external to docker
	if [[ ! -f "$configFolder"/motion.conf ]]; then
			sudo cp etc/motion/motion.conf.1 "$configFolder"/motion.conf
	fi	
	sudo cp "$configFolder"/motion.conf /etc/motion/motion.conf
	
	
	sudo cp nginx/default /etc/nginx/sites-enabled/default
	
}

fn_stop ()
{ # This is function stop
   sudo killall raspimjpeg 2>/dev/null
   sudo killall php 2>/dev/null
   sudo killall motion 2>/dev/null
}

#start operation
fn_stop
fn_init
fn_servicesUp


sudo mkdir -p /dev/shm/mjpeg
sudo chown www-data:www-data /dev/shm/mjpeg
sudo chmod 777 /dev/shm/mjpeg
sleep 1;sudo su -c 'raspimjpeg > /dev/null &' www-data
if [ -e /etc/debian_version ]; then
   sleep 1;sudo su -c "php /var/www/$rpicamdir/schedule.php > /dev/null &" www-data
else
   sleep 1;sudo su -c '/bin/bash' -c "php /var/www/$rpicamdir/schedule.php > /dev/null &" www-data
fi
