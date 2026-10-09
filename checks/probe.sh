#!/bin/sh
set -e
H=http://web:8080
# /index.php answers with the benchmark's own page.
curl -fsS "$H/index.php" | grep -qF '<form'
