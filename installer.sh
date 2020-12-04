

sudo apt install -y suckless-tools stterm libxinerama-dev libxft-dev xinit xorg xterm cromium-browser lxterminal

sudo make clean install
for u in /home/*
do
    sudo echo "exec dwm" >> $u/.xinitrc
done
