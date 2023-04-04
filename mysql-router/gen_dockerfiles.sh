#!/bin/bash
set -e

source ./VERSION

REPO=https://repo.mysql.com; [ -n "$1" ] && REPO=$1
CONFIG_PACKAGE_NAME=mysql80-community-release-el8.rpm; [ -n "$2" ] && CONFIG_PACKAGE_NAME=$2
MYSQL_CLIENT_PACKAGE=mysql-community-client-${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}; [ -n "$3" ] && MYSQL_CLIENT_PACKAGE=$3
MYSQL_ROUTER_PACKAGE=mysql-router-community-${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}; [ -n "$4" ] && MYSQL_ROUTER_PACKAGE=$4
MYSQL_CLIENT_PACKAGE_TEST=mysql-community-client; [ -n "$5" ] && MYSQL_CLIENT_PACKAGE_TEST=$5
MYSQL_ROUTER_PACKAGE_TEST=mysql-router-community; [ -n "$6" ] && MYSQL_ROUTER_PACKAGE_TEST=$6
REPO_NAME_SERVER=mysql80-community; [ -n "$7" ] && REPO_NAME_SERVER=$7
REPO_NAME_TOOLS=mysql-tools-community; [ -n "$8" ] && REPO_NAME_TOOLS=$8
for MAJOR_VERSION in "${!MYSQL_ROUTER_VERSIONS[@]}"; do
    sed 's#%%MYSQL_CLIENT_PACKAGE%%#'"${MYSQL_CLIENT_PACKAGE}"'#g' template/Dockerfile > tmpFile
    sed -i 's#%%MYSQL_ROUTER_PACKAGE%%#'"${MYSQL_ROUTER_PACKAGE}"'#g' tmpFile
    sed -i 's#%%CONFIG_PACKAGE_NAME%%#'"${CONFIG_PACKAGE_NAME}"'#g' tmpFile
    sed -i 's#%%REPO%%#'"${REPO}"'#g' tmpFile
    sed -i 's#%%REPO_NAME_SERVER%%#'"${REPO_NAME_SERVER}"'#g' tmpFile
    sed -i 's#%%REPO_NAME_TOOLS%%#'"${REPO_NAME_TOOLS}"'#g' tmpFile
    mv tmpFile $MAJOR_VERSION/Dockerfile

    # update test template
    sed -e 's#%%MYSQL_CLIENT_PACKAGE_TEST%%#'"${MYSQL_CLIENT_PACKAGE_TEST}"'#g' template/control.rb > tmpFile
    sed -i -e 's#%%MYSQL_CLIENT_PACKAGE_VERSION%%#'"${MYSQL_SERVER_VERSIONS[${MAJOR_VERSION}]}"'#g' tmpFile
    sed -i -e 's#%%MYSQL_ROUTER_PACKAGE_TEST%%#'"${MYSQL_ROUTER_PACKAGE_TEST}"'#g' tmpFile
    sed -i -e 's#%%MYSQL_ROUTER_PACKAGE_VERSION%%#'"${MYSQL_ROUTER_VERSIONS[${MAJOR_VERSION}]}"'#g' tmpFile
    sed -i -e 's#%%MAJOR_VERSION%%#'"${MAJOR_VERSION}"'#g' tmpFile
    if [ ! -d "${MAJOR_VERSION}/inspec" ]; then
      mkdir "${MAJOR_VERSION}/inspec"
    fi
    mv tmpFile "${MAJOR_VERSION}/inspec/control.rb"

    # copy entrypoint script
    cp template/run.sh $MAJOR_VERSION/run.sh
    chmod +x $MAJOR_VERSION/run.sh

    cp README.md $MAJOR_VERSION/
done

