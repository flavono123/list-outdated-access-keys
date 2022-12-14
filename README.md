# list-outdated-access-key.sh

## Usage
### Common
```sh
❯ export AWS_ACCESS_KEY_ID=xxx...
❯ export AWS_SECRET_ACCESS_KEY=xxx...
# or login with `aws configure`
# (Only for the script execution, mount it to a container for a docker or a minikube way)

# args: <retention_hours> (integer, default: 0)
```

### Shell Script
```sh
❯ sh list-outdated-access-key.sh [<retention_hours>]
# e.g. sh list-outdated-access-key.sh 2400 # list access keys created before 100 days ago
```

### Container
```sh
❯ docker run \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  -v "$(pwd)"/results:/results \
  vonogoru123/list-outdated-access-keys:0.1.0 [<retention_hours>]
# e.g.
# docker run \
#  -e AWS_ACCESS_KEY_ID \
#  -e AWS_SECRET_ACCESS_KEY \
#  -v "$(pwd)"/results:/results \
#  vonogoru123/list-outdated-access-keys:0.1.0 2400
```
- repo: https://hub.docker.com/repository/docker/vonogoru123/list-outdated-access-keys

### Minikube(k8s)
```sh
❯ RETENTION_HOURS=<retention_hours> \
  HOST_PATH=<minikube_node_path> \
    envsubst < manifests/cronjobs/list-outdated-access-keys-daily.yaml | \
  k apply -f -
# e.g.
#  RETENTION_HOURS=2400 \
#  HOST_PATH=/results \
#    envsubst < manifests/cronjobs/list-outdated-access-keys-daily.yaml | \
#  k apply -f -
```


## Dependencies(prerequisuites & enviornments)
- MacOS(Only tested)
- Internet connection
- AWS Access Key Id / Secret Access Key Pair (Follow 'Usage > Common' to set)

### Shell Script
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
# or pull the latest image

```

### Minikube(k8s)
```sh
# (macOS specific) Use driver mounts with host and confirm to connect the node(minikube VM) to internet,
# **[hyperkit](https://minikube.sigs.k8s.io/docs/drivers/hyperkit/)** is recommended.
❯ minikube start --driver=hyperkit --mount --mount-string <macos_host_path>:<minikube_node_path>
# e.g. minikube start --driver=hyperkit --mount --mount-string $PWD/results:/results

# Create the secret `aws'
❯ kubectl create secret generic aws \
    --from-literal AWS_ACCESS_KEY_ID=xxx... \
    --from-literal AWS_SECRET_ACCESS_KEY=xxx...
# or use the template
❯ BASE64_AWS_ACCESS_KEY_ID=$(echo -n "$AWS_ACCESS_KEY_ID" | base64) \
  BASE64_AWS_SECRET_ACCESS_KEY=$(echo -n "$AWS_SECRET_ACCES_KEY" | base64) \
    envsubst < manifests/secrets/aws.yaml | \
  k apply -f -
```

## Output
- `($WORKDIR/results|<mounted_host_path>)/<retention_ts>/<iam_user_name>.json`
  - `<retention_ts>` is the timestamp of the retention moment(UTC) which format is %Y%m%d%H%M%S(e.g. 20220101185723), and a parent directory of result files
  - `<iam_user_name>` is the user name of IAM who has IAM Access keys in the files
- Output file format: `<aws_iam_access_key> - <create_date> ...` (e.g 2022-06-17T05:30:24Z - AKIA...)

```sh
# e.g.
❯ tree results/20220101010514/
results/20220101010514/
├── Test10
├── Test2
├── Test5
├── Test6
├── Test8
├── Test9
├── chloe.kim
├── hojin.shim
├── jonny.koo
└── youngwoo.kim

0 directories, 10 files
```
