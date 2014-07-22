#!/bin/sh
if [ -z "$PKEY" ]; then
# if PKEY is not specified, run ssh using default keyfile
ssh "$@"
else
ssh -o StrictHostKeyChecking=no -i "$PKEY" "$@"
fi
