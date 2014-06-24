#!/bin/bash -e

PACKER=$(which packer)

if [ -z $PACKER ]; then
  echo "Packer not installed"
  exit 1
fi

if [ ! -x "./bin/make-mime.py" ] && [ ! -x "./bin/setup-user-data.sh" ]; then
  echo "Missing make-mime.py or setup-user-data.sh"
  exit 1
fi

if [ ! -z ${AWS_ACCESS_KEY_ID} ] && [ ! -z ${AWS_SECRET_ACCESS_KEY} ]; then
  echo "Make sure the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are defined"
  exit 1
fi

./bin/setup-user-data.sh
packer build Packerfile
