echo "Running 004"

# import variables
eval "$(
  cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    echo "export $key=\"$value\""
  done
)"

cd aphroconfuso.mt-backups

# Backup databases
docker exec -i postgreslistmonk /usr/bin/pg_dump -p 9433 -U $LISTMONK_USER $LISTMONK_DB | gzip -9 > postgres-listmonk-backup.sql.gz
gpg -c --passphrase $GPG_PASSPHRASE --batch --quiet postgres-listmonk-backup.sql.gz

docker exec -i postgreslistmonk /usr/bin/pg_dump -p 9433 -U $STRAPI_DB_USERNAME $STRAPI_DB | gzip -9 > postgres-strapi-backup.sql.gz
gpg -c --passphrase $GPG_PASSPHRASE --batch --quiet postgres-listmonk-backup.sql.gz

rm *-backup.sql.gz

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_deploykey_unsigned

git add .
git commit -m "Automatically added by aphroconfuso-daily-tasks.sh"
git push
