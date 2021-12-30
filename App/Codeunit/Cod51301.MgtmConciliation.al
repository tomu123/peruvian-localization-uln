codeunit 51301 "Mgtm Conciliation"
{  //ULN::PC    002  Conciliación OBJECT CREATED
    trigger OnRun()
    begin

    end;

    procedure ImportBankStatementConciliation(BankAccRecon: Record "Bank Acc. Reconciliation"; DataExch: Record "Data Exch."): Boolean
    var
        BankAcc: Record "Bank Account";
        DataExchDef: Record "Data Exch. Def";
        DataExchMapping: Record "Data Exch. Mapping";
        DataExchLineDef: Record "Data Exch. Line Def";
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary;
        ProgressWindow: Dialog;
    begin
        BankAcc.Get(BankAccRecon."Bank Account No.");
        BankAcc.GetDataExchDefConciliation(DataExchDef);

        DataExch."Related Record" := BankAcc.RecordId;
        DataExch."Data Exch. Def Code" := DataExchDef.Code;

        if not DataExch.ImportToDataExchConciliation(DataExchDef) then
            exit(false);


        ProgressWindow.Open(ProgressWindowMsg);

        CreateBankAccRecLineTemplate(TempBankAccReconLine, BankAccRecon, DataExch);
        DataExchLineDef.SetRange("Data Exch. Def Code", DataExchDef.Code);
        DataExchLineDef.FindFirst;

        DataExchMapping.Get(DataExchDef.Code, DataExchLineDef.Code, DATABASE::"Bank Acc. Reconciliation Line");

        if DataExchMapping."Pre-Mapping Codeunit" <> 0 then
            CODEUNIT.Run(DataExchMapping."Pre-Mapping Codeunit", TempBankAccReconLine);

        DataExchMapping.TestField("Mapping Codeunit");
        CODEUNIT.Run(DataExchMapping."Mapping Codeunit", TempBankAccReconLine);

        if DataExchMapping."Post-Mapping Codeunit" <> 0 then
            CODEUNIT.Run(DataExchMapping."Post-Mapping Codeunit", TempBankAccReconLine);

        InsertNonReconciledNonImportedLines(TempBankAccReconLine, GetStatementLineNoOffset(BankAccRecon));

        ProgressWindow.Close;
        OnAfterImportBankStatement(TempBankAccReconLine, DataExch);
        exit(true);
    end;

    procedure CreateBankAccRecLineTemplate(var BankAccReconLine: Record "Bank Acc. Reconciliation Line"; BankAccRecon: Record "Bank Acc. Reconciliation"; DataExch: Record "Data Exch.")
    begin
        BankAccReconLine.Init();
        BankAccReconLine."Statement Type" := BankAccRecon."Statement Type";
        BankAccReconLine."Statement No." := BankAccRecon."Statement No.";
        BankAccReconLine."Bank Account No." := BankAccRecon."Bank Account No.";
        BankAccReconLine."Data Exch. Entry No." := DataExch."Entry No.";
    end;

    local procedure InsertNonReconciledNonImportedLines(var TempBankAccReconLine: Record "Bank Acc. Reconciliation Line" temporary; StatementLineNoOffset: Integer)
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        if TempBankAccReconLine.FindSet then
            repeat
                if TempBankAccReconLine.CanImport then begin
                    BankAccReconciliationLine := TempBankAccReconLine;
                    BankAccReconciliationLine."Statement Line No." += StatementLineNoOffset;
                    BankAccReconciliationLine.Insert();
                end;
            until TempBankAccReconLine.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterImportBankStatement(BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line"; DataExch: Record "Data Exch.")
    begin
    end;

    local procedure GetStatementLineNoOffset(BankAccRecon: Record "Bank Acc. Reconciliation"): Integer
    var
        BankAccReconLine: Record "Bank Acc. Reconciliation Line";
    begin
        BankAccReconLine.SetRange("Statement Type", BankAccRecon."Statement Type");
        BankAccReconLine.SetRange("Statement No.", BankAccRecon."Statement No.");
        BankAccReconLine.SetRange("Bank Account No.", BankAccRecon."Bank Account No.");
        if BankAccReconLine.FindLast then
            exit(BankAccReconLine."Statement Line No.");
        exit(0)
    end;


    procedure fnFormatConciliation(var pDataExch: Record "Data Exch."; var pDataExchDef: Record "Data Exch. Def")
    var
        lclInStream: InStream;
        lclOutStream: OutStream;
        lclLineTxt: text;
        lclLineTxtTemp: text;
        lclLineTxtFinal: text;
        lclLineTxtReviewComent: text;
        lclCuTempBlob: Codeunit "Temp Blob";
        lclLineCount: Integer;
        lclReadLines: Boolean;
        lclIsFotter: Boolean;
        lclSeparator: Text;
        lclastposition: Integer;
        lclTotalLines: Integer;
        lclRecDataExchLineDef: Record "Data Exch. Line Def";
        lclRecDataExchColumnDef: Record "Data Exch. Column Def";
        FileName: Text;
        TestFile: File;
    begin

        if not pDataExchDef."ST Adjust Format" then
            exit;
        // Starting a loop  
        pDataExch."File Content".CreateInStream(lclInStream);

        lclCuTempBlob.CreateOutStream(lclOutStream);

        case pDataExchDef."Column Separator" OF
            pDataExchDef."Column Separator"::Comma:
                lclSeparator := ',';
            pDataExchDef."Column Separator"::Custom:
                lclSeparator := pDataExchDef."Custom Column Separator";
            pDataExchDef."Column Separator"::Semicolon:
                lclSeparator := ';';
            pDataExchDef."Column Separator"::Space:
                lclSeparator := ' ';
        end;

        lclRecDataExchLineDef.Reset();
        lclRecDataExchLineDef.SetRange("Data Exch. Def Code", pDataExch."Data Exch. Def Code");
        lclRecDataExchLineDef.FindSet();


        //Read lines 
        WHILE NOT (lclInStream.EOS) DO BEGIN
            lclLineTxt := '';
            lclLineTxtFinal := '';
            lclLineTxtReviewComent := '';
            lclLineCount += 1;
            lclastposition := 1;

            if (lclLineCount > pDataExchDef."ST Header Lines") or (pDataExchDef."ST Header Lines" = 0) then
                lclReadLines := true;



            lclInStream.READTEXT(lclLineTxt);

            IF pDataExchDef."ST Footer Tag" <> '' THEN
                if StrPos(lclLineTxt, pDataExchDef."ST Footer Tag") > 0 then
                    lclIsFotter := true;

            if lclIsFotter then
                lclReadLines := false;

            if lclReadLines then begin
                lclRecDataExchColumnDef.Reset();
                lclRecDataExchColumnDef.SetRange("Data Exch. Def Code", lclRecDataExchLineDef."Data Exch. Def Code");
                lclRecDataExchColumnDef.SetRange("Data Exch. Line Def Code", lclRecDataExchLineDef.Code);
                if lclRecDataExchColumnDef.FindSet() then
                    repeat


                        lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, lclRecDataExchColumnDef.Length);
                        lclastposition += lclRecDataExchColumnDef.Length;
                        lclLineTxtTemp := lclLineTxtTemp.Trim();


                        case lclRecDataExchColumnDef."Data Type" of
                            lclRecDataExchColumnDef."Data Type"::Date:
                                fnFormateDate(lclLineTxtTemp);
                        end;
                        //Limpiamos almohadillas
                        case lclRecDataExchColumnDef."Pad Character" of
                            '':
                                lclLineTxtTemp := lclLineTxtTemp.Trim();
                            ELSE
                                lclLineTxtTemp := DelChr(lclLineTxtTemp.Trim(), '=', lclRecDataExchColumnDef."Pad Character");
                        end;
                        //Revisamos si es una linea no valida
                        if lclRecDataExchColumnDef."Column No." < 3 then
                            lclLineTxtReviewComent += lclLineTxtTemp.Trim();

                        lclLineTxtTemp := lclLineTxtTemp.Trim() + ';';
                        lclLineTxtFinal += lclLineTxtTemp;
                    until lclRecDataExchColumnDef.Next() = 0;

                //Revisamos si es una linea no es de comentario
                if (lclLineTxtReviewComent.Trim()) <> '' then begin
                    lclOutStream.WriteText(lclLineTxtFinal);
                    lclOutStream.WriteText();
                    //Insertamos Linea ITF
                    fnInsertLineItf(lclLineTxtFinal, pDataExchDef, lclOutStream);
                end;

            end;

        end;

        Clear(lclInStream);
        FileName := 'FileTexting.txt';

        lclCuTempBlob.CreateInStream(lclInStream);

        //Reemplazamos Archivos
        Clear(lclOutStream);
        pDataExch."File Content".CreateOutStream(lclOutStream);
        CopyStream(lclOutStream, lclInStream);
        //DownloadFromStream(lclInStream, '', '', '', FileName);

    end;

    procedure fnInsertLineItf(pLineTxt: Text; var pDataExchDef: Record "Data Exch. Def"; var pOutStream: OutStream)
    var
        lclArrayLine: List of [Text];
        lclValueText: Text;
        lclArrayLinetxt: Text;
        lclBucle: Integer;
    begin

        if not pDataExchDef."ST ITF" then
            exit;
        if pDataExchDef."ST ITF Column" = 0 then
            exit;

        lclArrayLine := pLineTxt.Split(';');

        lclValueText := lclArrayLine.Get(pDataExchDef."ST ITF Column");

        if lclValueText <> '' then begin
            lclArrayLine.Set(pDataExchDef."ST ITF Column Amount", '-' + lclValueText);
            //Descripcion ITF
            if STRPOS(gBankCode, 'BBVA') > 0 then begin
                lclArrayLine.Set(6, 'IMPUESTO ITF');
            end;

            for lclBucle := 1 to lclArrayLine.Count do begin
                lclArrayLinetxt += lclArrayLine.Get(lclBucle) + ';';
            end;


            pOutStream.WriteText(lclArrayLinetxt);
            pOutStream.WriteText();
        end;

    end;

    procedure fnFormateDate(var pTextDate: Text)
    var
        lclSymbolSeparator: Text;
        lclLongMin: Integer;
        lclyear: Integer;
    begin
        if pTextDate = '' then
            exit;

        lclyear := Date2DMY(WorkDate, 3);

        if StrPos(pTextDate, '/') > 0 then
            lclSymbolSeparator := '/';
        if StrPos(pTextDate, '-') > 0 then
            lclSymbolSeparator := '-';


        case lclSymbolSeparator OF
            '':
                lclLongMin := 8;
            else
                lclLongMin := 10;
        end;

        if StrLen(pTextDate) < lclLongMin then
            case lclSymbolSeparator OF
                '':
                    pTextDate := pTextDate + format(lclyear);
                else
                    pTextDate := pTextDate + lclSymbolSeparator + format(lclyear);
            end;
    end;

    procedure fnFormateDate2(var pTextDate: Text)
    var
        lclSymbolSeparator: Text;
        lclLongMin: Integer;
        lclyear: Integer;
    begin
        if pTextDate = '' then
            exit;

        lclyear := Date2DMY(WorkDate, 3);

        if StrPos(pTextDate, '/') > 0 then
            lclSymbolSeparator := '/';
        if StrPos(pTextDate, '-') > 0 then
            lclSymbolSeparator := '-';


        case lclSymbolSeparator OF
            '':
                lclLongMin := 8;
            else
                lclLongMin := 10;
        end;

        if StrLen(pTextDate) < lclLongMin then
            case lclSymbolSeparator OF
                '':
                    pTextDate := pTextDate + format(lclyear);
                else
                    pTextDate := pTextDate + lclSymbolSeparator + format(lclyear);
            end;

        pTextDate := pTextDate.Replace('-', '/')
    end;

    procedure ImportExtractbank(pBankCode: code[20])
    var
        AttachmentRec: Record Attachment;
        FileOutStream: OutStream;
        FileInStream: InStream;
        FileInStreamReview: InStream;
        tempfilename: text;
        DialogTitle: Label 'Please select a File...', Comment = 'ESM="Seleccione un archivo"';
        RecRef: RecordRef;
        lclUploadIntoBool: Boolean;
        lclBank: Record "Bank Account";
        lclSeparator: Text;
        lclLineTxt: text;
        lclLineTxtTemp: text;
        lclLineTxtFinal: text;
        lclLineTxtReviewComent: text;
        lclLineCount: Integer;
        lclReadLines: Boolean;
        lclIsFotter: Boolean;
        lclastposition: Integer;
        lclTotalLines: Integer;
        lclCuTempBlob: Codeunit "Temp Blob";
        lclOutStream: OutStream;
        lclInStream: InStream;
        lclArrayTemp: List of [Text];
        lclCharacter: Label '';
    begin
        lclBank.get(pBankCode);
        gBankCode := '';
        gBankCode := pBankCode;
        lclBank.TestField("Import Format Statement");
        gBankExportImportSetup.get(lclBank."Import Format Statement");
        gDataExchDef.get(gBankExportImportSetup."Data Exch. Def. Code");

        lclUploadIntoBool := false;
        if UploadIntoStream(DialogTitle, '', 'All Files (*.*)|*.*', tempfilename, FileInStream) then begin

            gCuTempFileBlob.CreateOutStream(FileOutStream);
            CopyStream(FileOutStream, FileInStream);
            gCuTempFileBlob.CreateInStream(FileInStreamReview);
            fnReviewBankAccount(FileInStreamReview);
            lclUploadIntoBool := true;
        end;

        if not lclUploadIntoBool then
            exit;



        lclCuTempBlob.CreateOutStream(lclOutStream);
        //Revisamos Archivo

        case gDataExchDef."Column Separator" OF
            gDataExchDef."Column Separator"::Comma:
                lclSeparator := ',';
            gDataExchDef."Column Separator"::Custom:
                lclSeparator := gDataExchDef."Custom Column Separator";
            gDataExchDef."Column Separator"::Semicolon:
                lclSeparator := ';';
            gDataExchDef."Column Separator"::Space:
                lclSeparator := ' ';
        end;

        gRecDataExchLineDef.Reset();
        gRecDataExchLineDef.SetRange("Data Exch. Def Code", gBankExportImportSetup."Data Exch. Def. Code");
        gRecDataExchLineDef.FindSet();

        gCuTempFileBlob.CreateInStream(FileInStream);
        //Read lines 
        WHILE NOT (FileInStream.EOS) DO BEGIN
            lclLineTxt := '';
            lclLineTxtFinal := '';
            lclLineTxtReviewComent := '';
            lclLineCount += 1;
            lclastposition := 1;

            case gDataExchDef."ST Adjust Format" of
                true:
                    begin
                        if (lclLineCount > gDataExchDef."ST Header Lines") or (gDataExchDef."ST Header Lines" = 0) then
                            lclReadLines := true;
                    end;
                false:
                    begin
                        if (lclLineCount > gDataExchDef."Header Lines") or (gDataExchDef."Header Lines" = 0) then
                            lclReadLines := true;
                    end;
            end;




            FileInStream.READTEXT(lclLineTxt);

            IF gDataExchDef."ST Footer Tag" <> '' THEN
                if StrPos(lclLineTxt, gDataExchDef."ST Footer Tag") > 0 then
                    lclIsFotter := true;

            if lclIsFotter then
                lclReadLines := false;

            if lclReadLines then begin
                gRecDataExchColumnDef.Reset();
                gRecDataExchColumnDef.SetRange("Data Exch. Def Code", gRecDataExchLineDef."Data Exch. Def Code");
                gRecDataExchColumnDef.SetRange("Data Exch. Line Def Code", gRecDataExchLineDef.Code);
                if gRecDataExchColumnDef.FindSet() then
                    repeat
                        if STRPOS(pBankCode, 'BCP') > 0 then begin
                            lclLineTxt := lclLineTxt.Replace('","', 'XYZ');
                            lclSeparator := 'XYZ';
                        end;
                        case gDataExchDef."ST Adjust Format" of
                            true:
                                begin
                                    if STRPOS(pBankCode, 'BCP') > 0 then begin
                                        lclArrayTemp := lclLineTxt.Split(lclSeparator);
                                        lclLineTxtTemp := lclArrayTemp.Get(gRecDataExchColumnDef."Column No.");

                                    end;
                                    if STRPOS(pBankCode, 'GEN') > 0 then begin
                                        lclArrayTemp := lclLineTxt.Split(lclSeparator);
                                        lclLineTxtTemp := lclArrayTemp.Get(gRecDataExchColumnDef."Column No.");

                                    end;
                                    if STRPOS(gBankCode, 'BBVA') > 0 then begin
                                        lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);
                                    end;

                                    if STRPOS(gBankCode, 'BIF') > 0 then begin
                                        lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);
                                        IF gRecDataExchColumnDef."Column No." = 11 then
                                            lclLineTxtTemp := '-0' + lclLineTxtTemp;
                                    end;

                                    if STRPOS(gBankCode, 'IBK') > 0 then begin
                                        lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);
                                        IF gRecDataExchColumnDef."Column No." = 12 then
                                            lclLineTxtTemp := '-0' + lclLineTxtTemp.Trim();
                                    end;
                                    if STRPOS(gBankCode, 'SBP') > 0 then begin
                                        lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);
                                    end;
                                    //  lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);


                                end;
                            false:
                                begin
                                    lclArrayTemp := lclLineTxt.Split(lclSeparator);
                                    lclLineTxtTemp := lclArrayTemp.Get(gRecDataExchColumnDef."Column No.");

                                end;

                        END;
                        //   lclLineTxtTemp := CopyStr(lclLineTxt, lclastposition, gRecDataExchColumnDef.Length);
                        lclastposition += gRecDataExchColumnDef.Length;
                        lclLineTxtTemp := lclLineTxtTemp.Trim();



                        //Limpiamos almohadillas
                        case gRecDataExchColumnDef."Pad Character" of
                            '':
                                lclLineTxtTemp := lclLineTxtTemp.Trim();
                            ELSE
                                lclLineTxtTemp := DelChr(lclLineTxtTemp.Trim(), '=', gRecDataExchColumnDef."Pad Character");
                        end;
                        //Revisamos Fecha
                        case gRecDataExchColumnDef."Data Type" of
                            gRecDataExchColumnDef."Data Type"::Date:
                                fnFormateDate2(lclLineTxtTemp);
                        end;
                        //Revisamos si es una linea no valida
                        if gRecDataExchColumnDef."Column No." < 3 then
                            lclLineTxtReviewComent += lclLineTxtTemp.Trim();

                        lclLineTxtTemp := lclLineTxtTemp.Trim() + ';';
                        lclLineTxtFinal += lclLineTxtTemp;
                    until gRecDataExchColumnDef.Next() = 0;

                //Revisamos si es una linea no es de comentario
                if (lclLineTxtReviewComent.Trim()) <> '' then begin
                    lclOutStream.WriteText(lclLineTxtFinal);
                    lclOutStream.WriteText();
                    //Insertamos Linea ITF
                    fnInsertLineItf(lclLineTxtFinal, gDataExchDef, lclOutStream);
                end;

            end;

        end;
        lclCuTempBlob.CreateInStream(lclInStream);
        fnReviewExtractbank(lclInStream);
        lclCuTempBlob.CreateInStream(lclInStream);
        fnInserttExtractbank(lclInStream);
    end;

    procedure fnReviewExtractbank(pInStream: InStream)
    var
        lclLineTxt: Text;
        ArrayLine: List of [Text];
        lclLineColum: Integer;
        lclLineNumber: Integer;
        lclTextValue: Text;
        lclReviewDate: Date;
        lclReviewDateTime: DateTime;
        lclReviewDecimal: Decimal;
        lclText001: Label 'The value of column %1 must be %2 , invalid value %3, Line %4', Comment = 'ESM="El valor de la columna %1 debe ser %2 , valor %3 no valido , Linea %4"';
        lclRecDataExchFieldMapping: Record "Data Exch. Field Mapping";
        lclisOptional: Boolean;

    begin
        lclLineNumber := 0;
        WHILE NOT (pInStream.EOS) DO BEGIN
            pInStream.READTEXT(lclLineTxt);
            ArrayLine := lclLineTxt.Split(';');
            lclLineNumber += 1;
            gRecDataExchColumnDef.Reset();
            gRecDataExchColumnDef.SetRange("Data Exch. Def Code", gRecDataExchLineDef."Data Exch. Def Code");
            gRecDataExchColumnDef.SetRange("Data Exch. Line Def Code", gRecDataExchLineDef.Code);
            if gRecDataExchColumnDef.FindSet() then
                repeat

                    lclTextValue := ArrayLine.Get(gRecDataExchColumnDef."Column No.");
                    lclRecDataExchFieldMapping.Reset();
                    lclRecDataExchFieldMapping.SetRange("Data Exch. Def Code", gRecDataExchLineDef."Data Exch. Def Code");
                    lclRecDataExchFieldMapping.SetRange("Data Exch. Line Def Code", gRecDataExchLineDef.Code);
                    lclRecDataExchFieldMapping.SetRange("Table ID", 51039);
                    lclRecDataExchFieldMapping.SetRange("Column No.", gRecDataExchColumnDef."Column No.");
                    if lclRecDataExchFieldMapping.FindSet() then
                        lclisOptional := lclRecDataExchFieldMapping.Optional
                    else
                        lclisOptional := true;

                    //Si no es opcional
                    if not lclisOptional then begin


                        case gRecDataExchColumnDef."Data Type" OF
                            gRecDataExchColumnDef."Data Type"::Date:
                                begin
                                    lclTextValue := fnReviewDate(lclTextValue);
                                    IF NOT Evaluate(lclReviewDate, lclTextValue) then
                                        Error(StrSubstNo(lclText001, gRecDataExchColumnDef."Column No.", Format(gRecDataExchColumnDef."Data Type"), lclTextValue, lclLineNumber));
                                end;
                            gRecDataExchColumnDef."Data Type"::DateTime:
                                begin
                                    IF NOT Evaluate(lclReviewDateTime, lclTextValue) then
                                        Error(StrSubstNo(lclText001, gRecDataExchColumnDef."Column No.", Format(gRecDataExchColumnDef."Data Type"), lclTextValue, lclLineNumber));

                                end;
                            gRecDataExchColumnDef."Data Type"::Decimal:
                                begin
                                    IF (StrPos(lclTextValue, '+') = 0) AND (StrPos(lclTextValue, '-') = 0) then
                                        lclTextValue := '0' + lclTextValue;
                                    IF NOT Evaluate(lclReviewDecimal, lclTextValue) then
                                        Error(StrSubstNo(lclText001, gRecDataExchColumnDef."Column No.", Format(gRecDataExchColumnDef."Data Type"), lclTextValue, lclLineNumber));

                                end;
                        end
                    end;
                until gRecDataExchColumnDef.Next() = 0;

        end;
    end;

    procedure fnReviewDate(ptext: Text): Text
    var
        lclDia: Text;
        lclAnio: Text;
        lclMes: Text;
    begin
        if gRecDataExchColumnDef."Data Format" <> 'yyyymmdd' then
            EXIT(ptext);

        IF gRecDataExchColumnDef."Data Format" = 'yyyymmdd' then begin
            lclAnio := CopyStr(ptext, 1, 4);
            lclMes := CopyStr(ptext, 5, 2);
            lclDia := CopyStr(ptext, 7, 2);
            ptext := lclDia + '/' + lclMes + '/' + lclAnio;

        end;

        exit(ptext);
    end;

    procedure fnInserttExtractbank(pInStream: InStream)
    var
        lclLineTxt: Text;
        ArrayLine: List of [Text];
        lclLineColum: Integer;
        lclRecDataExchFieldMapping: Record "Data Exch. Field Mapping";
        lclRecRef: RecordRef;
        lclFieldRef: FieldRef;
        lclTextValue: Text;
        lclTextValueReview: Text;
        lclReviewDate: Date;
        lclReviewDateTime: DateTime;
        lclReviewDecimal: Decimal;
        lclRecExtractTheBank: Record "Extract The Bank";
        lineNo: Integer;
    begin
        lclRecExtractTheBank.Reset();
        //lclRecExtractTheBank.SetAscending("Statement Line No.", true);
        if lclRecExtractTheBank.FindLast() then
            lineNo += lclRecExtractTheBank."Statement Line No.";

        lclRecRef.Open(51039);
        WHILE NOT (pInStream.EOS) DO BEGIN
            pInStream.READTEXT(lclLineTxt);

            ArrayLine := lclLineTxt.Split(';');

            lclRecRef.INIT;
            lineNo += 1;
            lclRecDataExchFieldMapping.Reset();
            lclRecDataExchFieldMapping.SetRange("Data Exch. Def Code", gRecDataExchLineDef."Data Exch. Def Code");
            lclRecDataExchFieldMapping.SetRange("Data Exch. Line Def Code", gRecDataExchLineDef.Code);
            lclRecDataExchFieldMapping.SetRange("Table ID", 51039);
            if lclRecDataExchFieldMapping.FindSet() then
                repeat
                    lclTextValue := '';
                    lclFieldRef := lclRecRef.FIELD(lclRecDataExchFieldMapping."Field ID");
                    lclTextValue := ArrayLine.Get(lclRecDataExchFieldMapping."Column No.");


                    gRecDataExchColumnDef.Reset();
                    gRecDataExchColumnDef.SetRange("Data Exch. Def Code", gRecDataExchLineDef."Data Exch. Def Code");
                    gRecDataExchColumnDef.SetRange("Data Exch. Line Def Code", gRecDataExchLineDef.Code);
                    gRecDataExchColumnDef.SetRange("Column No.", lclRecDataExchFieldMapping."Column No.");
                    if gRecDataExchColumnDef.FindSet() then begin
                        case gRecDataExchColumnDef."Data Type" OF
                            gRecDataExchColumnDef."Data Type"::Date:
                                begin
                                    lclTextValue := fnReviewValues(lclTextValue);
                                    Evaluate(lclReviewDate, lclTextValue);
                                    lclFieldRef.Value := lclReviewDate;
                                end;
                            gRecDataExchColumnDef."Data Type"::DateTime:
                                begin
                                    Evaluate(lclReviewDateTime, lclTextValue);
                                    lclFieldRef.Value := lclReviewDateTime;
                                end;
                            gRecDataExchColumnDef."Data Type"::Decimal:
                                begin
                                    lclTextValue := fnReviewValues(lclTextValue);
                                    Evaluate(lclReviewDecimal, lclTextValue);
                                    if lclTextValue <> '0' then
                                        lclFieldRef.Value := lclReviewDecimal;
                                end;
                            gRecDataExchColumnDef."Data Type"::Text:
                                begin

                                    lclFieldRef.Value := lclTextValue;
                                end;
                        end;
                    end;
                until lclRecDataExchFieldMapping.Next() = 0;

            lclFieldRef := lclRecRef.FIELD(1);
            lclFieldRef.Value := gBankCode;
            lclFieldRef := lclRecRef.FIELD(20);
            lclFieldRef.Value := gStatementType::"Bank Reconciliation";
            lclFieldRef := lclRecRef.FIELD(3);
            lclFieldRef.Value := lineNo;
            lclRecRef.INSERT(true);
        end;
    end;

    procedure fnReviewValues(pText: Text): Text;
    begin
        case gRecDataExchColumnDef."Data Type" OF
            gRecDataExchColumnDef."Data Type"::Date:
                begin
                    pText := fnReviewDate(pText);
                end;
            gRecDataExchColumnDef."Data Type"::Decimal:
                begin
                    if pText = '' then
                        pText := '0';
                end;
        end;

        exit(pText);
    end;

    procedure fnImportExtractBank(pBankAccReconciliation: Record "Bank Acc. Reconciliation")
    var
        lclDialogPage: Page "Standard Dialog Page";
        lclStartDate: Date;
        lclEndDate: Date;
        lclRecExtractTheBank: Record "Extract The Bank";
        lclRecBankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        lclLineNo: Integer;
    begin
        Clear(lclDialogPage);
        lclDialogPage.SetType(1);
        lclDialogPage.LOOKUPMODE(TRUE);
        IF lclDialogPage.RUNMODAL IN [ACTION::OK, ACTION::LookupOK] THEN begin
            lclStartDate := lclDialogPage.GetStartDate();
            lclEndDate := lclDialogPage.GetEndDate();
        end;


        lclRecBankAccReconciliationLine.Reset();
        if lclRecBankAccReconciliationLine.FindLast() then
            lclLineNo += 1
        else
            lclLineNo += 1;

        lclRecExtractTheBank.Reset();
        lclRecExtractTheBank.SetFilter("Transaction Date", '%1..%2', lclStartDate, lclEndDate);
        lclRecExtractTheBank.SetRange(Closed, true);
        lclRecExtractTheBank.SetFilter(Description, '<>%1', '');

        lclRecExtractTheBank.SetRange("Bank Account No.", pBankAccReconciliation."Bank Account No.");
        if lclRecExtractTheBank.FindSet() then begin
            repeat
                lclLineNo += 1;
                lclRecBankAccReconciliationLine.Init();
                lclRecBankAccReconciliationLine.TransferFields(lclRecExtractTheBank);
                lclRecBankAccReconciliationLine."Bank Account No." := pBankAccReconciliation."Bank Account No.";
                lclRecBankAccReconciliationLine."Statement Type" := lclRecExtractTheBank."Statement Type"::"Bank Reconciliation";
                lclRecBankAccReconciliationLine."Statement No." := pBankAccReconciliation."Statement No.";
                lclRecBankAccReconciliationLine."Statement Line No." := lclLineNo;
                lclRecBankAccReconciliationLine."Import Extract The Bank" := true;
                lclRecBankAccReconciliationLine."EB Statement Line No." := lclRecExtractTheBank."Statement Line No.";
                lclRecBankAccReconciliationLine."Description 2" := lclRecExtractTheBank."Description 2";
                lclRecBankAccReconciliationLine.Insert();
                lclRecExtractTheBank.Reconciled := true;
            until lclRecExtractTheBank.Next() = 0;

        end;
    end;

    [EventSubscriber(ObjectType::Table, database::"Bank Account Statement Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventBASL(VAR Rec: Record "Bank Account Statement Line"; RunTrigger: Boolean)
    var
        lclExtractBank: Record "Extract The Bank";
    begin
        if Rec."Import Extract The Bank" then begin
            lclExtractBank.SetRange("Bank Account No.", Rec."Bank Account No.");
            lclExtractBank.SetRange("Document No.", Rec."Document No.");
            lclExtractBank.SetRange("Transaction Date", Rec."Transaction Date");
            lclExtractBank.SetRange("Statement Line No.", Rec."EB Statement Line No.");
            if lclExtractBank.FindSet() then
                lclExtractBank.Delete();
        end;
    end;

    local procedure fnReviewBankAccount(pInstream: InStream)
    var
        lclBankAccount: Record "Bank Account";
        lclLineText: Text;
        lclBankAccountNo: Text;
        lclBankAccountExist: Boolean;
        lcCompanyInformation: Record "Company Information";
        lclError: Label 'Cuenta Bancaria %1 no existe en archivo Importado , banco %2', Comment = 'ESM="Cuenta Bancaria %1 no existe en archivo Importado , banco %2"';
    begin
        lcCompanyInformation.Get();
        lclBankAccountExist := false;

        lclBankAccount.Get(gBankCode);

        if lclBankAccount."Process Bank" = lclBankAccount."Process Bank"::" " then
            exit;

        lclBankAccount.TestField("Bank Account No.");
        lclBankAccount.TestField("Process Bank");
        case lclBankAccount."Process Bank" of
            lclBankAccount."Process Bank"::BCP:
                lclBankAccountNo := copystr(lclBankAccount."Bank Account No.", 1, 3) + '-' + copystr(lclBankAccount."Bank Account No.", 4, 7) + '-' + copystr(lclBankAccount."Bank Account No.", 11, 1) + '-' + copystr(lclBankAccount."Bank Account No.", 12, 2);
            lclBankAccount."Process Bank"::INTERBANK:
                lclBankAccountNo := copystr(lclBankAccount."Bank Account No.", 4, StrLen(lclBankAccount."Bank Account No."));
            lclBankAccount."Process Bank"::BBVA:
                lclBankAccountNo := copystr(lclBankAccount."Bank Account No.", 1, 8) + copystr(lclBankAccount."Bank Account No.", 11, StrLen((lclBankAccount."Bank Account No.")));
            lclBankAccount."Process Bank"::BANBIF:
                lclBankAccountNo := lclBankAccount."Bank Account No.";
            lclBankAccount."Process Bank"::SCOTIA:
                begin
                    lcCompanyInformation.TestField("Bank Account No.");
                    lclBankAccountNo := lclBankAccount."Bank Account No.";
                    //JB :: El archivo que se importa recibe un 0 menos. 17/12/21
                    lclBankAccountNo := lclBankAccountNo.Substring(2);
                end;


        end;

        while not pInstream.EOS do begin
            pInstream.READTEXT(lclLineText);
            if StrPos(lclLineText, lclBankAccountNo) > 0 then
                lclBankAccountExist := true;
        end;

        if not lclBankAccountExist then
            Error(StrSubstNo(lclError, lclBankAccountNo, lclBankAccount."No."));
    end;

    var
        ProgressWindowMsg: Label 'Please wait while the operation is being completed.', Comment = 'ESM="Espere mientras se completa la operación."';
        gCuTempFileBlob:
                Codeunit "Temp Blob";
        gBankExportImportSetup:
                Record "Bank Export/Import Setup";
        gDataExchDef:
                Record "Data Exch. Def";
        gRecDataExchLineDef:
                Record "Data Exch. Line Def";
        gRecDataExchColumnDef:
                Record "Data Exch. Column Def";
        gBankCode: Code[20];
        gStatementType: Option "Bank Reconciliation","Payment Application";
}