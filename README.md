
They've Gone into Plaid
=======================

_Spaceballs The Film_ inspired a lot of the original
terminology in ROS. This repository contains tools and guidelines to accelerate development with ros2.

## plaid CLI Tool

The `plaid` command line tool is meant to make working with ros2 workspaces more rapid.

### Workspace Management

Source an enclosing workspace:
```
plaid source [PATH]
```

Run a command at the root of the current workspace:
```
plaid ws COMMAND [ARG...]
