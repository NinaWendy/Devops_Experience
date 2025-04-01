Official Documentation
ngrok.com

Login to your account

Agent is linux

Homebrew Installation

curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
	| sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null \
	&& echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
	| sudo tee /etc/apt/sources.list.d/ngrok.list \
	&& sudo apt update \
	&& sudo apt install ngrok


Snap Installation

snap install ngrok

Run the following command to add your authtoken to the default ngrok.yml configuration file.

ngrok config add-authtoken

~/.config/ngrok/ngrok.yml

Deploy service online
ngrok http http://localhost:9000

