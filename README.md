# Erik Kronquist - Homework 4: Social Sent Scores
## Usage Instructions
### Lua Installation
If you would like to download and install Lua to test locally (at least on Windows) go to: https://sourceforge.net/projects/luabinaries/files/5.5.0/Tools%20Executables/ and download `lua-5.5.0_Win64_bin.zip`. Then extract the zip folder somewhere onto your PC. The file called `lua55.exe` can be renamed to `lua.exe` to be able to run `lua test.lua` instead of `lua55 test.lua`. Then set the folder that the files were extracted to as an environment `PATH` variable. Now lua can be run from the command line.
### Makefile
No makefile is provided
### Execution
Run `lua main.lua` for testing the base NovelReview.txt file.<br>
Run `lua main.lua <input_file_name>.txt` for testing specific files.
### Replit
I created a blank Lua project on replit by having the replit agent by running "Blank Lua Project". I did not actually program in replit, I programmed locally in VSCode and then tested on replit. Here is the replit project I tested on: [HW4 Lua Replit Project](https://csci-3415-hw-4--erikkronquist1.replit.app)
#### Execution on Replit
Execution on replit can be done the same as locally as specified before. Alternatively the makefile provided in that replit link can be used, however I had trouble getting the green `run` button to appear in replit so I had to resort to using the replit shell.