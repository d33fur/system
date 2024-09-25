#!/bin/bash

LONG_PRESS_THRESHOLD=1

start_time=$(date +%s)

while [ $(grep -c "PBTN" /proc/acpi/event) -eq 1 ]; do
    sleep 0.1
done

end_time=$(date +%s)

duration=$((end_time - start_time))

if [ $duration -ge $LONG_PRESS_THRESHOLD ]; then
    systemctl poweroff
else
    systemctl suspend
fi

# sudo apt install acpid
# sudo systemctl enable acpid
# sudo systemctl start acpid

# sudo vim /etc/acpi/events/powerbtn

# пример файла
# event=button/power (PWR.||PBTN)
# action=/etc/acpi/powerbtn.sh

# sudo vim /etc/acpi/powerbtn-custom.sh
# sudo chmod +x /etc/acpi/powerbtn-custom.sh

# меняем в файле /etc/acpi/events/powerbtn action на наш
# sudo vim /etc/acpi/events/powerbtn
# action=/etc/acpi/powerbtn-custom.sh

# sudo systemctl restart acpid


# some logs
# system on git main took 7s
# > sudo systemctl stop acpid
# Stopping 'acpid.service', but its triggering units are still active:
# acpid.path, acpid.socket

# system on git main
# > sudo systemctl stop acpid.path

# system on git main
# > sudo systemctl stop acpid.socket

# system on git main
# > sudo systemctl stop acpid

# system on git main
# > sudo systemctl disable acpid.socket
# Removed "/etc/systemd/system/sockets.target.wants/acpid.socket".

# system on git main
# > sudo systemctl disable acpid.path
# Removed "/etc/systemd/system/paths.target.wants/acpid.path".