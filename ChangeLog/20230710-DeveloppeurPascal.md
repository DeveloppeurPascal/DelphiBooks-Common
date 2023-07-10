# 20230710 - [DeveloppeurPascal](https://github.com/DeveloppeurPascal)

* fixed memory usage and freeing instances of JSON elements to avoid memory leaks
* limit the "page name" content type to 128 characters

* increased repository database level => 20230710

* added TDelphiBooksWebPageContent, TDelphiBooksWebPageContentsList and TDelphiBooksWebPageContentsObjectList to manage tranlated content of each web page
* added TDelphiBooksWebPage, TDelphiBooksWebPagesList and TDelphiBooksWebPagesObjectList to manage web pages
* added web pages to load&save for the database repository
* added a SortByPageName() method on items lists
