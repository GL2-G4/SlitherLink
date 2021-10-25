if [ "$EUID" -ne 0 ]
	then echo "Please run as root"
	exit
fi

sudo apt update
sudo apt-get install ruby
sudo apt-get install ruby-dev
sudo gem install gtk3

echo "you should be able to run slitherlink with the command ./SlitherLink.sh"
