#attributes where information about how object was constructed is stored
DeclareAttribute("MitM_ConstructorInfo", IsObject);

BIND_GLOBAL("_GLOBAL_MITM_CONSTRUCTOR_TABLE", NewDictionary(false, true));

#TODO: remove this from global scope
#TODO: rename variables
loc := function(o)
    local i;
    if IsOperation(o) then
        i := PositionProperty(OPERATIONS, x -> x = o);
        return OPERATIONS_LOCATIONS[i + 1];
    elif IsFunction(o) then
        return rec( file := FILENAME_FUNC(o) );
    else
        return rec();
    fi;
end;

wrapper :=
function( functionToBeCalled, replacedFunction )
    return function( arg...)
        local list;

        list := arg{[1..(Length(arg)-1)]};
        Append(list,
               [(function(local_arg...)
                    local res, r;

                    res := CallFuncListWrap(arg[(Length(arg))], (local_arg));
                    if(Length(res) = 0) then
                        return;
                    fi;
                    res := res[1];

                    r := rec( name := NameFunction(arg[1])
                            , location := loc(arg[1])
                            , args := local_arg);
                    if(IsAttributeStoringRep(res)) then
                        SetMitM_ConstructorInfo(res, r);
                    else
                        AddDictionary(_GLOBAL_MITM_CONSTRUCTOR_TABLE, res, r);
                    fi;

                    return res;
                end)]);
        CallFuncList(functionToBeCalled, list);
    end;
end;

for str in ["InstallMethod", "InstallOtherMethod"] do
    MakeReadWriteGlobal(str);
    temp := ValueGlobal(str);
    UnbindGlobal(str);
    BIND_GLOBAL(str, wrapper(temp, str));
    #    MakeReadOnlyGlobal(str);
od;
