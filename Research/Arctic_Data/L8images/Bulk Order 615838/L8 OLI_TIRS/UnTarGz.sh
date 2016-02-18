#!/bin/bash

find ./ -name "*.gz" -exec gunzip '{}' \;

find . -name "*tar" -print0|xargs -0 -I {} basename {} .tar|xargs mkdir

find . -type d -name "L*" -exec mv '{}'.tar '{}' \;

find . -name "*tar" -print0|xargs -0 -I {} basename {} .tar|xargs -I file tar -xvf ./file/file.tar -C ./file
