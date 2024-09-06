CYAN = "\033[36m"
LIGHT_GREY = "\033[90m"
RESET = "\033[0m"

args = command.split()
target = debugger.GetSelectedTarget()
process = target.GetProcess()

if not args:
    result.SetError("Please provide an address")
    return

try:
    addr = process.GetSelectedThread().GetFrameAtIndex(0).EvaluateExpression(args[0]).GetValueAsUnsigned()
    length = int(args[1], 0) if len(args) > 1 else 64

except ValueError:
    result.SetError("Invalid address")
    return

target = debugger.GetSelectedTarget()
error = lldb.SBError()
memory = target.ReadMemory(lldb.SBAddress(addr, target), length, error)

if error.Fail():
    result.SetError(f"Failed to read memory: {error.GetCString()}")
    return

for i in range(0, len(memory), 16):
    chunk = memory[i:i+16]
    
    hex_dump = ''
    for b in chunk:
        if 32 <= b < 127:
            hex_dump += f"{CYAN}{b:02x}{RESET} "
        elif b == 0:
            hex_dump += f"{LIGHT_GREY}..{RESET} "
        else:
            hex_dump += f"{b:02x} "

    ascii_dump = ''.join(chr(b) if 32 <= b < 127 else '.' for b in chunk)
    result.AppendMessage(f" 0x{addr+i:08x}  {hex_dump:<47} {ascii_dump}")
