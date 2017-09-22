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

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m1-ardana \
"sudo grep -q 'enabled_backends=LVM1-CONFIG-CP1, LVM3-CONFIG-CP1' /etc/cinder/cinder.conf"
rc=$?

if [ "$rc" != "0" ]
then
    echo "ERROR: Could not validate correct backends on first controller."
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m2-ardana \
"sudo grep -q 'enabled_backends=LVM2-CONFIG-CP1' /etc/cinder/cinder.conf"
rc=$?

if [ "$rc" != "0" ]
then
    echo "ERROR: Could not validate correct backends on second controller."
    result="fail"
fi

ssh -o BatchMode=yes -o StrictHostKeyChecking=no project-ccp-controller-m3-ardana \
"sudo grep -q '^enabled_backends=[[:space:]]*$' /etc/cinder/cinder.conf"
rc=$?

if [ "$rc" != "0" ]
then
    echo "ERROR: Could not validate correct backends on third controller."
    result="fail"
fi

if [ "$result" == "fail" ]
then
    echo FAILURE: Could not validate correct backends on controllers, check error \
                  messages above for more details.
    exit -1
else
    echo SUCCESS: Validated correct backends on controllers after migrating cinder volume service.
    exit 0
fi
