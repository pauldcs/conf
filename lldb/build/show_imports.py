#!/usr/bin/python3
import lldb

# Import this module by running:
#     (lldb) command script import show_imports.py
#     (lldb) show_imports

def show_imports(
        debugger,
        command,
        result,
        internal_dict
    ):
    """
    LLDB module auto-generated by lldbmodgen on Mon Sep  9 00:40:46 CEST 2024.
    """

    target = debugger.GetSelectedTarget()
    for m in target.module_iter():
        print(m)

def __lldb_init_module(
        debugger,
        internal_dict
    ):
    debugger.HandleCommand('command script add -f show_imports.show_imports show_imports')
    print(' Installed: "show_imports"')

