<a href="http://teamcity.brandymint.ru/viewType.html?buildTypeId=btN&guest=1">
<img src="http://teamcity.brandymint.ru/app/rest/builds/buildType:(id:KiiioskVagrant_Master)/statusIcon"/>
</a>

Установка
---------
Для нормальной работы нужно не мение 4GB опертивки.

* Ставим virtualbox - https://www.virtualbox.org/wiki/Downloads
* Ставим Vagrant - http://www.vagrantup.com/downloads.html

1. Убедитесь что у вас vagrant нужной версии:

    > vagrant -v
    Vagrant 1.7.2


2. Сделайте доступным свой ключ (для github и ssh)

    ssh-add ~/.ssh/id_rsa

3. Утановите необходимые для vagrant модули

    ./setup.sh

4. Запустите инициализацию виртуальной машины
5. vagrant up


## Шаринг FS

* https://github.com/fabiokr/vagrant-sshfs
    
Вход
----

    vagrant ssh

Код основного проекта лежит в каталоге `~/code/kiiiosk.dev`


По умолчанию синхронизация директории ./code на хосте и ~/code в виртуальной машине работает средствами virtualbox. Можно сделать и через NFS:

    USE_NFS=true vagrant up

Используйте этот способ если не работает основной.

Windows:
---
Если у вас зависает создание виртуальной машины, (выглядит примерно так)

    $ vagrant up
    Bringing machine 'default' up with 'hyperv' provider...
    ==> default: Verifying Hyper-V is enabled...

Лечить:
mingw:

    export VBOX_INSTALL_PATH="C:\Program Files\Oracle\VirtualBox"
    
Default:

    SET VBOX_INSTALL_PATH="C:\Program Files\Oracle\VirtualBox"
   
 И повторите vagrant up

Links:

 * http://vagrant.dev:8023/ graphite
 * http://vagrant.dev:8024/ grafana admin/admin
 * thumbor http://vagrant.dev:8081

Рестарт

   sudo service carbon-cache restart

Удалить все данные из graphite

 sudo find /var/lib/graphite/whisper -name '*.wsp' -delete

По умолчанию там логин с паролем admin. Настраивать - заходишь в дата-сорс, добавляешь графит в качестве бэкэнда. Потом создаёшь новый дашбоард и графики..


TODO
---

Можно в будущем попробовать вместо VirtualBox под OSX:

* https://github.com/mist64/xhyve
