#!/bin/bash

set -eo pipefail

echo "Installing dependencies ..."
# dependencies
apt-get update
apt-get install -y gnupg
echo "Installing Google Chrome ..."
# installing chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
apt-get install -y ./google-chrome-stable_current_amd64.deb

echo "Purge apt packages"
apt-get clean -y && apt-get autoremove -y
rm -rf google-chrome-stable_current_amd64.deb

echo "Configuring Google Chrome headless"
sed -i 's|HERE/chrome"|HERE/google-chrome-stable" --no-sandbox --user-data-dir|g' $CHROME_BIN

echo "Done!"

