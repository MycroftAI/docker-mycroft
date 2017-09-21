# Mycroft Docker Development Environment

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=btotharye&repoName=docker-mycroft&branch=master&pipelineName=docker-mycroft&accountName=btotharye&type=cf-1)]( https://g.codefresh.io/repositories/btotharye/docker-mycroft/builds?filter=trigger:build;branch:master;service:5952e3f0b2ad780001c3a603~docker-mycroft)

## Running image from dockerhub
This repo is updated on dockerhub at https://hub.docker.com/r/mycroftai/docker-mycroft/ and you can run it without building by simply running the below code.

Just replace the directory_on_local_machine with where you want the container mapped on your local machine, IE /home/user/mycroft for example if you created a mycroft folder in your home directory.  This is so the pairing file is stored outside the container.  If you wanted to run unstable then you would do `mycroftai/docker-mycroft:unstable` in the below command to run it on the unstable tag instead of latest which is the default.

`docker run -itd -p 8181:8181 -v directory_on_local_machine:/root/.mycroft mycroftai/docker-mycroft`

## Versions and Builds - Tags
**Latest** - Latest stable release currently [8.21](https://github.com/MycroftAI/mycroft-core/releases/tag/release%2Fv0.8.21)

**Unstable** - Latest unstable release currently [8.22](https://github.com/MycroftAI/mycroft-core/releases/tag/release%2Fv0.8.22)

## How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Build the docker image with 
   ```docker build -t ${USER}/mycroft .``` in the directory that you have checked out.
   
3. Run the following to start up mycroft:
   ```docker run -itd -p 8181:8181 ${USER}/mycroft```
   
4. Want a interactive cli session to register the device and test things, then run the following and type pair my device to start, we are mounting a local filesystem into the container so we can store our Identity file to reuse this same device over and over on new containers:
   ```docker run -it -p 8181:8181 -v /path_on_local_device:/root/.mycroft ${USER}/mycroft /bin/bash```
   
   Then you can run from inside the container:
   ```cli.sh``` to start up the cli, and type pair my device to pair it.

5. Confirm via docker ps that your container is up and serving port 8181, mycroft will already be running since its configured in the image to auto start:


```
docker ps
CONTAINER ID        IMAGE                                                COMMAND                  CREATED             STATUS              PORTS                                            NAMES
692219e23bf2        user/mycroft                                    "/mycroft/ai/mycro..."   3 seconds ago       Up 1 second         8181/tcp                                         amazing_borg
```


### CLI Access
You can interact with the CLI of the container by running the following command, this will connect you to the running container via bash:

```
docker exec -it container_name /bin/bash
```

Once in the container you can do ```./cli.sh``` to get a interactive CLI to interact with mycroft if needed.  Mycroft is started by default upon running container.

You can exit this container safely and leave it running by hitting cntrl + p + q, otherwise you can just hit cntrl+c to exit the cli and it will exit the container.  If you exit with cntrl + p + q it will leave the session open and running, still seeing issues attaching to sessions with previously running cli sessions though, so be advised.


You can get the container name via:

```
docker ps
```
You can exit this container safely and leave it running by hitting cntrl + p + q, otherwise you can just hit cntrl+c to exit the cli and it will exit the container.  If you exit with cntrl + p + q it will leave the session open and running, still seeing issues attaching to sessions with previously running cli sessions though, so be advised.


You can get the container name via:

```
docker ps
```
