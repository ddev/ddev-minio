setup() {
  TEST_BREW_PREFIX="$(brew --prefix)"
  load "${TEST_BREW_PREFIX}/lib/bats-support/load.bash"
  load "${TEST_BREW_PREFIX}/lib/bats-assert/load.bash"
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-minio
  mkdir -p $TESTDIR
  export PROJNAME=test-minio
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  ddev config --project-name=${PROJNAME}
  ddev config --disable-upload-dirs-warning
  ddev start -y >/dev/null
}

health_checks() {
  set +u # bats-assert has unset variables so turn off unset check
  # ddev restart is required because we have done `ddev get` on a new service
  run ddev restart
  assert_success
  # Make sure we can hit the 8090 port successfully
  curl -s -I -f  https://${PROJNAME}.ddev.site:8090 >/tmp/curlout.txt
  # Make sure `ddev minio` works
  DDEV_DEBUG=true run ddev minio
  assert_success
  assert_output "FULLURL https://${PROJNAME}.ddev.site:8090"
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev restart
  health_checks
}

@test "install from release" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  echo "# ddev get oblakstudio/ddev-minio with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get oblakstudio/ddev-minio
  ddev restart >/dev/null
  health_checks
}

