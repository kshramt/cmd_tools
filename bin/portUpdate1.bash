#!/bin/bash
echo portUpdate1.bash
date
port selfupdate
port upgrade outdated
sleep 111111
sudo nohup nice ./portUpdate2.bash &
