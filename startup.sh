#!/bin/bash
trap exit SIGINT

/opt/mycroft/./start-mycroft.sh all
tail -f /opt/mycroft/scripts/logs/mycroft-skills.log
