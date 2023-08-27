FROM python:3.11

#set environment variables
ARG UID
ARG GID
ARG USER_PASSWORD
ARG USER_NAME
ARG DEV_FOLDER

RUN apt-get update && apt-get install -y cmake vim sudo bash-completion tmux

#install python utility

#Up ssh server if not used vscode
RUN sudo apt-get install -y openssh-server
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
COPY .devcontainer/scripts/run.sh .
RUN chmod +x run.sh

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

#add  python user features
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN echo "export PATH="/home/${USER_NAME}/.local/bin:$PATH"" >> .bashrc
USER root
RUN /home/${USER_NAME}/.local/bin/poetry completions bash >> /usr/share/bash-completion/completions/poetry

USER ${USER_NAME}
COPY . ${DEV_FOLDER}
WORKDIR /home/${USER_NAME}/${DEV_FOLDER}

USER root