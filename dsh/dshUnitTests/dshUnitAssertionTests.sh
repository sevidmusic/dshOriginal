#!/bin/bash
set -o posix

# THIS LINE IS VERY IMPORTANT | IT IS THE ONLY LINE REQUIRED FOR ALL TEST FILES source dshUnit
. "$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | sed 's/dshUnitTests//g')dshUnit"

setTestGroup() {
    TESTGROUP="${1:-all}"
}

setTestGroup "${1}"

showTestsRunningLoadingBar "${TESTGROUP}" "dshUnitAssertionTests.sh"

testAssertSuccessRunsWithoutErrorForPassAndFail() {
    notifyUser "    Testing that assertSuccess runs without error for tests that are expected to pass, and tests that are expected to fail." 0 'dontClear'
    assertSuccess "assertSuccess exit"
    assertSuccess "assertSuccess ${RANDOM}"
}

testAssertErrorRunsWithoutErrorForPassAndFail() {
    notifyUser "    Testing that assertError runs without error for tests that are expected to pass, and tests that are expected to fail." 0 'dontClear'
    assertSuccess "assertError ${RANDOM}"
    assertSuccess "assertError exit"
}

testAssertDirectoryExistsRunsWithoutErrorForPassAndFail() {
    notifyUser "    Testing that assertDirectoryExists runs without error for tests that are expected to pass, and tests that are expected to fail." 0 'dontClear'
    assertSuccess "assertDirectoryExists $(pwd)"
    assertSuccess "assertDirectoryExists ${RANDOM}"
}

testAssertDirectoryDoesNotExistRunsWithoutErrorForPassAndFail() {
    notifyUser "    Testing that assertDirectoryDoesNotExist runs without error for tests that are expected to pass, and tests that are expected to fail." 0 'dontClear'
    assertSuccess "assertDirectoryDoesNotExist ${RANDOM}"
    assertSuccess "assertDirectoryDoesNotExist $(pwd)"
}

testAssertSuccessIndicatesPassForExit0() {
    notifyUser "The following call to ${HIGHLIGHTCOLOR}assertSuccess \"exit 0\"${NOTIFYCOLOR} should indicate a ${HIGHLIGHTCOLOR}passing${NOTIFYCOLOR} test, if it does not there is a bug is assertSuccess() or captureError()." 0 'dontClear'
    assertSuccess "exit 0"
}

testAssertSuccessIndicatesFailForExit1() {
    notifyUser "The following call to ${HIGHLIGHTCOLOR}assertSuccess \"exit 1\"${NOTIFYCOLOR} should indicate a ${HIGHLIGHTCOLOR}failing${NOTIFYCOLOR} test, if it does not there is a bug is assertSuccess() or captureError()." 0 'dontClear'
    assertSuccess "exit 1"
}

testAssertErrorIndicatesPassForExit1() {
    notifyUser "The following call to ${HIGHLIGHTCOLOR}assertError \"exit 1\"${NOTIFYCOLOR} should indicate a ${HIGHLIGHTCOLOR}passing${NOTIFYCOLOR} test, if it does not there is a bug is assertError() or captureError()." 0 'dontClear'
    assertError "exit 1"
}

testAssertErrorIndicatesFailForExit0() {
    notifyUser "The following call to ${HIGHLIGHTCOLOR}assertError \"exit 0\"${NOTIFYCOLOR} should indicate a ${HIGHLIGHTCOLOR}failing${NOTIFYCOLOR} test, if it does not there is a bug is assertError() or captureError()." 0 'dontClear'
    assertError "exit 0"
}

if [[ "${TESTGROUP}" == 'all' || "${TESTGROUP}" == 'noErrorForPassAndFail' ]]; then
    testAssertSuccessRunsWithoutErrorForPassAndFail
    testAssertErrorRunsWithoutErrorForPassAndFail
    testAssertDirectoryExistsRunsWithoutErrorForPassAndFail
    testAssertDirectoryDoesNotExistRunsWithoutErrorForPassAndFail
fi

if [[ "${TESTGROUP}" == 'all' || "${TESTGROUP}" == 'indicatePass' ]]; then
    testAssertSuccessIndicatesPassForExit0
    testAssertErrorIndicatesPassForExit1
fi

if [[ "${TESTGROUP}" == 'all' || "${TESTGROUP}" == 'indicateFail' ]]; then
    testAssertSuccessIndicatesFailForExit1
    testAssertErrorIndicatesFailForExit0
fi

if [[ "${TESTGROUP}" == 'all' || "${TESTGROUP}" == 'passTracked' ]]; then
    notifyUser "The following tests are intended to test that the total number of passing tests is tracked and can be obtained via ${HIGHLIGHTCOLOR}dshUnit::showTotals()${NOTIFYCOLOR}, which is called at the end of the ${HIGHLIGHTCOLOR}dshUnitAssertionsTests.sh${NOTIFYCOLOR} test file, and can be optionally called by any test file. After tests are run ${HIGHLIGHTCOLOR}dshUnit::showTotals()${NOTIFYCOLOR} should indicate ${HIGHLIGHTCOLOR}2${NOTIFYCOLOR} passing tests, and ${HIGHLIGHTCOLOR}0${NOTIFYCOLOR} failing tests." 0 'dontClear'
    assertError "${RANDOM} ${RANDOM}"
    assertSuccess "ls"
fi

if [[ "${TESTGROUP}" == 'all' || "${TESTGROUP}" == 'failTracked' ]]; then
    notifyUser "The following tests are intended to test that the total number of failing tests is tracked and can be obtained via ${HIGHLIGHTCOLOR}dshUnit::showTotals()${NOTIFYCOLOR}, which is called at the end of the ${HIGHLIGHTCOLOR}dshUnitAssertionsTests.sh${NOTIFYCOLOR} test file, and can be optionally called by any test file. After tests are run ${HIGHLIGHTCOLOR}dshUnit::showTotals()${NOTIFYCOLOR} should indicate ${HIGHLIGHTCOLOR}2${NOTIFYCOLOR} failing tests, and ${HIGHLIGHTCOLOR}0${NOTIFYCOLOR} passing tests." 0 'dontClear'
    assertSuccess "${RANDOM} ${RANDOM}"
    assertError "ls"
fi

showTestTotals



