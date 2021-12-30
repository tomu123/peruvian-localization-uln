codeunit 51020 "Payment Schedule Utility"
{
    Permissions = TableData "Cust. Ledger Entry" = rimd, TableData "Vendor Ledger Entry" = rimd, TableData "Sales Cr.Memo Header" = rimd, TableData "Job Ledger Entry" = rimd, TableData "VAT Entry" = rimd;
    trigger OnRun();
    begin

    end;

    [EventSubscriber(ObjectType::Table, Database::"Employee Ledger Entry", 'OnAfterCopyEmployeeLedgerEntryFromGenJnlLine', '', true, true)]
    procedure SetOnAfterCopyEmployeeLedgerEntryFromGenJnlLine(var EmployeeLedgerEntry: Record "Employee Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        EmployeeLedgerEntry."PS Due Date" := GenJournalLine."Due Date";
    end;

    procedure fnDowloadControlDocument(VAR pRecordLink: Record "Record Link")
    var
        lcCuFileMgt: Codeunit "File Management";
        lcFileName: Text[250];
        lcFileExtension: Text[10];
        lcClienteFileName: Text;
        lcFullFileName: Text[1024];
        lcPath: Text[1024];
        lcText0001: label 'Archivo "%1" descargado correctamenten en la siguiente dirección: "%2"';
    begin
        fnGetNameAndExtensionFile(pRecordLink.URL1, lcFileName, lcFileExtension, TRUE);
        lcCuFileMgt.SelectFolderDialog('Seleccione el directorio de destino', lcClienteFileName);
        IF lcClienteFileName = '' THEN
            EXIT;
        lcPath := lcClienteFileName + '\' + lcFileName + '.' + lcFileExtension;
        lcFullFileName := lcFileName + '.' + lcFileExtension;
        // lcCuFileMgt.DownloadToFile(pRecordLink.URL1, lcPath);

        MESSAGE(lcText0001, lcFullFileName, lcPath);
    end;

    procedure fnMessageNotification(pMessage: Text[1024])
    var
        lcNotification: Notification;
    begin
        lcNotification.MESSAGE(pMessage);
        lcNotification.SCOPE := NOTIFICATIONSCOPE::LocalScope;
        lcNotification.SEND;
    end;

    procedure fnGetNameAndExtensionFile(pPath: Text[1024]; VAR pNameFile: Text[250]; VAR pExtensionFile: Text[10]; pIsDownload: Boolean)
    var
        lcTotalCharacters: Integer;
        lcIterations: Integer;
        lcStatusExtension: Boolean;
        lcStatusFileName: Boolean;
        lcIsCharater: Boolean;
        lcExtension: Text[10];
        lcFileName: Text[250];
        lcTempText: Text;
        lcPath: Text[1024];
        lcText0001: label 'No se identificó un nombre de archivo en la dirección %1';
    begin
        lcStatusExtension := FALSE;
        lcStatusFileName := FALSE;
        lcTotalCharacters := STRLEN(pPath);
        IF lcTotalCharacters > 0 THEN BEGIN
            lcPath := pPath;
            REPEAT
                lcIsCharater := NOT (COPYSTR(lcPath, lcTotalCharacters - lcIterations, 1) IN ['\', '.']);

                IF (NOT lcStatusExtension) AND (lcIsCharater) THEN
                    lcExtension := COPYSTR(lcPath, lcTotalCharacters - lcIterations, 1) + lcExtension;
                IF (lcStatusExtension) AND (lcIsCharater) THEN
                    lcFileName := COPYSTR(lcPath, lcTotalCharacters - lcIterations, 1) + lcFileName;

                IF NOT lcStatusExtension THEN
                    lcStatusExtension := COPYSTR(lcPath, lcTotalCharacters - lcIterations, 1) = '.';
                IF NOT lcStatusFileName THEN
                    lcStatusFileName := COPYSTR(lcPath, lcTotalCharacters - lcIterations, 1) = '\';

                lcIterations += 1;
            UNTIL ((lcStatusExtension) AND (lcStatusFileName)) OR (lcTotalCharacters = lcIterations);
            pExtensionFile := lcExtension;
            IF pIsDownload THEN
                pNameFile := lcFileName
            ELSE
                pNameFile := lcFileName + '-' + DELCHR(FORMAT(USERID), '=', ':/\*?|"') +
                             '-' + DELCHR(FORMAT(CURRENTDATETIME, 0, '<Day,2><Month,2><Year4><Hours24,2><Minutes,2><Seconds,2>'), '=', ':/\*?|"');

        END;

    end;

    procedure fnClosingControlCronograma(VAR recPaymentSchedule: Record "Payment Schedule")
    var
        lclCount: Integer;
    begin
        lclCount := 0;
        recPaymentSchedule.SETFILTER(Status, '%1', recPaymentSchedule.Status::Pendiente);
        IF recPaymentSchedule.FINDSET THEN
            REPEAT
                lclCount += 1;
                WITH recPaymentSchedule DO BEGIN
                    DELETE;
                END;
            UNTIL recPaymentSchedule.NEXT = 0;
    end;

    procedure fnMyCheckDim(DimCode: Code[20]): Boolean;
    var
        Dim: Record Dimension;
    begin
        IF Dim.GET(DimCode) THEN BEGIN
            IF Dim.Blocked THEN BEGIN
                DimErr :=
                  STRSUBSTNO(Text014, Dim.TABLECAPTION, DimCode);
                EXIT(FALSE);
            END;
        END ELSE BEGIN
            DimErr :=
              STRSUBSTNO(Text015, Dim.TABLECAPTION, DimCode);
            EXIT(FALSE);
        END;
        EXIT(TRUE);
    end;

    procedure fnMyGetDimErr(): Text[250];
    begin
        EXIT(DimErr);
    end;


    procedure fnMyGetShortcutDimensions(DimSetID: Integer; var ShortcutDimCode: array[10] of Code[20]);
    var
        i: Integer;
    begin
        fnMyGetGLSetup;
        FOR i := 3 TO 10 DO BEGIN
            ShortcutDimCode[i] := '';
            IF GLSetupShortcutDimCode[i] <> '' THEN
                IF DimSetEntry.GET(DimSetID, GLSetupShortcutDimCode[i]) THEN
                    ShortcutDimCode[i] := DimSetEntry."Dimension Value Code";
        END;
    end;

    procedure fnMyGetDimensionSet(var TempDimSetEntry: Record "Dimension Set Entry" temporary; DimSetID: Integer);
    var
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        TempDimSetEntry.DELETEALL;
        WITH DimSetEntry2 DO BEGIN
            SETRANGE("Dimension Set ID", DimSetID);
            IF FINDSET THEN
                REPEAT
                    TempDimSetEntry := DimSetEntry2;
                    TempDimSetEntry.INSERT;
                UNTIL NEXT = 0;
        END;
    end;

    procedure fnMyValidateShortcutDimValues(FieldNumber: Integer; VAR ShortcutDimCode: Code[20]; VAR DimSetID: Integer)
    var
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry";
    begin
        fnMyValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        IF ShortcutDimCode <> '' THEN BEGIN
            DimVal.GET(DimVal."Dimension Code", ShortcutDimCode);
            IF NOT fnMyCheckDim(DimVal."Dimension Code") THEN
                ERROR(fnMyGetDimErr);
            IF NOT fnMyCheckDimValue(DimVal."Dimension Code", ShortcutDimCode) THEN
                ERROR(fnMyGetDimErr);
        END;
        fnMyGetDimensionSet(TempDimSetEntry, DimSetID);
        IF TempDimSetEntry.GET(TempDimSetEntry."Dimension Set ID", DimVal."Dimension Code") THEN
            IF TempDimSetEntry."Dimension Value Code" <> ShortcutDimCode THEN
                TempDimSetEntry.DELETE;
        IF ShortcutDimCode <> '' THEN BEGIN
            TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code" := DimVal.Code;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            IF TempDimSetEntry.INSERT THEN;
        END;
        DimSetID := fnMyGetDimensionSetID(TempDimSetEntry);
    end;

    procedure fnMyGetDimensionSetID(var DimSetEntry2: Record "Dimension Set Entry"): Integer;
    begin
        EXIT(DimSetEntry.GetDimensionSetID(DimSetEntry2));
    end;

    procedure "#GetDimensionsSetup"(ParIntI: Integer): Code[20];
    var
        lclI: Integer;
        lclDimGlobal: array[10] of Code[20];
    begin
        //BEGIN ULN::JLM 001 ++
        CLEAR(lclDimGlobal);

        fnMyGetGLSetup;
        FOR lclI := 1 TO 10 DO BEGIN
            lclDimGlobal[lclI] := GLSetupShortcutDimCode[lclI];
        END;

        EXIT(lclDimGlobal[ParIntI]);
        //END ULN::JLM 001 ++
    end;

    procedure fnMyLookupDimValueCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        fnMyGetGLSetup;
        IF GLSetupShortcutDimCode[FieldNumber] = '' THEN
            ERROR(Text002, GLSetup.TABLECAPTION);
        DimVal.SETRANGE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
        DimVal."Dimension Code" := GLSetupShortcutDimCode[FieldNumber];
        DimVal.Code := ShortcutDimCode;
        IF PAGE.RUNMODAL(0, DimVal) = ACTION::LookupOK THEN BEGIN
            fnMyCheckDim(DimVal."Dimension Code");
            fnMyCheckDimValue(DimVal."Dimension Code", DimVal.Code);
            ShortcutDimCode := DimVal.Code;
        END;
    end;


    procedure fnMyCheckDimValue(DimCode: Code[20]; DimValCode: Code[20]): Boolean;
    var
        DimVal: Record "Dimension Value";
    begin
        IF (DimCode <> '') AND (DimValCode <> '') THEN BEGIN
            IF DimVal.GET(DimCode, DimValCode) THEN BEGIN
                IF DimVal.Blocked THEN BEGIN
                    DimErr :=
                      STRSUBSTNO(
                        Text016, DimVal.TABLECAPTION, DimCode, DimValCode);
                    EXIT(FALSE);
                END;
                IF NOT (DimVal."Dimension Value Type" IN
                        [DimVal."Dimension Value Type"::Standard,
                         DimVal."Dimension Value Type"::"Begin-Total"])
                THEN BEGIN
                    DimErr :=
                      STRSUBSTNO(Text017, DimVal.FIELDCAPTION("Dimension Value Type"),
                        DimVal.TABLECAPTION, DimCode, DimValCode, FORMAT(DimVal."Dimension Value Type"));
                    EXIT(FALSE);
                END;
            END ELSE BEGIN
                DimErr :=
                  STRSUBSTNO(
                    Text018, DimVal.TABLECAPTION, DimCode);
                EXIT(FALSE);
            END;
        END;
        EXIT(TRUE);
    end;

    procedure fnMyValidateDimValueCode(FieldNumber: Integer; var ShortcutDimCode: Code[20]);
    var
        DimVal: Record "Dimension Value";
        GLSetup: Record "General Ledger Setup";
    begin
        fnMyGetGLSetup;
        IF (GLSetupShortcutDimCode[FieldNumber] = '') AND (ShortcutDimCode <> '') THEN
            ERROR(Text002, GLSetup.TABLECAPTION);
        DimVal.SETRANGE("Dimension Code", GLSetupShortcutDimCode[FieldNumber]);
        IF ShortcutDimCode <> '' THEN BEGIN
            DimVal.SETRANGE(Code, ShortcutDimCode);
            IF NOT DimVal.FINDFIRST THEN BEGIN
                DimVal.SETFILTER(Code, STRSUBSTNO('%1*', ShortcutDimCode));
                IF DimVal.FINDFIRST THEN
                    ShortcutDimCode := DimVal.Code
                ELSE
                    ERROR(
                      STRSUBSTNO(Text003,
                        ShortcutDimCode, DimVal.FIELDCAPTION(Code)));
            END;
        END;
    end;

    procedure fnMyGetGLSetup();
    var
        GLSetup: Record "General Ledger Setup";
    begin
        IF NOT HasGotGLSetup THEN BEGIN
            GLSetup.GET;
            GLSetupShortcutDimCode[1] := GLSetup."Shortcut Dimension 1 Code";
            GLSetupShortcutDimCode[2] := GLSetup."Shortcut Dimension 2 Code";
            GLSetupShortcutDimCode[3] := GLSetup."Shortcut Dimension 3 Code";
            GLSetupShortcutDimCode[4] := GLSetup."Shortcut Dimension 4 Code";
            GLSetupShortcutDimCode[5] := GLSetup."Shortcut Dimension 5 Code";
            GLSetupShortcutDimCode[6] := GLSetup."Shortcut Dimension 6 Code";
            GLSetupShortcutDimCode[7] := GLSetup."Shortcut Dimension 7 Code";
            GLSetupShortcutDimCode[8] := GLSetup."Shortcut Dimension 8 Code";
            //GLSetupShortcutDimCode[9] := GLSetup."Shortcut Dimension 9 Code";
            //GLSetupShortcutDimCode[10] := GLSetup."Shortcut Dimension 10 Code";
            HasGotGLSetup := TRUE;
        END;
    end;

    procedure ViewTemplateBatch(pNotification: Notification)
    var
        TemplateName: Text;
        BatchName: Text;
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlMgt: Codeunit GenJnlManagement;
        Codeunit12: Codeunit 12;
    begin
        TemplateName := pNotification.GetData('TemplateName');
        BatchName := pNotification.GetData('BatchName');
        GenJnlBatch.Get(TemplateName, BatchName);
        GenJnlMgt.TemplateSelectionFromBatch(GenJnlBatch);
    end;

    //******************************** Begin Suscriptions ************************************

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    local procedure SetOnBeforeInsertGLEntryBuffer(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line"; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal; var NextEntryNo: Integer; var TotalAmount: Decimal; var TotalAddCurrAmount: Decimal)
    begin
        if GenJournalLine."Setup Source Code" <> GenJournalLine."Setup Source Code"::"Payment Schedule" then
            exit;
        if GenJournalLine."ST Control Entry No." = 0 then
            exit;
        if PaymentSchedule.Get(GenJournalLine."ST Control Entry No.") then begin
            PaymentSchedule.Status := PaymentSchedule.Status::Pagado;
            PaymentSchedule."Document No. Post" := GenJournalLine."Document No.";
            PaymentSchedule."User ID" := TempGLEntryBuf."User ID";
            PaymentSchedule."Process Date" := CurrentDateTime;
            PaymentSchedule.Modify();
            PostedPaymentSchedule.Init();
            PostedPaymentSchedule."Entry No." := PostedPaymentSchedule.fnNextLine();
            PostedPaymentSchedule.TransferFields(PaymentSchedule, false);
            PostedPaymentSchedule.Insert();
            PaymentSchedule.Delete();
        end;
    end;

    //******************************** End Suscriptions *************************************
    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Account No.', true, true)]
    procedure OnAfterValidateEventAccountNo(var Rec: Record "Gen. Journal Line")
    var
        lcRecCustomer: Record Customer;
        lcRecVendor: Record Vendor;
        lcRecEmployee: Record Employee;
    begin
        case Rec."Account Type" of
            Rec."Account Type"::Vendor:
                begin
                    if lcRecVendor.get(rec."Account No.") then
                        Rec."Check Name" := lcRecVendor.Name;
                end;
            Rec."Account Type"::Customer:
                begin
                    if lcRecCustomer.get(rec."Account No.") then
                        Rec."Check Name" := lcRecCustomer.Name;
                end;
            Rec."Account Type"::Employee:
                begin
                    if lcRecEmployee.get(rec."Account No.") then
                        Rec."Check Name" := lcRecEmployee.FullName();
                end;
        end;
    end;

    procedure fnShowCard(var Rec: Record "Payment Schedule")
    var
        Vend: Record Vendor;
        Cust: Record Customer;
        Emplo: Record Employee;
    begin
        CASE Rec."Type Source" OF
            Rec."Type Source"::"Employee Entries":
                BEGIN
                    Emplo."No." := Rec."VAT Registration No.";
                    PAGE.RUN(PAGE::"Employee Card", Emplo);
                END;
            Rec."Type Source"::"Customer Entries":
                BEGIN
                    Cust."No." := Rec."VAT Registration No.";
                    PAGE.RUN(PAGE::"Customer Card", Cust);
                END;
            Rec."Type Source"::"Vendor Entries":
                BEGIN
                    Vend."No." := Rec."VAT Registration No.";
                    PAGE.RUN(PAGE::"Vendor Card", Vend);
                END;
        END;

    end;

    procedure fnNavigate(var Rec: Record "Payment Schedule")
    var
        Navigate: Page Navigate;
    begin
        Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
        Navigate.RUN;
    end;

    var
        Error001: Label 'El campo de correo electronico debe cumplir con el formato.';
        recGeneralLedgerSetup: Record "General Ledger Setup";
        PaymentSchedule: Record "Payment Schedule";
        PostedPaymentSchedule: Record "Posted Payment Schedule";
        gRemittanceFiles: Record "ST Control File";
        gEntryNo: Integer;
        CheckSumBanco: BigInteger;
        GCompanyInfor: Record "Company Information";

        GenJournalLine: Record "Gen. Journal Line";
        Multiple: Boolean;
        FactProveedor: Text;
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        gReferenciaAdicional: Text[40];
        gchar1: Text;
        gchar2: Text;
        gPeruvianSetup: Record "Setup Localization";

        gStartDate: Date;
        gEndDate: Date;
        gCodeProcess: Code[20];
        gWindow: Dialog;
        TEXT001: Label 'Procesando Pendientes  #1########## @2@@@@@@@@@@@@@';
        Error002: Label 'Qty. Packed is greater than Qty. in Picking %1 for item %2';
        Error003: Label 'La cantidad ingresada soprepasa la cantidad del picking';
        Error004: Label 'El producto no corresponde al picking seleccionado';
        gText001: Label 'Procesando Pendientes  #1########## @2@@@@@@@@@@@@@';
        DimSetEntry: Record "Dimension Set Entry";
        GLSetupShortcutDimCode: array[10] of Code[20];
        Text000: Label 'Dimension combinations %1 - %2 and %3 - %4 can''t be used concurrently.';
        Text002: Label 'This Shortcut Dimension is not defined in the %1.';
        Text003: label '%1 is not an available %2 for that dimension.';
        Text014: Label '%1 %2 is blocked.';
        Text015: Label '%1 %2 can''t be found.';
        Text004: Label 'Select a %1 for the %2 %3.';
        Text016: Label '%1 %2 - %3 is blocked.';
        Text017: Label '%1 for %2 %3 - %4 must not be %5.';
        Text018: Label '%1 for %2 is missing.';
        DimErr: Text[250];
        HasGotGLSetup: Boolean;
}