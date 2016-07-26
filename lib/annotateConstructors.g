#attributes where information about how object was constructed is stored
DeclareAttribute("MitM_ConstructorInfo", IsObject);

BIND_GLOBAL("_GLOBAL_MITM_CONSTRUCTOR_TABLE", NewDictionary(false, true));

#TODO: remove this from global scope
#TODO: rename variables
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
        
        if(replacedFunction = "InstallGlobalFunction") then
            r := rec(name := "", args := local_arg);
        else
            r := rec(name := NameFunction(arg[1]), args := local_arg);
        fi;
    
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

for str in ["InstallMethod", "InstallOtherMethod",
    "InstallGlobalFunction"] do 
    MakeReadWriteGlobal(str);
    temp := ValueGlobal(str);
    UnbindGlobal(str);
    BIND_GLOBAL(str, wrapper(temp, str));
#    MakeReadOnlyGlobal(str);
od;
