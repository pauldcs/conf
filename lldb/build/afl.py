#!/usr/bin/python3
import lldb

# Import this module by running:
#     (lldb) command script import afl.py
#     (lldb) afl

def afl(
        debugger,
        command,
        result,
        internal_dict
    ):
    """
    LLDB module auto-generated by lldbmodgen on Fri Sep  6 17:17:05 CEST 2024.
    """

    target = debugger.GetSelectedTarget()
    if not target:
        result.SetError("No target loaded")
        return
    
    for symbol in target.modules[0]:
        if symbol.GetType() == lldb.eSymbolTypeCode:
            addr = symbol.GetStartAddress().GetFileAddress()
            size = symbol.GetSize()
            name = symbol.name
            result.AppendMessage(f" 0x{addr:x} {size:>8} {name}")

def __lldb_init_module(
        debugger,
        internal_dict
    ):
    debugger.HandleCommand('command script add -f afl.afl afl')
    print(' Installed: "afl"')
