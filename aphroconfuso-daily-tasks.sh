#!/bin/bash

echo "Running backups..."

# Add to crontab
#
# crontab -e
# 0 5 * * * ~/aphroconfuso-daily-tasks.sh

# Import variables
# eval "$(
#   cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
#     key=$(echo "$line" | cut -d '=' -f 1)
#     value=$(echo "$line" | cut -d '=' -f 2-)
#     echo "export $key=\"$value\""
#   done
# )"

source .env
echo "Imported variables:"
echo "LISTMONK_USER $LISTMONK_USER"
echo "LISTMONK_DB $LISTMONK_DB"
echo "STRAPI_DB_USERNAME $STRAPI_DB_USERNAME"
echo "STRAPI_DB $STRAPI_DB"
echo "GPG_PASSPHRASE $GPG_PASSPHRASE"
echo "MYSQL_ROOT_PASSWORD $MYSQL_ROOT_PASSWORD"
echo "MYSQL_DATABASE $MYSQL_DATABASE"

cd aphroconfuso.mt-backups

# Delete existing files
rm *-backup.sql.gz.gpg

# Backup databases
docker exec -i postgreslistmonk /usr/bin/pg_dump -p 9433 -U $LISTMONK_USER -d $LISTMONK_DB | gzip -9 > postgres-listmonk-backup.sql.gz
gpg -c --passphrase $GPG_PASSPHRASE --batch --yes --quiet postgres-listmonk-backup.sql.gz

export PGPASSWORD=$STRAPI_DB_PASSWORD
docker exec -i postgresstrapi /usr/bin/pg_dump -p 5437 -U $STRAPI_DB_USERNAME -d $STRAPI_DB | gzip -9 > postgres-strapi-backup.sql.gz
gpg -c --passphrase $GPG_PASSPHRASE --batch --yes --quiet postgres-strapi-backup.sql.gz

docker exec mariadbmatomo /usr/bin/mysqldump -u root --password=$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE | gzip -9 > postgres-matomo-backup.sql.gz
gpg -c --passphrase $GPG_PASSPHRASE --batch --yes --quiet postgres-matomo-backup.sql.gz

# Delete plaintext files
rm *-backup.sql.gz

# Commit and push
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_deploykey_unsigned

git add .
git commit -m "Automatically added by aphroconfuso-daily-tasks.sh"
git push

cd ..
cd aphroconfuso.mt-stampi
git add .
git commit -m "Automatically added by aphroconfuso-daily-tasks.sh"
git push
