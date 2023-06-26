unit DelphiBooks.Classes;

// TODO : ajouter gestion de la couverture du livre + thumbs
// TODO : récupérer les URL des pages (en export API)
// TODO : gestion des listes (import/export/génération des ID)
interface

uses
  System.Generics.Collections,
  System.JSON;

type
  TDelphiBooksLanguage = class;
  TDelphiBooksLanguagesList = class;
  TDelphiBooksKeyword = class;
  TDelphiBooksKeywordsList = class;
  TDelphiBooksDescription = class;
  TDelphiBooksDescriptionsList = class;
  TDelphiBooksTableOfContent = class;
  TDelphiBooksTableOfContentsList = class;
  TDelphiBooksAuthor = class;
  TDelphiBooksAuthorsList = class;
  TDelphiBooksPublisher = class;
  TDelphiBooksPublishersList = class;
  TDelphiBooksBook = class;
  TDelphiBooksBooksList = class;

  TDelphiBooksClass = class
  private
    FId: integer;
    Fguid: string;
    FPageName: string;
    FDataLevel: integer;
    FDataVersion: integer;
    FHasChanged: boolean;
    FIsPageToBuild: boolean;
    function Getguid: string;
    procedure SetPageName(const Value: string);
  protected
    procedure ValuesChanged;
    function GetFileName: string;
    function GetClassDataVersion: integer; virtual; abstract;
  public
    property Id: integer read FId;
    property Guid: string read Getguid;
    property DataLevel: integer read FDataLevel;
    property hasChanged: boolean read FHasChanged;
    property isPageToBuild: boolean read FIsPageToBuild;
    property PageName: string read FPageName write SetPageName;

    constructor Create; virtual;

    constructor CreateFromRepository(AFolder: string;
      AFileName: string); virtual;

    constructor CreateFromJSON(AJSON: TJSONObject); virtual;

    procedure SaveToRepository(AFolder: string); virtual;

    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; virtual;
  end;

  TDelphiBooksListClass<T: TDelphiBooksClass, constructor> = class(TList<T>)
  private
  protected
  public
    function ToJSONArray(ForDelphiBooksRepository: boolean = false)
      : TJSONArray; virtual;
    // TODO : function FromJSONArray()
  end;

  TDelphiBooksLanguage = class(TDelphiBooksClass)
  private

    const
    CDataVersion = 1;

  var
    FISOCode: string;
    FText: string;

    procedure SetISOCode(const Value: string);
    procedure SetText(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property ISOCode: string read FISOCode write SetISOCode;
    property Text: string read FText write SetText;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
  end;

  TDelphiBooksLanguagesList = class(TDelphiBooksListClass<TDelphiBooksLanguage>)
  end;

  TDelphiBooksKeyword = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FText: string;
    procedure SetText(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property Text: string read FText write SetText;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
  end;

  TDelphiBooksKeywordsList = class(TDelphiBooksListClass<TDelphiBooksKeyword>)
  end;

  TDelphiBooksDescription = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FLanguageISOCode: string;
    FText: string;
    procedure SetLanguageISOCode(const Value: string);
    procedure SetText(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property LanguageISOCode: string read FLanguageISOCode
      write SetLanguageISOCode;
    property Text: string read FText write SetText;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
  end;

  TDelphiBooksDescriptionsList = class
    (TDelphiBooksListClass<TDelphiBooksDescription>)
  end;

  TDelphiBooksTableOfContent = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FLanguageISOCode: string;
    FText: string;
    procedure SetLanguageISOCode(const Value: string);
    procedure SetText(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property LanguageISOCode: string read FLanguageISOCode
      write SetLanguageISOCode;
    property Text: string read FText write SetText;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
  end;

  TDelphiBooksTableOfContentsList = class
    (TDelphiBooksListClass<TDelphiBooksTableOfContent>)
  end;

  TDelphiBooksAuthor = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FLastName: string;
    FPseudo: string;
    Furl: string;
    FFirstName: string;
    FDescriptions: TDelphiBooksDescriptionsList;
    FBooks: TDelphiBooksBooksList;
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetPseudo(const Value: string);
    procedure Seturl(const Value: string);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsList);
    procedure SetBooks(const Value: TDelphiBooksBooksList);
  protected
    function GetClassDataVersion: integer; override;
  public
    property LastName: string read FLastName write SetLastName;
    property FirstName: string read FFirstName write SetFirstName;
    property Pseudo: string read FPseudo write SetPseudo;
    property URL: string read Furl write Seturl;
    property Descriptions: TDelphiBooksDescriptionsList read FDescriptions
      write SetDescriptions;
    property Books: TDelphiBooksBooksList read FBooks write SetBooks;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TDelphiBooksAuthorsList = class(TDelphiBooksListClass<TDelphiBooksAuthor>)
  end;

  TDelphiBooksPublisher = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FBooks: TDelphiBooksBooksList;
    FDescriptions: TDelphiBooksDescriptionsList;
    FCompanyName: string;
    Furl: string;
    procedure SetBooks(const Value: TDelphiBooksBooksList);
    procedure SetCompanyName(const Value: string);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsList);
    procedure Seturl(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property CompanyName: string read FCompanyName write SetCompanyName;
    property URL: string read Furl write Seturl;
    property Descriptions: TDelphiBooksDescriptionsList read FDescriptions
      write SetDescriptions;
    property Books: TDelphiBooksBooksList read FBooks write SetBooks;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TDelphiBooksPublishersList = class
    (TDelphiBooksListClass<TDelphiBooksPublisher>)
  end;

  TDelphiBooksBook = class(TDelphiBooksClass)
  private const
    CDataVersion = 1;

  var
    FTOCs: TDelphiBooksTableOfContentsList;
    FLanguageISOCode: string;
    FPublishedDateYYYYMMDD: string;
    FDescriptions: TDelphiBooksDescriptionsList;
    FTitle: string;
    FISBN13: string;
    FISBN10: string;
    FAuthors: TDelphiBooksAuthorsList;
    Furl: string;
    FPublishers: TDelphiBooksPublishersList;
    procedure SetAuthors(const Value: TDelphiBooksAuthorsList);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsList);
    procedure SetISBN10(const Value: string);
    procedure SetISBN13(const Value: string);
    procedure SetLanguageISOCode(const Value: string);
    procedure SetPublishedDateYYYYMMDD(const Value: string);
    procedure SetPublishers(const Value: TDelphiBooksPublishersList);
    procedure SetTitle(const Value: string);
    procedure SetTOCs(const Value: TDelphiBooksTableOfContentsList);
    procedure Seturl(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property Title: string read FTitle write SetTitle;
    property Descriptions: TDelphiBooksDescriptionsList read FDescriptions
      write SetDescriptions;
    property TOCs: TDelphiBooksTableOfContentsList read FTOCs write SetTOCs;
    property Authors: TDelphiBooksAuthorsList read FAuthors write SetAuthors;
    property Publishers: TDelphiBooksPublishersList read FPublishers
      write SetPublishers;
    property ISBN10: string read FISBN10 write SetISBN10;
    property ISBN13: string read FISBN13 write SetISBN13;
    property LanguageISOCode: string read FLanguageISOCode
      write SetLanguageISOCode;
    property PublishedDateYYYYMMDD: string read FPublishedDateYYYYMMDD
      write SetPublishedDateYYYYMMDD;
    property URL: string read Furl write Seturl;
    constructor CreateFromJSON(AJSON: TJSONObject); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TDelphiBooksBooksList = class(TDelphiBooksListClass<TDelphiBooksBook>)
  end;

implementation

uses
  System.SysUtils,
  System.IOUtils;

{ TDelphiBooksClass }

constructor TDelphiBooksClass.Create;
begin
  inherited;
  FId := -1;
  Fguid := '';
  FPageName := '';
  FDataLevel := 0;
  FDataVersion := GetClassDataVersion;
  FHasChanged := false;
  FIsPageToBuild := false;
end;

constructor TDelphiBooksClass.CreateFromJSON(AJSON: TJSONObject);
begin
  if (not assigned(AJSON)) or (not(AJSON is TJSONObject)) then
    raise exception.Create('JSON Object expected');

  Create;

  if not AJSON.TryGetValue<integer>('dataversion', FDataVersion) then
    FDataVersion := GetClassDataVersion;
  if FDataLevel > GetClassDataVersion then
    raise exception.Create
      ('Can''t load datas with this program. Please update it.');

  if not AJSON.TryGetValue<integer>('id', FId) then
    raise exception.Create('ID not found');

  if not AJSON.TryGetValue<string>('guid', Fguid) then
    Fguid := '';

  if not AJSON.TryGetValue<string>('pagename', FPageName) then
    FPageName := '';

  if not AJSON.TryGetValue<integer>('datalevel', FDataLevel) then
    FDataLevel := 0;

  if not AJSON.TryGetValue<boolean>('id', FIsPageToBuild) then
    FIsPageToBuild := false;
end;

constructor TDelphiBooksClass.CreateFromRepository(AFolder, AFileName: string);
var
  JSO: TJSONObject;
  FilePath: string;
  JSON: string;
begin
  if AFolder.isempty then
    raise exception.Create('Empty folder');

  if AFileName.isempty then
    raise exception.Create('Empty filename');

  FilePath := tpath.combine(AFolder, AFileName);
  if not tfile.Exists(FilePath) then
    raise exception.Create('File "' + FilePath + '" not found');

  JSON := tfile.ReadAllText(FilePath, tencoding.UTF8);
  JSO := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  if not assigned(JSO) then
    raise exception.Create('Wrong file format in "' + FilePath + '"');

  try
    CreateFromJSON(JSO);
  finally
    JSO.Free;
  end;
end;

function TDelphiBooksClass.GetFileName: string;
begin
  if Guid.isempty then
    raise exception.Create('Empty GUID');

  result := Guid + '.dat';
end;

function TDelphiBooksClass.Getguid: string;
var
  i: integer;
  LGuid: string;
begin
  if Fguid.isempty then
  begin
    LGuid := TGUID.NewGuid.ToString;
    for i := 0 to length(LGuid) - 1 do
    begin
      if CharInSet(LGuid.Chars[i], ['0' .. '9', 'A' .. 'Z', 'a' .. 'z']) then
        Fguid := Fguid + LGuid.Chars[i];
    end;
  end;
  result := Fguid;
end;

procedure TDelphiBooksClass.SaveToRepository(AFolder: string);
begin
  if AFolder.isempty then
    raise exception.Create('Empty folder');

  if not tdirectory.Exists(AFolder) then
    raise exception.Create('Folder "' + AFolder + '" doesn''t exists.');

  tfile.WriteAllText(tpath.combine(AFolder, GetFileName),
    ToJSONObject(true).ToJSON, tencoding.UTF8);

  FHasChanged := false;
end;

procedure TDelphiBooksClass.SetPageName(const Value: string);
begin
  FPageName := Value;
  ValuesChanged;
end;

function TDelphiBooksClass.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := TJSONObject.Create;

  if (not ForDelphiBooksRepository) and (FId < 0) then
    raise exception.Create('ID undefined !');

  result.AddPair('id', Id);

  if ForDelphiBooksRepository then
  begin
    result.AddPair('guid', Getguid);
    result.AddPair('pagename', PageName);
    result.AddPair('datalevel', DataLevel);
    result.AddPair('dataversion', GetClassDataVersion);
    result.AddPair('ispagetobuild', isPageToBuild);
  end;
end;

procedure TDelphiBooksClass.ValuesChanged;
begin
  inc(FDataLevel);
  FHasChanged := true;
  FIsPageToBuild := true;
end;

{ TDelphiBooksLanguage }

constructor TDelphiBooksLanguage.Create;
begin
  inherited;
  FISOCode := '';
  FText := '';
end;

constructor TDelphiBooksLanguage.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

function TDelphiBooksLanguage.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksLanguage.SetISOCode(const Value: string);
begin
  FISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksLanguage.SetText(const Value: string);
begin
  FText := Value;
  ValuesChanged;
end;

function TDelphiBooksLanguage.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('iso', ISOCode);
  result.AddPair('text', Text);
end;

{ TDelphiBooksKeyword }

constructor TDelphiBooksKeyword.Create;
begin
  inherited;
  FText := '';
end;

constructor TDelphiBooksKeyword.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

function TDelphiBooksKeyword.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksKeyword.SetText(const Value: string);
begin
  FText := Value;
  ValuesChanged;
end;

function TDelphiBooksKeyword.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('text', Text);
end;

{ TDelphiBooksDescription }

constructor TDelphiBooksDescription.Create;
begin
  inherited;
  FText := '';
  FLanguageISOCode := '';
end;

constructor TDelphiBooksDescription.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

function TDelphiBooksDescription.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksDescription.SetLanguageISOCode(const Value: string);
begin
  FLanguageISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksDescription.SetText(const Value: string);
begin
  FText := Value;
  ValuesChanged;
end;

function TDelphiBooksDescription.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('iso', LanguageISOCode);
  result.AddPair('text', Text);
end;

{ TDelphiBooksTableOfContent }

constructor TDelphiBooksTableOfContent.Create;
begin
  inherited;
  FLanguageISOCode := '';
  FText := '';
end;

constructor TDelphiBooksTableOfContent.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

function TDelphiBooksTableOfContent.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksTableOfContent.SetLanguageISOCode(const Value: string);
begin
  FLanguageISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksTableOfContent.SetText(const Value: string);
begin
  FText := Value;
  ValuesChanged;
end;

function TDelphiBooksTableOfContent.ToJSONObject(ForDelphiBooksRepository
  : boolean): TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('iso', LanguageISOCode);
  result.AddPair('text', Text);
end;

{ TDelphiBooksAuthor }

constructor TDelphiBooksAuthor.Create;
begin
  inherited;
  FLastName := '';
  FPseudo := '';
  Furl := '';
  FFirstName := '';
  FDescriptions := TDelphiBooksDescriptionsList.Create;
  FBooks := TDelphiBooksBooksList.Create;
end;

constructor TDelphiBooksAuthor.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

destructor TDelphiBooksAuthor.Destroy;
begin
  FBooks.Free;
  FDescriptions.Free;
  inherited;
end;

function TDelphiBooksAuthor.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksAuthor.SetBooks(const Value: TDelphiBooksBooksList);
begin
  FBooks := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetDescriptions(const Value
  : TDelphiBooksDescriptionsList);
begin
  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetFirstName(const Value: string);
begin
  FFirstName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetLastName(const Value: string);
begin
  FLastName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetPseudo(const Value: string);
begin
  FPseudo := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.Seturl(const Value: string);
begin
  Furl := Value;
  ValuesChanged;
end;

function TDelphiBooksAuthor.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('lastname', LastName);
  result.AddPair('firstname', FirstName);
  result.AddPair('pseudo', Pseudo);
  result.AddPair('url', URL);
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('books', Books.ToJSONArray(ForDelphiBooksRepository));
end;

{ TDelphiBooksPublisher }

constructor TDelphiBooksPublisher.Create;
begin
  inherited;
  FCompanyName := '';
  Furl := '';
  FDescriptions := TDelphiBooksDescriptionsList.Create;
  FBooks := TDelphiBooksBooksList.Create;
end;

constructor TDelphiBooksPublisher.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  // TODO : à compléter
end;

destructor TDelphiBooksPublisher.Destroy;
begin
  FBooks.Free;
  FDescriptions.Free;
  inherited;
end;

function TDelphiBooksPublisher.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksPublisher.SetBooks(const Value: TDelphiBooksBooksList);
begin
  FBooks := Value;
  ValuesChanged;
end;

procedure TDelphiBooksPublisher.SetCompanyName(const Value: string);
begin
  FCompanyName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksPublisher.SetDescriptions(const Value
  : TDelphiBooksDescriptionsList);
begin
  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksPublisher.Seturl(const Value: string);
begin
  Furl := Value;
  ValuesChanged;
end;

function TDelphiBooksPublisher.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('companyname', CompanyName);
  result.AddPair('url', URL);
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('books', Books.ToJSONArray(ForDelphiBooksRepository));
end;

{ TDelphiBooksBook }

constructor TDelphiBooksBook.Create;
begin
  inherited;
  FTitle := '';
  FISBN13 := '';
  FISBN10 := '';
  Furl := '';
  FLanguageISOCode := '';
  FPublishedDateYYYYMMDD := '00000000';
  FAuthors := TDelphiBooksAuthorsList.Create;
  FDescriptions := TDelphiBooksDescriptionsList.Create;
  FTOCs := TDelphiBooksTableOfContentsList.Create;
  FPublishers := TDelphiBooksPublishersList.Create;
end;

constructor TDelphiBooksBook.CreateFromJSON(AJSON: TJSONObject);
begin
  inherited;
  if not AJSON.TryGetValue<string>('title', FTitle) then
    raise exception.Create('Title not found');
  if not AJSON.TryGetValue<string>('isbn10', FISBN10) then
    raise exception.Create('ISBN 10 (GENCOD) not found');
  if not AJSON.TryGetValue<string>('isbn13', FISBN13) then
    raise exception.Create('ISBN 13 (GENCOD) not found');
  if not AJSON.TryGetValue<string>('url', Furl) then
    raise exception.Create('URL not found');
  if not AJSON.TryGetValue<string>('iso', FLanguageISOCode) then
    raise exception.Create('Language ISO code not found');
  if not AJSON.TryGetValue<string>('pubdate', FPublishedDateYYYYMMDD) then
    raise exception.Create('Published date not found');

  FAuthors := AJSON.GetValue('authors');
  if not assigned(FAuthors) then
    raise exception.Create('Authors list not found');

  FPublishers := AJSON.GetValue('publishers');
  if not assigned(FPublishers) then
    raise exception.Create('Publishers list not found');

  FTOCs := AJSON.GetValue('toc');
  if not assigned(FTOCs) then
    raise exception.Create('TOCs list not found');

  FDescriptions := AJSON.GetValue('descriptions');
  if not assigned(FDescriptions) then
    raise exception.Create('Descriptions list not found');
end;

destructor TDelphiBooksBook.Destroy;
begin
  FAuthors.Free;
  FDescriptions.Free;
  FTOCs.Free;
  FPublishers.Free;
  inherited;
end;

function TDelphiBooksBook.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksBook.SetAuthors(const Value: TDelphiBooksAuthorsList);
begin
  FAuthors := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetDescriptions(const Value
  : TDelphiBooksDescriptionsList);
begin
  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetISBN10(const Value: string);
begin
  FISBN10 := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetISBN13(const Value: string);
begin
  FISBN13 := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetLanguageISOCode(const Value: string);
begin
  FLanguageISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetPublishedDateYYYYMMDD(const Value: string);
begin
  FPublishedDateYYYYMMDD := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetPublishers(const Value
  : TDelphiBooksPublishersList);
begin
  FPublishers := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetTitle(const Value: string);
begin
  FTitle := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetTOCs(const Value
  : TDelphiBooksTableOfContentsList);
begin
  FTOCs := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.Seturl(const Value: string);
begin
  Furl := Value;
  ValuesChanged;
end;

function TDelphiBooksBook.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited ToJSONObject(ForDelphiBooksRepository);
  result.AddPair('title', Title);
  result.AddPair('url', URL);
  result.AddPair('isbn10', ISBN10);
  result.AddPair('isbn13', ISBN13);
  result.AddPair('iso', LanguageISOCode);
  result.AddPair('pubdate', PublishedDateYYYYMMDD);
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('toc', TOCs.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('authors', Authors.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('publishers',
    Publishers.ToJSONArray(ForDelphiBooksRepository));
end;

{ TDelphiBooksListClass<T> }

function TDelphiBooksListClass<T>.ToJSONArray(ForDelphiBooksRepository: boolean)
  : TJSONArray;
var
  item: T;
  JSO: TJSONObject;
begin
  result := TJSONArray.Create;
  if (Count > 0) then
    for item in self do
    begin
      JSO := TJSONObject.Create;
      JSO.AddPair('id', item.Id);
      if ForDelphiBooksRepository then
        JSO.AddPair('guid', item.Guid);
    end;
end;

end.
