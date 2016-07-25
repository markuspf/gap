#attributes where information about how object was constructed is stored
DeclareAttribute("MitM_ConstructorInfo", IsObject);

BIND_GLOBAL("_GLOBAL_MITM_CONSTRUCTOR_TABLE", NewDictionary(false, true));

wrapper :=
function( functionToBeCalled )
  return function( arg...)
    local list;
    list := arg{[1..(Length(arg)-1)]};
    Append(list,
    [(function(local_arg...)

      local G, r;
      G:= CallFuncListWrap(arg[(Length(arg))], (local_arg));

      if(Length(G) = 0) then
        return;
      fi;

      G := G[1];
      r := rec(name := NameFunction(arg[1]), args := local_arg);

      if(IsAttributeStoringRep(G)) then
        SetMitM_ConstructorInfo(G, r);
      else
        AddDictionary(ValueGlobal("_GLOBAL_MITM_CONSTRUCTOR_TABLE"), G, r);
      fi;

      return G;
    end)]);
    CallFuncList(functionToBeCalled, list);
  end;
end;


MakeReadWriteGlobal("InstallMethod");
temp := InstallMethod;
UnbindGlobal("InstallMethod");
BIND_GLOBAL("InstallMethod", wrapper(temp));
MakeReadOnlyGlobal("InstallMethod");
