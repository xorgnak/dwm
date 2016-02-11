
EXE=dwm
DEV='libx11-dev libxft-dev libxinerama-dev build-essential'
SYS='xinit xorg xterm alsa-base alsa-utils chromium vlc'

apt-get -y install $EXE $DEV $SYS
apt-get -y remove $EXE
make install
make clean
apt-get -y remove $DEV
echo "DONE!"
