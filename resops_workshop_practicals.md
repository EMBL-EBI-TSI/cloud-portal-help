### GitHub repository hosting the practicals code: 
[`https://github.com/EMBL-EBI-TSI/resops_workshop`](https://github.com/EMBL-EBI-TSI/resops_workshop) 

## Practical 1

Deploying a virtual machine with Terraform

1. Log into your instance using the guide [`here`](https://docs.google.com/a/ebi.ac.uk/presentation/d/15SFd-hqymAeRB7PpLHEn5-cR4OkDHCoUnPGxt_uQZIA/edit?usp=sharing).

SSH keys are here: [`https://oc.ebi.ac.uk/s/BMxun5e1YaFrVij`](https://oc.ebi.ac.uk/s/BMxun5e1YaFrVij)

2. Your environment has been set up so that Terraform and Ansible are already installed. Test this by running `terraform -v` and `ansible --version`. If you get `command not found` for either of these, contact your friendly course guides for help before continuing.

3. Prepare your environment by sourcing the openstack script that is present in your home directory:`source ~/user_XX.sh` (replace XX with your user number)

Enter your password when prompted.

3. Make sure your home folder contains the deployment_workshop folder with `ls`

4. Cd in and run a `git pull` to make sure it is up to date.

6. Create a folder called `practical1` (`mkdir practical1`) and cd into it.

7. We’ll create a basic terraform file that boots a single server and allows us to SSH in. Create a file called `instance.tf` and open it in your favorite editor. (You may need to install it, e.g. `sudo yum install vim/nano/emacs`)

8. We’ll define a very basic VM first. Put the following contents in the file:

```
# Create a web serverresource "openstack_compute_instance_v2" "basic" {  # Change this to something better!  name            = "sometest_machine"  # This is the id of a pre baked image in openstack  image_id        = "3e8781ee-acfd-4f10-9884-5471378792e7"  # This determines the size of the VM  flavor_name     = "s1.tiny"}
```

9. Save the file and exit. Then run `terraform apply`. Some basic output will scroll by and finally your machine will have been created. Login to the openstack horizon interface ([`https://extcloud05.ebi.ac.uk`](https://extcloud05.ebi.ac.uk)) and see for yourself (click `Instances` and look for the name of your machine).

10. We have a machine, but how do we get to it? We must first create and associate a keypair. Reopen your instance.tf file and add the following bit at the top:

```
# Create a keypairresource "openstack_compute_keypair_v2" "demo_keypair" {
  # Change this to something better!  name = "sometest_keypair"  public_key = "${file("/path/to/pubkey.pub")}"}
```

Note that your public key should be in your home directory and ends in .pub.

Now that we have defined the keypair, we need to associate it with the machine. To do that, add

```
key_pair = "${openstack_compute_keypair_v2.demo_keypair.name}"</td>
```

under the `flavor_name` entry bit of your machine definition at the bottom of the file. This should be your final file:

```
# Create a keypairresource "openstack_compute_keypair_v2" "demo_keypair" {
  # Change this to something better!  name = "sometest_keypair"  public_key = "${file("/path/to/pubkey.pub")}"}

# Create a web serverresource "openstack_compute_instance_v2" "basic" {  # Change this to something better!  name            = "sometest_machine"  # This is the id of a pre baked image in openstack  image_id        = "3e8781ee-acfd-4f10-9884-5471378792e7"  # This determines the size of the VM  flavor_name     = "s1.tiny"
  # Associate keypair
  key_pair        = "${openstack_compute_keypair_v2.demo_keypair.name}"}
```

11. Now, save and exit the file and run `terraform apply` again. You will see that terraform destroys our machine and rebuilds it using the new keypair. So now we can connect to it with ssh. Find the ip of your new machine using `terraform show` and find the value for `network.0.fixed_ip_v4`. Then ssh to it with your key: `ssh -i /path/to/privatekey xx.xx.xx.xx`. Are you able to connect?

12. The new machine is refusing our connection because of its default firewall. So we’ll need to create a new rule and assign it. Open your instance.tf file, and add the following at the top: 

```
# Create a security groupresource "openstack_compute_secgroup_v2" "demo_secgroup" {
  # Again, remember to change this  name = "somename_secgroup"  description = "basic demo secgroup"  rule {    from_port = 22    to_port = 22    ip_protocol = "tcp"    cidr = "0.0.0.0/0"  }}
```

Next go into the machine definition and add 

```
security_groups = ["${openstack_compute_secgroup_v2.demo_secgroup.name}"]
```

Right below the key_pair entry we added in the previous step. Save and exit.

13. With your new file, run terraform apply again. You will see a new security group being created and your machine will be modified to include the new security group. Try to ssh in again. Is it working?

14. You should now be in your new machine, try and install for example an nginx server with `sudo yum install epel-release && sudo yum install nginx` (optional). Exit to your deployment vm (after you are done playing around) by typing `exit` or pressing Ctrl-D.

15. To make our terraform setup easily customizable, we can use variables to change things on a per-deployment basis. Open the instance.tf file and change the `name` line of your VM instance to be as follows: 

```
name = "${var.name}_machine"
```

Then, at the end of your file, add the definition of this variable:

```
variable "name" {  type = "string"}
```

Save and exit, and run `terraform apply`. You will be asked to enter a name, and your machine will be modified to include the new name. You can use variables for all sorts of things that would need to be changed on a per-deployment basis, such as ip-addresses, passwords, file inputs, etc. We can use it anywhere we want to, so we could use it to name the security group and keypair too in our example. Try using the `name` variable to name these two resources by editing your `instance.tf` file and redeploy your infrastructure. Did it work? (check the Horizon interface!)

16. Lastly, we need to tear down our infrastructure again. Run `terraform destroy`

Type `yes` to confirm. Terraform will now destroy your VM. Please don’t leave your machine running, so we can save resources as much as possible.

This concludes the first practical.

## Practical 2

During this practical you will deploy a OpenLava 2.2 cluster in our test tenancy in Embassy Cloud. This is a two step process: we’ll need to provision the infrastructure first using Terraform, and we’ll then apply the required configuration on the VMs (*contextualise*) via Ansible. Off we go!

1. Log back into your base VM (user-XX-vm)

2. As you’ve started a new SSH session, you’ll need to populate your environment again by sourcing the OpenStack configuration file as follows:  `source ~/user_XX.sh`

	Enter your OpenStack password when prompted.

3. We now need to move into the directory where the Terraform and Ansible code is stored, so `cd` into `deployment_workshop/practical_cluster`

4. As mentioned earlier, this practical requires both Terraform and Ansible. For easiness of use, we’ve included all the commands required to carry out the full deployment in a bash script called deploy.sh. The script is heavily commented, so open it and have a look around. Should you have any question, just ask for help!

5. Once you’re comfortable with what the deploy script does, you can go ahead and deploy the cluster. Before that, make sure you’ve customised the `TF_VAR_name`, `TF_VAR_DEPLOYMENT_KEY_PATH` and bastion_ip values with the right ones to avoid disappointments.

6. Run ./deploy.sh

7. Once the deployment is finished, you can ssh into your cluster: `ssh -i private_key_path centos@ip_displayed_by_the_deploy_script`

8. Check that your 1-node cluster is up and running by executing bhosts. You should see a master and a compute node.

9. This cluster has a predefined queue. Find out its name with bqueues

10. Time to put your new cluster to work! Submit a test job executing bsub `sleep 30 && echo "done!" > /home/centos/happiness.txt`

11. Now check that the job has been queued successfully with running bjobs. You should see your job in the queue! 

12. A text file `happiness.txt` should appear in your home folder after the job has run. Open it, your job is done! 

13. Now that you’ve achieved an awful lot of compute with your cluster it’s time to destroy it. First, terminate your ssh connection with exit.

14. Customise the `destroy.sh` script replacing the dummy `TF_VAR_DEPLOYMENT_KEY_PATH` value with the path to your private key. 

15. Run ./destroy.sh. Hopefully your cluster will go away :-)

**_Bonus things if you have time:_**

**Access the Ganglia monitoring interface**

Along with the cluster, this deployment also installs Ganglia, a monitoring system. It’s web interface it’s available at the URL `your_master_ip_address/ganglia`. When prompted, the default username is `mmg_user`, password is `resops_training`. However, as the VM is behind a bastion, you’ll need to setup a SOCKS proxy to reach it. There’s a guide [`here`](https://www.digitalocean.com/community/tutorials/how-to-route-web-traffic-securely-without-a-vpn-using-a-socks-tunnel) that will help you in this adventure. 

The full network stack deployment contained in the `resops_workshop/practical_cluster_full_network` doesn't  suffer of this problem, and you’ll be able to access the interface directly. Alternatively, we might simply ask Terraform to provision a floating ip - a public ip can be floated around VMs in the OpenStack world - for our master node to access it directly (you’re also able to skip the bastion host, in that case).

**Change the number of nodes in the cluster, or their flavour**

When writing the Terraform code of this practical, we tried to use variables for every single bit of configuration we thought we would have needed to change later on. A very easy use-case for this is changing the number of nodes composing the cluster, or their flavour (their size). Have a look in `terraform/openlava_ostack_var.tf` to see all the things you can customise without changing a single line of code. You can either change the default values, or create a `.tfvars` file to override them. Try to change the flavour of the nodes from `s1.tiny` to `s1.small` and bump up the number of nodes to 2.  
Remember to destroy your current cluster before deploying a new one! 

**Pre-bake images**

As you have experienced, deploying an OpenLava cluster from scratch takes time as you need to install many packages and apply a considerable amount of configurations. However, most of these configurations can be applied upfront, thus creating a custom (or pre-baked) image for our master and compute codes as well as for the the NFS server. This will considerably shorten the deployment time, reducing the configurations we need to do at deployment to mostly network configurations. Ideally, we want to maintain the same codebase to both deploy from scratch and from pre-baked images. One way to achieve this to add a unique Ansible [`tag`](http://docs.ansible.com/ansible/playbooks_tags.html) to each task (or play, or role) which is required to be executed at deployment time, and then use the `--skip-tags` and `--tags` options when running Ansible. In the codebase we’re using during this practical, we added the tag `live` to all the tasks that must be executed at deployment time. We can thus deploy a small cluster with 1 master, -1 compute node and 1 NFS server and pre-bake them running (remember to substitute `$bastion_ip` with the real IP of the bastion!):

```
TF_STATE='../terraform/terraform.tfstate' ansible-playbook -i /usr/local/bin/terraform-inventory --extra-vars "bastion_ip=$bastion_ip" -u centos --skip-tags live deployment.yml
```

This will let Ansible know that only tasks that don’t have a `live` tag need to be executed. When Ansible finishes, you can go back to the OpenStack interface and create a snapshot for each of them. (there’s a `Create Snapshot` button on the right for each VM). OpenStack will ask you to give it a name, and a good naming schema to adopt would be `vmrole_user_XX` (so `master_user_01`, `node_user_01` and `nfs_user_01` for `user_01`). Snapshots will be uploaded to the image management system, and you can find them in the `Images` tab in the web interface. Once they’re `Active`, you can inspect them clicking on the their name. Take a note somewhere of their IDs, as you’ll need them in a second. Hey! Congrats, you just pre-baked your first image! 

Now, next step is to tell Terraform that you want to spin up your next cluster starting from those pre-baked images, not from a basic CentOS one. Variables will help you again here! There are three variables in our Terraform code that define the base images the three types of machines we need: `master_image_id`, `node_image_id` and `nfs_image_id`. Defaults values for these are defined in terraform/openlava_ostack_var.tf, and they’re currently all pointing to the same CentOS 7 image. To change the deployment, you can either update the default values, create a `.tfvars` file as explained in the previous practical, or define environment variables that will then be picked up by Terraform at run time (have a look at the `deploy.sh` script on how to do this, `export` is your friend here). OK, now that you’re pointing to the new images, you’re almost ready to go. What’s the missing bit, then? We still need to tell Ansible that it only needs to execute the tasks tagged with a `live tag, which can be done updating the Ansible invocation in the deploy.sh script like this:

```
TF_STATE='../terraform/terraform.tfstate' ansible-playbook -i /usr/local/bin/terraform-inventory --extra-vars "bastion_ip=$bastion_ip" -u centos --tags live deployment.yml   
```

Now we’re ready to deploy! Execute the `deploy.sh` script and keep an eye on the clock!

You’re at the end of our practicals, well done! Feel free to play around with your deployment even further (try to scale it up, for example, without destroying it first!)

## Practical 3

You now have enough knowledge (or code you can copy from ;-) ) to write your own ResOps code.

Try to:

* Use Terraform to spin up two identical VMs (docs here: [`https://www.terraform.io/docs/providers/openstack/`](https://www.terraform.io/docs/providers/openstack/)) 

* Use Ansible to install nginx in both of them (docs here: [`http://docs.ansible.com/ansible/index.html`](http://docs.ansible.com/ansible/index.html), you want to look for the yum module) 

* Use terraform-inventory to link the two into a single `deploy.sh`

* Try to access the nginx servers from your base vm (a `curl ip_address_of_the_vm` will do)

## Portal Practical

* Repo hosting the application: [`https://github.com/EMBL-EBI-TSI/resops_workshop_portal_cluster`](https://github.com/EMBL-EBI-TSI/resops_workshop_portal_cluster)

* EMBL-EBI Cloud Portal: [`https://cloud-portal.ebi.ac.uk/`](https://cloud-portal.ebi.ac.uk/)

1. Connect to the EMBL-EBI Cloud portal ([`https://cloud-portal.ebi.ac.uk/`](https://cloud-portal.ebi.ac.uk/)) and log-in using your ELIXIR account

2. Add the OpenLava application  ([`https://github.com/EMBL-EBI-TSI/resops_workshop_portal_cluster`](https://github.com/EMBL-EBI-TSI/resops_workshop_portal_cluster)) to the registry

3. Create a new set of credentials in your profile. The fields you need are (case sensitive!):

    - **`OS_AUTH_URL`**
    - **`OS_TENANT_ID`**
    - **`OS_TENANT_NAME`**
    - **`OS_USERNAME`**
    - **`OS_PASSWORD`**

    *You can find all of them in the `users_XX.sh` file the home of your base VM (the one you were using earlier today to run the deployments).*

4. Create a new set of deployment parameters. The fields you need are (case sensitive!):

    - **`external_net_uuid`**: `e25c3173-bb5c-4bbc-83a7-f0551099c8cd`
    - **`floating_pool`**: `ext-net-36`
    - **`availability_zone`**: `(leave it empty)`
    - **`master_image_id`**: `3e8781ee-acfd-4f10-9884-5471378792e7`
    - **`openstack_subnet`**: `10.100.0.0/16`
    - **`nfs_image_id`**: `3e8781ee-acfd-4f10-9884-5471378792e7`
    - **`network_name`**: `base_vms_network`
    - **`node_flavor`**: `s1.small`
    - **`master_flavor`**: `s1.small`
    - **`node_image_id`**: `3e8781ee-acfd-4f10-9884-5471378792e7`
    - **`nfs_flavor`**: `s1.small`

5. Create a new Configuration linking your Credential and Deployment parameters.

6. Go off & deploy your cluster :-)

## Portal Packaging Practical

The official documentation to package applications to the cloud portal is hosted here:

[`http://embl-ebi-cloud-portal-documentation.readthedocs.io/en/latest/dev_documentation/`](http://embl-ebi-cloud-portal-documentation.readthedocs.io/en/latest/dev_documentation/)

For this practical, you’ll define your own application. You can start from the OpenLava deployment you used this morning and adapt the `deploy.sh` and `destroy.sh` to be used in the Cloud Portal. You’ll need to push this to a public git repository to add it to the portal. 

Feel free to go and have a go :-)

