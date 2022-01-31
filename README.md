
Accelerate ros2 Development with plaid
======================================

_Spaceballs The Film_ inspired a lot of the original
terminology in ROS. This repository pays homage to that era
and contains tools and opinionated guidelines to accelerate
development with ros2.

<img src="https://raw.githubusercontent.com/jbohren/plaid/master/doc/plaid.gif" width="250">

## Opinionated Guideline Topics

- [ament](topics/ament.md)
- [launchfiles](topics/launchfiles.md)
- [robot models](topics/robot_models.md)

## Other Notable Opinions

- https://snorriheim.atlassian.net/wiki/spaces/TechnicalNotes/pages/1179692/Ros

## plaid CLI Tool

The `plaid` command line tool provides shortcuts for working with ros2 workspaces.

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

### Eye Candy

To add an optional workspace nickname to your prompt, add a file named
`plaid.conf` to your workspace root containing:

```bash
PROMPT_PREFIX="[megamaid] "
```
