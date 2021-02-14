# LogicOfGlobal
Two instances in different subnet, in one VPC. Network Load Balancer.

Use terraform files to create infrastructure. Wich include instances in two different subnet for High Availability. Also create Network Load Balancer for balance traffic between two servers. Used user data for instance and create IIS webserver, and change settings to enable remote access (use powershell scripts).
Second script clean IIS website, applications and folders.

In this project I use in terraform aws_resource:
-“instance” - for create virtual machines with Windows Server 2019 on board.
-”vpc” - Virtual Private Cloud.
-”internet gateway” - VPC need for connect to global internet network.
-“subnet” – subnet in VPC.
-”route table” – resource for route address.
-”lb” – Elastic Load Balancer type – “network”, for balance traffic.
-”security group”-wich is necessary to open port and protocol wich I need to connect to my VPC.

For create infrastructure you should apply terraform files in terminal.
For clean IIS website, applications and folders run powershell scripts.
