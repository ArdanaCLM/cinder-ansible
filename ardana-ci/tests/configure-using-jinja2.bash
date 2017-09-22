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

# Rename original control_plane.yml and copy new one
mv ~/openstack/my_cloud/definition/data/control_plane.yml \
   ~/openstack/my_cloud/definition/data/control_plane.yml.backup
cp ~/ardana-ci-tests/control_plane.yml ~/openstack/my_cloud/definition/data/control_plane.yml

# Rename cinder config directory
mv ~/openstack/my_cloud/definition/data/cinder/ ~/openstack/my_cloud/definition/data/cinder.backup

# Copy cinder.conf.j2 with configured backend
cp ~/ardana-ci-tests/cinder.conf.j2 ~/openstack/my_cloud/config/cinder/cinder.conf.j2

pushd ~/openstack/ardana/ansible

git add -A
git commit  --allow-empty -m "Stop Using New Storage Input Model"

ansible-playbook -i hosts/localhost config-processor-run.yml -e encrypt="" \
                                                             -e rekey=""

sleep 5

ansible-playbook -i hosts/localhost ready-deployment.yml

sleep 5

popd
