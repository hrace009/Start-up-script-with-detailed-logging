#!/bin/bash

# Define base directory relative to where the script is run or use absolute path
# Using 'home' directly under root '/' is unusual, adjust if needed.
# Example: ServerDir="/srv/myserver" or ServerDir="$HOME/myserver"
ServerDir="138"

# Ensure GsLogFileDir is correctly defined relative to ServerDir or absolute
GsLogFileDir="$ServerDir" # Log file will be in /$ServerDir/
GsLogFileName="GameService_Log"

# ANSI Color Codes
txtnrm='\e[0;0m'  # Normal
txtred='\e[0;31m' # Red
txtgrn='\e[0;32m' # Green

# --- Ensure strace is available (optional but recommended) ---
# Uncomment the line below if you want to enforce strace installation check
command -v strace >/dev/null 2>&1 || { echo >&2 "Error: strace command not found. Please install it (e.g., sudo apt install strace). Aborting."; exit 1; }


# --- Function to Start Services ---
Server::Start()
{
    local base_log_dir="/$ServerDir/logs"
    local starting_log_dir="$base_log_dir/starting"

    # Ensure logs/starting directory exists
    # Creates base logs dir and starting subdir if they don't exist
    if [ ! -d "$starting_log_dir" ]; then
        # Check and create base log directory first if needed
        if [ ! -d "$base_log_dir" ]; then
            echo "Creating base log directory: $base_log_dir"
            # Use mkdir -p for the base directory to create parent if needed
            mkdir -p "$base_log_dir" || { echo >&2 "FATAL: Failed to create base log directory '$base_log_dir'. Check permissions."; exit 1; }
        fi
        # Now create the starting subdirectory
        echo "Creating starting log directory: $starting_log_dir"
        mkdir "$starting_log_dir" || { echo >&2 "FATAL: Failed to create starting log directory '$starting_log_dir'. Check permissions."; exit 1; }
    fi

    echo -e "=== [${txtred} START ${txtnrm}] Log Service ==="
    # Check if directory exists before cd'ing
    if [ -d "/$ServerDir/logservice" ]; then
        cd "/$ServerDir/logservice" && strace -o "$starting_log_dir/logservice_strace.log" -f -tt ./logservice logservice.conf > "$starting_log_dir/logservice.log" 2>&1 &
        sleep 3
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/logservice not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Unique Name ==="
    if [ -d "/$ServerDir/uniquenamed" ]; then
        cd "/$ServerDir/uniquenamed" && strace -o "$starting_log_dir/uniquenamed_strace.log" -f -tt ./uniquenamed gamesys.conf > "$starting_log_dir/uniquenamed.log" 2>&1 &
        sleep 3
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/uniquenamed not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Auth ==="
    if [ -d "/$ServerDir/authd" ]; then
        cd "/$ServerDir/authd" && strace -o "$starting_log_dir/authd_strace.log" -f -tt ./authd start > "$starting_log_dir/authd.log" 2>&1 &
        sleep 5
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
         echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/authd not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Data Base ==="
    if [ -d "/$ServerDir/gamedbd" ]; then
        cd "/$ServerDir/gamedbd" && strace -o "$starting_log_dir/gamedbd_strace.log" -f -tt ./gamedbd gamesys.conf > "$starting_log_dir/gamedbd.log" 2>&1 &
        sleep 10
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gamedbd not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Anti Cheat ==="
    if [ -d "/$ServerDir/gacd" ]; then
        cd "/$ServerDir/gacd" && strace -o "$starting_log_dir/gacd_strace.log" -f -tt ./gacd gamesys.conf > "$starting_log_dir/gacd.log" 2>&1 &
        sleep 5
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gacd not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Faction ==="
    if [ -d "/$ServerDir/gfactiond" ]; then
        cd "/$ServerDir/gfactiond" && strace -o "$starting_log_dir/gfactiond_strace.log" -f -tt ./gfactiond gamesys.conf > "$starting_log_dir/gfactiond.log" 2>&1 &
        sleep 7
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gfactiond not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Delivery ==="
    if [ -d "/$ServerDir/gdeliveryd" ]; then
        cd "/$ServerDir/gdeliveryd" && strace -o "$starting_log_dir/gdeliveryd_strace.log" -f -tt ./gdeliveryd gamesys.conf > "$starting_log_dir/gdeliveryd.log" 2>&1 &
        sleep 5
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gdeliveryd not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Link ==="
    if [ -d "/$ServerDir/glinkd" ]; then
        cd "/$ServerDir/glinkd" && strace -o "$starting_log_dir/glink1_strace.log" -f -tt ./glinkd gamesys.conf 1 > "$starting_log_dir/glink.log" 2>&1 &
        cd "/$ServerDir/glinkd" && strace -o "$starting_log_dir/glink2_strace.log" -f -tt ./glinkd gamesys.conf 2 > "$starting_log_dir/glink2.log" 2>&1 &
        cd "/$ServerDir/glinkd" && strace -o "$starting_log_dir/glink3_strace.log" -f -tt ./glinkd gamesys.conf 3 > "$starting_log_dir/glink3.log" 2>&1 &
        cd "/$ServerDir/glinkd" && strace -o "$starting_log_dir/glink4_strace.log" -f -tt ./glinkd gamesys.conf 4 > "$starting_log_dir/glink4.log" 2>&1 &
        sleep 8
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/glinkd not found. ==="
    fi
    echo -e ""

    echo -e "=== [${txtred} START ${txtnrm}] Game Service ==="
    if [ -d "/$ServerDir/gamed" ]; then
        cd "/$ServerDir/gamed" && strace -o "$starting_log_dir/gs_strace.log" -f -tt ./gs gs01 > "$starting_log_dir/gs01.log" 2>&1 &
        sleep 30
        echo -e "=== [${txtgrn} OK ${txtnrm}] ==="
    else
        echo -e "=== [${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gamed not found. ==="
    fi
    echo ""
    echo "--- Server Startup Sequence Complete ---"
    echo ""
}

