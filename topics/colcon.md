
colcon
======

## colcon_cd is slow

On the first invocation of `colcon_cd`, it notifies you that the location of
the package has been cached. Unfortunately, caching doesn't actually speed it
up, because traversing the tree takes less time than invoking `colcon`, itself.
Running `colcon_cd` takes between 500ms and 1s, depending on the machine, which
becomes noticeable.

Invocation #1:
```
[#] jbohren@somewhere:~/ros2_ws$ time colcon_cd moveit_ros
Saved the directory '/home/jbohren/ros2_ws' for future invocations of 'colcon_cd <pkgname>' as well as to return to using 'colcon_cd'. Call 'colcon_cd --reset' to unset the saved path.

real    0m0.636s
user    0m0.568s
sys     0m0.070s
```

Invocation #2:
```
[#] jbohren@somewhere:~/ros2_ws$ time colcon_cd moveit_ros

real    0m0.636s
user    0m0.585s
sys     0m0.052s

```

However, using `find` and `xmllint` (via `plaid cd`) not only runs about 5x
faster, but also runs in under 150ms, about the limit for a human interface
response to appear "instantaneous":
```
[#] jbohren@somewhere:~/ros2_ws$ time plaid cd moveit_ros

real    0m0.123s
user    0m0.073s
sys     0m0.053s
```
