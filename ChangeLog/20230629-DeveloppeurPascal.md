# 20230629 - [DeveloppeurPascal](DeveloppeurPascal)

* moved the FID and FHasChanged properties from private to protected bloc of class TDelphiBooksItem
* add boolean hasId() method to check if an object has an ID (description & TOC don't)
* add boolean hasURL() method to check if an object has a Delphi-Books.com url (description & TOC don't)
* fixed ToJSON export for books keywords (was a second 'descriptions' property in the JSON)
* changed JSON export format to add line feed before each property (better than only one string for GIT database and COMMIT of changes)

* added the helper class TDelphiBooksItemHelper for changing read only FID and FHasChanged properties from TDelphiBooksItem in the DBAdmin and WSBuilder programs
* unset HasChanged property of items when the objects are saved in repository database format
* fixed GuidToFilename() method : the result was empty
* fixed SaveToRepository() method : the folder used was not the 'datas' subfolder
