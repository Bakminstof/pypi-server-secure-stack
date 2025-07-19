#!/bin/env bash
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ENV_FILE=".env"

pushd "$SCRIPT_DIR"

export CURRENT_USER_ID=$(id -u)
export CURRENT_GROUP_ID=$(id -g)

export $(grep -v '^#' "$ENV_FILE" | tr '\r' '\0' | xargs -d '\n')

chown -R $CURRENT_USER_ID:$CURRENT_GROUP_ID logs nginx certs pypi

docker compose down

git clean -fd
git restore *
git reset --hard
git pull origin "$GIT_BRANCH"

docker compose up

popd
