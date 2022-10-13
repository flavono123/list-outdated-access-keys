#!/bin/sh

export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"

retention_hours="${1:-0}"
RETENTION_EPOCH="$(date -u -d "now - ${retention_hours} hours" +%s)"
export RETENTION_EPOCH
retention_ts=$(date -u -d "@${RETENTION_EPOCH}" +%Y%m%d%H%M%S)

results_dir="results/$retention_ts"
mkdir -p "$results_dir"

echo "Create files with access keys created before ${retention_hours} hours ago(at ${retention_ts})"
# Create the access key list json for each users
aws iam list-users | \
  jq .Users[].UserName | \
  xargs -I{} sh -c \
    "aws iam list-access-keys --user-name {} | \
      jq -r '.AccessKeyMetadata |
        select(length != 0)[] | select(.CreateDate | fromdateiso8601 < $RETENTION_EPOCH) |
        \"\(.CreateDate) - \(.AccessKeyId)\"' > $results_dir/{}.json && \
      echo \"'$results_dir/{}.json' is created\""


# Delete empty files
find "$results_dir" -size 0 -delete
echo 'Empty files are deleted'
