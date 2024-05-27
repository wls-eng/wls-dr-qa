#!/bin/bash

export WL_HOME="{{ weblogic_home }}"
export TEST_BASE_DIR="{{ test_work_dir }}"
export RELEASE="{{ weblogic_home }}/server"
export WLS_TEST_RESULTS_ctl="{{ wls_test_results_ctl }}"
export BUILDOUT_ctl="{{ buildout_ctl }}"

mkdir -p $WLS_TEST_RESULTS_ctl
mkdir -p $BUILDOUT_ctl

. $WL_HOME/server/bin/setWLSEnv.sh

rm -f $TEST_BASE_DIR/*.log

cd $TEST_BASE_DIR/wlstest
. ./qaenv.sh

cd $TEST_BASE_DIR/wlstest/wlstest/common/wls_ha_dr_test/basic
ant -f basic.cluster.test.xml clean build all > $TEST_BASE_DIR/basic.test.log

sed -n '/\[testlogic\] | Clean run/, /TEST RUN COMPLETE/p' *.test.log

sed -n '/\[testlogic\] | Not a clean run/, /TEST RUN COMPLETE/p' *.test.log

if grep -iq "not a clean run :-(" $TEST_BASE_DIR/*.log
then
	echo "All tests didn't pass successfully"
	exit 1
else
	echo "All tests passed successfully"
	exit 0
fi


