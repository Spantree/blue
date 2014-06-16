#!/bin/bash

OS=$(/bin/bash /tmp/os-detect.sh ID)
CODENAME=$(/bin/bash /tmp/os-detect.sh CODENAME)

while [ ! -f /var/lib/cloud/instance/boot-finished ] ; do
  sleep 10
  echo "sleeping for 10 seconds while cloud-init is running"
done
while sudo fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
  sleep 10
  echo "Waiting while apt is ran by cloud-init"
done

if [[ ! -d /var/puppet-init/ ]]; then
    mkdir /var/puppet-init
    echo "Created directory /var/puppet-init"

    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
        sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
    fi
fi

if [[ ! -f /var/puppet-init/initial-setup-repo-update ]]; then
    if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
        echo "Running initial-setup apt-get update"
        # apt-get update >/dev/null
        apt-get update && apt-get dist-upgrade -y
        apt-get -y autoremove
        touch /var/puppet-init/initial-setup-repo-update
        echo "Finished running initial-setup apt-get update"
    elif [[ "$OS" == 'centos' ]]; then
        echo "Running initial-setup yum update"
        yum update -y >/dev/null
        echo "Finished running initial-setup yum update"

        echo "Installing basic development tools (CentOS)"
        yum -y groupinstall "Development Tools" >/dev/null
        echo "Finished installing basic development tools (CentOS)"
        touch /var/puppet-init/initial-setup-repo-update
    fi
fi

if [[ "$OS" == 'ubuntu' && ("$CODENAME" == 'lucid' || "$CODENAME" == 'precise') && ! -f /var/puppet-init/ubuntu-required-libraries ]]; then
    echo 'Installing basic curl packages (Ubuntu only)'
    apt-get install -y curl unzip libcurl3 libcurl4-gnutls-dev 
    echo 'Finished installing basic curl packages (Ubuntu only)'

    touch /var/puppet-init/ubuntu-required-libraries
fi
