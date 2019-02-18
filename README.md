Web based interface for controlling the Raspberry Pi Camera, includes motion detection, time lapse, and image and video recording.
Current version 6.4.48
All information on this project can be found here: http://www.raspberrypi.org/forums/viewtopic.php?f=43&t=63276

The wiki page can be found here:

http://elinux.org/RPi-Cam-Web-Interface

This includes the installation instructions at the top and full technical details.

docker build command
>sudo docker build -t img_rpi_cam_web_om .
docker install command
>sudo docker run -d --name=rpi_cam_web_om  -p=81:80/tcp --volume=/opt/vc:/opt/vc --device=/dev/vchiq --device=/dev/vcsm rpi_cam_web_om
  
