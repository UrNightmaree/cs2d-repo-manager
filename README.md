# cs2d-repo-manager
A repo for managing my CS2D scripts, mod, etc.

## Building a script

Dependencies for the build script:
- Lua >= `5.1` < `5.5`, `5.1.5` preferred
- Luarocks >= `3.9.2`

Remaining dependencies is installed automatically through Luarocks in build script.

To build a script, you need to have the repo cloned and the dependencies installed (see above). After that change directory to the repo and run.
```bash
scripts/make-script.sh <script name>
```
This shell script is written in Bash, you may need MSYS2 or WSL to run it.

## Scripts
 - [**YouHelpMe**](lua/YouHelpMe)<br>
   YouHelpMe (YHM) is a CS2D Lua script for showing hint and tips upon spawning.
