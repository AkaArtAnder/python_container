FROM python:3.9

#set environment variables
ARG UID
ARG GID
ARG USER_PASSWORD
ARG USER_NAME
ARG DEV_FOLDER
ARG SSH_KEY_NAME
ARG SSH_HOST

RUN apt-get update && apt-get install -y cmake vim sudo bash-completion tmux



#Up ssh server if not used vscode
RUN sudo apt-get install -y openssh-server
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

WORKDIR /root
COPY .devcontainer/scripts/run.sh .
RUN chmod +x run.sh

#install poetry
WORKDIR /etc
COPY .devcontainer/scripts/pip.conf .
RUN pip install poetry
RUN poetry completions bash >> /usr/share/bash-completion/completions/poetry

# Install own utility
#-----------

#make user and set own id
RUN groupadd -r ${USER_NAME} && useradd -m -s /bin/bash -g ${USER_NAME} ${USER_NAME} -G adm,cdrom,sudo
RUN echo ${USER_NAME}:${USER_PASSWORD} | chpasswd
RUN usermod -u ${UID} ${USER_NAME} \
  && groupmod -g ${GID} ${USER_NAME}

USER ${USER_NAME}
WORKDIR /home/${USER_NAME}
RUN mkdir ${DEV_FOLDER}

COPY . ${DEV_FOLDER}
WORKDIR /home/${USER_NAME}/${DEV_FOLDER}
RUN poetry config certificates.PyPI.cert false && poetry config certificates.fpho.cert false 
RUN echo "export PYTHONWARNINGS=\"ignore:Unverified HTTPS request\"" >> ~/.bashrc

#Setting ssh_key
WORKDIR /home/${USER_NAME}
RUN mkdir .ssh
COPY .devcontainer/ssh_keys/${SSH_KEY_NAME} .ssh/id_ed25519
USER root
RUN chmod 777 /home/${USER_NAME}/.ssh && \
    chmod 777 /home/${USER_NAME}/.ssh/id_ed25519 && \
    ssh-keyscan -f /home/${USER_NAME}/.ssh/id_ed25519 -t rsa ${SSH_HOST} > /home/${USER_NAME}/.ssh/known_hosts

USER root