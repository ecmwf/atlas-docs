#!/usr/bin/env bash

# This script should be sourced to install atlas documentation in a Python virtualenv.
#
#   . ./atlas-doc-env [-p python-binary] [-d venv-directory]
#                     [-s atlas-source] [-b atlas-branch]
#
ATLAS_DOCS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/.."

USAGE_HELP="Usage: $(basename $0) [OPTIONS]

Options:
  -p, --python PATH          Python binary to use for virtualenv install
  -d, --env-dir PATH         Path of the virtualenv to create (default: venv)
  --atlas PATH               Path to atlas source repository
  --eckit PATH               Path to eckit source repository
  --version VERSION          Version of atlas git repository
  -f, --force                Force a clean re-install of the virtualenv
  --proxy                    Proxy to use for pip installs
  --https                    Use https to perform initial atlas install
  -h, --help                 Show this message and exit.
"

_here=$(pwd)
_pyenv_path="venv"       # Default python environment name
_pyenv_bin="python3"          # Default python interpreter for the venv
_pyenv_force=false            # By default don't force the venv installation
_pyenv_requirements=false     # By default don't install requirements
_pyenv_proxy=false            # By default don't use a proxy

# Default location and branch for atlas source retrieval 
_atlas_source=false        # Default will be set once know if we use htts or ssh
_atlas_branch="develop"
_eckit_source=false
_eckit_branch="master"
_atlas_bin=atlas-create    # Command to check if atlas is already installed
_atlas_https=false         # By default use ssh for git checkout

# TODO: Python2 legacy setup (bootstrap `virtualenv` from pypi)

PARAMS=""
while (( "$#" )); do
    case "$1" in
    -p|--python)
        _pyenv_bin=$2
        shift 2 ;;
    -d|--env-dir)
        _pyenv_path=$2
        shift 2 ;;
    --atlas)
        _atlas_source=$2
        shift 2 ;;
    --eckit)
        _eckit_source=$2
        shift 2 ;;
    --version)
        _atlas_branch=$2
        shift 2 ;;
    -f|--force)
        _pyenv_force=true
        shift 1 ;;
    -r|--requirements)
        _pyenv_requirements=$2
        shift 2 ;;
    --proxy)
        _pyenv_proxy=$2
        shift 2 ;;
    --https)
        _atlas_https=true
        shift 1 ;;
    -h|--help)
        echo "${USAGE_HELP}" >&2
        exit 0
        shift 1 ;;
    --) # end argument parsing
        shift
        break
        ;;
    -*|--*=) # unsupported flags
    echo "Error: Unsupported flag $1" >&2
    echo "${USAGE_HELP}" >&2
    exit 1
    ;;
    *) # preserve positional arguments
        PARAMS="$PARAMS $1"
        shift
        ;;
    esac
done

# set positional arguments in their proper place
eval set -- "$PARAMS"

command_exists () { type "$1" &> /dev/null ; }



mkdir -p $ATLAS_DOCS_DIR/downloads
if [[ ! -d $ATLAS_DOCS_DIR/downloads/atlas ]]; then
    if [[ -d "${_atlas_source}" ]]; then
        _atlas_source="$( cd ${_atlas_source} && pwd )"
        echo "Use existing atlas sources at ${_atlas_source}"
        ln -sf ${_atlas_source} $ATLAS_DOCS_DIR/downloads/atlas
    else
        if [[ ${_atlas_source} == false ]] ; then
            # Set default checkout locations
            _atlas_source="https://github.com/ecmwf/atlas"
        fi
        git clone -b ${_atlas_branch} ${_atlas_source} $ATLAS_DOCS_DIR/downloads/atlas
    fi
fi

if [[ ! -d $ATLAS_DOCS_DIR/downloads/eckit ]]; then
    if [[ -d "${_eckit_source}" ]]; then
        _eckit_source="$( cd ${_eckit_source} && pwd )"
        echo "Use existing eckit sources at ${_eckit_source}"
        ln -sf ${_eckit_source} $ATLAS_DOCS_DIR/downloads/eckit
    else
        if [[ ${_eckit_source} == false ]] ; then
            # Set default checkout locations
            _eckit_source="https://github.com/ecmwf/eckit"
        fi
        git clone -b ${_eckit_branch} ${_eckit_source} $ATLAS_DOCS_DIR/downloads/eckit
    fi
fi

[ -d ${ATLAS_DOCS_DIR}/downloads/m.css ] || git clone -b mathtools https://github.com/wdeconinck/m.css ${ATLAS_DOCS_DIR}/downloads/m.css


if ! command_exists ${_pyenv_bin} ; then
    echo "ERROR: Python command \"${_pyenv_bin}\" not found!"
    exit 1
fi

if [[ -d "$_pyenv_path" && ${_pyenv_force} == true ]]; then
    # Remove existing virtualenv to trigger re-install
    echo "[atlas-docs] Removing virtualenv in ${_pyenv_path}"
    rm -rf ${_pyenv_path}
fi

if [ ! -d "$_pyenv_path" ]; then
    # Create a new virtualenv from a given python binary
    echo "[atlas-docs] Creating ${_pyenv_bin} virtualenv in ${_pyenv_path}"

    # Make sure python has required version
    required_python_version=3.6
    python_version_ok=$(${_pyenv_bin} -c "import sys; print( sys.version_info[:3] >= tuple(map(int, '${required_python_version}'.split('.'))))")
    if [[ "${python_version_ok}" != "True" ]]; then
        python_version=$(${_pyenv_bin} -c "import sys; print( '.'.join([str(v) for v in sys.version_info[:3]]) )")
        echo "ERROR: python version \"${required_python_version}\" or greater required (used version \"${python_version}\")"
        exit 1
    fi

    ${_pyenv_bin} -m venv ${_pyenv_path}
fi

# Activate virtualenv
echo "[atlas-docs] Activating Python virtualenv in ${_pyenv_path}"
source ${_pyenv_path}/bin/activate

# Make sure doxygen has required version
echo "[atlas-docs] Checking doxygen has as suitable version"
required_doxygen_version=1.8.17
doxygen_version=$(echo $(doxygen --version) | cut -d' ' -f1)
doxygen_version_ok=$(python -c "\
from distutils.version import StrictVersion; \
print(StrictVersion('${doxygen_version}') >= StrictVersion('${required_doxygen_version}') )")
if [[ "${doxygen_version_ok}" != "True" ]]; then
    echo "ERROR: doxygen version \"${required_doxygen_version}\" or greater required (used version \"${doxygen_version}\")"
    exit 1
fi

if [[ ${_pyenv_proxy} != false ]] ; then
    _pip_cmd="pip --disable-pip-version-check install --proxy ${_pyenv_proxy}"
else
    _pip_cmd="pip --disable-pip-version-check install"
fi

${_pip_cmd} jinja2 Pygments pelican
${_pip_cmd} sites-toolkit --index-url https://nexus.ecmwf.int/repository/pypi-all/simple

ln -sf ${ATLAS_DOCS_DIR}/downloads/m.css/documentation/doxygen.py ${_pyenv_path}/bin/doxygen.py
ln -sf ${ATLAS_DOCS_DIR}/downloads/m.css ${_here}/pelican/m.css

unset _pyenv_path _pyenv_bin _atlas_source _atlas_branch _atlas_bin
unset _pyenv_force _pyenv_requirements _pyenv_proxy _atlas_https _pip_cmd USAGE_HELP
