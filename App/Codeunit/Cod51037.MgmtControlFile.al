codeunit 51037 "Mgmt Control File"
{
    trigger OnRun()
    begin

    end;

    procedure fnParameters(pRequerimentNo: Code[20]; pUser: Code[20]; pPreAssignedNo: Code[20]);
    begin
        gRequirementNo := pRequerimentNo;
        gUser := pUser;
        gPreAssignedNo := pPreAssignedNo;
    end;

    procedure fnUploadAttachment(pVariant: Variant)
    var
        AttachmentRec: Record Attachment;
        FileOutStream: OutStream;
        FileInStream: InStream;
        tempfilename: text;
        DialogTitle: Label 'Please select a File...';
        RecRef: RecordRef;
        lclUploadIntoBool: Boolean;
    begin
        lclUploadIntoBool := false;
        if UploadIntoStream(DialogTitle, '', 'All Files (*.*)|*.*', tempfilename, FileInStream) then begin
            gCuTempFileBlob.CreateOutStream(FileOutStream);
            CopyStream(FileOutStream, FileInStream);
            lclUploadIntoBool := true;
        end;

        if not lclUploadIntoBool then
            exit;

        RecRef.GetTable(pVariant);

        case RecRef.Number() of
            DATABASE::"Warehouse Receipt Header":
                begin
                    gWarehouseReceiptHeader.Reset();
                    RecRef.SetTable(gWarehouseReceiptHeader);
                    fnPostToControlFile(tempfilename, gWarehouseReceiptHeader."No.");
                end;

        end;
    end;



    procedure fnPrepaymentGetFileType(pFilename: Text): Text;
    var
        FilenamePos: Integer;
    begin
        FilenamePos := StrLen(pFilename);
        while (pFilename[FilenamePos] <> '.') or (FilenamePos < 1) do
            FilenamePos -= 1;

        if FilenamePos = 0 then
            exit('');

        exit(CopyStr(pFilename, FilenamePos + 1, StrLen(pFilename)));
    end;

    procedure fnPostToControlFile(pFileName: code[250]; pFileId: Code[50])
    var
        NewFileinStream: inStream;
        FileName: Text;
        FileExt: Text;
        EntryNo: integer;
        Confirmdownload: Label 'do you want to download the following file?';
        lcCompanyInf: Record "Company Information";
    begin
        gCuTempFileBlob.CreateinStream(NewFileinStream);
        FileName := pFileName;
        FileExt := fnPrepaymentGetFileType(pFileName);

        EntryNo := gControlFile.CreateControlFileRecord(pFileId, FileName, FileExt, WorkDate, WorkDate, NewFileinStream);
        fnMessageNotification(pFileName, STRSUBSTNO('Se importo el Archivo Adjunto %1', pFileName), pFileId);

    end;



    procedure fnMessageNotification(pFileName: text[250]; pMessage: Text[1024]; pFileId: text[50]) pNro: text[20];
    var
        lcNotification: Notification;
        ViewFile: Label 'View File';
    begin
        lcNotification.Message(pMessage);
        lcNotification.Scope := NotificationScope::LocalScope;
        lcNotification.SetData('NameFile', pFileName);
        lcNotification.SetData('FileId', pFileId);
        lcNotification.AddAction(ViewFile, Codeunit::"Mgmt Control File", 'fnPViewControlFileList');
        lcNotification.Send();
    end;

    procedure fnPViewControlFileList(MyNotification: Notification)
    var
        lcFileId: Text;
        lcNameFile: Text;
        lcCuGenJnlMgt: Codeunit GenJnlManagement;
        lcRecRemittanceFiles: Record "ST Control File";
        lcPgRemittanceFiles: Page "ST Control File List";
    begin
        lcFileId := MyNotification.GETDATA('FileId');
        lcNameFile := MyNotification.GETDATA('NameFile');
        CLEAR(lcPgRemittanceFiles);
        lcRecRemittanceFiles.Reset();
        lcRecRemittanceFiles.SetRange("File ID", lcFileId);
        lcRecRemittanceFiles.SetRange("File Name", lcNameFile);
        lcPgRemittanceFiles.SETTABLEVIEW(lcRecRemittanceFiles);
        lcPgRemittanceFiles.RUNMODAL;

    end;

    procedure fnOpenAttachment(pFileIde: Code[50])
    var
        lcRecRemittanceFiles: Record "ST Control File";
        lcPgRemittanceFiles: Page "ST Control File List";
    begin

        CLEAR(lcPgRemittanceFiles);
        lcRecRemittanceFiles.Reset();
        lcRecRemittanceFiles.SetRange("File ID", pFileIde);
        lcPgRemittanceFiles.SETTABLEVIEW(lcRecRemittanceFiles);
        lcPgRemittanceFiles.RUNMODAL;
    end;

    var
        gRequirementNo: Code[20];
        gUser: Code[20];
        gPreAssignedNo: Code[20];
        gCuTempFileBlob: Codeunit "Temp Blob";
        gControlFile: Record "ST Control File";
        gWarehouseReceiptHeader: Record "Warehouse Receipt Header";
}