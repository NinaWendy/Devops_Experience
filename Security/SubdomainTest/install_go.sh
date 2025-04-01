cd ~

curl -OL https://golang.org/dl/go1.21.1.linux-amd64.tar.gz

sha256sum go1.21.1.linux-amd64.tar.gz

sudo tar -C /usr/local -xvf go1.21.1.linux-amd64.tar.gz

sudo nano ~/.profile

echo 'export PATH=$PATH:$HOME/go/bin' >> ~/.profile


