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