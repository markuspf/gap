#TODO: put this in function, make variables local

#for str in NamesSystemGVars() do
#    if(IsBoundGlobal(str) and IsFunction(ValueGlobal(str)) and
#    not(IsKernelFunction(ValueGlobal(str))) and not(str in ["temp"]))  then
#        funcStr := "";
#        stream := OutputTextString(funcStr, true);
#        PrintTo(stream, ValueGlobal(str));
#        CloseStream(stream);
#        
#        if(not(IS_SUBSTRING(funcStr, "Objectify"))) then
#            continue;
#        fi;
##        Print(funcStr, "\n");
#
#        AppendTo("objectifies.txt", "\"", str, "\", ");

wrapper := function(funcToWrap, str) 
     return (function(local_arg...)
        local res, r;

        res := CallFuncListWrap(funcToWrap, local_arg);
    
        if(Length(res) = 0) then
          return;
        fi;
    
        res := res[1];
        
        r := rec(name := "bla", args := local_arg);
        Print("args: ", local_arg, str, "\n");
        Print(r);
    
        if(IsAttributeStoringRep(res)) then
          SetMitM_ConstructorInfo(res, r);
          Print(MitM_ConstructorInfo(res));
        else
          AddDictionary(_GLOBAL_MITM_CONSTRUCTOR_TABLE, res, r);
        fi;
    
      return res;
    end);
    end;

for str in ["EmptyMatrix"] do  #["ANFAutomorphism", "AbelianNumberFieldByReducedGaloisStabilizerInfo", "ActionHomomorphismConstructor", "AppendTo1", "ArithmeticElementCreator", "AssocBWorLetRepPow", "AssocWWorLetRepPow", "BasisForFreeModuleByNiceBasis", "BasisOfAlgebraModule", "BasisOfMonomialSpace", "BasisOfSparseRowSpace", "BasisOfWeightRepSpace", "BasisWithReplacedLeftModule", "BinaryRelationByListOfImagesNC", "BinaryRelationOnPointsNC", "BlockMatrix", "BlowUpIsomorphism", "CompositionMapping2General", "ConvertToCharacterTableNC",
#"ConvertToLibraryCharacterTableNC", "ConvertToTableOfMarks", "CopyMemory", "CreateKnuthBendixRewritingSystem", "CreateOrderingByLtFunction", "CreateOrderingByLteqFunction", "DenseHashTable", "DictionaryByList", "DictionaryByPosition", "DictionaryBySort", "DoAlgebraicExt", "DoGGMBINC", "DoRightTransversalPc", "ElementNumber_ZmodnZ", "ElmDivRingElm", "ElmTimesRingElm", "EmptyMatrix", "EndoMappingByTransformation", "EnumeratorByFunctions", "EquivalenceRelationByPartition", "EquivalenceRelationByPartitionNC", "EquivalenceRelationByProperty", "ExternalSetByFilterConstructor", "ExternalSetByTypeConstructor", "FGA_FromGeneratorsLetterRep", "FGA_FromGroupWithGenerators",
#"FactorFreeAlgebraByRelators", "FactorFreeGroupByRelators", "FactorFreeMonoidByRelations", "FactorFreeSemigroupByRelations", "FactoredTransversal", "FieldByMatrixBasisNC", "FpLieAlgebraEnumeration", "FreeLieAlgebra", "FreeMagmaRing", "FrobeniusAutomorphismI", "FullMatrixModule", "FullMatrixSpace", "FullRowModule", "FullRowSpace", "GF2IdentityMatrix", "GeneralMappingByElements", "GeneralRestrictedMapping", "GeneratorsOfReesMatrixSemigroupNC", "GeneratorsOfReesZeroMatrixSemigroupNC", "GeneratorsWithMemory", "GroupGeneralMappingByImages_for_pcp", "GroupHomomorphismByFunction", "GroupToAdditiveGroupHomomorphismByFunction", "HomomorphismQuotientSemigroup", "IO_WrapFD", "IdealByGeneratorsForLieAlgebra", "IdealNC", "ImmutableGF2MatrixRep", "InfBits_AssocWord", "InfiniteListOfGenerators", "InfiniteListOfNames", "InputOutputLocalProcess",
#"InputTextNone", "IsDoneIter_LowIndSubs", "IteratorByFunctions", "LAUR_POL_BY_EXTREP", "LR2MagmaCongruenceByGeneratingPairsCAT", "LR2MagmaCongruenceByPartitionNCCAT", "LatticeFromClasses", "LatticeSubgroupsByTom", "LaurentPolynomialByExtRep", "LaurentPolynomialByExtRepNC", "MagmaByMultiplicationTableCreatorNC", "MagmaRingModuloSpanOfZero", "MakeMagmaWithInversesByFiniteGenerators", "MakeMonomialOrdering", "MappingByFunction", "MatSpace", "MatrixSpace", "MutableBasisViaNiceMutableBasisMethod2",
#"MutableBasisViaNiceMutableBasisMethod3", "NewClass", "NewToBeDefinedObj", "NiceMonomorphismAutomGroup", "OutputTextNone", "PadicExtensionNumberFamily", "PartitionBacktrack", "Pcp", "PcpElementConstruction", "PolynomialByExtRepNC", "PresentationAugmentedCosetTable", "PresentationFpGroup", "PrimitiveGroupsIterator", "PrintTo1", "RMSElement", "RationalFunctionByExtRepNC", "ReducedConfluentRwsFromKbrwsNC", "ReesMatrixSemigroupElement", "ReesMatrixSubsemigroupNC", "ReesZeroMatrixSemigroupElement", "ReesZeroMatrixSubsemigroupNC", "RightTransversalPermGroupConstructor", "RingElmTimesElm", "RowSpace", "SHALLOWCOPY_GF2MAT", "ScanBBoxProgram", "ShallowCopy_SingleCollector",
#"SimpleLieAlgebraTypeA_G", "SparseHashTable", "StraightLineDecisionNC", "StraightLineProgElm", "StraightLineProgramNC", "SubFLMLORNC", "SubadditiveGroupNC", "SubadditiveMagmaNC", "SubadditiveMagmaWithInversesNC", "SubadditiveMagmaWithZeroNC", "SubalgebraNC", "SubfieldNC", "Subgroup", "SubgroupByProperty", "SubgroupNC", "SubgroupOfWholeGroupByCosetTable", "SubgroupOfWholeGroupByQuotientSubgroup", "SubgroupShell", "SubmagmaNC", "SubmagmaWithInverses", "SubmagmaWithInversesNC", "SubmagmaWithOneNC", "SubmoduleNC", "SubmonoidNC", "SubnearAdditiveGroupNC", "SubnearAdditiveMagmaNC", "SubnearAdditiveMagmaWithInversesNC", "SubnearAdditiveMagmaWithZeroNC", "SubringWithOneNC", "SubsemigroupNC", "SubspaceNC", "TwoSidedIdealNC", "UNIV_FUNC_BY_EXTREP", "UnivariateRationalFunctionByExtRep", "UnivariateRationalFunctionByExtRepNC", "VectorSearchTable", "WyckoffPositionObject", "ZmodnZepsObj", "_InjectionPrincipalFactor"] do
        if(IsReadOnlyGlobal(str)) then MakeReadWriteGlobal(str); fi;
        #Print(str, "\n");
        temp := ValueGlobal(str);
        UnbindGlobal(str);
        BIND_GLOBAL(str, wrapper(temp, str));
    #    MakeReadOnlyGlobal(str);
#    fi;

#transformation, Permutations, rational numbers -> OMPrint (if there is cd, except for groups), finite field vectors, 
od;
