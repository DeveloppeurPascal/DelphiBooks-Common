unit DelphiBooks.DB.Repository;

interface

uses
  DelphiBooks.Classes;

type
{$SCOPEDENUMS ON}
  TDelphiBooksTable = (Authors, Publishers, Books, Languages);

  TDelphiBooksDatabase = class
  private const
    CDatabaseVersion = '20230710';
    CDBFileExtension = '.json';

  var
    FDatabaseFolder: string;
    FBooks: TDelphiBooksBooksObjectList;
    FAuthors: TDelphiBooksAuthorsObjectList;
    FPublishers: TDelphiBooksPublishersObjectList;
    FLanguages: TDelphiBooksLanguagesObjectList;
    procedure SetLanguages(const Value: TDelphiBooksLanguagesObjectList);
    procedure SetAuthors(const Value: TDelphiBooksAuthorsObjectList);
    procedure SetBooks(const Value: TDelphiBooksBooksObjectList);
    procedure SetPublishers(const Value: TDelphiBooksPublishersObjectList);
  protected
    procedure CreateRecordFromRepository(AFilename: string;
      ATable: TDelphiBooksTable);
    function GuidToFilename(AGuid: string; ATable: TDelphiBooksTable;
      AFileExtension: string): string;
    procedure RebuildBooksListForAuthors;
    procedure RebuildBooksListForPublishers;
  public const
    CThumbExtension = '.jpg';
    property Authors: TDelphiBooksAuthorsObjectList read FAuthors
      write SetAuthors;
    property Publishers: TDelphiBooksPublishersObjectList read FPublishers
      write SetPublishers;
    property Books: TDelphiBooksBooksObjectList read FBooks write SetBooks;
    property Languages: TDelphiBooksLanguagesObjectList read FLanguages
      write SetLanguages;
    property DatabaseFolder: string read FDatabaseFolder;
    constructor Create; virtual;
    destructor Destroy; override;
    procedure CheckRepositoryLevelInFolder(AFolder: string);
    function isPageNameUniq(APageName: string; ATable: TDelphiBooksTable;
      ACurItem: TDelphiBooksItem): boolean;
    constructor CreateFromRepository(ARepositoryFolder: string); virtual;
    procedure SaveToRepository(AFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
    procedure SaveItemToRepository(AItem: TDelphiBooksItem;
      AItemTable: TDelphiBooksTable; ADatabaseFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
    procedure LoadAuthorsFromRepository(ADatabaseFolder: string = ''); virtual;
    procedure SaveAuthorsToRepository(ADatabaseFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
    procedure LoadPublishersFromRepository(ADatabaseFolder
      : string = ''); virtual;
    procedure SavePublishersToRepository(ADatabaseFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
    procedure LoadBooksFromRepository(ADatabaseFolder: string = ''); virtual;
    procedure SaveBooksToRepository(ADatabaseFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
    procedure LoadLanguagesFromRepository(ADatabaseFolder
      : string = ''); virtual;
    procedure SaveLanguagesToRepository(ADatabaseFolder: string = '';
      AOnlyChanged: boolean = true); virtual;
  end;

  TDelphiBooksItemHelper = class helper for TDelphiBooksItem
  public
    procedure SetId(AID: integer);
    procedure SetHasChanged(AHasChanged: boolean);
    procedure SetHasNewImage(AHasNewImage: boolean);
    function GetImageFileName: string;
  end;

function AddNewLineToJSONAsString(JSON: string): string;

implementation

uses
  System.Classes,
  System.Types,
  System.SysUtils,
  System.JSON,
  System.IOUtils;

{ TDelphiBooksDatabase }

constructor TDelphiBooksDatabase.Create;
begin
  inherited;
  FBooks := TDelphiBooksBooksObjectList.Create;
  FAuthors := TDelphiBooksAuthorsObjectList.Create;
  FPublishers := TDelphiBooksPublishersObjectList.Create;
  FLanguages := TDelphiBooksLanguagesObjectList.Create;

  FDatabaseFolder := '';
{$IFDEF DEBUG}
{$IFDEF MSWINDOWS}
  FDatabaseFolder := tpath.Combine(tpath.GetDirectoryName(paramstr(0)), '..');
  // debug
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, '..'); // win32 or win64
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, '..'); // src
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, '..'); // v1_x or v2
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, 'lib-externes');
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, 'DelphiBooks-WebSite');
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, 'database');
  FDatabaseFolder := tpath.Combine(FDatabaseFolder, 'datas');
{$ENDIF}
{$ELSE}
{$IFDEF MSWINDOWS}
  FDatabaseFolder := tpath.Combine(tpath.GetDirectoryName(paramstr(0)),
    'datas');
{$ENDIF}
{$ENDIF}
end;

