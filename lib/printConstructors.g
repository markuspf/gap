LoadPackage("Openmath", false);

DeclareOperation("MitM_OM", [IsObject]);

#TODO: refactor
InstallMethod(MitM_OM, [IsObject],
    function(obj)
        local str, arg, r, cd_name;

        cd_name := "scscp_transient_mitm";

        if(IsInt(obj) or IsFloat(obj) or IsPerm(obj)) then return OMString(obj); fi;

        if(HasMitM_ConstructorInfo(obj)) then
            r := MitM_ConstructorInfo(obj);
        else
            r := LookupDictionary(ValueGlobal("_GLOBAL_MITM_CONSTRUCTOR_TABLE"), obj);
        fi;

        if(r = fail) then
            str := OMString(obj);
        else
            str := Concatenation("<OMA><OMS cd=\"", cd_name, "\" name=\"",
                    r.name, "\"/>");

            if(not(IsString(r.args)) and IsList(r.args)) then
                str := Concatenation(str, "<OMA><OMS cd=\"list1\" name=\"list\"/>");
    
                for arg in r.args do
                    str := Concatenation(str, MitM_OM(arg));
                od;

                str := Concatenation(str, "</OMA>");
            elif(IsRecord(r.args)) then
                str := Concatenation(str, "<OMA><OMS cd=\"permut1\" name=\"permutation\"/>");

                for arg in r.args do
                    str := Concatenation(str, MitM_OM(arg));
                od;

                str := Concatenation(str, "</OMA>");
            fi;
            
            str := Concatenation(str, "</OMA>");
        fi;
        return str;
    end
);

#g := GroupWithGenerators([(1,2)]);
#Print(MitM_OM(g));
