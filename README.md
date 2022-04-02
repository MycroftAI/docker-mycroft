# Mycroft Docker Development Environment

[![Build Status](https://travis-ci.org/MycroftAI/docker-mycroft.svg?branch=master)](https://travis-ci.org/MycroftAI/docker-mycroft)

## Install
### Get image from Docker hub
This repo is updated on [dockerhub](https://hub.docker.com/r/mycroftai/docker-mycroft/) and you can have it without building it, by simply running the below command.

```bash
docker pull mycroftai/docker-mycroft
```

### Build image
Git pull this repository.

```bash
git clone https://github.com/MycroftAI/docker-mycroft.git
```

Build the docker image in the directory that you have checked out.

```bash
docker build -t mycroft .
```

## Run
To get persistent data and don't have, for example, to pair our instance every time the container is started. You can map a local directory into the container. Just replace the `config_dir_on_host` with where you want the container mapped on your local machine (e.g. `/home/user/mycroft`). To get persistent storage of non-default skills, so that they don't have to be re-installed every time the container is started, we map the container's `skills` directory to a local directory. Just replace the `skills_dir_on_host` with the desired location (e.g. `/home/user/mycroft_skills`).

Sounds can be played in the container using pulseaudio, without modifying any config files (Thanks to [fsmunoz](https://github.com/jessfraz/dockerfiles/issues/85#issuecomment-299431931)).

* Set [PULSE_SERVER](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Network/#directconnection) env variable
* Share pulseaudio's [cookie](https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Network/#authorization)

Run the following to start up mycroft:

```bash
docker run -d \
-v config_dir_on_host:/root/.mycroft \
-v skills_dir_on_host:/opt/mycroft/skills \
--mount type=tmpfs,destination=/tmp \
--device /dev/snd \
-e PULSE_SERVER=unix:${XDG_RUNTIME_DIR}/pulse/native \
-v ${XDG_RUNTIME_DIR}/pulse/native:${XDG_RUNTIME_DIR}/pulse/native \
-v ~/.config/pulse/cookie:/root/.config/pulse/cookie \
-p 8181:8181 \
--name mycroft mycroftai/docker-mycroft
```

Confirm via docker ps that your container is up and serving port 8181:

```bash
docker ps
CONTAINER ID        IMAGE                                                COMMAND                  CREATED             STATUS              PORTS                                            NAMES
692219e23bf2        mycroft                                    "/mycroft/ai/mycro..."         3 seconds ago         Up 1 second           0.0.0.0:8181->8181/tcp                          mycroft
```

You should now have a running instance of mycroft that you can interact with via the cli, etc.

## Logs
At any time you can watch the logs simply by running the bellow command:

```bash
docker logs -f mycroft
```

You can exit out of this docker log command by hitting ctrl + c, the `--follow` basically turns it into a real tail instead of a cat of the log.

## CLI Access
You can interact with the CLI of the container by running the following command, this will connect you to the running container via bash:

```bash
docker exec -it mycroft /bin/bash
```

Once in the container you can do `./start-mycroft.sh cli` to get a interactive CLI to interact with mycroft if needed.

You can hit ctrl + c to exit the cli.

## Pairing Instance
After the container has been started you can watch the logs and look for the line that says Pairing Code and use this to pair at https://home.mycroft.ai.

You can filter the logs to get the pairing code as such:

```bash
docker logs mycroft | grep "Pairing code:"

```

## Skills
You can watch the logs and confirm it installs/deletes skills.

### Install
You can install skills into the container with the Mycroft Skills Manager (MSM):

```bash
docker exec -it mycroft /opt/mycroft/bin/mycroft-msm install skill-name
```

So to install the Hello World Skill we can use:

```bash
docker exec -it mycroft /opt/mycroft/bin/mycroft-msm install hello-world
```

For development purposes you can also install Skills directly from Github. So if the Hello World Skill was not in the Mycroft Marketplace, we could use the following:

```bash
docker exec -it mycroft /opt/mycroft/bin/mycroft-msm install https://github.com/MycroftAI/skill-hello-world
```

_Please note: only Skills in the Mycroft Marketplace have been reviewed and verified. We strongly recommend carefully reviewing the code of any Skill you are installing from outside of the Marketplace. This is done completely at your own risk._

### Remove
You can uninstall a Skill using MSM or by removing the folder location for it:

```bash
docker exec -it mycroft /opt/mycroft/bin/mycroft-msm remove hello-world
docker exec -it mycroft rm -rf /opt/mycroft/skills/mycroft-hello-world.mycroftai
```

Both of these commands would remove the Hello World Skill.
