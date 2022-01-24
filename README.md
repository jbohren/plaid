
Accelerate ros2 Development with plaid
======================================

_Spaceballs The Film_ inspired a lot of the original
terminology in ROS. This repository pays homage to that era
and contains tools and opinionated guidelines to accelerate
development with ros2.

<img src="https://raw.githubusercontent.com/jbohren/plaid/master/doc/plaid.gif" width="250">

## Opinionated Guideline Topics

- [launchfiles](topics/launchfiles.md)

## plaid CLI Tool

The `plaid` command line tool provides shortcuts for working with ros2 workspaces.

### Workspace Management

Source an enclosing workspace or one which encloses a particular path:
```
plaid source [PATH]
```

Run a command (e.g. `colcon build`) at the root of the current workspace:
```
plaid ws COMMAND [ARG...]
```

Set a workspace nickname:
```
plaid nick set NICKNAME
```

### Eye Candy

To add an optional workspace nickname to your prompt, add the following to your profile file:

```
export PS1="$PLAID_PROMPT_PREFIX$PS1"
```
