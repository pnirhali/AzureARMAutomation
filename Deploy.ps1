#Passing template name in order to deploy selected template
param ($SubscriptionName, $templateName, $resourceGroupName)

# errorActionPreference will not execute further code if system gets any error.
$ErrorActionPreference = "STOP"


# local functions start ======================================
function  Get-RandomChars {
    param (
        [int] $length = 5 
    )
    $randomChars = -join ((65..90) + ( 97..122) | Get-Random -Count $length | % { [char]$_ })
   return $randomChars
}

# local functions end ======================================
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
        $TemplateObject.virtualNetworkParams = $VirtualNetworkTemplateObject
        write-Output "Created Virtual Network param object"
    }
    Default { }
}
Write-Output "Created main template object for deployment cmd "$TemplateObject

#generate random resource group name if client doesn't send 
if (!$resourceGroupName) {
    $resourceGroupName ="Poonam-" + (Get-RandomChars -length 5)
}


# set  subscription name if client sends, else set "Free Trial"
if (!$SubscriptionName) {
    $SubscriptionName = "Free Trial"
}
# connect to Azure
Write-Output "Connecting to subscription"
Connect-AzAccount  -Subscription $SubscriptionName
#Creating Resource group
Write-Output "Creating RG"
New-AzResourceGroup -Name $resourceGroupName -Location "Australia East"

#Deploy template
Write-Output "creating template parameter object"

#2.Deployment started
Write-Output "Deployment started"
New-AzResourceGroupDeployment -Name "RgDeployment" `
    -ResourceGroupName "PoonamRG1" `
    -TemplateParameterObject  $TemplateObject  `
    -TemplateFile $templatePath

   