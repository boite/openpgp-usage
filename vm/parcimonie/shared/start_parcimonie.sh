#!/bin/sh

# Start parcimonie
PARCIMONIE_LOG=~/parcimonie/log/parcimonie.log
PARCIMONIE_ERR=~/parcimonie/log/parcimonie.err
DISPLAY=":0" DBUS_SESSION_BUS_ADDRESS="unix:path=/run/dbus/system_bus_socket" parcimonie 1>>$PARCIMONIE_LOG 2>>$PARCIMONIE_ERR &
