param (
  [string]$target = "./packages.config",

  [string[]]$keep = @(),

  [string[]]$exclude = @()
)

$keepExists = $keep.count -ne 0
$excludeExists = $exclude.count -ne 0

$packages = choco list -lo -r | % { $_ -split "\|" | select -first 1 }

if ($keepExists) {
  $packages = $packages | Select-String -Pattern $keep
}

if ($excludeExists) {
  $packages = $packages | Select-String -Pattern $exclude -NotMatch
}

$packageXml = ""
$packages | % { $packageXml += "`n`t<package id=""$_"" />" }
Set-Content "<?xml version=`"1.0`" encoding=`"utf-8`"?>`n<packages>$packageXml`n</packages>" -Path $target