# --- Function to Stop Services ---
Server::Stop()
{
    echo ""
    echo "--- Initiating Server Shutdown Sequence ---"

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Log Service..."
    pkill -9 logservice # Corrected name
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Link..."
    pkill -9 glinkd
    sleep 5 # Reduced sleep from 15 unless truly needed

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Auth..."
    pkill -9 authd
    sleep 2 # Reduced sleep

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Delivery..."
    pkill -9 gdeliveryd
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Anti Cheat..."
    pkill -9 gacd
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Game Service..."
    pkill -9 gs
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Faction..."
    pkill -9 gfactiond
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Unique Name..."
    pkill -9 uniquenamed
    sleep 2

    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Data Base..."
    pkill -9 gamedbd
    sleep 2

    # Stop Java - Be cautious, ensure this doesn't kill unrelated Java processes
    # Consider a more specific pkill if possible, e.g., pkill -f 'java -jar yourserver.jar'
    echo -e "[ ${txtred}STOP${txtnrm} ] Stopping Java (Use with caution)..."
    pkill -9 java
    sleep 3

    echo "--- Server Shutdown Sequence Complete ---"
    echo ""
}

# --- Main Execution Logic ---
PARAM_STR=$1

# Function for usage instructions
usage() {
    echo "Usage: $0 [start|stop|restart|getlog]" >&2
    exit 1
}

if [ -z "$PARAM_STR" ]; then
    echo "Error: No command specified." >&2
    usage
fi

case "$PARAM_STR" in
    start)
        Server::Start
        ;;
    stop)
        Server::Stop
        ;;
    restart)
        Server::Stop
        echo ""
        echo "--- Restarting services ---"
        sleep 5 # Add a small delay before restarting
        Server::Start
        ;;
    getlog)
        # Ensure target directory exists before trying to write log
        mkdir -p "/$GsLogFileDir/" || { echo >&2 "FATAL: Failed to ensure log directory /$GsLogFileDir/ exists."; exit 1; }
        if [ -d "/$ServerDir/gamed" ]; then
             # Assuming './gs log' command exists and works
             cd "/$ServerDir/gamed" && ./gs log > "/$GsLogFileDir/$GsLogFileName.txt"
             echo -e "[${txtgrn} OK ${txtnrm}] Getting Logs. Path To Log File: /${GsLogFileDir}/${GsLogFileName}.txt"
        else
             echo -e "[${txtred} FAILED ${txtnrm}] Directory /$ServerDir/gamed not found. Cannot get log."
        fi
        ;;
    *)
        echo "Error: Invalid command '$PARAM_STR'." >&2
        usage
        ;;
esac

exit 0
