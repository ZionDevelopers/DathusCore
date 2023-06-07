@echo off
cd /d "V:\SteamLibrary\SteamApps\common\GarrysMod\bin"
gmad.exe create -folder "D:\Github\DathusCore" -out "D:\Github\DathusCore.gma"
gmpublish update -addon "D:\Github\DathusCore.gma" -id "106681516" -changes "Change it later"
pause