constructor TDelphiBooksDatabase.CreateFromRepository(ARepositoryFolder
  : string);
var
  DatabaseFolder: string;
begin
  CheckRepositoryLevelInFolder(ARepositoryFolder);

  DatabaseFolder := tpath.Combine(tpath.Combine(ARepositoryFolder,
    'database'), 'datas');
  if not tdirectory.exists(DatabaseFolder) then
    raise exception.Create
      ('The database folder doesn''t exist in the repository folders tree.');

  Create;

  LoadAuthorsFromRepository(DatabaseFolder);
  LoadPublishersFromRepository(DatabaseFolder);
  LoadBooksFromRepository(DatabaseFolder);
  LoadLanguagesFromRepository(DatabaseFolder);

  RebuildBooksListForAuthors;
  RebuildBooksListForPublishers;

  // All is good, we save the database repository folder
  FDatabaseFolder := DatabaseFolder;
end;

procedure TDelphiBooksDatabase.CreateRecordFromRepository(AFilename: string;
  ATable: TDelphiBooksTable);
var
  JSO: TJSONObject;
  JSON: string;
begin
  if AFilename.isempty then
    raise exception.Create('Empty filename');

  if not tfile.exists(AFilename) then
    raise exception.Create('File "' + AFilename + '" not found');

  JSON := tfile.readalltext(AFilename, tencoding.utf8);
  JSO := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
  if not assigned(JSO) then
    raise exception.Create('Wrong file format in "' + AFilename + '"');

  try
    case ATable of
      TDelphiBooksTable.Authors:
        Authors.add(tdelphibooksauthor.createfromjson(JSO, true, false));
      TDelphiBooksTable.Publishers:
        Publishers.add(TDelphiBooksPublisher.createfromjson(JSO, true, false));
      TDelphiBooksTable.Books:
        Books.add(TDelphiBooksBook.createfromjson(JSO, true, false));
      TDelphiBooksTable.Languages:
        Languages.add(TDelphiBooksLanguage.createfromjson(JSO, true, false));
    end;
  finally
    JSO.Free;
  end;
end;

destructor TDelphiBooksDatabase.Destroy;
begin
  FLanguages.Free;
  FBooks.Free;
  FPublishers.Free;
  FAuthors.Free;
  inherited;
end;

function TDelphiBooksDatabase.GuidToFilename(AGuid: string;
  ATable: TDelphiBooksTable; AFileExtension: string): string;
var
  i: integer;
begin
  while AFileExtension.StartsWith('.') do
    AFileExtension := AFileExtension.Substring(1);

  if AFileExtension.isempty then
    raise exception.Create('Please specify an extension for this file !');

  if AGuid.isempty then
    raise exception.Create('Need a GUID to define a filename.');

  result := '';
  for i := 0 to length(AGuid) - 1 do
  begin
    if CharInSet(AGuid.Chars[i], ['0' .. '9', 'A' .. 'Z', 'a' .. 'z']) then
      result := result + AGuid.Chars[i];
  end;

  if result.isempty then
    raise exception.Create('Wrong GUID. Filename conversion not available.');

  case ATable of
    TDelphiBooksTable.Authors:
      result := 'a-' + result;
    TDelphiBooksTable.Publishers:
      result := 'p-' + result;
    TDelphiBooksTable.Books:
      result := 'b-' + result;
    TDelphiBooksTable.Languages:
      result := 'l-' + result;
  end;

  result := result + '.' + AFileExtension;
