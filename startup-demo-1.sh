#!/bin/bash
timestamp=$(date +%Y%m%d)
log_path="`pwd`"
filename=docker_logs_$timestamp.log
log=$log_path/$filename

REMOVEIMAGES=`docker images | grep "jackie-image" | awk '{print $3}'`
REMOVECONTAINER=`docker ps | grep "jackie-container" | awk '{print $1}'`
if [ $REMOVECONTAINER ]
then
        docker stop ${REMOVECONTAINER}
        echo "${REMOVECONTAINER} Container Stoped............................................."
        docker rm -f ${REMOVECONTAINER}
        echo "${REMOVECONTAINER} Container deleted."
else
        echo "Old Container is not present."
fi
echo "================================================================"

if [ $REMOVEIMAGES ]
then
	docker rmi -f ${REMOVEIMAGES}
	echo "${REMOVEIMAGES} jackie-image:v0.0.1  is Deleted..................................."
else
	echo "Old jackie image is not present."
fi
echo "================================================================"

docker build -t jackie-image:v0.0.1 .
echo "================================================================"
docker run -it -d -p 9000:3000 -p 6005:6005 --restart always --name jackie-container jackie-image:v0.0.1
docker logs -f jackie-container >> $log &
#tail -f `docker inspect --format='{{.LogPath}}' jackie-image-container` > $log &
echo "================================================================"
echo "Find the console logs in ${log}"
exit

