$sambaUser = "samba"
$sambaPassword = "samba"

$userExists = (Get-LocalUser).Name -Contains $sambaUser
if ( ! $userExists ) {
    $userOptions = @{
        AccountNeverExpires = $true
        Description = "Used for shared folders with Hyper-V guests"
        Name = "samba"
        Password = "samba"
        PasswordNeverExpires = $true
        UserMayNotchangePassword = $true
    }
    New-LocalUser @userOptions
}

$sharedDrive = "$HOME/VM_Shared"

$sharedDriveExists = Test-Path -Path $sharedDrive
if ( ! $sharedDriveExists ) {
    New-Item -Path "$sharedDrive" -ItemType "directory"
}

$sharedDriveAcl = Get-Acl "$sharedDrive"
$vagrantWorkdirAcl = Get-Acl "$PSScriptRoot"

$aclEntry = "\samba","FullControl","ContainerInherit, ObjectInherit","None","Allow"
$rule = New-Object System.Security.AccessControl.FileSystemAccessrule($aclEntry)

$vagrantWorkdirAcl.setAccessRule($rule)
$sharedDriveAcl.setAccessRule($rule)

$vagrantWorkdirAcl | Set-Acl "$PSScriptRoot"
$sharedDriveAcl | Set-Acl "$sharedDrive"