#!/bin/bash
set -e

echo "Genarate JENKINS SSH KEY"
source /usr/local/bin/generate_key.sh
echo "start JENKINS"
if [ "x$1" == "x" ]; then
    exec /bin/tini -- /usr/local/bin/jenkins.sh --prefix=/jenkins
fi
exec "$@"