end;

function TDelphiBooksDatabase.isPageNameUniq(APageName: string;
  ATable: TDelphiBooksTable; ACurItem: TDelphiBooksItem): boolean;
var
  l: TDelphiBooksLanguage;
  b: TDelphiBooksBook;
  p: TDelphiBooksPublisher;
  a: tdelphibooksauthor;
begin
  result := true;

  if (Languages.Count > 0) then
    for l in Languages do
      if (l.PageName = APageName) and
        ((ATable <> TDelphiBooksTable.Languages) or (l <> ACurItem)) then
      begin
        result := false;
        exit;
      end;

  if (Authors.Count > 0) then
    for a in Authors do
      if (a.PageName = APageName) and ((ATable <> TDelphiBooksTable.Authors) or
        (a <> ACurItem)) then
      begin
        result := false;
        exit;
      end;

  if (Books.Count > 0) then
    for b in Books do
      if (b.PageName = APageName) and ((ATable <> TDelphiBooksTable.Books) or
        (b <> ACurItem)) then
      begin
        result := false;
        exit;
      end;

  if (Publishers.Count > 0) then
    for p in Publishers do
      if (p.PageName = APageName) and
        ((ATable <> TDelphiBooksTable.Publishers) or (p <> ACurItem)) then
      begin
        result := false;
        exit;
      end;
end;

procedure TDelphiBooksDatabase.LoadAuthorsFromRepository
  (ADatabaseFolder: string);
var
  Files: TStringDynArray;
  i: integer;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  Files := tdirectory.getfiles(ADatabaseFolder, 'a-*' + CDBFileExtension);
  Authors.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Authors);
end;

procedure TDelphiBooksDatabase.LoadBooksFromRepository(ADatabaseFolder: string);
var
  Files: TStringDynArray;
  i: integer;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  Files := tdirectory.getfiles(ADatabaseFolder, 'b-*' + CDBFileExtension);
  Books.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Books);
end;

procedure TDelphiBooksDatabase.LoadLanguagesFromRepository
  (ADatabaseFolder: string);
var
  Files: TStringDynArray;
  i: integer;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  Files := tdirectory.getfiles(ADatabaseFolder, 'l-*' + CDBFileExtension);
  Languages.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Languages);
end;

procedure TDelphiBooksDatabase.LoadPublishersFromRepository
  (ADatabaseFolder: string);
var
  Files: TStringDynArray;
  i: integer;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  Files := tdirectory.getfiles(ADatabaseFolder, 'p-*' + CDBFileExtension);
  Publishers.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Publishers);
end;

procedure TDelphiBooksDatabase.RebuildBooksListForAuthors;
var
  a: tdelphibooksauthor;
  b: TDelphiBooksBook;
  ashort: tdelphibooksauthorshort;
  bshort: TDelphiBooksBookShort;
begin
  if assigned(Authors) and (Authors.Count > 0) then
  begin
    // remove books from all authors
    Authors.SortByName;
    for a in Authors do
    begin
      a.Books.clear;
      a.SetHasChanged(true);
    end;

    // regenerate all links
    if assigned(Books) and (Books.Count > 0) then
    begin
      Books.SortByTitle;
      for b in Books do
        if assigned(b.Authors) and (b.Authors.Count > 0) then
        begin
          b.Authors.SortByName;
          for ashort in b.Authors do
          begin
            a := Authors.GetItemByGUID(ashort.Guid);
            if not assigned(a) then
              raise exception.Create('A book''s author is missing ! ("' +
                ashort.ToString + '")');
            bshort := TDelphiBooksBookShort.createfromjson(b.ToJSONObject(true),
              true, true);
            a.Books.add(bshort);
          end;
        end;
    end;
  end;
end;

procedure TDelphiBooksDatabase.RebuildBooksListForPublishers;
var
  p: TDelphiBooksPublisher;
  b: TDelphiBooksBook;
  pshort: TDelphiBooksPublishershort;
  bshort: TDelphiBooksBookShort;
