##
##  Copyright (C)  1996,  Lehrstuhl D für Mathematik,  RWTH Aachen,  Germany
##  (C) 1998 School Math and Comp. Sci., University of St Andrews, Scotland
##  Copyright (C) 2002 The GAP Group
##
##  This software is licensed under the GPL 2 or later, please refer
##  to the COPYRIGHT.md and LICENSE files for details.
##

BIND_GLOBAL("IO_OBJ_FAMILY", NewFamily("IO_OBJ_FAMILY"));

DeclareCategory("IsInputFileContainer", IsObject);
DeclareCategory("IsOutputFileContainer", IsObject);

BIND_GLOBAL( "TYPE_OUTPUT_FILE_CONTAINER",
            NewType(IO_OBJ_FAMILY, IsOutputFileContainer));
BIND_GLOBAL( "TYPE_INPUT_FILE_CONTAINER",
            NewType(IO_OBJ_FAMILY, IsInputFileContainer));


