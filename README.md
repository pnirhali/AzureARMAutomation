# Description:
Created azure project using ARM template.
This project has a powershell script for creating and deploying resource group and resources.
Created one json template for Azure SQL.

 I parameterized deploy.ps1 with the template name and also added client.ps1 to consume deploy.ps1.
 With this changes, Resouces get deployed as per the passed template name.
 for example:- Through client.ps1, I have called deploy.ps1 with template name of "VirtualNetWork"; so, Virtual network will get deployed through this script.
 
 Parameterized resource group name and subscription name.
If client doesn't send any resouce group name to create then code will generate random char string.
Added ErrorActionReference to stop further execution of code if any error occurs.

Added support for role based access control using IAM
Provided emails will have the "Owner" role over the deployed resource group.
