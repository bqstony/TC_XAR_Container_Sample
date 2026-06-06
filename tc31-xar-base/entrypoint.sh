#!/bin/sh
# SPDX-License-Identifier: Zero-Clause BSD

# Exit immediately if a command exits with a non-zero status
set -e

# Start a tiny syslog daemon so TcSystemServiceUm's syslog() calls (the
# Linux-side equivalent of the Windows TwinCAT System Event Logger) land
# on the container's stdout — `docker logs` then surfaces them alongside
# the runtime's own stdout output.
#   -n        run in foreground (keeps inherited fds alive)
#   -f /dev/null  ignore /etc/syslog.conf (Debian ships one that would
#                 otherwise route facilities to /var/log/syslog etc. and
#                 override -O)
#   -O -      write all log lines to syslogd's stdout, which is this
#                 script's stdout (PID 1), i.e. the container pipe
#                 surfaced by `docker logs`
#   -S        compact output (drop redundant timestamp/host fields)
if command -v busybox >/dev/null 2>&1 && [ ! -S /dev/log ]; then
    busybox syslogd -n -S -f /dev/null -O - &
fi


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