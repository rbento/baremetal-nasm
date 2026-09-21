#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning up..."
make clean
rm -rf .cache .gdb_history tags

echo "Building debug target..."
make debug

echo "Generating Ctags..."
ctags -R .

TARGET=$(make print-target)

echo ""
echo "Generated:"
echo "- $TARGET"
echo "- build/"
echo "- tags"
echo "Done"
