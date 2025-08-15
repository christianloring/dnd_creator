#!/bin/bash
set -e

# Load environment variables
set -a
source .env
set +a

# Run kamal with the provided arguments
kamal "$@"
