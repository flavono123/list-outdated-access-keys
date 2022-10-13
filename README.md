# list-outdated-access-key.sh

## Prerequisuite
- MacOS(Only tested)
- Internet connection
- AWS Access Key Id / Secret Access Key Pair
- Dependencies

```sh
# awscli <~ 1.25.90
❯ aws --version
aws-cli/1.25.90 Python/3.10.7 Darwin/21.6.0 botocore/1.27.89

# jq <~ 1.6
❯ jq -V
jq-1.6

# gnu utils(date, xargs)
❯ date --version
date (GNU coreutils) 9.1
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by David MacKenzie.

❯ xargs --version
xargs (GNU findutils) 4.9.0
Packaged by Homebrew
Copyright (C) 2022 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by Eric B. Decker, James Youngman, and Kevin Dalley.

```

## Usage
```sh
❯ export AWS_ACCESS_KEY_ID=xxx...
❯ export AWS_SECRET_ACCESS_KEY=xxx...
# or login with `aws configure`
❯ sh list-outdated-access-key.sh [<retention_hours>]
# args: <retention_hours> (integer, default: 0)
```

## Outputs
- `$WORKDIR/results/<retention_ts>/<iam_user_name>.json`
  - `<retention_ts>` is the timestamp of the retention monment(UTC) which format is %Y%m%d%H%M%S(e.g. 20220101185723), and a parent directory of result files
  - `<iam_user_name>` is the user name of IAM who has IAM Access keys in the files
- Output file format: `<aws_iam_access_key> - <create_date> ...` (e.g 2022-06-17T05:30:24Z - AKIAQWOA54DNYICYVQQM)
