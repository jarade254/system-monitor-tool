#!/bin/bash

LOGFILE="system_report_$(date +%F_%H-%M-%S).log"

# 🎨 Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

show_menu() {
    clear
    echo -e "${BLUE}===================================${RESET}"
    echo -e "${GREEN}     SYSTEM MONITOR DASHBOARD     ${RESET}"
    echo -e "${BLUE}===================================${RESET}"
    echo "1) Full System Report"
    echo "2) CPU Usage Only"
    echo "3) Memory Usage Only"
    echo "4) Disk Usage Only"
    echo "5) Security Check (Failed Logins)"
    echo "6) System Health Status"
    echo "7) Exit"
    echo -e "${BLUE}===================================${RESET}"
    echo -n "Choose an option: "
}

full_report() {
    echo "FULL SYSTEM REPORT" | tee -a "$LOGFILE"
    uptime | tee -a "$LOGFILE"
    free -h | tee -a "$LOGFILE"
    df -h | tee -a "$LOGFILE"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
    who | tee -a "$LOGFILE"
}

cpu_report() {
    echo "CPU USAGE" | tee -a "$LOGFILE"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
}

memory_report() {
    echo "MEMORY USAGE" | tee -a "$LOGFILE"
    free -h | tee -a "$LOGFILE"
}

disk_report() {
    echo "DISK USAGE" | tee -a "$LOGFILE"
    df -h | tee -a "$LOGFILE"
}

security_check() {
    echo "SECURITY CHECK (FAILED LOGINS)" | tee -a "$LOGFILE"
#!/bin/bash

LOGFILE="system_report_$(date +%F_%H-%M-%S).log"

# 🎨 Colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
RESET="\e[0m"

# ================= MENU =================
show_menu() {
    clear
    echo -e "Last Updated: $(date)"
    echo ""

    echo -e "${BLUE}===================================${RESET}"
    echo -e "${GREEN}     LINUX SYSTEM MONITOR TOOL     ${RESET}"
    echo -e "${BLUE}===================================${RESET}"
    echo -e "System Health & Performance Dashboard"
    echo ""
    echo "1) Full System Report"
    echo "2) CPU Usage Only"
    echo "3) Memory Usage Only"
    echo "4) Disk Usage Only"
    echo "5) Security Check (Failed Logins)"
    echo "6) System Health Status"
    echo "7) Exit"
    echo -e "${BLUE}===================================${RESET}"
    echo -n "Choose an option: "
}

# ================= REPORTS =================
full_report() {
    echo "FULL SYSTEM REPORT" | tee -a "$LOGFILE"
    uptime | tee -a "$LOGFILE"
    free -h | tee -a "$LOGFILE"
    df -h | tee -a "$LOGFILE"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
    who | tee -a "$LOGFILE"
}

cpu_report() {
    echo "CPU USAGE" | tee -a "$LOGFILE"
    top -bn1 | grep "Cpu(s)" | tee -a "$LOGFILE"
}

memory_report() {
    echo "MEMORY USAGE" | tee -a "$LOGFILE"
    free -h | tee -a "$LOGFILE"
}

disk_report() {
    echo "DISK USAGE" | tee -a "$LOGFILE"
    df -h | tee -a "$LOGFILE"
}

security_check() {
    echo "SECURITY CHECK (FAILED LOGINS)" | tee -a "$LOGFILE"

    if [ -f /var/log/auth.log ]; then
        grep "Failed password" /var/log/auth.log | tail -10 | tee -a "$LOGFILE"
    else
        echo "No access to auth.log (run with sudo)" | tee -a "$LOGFILE"
    fi
}

# ================= SYSTEM HEALTH =================
get_cpu_usage() {
    top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}'
}

get_memory_usage() {
    free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}'
}

system_health() {
    CPU=$(get_cpu_usage)
    MEM=$(get_memory_usage)

    echo ""
    echo "========== SYSTEM HEALTH STATUS =========="
    echo ""

    echo "CPU Usage    : $CPU%"
    echo "Memory Usage : $MEM%"
    echo ""

    # CPU status
    if (( $(echo "$CPU < 50" | bc -l) )); then
        echo "CPU Status    : 🟢 GOOD"
    elif (( $(echo "$CPU < 80" | bc -l) )); then
        echo "CPU Status    : 🟡 WARNING"
    else
        echo "CPU Status    : 🔴 CRITICAL"
    fi

    # Memory status
    if (( MEM < 50 )); then
        echo "Memory Status : 🟢 GOOD"
    elif (( MEM < 80 )); then
        echo "Memory Status : 🟡 WARNING"
    else
        echo "Memory Status : 🔴 CRITICAL"
    fi

    echo ""
    echo "=========================================="
}

# ================= MAIN LOOP =================
while true; do
    show_menu
    read choice

    case $choice in
        1)
            full_report ;;
        2)
            cpu_report ;;
        3)
            memory_report ;;
        4)
            disk_report ;;
        5)
            security_check ;;
        6)
            system_health ;;
        7)
            echo "Exiting... Report saved to $LOGFILE"
            break ;;
        *)
            echo "Invalid option" ;;
    esac

    echo ""
    read -p "Press Enter to continue..."
done
