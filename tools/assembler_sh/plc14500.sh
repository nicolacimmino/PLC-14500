#!/usr/bin/env bash
# plc14500.sh — PLC-14500 assembler (bash port of the Dart assembler)
#
# Usage: plc14500.sh <file.asm>
# Output: <file>.bin — 256 raw bytes, padded with NOPF (0x0F)

# ── Opcode table (4-bit values) ───────────────────────────────────────────────

declare -A OPCODES=(
    [NOPO]=0   [LD]=1    [LDC]=2   [AND]=3
    [ANDC]=4   [OR]=5    [ORC]=6   [XNOR]=7
    [STO]=8    [STOC]=9  [IEN]=10  [OEN]=11
    [JMP]=12   [RTN]=13  [SKZ]=14  [NOPF]=15
)

declare -A METADATA=()
INSTRUCTIONS=()
BYTES=()
RESOLVE_RESULT=0
DUMP_LINES=()

# ── Helpers ───────────────────────────────────────────────────────────────────

die() {
    echo "$1"
    exit 1
}

usage() {
    [[ -n "${1:-}" ]] && echo "$1"
    echo "Usage: plc14500.sh [-d] [-p <port>] <file.asm>"
    echo "  -d         Write a .dump listing to <file's dir>/.build/"
    echo "  -p <port>  Upload binary to serial port after assembling (9600,n,8,1)"
    echo "             Linux: /dev/ttyUSB0  macOS: /dev/cu.usbmodem*  Windows: /dev/ttyS3"
}

# Configure a serial port (Linux uses -F, macOS uses -f)
_stty() {
    stty -F "$@" 2>/dev/null || stty -f "$@"
}

# Convert a bash/MSYS path to a Windows path for PowerShell
_winpath() {
    cygpath -w "$1" 2>/dev/null || echo "$1"
}

# ── Serial upload ─────────────────────────────────────────────────────────────

_upload_unix() {
    local port="$1"

    echo "Configuring $port at 9600,n,8,1..."
    _stty "$port" 9600 cs8 -cstopb -parenb raw -echo clocal -crtscts \
        || die "Cannot configure serial port: $port"

    # Open port for read and write; this triggers DTR reset on most boards
    exec 3<>"$port"

    echo "Waiting for bootloader prompt..."

    local found=0 line start=$SECONDS
    while (( SECONDS - start < 15 )); do
        if IFS= read -t 2 -r -d $'\n' -u 3 line; then
            line="${line%$'\r'}"
            if [[ "$line" == *"PRESS ENTER FOR INTERACTIVE MONITOR."* ]]; then
                found=1
                break
            fi
        fi
    done

    if (( ! found )); then
        exec 3>&-
        die "Timeout: bootloader prompt not received on $port"
    fi

    echo "Sending ${#BYTES[@]} bytes..."
    for byte in "${BYTES[@]}"; do
        printf '%b' "$(printf '\\x%02x' "$byte")" >&3
    done

    exec 3>&-
    echo "Upload complete."
}

_upload_windows() {
    local port="$1"

    # Accept COM2 or /dev/ttyS1 (ttyS n = COM n+1)
    local comport
    if [[ "${port^^}" =~ ^COM[0-9]+$ ]]; then
        comport="${port^^}"
    elif [[ "$port" =~ ^/dev/ttyS([0-9]+)$ ]]; then
        comport="COM$(( BASH_REMATCH[1] + 1 ))"
    else
        die "Cannot map '$port' to a Windows COM port (use COM2 or /dev/ttyS1)"
    fi

    local winbin
    winbin=$(_winpath "$outfile")

    local tmpps
    tmpps=$(mktemp --suffix=.ps1)
    local winps
    winps=$(_winpath "$tmpps")

    # Write PowerShell script; bash expands $comport/$winbin, \$ becomes PS variable
    cat > "$tmpps" <<PSEOF
\$ErrorActionPreference = 'Stop'
\$sp = New-Object System.IO.Ports.SerialPort('$comport', 9600, [System.IO.Ports.Parity]::None, 8, [System.IO.Ports.StopBits]::One)
\$sp.ReadTimeout = 2000
try { \$sp.Open() } catch { Write-Host "Cannot open ${comport}: \$_"; exit 1 }
\$sp.DiscardInBuffer()
\$sp.DtrEnable = \$true
Start-Sleep -Milliseconds 250
\$sp.DtrEnable = \$false
Write-Host 'Waiting for bootloader prompt...'
\$found = \$false
\$deadline = [DateTime]::Now.AddSeconds(15)
while ([DateTime]::Now -lt \$deadline) {
    try {
        \$line = \$sp.ReadLine()
        if (\$line -match 'PRESS ENTER FOR INTERACTIVE MONITOR') { \$found = \$true; break }
    } catch [System.TimeoutException] { }
}
if (-not \$found) { \$sp.Close(); Write-Host 'Timeout: bootloader prompt not received on $comport'; exit 1 }
Write-Host 'Sending program...'
\$bytes = [System.IO.File]::ReadAllBytes('$winbin')
\$sp.Write(\$bytes, 0, \$bytes.Length)
\$sp.Close()
Write-Host 'Upload complete.'
PSEOF

    echo "Uploading to $comport..."
    powershell.exe -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$winps"
    local rc=$?
    rm -f "$tmpps"
    (( rc == 0 )) || die "Upload failed"
}

upload_to_serial() {
    local port="$1"
    if [[ -n "${MSYSTEM:-}" || "$OSTYPE" == msys* || "$OSTYPE" == cygwin* ]]; then
        _upload_windows "$port"
    else
        _upload_unix "$port"
    fi
}

# Trim leading and trailing whitespace (pure bash, no subshell needed)
trim_var() {
    local -n _ref="$1"
    _ref="${_ref#"${_ref%%[![:space:]]*}"}"
    _ref="${_ref%"${_ref##*[![:space:]]}"}"
}

# Strip inline comment: remove ';' and everything after it,
# but only if ';' appears after position 0 (matching Dart: indexOf(";") > 0).
strip_comment_var() {
    local -n _sref="$1"
    if [[ "${_sref}" == *";"* ]]; then
        local before="${_sref%%;*}"
        [[ ${#before} -gt 0 ]] && _sref="$before"
    fi
}

# Resolve an I/O label to a numeric address.
# Result is stored in RESOLVE_RESULT (avoids subshell so die() works correctly).
resolve_io() {
    local label="$1"

    # Friendly name lookup: .io_LABEL=ADDRESS directives
    local meta_key="IO_${label}"
    if [[ -v "METADATA[$meta_key]" ]]; then
        label="${METADATA[$meta_key]}"
    fi

    # Direct integer address
    if [[ "$label" =~ ^[0-9]+$ ]]; then
        RESOLVE_RESULT="$label"
        return
    fi

    # Board aliases for PLC14500-Nano
    case "$label" in
        RR)        label="SPR7" ;;
        TMR0-OUT)  label="IN7"  ;;
        TMR0-TRIG) label="OUT7" ;;
    esac

    # Standard I/O labels
    if [[ "$label" =~ ^IN([0-9]+)$ ]];  then RESOLVE_RESULT=$(( 8 + ${BASH_REMATCH[1]} )); return; fi
    if [[ "$label" =~ ^OUT([0-9]+)$ ]]; then RESOLVE_RESULT=$(( 8 + ${BASH_REMATCH[1]} )); return; fi
    if [[ "$label" =~ ^SPR([0-9]+)$ ]]; then RESOLVE_RESULT=${BASH_REMATCH[1]};             return; fi

    die "Invalid label $label"
}

# ── Argument validation ───────────────────────────────────────────────────────

PORT=""
DUMP=0

while getopts ":dp:" opt; do
    case $opt in
        d) DUMP=1 ;;
        p) PORT="$OPTARG" ;;
        :) usage "-p requires a port argument"; exit 1 ;;
        \?) usage "Unknown option: -$OPTARG"; exit 1 ;;
    esac
done
shift $(( OPTIND - 1 ))

