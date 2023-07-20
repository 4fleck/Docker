FROM jenkins/jenkins

ARG DOCKER_COMPOSE_VERSION=1.25.0

USER root
RUN apt-get update && \
   apt-get upgrade -y && \
   apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      git \
      software-properties-common && \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
   add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce && \
   apt-get clean autoclean && apt-get autoremove && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose 

RUN usermod -aG docker jenkins && gpasswd -a jenkins docker

USER jenkins
