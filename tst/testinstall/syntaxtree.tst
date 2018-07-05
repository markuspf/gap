
#
gap> SYNTAX_TREE(1);
Error, SYNTAX_TREE: <func> must be a plain GAP function
gap> SYNTAX_TREE(\+);
Error, SYNTAX_TREE: <func> must be a plain GAP function
gap> SyntaxTree(1);
Error, SYNTAX_TREE: <func> must be a plain GAP function
gap> SyntaxTree(x -> x);
<syntax tree>
gap> SyntaxTree(\+);
Error, SYNTAX_TREE: <func> must be a plain GAP function

# Just try compiling all functions we can find in the workspace
# to see nothing crashes.
gap> for n in NamesGVars() do
>        if IsBoundGlobal(n) then
>            v := ValueGlobal(n);
>            if IsFunction(v) and not IsKernelFunction(v) then
>                SYNTAX_TREE(v);
>            elif IsOperation(v) then
>                for i in [1..6] do
>                    for x in METHODS_OPERATION(v, i) do
>                        if IsFunction(x) and not IsKernelFunction(v) then
>                        SYNTAX_TREE(x);
>                        fi;
>                    od; 
>                od;
>            fi;
>        fi;
> od;;

#