if [[ $# -ne 1 ]]; then
    usage
    exit 0
fi

SOURCE_FILE="$1"

if [[ "$SOURCE_FILE" != *.asm ]]; then
    usage "Invalid input file"
    exit 0
fi

if [[ ! -f "$SOURCE_FILE" ]]; then
    die "$SOURCE_FILE not found"
fi

# ── Parse file ────────────────────────────────────────────────────────────────

echo "Assembling $(basename "$SOURCE_FILE")..."

while IFS= read -r raw_line || [[ -n "$raw_line" ]]; do
    line="$raw_line"
    trim_var line

    # ── Metadata: lines starting with '.' ────────────────────────────────────
    if [[ "$line" == "."* ]]; then
        strip_comment_var line
        trim_var line

        IFS='=' read -ra parts <<< "$line"
        if [[ ${#parts[@]} -ne 2 ]]; then
            die "invalid meta content: $line"
        fi

        key="${parts[0]}"
        trim_var key
        key="${key#.}"   # strip leading dot
        key="${key^^}"   # uppercase

        value="${parts[1]}"
        trim_var value
        value="${value^^}"  # uppercase

        METADATA["$key"]="$value"
    fi

    # ── Instructions: lines starting with a letter ────────────────────────────
    if [[ "$line" =~ ^[a-zA-Z] ]]; then
        strip_comment_var line
        trim_var line
        line="${line^^}"   # uppercase

        # Collapse internal whitespace to single space
        read -ra words <<< "$line"
        line="${words[*]}"

        INSTRUCTIONS+=("$line")
    fi

done < "$SOURCE_FILE"

# ── Validate board ────────────────────────────────────────────────────────────

board="${METADATA[BOARD]:-}"
if [[ "$board" != "PLC14500-NANO" ]]; then
    die "Unknown board type $board"
fi

echo "Target: $board | ${#INSTRUCTIONS[@]} instructions found"

# ── Build dump header ─────────────────────────────────────────────────────────

source_basename=$(basename "$SOURCE_FILE")
DUMP_LINES+=("SOURCE: ${source_basename^^}")
DUMP_LINES+=("TARGET: ${METADATA[BOARD]}")
DUMP_LINES+=("PRG MEMORY: 256 BYTES")
DUMP_LINES+=("----------------------------")
DUMP_LINES+=("ADDR    BYTECODE INSTR ARG")
DUMP_LINES+=("----------------------------")

# ── Assemble ──────────────────────────────────────────────────────────────────

for line in "${INSTRUCTIONS[@]}"; do
    read -ra tokens <<< "$line"
    mnemonic="${tokens[0]}"
    argument="${tokens[1]:-}"

    if [[ ! -v "OPCODES[$mnemonic]" ]]; then
        die "Invalid mnemonic: $mnemonic"
    fi

    opcode="${OPCODES[$mnemonic]}"
    result="$opcode"

    if [[ -n "$argument" ]]; then
        resolve_io "$argument"
        result=$(( opcode | (RESOLVE_RESULT << 4) ))
    fi

    # Validate: JMP with non-zero operand (warning only)
    if (( (result & 0xF) == 12 && (result & 0xF0) != 0 )); then
        echo "Warning: PLC14500-Nano can only JMP 0, operand value has no effect."
    fi

    BYTES+=("$result")
    addr=$(( ${#BYTES[@]} - 1 ))
    DUMP_LINES+=("$(printf '%04x    %02x       %-5s %s' "$addr" "$result" "$mnemonic" "$argument")")

    if (( ${#BYTES[@]} > 256 )); then
        die "Program too long, max 256 bytes"
    fi
done

# ── Build dump footer ─────────────────────────────────────────────────────────

program_size=${#BYTES[@]}
DUMP_LINES+=("----------------------------")
DUMP_LINES+=("SIZE: ${program_size} BYTES")

# ── Pad to 256 bytes with NOPF (0x0F) ────────────────────────────────────────

while (( ${#BYTES[@]} < 256 )); do
    BYTES+=(15)
done

# ── Write binary output ───────────────────────────────────────────────────────

source_stem=$(basename "${SOURCE_FILE%.asm}")
build_dir="$(dirname "$SOURCE_FILE")/.build"
mkdir -p "$build_dir"

outfile="$build_dir/$source_stem.bin"
{
    for byte in "${BYTES[@]}"; do
        printf '%b' "$(printf '\\x%02x' "$byte")"
    done
} > "$outfile"

echo "Program assembled: $program_size bytes (padded to 256)"

# ── Write dump output (only when -d is passed) ────────────────────────────────

if (( DUMP )); then
    dumpfile="$build_dir/$source_stem.dump"
    {
        for dline in "${DUMP_LINES[@]}"; do
            printf '%s\r\n' "$dline"
        done
    } > "$dumpfile"
    echo "Output: $outfile, $dumpfile"
else
    echo "Output: $outfile"
fi

# ── Upload to serial port (if requested) ──────────────────────────────────────

[[ -n "$PORT" ]] && upload_to_serial "$PORT"
