
ament
=====

## Python Bindings Package

When building a package which uses SIP or pybind11 to generate
python bindings for a c++ library, the standard `ament_cmake_python`
facilities can't be used, so env-hooks need to be explicitly
generated to add the python site-packages to `PYTHONPATH`.

Create an `env-hooks/<PACKAGE_NAME>.dsv.in` file in the package similar to:
```cmake
prepend-non-duplicate;PYTHONPATH;lib/python@PYTHON_VERSION_MAJOR@.@PYTHON_VERSION_MINOR@/dist-packages
```

Then in the CMakeLists.txt, add the env hook:
```cmake
ament_environment_hooks(env-hooks/<PACKAGE_NAME>.dsv.in)
ament_package()
```
