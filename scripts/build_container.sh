set -e

VERSION=$1

mkdir -p toolbox/$VERSION
sed "s/{{ version }}/$VERSION/g;" toolbox/Dockerfile.tpl | tee toolbox/$VERSION/Dockerfile
docker build -t rackspace-toolbox:$VERSION-$CIRCLE_SHA1 -f toolbox/$VERSION/Dockerfile .

docker login -u $DOCKER_USER -p $DOCKER_PASS

docker tag rackspace-toolbox:$VERSION-$CIRCLE_SHA1 "rackautomation/rackspace-toolbox:$VERSION-$CIRCLE_SHA1"
docker push "rackautomation/rackspace-toolbox:$VERSION-$CIRCLE_SHA1"

docker tag rackspace-toolbox:$VERSION-$CIRCLE_SHA1 "rackautomation/rackspace-toolbox:$VERSION"
docker push "rackautomation/rackspace-toolbox:$VERSION"
