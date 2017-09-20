# Mycroft Docker Development Environment

[![Codefresh build status]( https://g.codefresh.io/api/badges/build?repoOwner=btotharye&repoName=docker-mycroft&branch=master&pipelineName=docker-mycroft&accountName=btotharye&type=cf-1)]( https://g.codefresh.io/repositories/btotharye/docker-mycroft/builds?filter=trigger:build;branch:master;service:5952e3f0b2ad780001c3a603~docker-mycroft)

## How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Build the docker image with 
   ```docker build -t ${USER}/mycroft .``` in the directory that you have checked out.
   
3. Run the following to start up mycroft:
   ```docker run --device -itd ${USER}/mycroft```
   
4. Want a interactive cli session to register the device and test things, then run the following and type pair my device to start, we are mounting a local filesystem into the container so we can store our Identity file to reuse this same device over and over on new containers:
   ```docker run -it -p 8181:8181 -v /path_on_local_device:/root/.mycroft ${USER}/mycroft /bin/bash```
   
   Then you can run from inside the container:
   ```pair.sh``` and type pair my device to pair it.

5. Confirm via docker ps that your container is up and serving port 8181:


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

You can exit this container safely and leave it running by hitting cntrl + p + q, otherwise you can just hit cntrl+c to exit the cli and it will exit the container.  If you exit with cntrl + p + q it will leave the session open and running, still seeing issues attaching to sessions with previously running cli sessions though, so be advised.


You can get the container name via:

```
docker ps
```
