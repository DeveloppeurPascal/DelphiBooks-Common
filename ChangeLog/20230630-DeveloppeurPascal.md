# 20230630 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* fixed the User link in previous change log files
* changed the TDelphiBooksKeyword class to force ID and URL
* added a language object and list(s) class(es) in DelphiBooks.Classes.pas
* updated the DelphiBooks.DB.Repository.pas unit to manage the Languages in the database
* upgraded the repository and object model version to "20230630"

* added a function TDelphiBooksObjectList<T>.GetMaxID to fill the unknown IDs (for new objects)
* added a function TDelphiBooksList<T>.GetMaxID to fill the unknown IDs (for new objects)
* added a ToString function in all objects of the memory database
* unset FHasChanged in objects when using the CreateFromRepository() method

* fixed the setID() helper method by setting the forgotten FHasChanged to true
* updated the db storrage file extension ('json' => '.json')
* added thumb image files extension as a public constant
