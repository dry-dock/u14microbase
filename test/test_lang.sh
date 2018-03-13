#!/bin/bash -e

echo "================= OS Information ==================="
printf "\n"
echo "lsb_release -a"
lsb_release -a
printf "\n\n"

echo "================= Python Version ==================="
printf "\n"
echo "python --version"
python --version
printf "\n\n"

echo "================= Node Version ==================="
printf "\n"
echo "node --version"
node --version
printf "\n\n"

echo "================= gcloud Versions ==================="
printf "\n"
echo "gcloud version"
gcloud version

echo "================= JQ Versions ==================="
printf "\n"
echo "jq --version"
jq --version
