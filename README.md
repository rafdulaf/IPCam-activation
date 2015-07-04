# IPCam-activation
Shell that activate/deactivate motion detection on IP cam, depending if smartphones are present on wifi

Copy the script "watch-ip-cam.sh" to your home directory, makes it executable (chmod a+x *.sh) and add it to your crontab (using "crontab -e") and adding:
    * * * * * /home/pi/watch-ip-cam.sh >/tmp/log 2>&1

As my raspberrypi has network issues with wifi, I added a watch-network.sh script to monitor the connection and reboot if necessary. So also copy this script to your home directory, makes it executable and add to crontab:
    * * * * * /home/pi/watch-network.sh >/tmp/logwifi 2>&1
This scrip will reboot if network is lost. To avoid cycling reboot, it will wait for 5 minutes between reboots.
