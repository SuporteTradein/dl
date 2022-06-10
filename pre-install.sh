#!/bin/bash

#pre-install
echo 'Checking inicial do sistema...'
error_code='0000'
if [ -f /etc/oracle-release ]; then ### Verifica se o sistema é Oracle Linux.
    echo -e 'Oracle Linux... OK.'
    if grep -Fxq "Oracle Linux Server release 8.6" /etc/oracle-release ; then   ### Verifica a versão do Oracle Linux.
        echo -e 'Versão 8.6... \tOK.'
        ping -q -c3 1.1.1.1 &>/dev/null
        if [ $? -eq 0 ];then ### Verifica a conexão com internet
            echo -e 'Internet... \tOK.'
            if (yum repolist enabled | grep "UEKR\|appstream\|baseos" &>/dev/null); then ### Verifica a configuração do repositorio.
                echo -e 'Repositorios... OK.'
                echo 'Instalando novos pacotes...'
                yum install bind-utils open-vm-tools openssh-server nano python3 git -y -q
                echo 'Configurando novos pacotes...'
                update-alternatives --remove python /usr/libexec/no-python &>/dev/null
            else
                echo 'Repositorios... FAIL. [Configure corretamente os repositorios.]'
                error_code='0004'
            fi
        else
            echo -e 'Internet... \tFAIL. [Verifique a conexão com a internet.]'
            error_code='0003'
        fi
    else
        echo -e 'Versao 8.6... \tFAIL. [É necessario um "Oracle Linux Server release 8.6"]'
        error_code='0002'
    fi
else
    echo 'Oracle Linux... FAIL. [Este Sistema nao é um Oracle Linux, encerrando instalação.]'
    error_code='0001'
fi

#Check error pre-install
if [ $error_code == '0000' ]; then
    clear
    echo 'Checking inicial concluido, iniciando download do sistema principal.'
else
    echo 'Codigo de erro: #'$error_code
    echo 'Consulte a seção de codigo de erros da KB para ajuda!'
fi

# Get install
