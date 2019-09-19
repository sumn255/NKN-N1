#!/bin/sh

systemctl daemon-reload
mv /etc/udev/rules.d/99-local.rules.1 /etc/udev/rules.d/99-local.rules
udevadm control --reload-rules
sed -i '/firstboot/d' /etc/rc.local