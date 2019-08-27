#!/bin/bash

filename="$1"

while IFS= read -r line || [[ -n "$line" ]]; do
    you-get $line
done < "$filename"