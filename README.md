
Установка
---------

1. Убедитесь что у вас vagrant нужной версии:

    > vagrant -v
    Vagrant 1.7.2


2. Сделайте доступным свой ключ (для github и ssh)

    ssh-add ~/.ssh/id_rsa

3. Утановите необходимые для vagrant модули

    ./setup.sh

4. Запустите инициализацию виртуальной машины

    vagrant up
    
Вход
----

    vagrant ssh

Код основного проекта лежит в каталоге `~/code/kiiiosk.dev`


По умолчанию синхронизация директории ./code на хосте и ~/code в виртуальной машине работает средствами virtualbox. Можно сделать и через NFS:

    USE_NFS=true vagrant up


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
