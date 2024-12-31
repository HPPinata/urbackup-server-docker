#!/bin/bash
set -e
# Copy www-folder back, if folder is bind-mounted
cp -R /web-backup/* /usr/share/urbackup
# Specifying backup-folder location
echo "/backups" > /var/urbackup/backupfolder
# Set ZFS dataset if ENV variable is not empty
if [[ -v ZFS_DATASET ]]; then
	echo "$ZFS_DATASET" > /etc/urbackup/dataset
fi
# Giving the user and group "urbackup" the provided UID/GID
if [[ $PUID != "" ]]
then
	usermod -u $PUID -o urbackup
else
	usermod -u 101 -o urbackup
fi
if [[ $PGID != "" ]]
then
	groupmod -g $PGID -o urbackup
else
	groupmod -g 101 -o urbackup
fi
chown urbackup:urbackup /backups
chown urbackup:urbackup /var/urbackup
exec urbackupsrv "$@"
