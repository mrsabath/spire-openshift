#!/bin/bash

# this script requires https://github.com/duglin/tools/tree/master/demoscript
# or https://github.com/mrsabath/tools/tree/master/demoscript
declare DEMOFILE=/usr/local/bin/demoscript
if [ ! -f "$DEMOFILE" ]; then
    echo "$DEMOFILE does not exist."
    exit 1
fi
source "${DEMOFILE}"

SPIFFE_ENDPOINT_SOCKET=${SPIFFE_ENDPOINT_SOCKET:-"/spiffe-workload-api/spire-agent.sock"}
AWS_WEB_IDENTITY_TOKEN_FILE=${AWS_WEB_IDENTITY_TOKEN_FILE:-"/tmp/token.jwt"}
S3_AUD=${S3_AUD:-"mys3"}
AWS_ROLE_ARN=${AWS_ROLE_ARN:-""}
S3_CMD=${S3_CMD:-""}
S3_EXE=${S3_EXE:-""}

# bin/spire-agent api fetch jwt -audience mys3 -socketPath /run/spire/sockets/agent.sock
# vi token.jwt # get JWT token
# bin/spire-agent api fetch jwt -audience mys3 -socketPath /run/spire/sockets/agent.sock  | sed -n '2p' | x
# args > token.jwt
# AWS_ROLE_ARN=arn:aws:iam::581274594392:role/mars-mission-role AWS_WEB_IDENTITY_TOKEN_FILE=token.jwt aws s3 cp s3://mars-spire/mars.txt top-secret.txt

# show the JWT token
doit "/opt/spire/bin/spire-agent api fetch jwt -audience $S3_AUD -socketPath $SPIFFE_ENDPOINT_SOCKET"

# parse the JWT token
doit --noexec "/opt/spire/bin/spire-agent api fetch jwt -audience $S3_AUD -socketPath $SPIFFE_ENDPOINT_SOCKET | sed -n '2p' | xargs > $AWS_WEB_IDENTITY_TOKEN_FILE"
/opt/spire/bin/spire-agent api fetch jwt -audience "$S3_AUD" -socketPath "$SPIFFE_ENDPOINT_SOCKET" | sed -n '2p' | xargs > "$AWS_WEB_IDENTITY_TOKEN_FILE"

# use the JWT token to request S3 content
doit "AWS_ROLE_ARN=$AWS_ROLE_ARN AWS_WEB_IDENTITY_TOKEN_FILE=$AWS_WEB_IDENTITY_TOKEN_FILE $S3_CMD"
doit "$S3_EXE"
