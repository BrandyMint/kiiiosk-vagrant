
# Копируем ключи, чтобы выполнялся git clone
cp -vr ~/.host_ssh/* ~/.ssh

git clone git@github.com:BrandyMint/merchantly.git ~/code/kiiiosk

cd ~/code/kiiiosk

git submodule init
git submodule update
#sudo npm install -g bower
bower install
bundle
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
