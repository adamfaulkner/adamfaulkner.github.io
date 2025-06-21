#!/usr/bin/env bash

for f in *.md; do
  echo "Processing $f";
  marked -i $f -o ${f%.md}.html;
done;