begin
  if assigned(Publishers) and (Publishers.Count > 0) then
  begin
    // remove books from all publishers
    Publishers.SortByCompanyName;
    for p in Publishers do
    begin
      p.Books.clear;
      p.SetHasChanged(true);
    end;

    // regenerate all links
    if assigned(Books) and (Books.Count > 0) then
    begin
      Books.SortByTitle;
      for b in Books do
        if assigned(b.Publishers) and (b.Publishers.Count > 0) then
        begin
          b.Publishers.SortByCompanyName;
          for pshort in b.Publishers do
          begin
            p := Publishers.GetItemByGUID(pshort.Guid);
            if not assigned(p) then
              raise exception.Create('A book''s publisher is missing ! ("' +
                pshort.ToString + '")');
            bshort := TDelphiBooksBookShort.createfromjson(b.ToJSONObject(true),
              true, true);
            p.Books.add(bshort);
          end;
        end;
    end;
  end;
end;

procedure TDelphiBooksDatabase.SaveAuthorsToRepository(ADatabaseFolder: string;
  AOnlyChanged: boolean);
var
  Author: tdelphibooksauthor;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  if Authors.Count > 0 then
    for Author in Authors do
      SaveItemToRepository(Author, TDelphiBooksTable.Authors, ADatabaseFolder,
        AOnlyChanged);
end;

procedure TDelphiBooksDatabase.SaveBooksToRepository(ADatabaseFolder: string;
  AOnlyChanged: boolean);
var
  Book: TDelphiBooksBook;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  if Books.Count > 0 then
    for Book in Books do
      SaveItemToRepository(Book, TDelphiBooksTable.Books, ADatabaseFolder,
        AOnlyChanged);
end;

procedure TDelphiBooksDatabase.SaveItemToRepository(AItem: TDelphiBooksItem;
  AItemTable: TDelphiBooksTable; ADatabaseFolder: string;
  AOnlyChanged: boolean);
var
  JSO: TJSONObject;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;

  if (AOnlyChanged and AItem.hasChanged) or (not AOnlyChanged) then
  begin
    begin
      // TODO : don't save a file where previous version is the same as the new one
      JSO := AItem.ToJSONObject(true);try
      tfile.WriteAllText(tpath.Combine(ADatabaseFolder,
        GuidToFilename(AItem.Guid, AItemTable, CDBFileExtension)),
        AddNewLineToJSONAsString(JSO.ToJSON), tencoding.utf8);
      finally
        jso.Free;
      end;
      AItem.SetHasChanged(false);
    end;
  end;
end;

procedure TDelphiBooksDatabase.SaveLanguagesToRepository(ADatabaseFolder
  : string; AOnlyChanged: boolean);
var
  Language: TDelphiBooksLanguage;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  if Languages.Count > 0 then
    for Language in Languages do
      SaveItemToRepository(Language, TDelphiBooksTable.Languages,
        ADatabaseFolder, AOnlyChanged);
end;

procedure TDelphiBooksDatabase.SavePublishersToRepository(ADatabaseFolder
  : string; AOnlyChanged: boolean);
var
  Publisher: TDelphiBooksPublisher;
begin
  if ADatabaseFolder.isempty then
    ADatabaseFolder := FDatabaseFolder;
  if Publishers.Count > 0 then
    for Publisher in Publishers do
      SaveItemToRepository(Publisher, TDelphiBooksTable.Publishers,
        ADatabaseFolder, AOnlyChanged);
end;

procedure TDelphiBooksDatabase.SaveToRepository(AFolder: string;
  AOnlyChanged: boolean);
var
  DatabaseFolder: string;
begin
  if not AFolder.isempty then
  begin
    CheckRepositoryLevelInFolder(AFolder);

    DatabaseFolder := tpath.Combine(tpath.Combine(AFolder, 'database'),
      'datas');
  end
  else if not FDatabaseFolder.isempty then
    DatabaseFolder := FDatabaseFolder
  else
    raise exception.Create('No folder to save the repository database.');

  if not tdirectory.exists(DatabaseFolder) then
    raise exception.Create
      ('The database folder doesn''t exist in the repository folders tree.');

  SaveAuthorsToRepository(DatabaseFolder, AOnlyChanged);
  SavePublishersToRepository(DatabaseFolder, AOnlyChanged);
  SaveBooksToRepository(DatabaseFolder, AOnlyChanged);
  SaveLanguagesToRepository(DatabaseFolder, AOnlyChanged);
