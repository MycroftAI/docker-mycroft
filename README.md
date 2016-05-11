# Mycroft Docker Development Environment

### How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Edit the Dockerfile and change the user:pass information in the Mycroft checkout line to your authorised username and password on Github for the MycroftAI repo.

3. Build the docker image with 
   ```docker build -t <yourusername>/mycroft .``` in the directory that you have checked out.

4. Start the image with ``` docker run --device /dev/snd:/dev/snd --privileged -it <youruser>/mycroft ```

5. If you would rather have an interactive session (for testing, coding, or whatever) with the docker container, start the container with 
   ```docker run --device /dev/snd:/dev/snd --privileged -it <youruser>/mycroft /bin/bash``` 
   Once the container is loaded, please run ```supervisord``` from the bash prompt to start the Mycroft services 
