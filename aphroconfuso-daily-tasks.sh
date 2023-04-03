echo "running..."

export "$(grep -vE "^(#.*|\s*)$" .env)"

echo $LISTMONK_USER
