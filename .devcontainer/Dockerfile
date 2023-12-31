FROM python:3.11

#set environment variables
ARG UID
ARG GID
ARG USER_PASSWORD
ARG USER_NAME
ARG DEV_FOLDER
ARG GIT_USER
ARG GIT_EMAIL

RUN apt-get update && apt-get install -y cmake vim sudo bash-completion tmux

#Up ssh server if not used vscode
RUN sudo apt-get install -y openssh-server
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

WORKDIR /root
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
RUN /home/${USER_NAME}/.local/bin/poetry env use python
RUN /home/${USER_NAME}/.local/bin/poetry install

####Comment if use vscode_devcontainer=====================================================
# # Create ssh folder
# WORKDIR /home/${USER_NAME}
# RUN mkdir .ssh
# RUN chmod -R 700 .ssh
# #end

# #Set ssh key for authorization
# COPY --chown=${USER_NAME}:${USER_NAME} .devcontainer/ssh_keys/auth_key.pub .ssh/authorized_keys
# USER ${USER_NAME}
# RUN chmod 644 /home/${USER_NAME}/.ssh/authorized_keys
# # # end

# # # Set git user for remote repository
# USER ${USER_NAME}
# RUN git config --global user.name ${GIT_USER} && git config --global user.email ${GIT_EMAIL}
# ####=====================================================

USER root