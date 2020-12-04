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

