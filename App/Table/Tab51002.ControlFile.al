table 51002 "ST Control File"
{
    DataClassification = ToBeClassified;
    Caption = 'Control File', Comment = 'ESM="Control de archivos"';

    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="N° Mov."';
        }

        field(51001; "File ID"; code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Id. Archivo', Comment = 'ESM="Id. Archivo"';
        }

        field(51002; "File Name"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'File Name', Comment = 'ESM="Nombre archivo"';
        }

        field(51003; "File Extension"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'File Extension', Comment = 'ESM="Extensión archivo"';
        }

        field(51004; "Start Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Start Date', Comment = 'ESM="Fecha Inicio"';
        }

        field(51005; "End Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
        }

        field(51006; "Create DateTime File"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Create Datetim file', Comment = 'ESM="fecha Creación"';
        }

        field(51007; "Create User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Create User ID', Comment = 'ESM="Id. Usuario Creador"';
        }

        field(51008; "File Blob"; Blob)
        {
            DataClassification = ToBeClassified;
            Caption = 'File', Comment = 'ESM="Archivo"';
        }

        field(51009; "Status"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status', Comment = 'ESM="Estado"';
            OptionMembers = ,Generado,Validado,Enviado;
        }
        field(51109; "Entry Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Tipo Entrada', Comment = 'ESM="Tipo Entrada"';
            OptionMembers = " ","Recaudación";
        }
        field(51110; "Description"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Descriptción', Comment = 'ESM="Description"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        FileMgt: Codeunit "File Management";

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin
    end;

    trigger OnRename()
    begin

    end;

    procedure CreateControlFileRecord(FileID: Code[50]; FileName: Text[150]; FileExt: Text[30]; StartDate: Date; EndDate: Date; var NewFileInStream: InStream): Integer
    var
        ControlFile: Record "ST Control File";
        NextEntryNo: Integer;
        NewFileOutStream: OutStream;
    begin
        ControlFile.Reset();
        ControlFile.SetCurrentKey("Entry No.");
        if ControlFile.FindLast() then
            NextEntryNo := ControlFile."Entry No." + 1
        else
            NextEntryNo := 1;
        ControlFile.Init();
        ControlFile."Entry No." := NextEntryNo;
        ControlFile."File ID" := FileID;
        ControlFile."File Name" := FileName;
        ControlFile."File Extension" := FileExt;
        ControlFile."Start Date" := StartDate;
        ControlFile."End Date" := EndDate;
        ControlFile."File Blob".CreateOutStream(NewFileOutStream);
        CopyStream(NewFileOutStream, NewFileInStream);
        ControlFile."Create DateTime File" := CurrentDateTime;
        ControlFile."Create User ID" := UserId;
        ControlFile.Insert();
        exit(NextEntryNo);
    end;

    procedure CreateControlFileRecordANSI(FileID: Code[50]; FileName: Text[150]; FileExt: Text[30]; StartDate: Date; EndDate: Date; var NewFileInStream: InStream): Integer
    var
        ControlFile: Record "ST Control File";
        NextEntryNo: Integer;
        NewFileOutStream: OutStream;
    begin
        ControlFile.Reset();
        ControlFile.SetCurrentKey("Entry No.");
        if ControlFile.FindLast() then
            NextEntryNo := ControlFile."Entry No." + 1
        else
            NextEntryNo := 1;
        ControlFile.Init();
        ControlFile."Entry No." := NextEntryNo;
        ControlFile."File ID" := FileID;
        ControlFile."File Name" := FileName;
        ControlFile."File Extension" := FileExt;
        ControlFile."Start Date" := StartDate;
        ControlFile."End Date" := EndDate;
        ControlFile."File Blob".CreateOutStream(NewFileOutStream, TextEncoding::Windows);
        CopyStream(NewFileOutStream, NewFileInStream);
        ControlFile."Create DateTime File" := CurrentDateTime;
        ControlFile."Create User ID" := UserId;
        ControlFile.Insert();
        exit(NextEntryNo);
    end;

    procedure DownLoadFile(var ControlFile: Record "ST Control File")
    var
        NewFileInStream: InsTream;
        NewFileOutStream: OutStream;
        ToFileName: text[250];
        TempBlob: Codeunit "Temp Blob";
        FileIsNotExist: Label 'The file is not exists.', Comment = 'ESM="EL archivo no existe."';
        DialogTitle: Label 'Download File', Comment = 'ESM="Descargar archivo."';
    begin
        ControlFile.CalcFields("File Blob");
        If NOT ControlFile."File Blob".HasValue then begin
            Message(FileIsNotExist);
            exit;
        end;
        ControlFile."File Blob".CreateInStream(NewFileInStream);
        ToFileName := ControlFile."File Name" + '.' + ControlFile."File Extension";
        DownloadFromStream(NewFileInStream, DialogTitle, '', 'All Files (*.*)|*.*', ToFileName);
    end;

    procedure DownloadEmptyFile(var ControlFile: Record "ST Control File")
    var
        NewFileInStream: InsTream;
        NewFileOutStream: OutStream;
        ToFileName: text[250];
        TempBlob: Codeunit "Temp Blob";
        FileIsNotExist: Label 'The file is not exists.', Comment = 'ESM="EL archivo no existe."';
        DialogTitle: Label 'Download File', Comment = 'ESM="Descargar archivo."';
    begin
        ControlFile.CalcFields("File Blob");
        ControlFile."File Blob".CreateInStream(NewFileInStream);
        ToFileName := ControlFile."File Name" + '.' + ControlFile."File Extension";
        DownloadFromStream(NewFileInStream, DialogTitle, '', 'All Files (*.*)|*.*', ToFileName);
    end;

    procedure DownLoadFileANSII(var ControlFile: Record "ST Control File")
    var
        NewFileInStream: InsTream;
        NewFileOutStream: OutStream;
        ToFileName: text[250];
        TempBlob: Codeunit "Temp Blob";
        FileIsNotExist: Label 'The file is not exists.', Comment = 'ESM="EL archivo no existe."';
        DialogTitle: Label 'Download File', Comment = 'ESM="Descargar archivo."';
    begin
        ControlFile.CalcFields("File Blob");
        If NOT ControlFile."File Blob".HasValue then begin
            Message(FileIsNotExist);
            exit;
        end;
        ControlFile."File Blob".CreateInStream(NewFileInStream, TextEncoding::Windows);
        ToFileName := ControlFile."File Name" + '.' + ControlFile."File Extension";
        DownloadFromStream(NewFileInStream, DialogTitle, '', 'All Files (*.*)|*.*', ToFileName);
    end;

    procedure CompressZipControlFile(pEntryNo: Integer)
    var
        CuDataCompress: Codeunit "Data Compression";
        lcCUTempBlob: Codeunit "Temp Blob";
        ZipFileName: Text[150];
        lcOutStream: OutStream;
        lcIntStream: InStream;
        lclControlFile: Record "ST Control File";
        lclFileName: Text;
        lclFileExt: Text;
        lclCharacter: Label '.-!"·$%&/()=¿?[]?^*Ç¨\|@#~+_';
    begin
        if pEntryNo = 0 then
            exit;

        lclControlFile.Get(pEntryNo);

        Clear(CuDataCompress);
        Clear(lcCUTempBlob);
        lclControlFile.CalcFields("File Blob");

        lclControlFile."File Blob".CreateInStream(lcIntStream, TextEncoding::Windows);

        //Get New Name File
        lclFileExt := lclControlFile."File Extension";
        lclFileName := lclControlFile."File Name";
        lclFileName := DelChr(DelChr(lclFileName, '=', lclFileExt), '=', lclCharacter);
        lclFileExt := 'zip';

        CuDataCompress.CreateZipArchive();
        CuDataCompress.AddEntry(lcIntStream, lclFileName + '.' + lclControlFile."File Extension");
        Clear(lclControlFile."File Blob");
        //Replace File
        lclControlFile."File Blob".CreateOutStream(lcOutStream, TextEncoding::Windows);
        CuDataCompress.SaveZipArchive(lcOutStream);

        //Replace Name File
        lclControlFile."File Extension" := lclFileExt;
        lclControlFile."File Name" := lclFileName;
        lclControlFile.Modify();
    end;
}