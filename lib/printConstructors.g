LoadPackage("Openmath", false);

#custom lookup function for dictionary
#uses different comparison than library function
DeclareOperation("MitM_LookupDictionary", [IsListLookupDictionary, IsObject]);
InstallMethod(MitM_LookupDictionary,"for list dictionaries",true,
  [IsListLookupDictionary,IsObject],0,
function(d,x)
    local p;
    for p in d!.entries do
        if IsIdenticalObj(p[1], x) then
            return p[2];
        fi;
    od;
    return fail;
end);

DeclareOperation("MitM_OM", [IsObject]);

for filter in [IsInt, IsFloat, IsPerm, IsTransformation, IsRationals, IsFFE] do
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
        #TODO: EMPTYMATRIX SHOULDN'T BE LIST, SHOULD BE LOOKED UP FIRST
        if(HasMitM_ConstructorInfo(obj)) then
            r := MitM_ConstructorInfo(obj);
        else
            #MitM_
            r := MitM_LookupDictionary(_GLOBAL_MITM_CONSTRUCTOR_TABLE, obj);
        fi;

        if(r = fail and (IsList(obj) or IsRecord(obj))) then
            str := "<OMA>";

            if(IsList(obj)) then
                str := Concatenation(str, "<OMS cd=\"list1\" name=\"list\"/>");
            else
                str := Concatenation(str, "<OMS cd=\"permut1\" name=\"permutation\"/>");
            fi;
    
            for arg in obj do
                str := Concatenation(str, MitM_OM(arg));
            od;
    
            str := Concatenation(str, "</OMA>");
        elif(r = fail) then
            str := OMString(obj:noomobj);
        else
            str := Concatenation("<OMA><OMS cd=\"", cd_name, "\" name=\"",
                    r.name, "\"/>");

            for arg in r.args do
                str := Concatenation(str, MitM_OM(arg));
            od;
                        
            str := Concatenation(str, "</OMA>");
        fi;
        
        return str;
    end
);

#g := GroupWithGenerators([(1,2)]);
#Print(MitM_OM(g));
