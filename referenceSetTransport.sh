#!/bin/bash
#title           :rsTransport.sh
#description     :This script transport Reference Sets between QRadar Consoles..
#author          :Burak Karaca from KocSistem SOC
#date            :20170628
#version         :0.2
#usage           :bash rsTransport.sh
#notes           :You need to connect consoles via ssh access.

if [ '$1' == "--help" ] || [ '$1' == "-h" ]; then
        echo "##This script created for transporting Reference Sets from one QRadar console to another QRadar console. To perform this action, consoles had to connect via ssh access."
        echo "##Script contains just 2 functions which save and load ReferenceSets between QRadar Consoles."
        echo "##First function pass first argument as Reference Set name and second as file name and saved data."
        echo "##Second function pass first argument as IP address, second as filename and third as Reference Set name and loaded data to another QRadar console."
        echo "##You need to create reference sets by manually."
        echo "##You can transfer more Reference Sets with editing this script."
fi

#Get data list from reference set and store in a temporary file, then select IP addresses and make a csv file from collected addresses. Pass first argument as Reference Set name and second as file name.

saveReferenceSet (){
        /opt/qradar/bin/ReferenceSetUtil.sh list "$1" [displayContents] > temp1
        grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' temp1 > $2
        sed -i '1s/^/data\n/' $2
        rm -f temp1
}

#Copy file to another QRadar, connect with ssh and run requiered command for load data. Pass first argument as IP address, second as filename and third as Reference Set name.

loadReferenceSet_purgeAll (){
        ssh $1 "mkdir /root/referenceSetTransport/"
        scp $2 $1:/root/referenceSetTransport/$2
        ssh $1 "/opt/qradar/bin/ReferenceSetUtil.sh purgeall '$3'"
        ssh $1 "/opt/qradar/bin/ReferenceSetUtil.sh load '$3' /root/referenceSetTransport/$2"
        ssh $1 "rm -rf /root/referenceSetTransport"
        rm -f $2
}

loadReferenceSet_purge (){
        ssh $1 "mkdir /root/referenceSetTransport/"
        scp $2 $1:/root/referenceSetTransport/$2
        ssh $1 "/opt/qradar/bin/ReferenceSetUtil.sh purge '$3'"
        ssh $1 "/opt/qradar/bin/ReferenceSetUtil.sh load '$3' /root/referenceSetTransport/$2"
        ssh $1 "rm -rf /root/referenceSetTransport"
        rm -f $2
}

##Example usage:

#saveReferenceSet "source set name" sourcefile.csv
#loadReferenceSet ipaddress sourcefile.csv 'destination set name'
