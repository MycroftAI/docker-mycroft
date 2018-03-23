#!/bin/bash
/mycroft/ai/./start-mycroft.sh all
sleep 30s
python /mycroft/ai/mycroft/messagebus/send.py speak "'{"utterance": "pair my device"}'"
tail -f /mycroft/ai/scripts/logs/mycroft-skills.log
