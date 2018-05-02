#!/bin/bash

logSCREEN () {
  printf "$*\n"
}

usage()
{
cat << EOF
usage: $0 options

This is the script which will trigger the scan based on the docker image and get the scan results

Prerequisites to run the script:

1)export your Ipaddress as below
For Example:export IPADDRESS=52.68.1.10


OPTIONS:
   -h      help
   -U      docker user name.
   -u      username.
   -p      password.
   -P      docker password.
   -i      image name
EOF
}

while getopts “hupUPigtI” OPTION
do
     case $OPTION in
         h)
             usage
             exit 1
             ;;
         u)
            shift;
            userName=$1;
            if [ -z "$userName" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         p)
            shift;
            passWord=$2;
            if [ -z "$passWord" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         U)
            shift;
            dUserName=$3;
            if [ -z "$dUserName" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         P)
            shift;
            dPassWord=$4;
            if [ -z "$dPassWord" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         i)
           shift;
            imagename=$5;
            if [ -z "$imagename" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         g)
           shift;
            guideline=$6;
            if [ -z "$guideline" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
        t)
           shift;
            tag=$7;
            if [ -z "$tag" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
        I)
           shift;
            IPADDRESS=$8;
            if [ -z "$IPADDRESS" ];
            then echo "./jenkinsplugin.sh -h"
            exit 0;
            fi
            ;;
         ?)
             usage
             exit
             ;;
     esac
done

Basic_token=$( echo -n $userName:$passWord  | base64 )
echo "The token generated is" :${Basic_token}
OAUTH_OBJ=`curl -k -X POST -H  "Authorization:Basic ${Basic_token}" -H "Content-Type:application/json" https://$IPADDRESS/arap-server/api/v0/login`;
echo "The Oauth related information for your scan is": $OAUTH_OBJ
ACCESS_TOKEN=$(echo -n  $OAUTH_OBJ | jq -r '.access_token')
REFRESH_TOKEN=$(echo -n $OAUTH_OBJ | jq -r '.refresh_token')

uuid=`curl -k -X POST --header "Content-Type:application/json" --header "Authorization:Bearer $ACCESS_TOKEN" https://$IPADDRESS/arap-server/api/v0/dockerimages --data '{"imageName":"docker.io/'$dUserName'/'$tag':'$imagename'","username":"'$dUserName'","password":"'$dPassWord'"}'|jq -r '.id'`;
logSCREEN "The Docker image is created with id" :$uuid
logSCREEN '*********************************************'
logSCREEN "Fetching CAVIRIN-Pulsar's Policypacks based on applicability"
logSCREEN "The Policy Pack selected for the Docker Image scan is": $guideline
logSCREEN '********************************************'
policypacks=`curl -k --header "Content-Type:application/json" --header "Authorization:Bearer $ACCESS_TOKEN" https://$IPADDRESS/arap-server/api/v0/dockerimages/$uuid/scan --data '{"policypacks":["root.'$guideline'"],"scan":true}'`;
sleep 180
logSCREEN '*********************************************'
logSCREEN "Please wait for few moments as the Docker Image you are interested is being scanned"
reports=`curl -k --header "Content-Type:application/json" --header "Authorization:Bearer $ACCESS_TOKEN" https://$IPADDRESS/arap-server/api/v0/reports/assessment/0/0 --data '{"policygroups":["root.'$guideline'"]}'|jq -r '.assessments'`;
load_Data(){
cat<<EOF
{
"assetgroupid":$uuid,
"assessments":$reports
}
EOF
}

echo $(load_Data) > /tmp/reports.json

python << !
#!/usr/bin/ python
import sys,json
with open('/tmp/reports.json', 'r') as myfile:
    data=myfile.read().replace('\n', '')
    myfile.close()
jsondata  = json.loads(data)
assetgroupid=jsondata['assetgroupid']
ids = 0
for i in jsondata['assessments']:
    if( assetgroupid == i['assetgroupid'] and i['assetType'] == 'IMAGE'):
        ids = i['worklogid']
        print ids
txt = open('/tmp/ids.json','w')
txt.write(str(ids))
txt.close()
!
scanid=`cat /tmp/ids.json`
echo 'scan id for the docker '$scanid
echo "The Scan results of the Docker Image will be listed very shortly"
sleep 180
#score=`curl -k --header "Authorization:Bearer $ACCESS_TOKEN" http://$IPADDRESS:3000/context/getScoreByScanId/$scanid?policypack=$guideline |#jq -r '.score'`; https://54.183.237.183/context/getScoreByDockerImage?imageid=10
score=`curl -k --header "Authorization:Bearer $ACCESS_TOKEN" https://$IPADDRESS/context/getScoreByDockerImage?imageid=$uuid |jq -r '.score'`;
echo 'The score fetched after the scan: '$score
logSCREEN "Here are the failed results of the Policies that are evaluated againist the image scanned"
logSCREEN '**************************************************'
policies=`curl -k -X POST --header "Content-Type:application/json" --header "Authorization:Bearer $ACCESS_TOKEN" https://$IPADDRESS/arap-server/api/v0/dockerimages/scanresults/$scanid/50/50 --data '{"policypacks":["'$guideline'"],"state":["Fail"]}'`
echo $policies | python -mjson.tool
logSCREEN "Here are the results of the Policies that are evaluated againist the image scanned"
logSCREEN '**************************************************'
#echo $policies
if [ "$score" -ge 80 ] ; then
  logSCREEN '***************************************'
  logSCREEN "We calculate the score based on the formulae as Weight of the Passed Policies/Weight of the Total policies applied "
  logSCREEN '**************************************'
  logSCREEN "Result of the Assessment: passed "
  logSCREEN '**************************************'
  logSCREEN "The score of the Assessment run againist the Policies of Cavirin-ARAP is:"$score
  logSCREEN  "Congratulations!!! your build has passed the global vulnerability threshold of Cavirin!!! "
  logSCREEN '***************************************'
  logSCREEN "The docker image can be moved in to other registery as it has met the criteria of evaluation"
  logSCREEN '***************************************'
else
 logSCREEN '****************************************'
 logSCREEN 'score':$score
 logSCREEN 'Reason: It did not meet the global threshold of 80 and hence this is marked as failed'
 logSCREEN '****************************************'
 exit 1;
fi
#score=`curl -k http://$IPADDRESS:3000/getScoreByScanId/$uuid?policypack=Image_CDIH `;
#policies=`curl -k --header "Content-Type:application/json" --header "username:$userName" --header "password:$passWord" http://$IPADDRESS/arap-server/api/v0/dockerimages/scanresults/$uuid/0/0`

#logSCREEN $policies| python -mjson.tool

