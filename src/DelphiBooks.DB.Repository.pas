unit DelphiBooks.DB.Repository;

interface

uses
  DelphiBooks.Classes;

type
{$SCOPEDENUMS ON}
  TDelphiBooksTable = (Authors, Publishers, Books);

  TDelphiBooksDatabase = class
  private const
    CDatabaseVersion = '20230628';

  var
    FDatabaseFolder: string;
    FBooks: TDelphiBooksBooksObjectList;
    FAuthors: TDelphiBooksAuthorsObjectList;
    FPublishers: TDelphiBooksPublishersObjectList;
    procedure SetAuthors(const Value: TDelphiBooksAuthorsObjectList);
    procedure SetBooks(const Value: TDelphiBooksBooksObjectList);
    procedure SetPublishers(const Value: TDelphiBooksPublishersObjectList);
  protected
    procedure CreateRecordFromRepository(AFilename: string;
      ATable: TDelphiBooksTable);
  public
    property Authors: TDelphiBooksAuthorsObjectList read FAuthors
      write SetAuthors;
    property Publishers: TDelphiBooksPublishersObjectList read FPublishers
      write SetPublishers;
    property Books: TDelphiBooksBooksObjectList read FBooks write SetBooks;
    property DatabaseFolder: string read FDatabaseFolder;
    constructor Create; virtual;
    destructor Destroy; override;
    constructor CreateFromRepository(AFolder: string); virtual;
    procedure SaveToRepository(AFolder: string = '';
      FOnlyChanged: boolean = true); virtual;
    procedure CheckRepositoryLevelInFolder(AFolder: string);
    function GuidToFilename(AGuid: string; ATable: TDelphiBooksTable;
      AFileExtension: string): string;
  end;

  TDelphiBooksItemHelper = class helper for TDelphiBooksItem
  public
    procedure SetId(AID: integer);
    procedure SetHasChanged(AHasChanged: boolean);
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

constructor TDelphiBooksDatabase.CreateFromRepository(AFolder: string);
var
  DatabaseFolder: string;
  Files: TStringDynArray;
  i: integer;
begin
  CheckRepositoryLevelInFolder(AFolder);

  DatabaseFolder := tpath.Combine(tpath.Combine(AFolder, 'database'), 'datas');
  if not tdirectory.exists(DatabaseFolder) then
    raise exception.Create
      ('The database folder doesn''t exist in the repository folders tree.');

  Create;

  // Load all authors
  Files := tdirectory.getfiles(DatabaseFolder, 'a-*.db');
  Authors.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Authors);

  // Load all publishers
  Files := tdirectory.getfiles(DatabaseFolder, 'p-*.db');
  Publishers.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Publishers);

  // Load all books
  Files := tdirectory.getfiles(DatabaseFolder, 'b-*.db');
  Books.clear;
  if (length(Files) > 0) then
    for i := 0 to length(Files) - 1 do
      CreateRecordFromRepository(Files[i], TDelphiBooksTable.Books);

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
        Authors.add(tdelphibooksauthor.createfromjson(JSO, true));
      TDelphiBooksTable.Publishers:
        Publishers.add(tdelphibookspublisher.createfromjson(JSO, true));
      TDelphiBooksTable.Books:
        Books.add(tdelphibooksbook.createfromjson(JSO, true));
    end;
  finally
    JSO.Free;
  end;
end;

destructor TDelphiBooksDatabase.Destroy;
begin
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
  end;

  result := result + '.' + AFileExtension;
end;

procedure TDelphiBooksDatabase.SaveToRepository(AFolder: string;
  FOnlyChanged: boolean);
var
  DatabaseFolder: string;
  Author: tdelphibooksauthor;
  Publisher: tdelphibookspublisher;
  Book: tdelphibooksbook;
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

  if Authors.Count > 0 then
    for Author in Authors do
      if (FOnlyChanged and Author.hasChanged) or (not FOnlyChanged) then
      begin
        tfile.WriteAllText(tpath.Combine(DatabaseFolder,
          GuidToFilename(Author.Guid, TDelphiBooksTable.Authors, 'json')),
          AddNewLineToJSONAsString(Author.ToJSONObject(true).ToJSON),
          tencoding.utf8);
        Author.SetHasChanged(false);
      end;

  if Publishers.Count > 0 then
    for Publisher in Publishers do
      if (FOnlyChanged and Publisher.hasChanged) or (not FOnlyChanged) then
      begin
        tfile.WriteAllText(tpath.Combine(DatabaseFolder,
          GuidToFilename(Publisher.Guid, TDelphiBooksTable.Publishers, 'json')),
          AddNewLineToJSONAsString(Publisher.ToJSONObject(true).ToJSON),
          tencoding.utf8);
        Publisher.SetHasChanged(false);
      end;

  if Books.Count > 0 then
    for Book in Books do
      if (FOnlyChanged and Book.hasChanged) or (not FOnlyChanged) then
      begin
        tfile.WriteAllText(tpath.Combine(DatabaseFolder,
          GuidToFilename(Book.Guid, TDelphiBooksTable.Books, 'json')),
          AddNewLineToJSONAsString(Book.ToJSONObject(true).ToJSON),
          tencoding.utf8);
        Book.SetHasChanged(false);
      end;
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

procedure TDelphiBooksDatabase.SetPublishers(const Value
  : TDelphiBooksPublishersObjectList);
begin
  FPublishers := Value;
end;

{ TDelphiBooksItemHelper }

procedure TDelphiBooksItemHelper.SetHasChanged(AHasChanged: boolean);
begin
  FHasChanged := AHasChanged;
end;

procedure TDelphiBooksItemHelper.SetId(AID: integer);
begin
  fid := AID;
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
