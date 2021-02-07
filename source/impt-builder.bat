@echo off

:: Capture the current working directory
set cwd=%cd%

:: Check for the existence of a 'Build' directory
set dir="./Build"
if exist %dir% (rmdir /Q /S %dir%)
mkdir %dir%

echo Running the Squirrel file binding process
call pleasebuild device/device.includes.nut > Build/compiled.device.nut
call pleasebuild agent/agent.includes.nut > Build/compiled.agent.nut

echo Building the Squirrel project
call impt build run

:exit
cd %cwd%
echo Exiting...