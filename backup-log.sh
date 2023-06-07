#!/bin/bash
#
# Autor: Raphael Kennedy
#
### Leia o script antes de executa-lo
#
# Criar arquivo de log: touch /var/log/.log
# Permissao : chmod 755 /var/log/registro_backup.log
#
# Para descompactar gzip -d arquivo.gz
#
#
#

#SIZE refere-se a 729M
SIZE="764411904"

DATE=$(date +%m%d%Y-%H%M)

FILE="/var/log/arquivo/log_aplicacao.txt"

LOG_FILE="/var/log/registro_backup.log"

BKPLog="/var/log/arquivo/olddir/registro.txt-$DATE.txt.gz"
#Sugestao: E interessante que seu backup apos criado, seja enviado para um bucket, com permissao somente de envio.

SizeFile=(du -b /var/log/arquivo/registro.txt | head -n 1 | awk {'print $1'})

function IniciarBackup(){

    echo "Iniciando backup Script backup-log " >> $LOG_FILE
    
    gzip -c $FILE > $BKPLog

    SBFile=$(du -csh $FILE | head -n 1 | awk {'print $1'})
    echo "Tamanho arquivo log inicio: $SBFile"  >> $LOG_FILE

if [ -f "$BKPLog" ]; then
    
    echo "Backup criado : $BKPLog"  >> $LOG_FILE
    SBkp=$(du -csh $BKPLog | head -n 1 | awk {'print $1'})
    echo "Tamanho arquivo backup: $SBkp"  >> $LOG_FILE
     
    echo "" > $FILE
    echo "Aviso: Arquivo de log apagado!" >> $LOG_FILE

    SAFile=$(du -csh $FILE | head -n 1 | awk {'print $1'})
    echo "Tamanho arquivo log final: $SAFile"  >> $LOG_FILE

else 
    echo "Nao foi criado - $BKPLog" >> $LOG_FILE
    exit 1 
fi
}

if [ $SizeFile -gt $SIZE ]; then
    
    echo "Iniciando backup - $DATE" >> $LOG_FILE
    IniciarBackup

else

    echo "Backup nao sera iniciado - $DATE" >> $LOG_FILE

fi
