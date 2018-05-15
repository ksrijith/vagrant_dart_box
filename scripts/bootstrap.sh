#!/bin/bash
set -eu
apt-get update
apt-get -y upgrade
apt-get update
apt-get install -y --no-install-recommends ubuntu-desktop
apt-get install -y --no-install-recommends xubuntu-desktop
apt-get install -y gnome-terminal
apt-get install -y git
apt-get install -y python-software-properties
apt-get install -y apt-transport-https
apt-get install -y ack-grep
sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_unstable.list > /etc/apt/sources.list.d/dart_unstable.list'
apt-get update
apt-get install -y dart
su - vagrant -c  "/usr/lib/dart/bin/pub global activate stagehand"
su - vagrant -c  "/usr/lib/dart/bin/pub global activate webdev"
su - vagrant -c  "git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime"
su - vagrant -c  "sh ~/.vim_runtime/install_awesome_vimrc.sh"
su - vagrant -c  "mkdir -p ~/.vim/bundle && cd ~/.vim/bundle && git clone https://github.com/dart-lang/dart-vim-plugin"
su - vagrant -c  "echo 'execute pathogen#infect()' >> /home/vagrant/.vimrc"
su - vagrant -c  "echo 'map <C-n> :NERDTreeToggle<CR>' >> /home/vagrant/.vimrc"
su - vagrant -c  "echo 'set noshowmode' >> /home/vagrant/.vimrc"
su - vagrant -c  "echo 'export PATH=$PATH:/usr/lib/dart/bin' >> /home/vagrant/.bash_profile"
su - vagrant -c  "echo 'export PATH=$PATH:~/.pub-cache/bin' >> /home/vagrant/.bash_profile"
apt install -y zsh
chsh -s /bin/zsh vagrant
su - vagrant -c  "wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh"
cp /scripts/custom.zsh /home/vagrant/.oh-my-zsh/custom
cp /scripts/dnew /usr/bin/dnew
chmod +x /usr/bin/dnew

add-apt-repository ppa:ubuntu-desktop/ubuntu-make
apt-get update
apt-get install -y ubuntu-make
su -c 'umake ide visual-studio-code /home/vagrant/.local/share/umake/ide/visual-studio-code --accept-license' vagrant
sed -i -e 's/visual-studio-code\/code/visual-studio-code\/bin\/code/' /home/vagrant/.local/share/applications/visual-studio-code.desktop
sed -i -e 's/"$CLI" "$@"/"$CLI" "--disable-gpu" "$@"/' /home/vagrant/.local/share/umake/ide/visual-studio-code/bin/code
#Cleanup
echo "fs.inotify.max_user_watches = 524288" > /etc/sysctl.d/60-inotify.conf
sysctl -p --system
chown -R vagrant:vagrant /home/vagrant/
apt-get -y autoclean
apt-get -y clean
apt-get -y autoremove