#!/bin/bash

function mssql-show-short-info {
  echo "MS SQL install script for Hassbian."
}

function mssql-show-long-info {
  echo "Installs the MS SQL database engine and dependencies for use with the recorder component in Home Assistant."
}

function mssql-show-copyright-info {
  echo "Copyright(c) 2017 Fredrik Lindqvist <https://github.com/Landrash>."
}

function mssql-install-package {
mssql-show-short-info
mssql-show-copyright-info

echo "Running apt-get preparation"
apt-get update
apt-get install -y freetds-dev


echo "Changing to homeassistant user"
sudo -u homeassistant -H /bin/bash <<EOF

echo "Changing to Home Assistant venv"
source /srv/homeassistant/bin/activate

echo "Installing dependencies for MS SQL"
pip3 install --upgrade setuptools wheel
pip3 install pymssql

echo "Deactivating virtualenv"
deactivate
EOF

echo "Checking the installation..."
validation=$(sudo -u homeassistant -H /bin/bash << EOF | grep Version | awk '{print $2}'
source /srv/homeassistant/bin/activate
pip3 show pymssql
EOF
)
if [ ! -z "${validation}" ]; then
  echo
  echo -e "\\e[32mInstallation done..\\e[0m"
  echo
  echo "No database or database user is created during this setup and will need to be created manually."
  echo
  echo "To continue have a look at https://home-assistant.io/components/recorder/"
  echo
else
  echo
  echo -e "\\e[31mInstallation failed..."
  echo -e "\\e[31mAborting..."
  echo -e "\\e[0mIf you have issues with this script, please say something in the #devs_hassbian channel on Discord."
  echo
  return 1
fi
return 0
}

[[ "$_" == "$0" ]] && echo "hassbian-config helper script; do not run directly, use hassbian-config instead"
