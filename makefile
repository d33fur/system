SHELL := /bin/bash

.PHONY: wol
wol:
	@wakeonlan -i 46.146.229.74 -p 9 fc:aa:14:29:f3:b8

.PHONY: ssh
ssh:
	@ssh drama@46.146.229.74

.PHONY: shutdown
shutdown:
	@ssh drama@46.146.229.74 "echo 'Gjkbyf888' | sudo -S shutdown -h now"