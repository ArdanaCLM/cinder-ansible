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

# Run this script on the deployer (located in ~/ardana-ci-tests/) to revert the
# Project Stack cloud back to it's original state after running test-plan.yml.
# The storage backends will be configured with the Storage Input Model. This
# script is not executed during CI.

mv ~/openstack/my_cloud/definition/data/control_plane.yml.backup \
   ~/openstack/my_cloud/definition/data/control_plane.yml

mv ~/openstack/my_cloud/definition/data/cinder.backup/ \
   ~/openstack/my_cloud/definition/data/cinder

# Copy original cinder.conf.j2 without backend configuration
cp ~/ardana-ci-tests/cinder.conf.j2.original ~/openstack/my_cloud/config/cinder/cinder.conf.j2

sudo rm /etc/ansible/facts.d/cinder_backend_assignment.fact
sudo rm /etc/ansible/facts.d/cinder_volume_run_location_ccp.fact

pushd ~/openstack/ardana/ansible

git add -A
git commit  --allow-empty -m "Revert Back To Using Storage Input Model"

ansible-playbook -i hosts/localhost config-processor-run.yml -e encrypt="" \
                                                             -e rekey=""

sleep 2

ansible-playbook -i hosts/localhost ready-deployment.yml

sleep 2

popd
pushd ~/scratch/ansible/next/ardana/ansible/
sleep 2

ansible-playbook -i hosts/verb_hosts cinder-deploy.yml

sleep 2

ansible-playbook -i hosts/verb_hosts cinder-status.yml

popd
