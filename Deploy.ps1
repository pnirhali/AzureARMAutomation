#Passing template name in order to deploy selected template
param ($SubscriptionName, 
    $templateName = "VirtualNetwork", 
    $resourceGroupName = "Poonam-RG1",
    [string[]] $emails = @("poonamdhimate@gmail.com"))

# errorActionPreference will not execute further code if system gets any error.
$ErrorActionPreference = "STOP"

Import-Module Az
Import-Module AzureAD
Import-Module Az.Resources
Enable-AzureRmAlias

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
$randomVar = (Get-RandomChars -length 5)
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
            "serverName"                 = "poonamserver_$randomVar" ;
        }
        $TemplateObject.SqlServerParams = $SqlServerTemplateObject
        write-Output "Created Sql server param object"

    }
    "VirtualNetwork" {
        $VirtualNetworkTemplateObject = @{ 
            "name"                 = "resource21-Vnet_$randomVar";
            "location"             = "North Europe";
            "addressPrefix"        = "10.1.0.0/16";
            "subnetName"           = "default";
            "subnetAddressPrefix"  = "10.1.0.0/24";
            "enableDdosProtection" = $false;
        }
        $TemplateObject.virtualNetworkParams = $VirtualNetworkTemplateObject
        write-Output "Created Virtual Network param object"
    }

    "CosmosDB" {
        $CosmosDbTemplateObject = @{
            "name"              = "cosmosDb-$randomVar".ToLowerInvariant();
            "location"          = "westus";
            "locationName"      = "West US";
            "defaultExperience" = "Core (SQL)";
        }
        $TemplateObject.CosmosDbParams = $CosmosDbTemplateObject
        write-Output "Created Cosmos DB param object"
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
$NewRGObject = New-AzResourceGroupDeployment -Name "RgDeployment" `
    -ResourceGroupName $resourceGroupName `
    -TemplateParameterObject  $TemplateObject `
    -TemplateFile $templatePath

Write-Output $NewRGObject.ProvisioningState 

foreach ($email in $emails) {
    if (($NewRGObject.ProvisioningState -eq "Succeeded" ) -and $email) {

        $AdUser = Get-AzureRmADUser -UserPrincipalName $email
        if (!$AdUser) {
            New-AzRoleAssignment -ObjectId $AdUser.Id -ResourceGroupName $NewRGObject.ResourceGroupName -RoleDefinitionName "Owner"
        }
    }
}
