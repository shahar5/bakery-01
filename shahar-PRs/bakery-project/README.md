Write a Jenkins pipeline that takes the following params:
- dropdown param name: region with all the us regions.
- string param: s3_folder_path
- string param: data_folder_path
- dropdown param named:  action with the following option -> create, destroy.
- Boolean param named: destroy_volumes his default value should be false.

If the action is create Jenkins will use Terraform to deploy EC2 (ubuntu) instance on AWS.
EC2 OS disk should be ephemeral.
Attach 2 additional volumes:
1. s3 bucket - on path /home/ubuntu/${s3_folder_path}
2. EBS volume - on path /home/ubuntu/${data_folder_path}/
* Make sure when you destroy and recreate the instance volumes[data] is still preserved.

Please don’t use any of the defaults resources.
create dedicate VPC, SG, subnet etc.
make sure you are able to SSH to it and that the instance have internet access.

file structure should be:
main.tf
outputs.tf
variables.tf
version.tf

IF action == destroy Jenkins will as the user to approve it.
Once approved Jenkins will destroy the instance and leave the volumes up unless  destroy_volumes is true.

spin up Nexus container
1. download a text file from Nexus to each of your volumes.
2. use Nexus to automate your whole process.

** Few notes **
- Try not copy pre-made examples from the internet. work with TF documentation.
- No hard-coded values.
- Put all the useful information at outputs.tf  file (think like CI/CD eng)
- You may use scripted OR declarative syntax. don’t mix them.
- Any secret/credential should be stored on Jenkins credentials manager. make sure you don’t accidentally push any secret to git or printing them on the console view. Jenkins provided masking function for preventing it.
