#
# (c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
# (c) Copyright 2017 SUSE LLC
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#

result="pass"

### Check First Controller ###

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m1-ardana \
"ps auxww | grep cinder-volume | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder Volume service should be running on the first controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m1-ardana \
"ps auxww | grep cinder-backup | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder Backup service should be running on the first controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m1-ardana \
"ps auxww | grep cinder-api | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder API service should be running on the first controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m1-ardana \
"ps auxww | grep cinder-scheduler | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder Scheduler service should be running on the first controller.
    result="fail"
fi


### Check Second Controller ###

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m2-ardana \
"ps auxww | grep cinder-volume | grep -v grep"
rc=$?

if [ "$rc" != "1" ]
then
    echo ERROR: Cinder Volume service should not be running on the second controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m2-ardana \
"ps auxww | grep cinder-backup | grep -v grep"
rc=$?

if [ "$rc" != "1" ]
then
    echo ERROR: Cinder Backup service should not be running on the second controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m2-ardana \
"ps auxww | grep cinder-api | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder API service should be running on the second controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m2-ardana \
"ps auxww | grep cinder-scheduler | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder Scheduler service should be running on the second controller.
    result="fail"
fi


### Check Third Controller ###

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m3-ardana \
"ps auxww | grep cinder-volume | grep -v grep"
rc=$?

if [ "$rc" != "1" ]
then
    echo ERROR: Cinder Volume service should not be running on the third controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m3-ardana \
"ps auxww | grep cinder-backup | grep -v grep"
rc=$?

if [ "$rc" != "1" ]
then
    echo ERROR: Cinder Backup service should not be running on the third controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m3-ardana \
"ps auxww | grep cinder-api | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder API service should be running on the third controller.
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m3-ardana \
"ps auxww | grep cinder-scheduler | grep -v grep"
rc=$?

if [ "$rc" != "0" ]
then
    echo ERROR: Cinder Scheduler service should be running on the third controller.
    result="fail"
fi


if [ "$result" == "fail" ]
then
    echo FAILURE: Could not validate cinder services running on controllers, check error \
                  messages above for more details.
    exit -1
else
    echo SUCCESS: Validated cinder services running on expected controllers.
    exit 0
fi
