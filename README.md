# Eye Motion Repair.
Code that removes residual distortions due to eye motion from images and videos processed by Demotion.

- This version of the code runs on python 3 and can use updated matlab versions.
- This script can handle multiple FOVs at a time and the results have a transparent fill.
- Trim_Warped_Edges has been integrated into this script, so that the images are compatible with ImageJ.
  - There is no need to run Trim_Warped_Edges after this script anymore.

# To set up python 3 to connect to matlab

- Determine the python version needed for the matlab version
  - https://www.mathworks.com/support/requirements/python-compatibility.html
  - If Matlab 2023b, need python 3.9-3.11 (3.11 vetted)
    - [Python Release Python 3.11.0 | Python.org](https://www.python.org/downloads/release/python-3110/)
    - NOTE: If not using python 3.11, edit the python path listed in line 56
- Installing python:
  - Select custom installation
  - Optional Features: Check all boxes except py launcher
  - Advanced Options: Check Install Python for all users, Create shortcuts for installed applications, precompile standard library
    - Install location must be: C:\Python3##
- Install Pycharm community edition if not allready installed
- Lauch Pycharm and open script
- Create new interpreter
  - existing interpreter, select python.exe in the folder location that was just installed
  - Install numpy for the interpreter
- On initial script run through, script will prompt you to select the python folder within the matlab installation folder.
  - It will then perform the linking commands between matlab and python and will end the script
- The script should then work as expected.




