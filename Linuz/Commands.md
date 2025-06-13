## TMUX

Create session

Create new named session

Detach

Attach to a session

Split window vertically
ctrl + B shift 5


Split window horizontally
ctrl + B shift "

Size of pane
ctrl b q direction

New window


Move through windows
ctrl + B N

Rename window


kill pane

kill window


## Remote Setup

mkdir -p ~/.ssh
chmod 700 ~/.ssh

scp /home/user/.ssh/id_rsa* user@machine_ip:~/.ssh/

chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
