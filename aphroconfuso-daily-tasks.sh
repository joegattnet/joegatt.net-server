echo "running..."

# import variables
eval "$(
  cat .env | awk '!/^\s*#/' | awk '!/^\s*$/' | while IFS='' read -r line; do
    key=$(echo "$line" | cut -d '=' -f 1)
    value=$(echo "$line" | cut -d '=' -f 2-)
    echo "export $key=\"$value\""
  done
)"

# Backup LISTMONK database
docker exec -i postgreslistmonk /usr/bin/pg_dump -P 9433 -U $LISTMONK_USER $LISTMONK_DB | gzip -9 > postgres-listmonk-backup.sql.gz

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa_deploykey_unsigned
