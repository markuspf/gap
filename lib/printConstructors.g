LoadPackage("Openmath", false);

DeclareOperation("MitM_OM", [IsObject]);

InstallMethod(MitM_OM, [IsObject],
    function(obj)
        local str, arg, r;

        if(IsInt(obj) or IsFloat(obj)) then return OMString(obj); fi;

        if(HasMitM_ConstructorInfo(obj)) then
            r := MitM_ConstructorInfo(obj);
        else
            r := LookupDictionary(ValueGlobal("_GLOBAL_MITM_CONSTRUCTOR_TABLE"), obj);
        fi;

        if(r = fail) then
            str := Concatenation("\n", OMString(obj), "\n");
        else
            str := "";
            str := Concatenation("<OMOBJ>\n\t<OMS cd='???' name='",
                    r.name, "'/>\n\t\t");

            for arg in r.args do
                str := Concatenation(str, MitM_OM(arg), "\n");
            od;

            str := Concatenation(str, "\n</OMOBJ>");
        fi;
        return str;
    end
);

#g := GroupWithGenerators([(1,2)]);
#Print(MitM_OM(g));
