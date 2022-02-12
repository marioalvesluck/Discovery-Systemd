#!/bin/bash

#####################################################################################################
# Script Title:   Systemd                                                                           #
# Script Descr:   ZABBIX CHECK SYSTEMD                                                              #
# Script Name:    discovery.systemd.sh                                                              #
# Author:         Mario Alves                                                                       #
# E-Mail:         marioalvesrzti@gmail.com                                                          #
# Telegram:       https://t.me/marioalvesrzti                                                       #
# GitHub:         https://github.com/marioalvesluck                                                 #
# Telegram:       https://t.me/NonReturnZero                                                        #
# GitHub:         https://github.com/NRZCode                                                        #
# Description BR: Verifica Serviços systemd e pesquisa por status enabled                           #
# Description EN: Checks systemd services and search by enabled status.                             #
# Help:           Execute /bin/bash discovery.systemd.sh para informacoes de uso.                   #
#                 Run /bin/bash discovery.systemd.update.sh for usage information.                  #
# Create v1.0.0:  Monday Jan 09 11:00:0 BRT 2022                                                    #
#####################################################################################################

# REQUISITOS   #####################################################################################
#                                                                                                   #
# BR - INSTALAÇÃO DO JQ EM SEU AMBIENTE PARA FORMATACAO JSON                                        #
# BR - SE OPTAR POR NA INSTALAR REMOVA NA LINHA 55 | JQ                                             #
#                                                                                                   #
#####################################################################################################

# Function JSON #####################################################################################
# BR - Monta JSON com todas as informações do systemd enabled                                       #
# EN - Mounts JSON with all available versions of Zabbix.                                           #
#####################################################################################################

list=$(systemctl list-unit-files | grep "enabled" |tr -d '@')

function json() {
  local json
  while read service state vendor_preset; do
    json+=$(printf '{"{#SYSTEMDNAME}":"%s","{#SYSTEMDSTATUS}":"%s"},' "$service" "$state")
  done <<< "$list"
  printf '{"data":[%s]}' "${json%,}"
}

# INICNIO DA FUNCÂO STATUS ###########################################

function status() {
 [[ $1 ]] && grep "$1" <<< "$list" |  awk '{print $2}'
}

# FINAL DA FUNÇÃO STATUS ##############################################



#################################
#     PARAMETER OPTION $1       #
#################################
case $1 in                      #
       JSON) json | jq;         #
        ;;                      #
        STATUS) status "$2";    #
        ;;                      #
        *)                      #
# END ###########################


echo ""
echo "================================================================================================================="
echo "= USAGE:                                                                                                        ="
echo "=                                                                                                               ="
echo "= Ex: /bin/bash systemd.sh JSON                                                                                 ="
echo "= Ex: /bin/bash systemd.sh STATUS SERVICO                                                                       ="
echo "=                                                                                                               ="
echo "================================================================================================================="
echo ""

exit ;;
esac
# END SCRIPT ###########################################################################################################
