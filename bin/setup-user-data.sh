#!/bin/bash -e

CMD="./bin/make-mime.py"

for file in `ls aws/src/*`; do

  CMD+=" -a $file:${file##*.}"
  echo $i
done

$CMD > aws/cloud-init.mime
