#!/bin/bash
set -e

echo "Genarate JENKINS SSH KEY"
source /usr/local/bin/generate_key.sh
echo "start JENKINS"
source /usr/local/bin/jenkins.sh
