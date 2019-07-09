##################################################################################
##  											                                      								##
##  PackageInfo.g                     FpGd                   Nisreen Alokbi     ##
##                                                             					        ##
##################################################################################


SetPackageInfo( rec(
                    PackageName    := "FpGd",
                    Subtitle       := "Finitely Presented Groupoid",
                    Version        := "1.0.0",
                    Date           := "01/07/2019",
                    PackageWWWHome := "https://github.com/nalokbi/FpGd",
                    ArchiveURL     := "https://github.com/nalokbi",
                    ArchiveFormats := ".tar.gz",
Persons := [
  rec( 
      LastName      := "Alokbi",
      FirstNames    := "Nisreen",
      IsAuthor      := true,
      IsMaintainer  := true,
      Email         := "N.ALOKBI1@nuigalway.ie",
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

Status         := "deposited",
README_URL     := Concatenation( ~.PackageWWWHome, "README" ),
PackageInfoURL := Concatenation( ~.PackageWWWHome, "PackageInfo.g" ),

AbstractHTML   := 
  "The <span class=\"pkgname\">FpGd</span> package, as its name suggests, \
   is an example of how to create a <span class=\"pkgname\">GAP</span> \
   package. It has little functionality except for being a package, however, \
   it contains an extensive appendix with guidelines for package authors.",

PackageDoc := rec( BookName         := "FpGd",
                   ArchiveURLSubset := ["doc"],
                   HTMLStart        := "doc/chap0.html",
                   PDFFile          := "doc/manual.pdf",
                   SixFile          := "doc/manual.six",
                   LongTitle        := "FpGd/Template of a GAP Package",
                  ),

Dependencies := rec( GAP                    := "4.5.6",
                     NeededOtherPackages    := [["hap", ">=1.1"]],
                     SuggestedOtherPackages := [],
                     ExternalConditions     := []
                    ),


AvailabilityTest := ReturnTrue,

BannerString := Concatenation( 
    "----------------------------------------------------------------\n",
    "Loading  FpGd ", ~.Version, "\n",
    "by ",
    JoinStringsWithSeparator( List( Filtered( ~.Persons, r -> r.IsAuthor ),
                                    r -> Concatenation(
        r.FirstNames, " ", r.LastName, " (", r.WWWHome, ")\n" ) ), "   " ),
    "For help, type: ?FpGd package \n",
    "----------------------------------------------------------------\n" ),


TestFile := "tst/testall.tst",

Keywords := ["General Mapper", "Fp Groupoid", "Free Groupoid", "Fundamental Groupoid"]

));


