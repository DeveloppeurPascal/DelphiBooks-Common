# 20230705 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* add a protected hasNewImage property in TDelphiBooksItem
* add a getImageFileName function in TDelphiBooksItem helper
* don't raise an exception if the 'id' is not in a JSON where it's expected during importing it
* don't save empty properties to json when they have a default value in the load method
* add a SetHasNewImage function in TDelphiBooksItem helper
* increase minimum program level in TDelphiBooksItem (now '20230705')
* add a "parent" property in authors (short)/publishers (short)/books (short)/descriptions/tocs/keywords lists
=> TDelphiBooksList<T: TDelphiBooksItem, constructor> 
=> TDelphiBooksObjectList<T: TDelphiBooksItem, constructor>
* set the "parent" property of lists when creating them attached to an item

* added a SaveItemToRepository() method to save individual items to the repository database
* changed SaveXXXToRepository() (for lists) to use the new SaveItemToRepository() method

* removed isPageToBuild property from DelphiBooks.Classes.pas
* moved GuidToFilename to protected part of its class in DelphiBooks.DB.Repository.pas

* added RebuildBooksListForAuthors method to TDelphiBooksDatabase
* added RebuildBooksListForPublishers method to TDelphiBooksDatabase

* added HasNewImage read only property in TDelphiBooksItem
