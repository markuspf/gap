//
// gapinterface.h
//
// Copyright (C) 2017  The GAP Developers.
// For list of the team members, please refer to the COPYRIGHT file.
//
// This package is licensed under the GPL 2 or later, please refer
// to the COPYRIGHT.md and LICENSE files for details.
//
#if !defined(__GAPINTERFACE_H)
#define __GAP_INTERFACE_H

#include "compiled.h"
#include "objects.h"


// Possibly pass a struct of options in here?
// Have separate functions?
int gap_initialize(int argc, char ** argv, char ** environ);
void gap_finalize();

/*
 * API
 *
 * These are the beginnings of an API for the GAP-as-a-library
 */
UInt8 gap_TNumObj(Obj obj)
{
    return TNUM_OBJ(obj);
}

/* We should really be able to extract/transfer BigInts as
   GMP integers */
Obj gap_IntObj_Int(UInt8 val)
{
    return INTOBJ_INT(val);
}
UInt8 gap_Int_IntObj(Obj obj)
{
    return INT_INTOBJ(obj);
}

UInt8 gap_Length_StringObj(Obj str)
{
    return GET_LEN_STRING(str);
};
/* Slightly dodgy, we could provide a function that copies the string
 * to a buffer */
char * gap_String_StringObj(Obj str)
{
    return CSTR_STRING(str);
};
Obj gap_StringObj_String(const char * str, size_t len)
{
    Obj res;
    C_NEW_STRING(res, len, str);
    return res;
}

/* Mhm. what should the API be here? */
Obj gap_NewPermutation()
{
    return 0;
}

/* Records */
Obj gap_NewPRec(UInt cap)
{
    return NEW_PREC(cap);
}

/* Lists */
Obj gap_NewPList(UInt cap)
{
    Obj list;

    list = NEW_PLIST(T_PLIST, cap);
    SET_LEN_PLIST(list, 0);

    return list;
}

UInt gap_GrowPList(Obj list, UInt cap)
{
    GROW_PLIST(list, cap);
}

void gap_ShrinkPList(Obj list, UInt cap)
{
    return SHRINK_PLIST(list, cap);
}

void gap_SetLenPList(Obj list, UInt len)
{
    return SET_LEN_PLIST(list, len);
}

void gap_SetElmPList(Obj list, UInt pos, Obj val)
{
    SET_ELM_PLIST(list, pos, val);
}

Obj gap_ElmPList(Obj list, UInt pos)
{
    return ELM_PLIST(list, pos);
}

Obj gap_ValGVar(const char * name)
{
    UInt varnum = GVarName(name);
    return VAL_GVAR(varnum);
}

/* Executing Functions */
/* It's probably enough to have "CallFuncList" in the API, though
   we might want to circumvent the "overhead" of that in places? */
Obj DoExecFunc0args(Obj func);
Obj DoExecFunc1args(Obj func, Obj arg1);
Obj gap_DoExecFunc0args(Obj func)
{
    return DoExecFunc0args(func);
}

Obj gap_DoExecFunc1args(Obj func, Obj arg1)
{
    return DoExecFunc1args(func, arg1);
}

Obj DoOperation0Args(Obj func);
Obj DoOperation1Args(Obj func, Obj arg1);
Obj gap_DoOperation0args(Obj func)
{
    return DoOperation0Args(func);
}

Obj gap_DoOperation1args(Obj func, Obj arg1)
{
    return DoOperation1Args(func, arg1);
}

Obj gap_CallFuncList(Obj func, Obj list)
{
    return CallFuncList(func, list);
}

void gap_GC_pin(Obj obj)
{
    AddObjSet(gap_GCPins, obj);
}

void gap_GC_unpin(Obj obj)
{
    RemoveObjSet(gap_GCPins, obj);
}

UInt gap_CollectBags(UInt size, UInt full)
{
    return CollectBags(size, full);
}

Obj gap_EvalString(
    char * cmd, char * out, size_t outl, char * err, size_t errl)
{
    gap_start_interaction(cmd);
    gap_enter();
    ReadEvalCommand(STATE(BottomLVars), 0);
    // Note that this prevents
    // any result of eval string from
    // being garbage collected, unless
    // its unpinned
    gap_GC_pin(STATE(ReadEvalResult));

    gap_append_stdout('\0');
    strncpy(out, stdout_buffer, outl);
    gap_append_stderr('\0');
    strncpy(err, stderr_buffer, errl);

    gap_exit();
    gap_finish_interaction();

    return STATE(ReadEvalResult);
}

#endif
