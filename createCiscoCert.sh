#!/bin/bash
#Create certificate request for Cisco SG Small business switches with subject Alternative Name and converted RSA public key.
#Cisco SG switches support a max certificate size of 2048
#ref https://stackoverflow.com/questions/10271197/how-to-extract-public-key-using-openssl
#ref https://severehalestorm.net/?p=54
#20180911 Carl Weiss

#Set to the location of the openssl.cnf file.
openSSLConfig=/etc/pki/tls/openssl.cnf

#Set Certificate Defaults
domainName=defaultdomain.com
O="Company"
OU="Department"
L="City"
ST="State"
C="Country"

echo "#########################################################################"
echo Certificate Defaults:
echo 	O:$O
echo 	OU:$OU
echo	L:$L
echo	ST:$ST
echo	C:$C
echo Domain name: $domainName
echo "#########################################################################"

#simple check to accept prompted input or parameter
if [[ -n $1 ]];
 then
  hostname=$1; 
 else
  echo Enter the hostname of the certificate:
  read hostname; 
fi

#create sub directory
mkdir $hostname
cd $hostname

echo "Files will be placed in the $hostname dir"
fqdn=$hostname.$domainName

echo creating certificate request for: $fqdn
echo creating certificate configuration: $hostname.cnf
cat $openSSLConfig <(printf "[SAN]\nsubjectAltName=DNS:$fqdn") >> $hostname.cnf

#create certificate
openssl req -new -sha256 -newkey rsa:2048 -keyout $hostname.key -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$fqdn" -reqexts SAN -config $hostname.cnf -out $hostname.csr

#generate the RSA private key
openssl rsa -in $hostname.key -outform PEM -out $hostname.pem

#generate public key
openssl rsa -in $hostname.pem -outform PEM -pubout -out $hostname.pub

#generate Cisco key 
cat $hostname.pub | sed -r 's/(MIIBI.{27})//' | sed -r 's/(PUBLIC)/RSA PUBLIC/' > $hostname.pub.cisco

echo "Copy the $hostname.csr file to the CA server for signing..."
echo "Use the $hostname.pub.cisco file as the public key"
echo "Use the $hostname.pem as the private unencrypted key"

echo "#########################################################################"
echo "$hostname.csr file contents"
cat $hostname.csr
echo "#########################################################################"
echo 
echo "#########################################################################"
echo "$hostname.pem Private Key file contents"
cat $hostname.pem
echo "#########################################################################"
echo
echo "#########################################################################"
echo "$hostname.pub.cisco Public Key contents"
cat $hostname.pub.cisco
echo "#########################################################################"

