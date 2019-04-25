#############################################################################
##
##  PackageInfo.g                FpGd Package                Nisreen Alokbi 
##
#############################################################################

SetPackageInfo( rec(

  PackageName := "FpGd",
  Subtitle  := "Finitely Presented groupoid",
  Version := "1.1",
  Date    := "15/04/2019",
  ArchiveURL 
          := " ",
  ArchiveFormats 
          := " ",


  Persons := [ 
    rec( 
      LastName      := "Alokbi",
      FirstNames    := "Nisreen",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "n.alokbi1@nuigalway.ie",
      WWWHome       := "https://github.com/nalokbi/FpGd",
      PostalAddress := Concatenation( [
                         "Nisreen Alokbi\n",
                         "Mathematics Department\n",
                         "NUI Galway\n",
                         "Galway\n",
                         "Ireland" ] ),
      Place         := "Galway",
      Institution   := "National University of Ireland, Galway"
    )
  ],  

  Status  := " ",
  CommunicatedBy 
          := " ",
  AcceptDate 
          := " ",

  README_URL := "https://github.com/nalokbi/FpGd/README.FPGD",
  PackageInfoURL := "https://github.com/nalokbi/FpGd/PackageInfo.g",

  AbstractHTML := 
    "This package provides some functions for the finitely presented groupoid. ",

  PackageWWWHome := "https://github.com/nalokbi/FpGd/www",
                  
  PackageDoc := rec(
    BookName  := "FpGd",
    ArchiveURLSubset := ["doc", "www"],
    HTMLStart := "www/index.html",
    PDFFile   := "doc/manual.pdf",
    SixFile   := "doc/manual.six",
    LongTitle := "Finitely presented groupoid",
    Autoload := true 
  ),


  Dependencies := rec(
    GAP := ">= 4.5.6",
    NeededOtherPackages := [
                             [ "hap", ">=1.1" ]
                           ],
    SuggestedOtherPackages := [ ],

    ExternalConditions := [ ]
  ),

AvailabilityTest := ReturnTrue,

BannerString     := Concatenation( "Loading FpGd ",
                            String( ~.Version ), " ...\n" ),

Autoload := true,

TestFile := "test/fpgd.tst",

Keywords := [ "free groupoid", "fp groupoid", "vertex group" ]

));

