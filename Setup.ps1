#Functions
function Show-Menu {
    param (
        [Parameter(Mandatory)]
        [string]$Title,

        [Parameter(Mandatory)]
        [string[]]$Options
    )
    $i = 0

    Clear-Host
    Write-Host "================ $Title ================"

    foreach ($option in $Options ) {       
        Write-Host ($i + 1): $option
        $i++
    }
}

#Initial Declarations

$art = @"
 ____                 _ __  __
|  _ \  ___  __ _  __| |  \/  | ___  _   _ ___  ___
| | | |/ _ \/ _` |/ _` | |\/| |/ _ \| | | / __|/ _ \
| |_| |  __/ (_| | (_| | |  | | (_) | |_| \__ \  __/
|____/ \___|\__,_|\__,_|_|  |_|\___/ \__,_|___/\___|

"@

$osDrive = (Get-WmiObject Win32_OperatingSystem).SystemDrive

Write-Host $art
Start-Sleep 1

# Check for DeadMouse Already Installed

if (Test-Path -Path $osDrive\Scripts\DeadMouse.ps1){

    do {
        $answer = Read-Host "It appears you already have deadmouse configured. Would you like to overwrite it? (Y/N)"
    }
    until ($answer -eq "Y" -or $answer -eq "N")

    if($answer -eq "N"){
        Write-Host "Goodbye"
        exit
    }
}

#Select Bluetooth Device to Monitor

$devices = Get-PnpDevice -Class 'Bluetooth'

$results = foreach ($device in $devices) {
    Clear-Host 
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

$selectionName = $selection.name
Write-Host "You Selected:" $selectioNname

# # Select Battery Level

# do {

# }
# until ()


# Select Time

$parsedDate = [DateTime]::MinValue


do {
$tasktime = Read-Host "What time would you like the system to check each day (24 Hour) (HH:MM)"

$isValid = [DateTime]::TryParseExact(
    $tasktime,
    "HH:mm",
    [System.Globalization.CultureInfo]::InvariantCulture,
    [System.Globalization.DateTimeStyles]::None,
    [ref]$parsedDate
)

}
until ($isValid)




$deadMouseScript = @"

    # Config
    `$deviceName = "$selectionName"
    `$lowBatLevel = 65

    # Script (Do Not Edit)
    `$device = Get-PnpDevice -Class 'Bluetooth' -FriendlyName `$deviceName

    `$battlevel = (Get-PnpDeviceProperty -InstanceId `$device.DeviceID -KeyName '{104EA319-6EE2-4701-BD47-8DDBF425BBE5} 2').Data



        `$xml = `@"
        <toast scenario="incomingCall">

        <visual>
            <binding template="ToastGeneric">
            <text>DeadMouse `$battlevel%</text>
            <text>Charge your `$deviceName</text>
            </binding>
        </visual>

        </toast>
`"@

    if (`$battlevel -le `$lowBatLevel){
        

        `$XmlDocument = [Windows.Data.Xml.Dom.XmlDocument, Windows.Data.Xml.Dom.XmlDocument, ContentType = WindowsRuntime]::New()
        `$XmlDocument.loadXml(`$xml)
        `$AppId = '{1AC14E77-02E7-4E5D-B744-2EB1AE5198B7}\WindowsPowerShell\v1.0\powershell.exe'
        [Windows.UI.Notifications.ToastNotificationManager, Windows.UI.Notifications, ContentType = WindowsRuntime]::CreateToastNotifier(`$AppId).Show(`$XmlDocument)

    }

"@





Write-Host "The system will create a script at $osDrive\Scripts\DeadMouse.ps1"

$deadMouseScript | Set-Content $osDrive\Scripts\DeadMouse.ps1
# Lay down worker script

# Lay down scheduled






