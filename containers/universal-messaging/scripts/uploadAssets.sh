#!/bin/sh
#*******************************************************************************
#  Copyright 2013 - 2018 Software AG, Darmstadt, Germany and/or its licensors
#
#   SPDX-License-Identifier: Apache-2.0
#
#     Licensed under the Apache License, Version 2.0 (the "License");
#     you may not use this file except in compliance with the License.
#     You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
#     Unless required by applicable law or agreed to in writing, software
#     distributed under the License is distributed on an "AS IS" BASIS,
#     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#     See the License for the specific language governing permissions and
#     limitations under the License.                                                            
#
#*******************************************************************************
set -e
set -x
echo "Start UM using /opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon"
/opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon start
# wait until UM is up
while [  ! -f /opt/softwareag/UniversalMessaging/server/umserver/bin/nserverdaemon.pid ]; do
     sleep 5
done

until /opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh GetServerTime -rname=nsp://localhost:9000
do 
    sleep 5
    tail /opt/softwareag/UniversalMessaging/server/umserver/logs/nirvana.log
done

# this is our main container process
echo "UM is ONLINE at nsp://localhost:9000/"

sleep 10
echo "Configurating UM"
#runUMTool.sh CreateConnectionFactory -rname=nsp://localhost:9000 -factoryname=local_um -durabletype=S
#/opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh CreateChannel -rname=nsp://localhost:9000 -channelname=channel0 -maxevents=10 
#/opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh ListChannels -rname=nsp://localhost:9000

/opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh ImportRealmXML -rname=nsp://localhost:9000 -filename=/opt/softwareag/UniversalMessaging/tools/runner/config.xml -importall=true
/opt/softwareag/UniversalMessaging/tools/runner/runUMTool.sh ViewConnectionFactory -rname=nsp://localhost:9000 -factoryname=local_um 

echo "Stopping Universal Messaging"
/opt/softwareag/UniversalMessaging/server/umserver/bin/nstopserver