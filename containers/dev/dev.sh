#!/usr/bin/env bash
set -o pipefail

function get_docker() {
    echo "Docker is required to build and run OpenHands."
    echo "https://docs.docker.com/get-started/get-docker/"
    exit 1
}

function check_tools() {
	command -v docker &>/dev/null || get_docker
}

function exit_if_indocker() {
    if [ -f /.dockerenv ]; then
        echo "Running inside a Docker container. Exiting..."
        exit 1
    fi
}

#
exit_if_indocker

check_tools

##
OPENHANDS_WORKSPACE=$(git rev-parse --show-toplevel)

cd "$OPENHANDS_WORKSPACE/containers/dev/" || exit 1

##
export BACKEND_HOST="0.0.0.0"
#
#export SANDBOX_USER_ID=$(id -u)
#export WORKSPACE_BASE=${WORKSPACE_BASE:-$OPENHANDS_WORKSPACE/workspace}

#docker compose run --rm --service-ports "$@" dev
#export SANDBOX_USER_ID=$(id -u)
#export WORKSPACE_BASE=${WORKSPACE_BASE:-$OPENHANDS_WORKSPACE/workspace}
export WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE
export AGENT_ENABLE_PROMPT_EXTENSIONS=false
export LOG_ALL_EVENTS=true
export LLM_NATIVE_TOOL_CALLING=true
export LLM_DISABLE_STOP_WORD=true
export LLM_REASONING_EFFORT=high
export WORKSPACE_BASE=/home/jesse/sandbox

# --service-ports "$@"
docker compose run --rm -p 3001:3000 -p 3003:3001 \
  -e WORKSPACE_MOUNT_PATH=$WORKSPACE_BASE \
    -v $WORKSPACE_BASE:/opt/workspace_base \
    -e AGENT_ENABLE_PROMPT_EXTENSIONS=false \
    -e LOG_ALL_EVENTS=true \
    -e LLM_NATIVE_TOOL_CALLING=true \
    -e LLM_DISABLE_STOP_WORD=true \
    -e LLM_REASONING_EFFORT=high \
    -e FILE_STORE_PATH=/.openhands \
    -e SANDBOX_ENABLE_GPU=true \
    -e SANDBOX_CUDA_VISIBLE_DEVICES=0 \
    -e DEBUG=true \
    -v ~/.openhands:/.openhands \
    -v /run/user/1000/docker.sock:/var/run/docker.sock \
  dev

##
