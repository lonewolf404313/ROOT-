#!/data/data/com.termux/files/usr/bin/bash

BOT_TOKEN="PASTE_NEW_BOT_TOKEN_HERE"
CHAT_ID="7416753891"

echo "Searching photos..."

find /storage/emulated/0/DCIM /storage/emulated/0/Pictures \
-type f \
\( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.heic" -o -iname "*.heif" \) \
-not -path "*/.backup/*" \
-print0 2>/dev/null |
while IFS= read -r -d '' PHOTO
do
    echo "Sending: $PHOTO"

    SUCCESS=0

    for RETRY in 1 2 3
    do
        RESPONSE=$(curl -sS --connect-timeout 10 --max-time 120 \
            -X POST \
            "https://api.telegram.org/bot${BOT_TOKEN}/sendDocument" \
            -F "chat_id=${CHAT_ID}" \
            -F "document=@${PHOTO}")

        if echo "$RESPONSE" | grep -q '"ok":true'
        then
            echo "SUCCESS"
            SUCCESS=1
            break
        fi

        echo "Retry $RETRY..."
        sleep 1
    done

    if [ "$SUCCESS" -eq 0 ]
    then
        echo "FAILED: $PHOTO"
    fi
done

echo
echo "=========================="
echo "Backup finished."
echo "=========================="