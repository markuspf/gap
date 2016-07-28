#TODO: put this in function, make variables local

for str in NamesSystemGVars() do
    if(IsBoundGlobal(str) and IsFunction(ValueGlobal(str)) and
    not(IsKernelFunction(ValueGlobal(str))))  then
        funcStr := "";
        stream := OutputTextString(funcStr, true);
        PrintTo(stream, ValueGlobal(str));
        CloseStream(stream);
        
        if(not(IS_SUBSTRING(funcStr, "Objectify"))) then
            continue;
        fi;
        #Print(funcStr, "\n");

        if(IsReadOnlyGlobal(str)) then MakeReadWriteGlobal(str); fi;
        temp := ValueGlobal(str);
        UnbindGlobal(str);
        BIND_GLOBAL(str, wrapper(temp, str));
    #    MakeReadOnlyGlobal(str);
    fi;

#transformation, Permutations, rational numbers -> OMPrint (if there is cd, except for groups), finite field vectors, 
#create custom dictionary or use orb gap package (probably loaded too late)
od;
