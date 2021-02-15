@echo off

:: Capture the current working directory
set cwd=%cd%

:: Check for the existence of a 'Build' directory
set dir="./build"
if exist %dir% (rmdir /Q /S %dir%)
mkdir %dir%

echo Running the Squirrel file binding process
call pleasebuild device/device.includes.nut > build/compiled.device.nut
call pleasebuild agent/agent.includes.nut > build/compiled.agent.nut

echo Building the Squirrel project
call impt build run

:exit
cd %cwd%
echo Exiting...