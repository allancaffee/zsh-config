#!/bin/sh
##
## debian_functions.sh
## 
## Made by Allan Caffee
## Login   <allan@laptop.localdomain>
## 
## Started on  Thu Sep 11 07:14:48 2008 Allan Caffee
## Last update Thu Sep 11 07:14:48 2008 Allan Caffee
##

## Update the listing of packages and then retrieve any updated packages.
deb_update()
{
	sudo apt-get update --quiet --assume-yes
	sudo apt-get upgrade --quiet --assume-yes --fix-broken
}
