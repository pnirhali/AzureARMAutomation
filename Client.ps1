    $ScriptPath = Split-Path $MyInvocation.InvocationName
    Write-Output "Current script folder path $ScriptPath"
    $args = @()
    $args += ("-templateName", "VirtualNetwork")
    $cmd = "$ScriptPath\Deploy.ps1"
    Write-Output "file name: $cmd" 
    Invoke-Expression "$cmd $args"