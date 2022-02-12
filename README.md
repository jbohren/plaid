
Accelerate ros2 Development with plaid
======================================

_Spaceballs The Film_ inspired a lot of the original
terminology in ROS. This repository pays homage to that era
and contains tools and opinionated guidelines to accelerate
development with ros2.

<img src="https://raw.githubusercontent.com/jbohren/plaid/master/doc/plaid.gif" width="250">

## Opinionated Guideline Topics

- [ament](topics/ament.md)
- [colcon](topics/colcon.md)
- [launchfiles](topics/launchfiles.md)
- [robot models](topics/robot_models.md)

## Other Notable Opinions

- https://snorriheim.atlassian.net/wiki/spaces/TechnicalNotes/pages/1179692/Ros

## Other User-Oriented Tooling

- https://github.com/MetroRobots/ros_command
- https://github.com/yossioo/ROS-Hacks

## plaid CLI Tool

The `plaid` command line tool provides shortcuts for working with ros2 workspaces.

Dependencies:
 - [GNU bash](https://www.gnu.org/software/bash/)
 - [GNU findutils](http://xmlsoft.org/xmllint.html)
 - [xmllint](http://xmlsoft.org/xmllint.html)

Optional:
 - [grc](https://github.com/garabik/grc)

To use it, add the following to your bash profile:
```
source /path/to/plaid/plaid_functions.bash
```

### Workspace Management

Source an enclosing workspace or one which encloses a particular path:
```
plaid source [PATH]
```

Move around a workspace
```
plaid cd [PKG]
```

Build specific packages (or the enclosing package):
```
plaid build [--this] [PKG [PKG..]]
```

Run a command (e.g. `find -name *.yaml`) at the root of the current workspace:
```
plaid ws COMMAND [ARG...]
```

### Workspace Configuration File

The `plaid` cli tool reads in variables from `plaid.conf` if it exists in the
root of your workspace.

#### Eye Candy

To add an optional workspace nickname to your prompt, add the following to the `plaid.conf` file:

```bash
PROMPT_PREFIX="[megamaid] "
```

To run `colcon` with colored output, install the
[grc](https://github.com/garabik/grc) configurations via [conf/grc/install.bash](conf/grc/install.bash)
and add this to the `plaid.conf` file:

```bash
COLCON_BUILD_PREFIX='grc -s -e'
```

#### Build Flags

To add build flags to each `plaid build` command, add the following to the
`plaid.conf` file:

```bash
COLCON_BUILD_FLAGS="--symlink-install"
```
