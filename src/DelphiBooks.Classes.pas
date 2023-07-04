unit DelphiBooks.Classes;

// TODO : sur authors, écraser champ "name" de l'objet short par PublicName sur la version complete
// TODO : add something to get covers and thumbs files for books
interface

uses
  System.Generics.Collections,
  System.JSON;

const
  CDelphiBooksNullID = -1;

type
  TDelphiBooksItem = class
  private
    Fguid: string;
    FPageName: string;
    FDataLevel: integer;
    FDataVersion: integer;
    FIsPageToBuild: boolean;
    FURL: string;
    function Getguid: string;
    procedure SetPageName(const Value: string);
    procedure SetURL(const Value: string);
  protected
    FId: integer;
    FHasChanged: boolean;
    procedure ValuesChanged;
    function GetClassDataVersion: integer; virtual; abstract;
    function hasID: boolean; virtual;
    function hasURL: boolean; virtual;
  public
    property Id: integer read FId;
    property URL: string read FURL write SetURL;

    property Guid: string read Getguid;
    property DataLevel: integer read FDataLevel;
    property hasChanged: boolean read FHasChanged;
    property isPageToBuild: boolean read FIsPageToBuild;
    property PageName: string read FPageName write SetPageName;

    constructor Create; virtual;

    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); virtual;

    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; virtual;

    function ToString: string; override;
  end;

  TDelphiBooksList<T: TDelphiBooksItem, constructor> = class(TList<T>)
  private
  protected
  public
    function ToJSONArray(ForDelphiBooksRepository: boolean = false)
      : TJSONArray; virtual;
    constructor CreateFromJSON(AJSON: TJSONArray;
      AFromRepository: boolean = false); virtual;
    function GetItemByID(AID: integer): T;
    function GetItemByGUID(AGuid: string): T;
    function GetMaxID: integer;
    procedure SortById;
    procedure SortByIdDesc;
  end;

  TDelphiBooksObjectList<T: TDelphiBooksItem, constructor> = class
    (TObjectList<T>)
  private
  protected
  public
    function ToJSONArray(ForDelphiBooksRepository: boolean = false)
      : TJSONArray; virtual;
    constructor CreateFromJSON(AJSON: TJSONArray;
      AFromRepository: boolean = false); virtual;
    function GetItemByID(AID: integer): T;
    function GetItemByGUID(AGuid: string): T;
    function GetMaxID: integer;
    procedure SortById;
    procedure SortByIdDesc;
  end;

  TDelphiBooksTextItem = class(TDelphiBooksItem)
  private const
    CDataVersion = 1;

  var
    FText: string;
    FLanguageISOCode: string;
    procedure SetLanguageISOCode(const Value: string);
    procedure SetText(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
    function hasID: boolean; override;
    function hasURL: boolean; override;
  public
    property LanguageISOCode: string read FLanguageISOCode
      write SetLanguageISOCode;
    property Text: string read FText write SetText;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    function ToString: string; override;
  end;

  TDelphiBooksTextItemsList<T: TDelphiBooksTextItem, constructor> = class
    (TDelphiBooksList<T>)
  private
  protected
  public
    function GetItemByLanguage(AISOCode: string; AText: string = ''): T;
    function GetItemByText(AText: string): T;
  end;

  TDelphiBooksTextItemsObjectList<T: TDelphiBooksTextItem, constructor> = class
    (TDelphiBooksObjectList<T>)
  private
  protected
  public
    function GetItemByLanguage(AISOCode: string; AText: string = ''): T;
    function GetItemByText(AText: string): T;
  end;

  TDelphiBooksKeyword = class(TDelphiBooksTextItem)
  private
  protected
    // TODO : export keywords as a new table
    function hasID: boolean; override;
    function hasURL: boolean; override;
  public
  end;

  TDelphiBooksKeywordsList = class
    (TDelphiBooksTextItemsList<TDelphiBooksKeyword>)
  public
    procedure SortByText;
    procedure SortByISOCode;
  end;

  TDelphiBooksKeywordsObjectList = class
    (TDelphiBooksTextItemsObjectList<TDelphiBooksKeyword>)
  public
    procedure SortByText;
    procedure SortByISOCode;
  end;

  TDelphiBooksDescription = class(TDelphiBooksTextItem)
  end;

  TDelphiBooksDescriptionsList = class
    (TDelphiBooksTextItemsList<TDelphiBooksDescription>)
  public
    procedure SortByISOCode;
  end;

  TDelphiBooksDescriptionsObjectList = class
    (TDelphiBooksTextItemsObjectList<TDelphiBooksDescription>)
  public
    procedure SortByISOCode;
  end;

  TDelphiBooksTableOfContent = class(TDelphiBooksTextItem)
  end;

  TDelphiBooksTableOfContentsList = class
    (TDelphiBooksTextItemsList<TDelphiBooksTableOfContent>)
  public
    procedure SortByISOCode;
  end;

  TDelphiBooksTableOfContentsObjectList = class
    (TDelphiBooksTextItemsObjectList<TDelphiBooksTableOfContent>)
  public
    procedure SortByISOCode;
  end;

  TDelphiBooksLanguage = class(TDelphiBooksTextItem)
  private
  protected
    function hasID: boolean; override;
    function hasURL: boolean; override;
  public
  end;

  TDelphiBooksLanguagesList = class
    (TDelphiBooksTextItemsList<TDelphiBooksLanguage>)
  public
    procedure SortByText;
    procedure SortByISOCode;
  end;

  TDelphiBooksLanguagesObjectList = class
    (TDelphiBooksTextItemsObjectList<TDelphiBooksLanguage>)
  public
    procedure SortByText;
    procedure SortByISOCode;
  end;

  TDelphiBooksAuthorShort = class(TDelphiBooksItem)
  private const
    CDataVersion = 1;

  var
    FName: string;
    procedure SetName(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property Name: string read FName write SetName;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToString: string; override;
  end;

  TDelphiBooksAuthorShortsList = class
    (TDelphiBooksList<TDelphiBooksAuthorShort>)
  private
  protected
  public
    procedure SortByName;
  end;

  TDelphiBooksAuthorShortsObjectList = class
    (TDelphiBooksObjectList<TDelphiBooksAuthorShort>)
  private
  protected
  public
    procedure SortByName;
  end;

  TDelphiBooksBookShortsObjectList = class;

  TDelphiBooksAuthor = class(TDelphiBooksAuthorShort)
  private const
    CDataVersion = 1;
    function GetPublicName: string;

  var
    FLastName: string;
    FBooks: TDelphiBooksBookShortsObjectList;
    FDescriptions: TDelphiBooksDescriptionsObjectList;
    FPseudo: string;
    FWebSiteURL: string;
    FFirstName: string;
    procedure SetBooks(const Value: TDelphiBooksBookShortsObjectList);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsObjectList);
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetPseudo(const Value: string);
    procedure SetWebSiteURL(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property LastName: string read FLastName write SetLastName;
    property FirstName: string read FFirstName write SetFirstName;
    property Pseudo: string read FPseudo write SetPseudo;
    property PublicName: string read GetPublicName;
    property WebSiteURL: string read FWebSiteURL write SetWebSiteURL;
    property Descriptions: TDelphiBooksDescriptionsObjectList read FDescriptions
      write SetDescriptions;
    property Books: TDelphiBooksBookShortsObjectList read FBooks write SetBooks;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
    function ToString: string; override;
  end;

  TDelphiBooksAuthorsList = class(TDelphiBooksList<TDelphiBooksAuthor>)
  private
  protected
  public
    procedure SortByName;
  end;

  TDelphiBooksAuthorsObjectList = class
    (TDelphiBooksObjectList<TDelphiBooksAuthor>)
  private
  protected
  public
    procedure SortByName;
  end;

  TDelphiBooksPublisherShort = class(TDelphiBooksItem)
  private const
    CDataVersion = 1;

  var
    FCompanyName: string;
    procedure SetCompanyName(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property CompanyName: string read FCompanyName write SetCompanyName;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToString: string; override;
  end;

  TDelphiBooksPublisherShortsList = class
    (TDelphiBooksList<TDelphiBooksPublisherShort>)
  private
  protected
  public
    procedure SortByCompanyName;
  end;

  TDelphiBooksPublisherShortsObjectList = class
    (TDelphiBooksObjectList<TDelphiBooksPublisherShort>)
  private
  protected
  public
    procedure SortByCompanyName;
  end;

  TDelphiBooksPublisher = class(TDelphiBooksPublisherShort)
  private const
    CDataVersion = 1;

  var
    FBooks: TDelphiBooksBookShortsObjectList;
    FDescriptions: TDelphiBooksDescriptionsObjectList;
    FWebSiteURL: string;
    procedure SetBooks(const Value: TDelphiBooksBookShortsObjectList);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsObjectList);
    procedure SetWebSiteURL(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property WebSiteURL: string read FWebSiteURL write SetWebSiteURL;
    property Descriptions: TDelphiBooksDescriptionsObjectList read FDescriptions
      write SetDescriptions;
    property Books: TDelphiBooksBookShortsObjectList read FBooks write SetBooks;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TDelphiBooksPublishersList = class(TDelphiBooksList<TDelphiBooksPublisher>)
  public
    procedure SortByCompanyName;
  end;

  TDelphiBooksPublishersObjectList = class
    (TDelphiBooksObjectList<TDelphiBooksPublisher>)
  public
    procedure SortByCompanyName;
  end;

  TDelphiBooksBookShort = class(TDelphiBooksItem)
  private const
    CDataVersion = 1;

  var
    FLanguageISOCode: string;
    FPublishedDateYYYYMMDD: string;
    FTitle: string;
    FCoverThumbURL: string;
    procedure SetLanguageISOCode(const Value: string);
    procedure SetPublishedDateYYYYMMDD(const Value: string);
    procedure SetTitle(const Value: string);
    procedure SetCoverThumbURL(const Value: string);
    function GetPublishedDateYYYY: string;
    function GetPublishedDateYYYYMM: string;
  protected
    function GetClassDataVersion: integer; override;
  public
    property Title: string read FTitle write SetTitle;
    property LanguageISOCode: string read FLanguageISOCode
      write SetLanguageISOCode;
    property PublishedDateYYYYMMDD: string read FPublishedDateYYYYMMDD
      write SetPublishedDateYYYYMMDD;
    property PublishedDateYYYYMM: string read GetPublishedDateYYYYMM;
    property PublishedDateYYYY: string read GetPublishedDateYYYY;
    property CoverThumbURL: string read FCoverThumbURL write SetCoverThumbURL;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToString: string; override;
  end;

  TDelphiBooksBookShortsList = class(TDelphiBooksList<TDelphiBooksBookShort>)
  private
  protected
  public
    procedure SortByTitle;
    procedure SortByPublishedDate;
    procedure SortByPublishedDateDesc;
  end;

  TDelphiBooksBookShortsObjectList = class
    (TDelphiBooksObjectList<TDelphiBooksBookShort>)
  private
  protected
  public
    procedure SortByTitle;
    procedure SortByPublishedDate;
    procedure SortByPublishedDateDesc;
  end;

  TDelphiBooksBook = class(TDelphiBooksBookShort)
  private const
    CDataVersion = 1;

  var
    FTOCs: TDelphiBooksTableOfContentsObjectList;
    FCover200pxWidthURL: string;
    FCover300pxWidthURL: string;
    FCover100pxWidthURL: string;
    FCoverURL: string;
    FCover400pxWidthURL: string;
    FCover500pxWidthURL: string;
    FCover150pxWidthURL: string;
    FDescriptions: TDelphiBooksDescriptionsObjectList;
    FWebSiteURL: string;
    FCover200pxHeightURL: string;
    FCover300pxHeightURL: string;
    FISBN13: string;
    FCover100pxHeightURL: string;
    FISBN10: string;
    FCover200pxSquareURL: string;
    FCover130x110pxURL: string;
    FCover300pxSquareURL: string;
    FAuthors: TDelphiBooksAuthorShortsObjectList;
    FCover400pxHeightURL: string;
    FCover100pxSquareURL: string;
    FCover500pxHeightURL: string;
    FPublishers: TDelphiBooksPublisherShortsObjectList;
    FKeywords: TDelphiBooksKeywordsObjectList;
    FCover400pxSquareURL: string;
    FCover500pxSquareURL: string;
    procedure SetAuthors(const Value: TDelphiBooksAuthorShortsObjectList);
    procedure SetCover100pxHeightURL(const Value: string);
    procedure SetCover100pxSquareURL(const Value: string);
    procedure SetCover100pxWidthURL(const Value: string);
    procedure SetCover130x110pxURL(const Value: string);
    procedure SetCover150pxWidthURL(const Value: string);
    procedure SetCover200pxHeightURL(const Value: string);
    procedure SetCover200pxSquareURL(const Value: string);
    procedure SetCover200pxWidthURL(const Value: string);
    procedure SetCover300pxHeightURL(const Value: string);
    procedure SetCover300pxSquareURL(const Value: string);
    procedure SetCover300pxWidthURL(const Value: string);
    procedure SetCover400pxHeightURL(const Value: string);
    procedure SetCover400pxSquareURL(const Value: string);
    procedure SetCover400pxWidthURL(const Value: string);
    procedure SetCover500pxHeightURL(const Value: string);
    procedure SetCover500pxSquareURL(const Value: string);
    procedure SetCover500pxWidthURL(const Value: string);
    procedure SetCoverURL(const Value: string);
    procedure SetDescriptions(const Value: TDelphiBooksDescriptionsObjectList);
    procedure SetISBN10(const Value: string);
    procedure SetISBN13(const Value: string);
    procedure SetKeywords(const Value: TDelphiBooksKeywordsObjectList);
    procedure SetPublishers(const Value: TDelphiBooksPublisherShortsObjectList);
    procedure SetTOCs(const Value: TDelphiBooksTableOfContentsObjectList);
    procedure SetWebSiteURL(const Value: string);
  protected
    function GetClassDataVersion: integer; override;
  public
    property Descriptions: TDelphiBooksDescriptionsObjectList read FDescriptions
      write SetDescriptions;
    property TOCs: TDelphiBooksTableOfContentsObjectList read FTOCs
      write SetTOCs;
    property Keywords: TDelphiBooksKeywordsObjectList read FKeywords
      write SetKeywords;
    property Authors: TDelphiBooksAuthorShortsObjectList read FAuthors
      write SetAuthors;
    property Publishers: TDelphiBooksPublisherShortsObjectList read FPublishers
      write SetPublishers;
    property ISBN10: string read FISBN10 write SetISBN10;
    property ISBN13: string read FISBN13 write SetISBN13;
    property WebSiteURL: string read FWebSiteURL write SetWebSiteURL;
    property CoverURL: string read FCoverURL write SetCoverURL;
    property Cover100pxWidthURL: string read FCover100pxWidthURL
      write SetCover100pxWidthURL;
    property Cover150pxWidthURL: string read FCover150pxWidthURL
      write SetCover150pxWidthURL;
    property Cover200pxWidthURL: string read FCover200pxWidthURL
      write SetCover200pxWidthURL;
    property Cover300pxWidthURL: string read FCover300pxWidthURL
      write SetCover300pxWidthURL;
    property Cover400pxWidthURL: string read FCover400pxWidthURL
      write SetCover400pxWidthURL;
    property Cover500pxWidthURL: string read FCover500pxWidthURL
      write SetCover500pxWidthURL;
    property Cover100pxHeightURL: string read FCover100pxHeightURL
      write SetCover100pxHeightURL;
    property Cover200pxHeightURL: string read FCover200pxHeightURL
      write SetCover200pxHeightURL;
    property Cover300pxHeightURL: string read FCover300pxHeightURL
      write SetCover300pxHeightURL;
    property Cover400pxHeightURL: string read FCover400pxHeightURL
      write SetCover400pxHeightURL;
    property Cover500pxHeightURL: string read FCover500pxHeightURL
      write SetCover500pxHeightURL;
    property Cover100pxSquareURL: string read FCover100pxSquareURL
      write SetCover100pxSquareURL;
    property Cover200pxSquareURL: string read FCover200pxSquareURL
      write SetCover200pxSquareURL;
    property Cover300pxSquareURL: string read FCover300pxSquareURL
      write SetCover300pxSquareURL;
    property Cover400pxSquareURL: string read FCover400pxSquareURL
      write SetCover400pxSquareURL;
    property Cover500pxSquareURL: string read FCover500pxSquareURL
      write SetCover500pxSquareURL;
    property Cover130x110pxURL: string read FCover130x110pxURL
      write SetCover130x110pxURL;
    constructor CreateFromJSON(AJSON: TJSONObject;
      AFromRepository: boolean = false); override;
    function ToJSONObject(ForDelphiBooksRepository: boolean = false)
      : TJSONObject; override;
    constructor Create; override;
    destructor Destroy; override;
  end;

  TDelphiBooksBooksList = class(TDelphiBooksList<TDelphiBooksBook>)
  private
  protected
  public
    function GetBookByISBN10(AISBN10: string): TDelphiBooksBook;
    function GetBookByISBN13(AISBN13: string): TDelphiBooksBook;
    procedure SortByTitle;
    procedure SortByPublishedDate;
    procedure SortByPublishedDateDesc;
  end;

  TDelphiBooksBooksObjectList = class(TDelphiBooksObjectList<TDelphiBooksBook>)
  private
  protected
  public
    function GetBookByISBN10(AISBN10: string): TDelphiBooksBook;
    function GetBookByISBN13(AISBN13: string): TDelphiBooksBook;
    procedure SortByTitle;
    procedure SortByPublishedDate;
    procedure SortByPublishedDateDesc;
  end;

implementation

uses
  System.Generics.defaults,
  System.SysUtils,
  System.IOUtils;

{ TDelphiBooksItem }

constructor TDelphiBooksItem.Create;
begin
  inherited;
  FId := CDelphiBooksNullID;
  Fguid := '';
  FURL := '';
  FPageName := '';
  FDataLevel := 0;
  FDataVersion := GetClassDataVersion;
  FHasChanged := false;
  FIsPageToBuild := false;
end;

constructor TDelphiBooksItem.CreateFromJSON(AJSON: TJSONObject;
  AFromRepository: boolean);
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
    if hasID then
      raise exception.Create('ID not found')
    else
      FId := CDelphiBooksNullID;

  if not AJSON.TryGetValue<string>('guid', Fguid) then
    Fguid := '';

  if not AJSON.TryGetValue<string>('url', FURL) then
    FURL := '';

  if not AJSON.TryGetValue<string>('pagename', FPageName) then
    FPageName := '';

  if not AJSON.TryGetValue<integer>('datalevel', FDataLevel) then
    FDataLevel := 0;

  if not AJSON.TryGetValue<boolean>('ispagetobuild', FIsPageToBuild) then
    FIsPageToBuild := false;

  FHasChanged := false;
end;

function TDelphiBooksItem.Getguid: string;
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
    ValuesChanged;
  end;
  result := Fguid;
end;

function TDelphiBooksItem.hasID: boolean;
begin
  result := true;
end;

function TDelphiBooksItem.hasURL: boolean;
begin
  result := true;
end;

procedure TDelphiBooksItem.SetPageName(const Value: string);
begin
  if FPageName = Value then
    exit;

  FPageName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksItem.SetURL(const Value: string);
begin
  if FURL = Value then
    exit;

  FURL := Value;
  ValuesChanged;
end;

function TDelphiBooksItem.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := TJSONObject.Create;

  if hasID then
  begin
    if (not ForDelphiBooksRepository) and (FId = CDelphiBooksNullID) then
      raise exception.Create('ID undefined !');
    result.AddPair('id', Id);
  end;

  if hasURL then
    result.AddPair('url', URL);

  if ForDelphiBooksRepository then
  begin
    result.AddPair('guid', Getguid);
    result.AddPair('pagename', PageName);
    result.AddPair('datalevel', DataLevel);
    result.AddPair('dataversion', GetClassDataVersion);
    result.AddPair('ispagetobuild', isPageToBuild);
  end;
end;

function TDelphiBooksItem.ToString: string;
begin
  result := Id.ToString + ' - ' + Guid;
end;

procedure TDelphiBooksItem.ValuesChanged;
begin
  inc(FDataLevel);
  FHasChanged := true;
  FIsPageToBuild := true;
end;

{ TDelphiBooksList<T> }

constructor TDelphiBooksList<T>.CreateFromJSON(AJSON: TJSONArray;
  AFromRepository: boolean);
var
  jsv: tjsonvalue;
begin
  if (not assigned(AJSON)) or (not(AJSON is TJSONArray)) then
    raise exception.Create('JSON Array expected');

  Create;

  if (AJSON.Count > 0) then
    for jsv in AJSON do
      if (jsv is TJSONObject) then
        add(T.CreateFromJSON(jsv as TJSONObject, AFromRepository));
end;

function TDelphiBooksList<T>.GetItemByGUID(AGuid: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Guid = AGuid then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksList<T>.GetItemByID(AID: integer): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Id = AID then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksList<T>.GetMaxID: integer;
var
  i: integer;
begin
  result := CDelphiBooksNullID;
  for i := 0 to Count - 1 do
    if items[i].Id > result then
      result := items[i].Id;
end;

procedure TDelphiBooksList<T>.SortById;
begin
  Sort(TComparer<T>.Construct(
    function(const a, b: T): integer
    begin
      if a.Id = b.Id then
        result := 0
      else if a.Id > b.Id then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksList<T>.SortByIdDesc;
begin
  Sort(TComparer<T>.Construct(
    function(const a, b: T): integer
    begin
      if a.Id = b.Id then
        result := 0
      else if a.Id < b.Id then
        result := 1
      else
        result := -1;
    end));
end;

function TDelphiBooksList<T>.ToJSONArray(ForDelphiBooksRepository: boolean)
  : TJSONArray;
var
  Item: T;
begin
  result := TJSONArray.Create;
  if (Count > 0) then
    for Item in self do
      result.add(Item.ToJSONObject(ForDelphiBooksRepository));
end;

{ TDelphiBooksObjectList<T> }

constructor TDelphiBooksObjectList<T>.CreateFromJSON(AJSON: TJSONArray;
AFromRepository: boolean);
var
  jsv: tjsonvalue;
begin
  if (not assigned(AJSON)) or (not(AJSON is TJSONArray)) then
    raise exception.Create('JSON Array expected');

  Create;

  if (AJSON.Count > 0) then
    for jsv in AJSON do
      if (jsv is TJSONObject) then
        add(T.CreateFromJSON(jsv as TJSONObject, AFromRepository));
end;

function TDelphiBooksObjectList<T>.GetItemByGUID(AGuid: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Guid = AGuid then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksObjectList<T>.GetItemByID(AID: integer): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Id = AID then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksObjectList<T>.GetMaxID: integer;
var
  i: integer;
begin
  result := CDelphiBooksNullID;
  for i := 0 to Count - 1 do
    if items[i].Id > result then
      result := items[i].Id;
end;

procedure TDelphiBooksObjectList<T>.SortById;
begin
  Sort(TComparer<T>.Construct(
    function(const a, b: T): integer
    begin
      if a.Id = b.Id then
        result := 0
      else if a.Id > b.Id then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksObjectList<T>.SortByIdDesc;
begin
  Sort(TComparer<T>.Construct(
    function(const a, b: T): integer
    begin
      if a.Id = b.Id then
        result := 0
      else if a.Id < b.Id then
        result := 1
      else
        result := -1;
    end));
end;

function TDelphiBooksObjectList<T>.ToJSONArray(ForDelphiBooksRepository
  : boolean): TJSONArray;
var
  Item: T;
begin
  result := TJSONArray.Create;
  if (Count > 0) then
    for Item in self do
      result.add(Item.ToJSONObject(ForDelphiBooksRepository));
end;

{ TDelphiBooksAuthorShort }

constructor TDelphiBooksAuthorShort.Create;
begin
  inherited;
  FName := '';
end;

constructor TDelphiBooksAuthorShort.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
begin
  inherited;
  if not AJSON.TryGetValue<string>('name', FName) then
    FName := '';

  FHasChanged := false;
end;

function TDelphiBooksAuthorShort.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksAuthorShort.SetName(const Value: string);
begin
  if FName = Value then
    exit;

  FName := Value;
  ValuesChanged;
end;

function TDelphiBooksAuthorShort.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;
  result.AddPair('name', Name);
end;

function TDelphiBooksAuthorShort.ToString: string;
begin
  result := name;
end;

{ TDelphiBooksPublisherShort }

constructor TDelphiBooksPublisherShort.Create;
begin
  inherited;
  FCompanyName := '';
end;

constructor TDelphiBooksPublisherShort.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
begin
  inherited;
  if not AJSON.TryGetValue<string>('label', FCompanyName) then
    FCompanyName := '';

  FHasChanged := false;
end;

function TDelphiBooksPublisherShort.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksPublisherShort.SetCompanyName(const Value: string);
begin
  if FCompanyName = Value then
    exit;

  FCompanyName := Value;
  ValuesChanged;
end;

function TDelphiBooksPublisherShort.ToJSONObject(ForDelphiBooksRepository
  : boolean): TJSONObject;
begin
  result := inherited;
  result.AddPair('label', CompanyName);
end;

function TDelphiBooksPublisherShort.ToString: string;
begin
  result := CompanyName;
end;

{ TDelphiBooksBookShort }

constructor TDelphiBooksBookShort.Create;
begin
  inherited;
  FTitle := '';
  FLanguageISOCode := 'EN';
  FPublishedDateYYYYMMDD := '00000000';
  FCoverThumbURL := '';
end;

constructor TDelphiBooksBookShort.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
begin
  inherited;
  if not AJSON.TryGetValue<string>('name', FTitle) then
    FTitle := '';
  if not AJSON.TryGetValue<string>('lang', FLanguageISOCode) then
    FLanguageISOCode := 'EN';
  if not AJSON.TryGetValue<string>('pubdate', FPublishedDateYYYYMMDD) then
    FPublishedDateYYYYMMDD := '00000000';
  if not AJSON.TryGetValue<string>('thumb', FCoverThumbURL) then
    FCoverThumbURL := '';

  FHasChanged := false;
end;

function TDelphiBooksBookShort.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

function TDelphiBooksBookShort.GetPublishedDateYYYY: string;
begin
  result := PublishedDateYYYYMMDD.substring(0, 4);
end;

function TDelphiBooksBookShort.GetPublishedDateYYYYMM: string;
begin
  result := PublishedDateYYYYMMDD.substring(0, 6);
end;

procedure TDelphiBooksBookShort.SetCoverThumbURL(const Value: string);
begin
  if FCoverThumbURL = Value then
    exit;

  FCoverThumbURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBookShort.SetLanguageISOCode(const Value: string);
begin
  if FLanguageISOCode = Value then
    exit;

  FLanguageISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBookShort.SetPublishedDateYYYYMMDD(const Value: string);
begin
  if FPublishedDateYYYYMMDD = Value then
    exit;

  FPublishedDateYYYYMMDD := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBookShort.SetTitle(const Value: string);
begin
  if FTitle = Value then
    exit;

  FTitle := Value;
  ValuesChanged;
end;

function TDelphiBooksBookShort.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;
  result.AddPair('name', Title);
  result.AddPair('lang', LanguageISOCode);
  result.AddPair('pubdate', PublishedDateYYYYMMDD);
  result.AddPair('thumb', CoverThumbURL);
end;

function TDelphiBooksBookShort.ToString: string;
begin
  result := Title;
end;

{ TDelphiBooksTextItem }

constructor TDelphiBooksTextItem.Create;
begin
  inherited;
  FLanguageISOCode := 'EN';
  FText := '';
end;

constructor TDelphiBooksTextItem.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
begin
  inherited;
  if not AJSON.TryGetValue<string>('lang', FLanguageISOCode) then
    raise exception.Create('Language ISO code not found');

  if not AJSON.TryGetValue<string>('text', FText) then
    FText := '';

  FHasChanged := false;
end;

function TDelphiBooksTextItem.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

function TDelphiBooksTextItem.hasID: boolean;
begin
  result := false;
end;

function TDelphiBooksTextItem.hasURL: boolean;
begin
  result := false;
end;

procedure TDelphiBooksTextItem.SetLanguageISOCode(const Value: string);
begin
  if FLanguageISOCode = Value then
    exit;

  FLanguageISOCode := Value;
  ValuesChanged;
end;

procedure TDelphiBooksTextItem.SetText(const Value: string);
begin
  if FText = Value then
    exit;

  FText := Value;
  ValuesChanged;
end;

function TDelphiBooksTextItem.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;
  result.AddPair('lang', LanguageISOCode);
  result.AddPair('text', Text);
end;

function TDelphiBooksTextItem.ToString: string;
begin
  result := LanguageISOCode + ' : ' + Text;
end;

{ TDelphiBooksAuthor }

constructor TDelphiBooksAuthor.Create;
begin
  inherited;
  FFirstName := '';
  FLastName := '';
  FPseudo := '';
  FWebSiteURL := '';
  FDescriptions := TDelphiBooksDescriptionsObjectList.Create;
  FBooks := TDelphiBooksBookShortsObjectList.Create;
end;

constructor TDelphiBooksAuthor.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
var
  jsa: TJSONArray;
begin
  inherited;
  if AFromRepository then
  begin
    if not AJSON.TryGetValue<string>('lastname', FLastName) then
      FLastName := '';
    if not AJSON.TryGetValue<string>('firstname', FFirstName) then
      FFirstName := '';
    if not AJSON.TryGetValue<string>('pseudo', FPseudo) then
      FPseudo := '';
  end
  else if not AJSON.TryGetValue<string>('pseudo', FPseudo) then
    FPseudo := '';

  if not AJSON.TryGetValue<string>('website', FWebSiteURL) then
    FWebSiteURL := '';

  if AJSON.TryGetValue<TJSONArray>('descriptions', jsa) then
  begin
    FDescriptions.Free;
    Descriptions := TDelphiBooksDescriptionsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('books', jsa) then
  begin
    FBooks.Free;
    Books := TDelphiBooksBookShortsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  FHasChanged := false;
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

function TDelphiBooksAuthor.GetPublicName: string;
begin
  if Pseudo.isempty then
    result := trim(FirstName + ' ' + LastName)
  else
    result := Pseudo;
end;

procedure TDelphiBooksAuthor.SetBooks(const Value
  : TDelphiBooksBookShortsObjectList);
begin
  if FBooks = Value then
    exit;

  FBooks := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetDescriptions(const Value
  : TDelphiBooksDescriptionsObjectList);
begin
  if FDescriptions = Value then
    exit;

  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetFirstName(const Value: string);
begin
  if FFirstName = Value then
    exit;

  FFirstName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetLastName(const Value: string);
begin
  if FLastName = Value then
    exit;

  FLastName := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetPseudo(const Value: string);
begin
  if FPseudo = Value then
    exit;

  FPseudo := Value;
  ValuesChanged;
end;

procedure TDelphiBooksAuthor.SetWebSiteURL(const Value: string);
begin
  if FWebSiteURL = Value then
    exit;

  FWebSiteURL := Value;
  ValuesChanged;
end;

function TDelphiBooksAuthor.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;
  if ForDelphiBooksRepository then
  begin
    result.AddPair('lastname', LastName);
    result.AddPair('firstname', FirstName);
    result.AddPair('pseudo', Pseudo);
  end
  else if (not Pseudo.isempty) then
    result.AddPair('name', Pseudo)
  else
    result.AddPair('name', PublicName);
  result.AddPair('website', WebSiteURL);
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('books', Books.ToJSONArray(ForDelphiBooksRepository));
end;

function TDelphiBooksAuthor.ToString: string;
begin
  result := PublicName;
end;

{ TDelphiBooksPublisher }

constructor TDelphiBooksPublisher.Create;
begin
  inherited;
  FWebSiteURL := '';
  FDescriptions := TDelphiBooksDescriptionsObjectList.Create;
  FBooks := TDelphiBooksBookShortsObjectList.Create;
end;

constructor TDelphiBooksPublisher.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
var
  jsa: TJSONArray;
begin
  inherited;
  if not AJSON.TryGetValue<string>('website', FWebSiteURL) then
    FWebSiteURL := '';

  if AJSON.TryGetValue<TJSONArray>('descriptions', jsa) then
  begin
    FDescriptions.Free;
    Descriptions := TDelphiBooksDescriptionsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('books', jsa) then
  begin
    FBooks.Free;
    Books := TDelphiBooksBookShortsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  FHasChanged := false;
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

procedure TDelphiBooksPublisher.SetBooks(const Value
  : TDelphiBooksBookShortsObjectList);
begin
  if FBooks = Value then
    exit;

  FBooks := Value;
  ValuesChanged;
end;

procedure TDelphiBooksPublisher.SetDescriptions(const Value
  : TDelphiBooksDescriptionsObjectList);
begin
  if FDescriptions = Value then
    exit;

  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksPublisher.SetWebSiteURL(const Value: string);
begin
  if FWebSiteURL = Value then
    exit;

  FWebSiteURL := Value;
  ValuesChanged;
end;

function TDelphiBooksPublisher.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;
  result.AddPair('website', WebSiteURL);
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('books', Books.ToJSONArray(ForDelphiBooksRepository));
end;

{ TDelphiBooksBook }

constructor TDelphiBooksBook.Create;
begin
  inherited;
  FISBN13 := '';
  FISBN10 := '';
  FWebSiteURL := '';
  FCoverURL := '';

  FCover100pxWidthURL := '';
  FCover150pxWidthURL := '';
  FCover200pxWidthURL := '';
  FCover300pxWidthURL := '';
  FCover400pxWidthURL := '';
  FCover500pxWidthURL := '';
  FCover100pxHeightURL := '';
  FCover200pxHeightURL := '';
  FCover300pxHeightURL := '';
  FCover400pxHeightURL := '';
  FCover500pxHeightURL := '';
  FCover100pxSquareURL := '';
  FCover200pxSquareURL := '';
  FCover300pxSquareURL := '';
  FCover400pxSquareURL := '';
  FCover500pxSquareURL := '';
  FCover130x110pxURL := '';

  FTOCs := TDelphiBooksTableOfContentsObjectList.Create;
  FDescriptions := TDelphiBooksDescriptionsObjectList.Create;
  FAuthors := TDelphiBooksAuthorShortsObjectList.Create;
  FPublishers := TDelphiBooksPublisherShortsObjectList.Create;
  FKeywords := TDelphiBooksKeywordsObjectList.Create;
end;

constructor TDelphiBooksBook.CreateFromJSON(AJSON: TJSONObject;
AFromRepository: boolean);
var
  jsa: TJSONArray;
begin
  inherited;
  if not AJSON.TryGetValue<string>('isbn10', FISBN10) then
    FISBN10 := '';
  if not AJSON.TryGetValue<string>('isbn13', FISBN13) then
    FISBN13 := '';
  if not AJSON.TryGetValue<string>('website', FWebSiteURL) then
    FWebSiteURL := '';

  if not AJSON.TryGetValue<string>('cover', FCoverURL) then
    FCoverURL := '';

  if not AJSON.TryGetValue<string>('cover_100w', FCover100pxWidthURL) then
    FCover100pxWidthURL := '';
  if not AJSON.TryGetValue<string>('cover_150w', FCover150pxWidthURL) then
    FCover150pxWidthURL := '';
  if not AJSON.TryGetValue<string>('cover_200w', FCover200pxWidthURL) then
    FCover200pxWidthURL := '';
  if not AJSON.TryGetValue<string>('cover_300w', FCover300pxWidthURL) then
    FCover300pxWidthURL := '';
  if not AJSON.TryGetValue<string>('cover_400w', FCover400pxWidthURL) then
    FCover400pxWidthURL := '';
  if not AJSON.TryGetValue<string>('cover_500w', FCover500pxWidthURL) then
    FCover500pxWidthURL := '';

  if not AJSON.TryGetValue<string>('cover_100h', FCover100pxHeightURL) then
    FCover100pxHeightURL := '';
  if not AJSON.TryGetValue<string>('cover_200h', FCover200pxHeightURL) then
    FCover200pxHeightURL := '';
  if not AJSON.TryGetValue<string>('cover_300h', FCover300pxHeightURL) then
    FCover300pxHeightURL := '';
  if not AJSON.TryGetValue<string>('cover_400h', FCover400pxHeightURL) then
    FCover400pxHeightURL := '';
  if not AJSON.TryGetValue<string>('cover_500h', FCover500pxHeightURL) then
    FCover500pxHeightURL := '';

  if not AJSON.TryGetValue<string>('cover_100x100', FCover100pxSquareURL) then
    FCover100pxSquareURL := '';
  if not AJSON.TryGetValue<string>('cover_200x200', FCover200pxSquareURL) then
    FCover200pxSquareURL := '';
  if not AJSON.TryGetValue<string>('cover_300x300', FCover300pxSquareURL) then
    FCover300pxSquareURL := '';
  if not AJSON.TryGetValue<string>('cover_400x400', FCover400pxSquareURL) then
    FCover400pxSquareURL := '';
  if not AJSON.TryGetValue<string>('cover_500x500', FCover500pxSquareURL) then
    FCover500pxSquareURL := '';

  if not AJSON.TryGetValue<string>('cover_130x110', FCover130x110pxURL) then
    FCover130x110pxURL := '';

  if AJSON.TryGetValue<TJSONArray>('authors', jsa) then
  begin
    FAuthors.Free;
    Authors := TDelphiBooksAuthorShortsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('publishers', jsa) then
  begin
    FPublishers.Free;
    Publishers := TDelphiBooksPublisherShortsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('descriptions', jsa) then
  begin
    FDescriptions.Free;
    Descriptions := TDelphiBooksDescriptionsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('tocs', jsa) then
  begin
    FTOCs.Free;
    TOCs := TDelphiBooksTableOfContentsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  if AJSON.TryGetValue<TJSONArray>('keywords', jsa) then
  begin
    FKeywords.Free;
    Keywords := TDelphiBooksKeywordsObjectList.CreateFromJSON(jsa,
      AFromRepository);
  end;

  FHasChanged := false;
end;

destructor TDelphiBooksBook.Destroy;
begin
  FTOCs.Free;
  FDescriptions.Free;
  FAuthors.Free;
  FPublishers.Free;
  FKeywords.Free;
  inherited;
end;

function TDelphiBooksBook.GetClassDataVersion: integer;
begin
  result := CDataVersion;
end;

procedure TDelphiBooksBook.SetAuthors(const Value
  : TDelphiBooksAuthorShortsObjectList);
begin
  if FAuthors = Value then
    exit;

  FAuthors := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover100pxHeightURL(const Value: string);
begin
  if FCover100pxHeightURL = Value then
    exit;

  FCover100pxHeightURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover100pxSquareURL(const Value: string);
begin
  if FCover100pxSquareURL = Value then
    exit;

  FCover100pxSquareURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover100pxWidthURL(const Value: string);
begin
  if FCover100pxWidthURL = Value then
    exit;

  FCover100pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover130x110pxURL(const Value: string);
begin
  if FCover130x110pxURL = Value then
    exit;

  FCover130x110pxURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover150pxWidthURL(const Value: string);
begin
  if FCover150pxWidthURL = Value then
    exit;

  FCover150pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover200pxHeightURL(const Value: string);
begin
  if FCover200pxHeightURL = Value then
    exit;

  FCover200pxHeightURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover200pxSquareURL(const Value: string);
begin
  if FCover200pxSquareURL = Value then
    exit;

  FCover200pxSquareURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover200pxWidthURL(const Value: string);
begin
  if FCover200pxWidthURL = Value then
    exit;

  FCover200pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover300pxHeightURL(const Value: string);
begin
  if FCover300pxHeightURL = Value then
    exit;

  FCover300pxHeightURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover300pxSquareURL(const Value: string);
begin
  if FCover300pxSquareURL = Value then
    exit;

  FCover300pxSquareURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover300pxWidthURL(const Value: string);
begin
  if FCover300pxWidthURL = Value then
    exit;

  FCover300pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover400pxHeightURL(const Value: string);
begin
  if FCover400pxHeightURL = Value then
    exit;

  FCover400pxHeightURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover400pxSquareURL(const Value: string);
begin
  if FCover400pxSquareURL = Value then
    exit;

  FCover400pxSquareURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover400pxWidthURL(const Value: string);
begin
  if FCover400pxWidthURL = Value then
    exit;

  FCover400pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover500pxHeightURL(const Value: string);
begin
  if FCover500pxHeightURL = Value then
    exit;

  FCover500pxHeightURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover500pxSquareURL(const Value: string);
begin
  if FCover500pxSquareURL = Value then
    exit;

  FCover500pxSquareURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCover500pxWidthURL(const Value: string);
begin
  if FCover500pxWidthURL = Value then
    exit;

  FCover500pxWidthURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetCoverURL(const Value: string);
begin
  if FCoverURL = Value then
    exit;

  FCoverURL := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetDescriptions(const Value
  : TDelphiBooksDescriptionsObjectList);
begin
  if FDescriptions = Value then
    exit;

  FDescriptions := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetISBN10(const Value: string);
begin
  if FISBN10 = Value then
    exit;

  FISBN10 := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetISBN13(const Value: string);
begin
  if FISBN13 = Value then
    exit;

  FISBN13 := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetKeywords(const Value
  : TDelphiBooksKeywordsObjectList);
begin
  if FKeywords = Value then
    exit;

  FKeywords := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetPublishers(const Value
  : TDelphiBooksPublisherShortsObjectList);
begin
  if FPublishers = Value then
    exit;

  FPublishers := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetTOCs(const Value
  : TDelphiBooksTableOfContentsObjectList);
begin
  if FTOCs = Value then
    exit;

  FTOCs := Value;
  ValuesChanged;
end;

procedure TDelphiBooksBook.SetWebSiteURL(const Value: string);
begin
  if FWebSiteURL = Value then
    exit;

  FWebSiteURL := Value;
  ValuesChanged;
end;

function TDelphiBooksBook.ToJSONObject(ForDelphiBooksRepository: boolean)
  : TJSONObject;
begin
  result := inherited;

  result.AddPair('isbn10', FISBN10);
  result.AddPair('isbn13', FISBN13);
  result.AddPair('website', WebSiteURL);

  result.AddPair('cover', FCoverURL);

  result.AddPair('cover_100w', FCover100pxWidthURL);
  result.AddPair('cover_150w', FCover150pxWidthURL);
  result.AddPair('cover_200w', FCover200pxWidthURL);
  result.AddPair('cover_300w', FCover300pxWidthURL);
  result.AddPair('cover_400w', FCover400pxWidthURL);
  result.AddPair('cover_500w', FCover500pxWidthURL);

  result.AddPair('cover_100h', FCover100pxHeightURL);
  result.AddPair('cover_200h', FCover200pxHeightURL);
  result.AddPair('cover_300h', FCover300pxHeightURL);
  result.AddPair('cover_400h', FCover400pxHeightURL);
  result.AddPair('cover_500h', FCover500pxHeightURL);

  result.AddPair('cover_100x100', FCover100pxSquareURL);
  result.AddPair('cover_200x200', FCover200pxSquareURL);
  result.AddPair('cover_300x300', FCover300pxSquareURL);
  result.AddPair('cover_400x400', FCover400pxSquareURL);
  result.AddPair('cover_500x500', FCover500pxSquareURL);

  result.AddPair('cover_130x110', FCover130x110pxURL);

  result.AddPair('authors', Authors.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('publishers',
    Publishers.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('descriptions',
    Descriptions.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('tocs', TOCs.ToJSONArray(ForDelphiBooksRepository));
  result.AddPair('keywords', Keywords.ToJSONArray(ForDelphiBooksRepository));
end;

{ TDelphiBooksTextItemsList<T> }

function TDelphiBooksTextItemsList<T>.GetItemByLanguage(AISOCode,
  AText: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if (e.LanguageISOCode = AISOCode) and ((AText.isempty) or (e.Text = AText))
      then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksTextItemsList<T>.GetItemByText(AText: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Text = AText then
      begin
        result := e;
        break;
      end;
end;

{ TDelphiBooksTextItemsObjectList<T> }

function TDelphiBooksTextItemsObjectList<T>.GetItemByLanguage(AISOCode,
  AText: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if (e.LanguageISOCode = AISOCode) and ((AText.isempty) or (e.Text = AText))
      then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksTextItemsObjectList<T>.GetItemByText(AText: string): T;
var
  e: T;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.Text = AText then
      begin
        result := e;
        break;
      end;
end;

{ TDelphiBooksAuthorShortsList }

procedure TDelphiBooksAuthorShortsList.SortByName;
begin
  Sort(TComparer<TDelphiBooksAuthorShort>.Construct(
    function(const a, b: TDelphiBooksAuthorShort): integer
    begin
      if a.Name = b.Name then
        result := 0
      else if a.Name > b.Name then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksAuthorShortsObjectList }

procedure TDelphiBooksAuthorShortsObjectList.SortByName;
begin
  Sort(TComparer<TDelphiBooksAuthorShort>.Construct(
    function(const a, b: TDelphiBooksAuthorShort): integer
    begin
      if a.Name = b.Name then
        result := 0
      else if a.Name > b.Name then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksAuthorsList }

procedure TDelphiBooksAuthorsList.SortByName;
begin
  Sort(TComparer<TDelphiBooksAuthor>.Construct(
    function(const a, b: TDelphiBooksAuthor): integer
    var
      AName, BName: string;
    begin
      AName := a.PublicName;
      BName := b.PublicName;
      if AName = BName then
        result := 0
      else if AName > BName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksAuthorsObjectList }

procedure TDelphiBooksAuthorsObjectList.SortByName;
begin
  Sort(TComparer<TDelphiBooksAuthor>.Construct(
    function(const a, b: TDelphiBooksAuthor): integer
    var
      AName, BName: string;
    begin
      AName := a.PublicName;
      BName := b.PublicName;
      if AName = BName then
        result := 0
      else if AName > BName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksPublisherShortsList }

procedure TDelphiBooksPublisherShortsList.SortByCompanyName;
begin
  Sort(TComparer<TDelphiBooksPublisherShort>.Construct(
    function(const a, b: TDelphiBooksPublisherShort): integer
    begin
      if a.CompanyName = b.CompanyName then
        result := 0
      else if a.CompanyName > b.CompanyName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksPublisherShortsObjectList }

procedure TDelphiBooksPublisherShortsObjectList.SortByCompanyName;
begin
  Sort(TComparer<TDelphiBooksPublisherShort>.Construct(
    function(const a, b: TDelphiBooksPublisherShort): integer
    begin
      if a.CompanyName = b.CompanyName then
        result := 0
      else if a.CompanyName > b.CompanyName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksBookShortsList }

procedure TDelphiBooksBookShortsList.SortByPublishedDate;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD > b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBookShortsList.SortByPublishedDateDesc;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD < b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBookShortsList.SortByTitle;
begin
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.Title = b.Title then
        result := 0
      else if a.Title > b.Title then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksBookShortsObjectList }

procedure TDelphiBooksBookShortsObjectList.SortByPublishedDate;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD > b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBookShortsObjectList.SortByPublishedDateDesc;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD < b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBookShortsObjectList.SortByTitle;
begin
  Sort(TComparer<TDelphiBooksBookShort>.Construct(
    function(const a, b: TDelphiBooksBookShort): integer
    begin
      if a.Title = b.Title then
        result := 0
      else if a.Title > b.Title then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksBooksList }

function TDelphiBooksBooksList.GetBookByISBN10(AISBN10: string)
  : TDelphiBooksBook;
var
  e: TDelphiBooksBook;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.ISBN10 = AISBN10 then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksBooksList.GetBookByISBN13(AISBN13: string)
  : TDelphiBooksBook;
var
  e: TDelphiBooksBook;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.ISBN13 = AISBN13 then
      begin
        result := e;
        break;
      end;
end;

procedure TDelphiBooksBooksList.SortByPublishedDate;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD > b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBooksList.SortByPublishedDateDesc;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD < b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBooksList.SortByTitle;
begin
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.Title = b.Title then
        result := 0
      else if a.Title > b.Title then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksBooksObjectList }

function TDelphiBooksBooksObjectList.GetBookByISBN10(AISBN10: string)
  : TDelphiBooksBook;
var
  e: TDelphiBooksBook;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.ISBN10 = AISBN10 then
      begin
        result := e;
        break;
      end;
end;

function TDelphiBooksBooksObjectList.GetBookByISBN13(AISBN13: string)
  : TDelphiBooksBook;
var
  e: TDelphiBooksBook;
begin
  result := nil;
  if Count > 0 then
    for e in self do
      if e.ISBN13 = AISBN13 then
      begin
        result := e;
        break;
      end;
end;

procedure TDelphiBooksBooksObjectList.SortByPublishedDate;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD > b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBooksObjectList.SortByPublishedDateDesc;
begin // TODO : add the title as second field
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.PublishedDateYYYYMMDD = b.PublishedDateYYYYMMDD then
        result := 0
      else if a.PublishedDateYYYYMMDD < b.PublishedDateYYYYMMDD then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksBooksObjectList.SortByTitle;
begin
  Sort(TComparer<TDelphiBooksBook>.Construct(
    function(const a, b: TDelphiBooksBook): integer
    begin
      if a.Title = b.Title then
        result := 0
      else if a.Title > b.Title then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksKeyword }

function TDelphiBooksKeyword.hasID: boolean;
begin
  result := false;
end;

function TDelphiBooksKeyword.hasURL: boolean;
begin
  result := true;
end;

{ TDelphiBooksLanguage }

function TDelphiBooksLanguage.hasID: boolean;
begin
  result := true;
end;

function TDelphiBooksLanguage.hasURL: boolean;
begin
  result := true;
end;

{ TDelphiBooksLanguagesList }

procedure TDelphiBooksLanguagesList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksLanguage>.Construct(
    function(const a, b: TDelphiBooksLanguage): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksLanguagesList.SortByText;
begin
  Sort(TComparer<TDelphiBooksLanguage>.Construct(
    function(const a, b: TDelphiBooksLanguage): integer
    begin
      if a.Text = b.Text then
        result := 0
      else if a.Text > b.Text then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksLanguagesObjectList }

procedure TDelphiBooksLanguagesObjectList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksLanguage>.Construct(
    function(const a, b: TDelphiBooksLanguage): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksLanguagesObjectList.SortByText;
begin
  Sort(TComparer<TDelphiBooksLanguage>.Construct(
    function(const a, b: TDelphiBooksLanguage): integer
    begin
      if a.Text = b.Text then
        result := 0
      else if a.Text > b.Text then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksPublishersList }

procedure TDelphiBooksPublishersList.SortByCompanyName;
begin
  Sort(TComparer<TDelphiBooksPublisher>.Construct(
    function(const a, b: TDelphiBooksPublisher): integer
    begin
      if a.CompanyName = b.CompanyName then
        result := 0
      else if a.CompanyName > b.CompanyName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksPublishersObjectList }

procedure TDelphiBooksPublishersObjectList.SortByCompanyName;
begin
  Sort(TComparer<TDelphiBooksPublisher>.Construct(
    function(const a, b: TDelphiBooksPublisher): integer
    begin
      if a.CompanyName = b.CompanyName then
        result := 0
      else if a.CompanyName > b.CompanyName then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksKeywordsList }

procedure TDelphiBooksKeywordsList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksKeyword>.Construct(
    function(const a, b: TDelphiBooksKeyword): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksKeywordsList.SortByText;
begin
  Sort(TComparer<TDelphiBooksKeyword>.Construct(
    function(const a, b: TDelphiBooksKeyword): integer
    begin
      if a.Text = b.Text then
        result := 0
      else if a.Text > b.Text then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksKeywordsObjectList }

procedure TDelphiBooksKeywordsObjectList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksKeyword>.Construct(
    function(const a, b: TDelphiBooksKeyword): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

procedure TDelphiBooksKeywordsObjectList.SortByText;
begin
  Sort(TComparer<TDelphiBooksKeyword>.Construct(
    function(const a, b: TDelphiBooksKeyword): integer
    begin
      if a.Text = b.Text then
        result := 0
      else if a.Text > b.Text then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksDescriptionsList }

procedure TDelphiBooksDescriptionsList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksDescription>.Construct(
    function(const a, b: TDelphiBooksDescription): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksDescriptionsObjectList }

procedure TDelphiBooksDescriptionsObjectList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksDescription>.Construct(
    function(const a, b: TDelphiBooksDescription): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksTableOfContentsList }

procedure TDelphiBooksTableOfContentsList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksTableOfContent>.Construct(
    function(const a, b: TDelphiBooksTableOfContent): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

{ TDelphiBooksTableOfContentsObjectList }

procedure TDelphiBooksTableOfContentsObjectList.SortByISOCode;
begin
  Sort(TComparer<TDelphiBooksTableOfContent>.Construct(
    function(const a, b: TDelphiBooksTableOfContent): integer
    begin
      if a.LanguageISOCode = b.LanguageISOCode then
        result := 0
      else if a.LanguageISOCode > b.LanguageISOCode then
        result := 1
      else
        result := -1;
    end));
end;

end.
