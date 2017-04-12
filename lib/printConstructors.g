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
        end);
od;

InstallMethod(MitM_OM, [IsString],
    function(obj)
        return obj;
    end
);

BindGlobal("MitM_CDBase", "http://gap-system.org/lib");
BindGlobal("MitM_ExtractCD",
function(file)
    local p1, p2, cd;

    p1 := Positions(file, '/');
    p1 := p1[Length(p1)] + 1;

    p2 := Positions(cd, '.');
    p2 := p2[Length(p2)];

    return file{[p1..p2]};
end);

InstallMethod(MitM_OM, [IsObject],
    function(obj)
        local str, arg, r, cd;

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
            cd := MitM_ExtractCD(r.filename_func);
            str := Concatenation("<OMA><OMS cd_base=\"", MitM_CDBase, "\""
                                 , " cd=\"", cd, "\" name=\"", r.name, "\"/>");

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
