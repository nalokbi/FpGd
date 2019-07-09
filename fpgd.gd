#                   GROUPOID

DeclareGlobalFunction( "IdentityGroupoidElm" );
DeclareGlobalFunction( "FpGdProduct" );
DeclareAttribute( "GeneratorsOfGroupoid" , IsFpGdFpGroupoid );
DeclareAttribute( "GeneratorsOfGroupoid" , IsFpGdFreeGroupoid );
DeclareGlobalFunction( "FreeGroupoid" );
DeclareGlobalFunction( "FpGroupoid" );
DeclareGlobalFunction( "RelatorsOfFpGroupoid" );
DeclareGlobalFunction( "FreeGroupoidOfFpGroupoid" );
DeclareOperation( "TreeOfFpGroupoid" , [IsFpGdFpGroupoid, IsInt] );
DeclareOperation( "IdentityFpGroupoidElm" , [IsFpGdFpGroupoid,IsScalar] );
DeclareOperation( "ComponentsOfFpGroupoid" , [IsFpGdFpGroupoid] );
DeclareOperation( "IsConnectedFpGroupoid" , [IsFpGdFpGroupoid] );
DeclareOperation( "RelatorToGroupWord" , [IsFpGdFpGroupoid, IsFpGdFpGroupoidElm, IsInt] );
DeclareOperation( "VertexGroup" , [IsFpGdFpGroupoid, IsInt] );
DeclareOperation( "FundamentalGroupoidOfRegularCWComplex" , [IsHapRegularCWComplex, IsList] );
DeclareGlobalFunction( "UnionOfGroupoids" );
DeclareGlobalFunction( "FpGroupToFpGroupoid" );
DeclareGlobalFunction( "GroupoidMorphismByImages" );
DeclareGlobalFunction("ImageOfArrow");
DeclareGlobalFunction("FundamentalGroupoidOfRegularCWMap");
DeclareOperation( "PushoutOfFpGroupoids" , [IsGroupoidMorphism,IsGroupoidMorphism] );
DeclareGlobalFunction("TestFpGd");




#                   MAPPER

DeclareGlobalFunction("cluster");
DeclareGlobalFunction("FloatSpectrum");
DeclareGlobalFunction("GeneralMapper");
DeclareGlobalFunction("ReadAMCfileAsPatternMatrex");