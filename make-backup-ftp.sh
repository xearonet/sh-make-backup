#!/usr/bin/env bash
# Makes a backup via FTP

HOST="<url>"
PORT="<port>"
USER="<user>"
PASS="<passwd>"

BACKUPS_DIR="< dir for backups >"
# BACKUPS_DIR="$(pwd)/backups"
BACKUP_NAME="backup__$(date +'%Y-%m-%d__%H-%M')"
LOCAL_DIR="$BACKUPS_DIR/$BACKUP_NAME"

REMOTE_DIR="/FactoryGame/Saved/SaveGames/common"
INCLUDE_FILES="--include-glob 'NorthernForest_NOINTRO*'"
EXCLUDE_FILES=""
#ALWAYS_ALL="--transfer-all"

echo; echo "- Copying files (ftp://${HOST}:${PORT} -> ${LOCAL_DIR})"
mkdir -pv $LOCAL_DIR
lftp -c "set ftp:list-options -a;
open 'ftp://$USER:$PASS@$HOST' -p '$PORT';
lcd $LOCAL_DIR;
cd $REMOTE_DIR;
mirror --verbose --parallel=8 \
       $ALWAYS_ALL \
       $INCLUDE_FILES \
       $EXCLUDE_FILES "

echo; echo "- Archiving files ($LOCAL_DIR.tar.gz)"
tar czvf $LOCAL_DIR.tar.gz -C $BACKUPS_DIR $BACKUP_NAME
echo; echo "- Removing temp directory ($LOCAL_DIR)"
rm -rv $LOCAL_DIR
echo; echo "- Removing backups older than 14 days"
find $BACKUPS_DIR -type f -mtime +14 -name '*.gz' -execdir rm -v -- '{}' \;
echo; echo "- Done."
