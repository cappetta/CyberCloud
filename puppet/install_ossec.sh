#!/bin/bash
# REF: https://mig5.net/content/trying-automate-initial-ossec-installation-steps
# Variables
VERSION=2.7.1
CHECKSUM="ossec-hids-${VERSION}-checksum.txt"
TARBALL="ossec-hids-${VERSION}.tar.gz"


echo "Downloading packages and checksums"
wget http://www.ossec.net/files/${TARBALL}
wget http://www.ossec.net/files/${CHECKSUM}

echo "These are the checksums from the file"
cat $CHECKSUM
OSSEC_MD5=$(md5sum $TARBALL | awk {'print $1'})
OSSEC_SHA=$(sha1sum $TARBALL | awk {'print $1'})
echo "checking for matching md5/sha sums"

grep $OSSEC_MD5 $CHECKSUM
if [ $? -eq 1 ]; then
  echo "md5sum didn't match"!
  exit 1
fi


grep $OSSEC_SHA $CHECKSUM
if [ $? -eq 1 ]; then
  echo "sha1sum didn't match"!
  exit 1
fi

# sums matched, extract and run install
tar zxfv $TARBALL

builtin cd ossec-hids-${VERSION}

sudo bash install.sh