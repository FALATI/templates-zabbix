#!/bin/bash
#================================================================================
#
#  Programa :  check_instance_status.sh
#
#  Objetivo :  Checar o status da instancia oracle.
#
#================================================================================

INSTANCENAME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt | cut -d\; -f2 | tail -1)
ORACLE_HOME=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f4)
SYS_SENHA=$(cat /etc/zabbix/zabbix_agentd.d/scripts/4linux_parameters.txt  | grep $INSTANCENAME | cut -d\; -f6)

function check { 
export ORACLE_SID=${INSTANCENAME}
export ORACLE_HOME=${ORACLE_HOME}
${ORACLE_HOME}/bin/sqlplus -S /nolog << EOF

connect sys/$SYS_SENHA as sysdba

SELECT status FROM V\$INSTANCE;

exit

EOF
}

check | grep ^OPEN$ 2> /dev/null >> /dev/null

if [ "$?" = "0" ] ; then 
	echo 0 
else
	echo 1 
fi 
