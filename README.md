# Mycroft Docker Development Environment

### How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Build the docker image with 
   ```docker build -t <yourusername>/mycroft .``` in the directory that you have checked out.

3. If you would rather have an interactive session (for testing, coding, or whatever) with the docker container, start the container with 
   ```docker run --device /dev/snd:/dev/snd --privileged -it <youruser>/mycroft /bin/bash```
   
4. Now you can run /mycroft/ai/start.sh  to start up the service, and then run cli to test it.  The available syntax for this command is:

```
Quickly start, stop or restart Mycroft's esential services in detached screens

usage: /mycroft/ai/mycroft.sh [-h] (start [-v|-c]|stop|restart)
      -h             this help message
      start          starts mycroft-service, mycroft-skills, mycroft-voice and mycroft-cli in quiet mode
      start -v       starts mycroft-service, mycroft-skills and mycroft-voice
      start -c       starts mycroft-service, mycroft-skills and mycroft-cli in background
      start -d       starts mycroft-service and mycroft skills in quiet mode and an active mycroft-cli
      stop           stops mycroft-service, mycroft-skills and mycroft-voice
      restart        restarts mycroft-service, mycroft-skills and mycroft-voice

screen tips:
            run 'screen -list' to see all running screens
            run 'screen -r <screen-name>' (e.g. 'screen -r mycroft-service') to reatach a screen
            press ctrl + a, ctrl + d to detace the screen again
            See the screen man page for more details
```

