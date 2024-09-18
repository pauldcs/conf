target = debugger.GetSelectedTarget()
process = target.GetProcess()
thread = process.GetSelectedThread()
frame = thread.GetFrameAtIndex(0)
sp = frame.GetSP()

addr_byte_size = target.GetAddressByteSize()

num_elements_before = 4
num_elements_after = 16

start_addr = sp - num_elements_before * addr_byte_size
end_addr = sp + num_elements_after * addr_byte_size

if not frame:
    result.AppendMessage("no stack frame")
    return

for i, addr in enumerate(range(start_addr, end_addr, addr_byte_size)):
    error = lldb.SBError()
    value = process.ReadUnsignedFromMemory(addr, addr_byte_size, error)
    
    if addr == sp:
        sp_marker = "->"
    else:
        sp_marker = "  "
    
    if error.Success():
        print("{} 0x{:x}: 0x{:x}".format(sp_marker, addr, value))
    else:
        print("{} 0x{:x}: Unable to read".format(sp_marker, addr))
