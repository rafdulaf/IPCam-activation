# IPCam-activation
Shell that activate/deactivate motion detection on IP cam, depending if smartphones are present on wifi

Copy the script "watch-ip-cam.sh" to your home directory and add it to your crontab (using "crontab -e") and adding:
    * * * * * /home/pi/watch-ip-cam.sh >/tmp/log 2>&1