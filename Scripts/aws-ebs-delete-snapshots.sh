#!/bin/bash

set -eo pipefail

days_ago="700"

if [ "$days_ago" -le "90" ]; then
    echo "Data invalida"; exit 1
fi

if [ -z "${manual_date_ago}" ]; then
    echo "Date is empty"
    date_days_ago=$(date --date="-${days_ago} days" +%F)
else
    echo "Date isn't empty"
    date_days_ago=${manual_date_ago}
fi

echo "Buscando snapshots mais antigos que $date_days_ago na região $AWS_DEFAULT_REGION ..."

# Example using filters
# daily_snapshots_to_delete=$(aws ec2 describe-snapshots --filters Name=volume-size,Values=55 --owner-id XXXXXXXXXXXX --query "Snapshots[?StartTime<='${date_days_ago}'].SnapshotId" --output text)

daily_snapshots_to_delete=$(aws ec2 describe-snapshots --filters Name=volume-size,Values=55 --owner-id XXXXXXXXXXXX --query "Snapshots[?StartTime<='${date_days_ago}'].SnapshotId" --output text)

if [ -z "$daily_snapshots_to_delete" ]; then
    echo "Nenhum snapshot encontrado!"; exit 1
fi

c=0
for snap in ${daily_snapshots_to_delete}; do
  c=$((c+1))
  echo "[$c] deleting snapshot $snap ..."
  if [ "$snap" != "snap-0ff3d4436f1eec089" ]; then
    aws ec2 delete-snapshot --snapshot-id $snap
  fi
  echo "     $snap deleted!"
done