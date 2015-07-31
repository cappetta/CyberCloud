# CyberCloud

Semantic Version: 0.9.0

A compilation of open-source technologies which create a virtual security toolbox for red/blue team members.
This project is aimed to provide an open-source training ground for individuals, communities, & organizations.

Expertise is needed for protecting medium and large enterprise environments. An effective Cyber Security Strategy
requires one to take a Defense in Depth approach, using many more offensive and defensive strategies.

This project provides a virtual arsenal of security tools for researches, practitioners, and students.  It's
best to practice examine and exploit your assets in a safe environment.


####
**SIEM Console: ** OSSIM  
**Infrastructure Sensors: ** OS-SEC
**Vulnerability Scanner: ** OpenVas, Oswasp ZAP
**ISO27001 Compliance Reporting: ** AlienVault UVM
**Vulnerable App Options: ** Damn Vulnerable Web App, OSWAP Bricks, ++more
**PenTesting Framework: ** Kali, Metasploit



# Release Notes
A section which contains all of the techncial nitty-gritty details that most people don't read
yet complain when it is not present.


## Installation Instructions: <draft>
    1. Clone the repo
    2. Type Vagrant Up
    3. Apply puppet provisioning
    4. Log into SIEM console
        a. Configure IP && Subnet
            Option:         0 => 0 => 0 => 1
            IP:             192.168.0.12
            Subnet:         255.255.255.0
            Option:         0 (setup management interface)
            Eth2 Checkbox:  Checked
        b. Apply All changes
        c. Log into Siem @ http://192.168.0.12
            - default user/pass: admin/1CvL67XCTj5j48vnd7Wg

    5. Activate Application Deployment Manifest


##### Technology Dependencies:
###### V0.9 - Prototype Complete.
    1. Vagrant & Plug-ins (DevOps Automation)
        a. openstack (1.1.2)
        b. puppet (3.7.4)
        c. vagrant-bindfs (0.4.0)
        d. vagrant-login (1.0.1, system)
        e. vagrant-openstack-plugin (0.11.1)
        f. vagrant-share (1.1.3, system)
    1a. Vagrantbox.es:
        a. chef/centos-6.6
        b. ubuntu/trusty64
    2. Puppet (System BluePrints )
    3. AlienVault UVM w/ Plug-ins:
        a. Cisco ASA
        b. Cisco PIX
        c. Cisco WLC
        d. Citrix NetScaler
        e. CyberGuard SG565
        f. F5 FirePass
        g. Fortinet FortiGate
        h. Sonic Wall
        i. OS-SEC Monitoring
        j. Syslog
    4. OS-SEC agents (Network & Infrastructure Sensors)
    5. DVWA (Extremely Vulnerable Environment)

### v1.0 - (Work in Progress): Issues to Resolve:
    1. Fully Automated & manual configurations fully documented
    2. Fix SSH timeout issue w/ vagrant ossim.box
    3. Kali appliance (PenTesting Framework)
    4. Metasploitable (Extremely Vulnerable Environment)

### V2.0 - Prototype Under Development
    1. OpenStack
    2. Cassandra
    3. Graphite
    4. JVM Monitoring using JMXTrans
    5. YAML Implementation

### v3.0 - Production Proto-type

    1. Dedicated BigData Infrastructure
    2. Dedicated Computing Infrastructure.


### References:

    1. Vagrant Cassandra Project @github: bcantoni/vagrant-cassandra
    2. Parallel Provisioning: http://joemiller.me/2012/04/26/speeding-up-vagrant-with-parallel-provisioning/
