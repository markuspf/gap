# PRINT CONSTRUCTORS
This is a prototype implementation of wrapping all global functions
such that the construction objects can be traced back at every point by
calling a function on them.

The output should be valid OpenMath.

## What it can do
It can store the constructors and passed arguments for all functions
that are created at startup.

### How it works
All object creating functions are wrapped such that they store
the constructor and the passed arguments either as attributes
or alternatively in a global dictionary.

The responsible files are `lib/annotateConstructors.gi` and
`lib/printConstructors.gi`  as well as `lib/wrapGlobalFunction.gi`.

All globally bound functions are wrapped using a hard-coded list.

This implementation is obviously extremely inefficient in terms of memory
as all GAP objects ever created at runtime are saved and the storage of
at least the objects in the dictionary (meaning all non-attribute-storing
representations) is never freed. It might be useful to use so called
"weak pointers" at this place.

## What it can't do
This is to be determined by the KWARC group in Bremen, Germany.

## Bugs
There might be some problems with randomly created objects being not
properly reconstructed.

Under certain conditions it has also been observed that an infinite
recursion can occur.

## How to use

Build GAP

    sh autogen.sh
    ./configure
    make

Build io
    make bootstrap-pkg-full
    cd pkg/io-*
    ./configure
    make

Most function are wrapped in the start-up routine. The file
'wrapGlobalFunctions.g' has then to be called in order to wrap global
functions.

    bin/gap.sh

When you then create an object you should ideally see the output by
calling 'MitM_OM' on the respective object.

    gap> G := GroupWithGenerators([(1,2)]);
    Group([ (1,2) ])
    gap> MitM_OM(G);
    "<OMA><OMS cd=\"scscp_transient_mitm\" name=\"GroupWithGenerators\"/><OMA><OMS cd=\"list1\" name=\"list\"/><OMA> <OMS cd=\"permut1\" name=\"permutation\"/> <OMI>2</OMI> <OMI>1</OMI> </OMA></OMA></OMA>"
    gap> T := TransitiveGroup(10,2);
    D(10)=5:2
    gap> MitM_OM(T);
    "<OMA><OMS cd=\"scscp_transient_mitm\" name=\"GroupWithGenerators\"/><OMA><OMS cd=\"list1\" name=\"list\"/><OMA> <OMS cd=\"permut1\" name=\"permutation\"/> <OMI>3</OMI> <OMI>4</OMI> <OMI>5</OMI> <OMI>6</OMI> <OMI>7</OMI> <OMI>8</OMI> <OMI>9</OMI> <OMI>10</OMI> <OMI>1</OMI> <OMI>2</OMI> </OMA><OMA> <OMS cd=\"permut1\" name=\"permutation\"/> <OMI>4</OMI> <OMI>3</OMI> <OMI>2</OMI> <OMI>1</OMI> <OMI>10</OMI> <OMI>9</OMI> <OMI>8</OMI> <OMI>7</OMI> <OMI>6</OMI> <OMI>5</OMI> </OMA></OMA><OMA> <OMS cd=\"permut1\" name=\"permutation\"/> </OMA></OMA>" 
    
