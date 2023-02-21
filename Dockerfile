FROM node:latest

# We don't need the standalone Chromium
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD true

# Install Google Chrome Stable and fonts
# Note: this installs the necessary libs to make the browser work with Puppeteer.
RUN apt-get update && apt-get install gnupg wget -y && \
  wget --quiet --output-document=- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /etc/apt/trusted.gpg.d/google-archive.gpg && \
  sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' && \
  apt-get update && \
  apt-get install google-chrome-stable -y && \
  rm -rf /var/lib/apt/lists/* 

# App here
#FROM node:latest

#ENV POLLURL=null

#ENV ANSWERID=null

RUN mkdir -p /var/run/dbus && \
	dbus-daemon --config-file=/usr/share/dbus-1/system.conf --print-address

ENV PUPPETEER_EXECUTABLE_PATH="/usr/bin/google-chrome-stable"

RUN useradd --create-home voter

USER voter

RUN echo "NEW3"

RUN cd /home/voter && \
	git clone https://github.com/cph015/voteBot.git 

WORKDIR /home/voter/voteBot/voteBot

RUN npm install puppeteer

ENTRYPOINT ["/bin/bash"]
CMD ["/home/voter/voteBot/voteBot/runVoteBot.sh"]
