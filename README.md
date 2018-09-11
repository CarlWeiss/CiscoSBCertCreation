# CiscoSBCertCreation
##Logic to create CSR for Cisco Small Business SG switches

CSR requests from Cisco SG series Small Business switches (SG500,SG300, SG350X, etc.) do not support creating a "Subject Alternate Name" 
via the Console or Web interface. The SAN is required by [Chrome](https://support.google.com/chrome/a/answer/7391219?hl=en) since version 58. If it is not present the Chrome will show the certificate as invalid.

The SG series switches also require that the public key be configured as an RSA key as opposed to the standard key format. 

The script creates the Certificate Signing Requests to be signed by your Certificate Autority (CA).

Once the Certificate has been signed you can import the certificate data and Plaintext RSA Key-Pair from the Cisco Web UI or console.

Instructions on importing Cisco SB [certificates](https://sbkb.cisco.com/CiscoSB/ukp.aspx?vw=1&docid=49843175a37149768dc4c331a05dce92_Edit_SSL_Server_Authentication_Settings_on_SG500x_Series_Sta.xml&pid=2&respid=0&snid=3&dispid=0&cpage=search)
