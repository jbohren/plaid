
robot models
============

## Don't use Xacro

Xacro is an XML "macro" system intended to make it easier to create complex XML
files, motivated by reducing repetition and increasing scalability of ros URDF
and SDF files. However, use of Xacro can quickly get out of hand, with
excessive string prefixing and suffixing, in-line math and python-ish code, and
[other shenanigans](http://wiki.ros.org/xacro#Unrolling_loops).

If a complex XML structure needs to be created, python lxml etree's builder is
not only expressive and simple to use, but its imperative structure will be
easier to comprehend by new developers.

Consider a simple example:

```xml
<robot name="bot">
    <xacro:property name="alpha" value="${30/180*pi}" />

    <link name="world"/>
    <link name="l1"/>

    <joint name="j1" type="revolute">
        <parent link="world">
        <child link="l1"/>
        <limit
            lower="${-alpha}"
            upper="${alpha}"
            effort="0"
            velocity="${radians(75)}" />
    </joint>
</robot>
```

```python3
from math import pi, radians

from lxml import etree
from lxml.builder import E

alpha = 30/180*pi

robot = E.robot(
    E.link(name='world'),
    E.link(name='l1'),

    E.joint(
        E.parent(link='world'),
        E.child(link='l1'),
        E.limit(
            lower=f'{-alpha}',
            upper=f'{alpha}',
            effort='0',
            velocity=f'{radians(75)}'),
        name='j1',
        type='revolute'),
    name='bot')

print(etree.tostring(robot, pretty_print=True))
```



