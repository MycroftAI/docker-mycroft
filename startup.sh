#!/bin/bash
source /opt/mycroft/.venv/bin/activate
/opt/mycroft/./start-mycroft.sh all

tail -f /var/log/mycroft/*.log
