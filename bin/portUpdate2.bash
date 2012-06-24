#!/bin/bash
echo portUpdate2.bash
date
port selfupdate
port upgrade outdated
sleep 111111
sudo nohup nice ./portUpdate1.bash &
