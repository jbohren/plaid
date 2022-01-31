
launchfiles
===========

## Use XML before Python

The python launch syntax is as powerful as it is verbose. If you just need to
start a set of processes, XML is a good place to start.

## Don't Name Nodes In Launchfiles

Launch conflates the concepts of "nodes" with "executables" and this can create
issues when launching complex executables which own more than one node. If the same node needs to be launched multiple times, use _namespaces_ instead.

Specifically, avoid:

```xml
<node name="barf" package="winnebago" exec="pilot"/>
```

```python
Node(
    package='winnebago',
    executable='pilot'
    name='barf'
)
```

If two nodes are created within a single executable given a `name` from a
launchfile, there will be no explicit warnings except from the logging
facilities:

```
...
[WARN] [1643666642.955360588] [rcl.logging_rosout]: Publisher
already registered for provided node name. If this is due to multiple nodes
with the same name then all logs for that logger name will go out over the
existing publisher. As soon as any node with that name is destructed it will
unregister the publisher, preventing any further logs for that name from being
published on the rosout topic.
...
```

Note that running `ros2 node list` will detect and warn about this condition:

```
WARNING: Be aware that are nodes in the graph that share an exact name, this
can have unintended side effects.
```

