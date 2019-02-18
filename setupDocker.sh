DIRECTORY="/opt/config"
DOCKERFILE="/tmp/Dockerfile"

# create the config folder in  /opt
if [[ ! -e "$DIRECTORY" ]]; then
        sudo mkdir -p /opt/config
else
        echo "[INFO]    folder "."$DIRECTORY"." exists !";
fi

# remove dockerfile if exist in tmp folder
if [[ -f "$DOCKERFILE" ]]; then
        sudo rm "$DOCKERFILE"
fi

cd /tmp

# get docker file
wget -q https://raw.githubusercontent.com/orcema/RPi_Cam_Web_Interface/master/Dockerfile

# build docker image
sudo docker build -t img_rpi_cam_web_om .

#setup docker container
sudo docker run -d --name=rpi_cam_web_om -p=81:80/tcp --volume=/opt/vc:/opt/vc --volume=/opt/config:/opt/config --device=/dev/vchiq --device=/dev/vcsm img_rpi_cam_web_om