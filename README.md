# list-outdated-access-key.sh

## Prerequisuite
### Script
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

### Docker
- Docker
```sh
❯ docker version
Client:
 Cloud integration: v1.0.29
 Version:           20.10.17
 API version:       1.41
 Go version:        go1.17.11
 Git commit:        100c701
 Built:             Mon Jun  6 23:04:45 2022
 OS/Arch:           darwin/amd64
 Context:           default
 Experimental:      true

Server: Docker Desktop 4.12.0 (85629)
 Engine:
  Version:          20.10.17
  API version:      1.41 (minimum version 1.12)
  Go version:       go1.17.11
  Git commit:       a89b842
  Built:            Mon Jun  6 23:01:23 2022
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.8
  GitCommit:        9cd3357b7fd7218e4aec3eae239db1f68a5a6ec6
 runc:
  Version:          1.1.4
  GitCommit:        v1.1.4-0-g5fd4c4d
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

# Build
❯ docker build -t <tag> -f Dockerfile .
...
# or pull latest image

```

## Usage
```sh
❯ export AWS_ACCESS_KEY_ID=xxx...
❯ export AWS_SECRET_ACCESS_KEY=xxx...
# or login with `aws configure` (Only for the script execution)

# Script
❯ sh list-outdated-access-key.sh [<retention_hours>]
# args: <retention_hours> (integer, default: 0)

# Docker
❯ docker run \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -v "$(pwd)"/results:/results \
  list-outdated-access-keys:latest [<retention_hours>]
```

## Outputs
- `$WORKDIR/results/<retention_ts>/<iam_user_name>.json`
  - `<retention_ts>` is the timestamp of the retention monment(UTC) which format is %Y%m%d%H%M%S(e.g. 20220101185723), and a parent directory of result files
  - `<iam_user_name>` is the user name of IAM who has IAM Access keys in the files
- Output file format: `<aws_iam_access_key> - <create_date> ...` (e.g 2022-06-17T05:30:24Z - AKIAQWOA54DNYICYVQQM)
