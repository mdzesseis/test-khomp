#!/bin/bash
KEY_ID=$(cat ./AWS_ACCESS_KEY_ID)
SECRET_KEY=$(cat ./AWS_SECRET_ACCESS_KEY)
OPTION
touch ./deploy.log


clear 
MENU="
================================================
1 - Deploy Terraform
2 - Generate Key SSH
================================================
"

echo "$MENU"
read -p "choose an option: " OPTION
echo "================================================"

case "$OPTION" in
1)

  cd ../terraform\ _files/TERRAFORM_FILES_BUCKET_REMOTE_STATE/
  export "AWS_ACCESS_KEY_ID=$KEY_ID" 
  export "AWS_SECRET_ACCESS_KEY=$SECRET_KEY"
  `terraform init >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit; 
  `terraform plan -out plan.out >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit;
  `terraform apply -auto-approve plan.out  >> ../../bash/deploy.log`
  
   [ $? -ne 0 ] && echo "ERROR!" && exit; 

  cd ../TERRAFORM_FILES_AWS_VPC/
  export "AWS_ACCESS_KEY_ID=$KEY_ID" 
  export "AWS_SECRET_ACCESS_KEY=$SECRET_KEY"
  `terraform init >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit;
  `terraform plan -out plan.out >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit;
  `terraform apply -auto-approve plan.out  >> ../../bash/deploy.log`

   [ $? -ne 0 ] && echo "ERROR!" && exit; 
  
  cd ../TERRAFORM_FILES_VM/
  export "AWS_ACCESS_KEY_ID=$KEY_ID" 
  export "AWS_SECRET_ACCESS_KEY=$SECRET_KEY"
  `terraform init >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit; 
  `terraform plan -out plan.out >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit;
  `terraform apply -auto-approve plan.out  >> ../../bash/deploy.log`
   [ $? -ne 0 ] && echo "ERROR!" && exit;

   echo "Successful!"
   echo IP of instanve in deploy.log
    
;;

2) 
cd ../terraform\ _files/TERRAFORM_FILES_VM/
yes aws-vm-key | ssh-keygen  -N '' >/dev/null
[ $? -ne 0 ] && echo "ERROR!" && exit;
echo pair key generate in deploy/terraform _files/TERRAFORM_FILES_VM/
 
;;

*)
  echo "Option $OPTION not valid exinting..."
  sleep 3
  exit 1
;;

esac