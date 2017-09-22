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

#/bin/bash
source ~/service.osrc

function test_volume_count
{
    EXPECTED=$1
    COUNT=$(($(cinder list | wc -l) - 4))
    if [ "${COUNT}" != "${EXPECTED}" ]
    then
        echo Invalid volume count ${COUNT}
        exit -1
    fi
}

function create_volume
{
    echo Creating Volume...
    VOLUME=$1
    SIZE=$2
    cinder create --name ${VOLUME} ${SIZE}
    rc=$?
    if [ "$rc" != "0" ]
    then
        print Volume create failed for ${VOLUME}
        exit -1
    fi

    STATUS=""
    TIME_OUT=0
    while [ "${STATUS}" == "" ] && [ ${TIME_OUT} -lt 20 ]
    do
        sleep 1
        STATUS=$(cinder list | grep ${VOLUME} | grep available | awk '{print $2}')
        TIME_OUT=$((TIME_OUT + 1))
    done
}

function delete_volume
{
    echo Deleting Volume...
    VOLUME=$1
    BEFORE_COUNT=$(($(cinder list | wc -l) - 4))
    cinder delete ${VOLUME}
    rc=$?
    if [ "$rc" != "0" ]
    then
        print Volume delete failed for ${VOLUME}
        exit -1
    fi
    AFTER_COUNT=$(($(cinder list | wc -l) - 4))

    TIME_OUT=0
    while [ $((AFTER_COUNT)) -eq $((BEFORE_COUNT)) ] && [ ${TIME_OUT} -lt 20 ]
    do
        AFTER_COUNT=$(($(cinder list | wc -l) - 4))
        sleep 1
        TIME_OUT=$((TIME_OUT + 1))
    done
}

function test_backup_count
{
    EXPECTED=$1
    COUNT=$(($(cinder backup-list | wc -l) - 4))
    if [ "${COUNT}" != "${EXPECTED}" ]
    then
        echo Invalid backup count ${COUNT}
        exit -1
    fi
}

function create_backup
{
    echo Creating Backup Volume...
    BACKUP=$1
    VOLUME=$2
    cinder backup-create --name ${BACKUP} ${VOLUME}
    rc=$?
    if [ "$rc" != "0" ]
    then
        print Backup create failed for ${VOLUME}
        exit -1
    fi

    STATUS=""
    TIME_OUT=0
    while [ "${STATUS}" == "" ] && [ ${TIME_OUT} -lt 60 ]
    do
        sleep 1
        STATUS=$(cinder backup-list | grep ${BACKUP} | grep available | awk '{print $6}')
        TIME_OUT=$((TIME_OUT + 1))
    done
}

function restore_backup
{
    echo Restoring Backup Volume...
    VOLUME=$1
    BACKUP=$2
    ID=$(cinder backup-list | grep ${BACKUP} | awk '{print $2}')
    cinder backup-restore --volume ${VOLUME} ${ID}
    rc=$?
    if [ "$rc" != "0" ]
    then
        print Backup restore failed for ${BACKUP}
        exit -1
    fi

    STATUS=""
    TIME_OUT=0
    while [ "${STATUS}" == "" ] && [ ${TIME_OUT} -lt 40 ]
    do
        sleep 1
        STATUS=$(cinder list | grep ${VOLUME} | grep available | awk '{print $2}')
        TIME_OUT=$((TIME_OUT + 1))
    done

    STATUS=""
    TIME_OUT=0
    while [ "${STATUS}" == "" ] && [ ${TIME_OUT} -lt 40 ]
    do
        sleep 1
        STATUS=$(cinder backup-list | grep ${BACKUP} | grep available | awk '{print $6}')
        TIME_OUT=$((TIME_OUT + 1))
    done
}

function delete_backup
{
    echo Deleting Backup Volume...
    BACKUP=$1
    STATUS=""
    BEFORE_COUNT=$(($(cinder backup-list | wc -l) - 4))
    cinder backup-delete ${BACKUP}
    rc=$?
    if [ "$rc" != "0" ]
    then
        print Backup delete failed for ${BACKUP}
        exit -1
    fi
    AFTER_COUNT=$(($(cinder backup-list | wc -l) - 4))

    TIME_OUT=0
    while [ $((AFTER_COUNT)) -eq $((BEFORE_COUNT)) ] && [ ${TIME_OUT} -lt 20 ]
    do
        AFTER_COUNT=$(($(cinder backup-list | wc -l) - 4))
        sleep 1
        TIME_OUT=$((TIME_OUT + 1))
    done
}

test_volume_count 0
create_volume v1 1
test_volume_count 1

test_backup_count 0
create_backup b1 v1
test_backup_count 1

restore_backup v1 b1
delete_backup b1
test_backup_count 0

delete_volume v1
test_volume_count 0

echo ***VALIDATED CINDER OPERATIONS SUCCESSFULLY***

exit 0
