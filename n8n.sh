#!/data/data/com.termux/files/usr/bin/bash
source "$(dirname "${BASH_SOURCE[0]}")/source.env"

cd "$(dirname "${BASH_SOURCE[0]}")"

IMAGE_NAME="n8nio/n8n:latest"
CONTAINER_NAME="n8n"

# Default n8n port
case $PORT in
    ''|*[!0-9]*) PORT=5678;;
    *) [ $PORT -gt 1023 ] && [ $PORT -lt 65536 ] || PORT=5678;;
esac

udocker_check
udocker_prune
udocker_create "$CONTAINER_NAME" "$IMAGE_NAME"

DATA_DIR="$HOME/udocker/data-$CONTAINER_NAME"
mkdir -p "$DATA_DIR"

if [ -n "$1" ]; then
  # Run custom command
  unset cmd
  cmd="$*"
  udocker_run -p "$PORT:5678" \
      -v "$DATA_DIR:/data" \
      -e N8N_USER_FOLDER="/data" \
      "$CONTAINER_NAME" $cmd
else
  # Run default n8n
  udocker_run -p "$PORT:5678" \
      -v "$DATA_DIR:/data" \
      -e N8N_USER_FOLDER="/data" \
      "$CONTAINER_NAME"
fi

exit $?