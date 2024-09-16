if [ -f "./devel/local/bin-config/common.sh" ]; then
    . ./devel/local/bin-config/common.sh
fi
if [ -f "./devel/local/bin-config/$1.sh" ]; then
    . ./devel/local/bin-config/$1.sh
fi

if [ -z "$DOCKER_ARGS" ]; then
    DOCKER_ARGS=""
fi
if [ -z "$DOCKER_NAME" ]; then
    DOCKER_NAME="insios-smarthost"
fi
if [ -z "$DOCKER_IMG" ]; then
    DOCKER_IMG="local/insios-smarthost"
fi
if [ -z "$DOCKER_TAG" ]; then
    DOCKER_TAG="latest"
fi
if [ -z "$LOCAL_CONFIG" ]; then
    LOCAL_CONFIG="./devel/local/config"
fi
if [ -z "$LOCAL_SUBMIT_PORT" ]; then
    LOCAL_SUBMIT_PORT="8587"
fi
if [ -z "$LOCAL_SUBMIT_PORT_PP" ]; then
    LOCAL_SUBMIT_PORT_PP="8586"
fi
if [ -z "$HELM_NS" ]; then
    HELM_NS="default"
fi
if [ -z "$HELM_VALUES" ]; then
    HELM_VALUES="-f ./devel/local/chart/values.yaml"
fi
