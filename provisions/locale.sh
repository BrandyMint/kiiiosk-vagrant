#!/bin/bash

#locale
#apt-get -y install language-pack-ru
#locale-gen ru_RU.UTF-8
#localedef -i ru_RU -f UTF-8 ru_RU.UTF-8


# Без разницы какой язык в системе,
# главное чтобы это был UTF-8
# Кроме того системные сообщения лучше читать на ангилйском 
# Русские символы должны работать в:
# - shell (zsh)
# - less
# - vim 

# По умолчаиню LC_CTYPE=UTF-8, и из-за
# этого русский не работает в less и vim
echo 'LC_ALL="en_US.UTF-8"' > /etc/default/locale

#echo 'LANG="ru_RU.UTF-8"' > /etc/default/locale
#echo 'LC_CTYPE=""' >> /etc/default/locale
#export LC_MESSAGES="POSIX"
#export LESSCHARSET=utf-8
dpkg-reconfigure locales

exit 0
