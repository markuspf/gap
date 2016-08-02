#PRINT CONSTRUCTORS
This is a prototype implementation of wrapping all global functions
such that the construction objects can be traced back at every point by
calling a function on them.

The output should be valid OpenMath.

##What it can do
It can store the constructors and passed arguments for all functions
that are created at startup.

###How it works
All object creating functions are wrapped such that they store
the constructor and the passed arguments either as attributes
or alternatively in a global dictionary.

The responsible files are `lib/annotateConstructors.gi` and
`lib/printConstructors.gi`  as well as `wrapGlobalFunction.g`.

All globally bound functions are wrapped using a hard-coded list.

This implementation is obviously extremely inefficient in terms of memory
as all GAP objects ever created at runtime are saved and the storage of
at least the objects in the dictionary (meaning all non-attribute-storing
representations) is never freed. It might be useful to use so called
"weak pointers" at this place.

##What it can't do
This is to be determined by the KWARC group in Bremen, Germany.

##Bugs
There might be some problems with randomly created objects being not
properly reconstructed.

Under certain conditions it has also been observed that an infinite
recursion can occur.

##How to use
First of all you should make sure that GAP is compiled using the version
on the current branch as the non-finalised CallFuncListWrap-function is
being used.

    ./make

Most function are wrapped in the start-up routine. The file
'wrapGlobalFunctions.g' has then to be called in order to wrap global
functions.

    bin/gap.sh
    gap> Read("wrapGlobalFunctions.g");

When you then create an object you should ideally see the output by
calling 'MitM_OM' on the respective object.

    gap> obj := GroupWithGenerators([(1,2)]);
    gap> MitM_OM(obj);
