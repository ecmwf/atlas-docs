#!/usr/bin/env bash

ATLAS_DOCS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."
cd ${ATLAS_DOCS_DIR}

if [ -z "${ATLAS_DOCS_TOKEN}" ]; then
    echo "Please provide credentials for https://sites.ecmwf.int/docs/atlas/ "
    echo "  or provide a valid ATLAS_DOCS_TOKEN in environment"
    echo -n "User: "
    read ATLAS_DOCS_USER
    echo -n "Password: "
    read -s ATLAS_DOCS_PASSWORD
    echo
fi

make PUBLIC=1 WITH_ECKIT=1 WITH_DOXYGEN=1 clean html

source venv/bin/activate

if [ -z "${ATLAS_DOCS_TOKEN}" ]; then
    python scripts/publish.py --user=${ATLAS_DOCS_USER} --password=${ATLAS_DOCS_PASSWORD}
else
    python scripts/publish.py --token=${ATLAS_DOCS_TOKEN}
fi
