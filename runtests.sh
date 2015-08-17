#!/bin/sh

[[ "$COVERAGE" == "" ]] && COVERAGE=coverage

$COVERAGE run --branch --source=. -m unittest discover -p '*_test.py'
$COVERAGE html -d coverage_html
