#############################################################################
##
#W  type.gi                     GAP library
##
##
#Y  Copyright (C) 2016 The GAP Group
##
##  This file implements some additional functions relating to types and
##  families.
##

#############################################################################
##
#M  FiltersType( <type> )
##
##  Return list of filters set in the given type.
##
InstallMethod(FiltersType, "for a type", [ IsType ],
    type -> FILTERS{ TRUES_FLAGS(type![2]) });

#############################################################################
##
#M  FiltersObj( <object> )
##
##  Return list of filters set in the type of <object>.
##
InstallMethod(FiltersObj, "for an object", [ IsObject ],
    obj -> FiltersType(TypeObj(obj)));

#############################################################################
##
#M  NamesFilterShort( flags, max )
##
##  Make a shortened list of filter names for display purposes
##
BindGlobal("NamesFilterShort",
function(flags, max)
    local names;

    names := NamesFilter(flags);
    names := names{[1..Minimum(Length(names), max)]};
    names := JoinStringsWithSeparator(names, ", ");

    if Length(NamesFilter(flags)) > max then
        Append(names, ", ...");
    fi;

    return Concatenation("[ ", names, " ]");
end);

#############################################################################
##
#M  ViewString( <fam> )
##
InstallMethod( ViewString,
    "for a family",
    true,
    [ IsFamily ],
    0,
function(family)
    return STRINGIFY("<Family: \"", family!.NAME, "\">");
end);

#############################################################################
##
#M  DisplayString( <fam> )
##
InstallMethod( DisplayString,
    "for a family",
    true,
    [ IsFamily ],
    0,
function(family)
    local  res, req_flags, imp_flags, fnams;

    res := "";
    Append(res, STRINGIFY("name:\n    ", family!.NAME));
    req_flags := TRUES_FLAGS(family!.REQ_FLAGS);
    fnams := NamesFilter(req_flags);
    fnams := JoinStringsWithSeparator(fnams, "\n    ");
    Append(res, STRINGIFY("\nrequired filters:\n    ", fnams));
    imp_flags := family!.IMP_FLAGS;
    if imp_flags <> [  ]  then
        fnams := NamesFilter(TRUES_FLAGS(imp_flags));
        fnams := JoinStringsWithSeparator(fnams, "\n    ");
        Append(res, STRINGIFY( "\nimplied filters:\n    ", fnams));
    fi;
    return res;
end);

#############################################################################
##
#M  ViewString( <type> )
##
InstallOtherMethod( ViewString,
    "for a type",
    true,
    [ IsType ],
    0,
function ( type )
    local  res, family, flags, data, fnams;

    res := "<Type: (";
    family := type![1];
    Append(res, family!.NAME);
    Append(res, ", ");

    flags := type![2];
    Append(res, NamesFilterShort(flags, 3) );
    Append(res, ")");

    data := type![POS_DATA_TYPE];
    if data <> false  then
        Append(res, STRINGIFY(", data: ", data, "," ) );
    fi;
    Append(res, ">");
    return res;
end);

#############################################################################
##
#M  DisplayString( <type> )
##
InstallOtherMethod( DisplayString,
    "for a type",
    true,
    [ IsType ],
    0,
function ( type )
    local  res, family, flags, data, fnams;

    res := "";
    family := type![1];
    flags := type![2];
    data := type![POS_DATA_TYPE];

    Append(res, STRINGIFY("family:\n    ", family!.NAME));
    if flags <> [  ] or data <> false  then
        fnams := NamesFilter(TRUES_FLAGS(flags));
        fnams := JoinStringsWithSeparator(fnams, "\n    ");
        Append(res, STRINGIFY("\nfilters:\n    ", fnams));
        if data <> false  then
            Append(res, STRINGIFY("\ndata:\n", data ) );
        fi;
    fi;
    return res;
end);

InstallGlobalFunction( IsCategory,
function(object)
    local fid;
    for fid in [1..Length(FILTERS)] do
        if (FILTERS[fid] = object)
           and (INFO_FILTERS[fid] in FNUM_CATS) then
            return true;
        fi;
    od;
    return false;
end);

InstallGlobalFunction( IsAttribute,
function(object)
    local fid;
    for fid in [1..Length(FILTERS)] do
        if (FILTERS[fid] = object)
           and (INFO_FILTERS[fid] in FNUM_ATTS
                # Every property is also an attribute
                or INFO_FILTERS[fid] in FNUM_PROS) then
            return true;
        fi;
    od;
    return false;
end);

InstallGlobalFunction( IsProperty,
function(object)
    local fid;
    for fid in [1..Length(FILTERS)] do
        if (FILTERS[fid] = object)
           and (INFO_FILTERS[fid] in FNUM_PROS) then
            return true;
        fi;
    od;
    return false;
end);

InstallGlobalFunction( CategoryByName,
function(name)
    local fid;

    for fid in CATS_AND_REPS do
        if (INFO_FILTERS[fid] in FNUM_CATS) and
           (NAME_FUNC(FILTERS[fid]) = name) then
            return FILTERS[fid];
        fi;
    od;
    return fail;
end);

InstallGlobalFunction( LocationOfDeclaration,
function(object)
    local fid;
    if IsFilter(object) then
        fid := IdOfFilter(object);
        if fid <> fail then
            if IsBound(FILTERS_LOCATIONS[fid]) then
                return FILTERS_LOCATIONS[fid];
            fi;
        fi;
    fi;
    if IsOperation(object) then
        fid := Position(OPERATIONS, object);
        if fid <> fail then
            if IsBound(OPERATIONS_LOCATIONS[fid + 1]) then
                return OPERATIONS_LOCATIONS[fid + 1];
            fi;
        fi;
    fi;

    fid := PositionProperty(BIND_LOCS, x -> x[1] = NAME_FUNC(object));
    if fid <> fail then
        return BIND_LOCS[fid][2];
    fi;
    return fail;
end);
