#! /bin/bash

# cd /opt/
# wget https://nagarro-hybris-bucket.s3.amazonaws.com/SAPQSA/sh-install-mysql.sh
# wget https://nagarro-hybris-bucket.s3.amazonaws.com/SAPQSA/sh-sql-install-script.exp
# wget https://nagarro-hybris-bucket.s3.amazonaws.com/SAPQSA/sh-sql-query.exp
# chmod +x sh-*
# ./sh-install-mysql.sh
# ./sh-sql-query.exp

# wget https://nagarro-hybris-bucket.s3.amazonaws.com/SAPQSA/spruce.sh
# chmod +x spruce.sh
# ./spruce.sh
echo "DATE"
date
yum install update -y
yum install wget tomcat -y
cd /var/lib/tomcat/webapps/
wget -O "blue.war" "https://demo-artifact-repo-0903.s3.ap-south-1.amazonaws.com/Blue.war?response-content-disposition=inline&X-Amz-Security-Token=IQoJb3JpZ2luX2VjEJ%2F%2F%2F%2F%2F%2F%2F%2F%2F%2F%2FwEaCmFwLXNvdXRoLTEiSDBGAiEA%2FmM%2BWX2KgPWepr9WodjHIJlCalYeLKBsF5D7wl2By80CIQD4ppIx1o7hnccdwn7JaFsm3HQ%2BiOcXd725eqsThEBqLCr7AghYEAIaDDE4NjMxOTU3NTAxOSIMSGcqvwCTfu3dgBjpKtgCx8n9VmqQqL2qmTRWF%2Fh0YdGn%2BtnVWjOKPwVtXlytbDSemTS6B%2BpI9NNO4CoE1rDE2VV2RviXxQNf5EOpZEBxv8ikrbv5ktazAjIXBdo7ZsCPUxO49RBUxxM3rNJQl%2BVX7TgN92s5Pe4XVcd%2BFNuy0bVULIOnQkFTsKWPCeXgQm%2FiReaKY5uhO1yNqpEECFwwvZC5vpQ9YJvZTWWxBTAau%2Bc%2FFYCifqWVj8KDP8nK%2FmBlb0FOJ7c6FqzJeIXZH4qcwK2JlbALAj59FA%2FQ%2BKS0wDHAPqsp4uqSQAaP0fnroZ1WjA378mBc1WzAb6Pl7fqDsIauoTAEtv%2FXAhbObNWFpNgNwNJz3JW0lriqSM4o0lvJ%2FnEZAIozBAy59f7e3n6EblJgq1%2BZGjwbRRUEC7aww1gdM7s6uMdU921ooAFDltXbw0AnKJzGA8S9uCNWUsiWtJqgXV3pEH8w7auloAY6sgI0tngdheBThrbBdzRFTCmH8GRjalksZjzJ671525DAcDJQMvG59GQEmGUbBrRJ7jA1HtwkDyuxPQ%2BXdF3jM6u7pbnn6NgnApyIQjKyl8i0kFX8B9AI2CGSeYw%2BVVTX8o2HpABXR4%2FJSlwqeKA6tpzPw91trwGwLGpscT5A48ox5HIyPVFegCbkMefPtVYg0u4HGgVADO6OWe1UHHEwzJY1rByuy60e45mPnd25Xmz9LM0ryoxPrMdU%2F3wE1PQ9I%2F5%2FJdR0W4u863Oxsrchw8AX1Nv6kAbjfFjZqlfjHD0b9Rlf4Ss8qtI1KUeBwRQSgVxEGGiZKle0bGpX2JDhG8Mfind7QEvHn4OZgeSi3yTQwAFbrJ8PElOwrqGjPk8FU202fOkRZCizzfZEPvvNPogwdG4%3D&X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20230309T111940Z&X-Amz-SignedHeaders=host&X-Amz-Expires=43200&X-Amz-Credential=ASIASWYMDC7VSIE7OO24%2F20230309%2Fap-south-1%2Fs3%2Faws4_request&X-Amz-Signature=43eb69c7f41f95cd020d2eda675a1f3d850c900f3f68dd4845ce730ae7a5f565"
service tomcat start