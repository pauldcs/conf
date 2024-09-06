import os
import lldb

def __lldb_init_module(debugger, dict):
    srcs_dir = os.path.expanduser("~/Files/conf/lldb/build/")
    
    if not os.path.isdir(srcs_dir):
        print(
            f"error: {srcs_dir} does not exist."
        )
        return
    
    for fn in sorted(os.listdir(srcs_dir)):
        if fn.endswith(".py"):
            src = os.path.join(srcs_dir, fn)
            try:
                lldb.debugger.HandleCommand(
                    f'command script import "{src}"'
                )
            except:
                pass
