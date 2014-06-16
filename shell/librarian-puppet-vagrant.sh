#!/bin/bash

SCRIPT_ROOT=$(echo "$1")

OS=$(/bin/bash /tmp/os-detect.sh ID)
CODENAME=$(/bin/bash /tmp/os-detect.sh CODENAME)

# Directory in which librarian-puppet should manage its modules directory
PUPPET_DIR=/etc/puppet/

$(which git > /dev/null 2>&1)
FOUND_GIT=$?

if [ "$FOUND_GIT" -ne '0' ] && [ ! -f /var/puppet-init/librarian-puppet-installed ]; then
    $(which apt-get > /dev/null 2>&1)
    FOUND_APT=$?
    $(which yum > /dev/null 2>&1)
    FOUND_YUM=$?

    echo 'Installing git'

    if [ "${FOUND_YUM}" -eq '0' ]; then
        yum -q -y makecache
        yum -q -y install git
    else
        apt-get -q -y install git-core
    fi

    echo 'Finished installing git'
fi

if [[ ! -d "$PUPPET_DIR" ]]; then
    mkdir -p "$PUPPET_DIR"
    echo "Created directory $PUPPET_DIR"
fi

cp "$SCRIPT_ROOT/../puppet/Puppetfile" "$PUPPET_DIR"
echo "Copied Puppetfile"

if [ "$OS" == 'debian' ] || [ "$OS" == 'ubuntu' ]; then
    if [[ ! -f /var/puppet-init/librarian-base-packages ]]; then
        echo 'Installing base packages for librarian'
        apt-get install -y build-essential ruby-dev 
        echo 'Finished installing base packages for librarian'

        touch /var/puppet-init/librarian-base-packages
    fi
fi

if [ "$OS" == 'ubuntu' ]; then
    if [ "$CODENAME" == 'precise' ] && [ ! -f /var/puppet-init/librarian-libgemplugin-ruby ]; then
        echo 'Updating libgemplugin-ruby (Ubuntu only)'
        apt-get install -y libgemplugin-ruby
        echo 'Finished updating libgemplugin-ruby (Ubuntu only)'

        touch /var/puppet-init/librarian-libgemplugin-ruby
    fi

    if [ "$CODENAME" == 'lucid' ] && [ ! -f /var/puppet-init/librarian-rubygems-update ]; then
        echo 'Updating rubygems (Ubuntu Lucid only)'
        echo 'Ignore all "conflicting chdir" errors!'
        gem install rubygems-update
        /var/lib/gems/1.8/bin/update_rubygems
        echo 'Finished updating rubygems (Ubuntu Lucid only)'

        touch /var/puppet-init/librarian-rubygems-update
    fi
fi

cd "$PUPPET_DIR"

if [[ ! -f /var/puppet-init/librarian-puppet-installed ]]; then
    echo 'Installing librarian-puppet 1.0.3 because 1.1.x is causing some issues at the moment'
    gem install librarian-puppet -v1.0.3
    echo 'Finished installing librarian-puppet'

    echo 'Running initial librarian-puppet'
    librarian-puppet install --clean
    echo 'Finished running initial librarian-puppet'

    touch /var/puppet-init/librarian-puppet-installed
else
    sha1sum -c /var/puppet-init/Puppetfile.sha1
    if [[ $? > 0 ]]
    then
        echo 'Running update librarian-puppet'
        librarian-puppet update
        echo 'Finished running update librarian-puppet'
    else
        echo 'Skipping librarian-puppet (Puppetfile unchanged)'
    fi
fi

sha1sum Puppetfile > /var/puppet-init/Puppetfile.sha1
