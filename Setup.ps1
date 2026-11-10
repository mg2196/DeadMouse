#Functions
function Show-Menu {
    param (
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string[]]$Options
    )
    $i = 0

    cls
    Write-Host "================ $Title ================"

    foreach ($option in $Options ) {       
        Write-Host ($i + 1): $option
        $i++
    }
}

# Begin Script Art
$art = @"
     ____                 _ __  __
    |  _ \  ___  __ _  __| |  \/  | ___  _   _ ___  ___
    | | | |/ _ \/ _` |/ _` | |\/| |/ _ \| | | / __|/ _ \
    | |_| |  __/ (_| | (_| | |  | | (_) | |_| \__ \  __/
    |____/ \___|\__,_|\__,_|_|  |_|\___/ \__,_|___/\___|
"@


Write-Host $art
Start-Sleep 1



#Select Bluetooth Device to Monitor

$devices = Get-PnpDevice -Class 'Bluetooth'

$results = foreach ($device in $devices) {
    cls 
    Write-Host "Scanning:" $device.FriendlyName

    $battlevel = (Get-PnpDeviceProperty -InstanceId $device.InstanceId -KeyName '{104EA319-6EE2-4701-BD47-8DDBF425BBE5} 2').Data

    if ($battlevel) {
        [pscustomobject]@{
            name = $device.FriendlyName
            batt = $battlevel
        }            
    }            
}

# Select Device to Monitor

do 
{
    Show-Menu 'Select the Device you would like to monitor'  $results.name
    $input = Read-Host "Choose"
}
until ($input -gt 0 -and $input -le ($results.name).Count)

$selection = $results[$input - 1]

Write-Host "You Selected:" $selection.name


# Select Frequency of Checking

$time = @('daily', 'weekly')

do 
{
    Show-Menu 'Select Frequency of polling'  $time
    $input = Read-Host "Choose"
}
until ($input -gt 0 -and $input -le ($time).Count)

$selection = $time[$input - 1]

Write-Host "You Selected:" $selection


