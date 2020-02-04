#!/bins/bash -e
systemctl daemon-reload
systemctl disable hostapd.service
systemctl disable gpsd.socket gpsd.service
systemctl disable ntp.service
if [ "$AVNAV_DAILY" != "1" ] ; then
	apt install -y avnav avnav-raspi
else
	base="https://www.wellenvogel.de/software/avnav/downloads/daily/latest"
	curl -k -o /tmp/avnav.deb  "$base/avnav_latest_all.deb" || exit 1
	curl -k -o /tmp/avnav-raspi.deb "$base/avnav-raspi_latest_all.deb" || exit 1
	dpkg -i /tmp/avnav.deb
	dpkg -i /tmp/avnav-raspi.deb
fi

