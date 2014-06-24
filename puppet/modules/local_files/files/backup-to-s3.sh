#!/bin/bash -e

SRC_DIR="/srv/nexus/sonatype-work"
DATE=$(date +"%Y%m%d")

if [ -z ${AWS_ACCESS_KEY_ID} ] || [ -z ${AWS_SECRET_ACCESS_KEY} ]; then
  echo "Make sure the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY are defined for user: $(whoami)"
  exit 1
fi
aws s3 sync --delete $SRC_DIR "s3://spantree-nexus-backup/$DATE"  --exclude "*central/*"  --exclude "*central-m1/*"  --exclude "*apache-snapshots/*"  --exclude "*codehaus-snapshots/*"  --exclude "*public/*"  --exclude "*thirdparty/*" --exclude "*/indexer*" --exclude "*/felix-cache*"
