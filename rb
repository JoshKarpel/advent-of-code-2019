#!/usr/bin/env bash

set -e

echo "Running: day_$1.rb"
echo "----------------------------"
ruby ruby/day_"$1".rb
