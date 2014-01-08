#!/bin/bash

TZ='Europe/London'
USR='vagrant'

if grep --quiet --files-with-matches $TZ /etc/timezone;
then
  echo "Looks like the timezone is set to $TZ. Good."
else
  echo 'Setting timezone ...'
  echo $TZ | tee /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata
  echo '... done setting timezone!'
fi

apt-get -q update
apt-get -V -y install parcimonie

if [ -d /home/$USR/parcimonie ]
then
  echo "Looks like /home/$USR/parcimonie exists. Good!"
else
  echo "Creating /home/$USR/parcimonie ..."
  su -c "mkdir ~/parcimonie" - $USR
  echo "... copying files to /home/$USR/parcimonie ..."
  su -c "cp /home/$USR/host_share/logrotate.conf ~/parcimonie/" - $USR
  su -c "cp /home/$USR/host_share/start_parcimonie.sh ~/parcimonie/ && chmod u+x ~/parcimonie/start_parcimonie.sh" - $USR
fi

if [ -d /home/$USR/parcimonie/log ]
then
  echo "Looks like /home/$USR/parcimonie/log exists. Good!"
else
  echo "Creating /home/$USR/parcimonie/log ..."
  su -c "mkdir ~/parcimonie/log" - $USR
fi

if [ -d /home/$USR/.gnupg ]
then
  echo "Looks like /home/$USR/.gnupg exists. Good!"
else
  echo "Creating /home/$USR/.gnupg ..."
  su -c "gpg -qk" - $USR
  echo '... fetching a better GnuPG configuration file from github boite/openpgp-usage ...'
  su -c "wget --no-check-certificate -q -O - https://raw.github.com/boite/openpgp-usage/master/conf/gpg.conf > ~/.gnupg/gpg.conf" - $USR
  echo '... fetching sks-keyservers.netCA.pem ...'
  su -c "wget --no-check-certificate -q -P ~/.gnupg https://sks-keyservers.net/sks-keyservers.netCA.pem{.asc,}" - $USR
  echo '... updating gpg.conf with the path to sks-keyservers.netCA.pem ...'
  su -c "sed -i 's@ca\-cert\-file=sks\-keyservers\.netCA\.pem@ca\-cert\-file=/home/"$USR"/.gnupg/sks\-keyservers\.netCA\.pem@' ~/.gnupg/gpg.conf" - $USR
fi
