

#attributes where information about how object was
#constructed is stored
DeclareAttribute("MitM_ConstructorName", IsObject);
DeclareAttribute("MitM_ConstructorArgs", IsObject);

wrapper :=
function( functionToBeCalled )
  return function( arg...)
    local list;
    list := arg{[1..(Length(arg)-1)]};
    Append(list,
    [(function(local_arg...)

      local G;
      G:= CallFuncList(arg[(Length(arg))], (local_arg));

      SetMitM_ConstructorName(G, NameFunction(arg[1]));
      SetMitM_ConstructorArgs(G, local_arg);

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


#DeclareOperation("MitM_OM", [IsObject]);
#
#InstallMethod(MitM_OM, [IsObject],
#    function(obj)
#        local str, arg;
#
#        if(HasMitM_ConstructorName(obj)) then
#            str := Concatenation("<OMOBJ>\n\t<OMS cd='???' name='",
#                    MitM_ConstructorName(obj), "'/>\n\t\t");
#
#            for arg in MitM_ConstructorArgs(obj) do
#                str := Concatenation(str, MitM_OM(arg), "\n");
#            od;
#
#            str := Concatenation(str, "\n</OMOBJ>");
#        else
#            str := Concatenation("\n", OMString(obj), "\n");
#        fi;
#
#        return str;
#    end
#);

