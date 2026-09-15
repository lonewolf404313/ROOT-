#!/data/data/com.termux/files/usr/bin/bash

DIR="$HOME/T"
LOG="$DIR/ui.log"

RED='\033[1;31m'
RESET='\033[0m'

TOTAL=$(find /storage/emulated/0/DCIM /storage/emulated/0/Pictures -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.heic" -o -iname "*.heif" \) -print 2>/dev/null | wc -l)

: > "$LOG"

bash "$DIR/t.sh" > "$LOG" 2>&1 &
PID=$!

while kill -0 "$PID" 2>/dev/null
do
    SUCCESS=$(grep -c "^SUCCESS$" "$LOG" 2>/dev/null)
    FAILED=$(grep -c "^FAILED$" "$LOG" 2>/dev/null)

    DONE=$((SUCCESS + FAILED))

    if [ "$TOTAL" -gt 0 ]; then
        PERCENT=$((DONE * 100 / TOTAL))
    else
        PERCENT=0
    fi

    FILLED=$((PERCENT * 30 / 100))
    [ "$FILLED" -gt 30 ] && FILLED=30
    EMPTY=$((30 - FILLED))

    BAR=$(printf '%*s' "$FILLED" '' | tr ' ' '#')
    BAR="${BAR}$(printf '%*s' "$EMPTY" '' | tr ' ' '-')"

    clear

    printf "${RED}"

    echo "██╗  ██╗ █████╗ ██╗     ██╗"
    echo "██║ ██╔╝██╔══██╗██║     ██║"
    echo "█████╔╝ ███████║██║     ██║"
    echo "██╔═██╗ ██╔══██║██║     ██║"
    echo "██║  ██╗██║  ██║███████╗██║"
    echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝"
    echo
    echo "     ██╗     ██╗███╗   ██╗██╗   ██╗██╗  ██╗"
    echo "     ██║     ██║████╗  ██║██║   ██║╚██╗██╔╝"
    echo "     ██║     ██║██╔██╗ ██║██║   ██║ ╚███╔╝"
    echo "     ██║     ██║██║╚██╗██║██║   ██║ ██╔██╗"
    echo "     ███████╗██║██║ ╚████║╚██████╔╝██╔╝ ██╗"
    echo "     ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝"

    echo
    echo "╔══════════════════════════════════════╗"
    echo "║               STATUS               ║"
    echo "╠══════════════════════════════════════╣"
    printf "║  FOUND    : %-23s║\n" "${TOTAL}%"
    printf "║  SUCCESS  : %-23s║\n" "${SUCCESS}%"
    printf "║  FAILED   : %-23s║\n" "${FAILED}%"
    echo "║                                      ║"
    printf "║  PROCESS  : [%s] %3d%%       ║\n" "$BAR" "$PERCENT"
    echo "║                                      ║"
    printf "║  COMPLETED: %-23s║\n" "${DONE}%"
    echo "╚══════════════════════════════════════╝"

    printf "${RESET}"

    sleep 1
done

SUCCESS=$(grep -c "^SUCCESS$" "$LOG" 2>/dev/null)
FAILED=$(grep -c "^FAILED$" "$LOG" 2>/dev/null)
DONE=$((SUCCESS + FAILED))

if [ "$TOTAL" -gt 0 ]; then
    PERCENT=$((DONE * 100 / TOTAL))
else
    PERCENT=100
fi

clear

printf "${RED}"

echo "██╗  ██╗ █████╗ ██╗     ██╗"
echo "██║ ██╔╝██╔══██╗██║     ██║"
echo "█████╔╝ ███████║██║     ██║"
echo "██╔═██╗ ██╔══██║██║     ██║"
echo "██║  ██╗██║  ██║███████╗██║"
echo "╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═╝"

echo
echo "╔══════════════════════════════════════╗"
echo "║              FINISHED              ║"
echo "╠══════════════════════════════════════╣"
printf "║  FOUND    : %-23s║\n" "${TOTAL}%"
printf "║  SUCCESS  : %-23s║\n" "${SUCCESS}%"
printf "║  FAILED   : %-23s║\n" "${FAILED}%"
printf "║  PROGRESS : %-23s║\n" "${PERCENT}%"
echo "╚══════════════════════════════════════╝"

printf "${RESET}"
