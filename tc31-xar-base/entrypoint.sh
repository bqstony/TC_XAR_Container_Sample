#!/bin/sh
# SPDX-License-Identifier: Zero-Clause BSD

# Exit immediately if a command exits with a non-zero status
set -e

# Indicate the script's start for logging purposes
echo "Starting TcSystemServiceUm..."

# Replaces the shell process with the TcSystemServiceUm process, ensuring proper signal handling
# 0x4 is FastAsPossible, 0x5 is Test, 0x7 should be realtime
if [ "$TC_RUN_MODE" = 'FAST_AS_POSSIBLE' ];  then
    echo "Starting TcSystemServiceUm FastAsPossible"
    exec /usr/bin/TcSystemServiceUm -f 0x4 -i "${AMS_NETID}" -p /var/run/TcSystemServiceUm.pid
elif [ "$TC_RUN_MODE" = 'TEST' ]; then
    echo "Starting TcSystemServiceUm Test"
    exec /usr/bin/TcSystemServiceUm -f 0x5 -i "${AMS_NETID}" -p /var/run/TcSystemServiceUm.pid
else
    # $TC_RUN_MODE = REALTIME
    echo "Starting TcSystemServiceUm Realtime"
    exec /usr/bin/TcSystemServiceUm -f 0x7 -i "${AMS_NETID}" -p /var/run/TcSystemServiceUm.pid
fi