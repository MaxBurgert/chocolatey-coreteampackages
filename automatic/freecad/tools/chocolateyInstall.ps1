﻿$ErrorActionPreference = 'Stop';

 if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent }
. "$PSScriptRoot\helper.ps1"

$packageArgs = @{
  packageName    = 'freecad'
  fileType       = '7z'
  url            = ''
  url64          = 'https://github.com/FreeCAD/FreeCAD/releases/download/0.19_pre/FreeCAD_0.19.22522-Win-Conda_vc14.x-x86_64.7z'
  softwareName   = 'FreeCAD'
  checksum       = ''
  checksumType   = ''
  checksum64     = 'F7003B9D2404F3796C46F966B2A852C03E49885DADD2A52B215B429A06C3F7DC'
  checksumType64 = 'sha256'
  silentArgs     = '/S'
  validExitCodes = @(0)
}

if ( $packageArgs.filetype -eq '7z' ) {
  # Checking for Package Parameters
  $pp = ( Get-UserPackageParams -scrawl )
  if ($packageArgs.url64 -match "Conda") { $packageArgs.Remove("url"); $packageArgs.Remove("checksum"); $packageArgs.Remove("checksumType"); }
  if ($pp.InstallDir) { $packageArgs.Add( "UnzipLocation", $pp.InstallDir ) }
  Install-ChocolateyZipPackage @packageArgs
  if ($pp.Shortcut) { $pp.Remove("Shortcut"); Install-ChocolateyShortcut @pp }
  $files = get-childitem $pp.WorkingDirectory -Exclude $packageArgs.softwareName -include *.exe -recurse
  foreach ($file in $files) {
    New-Item "$file.ignore" -type file -force | Out-Null # Generate an ignore file(s)
  }
} else {
  Install-ChocolateyPackage @packageArgs
}
