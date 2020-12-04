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
* Consul 1.9
* Ansible
* Vagrant
* Terraform

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

## Run the jobs in this order

### Traefik Proxy

Run the terraform to deploy the traefik proxy.

Copy the `terraform.tfvars.example` file and rename it to `terraform.tfvars`
Edit the `terraform.tfvars` file and update the `nomad_addr` variable with the URL or IP address of your nomad cluster.
Deploy traefik with the commad below

```bash
cd ../jobs/terraform/traefik_proxy
terraform plan
terraform apply -auto-approve
```

You should now see the traefik proxy in your server console.

### Prometheus

```bash
cd ../nomad
nomad job run prometheus.nomad
```

### Grafana

```bash
cd ../nomad
nomad job run grafana.nomad
```

### Deploy Grafana Dashboards.

Run the terraform to deploy the Grafana dashboards.

Copy the `terraform.tfvars.example` file and rename it to `terraform.tfvars`
Edit the `terraform.tfvars` file and update the 2 variables with the URL or IP address of your deployed servers.
Deploy the dashboards with the commad below

```bash
cd ../terraform/grafana_dashboards
terraform plan
terraform apply -auto-approve
```

### Login to Grafana

You should now be able to login to Grafana using

http://{SERVERADDERSS}:3000

using the username admin and the password admin

## Multi cluster federation.

Federate the 2 clusters with the following command

```bash
nomad server join {NAME-OR-IP-OF-VAGRANT-SERVER}:4648
```

You should get a federated message
Then you can yse the `redis-mr.nomad` job to deploy across both clusters.