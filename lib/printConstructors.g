LoadPackage("Openmath", false);

DeclareOperation("MitM_OM", [IsObject]);

for filter in [IsInt, IsFloat, IsPerm, IsTransformation, IsRationals] do
    InstallMethod(MitM_OM, [filter],
        function(obj)
            return OMString(obj:noomobj); 
        end
    );
od;

InstallMethod(MitM_OM, [IsString],
    function(obj)
        return obj;
    end
);

InstallMethod(MitM_OM, [IsObject],
    function(obj)
        local str, arg, r, cd_name;

        cd_name := "scscp_transient_mitm";

        str := "";

        if (IsList(obj) or IsRecord(obj)) then
            str := "<OMA>";
            if(not(IsString(obj)) and IsList(obj)) then
                str := Concatenation(str, "<OMS cd=\"list1\" name=\"list\"/>");
            else
                str := Concatenation(str, "<OMS cd=\"permut1\" name=\"permutation\"/>");
            fi;
    
            for arg in obj do
                str := Concatenation(str, MitM_OM(arg));
            od;

            str := Concatenation(str, "</OMA>");
        else
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

                for arg in r.args do
                    str := Concatenation(str, MitM_OM(arg));
                od;
                            
                str := Concatenation(str, "</OMA>");
            fi;
        fi;
        
        return str;
    end
);

#g := GroupWithGenerators([(1,2)]);
#Print(MitM_OM(g));
