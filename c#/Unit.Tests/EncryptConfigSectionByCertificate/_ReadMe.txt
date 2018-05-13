
Steps to create the certificate
===============================
	Open IIS (Start > Run > inetmgr)
	Open "Server Certificates" from the server node
	Actions > "Create self-signed certificate"
	Friendly name = "my-cert"

Add to cert store
=================
	Start > Run > mmc
	File > Add/Remove snap-in
	Certificates
	My computer
	Open Certificates > Personal
	Right click on the right-hand pane and select "All Tasks > Import"
	Browse and locate the file (change the file type to all so you can find the ".pfx" file)
	Next
	Enter the password you used to create the cert
	Next, Finish

	You should now see your certificate in the store
		- Note that the "Name" will be your machine name, scroll across to the "Friendly Name" column and you should see "my-cert"

Get the thumbprint
==================
	Still in the MMC console, double click on your "my-cert" certificate
	Click the "Details" tab and find the Thumbprint entry
	Copy the value to the clipboard and paste it into the "config-protected-data.config" configuration file in our test below.







	