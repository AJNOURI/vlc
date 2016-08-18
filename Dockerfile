# VLC media player
#
# docker run -d \
#	-v /etc/localtime:/etc/localtime:ro \
#	--device /dev/snd \
#	--device /dev/dri \
#	-v /tmp/.X11-unix:/tmp/.X11-unix \
#	-e DISPLAY=unix$DISPLAY \
#	--name vlc \
#	jess/vlc
#
FROM debian:sid
MAINTAINER Jessica Frazelle <jess@docker.com>

RUN apt-get update && apt-get install -y \
	libgl1-mesa-dri \
	libgl1-mesa-glx \
	vlc \
	vim \
	nano \
	--no-install-recommends \
	&& rm -rf /var/lib/apt/lists/*

ENV HOME /home/vlc
RUN useradd --create-home --home-dir $HOME vlc \
	&& chown -R vlc:vlc $HOME \
	&& usermod -a -G audio,video vlc

VOLUME media

ADD ./media/small.3gp /media/small.3gp
ADD ./media/small.flv /media/small.flv
ADD ./media/small.mp4 /media/small.mp4
ADD ./media/small.ogv /media/small.ogv
ADD ./media/small.webm /media/small.webm

ADD ./media/startvlc.sh /media/startvlc.sh

#RUN echo "VLC   ALL = NOPASSWD: ALL" >> /etc/sudoers

WORKDIR $HOME
#USER vlc

RUN cp /usr/bin/vlc /usr/bin/vlc-backup
RUN sed -i 's/geteuid/getppid/' /usr/bin/vlc

ENTRYPOINT vlc
