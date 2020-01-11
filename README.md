# Description:
Created azure project using ARM template.
This project has a powershell script for creating and deploying resource group and resources.
Created one json template for Azure SQL.

In 3rd commit, I parameterized deploy.ps1 with the template name and also added client.ps1 to consume deploy.ps1.
 With this changes, Resouces get deployed as per the passed template name.
 for example:- Through client.ps1, I have called deploy.ps1 with template name of "VirtualNetWork"; so, Virtual network will get deployed through this script.
 
 
