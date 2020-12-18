
sudo apt update
sudo apt upgrade
sudo apt install -y suckless-tools stterm libx11-dev libxinerama-dev libxft-dev xinit xorg xterm cromium-browser lxterminal

sudo make clean install
for u in /home/*
do
    cat EOF<<EOF >> $u/.bashrc
export WORK_USER=$USER;
export WORK_NMAP='-v -A';
function ssh_to_server() {
    ssh $WORK_USER@$*;
}
function git_repo_commit_and_push() {
    git add . && git commit -m "$*" && git push origin main;
}                                                                                                   
watch() {
    mkdir -p $1
    inotifywait -mq \
	      --timefmt '%s' \
	      -e modify,delete \
	      --format '{ "timestamp": "%T", "events": "%e", "file": "%f" }' $1 | while read out;
    do
	redis-cli publish "WATCH.$1" "$out";
    done > /dev/null
}


function work {
    if [ $1 == "connect" ]; then
       	shift;
        ssh_to_server $*;
    elif [ $1 == "push" ]; then
        shift;
        git_repo_commit_and_push $*;
    elif [ $1 == "pull"]; then
    	git pull;
    elif [ $1 == "user" ]; then
        export WORK_USER=$2;
    elif [ $1 == "wifi" ]; then
	wicd-curses;
    elif [ $1 == "hack" ]; then
        sudo wifite; 
    elif [ $1 == "browser" ]; then
    	chromium-browser https://vango.me &
    elif [ $1 == "shark" ]; then
        sudo tshark;
    elif [ $1 == "fingerprint" ]; then
    	nmap $WORK_NMAP $2;
    elif [ $1 == "scanme" ]; then
        nmap $WORK_NMAP scanme.nmap.org;
    elif [ $1 == "watch" ]; then
    	watch $2
    else
	echo "usage: work [connect|push|pull|browser|user|wifi|hack|shark|fingerprint|scanme]";
	echo " connect <domain>";
	echo " push <your commit message>";
	echo " pull";
	echo " browser";
	echo " user <username>";
	echo " browser";
	echo " wifi";
	echo " hack";
	echo " shark";
	echo " fingerprint <domain>";
	echo " scanme";
      # use carefully.
    fi                                                                      
} 
EOF
    cat EOF<<EOF > $u/.autostart
#!/bin/sh
# nomadic cabage autostart script.
display() {
    if [ "$WORK_MODE" == "expert" ]; then
	lxterminal -e screen &
    elif [ "$WORK_MODE" == "public" ]; then
	    chromium-browser --kiosk https://vango.me/profile?id=`redis-cli get ID` &
    else
	    chromium-browser https://vango.me/profile?id=`redis-cli get ID` &
    fi
}
startup() { stterm -e wicd-curses; }
startup && display
EOF
    city=`redis-cli get CITY`
    pass=`echo -n $city | shasum | cut -c8-16`
    redis-cli set pass $pass
    cat EOF<<EOF > $u/.irc.el
(require 'erc-join)(erc-autojoin-mode 1)
(setq erc-autojoin-channels-alist 
'(("vango.me" "#feed" "#`redis-cli get CITY`" "#`redis-cli get NICK`")))
(erc :server "vango.me" :full-name "`redis-cli get ID`" :nick "`redis-cli get NICK`" :password "$pass")
EOF
    cp Xresources $u/.Xresources
    sudo echo 'screen -t "#" emacs -nw --load ~/.irc.el index.org' >> $u/.screenrc
    sudo echo "xrdb -merge ~/.Xresources" >> $u/.xinitrc
    sudo echo "chmod +x ~/.autostart && ./.autostart &" >> $u/.xinitrc
    sudo echo 'xsetroot -name "nomadic 0.1 | go places."' >> $u/.xinitrc
    sudo echo "exec dwm" >> $u/.xinitrc
done

