# CyberCloud

A compilation of open-source technologies which create a virtual security toolbox for red/blue team members.
This project is aimed to provide an open-source training ground for individuals, communities, & organizations.

Expertise is needed for protecting medium and large enterprise environments. An effective Cyber Security Strategy
requires one to take a Defense in Depth approach, using many more offensive and defensive strategies.

This project provides a virtual arsenal of security tools for researches, practitioners, and students.  It's
best to practice examine and exploit your assets in a safe environment.


# Release Notes
A section which contains all of the techncial nitty-gritty details that most people dont care for yet complain
when it is not present.


## Installation Instructions:
    1. Clone the repo
    2. Type Vagrant Up
    3. Apply puppet provisioning
    4. Configure SIEM
        a. IP = 192.168.0.12
    5. Activate Application Deployment Manifest


## Technology Dependencies:
### V0.9 - Prototype Complete.
    1. Vagrant & Plug-ins (DevOps Automation)
        a. openstack (1.1.2)
        b. puppet (3.7.4)
        c. vagrant-bindfs (0.4.0)
        d. vagrant-login (1.0.1, system)
        e. vagrant-openstack-plugin (0.11.1)
        f. vagrant-share (1.1.3, system)
    1a. Vagrantbox.es:
        a.
    2. Puppet (System BluePrints )
    3. AlienVault UVM (SIEM Console) Plug-ins for following Appliances
        a. Cisco ASA
        b. Cisco PIX
        c. Cisco WLC
        d. Citrix NetScaler
        e. CyberGuard SG565
        f. F5 FirePass
        g. Fortinet FortiGate
        h. Sonic Wall
    4. OSSEC (Network & Infrastructure Sensors)
    5. Kali (PenTesting Framework)
    6. Metasploitable (Extremeley Vulnerable Enviroment)
    7. DVWA (Extremeley Vulnerable Enviroment)
    8. Ubuntu & CentOS (Operating Systems)

### v1.0 - Foundation Baselined
    1. Fully Automated & manual configurations fully documented


### V2.0 - Prototype Pending
    1. OpenStack
    2. Cassandra
    3. Graphite
    4. JMXTrans
    5. Dedicated BigData Infrastructure
    6. Dedicated Computing Infrastructure.


### References:
