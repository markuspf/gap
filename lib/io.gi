##
##  Copyright (C)  1996,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##  (C) 1998 School Math and Comp. Sci., University of St Andrews, Scotland
##  Copyright (C) 2002 The GAP Group
##
##  This software is licensed under the GPL 2 or later, please refer
##  to the COPYRIGHT.md and LICENSE files for details.
##

InstallMethod( ViewString, "for an output file container",
               [ IsOutputFileContainer ],
function(out)
    return "<output file container>";
end);

InstallMethod( ViewString, "for an input file container",
               [ IsInputFileContainer ],
function(out)
    return "<input file container>";
end);

InstallGlobalFunction(DoWithOutput,
function(output, cont)
    local oldoutput, result;

    oldoutput := SAVE_OUTPUT();
    RESTORE_OUTPUT(output);
    result := cont();
    RESTORE_OUTPUT(oldoutput);

    return result;
end);

InstallGlobalFunction(DoWithInput,
function(input, cont)
    local oldinput, result;

    oldinput := SAVE_INPUT();
    RESTORE_INPUT(input);
    result := cont();
    RESTORE_INPUT(oldinput);

    return result;
end);

InstallGlobalFunction(DoWithInputAndOutput,
function(input, output, cont)
    local oldinput, oldoutput, result;
    oldinput := SAVE_INPUT();
    RESTORE_INPUT(input);
    oldoutput := SAVE_OUTPUT();
    RESTORE_OUTPUT(output);
    result := cont();
    RESTORE_OUTPUT(oldoutput);
    RESTORE_INPUT(oldinput);
    return result;
end);

