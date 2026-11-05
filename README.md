# Mouse Dead

I currently I have wireless mouse and I forget to charge it.

I want a customizable notification sent shortly before I leave the office for the day reminding me to plug it in.

# Build

I want to use skills that I fully know and make this a **NO AI** project.

# Plan

I will build a few basic powersehll scripts.

Thinking like a scheduled task that calls a script tht checks battery level and sends a windows toast

I already did some testing with Get-PNPDevice but I used AI for the specific commandlets parameters. So that must be forgotten

# Time Limitation
I am chalanging myself to track time on this project and keep the total syntax time under 1 hr.

Time tracking starts now... closing


We will need to use get-pnp

(Get-PnpDevice -Class 'Bluetooth' -FriendlyName 'MX Anywhere 2' | Get-PnpDeviceProperty -KeyName '{104EA319-6EE2-4701-BD47-8DDBF425BBE5} 2').Data