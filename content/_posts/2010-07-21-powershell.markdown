---
comments: true
layout: post
title: Powershell!?!?!?!
tags:
- Fun
---

Most of been bored last night, decided to have my first bash at automation in windows using powershell, kinda impressed but now where near the level that you can get in *nix :D
Hack of an attempt can be seen below (it works mainly but is pretty untested for the function actions as I don't have a windows server that can run hyperv, looks right per the docs though!):

```powershell
# Settings

## Email

$email_system = ""

$email_contact = ""

$email_host = ''

$email_username = ''

$email_password = ''
## Database

$database_host = ""

$database_name = ""

$database_user = ""

$database_pass = ""
## Run task settings

$run_tasks = 1

$run_reboots = 1

$run_poweroffs = 1

$run_powerups = 1
# Log file directory

$file_log_dir = 'C:\automation_logs\'
#

#

#

# Don't touch below here

#

#

#
# Session varibles
$base_log_name = $file_log_dir+$(Get-Date -format 'd-M-y-h-m-s')+'-'
# Functions
## Core functions

function log([string]$message, [string]$type = 'info')

{

if ((Test-Path -path $file_log_dir) -ne $True){

# Make log dir if it dosn't exist

write-host 'Making log dir'

New-Item $file_log_dir -type directory

}
$log_file = $base_log_name+$($type)+'.log'

write-host $message

add-content $log_file $message

}
function error([string]$traceback)

{

$error = 'Hit exception:'+$traceback

log $error 'error'

mail 'Exception encountered' $error

}
function mail([string]$subject, [string]$message)

{

#$smtp_handler = new-object Net.Mail.SmtpClient($email_host)

#$smtp_handler.Credentials = New-Object System.Net.NetworkCredential($email_username, $email_password)

#$smtp_handler.Send($email_system, $email_contact, $subject, $message)

}
function marktaskFailed([int]$task_id)

{

$time = [int][double]::Parse((Get-Date -UFormat %s))
try {
 $command = $database_handler.CreateCommand()
 $command.CommandText = "update queue set status = 'f', run_time = '$($time)' where id = '$($task_id)'"

$command.ExecuteNonQuery()

} catch {

log "Could not set status = failed for task id $task_id"

error $_.Exception.ToString()

}

}
function marktaskSuccess([int]$task_id)

{

$time = [int][double]::Parse((Get-Date -UFormat %s))
try {

$command = $database_handler.CreateCommand()

$command.CommandText = "update queue set status = 'c', run_time = '$($time)' where id = '$($task_id)'"

$command.ExecuteNonQuery()

} catch {

log "Could not set status = complete for task id $task_id"

error $_.Exception.ToString()

}

}
## Action functions

function rebootHyperVInstance($task)

{

# Un-tested bit but this is right according to the bizzare docs

$vm = gwmi -namespace root\virtualization -query "SELECT * FROM Msvm_ShutdownComponent WHERE SystemName = '$($task['machine_id'])'"

$result = $vm.InitiateShutdown("$true", "Automated shutdown requested")
if($result.returnvalue -match "0"){

$vm = gwmi -namespace root\virtualization -query "SELECT * FROM msvm_computersystem WHERE SystemName = '$($task['machine_id'])'"

$result = $vm.requeststatechange(2)
if($result.returnvalue -match "0"){

log "Task '$($task['task_id'])' ($($task['type'])) completed with success status"

marktaskSuccess($task['task_id'])

}else{

log "Task '$($task['task_id'])' ($($task['type'])) completed with failed status, could not issue powerup"

marktaskFailed($task['task_id'])

}

}else{

log "Task '$($task['task_id'])' ($($task['type'])) completed with failed status, could not shutdown vm"

marktaskFailed($task['task_id'])

}

}
function poweroffHyperVInstance($task)

{

# Un-tested bit but this is right according to the bizzare docs

$vm = gwmi -namespace root\virtualization -query "SELECT * FROM Msvm_ShutdownComponent WHERE SystemName = '$($task['machine_id'])'"

$result = $vm.InitiateShutdown("$true", "Automated shutdown requested")
if($result.returnvalue -match "0"){

log "Task '$($task['task_id'])' ($($task['type'])) completed with success status"

marktaskSuccess($task['task_id'])

}else{

log "Task '$($task['task_id'])' ($($task['type'])) completed with failed status, could not issue reboot"

marktaskFailed($task['task_id'])

}

}
function poweronHyperVInstance($task)

{

# Un-tested bit but this is right according to the bizzare docs

$vm = gwmi -namespace root\virtualization -query "SELECT * FROM msvm_computersystem WHERE SystemName = '$($task['machine_id'])'"

$result = $vm.requeststatechange(2)
if($result.returnvalue -match "0"){

log "Task '$($task['task_id'])' ($($task['type'])) completed with success status"

marktaskSuccess($task['task_id'])

}else{

log "Task '$($task['task_id'])' ($($task['type'])) completed with failed status, could not issue powerup"

marktaskFailed($task['task_id'])

}

}

&nbsp;

# Main code
## Load what we need!

try{

[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")

} catch {

log "Could not load mysql.net connector"

error $_.Exception.ToString()

break

}
## Main loop

while (1) {

write-host 'Doing run....'
## Connect to the database

try{

$database_handler = New-Object MySql.Data.MySqlClient.MySqlConnection

$database_handler.ConnectionString = "server=$database_host;uid=$database_user;pwd=$database_pass;database=$database_name;"

$database_handler.Open()

} catch {

log "Could not connect to the database :("

error $_.Exception.ToString()

break

}
write-host 'Connected to database'
try {

$command = $database_handler.CreateCommand()

$command.CommandText = "select * from `queue` where `status` = 'n'"

$data = $command.ExecuteReader()

} catch {

log "Could not run query against database"

error $_.Exception.ToString()

continue

}
write-host 'Got queue from database'
# Array where we will put our tasks!

$tasks_to_run = @()
write-host 'Loading queue'
while ($data.Read()) {

# task

try {

$task = @{}

$task['type'] = $data.GetValue(1).ToString()

$task['task_id'] = $data.GetValue(0).ToString()

$task['machine_id'] = $data.GetValue(3).ToString()
# Add task to list of tasks to run

$tasks_to_run += $task

write-host "Entered task $($task['task_id']) into queue"

} catch {

log "Could not add task to queue"

error $_.Exception.ToString()

continue

}

}

$data.close() # Close the data reader

write-host 'Loaded queue'
if($tasks_to_run.length -gt 0){

write-host "Tasks to run: $($tasks_to_run.length)!"
# Loop though the list of tasks to run

for ( $i = 0 ; $i -lt $tasks_to_run.length; $i++ ){

$task = $tasks_to_run[$i]
log "Running task $($task['task_id']) (Action '$($task['type'])' for instance '$($task['machine_id'])')"
 if($run_tasks -eq 1){

# The bit that decides what we are going to do

switch ($task['type']) {

poweron {

if($run_powerups -eq 1){

&poweronHyperVInstance($task)
 }else{
 log "Not running task '$($task['task_id'])', powerup tasks are disabled"
 marktaskFailed($task['task_id'])
 }

}
poweroff {
 if($run_poweroffs -eq 1){

&poweroffHyperVInstance($task)
 }else{
 log "Not running task '$($task['task_id'])', poweroff tasks are disabled"
 marktaskFailed($task['task_id'])
 }

}
reboot {
 if($run_reboots -eq 1){

&rebootHyperVInstance($task)
 }else{
 log "Not running task '$($task['task_id'])', reboot tasks are disabled"
 marktaskFailed($task['task_id'])
 }

}
default { # We were asked to do something we don't understand!

log "Tried to run an unknown action: '$($task['type'])' for task '$($task['task_id'])' this will need running manually!"

mail "Tried to run an unknown action: '$($task['type'])' for task '$($task['task_id'])' this will need running manually!"

marktaskFailed($task['task_id'])

}

}
 }else{
 log "Not running task '$($task['task_id'])', tasks are disabled"

marktaskFailed($task['task_id'])
 }

}

write-host 'Tasks run'

}else{

write-host "No tasks to run!"

}
write-host 'Run complete....'

# Sleep 10 seconds until next run

Start-Sleep 10

}
```

Anyway back to making this CSS I'm working on look half decent in IE!
