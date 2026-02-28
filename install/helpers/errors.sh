#!/usr/bin/env bash

set -eEo pipefail

trap 'error_msg "Command failed at line $LINENO. Installation aborted."; exit 1' ERR
