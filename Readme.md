# Nomad-TuringpPi

This repository is related to the talk I made for the HashiTalks DACH day in 2020
<https://events.hashicorp.com/hashitalksdach>
The video in German can be found here <https://www.youtube.com/watch?v=ppDfZLaFoSE> at 8:37:20

The slides can be found [here](slides/Introduction_to_Nomad_DE.pdf)

## Architecture

### Hardware

The infrastructure is made up of

* 1 [Turing PI v1] <https://turingpi.com/v1/> and 7 [RapberryPi 3+ compute modules]<https://www.raspberrypi.org/products/compute-module-3/?resellerType=home>
* 1 Vagrant Cluster running on an Ubuntu Laptop.

### Software

* Nomad Enterprise 1.0-beta3+ent
* Ansible
* Vagrant

## Preparing the Infrastructure

```bash
mkdir tpi-demo
cd tpi-demo
git clone https://github.com/lhaig/nomad-turingpi.git
```

Deploy the Vagrant cluster using the Vagrantfile provided.

```bash
cd vagrant
vagrant up
```

Install and configure your TuringPi cluster with Ubuntu 18.04
I added the node addresses to my local DNS environment.

## Deploy Nomad and Consul to the Servers and Clients

Open the hosts.ini file in your editor and make changes to the file with the details of your Vagrant and TuringPi servers and Hosts.

Once updated make sure you can SSH into each of the servers without using usernames and passwords.
Then run the playbook below to install Nomad and Consul on your servers.

```bash
cd ansible-turing-pi
ansible-playbook -i hosts.ini turingpi.yml
```
