# Mycroft Docker Development Environment

### How to build and run

1. Git pull this repository - ```git clone https://github.com/MycroftAI/docker-mycroft.git```

2. Edit the Dockerfile and change the user:pass information in the Mycroft checkout line to your authorised username and password on Github for the MycroftAI repo.

3. Build the docker image with 
   ```docker build -t <yourusername>/mycroft .``` in the directory that you have checked out.

4. Start the image with ``` docker run --device /dev/snd:/dev/snd <yourusername>/mycroft ```
 
