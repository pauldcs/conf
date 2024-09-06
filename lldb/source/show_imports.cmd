target = debugger.GetSelectedTarget()
for m in target.module_iter():
    print(m)