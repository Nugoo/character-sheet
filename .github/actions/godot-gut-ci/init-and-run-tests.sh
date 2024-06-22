#!/bin/bash
set -e

GODOT_VERSION=$1
GUT_PARAMS=$2
PROJECT_PATH=$3
GODOT_BIN=/usr/local/bin/godot

echo "Downloading Godot"

wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip

# Unzip it
unzip Godot_v${GODOT_VERSION}-stable_linux.x86_64.zip
mv Godot_v${GODOT_VERSION}-stable_linux.x86_64 $GODOT_BIN
GODOT_PARAMS="--headless"

# Run the tests
if [[ -n $PROJECT_PATH ]]; then
  cd $PROJECT_PATH
fi

echo Importing resources
# Cache custom classes
$GODOT_BIN --debug --headless --import --path $PWD > /dev/null 2>&1

echo Running GUT tests using params:
echo "  -> $GUT_PARAMS"
TEMP_FILE=/tmp/gut.log
$GODOT_BIN --debug --script --headless --path $PWD addons/gut/gut_cmdln.gd -gexit $GUT_PARAMS 2>&1 | tee $TEMP_FILE

# Godot always exists with error 0, but we want this action to fail in case of errors
if grep -q "No tests ran" "$TEMP_FILE" || grep -qE "Asserts\s+none" "$TEMP_FILE";
then
  echo "No test ran. Please check your 'gut_params'"
  exit 1
fi

if  ! grep -q "All tests passed" "$TEMP_FILE"
then
  echo "One or more test have failed"
  exit 1
fi

echo "ALL GOOD :) :) :)"

exit 0