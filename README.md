# iris-mail

This app serves as a substitute for mail server. I want to do load testing on an app which sends messages to a mail server. The people responsible for the mail server do not want to receive thousands of messages whenever I do load testing.

I start iris-mail in a container and redirect the messages from the real mail server to the substitute. I can review messages in iris-mail to confirm the correct number of messages have been received.

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation ZPM

```
zpm "install iris-mail"
```

## Installation docker

Clone/git pull the repo into any local directory

```
git clone https://github.com/oliverwilms/iris-mail.git
```

Open the terminal in this directory and run:

```
docker-compose build
```

3. Run the IRIS container with your project:

```
docker-compose up -d
```

## Online Demo
You can find online demo here - [demo](https://iris-mail.demo.community.intersystems.com/csp/sys/UtilHome.csp)