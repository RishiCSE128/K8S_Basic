DHUB_UNAME=$1
DHUB_PW=$2
VER=$3

docker build $DHUB_UNAME/fastapi-test:$VER .
docker run -it -p5000:5000 $DHUB_UNAME/fastapi-test:$VER 

echo 'Press any key to upload...'
read
docker login -u $DHUB_UNAME -p $DHUB_PW
docker push $DHUB_UNAME/fastapi-test:$VER