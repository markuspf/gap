
for str in NamesSystemGVars() do
    Print(str, "\n");
    if(IsBoundGlobal(str) and IsFunction(ValueGlobal(str)) and not(str in ["BIND_GLOBAL", "ValueGlobal",
    "MakeReadWriteGlobal", "UnbindGlobal", "wrapper", "str", "temp",
    "Append", "ASS_GVAR"])) then
        if(IsReadOnlyGlobal(str)) then MakeReadWriteGlobal(str); fi;
        temp := ValueGlobal(str);
        UnbindGlobal(str);
        BIND_GLOBAL(str, wrapper(temp, str));
    #    MakeReadOnlyGlobal(str);
    fi;
od;
