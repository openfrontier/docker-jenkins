#!/bin/bash
set -e

echo "Genarate JENKINS SSH KEY"
source /usr/local/bin/generate_key.sh
echo "start JENKINS"
var_cmd_start=`echo $@|cut -c 1-2`
if [ "${var_cmd_start}" == "--" ]; then
    exec /bin/tini -- /usr/local/bin/jenkins.sh $@
fi
exec "$@"