end;

procedure TDelphiBooksDatabase.CheckRepositoryLevelInFolder(AFolder: string);
var
  RepositoryLevelFileName: string;
  RepositoryLevel: string;
begin
  RepositoryLevelFileName := tpath.Combine(AFolder, 'DelphiBooks.lvl');

  if not tfile.exists(RepositoryLevelFileName) then
    raise exception.Create('Can''t find the repository level file.');

  RepositoryLevel := tfile.readalltext(RepositoryLevelFileName, tencoding.utf8);
  if RepositoryLevel <> CDatabaseVersion then
    raise exception.Create
      ('Wrong repository version, please update it and use its release of this program.');
end;

procedure TDelphiBooksDatabase.SetAuthors(const Value
  : TDelphiBooksAuthorsObjectList);
begin
  FAuthors := Value;
end;

procedure TDelphiBooksDatabase.SetBooks(const Value
  : TDelphiBooksBooksObjectList);
begin
  FBooks := Value;
end;

procedure TDelphiBooksDatabase.SetLanguages(const Value
  : TDelphiBooksLanguagesObjectList);
begin
  FLanguages := Value;
end;

procedure TDelphiBooksDatabase.SetPublishers(const Value
  : TDelphiBooksPublishersObjectList);
begin
  FPublishers := Value;
end;

{ TDelphiBooksItemHelper }

function TDelphiBooksItemHelper.GetImageFileName: string;
var
  i: integer;
begin
  if (Self is TDelphiBooksLanguage) then
    result := (Self as TDelphiBooksLanguage).languageisocode + '.gif'
  else
  begin
    result := '';
    for i := 0 to length(Guid) - 1 do
    begin
      if CharInSet(Guid.Chars[i], ['0' .. '9', 'A' .. 'Z', 'a' .. 'z']) then
        result := result + Guid.Chars[i];
    end;

    if result.isempty then
      raise exception.Create('Wrong GUID. Filename conversion not available.');

    if (Self is tdelphibooksauthor) or (Self is tdelphibooksauthorshort) then
      result := 'a-' + result + '.png'
    else if (Self is TDelphiBooksPublisher) or
      (Self is TDelphiBooksPublishershort) then
      result := 'p-' + result + '.png'
    else if (Self is TDelphiBooksBook) or (Self is TDelphiBooksBookShort) then
      result := 'b-' + result + '.png'
    else
      raise exception.Create('Unknow image file name for ' + Self.classname);
  end;
end;

procedure TDelphiBooksItemHelper.SetHasChanged(AHasChanged: boolean);
begin
  FHasChanged := AHasChanged;
end;

procedure TDelphiBooksItemHelper.SetHasNewImage(AHasNewImage: boolean);
begin
  if (fhasnewimage <> AHasNewImage) then
  begin
    fhasnewimage := AHasNewImage;
    FHasChanged := true;
  end;
end;

procedure TDelphiBooksItemHelper.SetId(AID: integer);
begin
  fid := AID;
  FHasChanged := true;
end;

function AddNewLineToJSONAsString(JSON: string): string;
begin
  result := JSON;
  // #10 = Line Feed
  result := result.Replace('{"', '{' + #10 + '"', [rfReplaceAll]);
  result := result.Replace('{[', '{[' + #10, [rfReplaceAll]);
  result := result.Replace(':[', ':[' + #10, [rfReplaceAll]);
  result := result.Replace(',"', ',' + #10 + '"', [rfReplaceAll]);
  result := result.Replace('},{', #10 + '},{' + #10, [rfReplaceAll]);
  // {-"
  // "-}
  // {-[-
  // :[-
  // -],
  // ,-"
  // -] (dernier du fichier)
end;

end.
