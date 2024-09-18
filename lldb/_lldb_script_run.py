import os
import re
import lldb

class AutoRun:
    def __init__(self, debugger):
        self.debugger = debugger
        self.variables = {}
        self.target_name = self._get_target_name()
        
        debugger.SetAsync(False)

    def _get_target_name(self):
        target = self.debugger.GetSelectedTarget()
        return target.GetExecutable().GetFilename() if target else None

    def run(self):
        auto_run_file = os.path.join(os.getcwd(), '.auto-run.lldb')
        if not os.path.isfile(auto_run_file):
            return

        with open(auto_run_file, 'r') as file:
            content = file.read().strip()

        if content.lower().startswith("disabled"):
            print("(auto-run): disabled")
            return

        commands = self._parse_commands(content)
        if not commands:
            return

        for cmd in commands:
            print("(auto-run):", cmd)
            self.debugger.HandleCommand(cmd)

    def _parse_commands(self, content):
        lines = content.splitlines()
        commands = []

        for line in lines:
            line = line.strip()
            if not line or line.startswith('#'):
                continue

            if '=' in line and not line.startswith('settings set'):
                var, value = line.split('=', 1)
                self.variables[var.strip()] = value.strip()
                continue

            for var, value in self.variables.items():
                line = line.replace(f"${var}", value)

            commands.append(line)

        return commands

def __lldb_init_module(debugger, _):
    auto_run = AutoRun(debugger)
    auto_run.run()
