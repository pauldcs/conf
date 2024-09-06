import os
import lldb

def __lldb_init_module(debugger, dict):
    fn = os.path.join(os.getcwd(), 'script.lldb')

    if not os.path.isfile(fn):
        return

    with open(fn, 'r') as file:
        lldb.debugger.SetAsync(False)
        for line in file:
            cmd = line.strip()
            if cmd:
                try:
                    lldb.debugger.HandleCommand(cmd)
                except Exception as e:
                    print(
                        f"Error executing command '{cmd}': {e}"
                    )
