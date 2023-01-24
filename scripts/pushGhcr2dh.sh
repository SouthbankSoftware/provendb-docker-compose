for image in `docker image ls|grep ghcr.io|cut -f1 -d' '|sort -u|grep -v provendb-cs`;do
    shortname=`echo $image|cut -d'/' -f3`
    echo "docker tag $image southbanksoftware/${shortname}:dockerCompose"
    echo "docker push southbanksoftware/${shortname}:dockerCompose"
    #echo "docker pull southbanksoftware/${shortname}:dockerCompose"
done