# Mycroft Docker Development Environment

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=btotharye&repoName=docker-mycroft&branch=master&pipelineName=docker-mycroft&accountName=btotharye&type=cf-1)]( https://g.codefresh.io/repositories/btotharye/docker-mycroft/builds?filter=trigger:build;branch:master;service:5952e3f0b2ad780001c3a603~docker-mycroft) [![Build Status](https://travis-ci.org/MycroftAI/docker-mycroft.svg?branch=master)](https://travis-ci.org/MycroftAI/docker-mycroft)

## Running image from dockerhub
This repo is updated on dockerhub at https://hub.docker.com/r/mycroftai/docker-mycroft/ and you can run it without building by simply running the below code.

Just replace the directory_on_local_machine with where you want the container mapped on your local machine, IE /home/user/mycroft for example if you created a mycroft folder in your home directory.  This is so the pairing file is stored outside the container.  

`docker run --name=mycroft -itd -p 8181:8181 -v directory_on_local_machine:/root/.mycroft mycroftai/docker-mycroft`

## How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Build the docker image with
   ```docker build -t mycroft .``` in the directory that you have checked out.

3. Run the following to start up mycroft:
   ```docker run --name mycroft --device /dev/snd:/dev/snd -itd -p 8181:8181 mycroft```

4. Want a interactive cli session to register the device and test things, then run the following and type pair my device to start, we are mounting a local filesystem into the container so we can store our Identity file to reuse this same device over and over on new containers:
   ```docker run --name mycroft -it -p 8181:8181 -v /path_on_local_device:/root/.mycroft mycroft /bin/bash```

Then you can run from inside the container:
```cli.sh``` to start up the cli, and type pair my device to pair it.

5. Confirm via docker ps that your container is up and serving port 8181:


```
docker ps
CONTAINER ID        IMAGE                                                COMMAND                  CREATED             STATUS              PORTS                                            NAMES
692219e23bf2        mycroft                                    "/mycroft/ai/mycro..."         3 seconds ago         Up 1 second           0.0.0.0:8181->8181/tcp                          mycroft
```
6. You should now have a running instance of mycroft that you can interact with via the cli, etc.

## Pairing Instance
After the container has been started you can do ```docker logs --follow mycroft``` and look for the line that says Pairing Code and use this to pair at https://home.mycroft.ai

You can exit out of this docker log command by hitting cntrl + c, the --follow basically turns it into a real tail instead of a cat of the log.


### CLI Access
You can interact with the CLI of the container by running the following command, this will connect you to the running container via bash:

```
docker exec -it mycroft /bin/bash
```

Once in the container you can do ```./start-mycroft.sh cli``` to get a interactive CLI to interact with mycroft if needed.  Mycroft is started by default upon running container.

You can exit this container safely and leave it running by hitting cntrl + p + q, otherwise you can just hit cntrl+c to exit the cli and it will exit the container.  If you exit with cntrl + p + q it will leave the session open and running, still seeing issues attaching to sessions with previously running cli sessions though, so be advised.


You can get the container name via:

```
docker ps
```
