
(c) Copyright 2016-2017 Hewlett Packard Enterprise Development LP
(c) Copyright 2017 SUSE LLC

Licensed under the Apache License, Version 2.0 (the "License"); you may
not use this file except in compliance with the License. You may obtain
a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
License for the specific language governing permissions and limitations
under the License.


README
======

This directory contains the test-plan that executes the playbooks and test
scripts during the project specific CI job for cinder-ansible.

To run test-plan.yml locally on your own test environment:

cd ~/ardana-dev-tools/ardana-vagrant-models/project-vagrant
../../bin/test-project-stack.sh --ci ardana/cinder-ansible

The cinder-ansible playbooks are tested with two different storage
backend configurations:
- New Storage Input Model
- Jinja2 Configuration

After test-plan.yml has completed, the storage backends will be
configured with Jinja2. To revert back to the original Storage Input
Model configuration, ssh to the deployer (server1) and run the
revert-to-storage-input-model.bash script in ~/ardana-ci-tests/.

Node Hostname Reference:
- server1     project-ccp-deployer-m1-ardana
- server2     project-ccp-monasca-m1-ardana
- server3     project-ccp-db-rmq-key-m1-ardana
- server4     project-ccp-controller-m3-ardana
- server5     project-ccp-controller-m1-ardana
- server6     project-ccp-controller-m2-ardana
