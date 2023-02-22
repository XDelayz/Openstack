This script, Deploys_Instance.sh, gives you the ability to quickly create an instance and throw the port to connect to the instance.
The script was created as an interactive menu, which is very convenient when you need to create an instance with specific parameters.
==================
Basic requirements:

1. Installed python-openstackclient;
2. rc-file, which you can get from your provider with the credentials to connect to the Openstack infrastructure;

In the script in the PS3="Image:" column the images will be different from the ones I have, because each provider has a different list of images.
In the - [select z in {Your list of images}] field you can specify your image values
In the field - [select flavor in {Your flavor list}] you can specify the values of your flavors
