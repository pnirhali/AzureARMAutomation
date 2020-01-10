# connect to Azure
Write-Output "Connecting to subscription"
Connect-AzAccount  -Subscription "Free Trial"

#Creating Resource group
Write-Output "Creating RG"
New-AzResourceGroup -Name PoonamRG1 -Location "Australia East"

#Deploy template
Write-Output "creating template parameter object"
#1.create template parameter oject
$TemplateObject = @{
    "administratorLogin"         = "admin1";
    "administratorLoginPassword" = "zaq1ZAQ!";
    "databaseName"               = "poonamdb";
    "tier"                       = "Basic";
    "skuName"                    = "Basic";
    "location"                   = "Australia East";
    "serverName"                 = "poonamserver";
}

#2.Deployment started
Write-Output "Deployment started"
New-AzResourceGroupDeployment -Name "RgDeployment" `
    -ResourceGroupName "PoonamRG1" `
    -TemplateParameterObject $TemplateObject `
    -TemplateFile "C:\Stuff\Poonam\AzureARM\Templates\Template.json"

   