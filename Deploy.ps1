#Passing template name in order to deploy selected template
param ($templateName = "SqlServer")
$templatePath = ""
$templatePath = "Templates\$templateName.json"
write-Output "selected Template path:$templatePath"

#create template parameter object 
$TemplateObject = @{ }
switch ($templateName) {
    "SqlServer" {
        $SqlServerTemplateObject = @{
            "administratorLogin"         = "admin1";
            "administratorLoginPassword" = "zaq1ZAQ!";
            "databaseName"               = "poonamdb";
            "tier"                       = "Basic";
            "skuName"                    = "Basic";
            "location"                   = "Australia East";
            "serverName"                 = "poonamserver";
        }
        $TemplateObject.SqlServerParams = $SqlServerTemplateObject
        write-Output "Created Sql server param object"

    }
    "VirtualNetwork" {
        $VirtualNetworkTemplateObject = @{ 
            "name"                 = "resource21-Vnet";
            "location"             = "North Europe";
            "addressPrefix"        = "10.1.0.0/16";
            "subnetName"           = "default";
            "subnetAddressPrefix"  = "10.1.0.0/24";
            "enableDdosProtection" = $false;
        }
        $TemplateObject.virtualNetworkParams =$VirtualNetworkTemplateObject
        write-Output "Created Virtual Network param object"
    }
    Default { }
}
Write-Output "Created main template object for deployment cmd "$TemplateObject

# connect to Azure
Write-Output "Connecting to subscription"
Connect-AzAccount  -Subscription "Free Trial"

#Creating Resource group
Write-Output "Creating RG"
New-AzResourceGroup -Name PoonamRG1 -Location "Australia East"

#Deploy template
Write-Output "creating template parameter object"

#2.Deployment started
Write-Output "Deployment started"
New-AzResourceGroupDeployment -Name "RgDeployment" `
    -ResourceGroupName "PoonamRG1" `
    -TemplateParameterObject  $TemplateObject  `
    -TemplateFile $templatePath

   