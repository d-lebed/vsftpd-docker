#!/usr/bin/env bash

FTP_USER=${FTP_USER:-user}
FTP_PASS=${FTP_PASS:-pass}
FTP_LOGGING=${FTP_LOGGING:-NO}

# Prepare user and directory
addgroup -g 1212 $FTP_USER
adduser -D -h /home/vsftpd/$FTP_USER -s /bin/false -G $FTP_USER -u 1212 $FTP_USER
echo "$FTP_USER:$FTP_PASS" | /usr/sbin/chpasswd
chown -R $FTP_USER:$FTP_USER /home/vsftpd/$FTP_USER

# Prepare config file
CONFIG_FILE=/etc/vsftpd/vsftpd.conf

# Disable logging if FTP_LOGGING is not YES
if [ "$FTP_LOGGING" != "YES" ]; then
  sed -i 's/^xferlog_enable=.*/xferlog_enable=NO/' "$CONFIG_FILE"
  sed -i 's/^log_ftp_protocol=.*/log_ftp_protocol=NO/' "$CONFIG_FILE"
fi

# Copy environment variables starting with VSFTPD_ and append them to CONFIG_FILE file
for var in $(env | grep '^VSFTPD_'); do
  name=$(echo "$var" | awk -F= '{print $1}')
  value=$(echo "$var" | awk -F= '{print $2}')

  echo "${name#VSFTPD_}=$value" >> "$CONFIG_FILE"
done

cat << TXT
*******************************************************
*               Server configuration                  *
*******************************************************
TXT
cat "$CONFIG_FILE"
cat << TXT
*******************************************************
TXT

# Start logging if FTP_LOGGING is YES
if [ "$FTP_LOGGING" = "YES" ]; then
  echo "Enabling logging"

  LOG_FILE=`grep ^vsftpd_log_file $CONFIG_FILE | cut -d= -f2`
  touch $LOG_FILE
  tail -f $LOG_FILE >> /dev/stdout &
fi

# Run vsftpd
exec /usr/sbin/vsftpd $CONFIG_FILE
