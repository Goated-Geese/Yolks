#!/bin/bash
# Pelican / Wings entrypoint for the dotnet_10 yolk.
# Mirrors https://github.com/pelican-eggs/yolks/blob/master/dotnet/entrypoint.sh

cd /home/container || exit 1

INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

export DOTNET_ROOT=/usr/share

printf "\033[1m\033[33mcontainer~ \033[0mdotnet --version\n"
dotnet --version

MODIFIED_STARTUP=$(echo -e "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo -e ":/home/container$ ${MODIFIED_STARTUP}"

eval ${MODIFIED_STARTUP}
