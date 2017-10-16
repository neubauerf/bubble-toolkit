#!/bin/bash
. `dirname $0`/../helper_scripts/cosmic/helperlib.sh

set -e

function usage {
  printf "Usage: %s: -m marvin_config test1 test2 ... testN\n" $(basename $0) >&2
}

say "Running script: $0"

function update_management_server_in_marvin_config {
  marvin_config=$1
  csip=$2

  sed -i "s/\"mgtSvrIp\": \"localhost\"/\"mgtSvrIp\": \"${csip}\"/" ${marvin_config}

  say "Management Server in Marvin Config updated to ${csip}"
}

function run_marvin_tests {
  config_file=$1
  tests="$2"
  halt_on_failure="$3"

  nose_tests_report_file=nosetests.xml

  cd cosmic-core/test/integration
  nosetests --with-xunit --xunit-file=../../../${nose_tests_report_file} --with-marvin --marvin-config=../../../${config_file} ${halt_on_failure} -s -a tags=advanced ${tests}
  cd -
}

halt_on_failure=

# Options
while getopts ':m:f' OPTION
do
  case $OPTION in
  m)    marvin_config="$OPTARG"
        ;;
  f)    halt_on_failure="--halt-on-failure"
        ;;
  esac
done

marvin_tests=${@:$OPTIND}

say "Received arguments:"
say "marvin_config = ${marvin_config}"
say "marvin_tests = \"${marvin_tests}\""
say "halt_on_failure = ${halt_on_failure}"

# Check if a marvin dc file was specified
if [ -z ${marvin_config} ]; then
  say "No Marvin config specified. Quiting."
  usage
  exit 1
else
  say "Using Marvin config '${marvin_config}'."
fi

if [ ! -f "${marvin_config}" ]; then
    say "Supplied Marvin config not found!"
    exit 1
fi

# Check if a marvin dc file was specified
if [ -z "${marvin_tests}" ]; then
  say "No Marvin Tests Specified. Quiting."
  usage
  exit 2
fi

parse_marvin_config ${marvin_config}

say "Making local copy of Marvin Config file"
cp ${marvin_config} .

marvin_config_copy=$(basename ${marvin_config})

say "Updating Marvin Config with Management Server IP"
update_management_server_in_marvin_config ${marvin_config_copy} ${cs1ip}

say "Running tests"
run_marvin_tests ${marvin_config_copy} "${marvin_tests}" ${halt_on_failure}
