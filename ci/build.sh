#!/usr/bin/env bash

set -eo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"

pushd "${SCRIPT_DIR}/../src" > /dev/null
  npm init -y
  npm install --save sns-validator
  npm install --save --save-exact @google-cloud/pubsub@2.6.0
popd > /dev/null