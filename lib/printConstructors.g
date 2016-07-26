LoadPackage("Openmath", false);

DeclareOperation("MitM_OM", [IsObject]);

#TODO: refactor
InstallMethod(MitM_OM, [IsObject],
    function(obj)
        local str, arg, r, cd_name;

        cd_name := "scscp_transient_mitm";

        if(IsInt(obj) or IsFloat(obj) or IsPerm(obj)) then return OMString(obj:noomobj); fi;

        str := "";

        if(not(IsString(obj)) and IsList(obj)) then
            str := Concatenation(str, "<OMA><OMS cd=\"list1\" name=\"list\"/>");
    
            for arg in obj do
                str := Concatenation(str, MitM_OM(arg));
            od;

            str := Concatenation(str, "</OMA>");
            return str;
        elif(IsRecord(obj)) then
            str := Concatenation(str, "<OMA><OMS cd=\"permut1\" name=\"permutation\"/>");

            for arg in obj do
                str := Concatenation(str, MitM_OM(arg));
            od;

            str := Concatenation(str, "</OMA>");
            return str;
        fi;


        if(HasMitM_ConstructorInfo(obj)) then
            r := MitM_ConstructorInfo(obj);
        else
            r := LookupDictionary(_GLOBAL_MITM_CONSTRUCTOR_TABLE, obj);
        fi;

        if(r = fail) then
            str := OMString(obj:noomobj);
        else
            str := Concatenation("<OMA><OMS cd=\"", cd_name, "\" name=\"",
                    r.name, "\"/>");

            str := Concatenation(str, MitM_OM(r.args));
                        
            str := Concatenation(str, "</OMA>");
        fi;
        return str;
    end
);

#g := GroupWithGenerators([(1,2)]);
#Print(MitM_OM(g));
