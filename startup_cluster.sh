#!/bin/sh
#@author: cappetta <thomas.cappetta>AT<gmail>
echo "STARTING all hosts  - `date`"
vagrant up --no-provision

boxes = [ 'node1','node2','node3' ]
#todo: interation logic to spawn provisioning off on each client for both shell & puppet


#echo "STARTING Initial Installation Provisioner  - `date`"
#vagrant provision --provision-with shell core 2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Provisioner (Shell) - agent1 - `date`"
vagrant provision --provision-with shell agent1 2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Provisioner (Shell) - agent2 - `date`"
vagrant provision --provision-with shell agent2 2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Puppet Provisioner (Shell) - agent3 - `date`"
vagrant provision --provision-with shell agent3 2>> /tmp/debug.out 1>> /tmp/corelogic.out

#echo "STARTING Puppet Provisioner  - core - `date`"
#vagrant provision --provision-with puppet core 2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Puppet Provisioner  - agent1 - `date`"
vagrant provision --provision-with puppet agent1  2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Puppet Provisioner  - agent2 - `date`"
vagrant provision --provision-with puppet agent2 2>> /tmp/debug.out 1>> /tmp/corelogic.out

echo "STARTING Puppet Provisioner  - agent3 - `date`"
vagrant provision --provision-with puppet agent3 2>> /tmp/debug.out 1>> /tmp/corelogic.out

#echo "Reloading Vagrant Environment"
#vagrant reload