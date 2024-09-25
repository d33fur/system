SHELL := /bin/bash

include .env

.PHONY: up
up:
	@wakeonlan -i ${IP} -p ${PORT} ${MAC}

.PHONY: ssh
ssh:
	@ssh drama@${IP}

.PHONY: down
down:
	@ssh drama@${IP} "echo ${PASSWORD} | sudo -S shutdown -h now"

.PHONY: sleep
sleep:
	@ssh drama@${IP} "echo ${PASSWORD} | sudo -S systemctl suspend"

.PHONY: reboot
reboot:
	@ssh drama@${IP} "echo ${PASSWORD} | sudo -S reboot"

.PHONY: ping-port
ping-port:
	@nc -zv ${IP} ${PORT}

.PHONY: ping
ping:
	@ping ${IP}