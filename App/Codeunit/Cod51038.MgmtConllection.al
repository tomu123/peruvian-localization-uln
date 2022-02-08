codeunit 51038 "Mgmt Collection"
{
    trigger OnRun()
    begin
    end;

    var
        TempFileBlob: Codeunit "Temp Blob";
        ConstrutOutStream: OutStream;
        CompanyInformation: Record "Company Information";
        gTotalRecords: Integer;
        gTotalAmount: Decimal;
        CollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
        BankAccNoSBP: Text;
        SecuenceSBP: Text;
        TipoOperacionIBK: Text;
        TipoFormatoIBK: Text;
        BankCollection: Text;
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        BankAccReconciliationLineTemp: Record "Bank Acc. Reconciliation Line" temporary;

    procedure SetBankCollection(var pBankCollection: Text)
    begin
        BankCollection := pBankCollection;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Read Data Exch. from File", 'OnBeforeFileImport', '', false, false)]
    procedure SetFileImport(var TempBlob: Codeunit "Temp Blob"; var FileName: Text)
    var
    begin
        SLSetup.Get();
        if (SLSetup."Current Bank Selected" = '') or (SLSetup."Curr. Bank Selected User Id." <> UserId) then
            exit;

        ConvertTxtToCSV(SLSetup."Current Bank Selected", TempBlob, FileName);
    end;


    [EventSubscriber(ObjectType::Page, PAGE::"Pmt. Reconciliation Journals", 'OnAfterActionEvent', 'ImportBankTransactionsToNew', false, false)]
    procedure OnAfterActionEvent_PB1294(VAR Rec: Record "Bank Acc. Reconciliation")
    var
    begin
        fnInsertLinesNotCreate();
        SLSetup.Get();
        SLSetup."Curr. Bank Selected User Id." := '';
        SLSetup."Current Bank Selected" := '';
        SLSetup.Modify();
    end;

    local procedure TxtToDateFormat(pDateTxt: Text) rDateTxx: Text
    var
        MOnthTxt: Text;
        DayTxt: Text;
        YearTxt: Text;
    begin
        if pDateTxt <> '' then begin
            YearTxt := COPYSTR(pDateTxt, 1, 4);
            MOnthTxt := COPYSTR(pDateTxt, 5, 2);
            DayTxt := COPYSTR(pDateTxt, 7, 2);
            rDateTxx := DayTxt + '/' + MOnthTxt + '/' + YearTxt;
        end;
        exit(rDateTxx);
    end;


    procedure ConvertTxtToCSV(pCollectionBank: text; var pTempFileBlob: Codeunit "Temp Blob"; var pFileName: Text)
    var
        TXTInStr: InStream;
        CSVInStr: InStream;
        Buffer: Text;
        LineCounter: Integer;
        CSVBuffer: Record "CSV Buffer" temporary;
        DocumentNo: Text;
        Suministro: Text;
        SerieNo: text;
        DocNo: Text;
        TransactionNo: Text;
        DatoAdicional: Text;
        ProcessDate: Text;
        DueDate: Text;
        PaymentAmount: Text;
        PaymentAmountEntero: text;
        PaymentAmountDec: Text;
        Reference: Text;
        FileName: Text;
        recReconciliationLine: Record "Bank Acc. Reconciliation Line";
    begin
        UploadIntoStream('', '', '', pFileName, TXTInStr);
        LineCounter := 0;

        gReconciliationLineBuffer.DeleteAll();

        while not TXTInStr.EOS do begin
            TXTInStr.READTEXT(Buffer);
            //BEGIN ULN :: JB 10/01/2022
            //Description: Filtrar para interbank, si son PEN entonces solo usar '01', si es USD entonces solo '10'
            if not (((SLSetup."Curr. Bank Code Selected" = 'IBK-R-PEN') and (COPYSTR(Buffer, 8, 2) <> '01')) or
            ((SLSetup."Curr. Bank Code Selected" = 'IBK-R-USD') and (COPYSTR(Buffer, 8, 2) <> '10'))) then begin
                //END ULN :: JB 10/01/2022
                LineCounter += 1;
                if LineCounter = 1 then begin
                    case pCollectionBank of
                        'INTERBANK':
                            begin
                                DocumentNo := delchr(COPYSTR(Buffer, 38, 15), '=', ' ');
                                SerieNO := COPYSTR(DocumentNo, 1, 4);
                                DocNo := COPYSTR(DocumentNo, 5, 11);
                                DocumentNo := SerieNO + '-' + DocNo;
                                Suministro := COPYSTR(Buffer, 10, 19).Trim();
                                ProcessDate := COPYSTR(Buffer, 83, 8);
                                ProcessDate := TxtToDateFormat(ProcessDate);

                                PaymentAmount := COPYSTR(Buffer, 97, 13);
                                PaymentAmountEntero := COPYSTR(PaymentAmount, 1, 11);
                                PaymentAmountDec := COPYSTR(PaymentAmount, 12, 2);
                                TransactionNo := CopyStr(Buffer, 140, 8);
                                Reference := COPYSTR(Buffer, 53, 30);
                            end;
                    end;
                end;

                if (LineCounter > 1) then begin
                    case pCollectionBank of
                        'BCP':
                            begin
                                DocumentNo := delchr(COPYSTR(Buffer, 31, 27), '=', ' ');
                                Suministro := fnRemoveCero(COPYSTR(Buffer, 14, 14));
                                ProcessDate := COPYSTR(Buffer, 58, 8);
                                ProcessDate := TxtToDateFormat(ProcessDate);

                                DueDate := COPYSTR(Buffer, 66, 8);
                                DueDate := TxtToDateFormat(DueDate);

                                PaymentAmount := COPYSTR(Buffer, 74, 15);
                                PaymentAmountEntero := COPYSTR(PaymentAmount, 1, 13);
                                PaymentAmountDec := COPYSTR(PaymentAmount, 14, 2);
                                TransactionNo := CopyStr(Buffer, 125, 5);
                                Reference := COPYSTR(Buffer, 131, 22);
                            end;
                        'BBVA':
                            begin
                                DocumentNo := delchr(COPYSTR(Buffer, 66, 14), '=', ' ');
                                if (COPYSTR(DocumentNo, 1, 1) = '0') then
                                    DocumentNo := COPYSTR(DocumentNo, 1, 2) + '-' + COPYSTR(DocumentNo, 3, 4) + '-' + CopyStr(DocumentNo, 7, 8)
                                else
                                    DocumentNo := COPYSTR(DocumentNo, 1, 4) + '-' + COPYSTR(DocumentNo, 5, 10);

                                //SerieNO := COPYSTR(DocumentNo, 1, 4);
                                //DocNo := COPYSTR(DocumentNo, 5, 12);
                                //DocumentNo := SerieNO + '-' + DocNo;
                                Suministro := COPYSTR(Buffer, 33, 10);
                                ProcessDate := COPYSTR(Buffer, 136, 8);
                                ProcessDate := TxtToDateFormat(ProcessDate);

                                PaymentAmount := COPYSTR(Buffer, 81, 15);
                                PaymentAmountEntero := COPYSTR(PaymentAmount, 1, 13);
                                PaymentAmountDec := COPYSTR(PaymentAmount, 14, 2);
                                TransactionNo := CopyStr(Buffer, 130, 6);
                            end;
                        'SCOTIA':
                            begin
                                DocumentNo := delchr(COPYSTR(Buffer, 34, 15), '=', ' ');
                                //SerieNO := COPYSTR(DocumentNo, 1, 4);
                                //DocNo := COPYSTR(DocumentNo, 5, 11);
                                //DocumentNo := SerieNO + '-' + DocNo;
                                if (COPYSTR(DocumentNo, 1, 1) = '0') then
                                    DocumentNo := COPYSTR(DocumentNo, 1, 2) + '-' + COPYSTR(DocumentNo, 3, 4) + '-' + CopyStr(DocumentNo, 7, 9)
                                else
                                    DocumentNo := COPYSTR(DocumentNo, 1, 4) + '-' + COPYSTR(DocumentNo, 5, 11);

                                Suministro := COPYSTR(Buffer, 19, 12);
                                Suministro := DELCHR(Suministro, '=');
                                ProcessDate := COPYSTR(Buffer, 147, 8);
                                ProcessDate := TxtToDateFormat(ProcessDate);

                                PaymentAmount := COPYSTR(Buffer, 73, 11);
                                PaymentAmountEntero := COPYSTR(PaymentAmount, 1, 9);
                                PaymentAmountDec := COPYSTR(PaymentAmount, 10, 2);
                                TransactionNo := CopyStr(Buffer, 157, 13);
                                Reference := COPYSTR(Buffer, 170, 30);
                            end;
                        'INTERBANK':
                            begin
                                DocumentNo := delchr(COPYSTR(Buffer, 38, 15), '=', ' ');
                                //SerieNO := COPYSTR(DocumentNo, 1, 4);
                                //DocNo := COPYSTR(DocumentNo, 5, 11);
                                //DocumentNo := SerieNO + '-' + DocNo;
                                if (COPYSTR(DocumentNo, 1, 1) = '0') then
                                    DocumentNo := COPYSTR(DocumentNo, 1, 2) + '-' + COPYSTR(DocumentNo, 3, 4) + '-' + CopyStr(DocumentNo, 7, 9)
                                else
                                    DocumentNo := COPYSTR(DocumentNo, 1, 4) + '-' + COPYSTR(DocumentNo, 5, 11);

                                Suministro := COPYSTR(Buffer, 10, 19).Trim();
                                ProcessDate := COPYSTR(Buffer, 83, 8);
                                ProcessDate := TxtToDateFormat(ProcessDate);

                                PaymentAmount := COPYSTR(Buffer, 97, 13);
                                PaymentAmountEntero := COPYSTR(PaymentAmount, 1, 11);
                                PaymentAmountDec := COPYSTR(PaymentAmount, 12, 2);
                                TransactionNo := CopyStr(Buffer, 140, 8);
                                Reference := COPYSTR(Buffer, 53, 30);
                            end;
                    end;
                end;

                case pCollectionBank of
                    'BCP':
                        begin
                            if COPYSTR(Buffer, 1, 2) = 'DD' then begin//Lineas detalle
                                CSVBuffer.InsertEntry(LineCounter, 1, DocumentNo);
                                CSVBuffer.InsertEntry(LineCounter, 2, ProcessDate);
                                CSVBuffer.InsertEntry(LineCounter, 3, DueDate);
                                CSVBuffer.InsertEntry(LineCounter, 4, PaymentAmountEntero + '.' + PaymentAmountDec);
                                CSVBuffer.InsertEntry(LineCounter, 5, TransactionNo);
                                CSVBuffer.InsertEntry(LineCounter, 6, Reference);
                                CSVBuffer.InsertEntry(LineCounter, 7, Suministro);
                                //fnReviewDocument(DocumentNo, ProcessDate, DueDate, PaymentAmountEntero + '.' + PaymentAmountDec, TransactionNo, Reference, Suministro);
                            end;
                        end;
                    'BBVA':
                        begin
                            if COPYSTR(Buffer, 1, 2) = '02' then begin//Lineas detalle
                                CSVBuffer.InsertEntry(LineCounter, 1, DocumentNo);
                                CSVBuffer.InsertEntry(LineCounter, 2, ProcessDate);
                                CSVBuffer.InsertEntry(LineCounter, 3, DueDate);
                                CSVBuffer.InsertEntry(LineCounter, 4, PaymentAmountEntero + '.' + PaymentAmountDec);
                                CSVBuffer.InsertEntry(LineCounter, 5, TransactionNo);
                                CSVBuffer.InsertEntry(LineCounter, 6, Suministro);
                                //fnReviewDocument(DocumentNo, ProcessDate, DueDate, PaymentAmountEntero + '.' + PaymentAmountDec, TransactionNo, '', Suministro);

                            end;
                        end;
                    'SCOTIA':
                        begin
                            if COPYSTR(Buffer, 1, 1) = 'D' then begin//Lineas detalle
                                CSVBuffer.InsertEntry(LineCounter, 1, DocumentNo);
                                CSVBuffer.InsertEntry(LineCounter, 2, ProcessDate);
                                CSVBuffer.InsertEntry(LineCounter, 3, DueDate);
                                CSVBuffer.InsertEntry(LineCounter, 4, PaymentAmountEntero + '.' + PaymentAmountDec);
                                CSVBuffer.InsertEntry(LineCounter, 5, TransactionNo);
                                CSVBuffer.InsertEntry(LineCounter, 6, Reference);
                                CSVBuffer.InsertEntry(LineCounter, 7, Suministro);
                                //fnReviewDocument(DocumentNo, ProcessDate, DueDate, PaymentAmountEntero + '.' + PaymentAmountDec, TransactionNo, Reference, Suministro);

                            end;
                        end;
                    'INTERBANK':
                        begin
                            CSVBuffer.InsertEntry(LineCounter, 1, DocumentNo);
                            CSVBuffer.InsertEntry(LineCounter, 2, ProcessDate);
                            CSVBuffer.InsertEntry(LineCounter, 3, DueDate);
                            CSVBuffer.InsertEntry(LineCounter, 4, PaymentAmountEntero + '.' + PaymentAmountDec);
                            CSVBuffer.InsertEntry(LineCounter, 5, TransactionNo);
                            CSVBuffer.InsertEntry(LineCounter, 6, Reference);
                            CSVBuffer.InsertEntry(LineCounter, 7, Suministro);
                            //fnReviewDocument(DocumentNo, ProcessDate, DueDate, PaymentAmountEntero + '.' + PaymentAmountDec, TransactionNo, Reference, Suministro);
                        end;
                end;
            end;
        end;

        CSVBuffer.SaveDataToBlob(pTempFileBlob, ';');

        pFileName := pCollectionBank + Format(Today) + '.csv';
        pTempFileBlob.CREATEINSTREAM(CSVInStr);

        // DOWNLOADFROMSTREAM(CSVInStr, '', '', '', FileName);
    end;

    local procedure fnReviewDocument(pDocumentNo: Text; pProcessDate: Text;
    pDueDate: Text; pPaymentAmountEntero: Text;
    pTransactionNo: Text; pReference: Text; pSuministro: Text);
    var
        lclRecCustLedgerEntry: Record "Cust. Ledger Entry";

    begin


        SLSetup.Get();
        gStatementLine += 10000;
        gReconciliationLineBuffer.Init();
        gReconciliationLineBuffer."Statement Line No." := gStatementLine;
        gReconciliationLineBuffer."Bank Account No." := SLSetup."Curr. Bank Code Selected";
        gReconciliationLineBuffer."Statement No." := SLSetup."Curr. Bank Statement No";
        gReconciliationLineBuffer."Statement Type" := gReconciliationLineBuffer."Statement Type"::"Payment Application";
        gReconciliationLineBuffer."Document No." := pDocumentNo;
        Evaluate(gReconciliationLineBuffer."Transaction Date", pProcessDate);
        Evaluate(gReconciliationLineBuffer."Value Date", pDueDate);
        Evaluate(gReconciliationLineBuffer."Statement Amount", pPaymentAmountEntero);
        Evaluate(gReconciliationLineBuffer.Difference, pPaymentAmountEntero);
        Evaluate(gReconciliationLineBuffer.Difference, pPaymentAmountEntero);
        gReconciliationLineBuffer."Transaction ID" := pTransactionNo;
        gReconciliationLineBuffer."Transaction Text" := pReference;
        gReconciliationLineBuffer."Suministro No" := pSuministro.Trim();
        gReconciliationLineBuffer.Insert();
    end;

    local procedure fnInsertLinesNotCreate()
    var
        BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
        lclStatementLine: Integer;
        lclBankAccReconciliation: Record "Bank Acc. Reconciliation";
        lclCuMatchBank: Codeunit "Match Bank Payments";
    begin
        SLSetup.Get();


        if not gReconciliationLineBuffer.FindSet() then
            exit;

        BankAccReconciliationLine.Reset();
        BankAccReconciliationLine.SetAscending("Statement Line No.", true);
        BankAccReconciliationLine.SetRange("Bank Account No.", SLSetup."Curr. Bank Code Selected");
        BankAccReconciliationLine.SetRange("Statement Type", BankAccReconciliationLine."Statement Type"::"Payment Application");
        if BankAccReconciliationLine.FindLast() then
            lclStatementLine += BankAccReconciliationLine."Statement Line No." + 10000;

        Commit();
        if gReconciliationLineBuffer.FindSet() then
            repeat
                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Bank Account No.", SLSetup."Curr. Bank Code Selected");
                BankAccReconciliationLine.SetRange("Statement No.", SLSetup."Curr. Bank Statement No");
                BankAccReconciliationLine.SetRange("Statement Type", BankAccReconciliationLine."Statement Type"::"Payment Application");
                // BankAccReconciliationLine.SetRange("Transaction Text", gReconciliationLineBuffer."Transaction Text");
                BankAccReconciliationLine.SetRange("Statement Amount", gReconciliationLineBuffer."Statement Amount");
                BankAccReconciliationLine.SetRange("Suministro No", gReconciliationLineBuffer."Suministro No");

                if not BankAccReconciliationLine.FindSet() then begin
                    lclStatementLine += 10000;
                    BankAccReconciliationLine.Init();
                    BankAccReconciliationLine.TransferFields(gReconciliationLineBuffer);
                    BankAccReconciliationLine."Statement Line No." := lclStatementLine;
                    BankAccReconciliationLine.Insert(true);
                end;

            until gReconciliationLineBuffer.Next() = 0;

        lclBankAccReconciliation.Reset();
        lclBankAccReconciliation.SetRange("Bank Account No.", SLSetup."Curr. Bank Code Selected");
        if lclBankAccReconciliation.FindSet() then
            lclBankAccReconciliation.ProcessStatement(lclBankAccReconciliation);
    end;

    procedure FindStructureCust(pCustNo: Code[20]) rBankAccountNo: Code[10]
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";
    begin
        rBankAccountNo := '';
        if Customer.get(pCustNo) then
            if CustomerBankAccount.Get(pCustNo, Customer."Preferred Bank Account Code") then
                rBankAccountNo := CustomerBankAccount."Reference Bank Acc. No.";
        exit(rBankAccountNo);
    end;

    procedure SetTotal(var pTotalRecords: Integer;
                        var pTotalAmount: Decimal)
    var
    begin
        gTotalAmount := pTotalAmount;
        gTotalRecords := pTotalRecords;
    end;

    procedure GenerateFilePaymentCollection(var ControlFile: Record "ST Control File";
                                            var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary;
                                            pCollectionBank: Text;
                                            pBankNo: code[20])
    var
        lclNumberRecords: Integer;
        lclCampos: Text;
        IsExistsFile: Boolean;
        lclTotalRecord: Integer;
        lclRow: Integer;
        lclFecha: Date;
        lclFileName: Text;
        pProcessDate: Date;
        i: Integer;
        pTRecord: Text;
        TFileRecord: text;
        pCurrencyCode: Text;
        p1294: page 1294;
        lclCompany: Record "Company Information";
    begin
        if NOT CONFIRM('Desea generar txt, cobranzas - recaudación', true) then
            exit;

        CompanyInformation.get;
        lclCampos := '';
        lclRow := 0;


        case pCollectionBank of
            'BCP':
                CreateTempFile(false);
            'BBVA':
                CreateTempFile(false);
            'SCOTIA':
                CreateTempFile(true);
            'INTERBANK':
                CreateTempFile(true);
            'BANBIF':
                CreateTempFile(true);
            else
                CreateTempFile(true);
        end;
        //PC 30.06.21 MORA+++++++++++
        gGeneratearrears := false;
        case pCollectionBank of
            'BANBIF':
                begin
                    pRecCollectionBuffer.Reset();
                    pRecCollectionBuffer.SetFilter("Due Date", '..%1', WorkDate());
                    if pRecCollectionBuffer.FindSet() then
                        if Confirm('desea generar el cobro de mora', true) then
                            gGeneratearrears := true;
                end;
        end;
        //PC 30.06.21---------
        pRecCollectionBuffer.Reset();
        pRecCollectionBuffer.SetFilter("No. Suministro", '<>%1', '');
        if pRecCollectionBuffer.FindFirst() then begin
            lclTotalRecord := pRecCollectionBuffer.Count;
            gTotalRecords := pRecCollectionBuffer.Count;
            repeat
                lclCampos := '';
                pTRecord := pRecCollectionBuffer."Post Type";
                TFileRecord := pRecCollectionBuffer."Post File";

                pRecCollectionBuffer.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                pCurrencyCode := pRecCollectionBuffer."Currency Code";
                IsExistsFile := true;
                lclRow += 1;
                case pCollectionBank of
                    'BCP':
                        begin
                            //Make Header
                            lclCampos := '';
                            if lclRow = 1 then begin
                                lclCampos := BCPHeaderStructure(pBankNo, Today, gTotalRecords, gTotalAmount, TFileRecord);
                                InsertLineToTempFile(lclCampos);
                            end;
                            // Make Detail
                            IF lclRow >= 1 THEN begin
                                lclCampos := BCPLineStructure(pRecCollectionBuffer, pBankNo, pTRecord);
                                InsertLineToTempFile(lclCampos);
                            end;
                        end;
                    'BBVA':
                        begin
                            lclCampos := '';
                            //Make Header
                            if lclRow = 1 then begin
                                lclCampos := BBVAHeaderStructure(pBankNo, pCurrencyCode, '', pTRecord);
                                InsertLineToTempFile(lclCampos);
                            end;
                            // Make Detail
                            IF lclRow >= 1 then begin
                                lclCampos := BBVALineStructure(pRecCollectionBuffer);
                                InsertLineToTempFile(lclCampos);
                            end;
                            // Make LastRow
                            IF lclRow = gTotalRecords then begin
                                lclCampos := BBVATotalStructure(gTotalRecords, gTotalAmount);
                                InsertLineToTempFile(lclCampos);
                            end;
                        end;
                    'SCOTIA':
                        begin
                            lclCampos := '';
                            //Post H
                            if lclRow = 1 then begin
                                pProcessDate := Today;
                                lclCampos := SCOTIAHeaderStructure(pProcessDate, pBankNo, pCurrencyCode, gTotalRecords, gTotalAmount);
                                InsertLineToTempFile(lclCampos);
                            end;
                            // Post D
                            IF lclRow >= 1 THEN begin
                                lclCampos := SCOTIALineStructure(pRecCollectionBuffer, pBankNo, pCurrencyCode, pTRecord);
                                InsertLineToTempFile(lclCampos);
                            end;
                            //Post C
                            IF lclRow = gTotalRecords then begin
                                lclCampos := SCOTIATotalStructure(pBankNo, pCurrencyCode);
                                InsertLineToTempFile(lclCampos);
                            end;
                        end;
                    'INTERBANK':
                        begin
                            lclCampos := '';
                            //Post Header
                            if lclRow = 1 then begin
                                lclCampos := INTERBANKHeaderStructure(Today, pCurrencyCode, gTotalRecords, gTotalAmount, TFileRecord);
                                InsertLineToTempFile(lclCampos);
                            end;
                            // Post Quota/Detail
                            IF lclRow >= 1 THEN begin
                                lclCampos := INTERBANKQuotaPostStructure(pRecCollectionBuffer);
                                InsertLineToTempFile(lclCampos);

                                //  lclCampos := INTERBANKLinesStructure(pRecCollectionBuffer, pCurrencyCode, pTRecord);
                                //InsertLineToTempFile(lclCampos);
                            end;
                        end;
                    'BANBIF':
                        begin
                            //Make Lines
                            lclCampos := BANBIFLineStructure(pRecCollectionBuffer, pBankNo, pTRecord);
                            InsertLineToTempFile(lclCampos);
                        end;
                end;
            until pRecCollectionBuffer.Next = 0;
            //INTERBANK NUEVO ORDEN 
            lclRow := 0;
            pRecCollectionBuffer.Reset();
            pRecCollectionBuffer.SetFilter("No. Suministro", '<>%1', '');
            if pRecCollectionBuffer.FindFirst() then begin
                lclTotalRecord := pRecCollectionBuffer.Count;
                repeat
                    lclCampos := '';
                    pTRecord := pRecCollectionBuffer."Post Type";
                    TFileRecord := pRecCollectionBuffer."Post File";

                    pRecCollectionBuffer.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                    pCurrencyCode := pRecCollectionBuffer."Currency Code";
                    IsExistsFile := true;
                    lclRow += 1;
                    case pCollectionBank of
                        'INTERBANK':
                            begin
                                lclCampos := '';
                                //Post Header
                                if lclRow = 1 then begin
                                end;
                                // Post Quota/Detail
                                IF lclRow >= 1 THEN begin
                                    lclCampos := INTERBANKLinesStructure(pRecCollectionBuffer, pCurrencyCode, pTRecord);
                                    InsertLineToTempFile(lclCampos);
                                end;
                            end;
                    end;
                until pRecCollectionBuffer.Next = 0;
            END;
            pRecCollectionBuffer.Reset();

            if IsExistsFile then begin
                case pCollectionBank of
                    'BCP':
                        begin
                            lclFileName := 'CREP' + Format(Today);
                        end;
                    'BBVA':
                        begin
                            lclFileName := 'BBVA' + Format(Today);
                        end;
                    'SCOTIA':
                        begin
                            //lclFileName := 'SCOTIA' + Format(Today);
                            case pCurrencyCode OF
                                '':
                                    lclFileName := 'ATRIAMN';
                                else
                                    lclFileName := 'ATRIAME';
                            end;
                        end;
                    'INTERBANK':
                        begin
                            //lclFileName := 'C' + Format(Today) + '.016';
                            lclFileName := 'C0740101';
                        end;
                    'BANBIF':
                        begin
                            lclCompany.get;
                            case gTipoArchivo OF
                                gTipoArchivo::"Archivo de Actualización":
                                    lclFileName := 'REC_' + GetDateFileName(WorkDate()) + '_' + DelChr(lclCompany."VAT Registration No.", '=', gCaracteresNoValidos) + '_A';
                                gTipoArchivo::"Archivo de Reemplazo":
                                    lclFileName := 'REC_' + GetDateFileName(WorkDate()) + '_' + DelChr(lclCompany."VAT Registration No.", '=', gCaracteresNoValidos) + '_R';

                            end;
                        end;
                end;
                PostFileToControlFileRecord(lclFileName, pCollectionBank);
                lclCampos := '';
            end;
        end;

    end;

    procedure FindFillCollection(pBankCollection: Text;
                                pBankNo: code[20];
                                pCurrencyCode: Code[10];
                                pTFileCode: Text; pTRecord: Text;
                                pDateFrom: Date;
                                pDateTo: Date;
                                pSerieDoc: Text)
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SetAutoCalcFields("Remaining Amount", "Remaining Amt. (LCY)");
        CustLedgerEntry.SetRange("Currency Code", pCurrencyCode);
        CustLedgerEntry.SetRange("Bank Reference", pBankNo);
        CustLedgerEntry.SetFilter("Document Type", '%1', CustLedgerEntry."Document Type"::Invoice);

        if (pDateFrom <> 0D) and (pDateTo <> 0D) then
            CustLedgerEntry.SetFilter("Posting Date", '%1..%2', pDateFrom, pDateTo);

        if pSerieDoc <> '' then
            CustLedgerEntry.SetFilter("Document No.", UpperCase(pSerieDoc));

        if pCurrencyCode = '' then
            CustLedgerEntry.SetFilter("Remaining Amt. (LCY)", '>%1', 0)
        else
            CustLedgerEntry.SetFilter("Remaining Amount", '>%1', 0);

        if CustLedgerEntry.FindSet then begin
            // repeat
            FillCollectionBuffer(CustLedgerEntry, pBankCollection, pBankNo, pTFileCode, pTRecord, pCurrencyCode);
            //until CustLedgerEntry.Next = 0;
        end else
            Message('No existen Documentos, con los criterios indicado.');
    end;

    procedure FillCollectionBuffer(var pCustLedgerEntry: Record "Cust. Ledger Entry";
                                            pBankCollection: text;
                                            pBankNo: code[20];
                                            pTFileCode: text;
                                            pTRecord: Text; pCurrencyCode: Code[10])
    var
        STControlFile: Record "ST Control File";
    begin

        gTotalAmount := 0;
        gTotalRecords := 0;

        CollectionPaymentBuffer.Reset();
        CollectionPaymentBuffer.DeleteAll();

        pCustLedgerEntry.FindSet();
        repeat
            if IsCustomerBankAcc(pCustLedgerEntry."Customer No.", pBankNo, pCurrencyCode) then begin

                ValidateCollectionBuffer(pCustLedgerEntry);//PC 24.05.21 ADD
                pCustLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");
                CollectionPaymentBuffer.Init();
                CollectionPaymentBuffer.TransferFields(pCustLedgerEntry, true);
                CollectionPaymentBuffer.onAfterCopyFromCustLedgEntry(CollectionPaymentBuffer, pCustLedgerEntry);//PC 24.05.21 ADD
                CollectionPaymentBuffer."Post File" := pTFileCode;
                CollectionPaymentBuffer."Post Type" := pTRecord;
                CollectionPaymentBuffer."Collection Bank" := pBankCollection;
                CollectionPaymentBuffer."Bank Account No." := pBankNo;
                CollectionPaymentBuffer.Insert();

                gTotalRecords += 1;
                if pCustLedgerEntry."Currency Code" = '' then
                    gTotalAmount += pCustLedgerEntry."Remaining Amt. (LCY)"
                else
                    gTotalAmount += pCustLedgerEntry."Remaining Amount";

            end;
        until pCustLedgerEntry.Next() = 0;

        GenerateFilePaymentCollection(STControlFile, CollectionPaymentBuffer, pBankCollection, pBankNo);
        CollectionPaymentBuffer.Reset();
    end;

    procedure ValidateCollectionBuffer(VAR pCustLedgerEntry: Record "Cust. Ledger Entry")
    var

        lclRecLegalDocument: Record "Legal Document";
        lclRecCustLedgerEntry: Record "Cust. Ledger Entry";
        lclSerieText: Text;
        lclDocumentNumber: Text;
        workString: Text;
        LabelError1: Label 'Nº Serie supera la longitud máxima del tipo documento legal %1 en el Mov.Cliente %2';
        LabelError2: Label 'Nº Documento %1 supera la longitud máxima del tipo documento legal %2 en el Mov.Cliente %3';
        LabelError3: Label 'Nº Documento %1 no tiene el formato correcto en el Mov.Cliente %2';

        ArrayText: List of [Text];
    begin
        //PC 24.05.21 +++++ 
        if pCustLedgerEntry."Legal Document" = '' then
            exit;

        lclRecLegalDocument.Reset();
        lclRecLegalDocument.SetRange("Option Type", lclRecLegalDocument."Option Type"::"SUNAT Table");
        lclRecLegalDocument.SetRange("Type Code", '10');
        lclRecLegalDocument.SetRange("Legal No.", pCustLedgerEntry."Legal Document");
        lclRecLegalDocument.SetFilter("Serie Lenght", '<>%1', 0);
        if lclRecLegalDocument.FindSet() then begin

            workString := pCustLedgerEntry."Document No.";
            if StrPos(workString, '-') = 0 then
                Error(StrSubstNo(LabelError3, pCustLedgerEntry."Document No.", pCustLedgerEntry."Entry No."));


            /*
                if UpperCase(CopyStr(workString, 1, 1)) = 'V' then
                    workString := CopyStr(workString, 2, 4) + '-' + CopyStr(workString, 6, StrLen(workString))
                else
                    workString := CopyStr(workString, 1, 4) + '-' + CopyStr(workString, 5, StrLen(workString));
           */
            ArrayText := workString.Split('-');
            lclSerieText := ArrayText.Get(1);
            lclDocumentNumber := ArrayText.Get(2);
            if StrLen(lclSerieText) > lclRecLegalDocument."Serie Lenght" then
                Error(StrSubstNo(LabelError1, lclRecLegalDocument."Legal No.", pCustLedgerEntry."Entry No."));
            if StrLen(lclDocumentNumber) > lclRecLegalDocument."Number Lenght" then
                Error(StrSubstNo(LabelError2, pCustLedgerEntry."Document No.", lclRecLegalDocument."Legal No.", pCustLedgerEntry."Entry No."));
        end;

        //PC 24.05.21 +++++ 
    end;

    procedure MasterDataLookup(pCollectionBank: Text) rText: Text
    var
        MasterData: Record "Master Data";
        PageMasterData: Page "MasterData Lookup";
    begin
        MasterData.Reset();
        MasterData.SetRange("Type Table", pCollectionBank);
        if MasterData.FindSet() then begin
            PageMasterData.SetTableView(MasterData);
            PageMasterData.LookupMode(true);
            if PageMasterData.RunModal() = Action::LookupOK then begin
                PageMasterData.GetRecord(MasterData);
                if MasterData.Find then begin
                    rText := MasterData.Description;
                end;
            end;
            exit(rText);
        end;
    end;

    procedure ValidateRecordType(var TFileCode: Text; var TRecordCode: Text) rValue: Boolean
    var
    begin
        case TFileCode of
            'A':
                if TRecordCode = ' ' then begin
                    Message('Opcion No Aplica, valida solo pata tipo archivo: Remplazo.');
                    rValue := true;
                end;
            'R':
                if TRecordCode <> ' ' then begin
                    Message('Opcion no valida, solo se permite No Aplica');
                    rValue := true;
                end;
        end;
        exit(rValue);
    end;

    local procedure GetDate(pDate: Date): Text
    var
        TxtDay: Text;
        TxtMonth: Text;
        TxtYear: Text;
    begin
        TxtDay := FORMAT(DATE2DMY(pDate, 1));
        TxtMonth := FORMAT(DATE2DMY(pDate, 2));
        TxtYear := FORMAT(DATE2DMY(pDate, 3));
        IF STRLEN(TxtDay) = 1 THEN
            TxtDay := '0' + TxtDay;
        IF STRLEN(TxtMonth) = 1 THEN
            TxtMonth := '0' + TxtMonth;
        EXIT(TxtYear + TxtMonth + TxtDay);
    end;

    local procedure GetDateFileName(pDate: Date): Text
    var
        TxtDay: Text;
        TxtMonth: Text;
        TxtYear: Text;
    begin
        TxtDay := FORMAT(DATE2DMY(pDate, 1));
        TxtMonth := FORMAT(DATE2DMY(pDate, 2));
        TxtYear := CopyStr(FORMAT(DATE2DMY(pDate, 3)), 3, 2);
        IF STRLEN(TxtDay) = 1 THEN
            TxtDay := '0' + TxtDay;
        IF STRLEN(TxtMonth) = 1 THEN
            TxtMonth := '0' + TxtMonth;
        EXIT(TxtDay + TxtMonth + TxtYear);
    end;

    local procedure CreateTempFile(pIsAnsi: Boolean)
    begin
        case pIsAnsi of
            true:
                TempFileBlob.CreateOutStream(ConstrutOutStream, TextEncoding::Windows);
            false:
                TempFileBlob.CreateOutStream(ConstrutOutStream, TextEncoding::UTF8);
        end;

    end;

    local procedure InsertLineToTempFile(LineText: Text[1024])
    begin
        ConstrutOutStream.WriteText(LineText);
        ConstrutOutStream.WriteText;
    end;

    local procedure IsCustomerBankAcc(pCustNo: code[20]; pBankNo: code[20]; pCurrencyCode: Text) rValue: Boolean
    var
        Customer: Record Customer;
        CustomerBankAccount: Record "Customer Bank Account";

    begin
        rValue := false;
        if Customer.get(pCustNo) then begin
            if (Customer."Preferred Bank Account Code" <> '') or (Customer."Preferred Bank Account Code ME" <> '') then
                case pCurrencyCode of
                    '':
                        begin
                            if CustomerBankAccount.get(pCustNo, Customer."Preferred Bank Account Code") then begin
                                if CustomerBankAccount."Reference Bank Acc. No." <> '' then
                                    rvalue := CustomerBankAccount."Reference Bank Acc. No." = pBankNo;
                            end;
                        end;
                    'USD':
                        begin
                            if CustomerBankAccount.get(pCustNo, Customer."Preferred Bank Account Code ME") then begin
                                if CustomerBankAccount."Reference Bank Acc. No." <> '' then
                                    rvalue := CustomerBankAccount."Reference Bank Acc. No." = pBankNo;
                            end;
                        end;
                end;
        end;
        exit(rValue)
    end;

    procedure PostFileToControlFileRecord(pFileName: Text; pCollectionBank: Text)
    var
        CompInf: Record "Company Information";
        ControlFile: Record "ST Control File";
        UpdateControlFile: Record "ST Control File";
        NewFileInStream: InStream;
        FileName: Text;
        FileExt: Text;
        EntryNo: Integer;
        ConfirmDownload: Label 'Do you want to download the following file?', Comment = 'ESM="¿Quieres descargar el siguiente archivo?"';
    begin
        CompInf.Get();
        case pCollectionBank of
            'BCP':
                begin
                    TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::UTF8);
                    FileExt := 'txt';
                    EntryNo := ControlFile.CreateControlFileRecord('01', pFileName, FileExt, Today, Today, NewFileInStream);
                end;

            'BBVA':
                begin
                    TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::UTF8);
                    FileExt := 'txt';
                    EntryNo := ControlFile.CreateControlFileRecord('01', pFileName, FileExt, Today, Today, NewFileInStream);
                end;
            'SCOTIA':
                begin
                    TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::Windows);
                    FileExt := 'txt';
                    EntryNo := ControlFile.CreateControlFileRecordANSI('01', pFileName, FileExt, Today, Today, NewFileInStream);
                end;
            'INTERBANK':
                begin
                    TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::Windows);
                    FileExt := 'txt';
                    EntryNo := ControlFile.CreateControlFileRecordANSI('01', pFileName, FileExt, Today, Today, NewFileInStream);
                end;
            'BANBIF':
                begin
                    TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::Windows);
                    FileExt := 'txt';
                    EntryNo := ControlFile.CreateControlFileRecordANSI('01', pFileName, FileExt, Today, Today, NewFileInStream);
                end;
        end;

        //Revisamos si se comprime el archivo
        case pCollectionBank of
            'INTERBANK':
                begin
                    //ControlFile.CompressZipControlFile(EntryNo);
                end;
        end;
        if EntryNo <> 0 then begin
            UpdateControlFile.Get(EntryNo);
            UpdateControlFile."Entry Type" := UpdateControlFile."Entry Type"::"Recaudación";
            //PC 28.05.21 +++
            if gCurrencyCode = '' then
                gCurrencyCode := 'PEN';

            IF gTipoArchivo = gTipoArchivo::"Archivo de Reemplazo" then
                UpdateControlFile.Description := gBankCollection + ' ' + gCurrencyCode + ' Reemplazo - ' + DelChr(Format(Today), '=', '/');
            IF gTipoArchivo = gTipoArchivo::"Archivo de Actualización" then
                UpdateControlFile.Description := gBankCollection + ' ' + gCurrencyCode + ' Actualización - ' + DelChr(Format(Today), '=', '/');

            IF UpdateControlFile.Description = '' then
                UpdateControlFile.Description := gBankCollection + ' ' + gCurrencyCode + ' Actualización - ' + DelChr(Format(Today), '=', '/');
            //PC 28.05.21 ---
            UpdateControlFile.Modify();
            if Confirm(ConfirmDownload, false) then begin
                ControlFile.Get(EntryNo);

                case pCollectionBank of
                    'BCP':
                        ControlFile.DownLoadFile(ControlFile);
                    'BBVA':
                        ControlFile.DownLoadFile(ControlFile);
                    'SCOTIA':
                        ControlFile.DownLoadFileANSII(ControlFile);
                    'INTERBANK':
                        ControlFile.DownLoadFileANSII(ControlFile);
                    'BANBIF':
                        ControlFile.DownLoadFileANSII(ControlFile);
                end;
            end;
        end;
    end;

    local procedure BCPHeaderStructure(pBankNo: code[20]; pDate: date; pTotalRecords: Integer; pTotalAMountDoc: Decimal; pFileType: Text) rTxtHeaderBCP: Text
    var
        lclTemp: Text;
        lclAmountTxt: Text;
        BankAccount: Record "Bank Account";
    begin
        // CC 193 0 1596661 C ATRIA ENERGIA S.A.C                     20200609000000630000001842952113A
        // 1 – 2  	2 	Alfabético	Tipo de registro (CC = Cabecera) 
        rTxtHeaderBCP := 'CC';
        // 3 – 5  	3 	Numérico	Código de la Sucursal(de la Cta.de la Empresa Afiliada) 
        // 6 – 6  	1 	Numérico	Código de la moneda (de la Cta. De la Empresa Afiliada)  ( 0=soles, 1= Dólares)
        // 7 – 13  	7 	Numérico	Número de cuenta de la Empresa Afiliada 
        if BankAccount.GET(pBankNo) then begin
            rTxtHeaderBCP += COPYSTR(BankAccount."Bank Account No.", 1, 3);
            rTxtHeaderBCP += COPYSTR(BankAccount."Bank Account No.", 11, 1);
            rTxtHeaderBCP += COPYSTR(BankAccount."Bank Account No.", 4, 7);
        end;
        // 14 – 14 	1 	Alfabético	Tipo de validación (C = Completa) 
        rTxtHeaderBCP += 'C';

        // 15 – 54 	40 	Alfanumérico	Nombre de la Empresa Afiliada 
        lclTemp := CompanyInformation.Name + PADSTR('', 40 - STRLEN(CompanyInformation.Name), ' ');
        rTxtHeaderBCP += lclTemp;

        // 55 – 62 	8 	Numérico	Fecha de transmisión (AAAAMMDD) 
        rTxtHeaderBCP += GetDate(pDate);

        // 63 – 71  9 	Numérico	Cantidad total de registros enviados (en el detalle)
        lclTemp := PADSTR('', 9 - STRLEN(FORMAT(pTotalRecords)), '0') + FORMAT(pTotalRecords);
        rTxtHeaderBCP += lclTemp;

        // 72 – 86  	15 	Numérico	Monto total enviado (2 decimales)
        lclAmountTxt := DelChr(FORMAT(pTotalAMountDoc, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtHeaderBCP += lclTemp;

        // 87 – 87	1	Alfanumérico	Tipo de Archivo (“ ” o R = Archivo de Reemplazo, A = Archivo de Actualización)
        rTxtHeaderBCP += pFileType;

        // 88 – 93	6	Alfanumérico	Código Servicio (solo empresas que trabajan con servicios) 
        rTxtHeaderBCP += PADSTR('', 6, ' ');

        // 94 – 250  	157 		Filler (Libre) 
        rTxtHeaderBCP += PADSTR('', 157, ' ');
    end;

    local procedure BANBIFLineStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary; pBankNo: code[20]; pTRecord: text) rTxtLineBANBIF: Text
    var
        lclTemp: Text;
        lclNumDocPago: Text;
        lclAmountTxt: Text;
        BankAccount: Record "Bank Account";
        lclSuministroNo: Text;
        lclDocNoNumber: Integer;
        lclDocType: Text;
    begin

        //1: 1-20 20 Numérico Número de recibo (valor debe ser único en todala base)(0 decim.) 
        lclDocNoNumber := fngetNumberDocument(pRecCollectionBuffer."Document No.");
        rTxtLineBANBIF := PADSTR('', 20 - STRLEN(format(lclDocNoNumber)), '0') + format(lclDocNoNumber);
        //2:  21-40 20 Carácter Código del Integrante 
        lclSuministroNo := pRecCollectionBuffer."No. Suministro";
        lclTemp := lclSuministroNo + PADSTR('', 20 - STRLEN(lclSuministroNo), ' ');
        rTxtLineBANBIF += lclTemp;
        //3:  41-60 20 Carácter Apellido patern
        lclTemp := fnAdjsText(pRecCollectionBuffer."Customer Name", 20);
        lclTemp := lclTemp + PADSTR('', 20 - STRLEN(lclTemp), ' ');
        rTxtLineBANBIF += lclTemp;

        //4:  61-80 20 Carácter Apellido materno
        /* if StrLen(pRecCollectionBuffer."Customer Name") > 20 then
             lclTemp := '.' + fnAdjsText(copystr(pRecCollectionBuffer."Customer Name", 21, StrLen(pRecCollectionBuffer."Customer Name")), 19)
         else*/
        lclTemp := '.' + PADSTR('', 19, ' ');

        lclTemp := lclTemp + PADSTR('', 20 - STRLEN(lclTemp), ' ');
        rTxtLineBANBIF += lclTemp;
        //5:  81-100 20 Carácter Nombre
        /* if StrLen(pRecCollectionBuffer."Customer Name") > 40 then
             lclTemp := '.' + fnAdjsText(copystr(pRecCollectionBuffer."Customer Name", 41, StrLen(pRecCollectionBuffer."Customer Name")), 19)
         else*/
        lclTemp := '.' + PADSTR('', 19, ' ');

        lclTemp := lclTemp + PADSTR('', 20 - STRLEN(lclTemp), ' ');
        rTxtLineBANBIF += lclTemp;
        //6:  101-104 4 Código de Grupo – (Según tabla definida con el Banco por ej.: ”0001”)(0 decim.)
        rTxtLineBANBIF += '0001';
        //7:  105-112 8 Fecha de emisión de recibo (formato AAAAMMDD) “00000000” si no está disponible Numérico (0 decim.)
        rTxtLineBANBIF += GetDate(pRecCollectionBuffer."Document Date");
        //8:  112-120 8 Fecha de vencimiento de recibo (formato (AAAAMMDD – Año/mes/dia)Numérico (0 decim.)
        rTxtLineBANBIF += GetDate(pRecCollectionBuffer."Due Date");
        //9:  121-123 3 Carácter Moneda a Pagar (“SOL” Soles, “USD” Dólares)
        case pRecCollectionBuffer."Currency Code" of
            '':
                rTxtLineBANBIF += 'SOL';
            else
                rTxtLineBANBIF += pRecCollectionBuffer."Currency Code";
        end;
        //10: 124-135 12 Carácter Código de referencia propio del Cliente para el recibo (en blanco si no está disponible)
        lclTemp := pRecCollectionBuffer."Customer No.";
        lclTemp := 'C' + fnAdjsText(DelChr(lclTemp, '=', gOnlyNumbers), 11);
        rTxtLineBANBIF += lclTemp + PADSTR('', 12 - STRLEN(lclTemp), '0');
        //11: 136-175 40 Carácter Descripción breve del cobro a realizar. 
        lclTemp := fnAdjsText(pRecCollectionBuffer.Description, 40);
        lclTemp := DelChr(lclTemp, '=', gCaracteresNoValidos);
        rTxtLineBANBIF += lclTemp + PADSTR('', 40 - STRLEN(lclTemp), ' ');
        //12: 176-235 60 Carácter Observaciones del Recibo (en blanco si no está disponible)
        rTxtLineBANBIF += PADSTR('', 60, ' ');
        //13: 236-236 1 Indicador de cobro de mora (“1” No se cobra mora, “0” Si se cobra mora )
        case gGeneratearrears of
            true:
                rTxtLineBANBIF += '0';
            false:
                rTxtLineBANBIF += '1';

        end;
        //14: 237-239 3 Código concepto 1 – (Según Tabla de conceptos Sí definida con el Banco , Ejm “01”)Numérico(0 decim.) 
        rTxtLineBANBIF += '001';
        //15:  240-249 10   Importe de cobro para el concepto Numérico Numérico
        if pRecCollectionBuffer."Currency Code" = 'USD' then
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.')
        else
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amt. (LCY)", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');

        lclTemp := PADSTR('', 10 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineBANBIF += lclTemp;
        //16-25 Otros campos no usados 
        rTxtLineBANBIF += PADSTR('', 65, '0');
    end;

    local procedure BCPLineStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary; pBankNo: code[20]; pTRecord: text) rTxtLineBCP: Text
    var
        lclTemp: Text;
        lclNumDocPago: Text;
        lclAmountTxt: Text;
        BankAccount: Record "Bank Account";
        lclSuministroNo: Text;
        lclDocNoNumber: Integer;
        lclDocType: Text;
    begin
        // DD1930159666100000000013079ZYL AGRO E I R L                        01-F001-0010246               2020040820200418000000020090498000000000000000000000000A       01F0010010246    C20480853424
        // 1 – 2  	2 	Alfabético	Tipo de registro (DD = Detalle) 
        rTxtLineBCP := 'DD';

        // 3 – 5  	3 	Numérico	Código de la Sucursal(de la Cta.de la Empresa Afiliada) 
        // 6 – 6  	1 	Numérico	Código de la moneda (de la Cta.de la Empresa Afiliada) 
        // 7 – 13 	7 	Numérico	Número de cuenta de la Empresa Afiliada 
        if BankAccount.GET(pBankNo) then begin
            rTxtLineBCP += COPYSTR(BankAccount."Bank Account No.", 1, 3);
            rTxtLineBCP += COPYSTR(BankAccount."Bank Account No.", 11, 1);
            rTxtLineBCP += COPYSTR(BankAccount."Bank Account No.", 4, 7);
        end;

        // 14 – 27 	14 	Alfanumérico	Código de identificación del Depositante 
        lclSuministroNo := pRecCollectionBuffer."No. Suministro";
        // lclSuministroNo := PADSTR('', 14, '0');

        lclTemp := PADSTR('', 14 - STRLEN(lclSuministroNo), '0') + lclSuministroNo;
        rTxtLineBCP += lclTemp;

        // 28 – 67 	40 	Alfanumérico	Nombre del Depositante 
        pRecCollectionBuffer."Customer Name" := fnAdjsText(pRecCollectionBuffer."Customer Name", 40);
        lclTemp := pRecCollectionBuffer."Customer Name" + PADSTR('', 40 - STRLEN(pRecCollectionBuffer."Customer Name"), ' ');
        rTxtLineBCP += lclTemp;


        // 68 – 97 	30 	Alfanumérico	Campo con información de retorno 
        if pRecCollectionBuffer."Legal Document" <> '' then
            lclNumDocPago := pRecCollectionBuffer."Legal Document" + ' ' + pRecCollectionBuffer."Document No."
        else
            lclNumDocPago := '00 ' + pRecCollectionBuffer."Document No.";
        lclNumDocPago := DelChr(lclNumDocPago, '=', gCaracteresNoValidosBCP);
        lclTemp := lclNumDocPago + PADSTR('', 30 - STRLEN(lclNumDocPago), ' ');
        rTxtLineBCP += lclTemp;

        // 98 – 105 	8	Numérico	Fecha de emisión del cupón 
        rTxtLineBCP += GetDate(pRecCollectionBuffer."Document Date");

        // 106 – 113	8	Numérico	Fecha de vencimiento del cupón 
        rTxtLineBCP += GetDate(pRecCollectionBuffer."Due Date");

        // 114 – 128	15	Numérico	Monto del cupón (2 decimales)
        if pRecCollectionBuffer."Currency Code" = 'USD' then
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.')
        else
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amt. (LCY)", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');

        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineBCP += lclTemp;

        // 129 – 143	15	Numérico	Monto del mora (2 decimales)
        rTxtLineBCP += PADSTR('', 15, '0');

        // 144 – 152	9	Numérico	Monto mínimo (2 decimales) 
        rTxtLineBCP += PADSTR('', 9, '0');

        // 153	1	Alfabético	Tipo de registro de actualización (A = Registro a Agregar, M = Registro a Modificar, E = Registro a Eliminar)
        rTxtLineBCP += pTRecord;

        // 154 – 173 	20	Alfanumérico	Nro. Documento de Pago
        if pRecCollectionBuffer."Legal Document" <> '' then
            lclDocType := pRecCollectionBuffer."Legal Document"
        else
            lclDocType := '00';

        lclNumDocPago := lclDocType + delchr(pRecCollectionBuffer."Document No.", '=', '-');
        lclTemp := PADSTR('', 20 - STRLEN(lclNumDocPago), ' ') + lclNumDocPago;
        rTxtLineBCP += lclTemp;

        // Alinear a la derecha
        // Si es numérico, completar con ceros a la izquierda.
        // Si es alfanumérico, completar con espacios a la izquierda.
        // 174 – 189 	16	Alfanumérico	Nro. Documento de Identidad
        if Evaluate(lclDocNoNumber, pRecCollectionBuffer."Customer No.") then
            lclTemp := PADSTR('', 16 - STRLEN(pRecCollectionBuffer."Customer No."), ' ') + pRecCollectionBuffer."Customer No."
        else
            lclTemp := PADSTR('', 16 - STRLEN(pRecCollectionBuffer."Customer No."), '0') + pRecCollectionBuffer."Customer No.";

        rTxtLineBCP += lclTemp;
        // Alinear a la derecha
        // Si es numérico, completar con ceros a la izquierda.
        // Si es alfanumérico, completar con espacios a la izquierda.
        // 190 – 250  	61		Filler (Libre) 
        rTxtLineBCP += PADSTR('', 61, ' ');
    end;

    local procedure BBVAHeaderStructure(pBankNo: code[20]; pCurrencyCode: code[10]; pClase: Text; pFileType: Text) rTxtHeaderBBVA: Text
    var
        BankAccount: Record "Bank Account";
        STControlFile: Record "ST Control File";
        CurrencyCode: Text;
        FileName: Text;
        Correlativo: Text;
    begin
        // 1	Tipo de Registro	Núm.	1	2	2	OBL	Indicador de cabecera 01 (*)	01
        rTxtHeaderBBVA := '01';

        // 2	Ruc de la Empresa	Alfnúm.	3	13	11	OBL	Nro. de Ruc indicado en la ficha técnica	20501860329
        rTxtHeaderBBVA += CompanyInformation."VAT Registration No.";

        // 3	Número de clase	Núm.	14	16	3	OBL	Número proporcionado por el banco	123
        if pCurrencyCode = '' then
            rTxtHeaderBBVA += '000'
        ELSE
            rTxtHeaderBBVA += '100';



        // 4	Moneda	Alfnúm.	17	19	3	OBL	"PEN: Soles  USD:Dolares"	PEN
        if pCurrencyCode = '' then
            CurrencyCode := 'PEN'
        ELSE
            CurrencyCode := pCurrencyCode;

        rTxtHeaderBBVA += CurrencyCode;

        // 5	Fecha de Facturación	Alfnúm.	20	27	8	OBL	Colocar la fecha actual AAAAMMDD (**)	20190708
        rTxtHeaderBBVA += GetDate(Today);

        // 6	Versión	Núm.	28	30	3	OBL	Inicia en 000 y si se hace mas de una vez el envio seguira el consecutivo (***)	000
        FileName := 'BBVA' + Format(Today);
        STControlFile.Reset();
        STControlFile.SetRange("File Name", FileName);
        if STControlFile.count > 0 then begin
            Correlativo := format(STControlFile.Count);

            if strlen(Correlativo) = 1 then
                Correlativo := '00' + Correlativo;
            if strlen(Correlativo) = 2 then
                Correlativo := '0' + Correlativo;
        end else
            Correlativo := '000';

        rTxtHeaderBBVA += Correlativo;

        // 7	Vacio	Alfnúm.	31	37	7	OBL	Rellenar de Blancos	
        rTxtHeaderBBVA += PADSTR('', 7, ' ');

        // 8	Tipo de Actualización	Alfnúm.	38	38	1	OPC	T: Actualización Total (reemplaza la base de datos existente)  
        //   *Si no utilizan ninguna de las opciones(T, P o E) rellenar con espacio en blanco, el sistema tomara la opción contratada.T
        rTxtHeaderBBVA += pFileType;

        // 9	Vacio	Alfnúm.	39	360	322	OBL	Rellenar con espacios en Blanco	
        rTxtHeaderBBVA += PADSTR('', 322, ' ');

        // 					360	OBL = Obligatorio, OPC= Opcional 		
    end;

    local procedure ReplaceString(String: Text; FindWhat: Text; ReplaceWith: Text) NewString: Text
    var
        FindPos: Integer;
    begin
        FindPos := STRPOS(String, FindWhat);
        WHILE FindPos > 0 DO BEGIN
            NewString += DELSTR(String, FindPos) + ReplaceWith;
            String := COPYSTR(String, FindPos + STRLEN(FindWhat));
            FindPos := STRPOS(String, FindWhat);
        END;
        NewString += String;
    end;

    local procedure CharConvert(var pText: Text) rText: Text
    var
        i: Integer;
        Long: Integer;
        RepTxt: Text;
        FindText: Text;
    begin
        RepTxt := '';
        Long := StrLen(pText);
        for i := 1 to Long do begin
            FindText := CopyStr(pText, i, Long);
            case FindText of
                'Ä,Á,À,á,à,Ã,ã,â,Â,ä':
                    RepTxt := 'A';
                'Ë,É,È,é,è,ê,Ê,ë':
                    RepTxt := 'E';
                'Ï,Í,Ì,í,ì,î,Î,ï':
                    RepTxt := 'I';
                'Ö,Ó,Ò,ó,ò,Õ,õ,ô,Ô,ö':
                    RepTxt := 'O';
                'Ü,Ú,Ù,ú,ù,û,Û,ü':
                    RepTxt := 'U';
                '±,Ñ,ñ':
                    RepTxt := 'N';
                'ÿ,ý,Ý':
                    RepTxt := 'Y';
                'Ð':
                    RepTxt := 'D';
                '",;,,,+':
                    RepTxt := ' ';
                '!,,#,$,%,/,(,\,¡,¿,´,~,[,},],`,<,>,_,),{,^,:,|,°,¬,=,?,º':
                    RepTxt := ' ';
            end;
        end;

        if RepTxt <> '' then
            ReplaceString(pText, FindText, RepTxt);

        exit(rText);
    end;

    local procedure BBVALineStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary) rTxtLineBBVA: Text
    var
        DateLock: Text;
        TxtMonth: Text;
        lclTemp: Text;
        lclDoc: text;
        lclAmountTxt: Text;

    begin
        // 1	Tipo de Registro	Núm.	1	2	2	OBL	Indicador de detalle 02 (*)
        rTxtLineBBVA := '02';

        // 2	Nombre del Cliente	Alfnúm.	3	32	30	OBL	Indicar Razon Social o Nombre del Cliente
        lclTemp := pRecCollectionBuffer."Customer Name";
        if strlen(lclTemp) > 30 then
            lclTemp := copystr(lclTemp, 1, 30)
        else
            lclTemp := lclTemp + PadStr('', 30 - StrLen(lclTemp), ' ');

        rTxtLineBBVA += lclTemp;

        // 3	Campo de Identificación del Pago	Núm./Alfnúm	33	80	48	OBL	Especificación Según Ficha Tecnica (**)
        // 	Campo de Identificación Adicional						
        // 	Campo Opcional del Pago			
        lclDoc := pRecCollectionBuffer."No. Suministro" + PadStr('', 20 - StrLen(pRecCollectionBuffer."No. Suministro"), ' ') +
        pRecCollectionBuffer."Customer No." +
                pRecCollectionBuffer."Legal Document" +
                delchr(pRecCollectionBuffer."Document No.", '=', ' -');

        if strlen(lclDoc) > 48 then
            lclDoc := copystr(lclDoc, 1, 48)
        else
            lclDoc := lclDoc + PadStr('', 48 - StrLen(lclDoc), ' ');

        rTxtLineBBVA += lclDoc;

        // 4	Fecha de Vencimiento	Alfnúm.	81	88	8	OBL	Vencimiento del Pago en AAAAMMDD
        rTxtLineBBVA += GetDate(pRecCollectionBuffer."Due Date");

        // 5	Fecha de Bloqueo	Alfnúm.	89	96	8	OBL	Fecha hasta la cual el banco tendra en sus sistemas dicho registro AAAAMMDD (1)
        rTxtLineBBVA += '20301231';

        // 6	Período del pago Facturado	Núm.	97	98	2	OBL	Período en el que se factura "01" ej Enero (2)
        TxtMonth := FORMAT(DATE2DMY(pRecCollectionBuffer."Document Date", 2));
        IF STRLEN(TxtMonth) = 1 THEN
            TxtMonth := '0' + TxtMonth;

        rTxtLineBBVA += TxtMonth;

        // 7	Importe Maximo a cobrar	Núm.	99	113	15	OBL	Se colocara 13 enteros y 2 decimales sin punto ni comas
        if pRecCollectionBuffer."Currency Code" = 'USD' then
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.')
        else
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amt. (LCY)", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');

        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineBBVA += lclTemp;

        // 8	Importe Minimo a cobrar	Núm.	114	128	15	OBL	Se colocara 13 enteros y 2 decimales sin punto ni comas
        if pRecCollectionBuffer."Currency Code" = 'USD' then
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.')
        else
            lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amt. (LCY)", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');

        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineBBVA += lclTemp;

        // 9	Información Adicional	Núm.	129	160	32	OBL	Uso exclusivo del banco se rella de ceros
        rTxtLineBBVA += PADSTR('', 32, '0');

        // 10	Cod. De Sub concepto 01	Núm.	161	162	2	OPC	Se colocar "01" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 11	Valor de Sub Concepto 01	Núm.	163	176	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 12	Cod. De Sub concepto 02	Núm.	177	178	2	OPC	Se colocar "02" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 13	Valor de Sub Concepto 02	Núm.	179	192	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 14	Cod. De Sub concepto 03	Núm.	193	194	2	OPC	Se colocar "03" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 15	Valor de Sub Concepto 03	Núm.	195	208	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 16	Cod. De Sub concepto 04	Núm.	209	210	2	OPC	Se colocar "04" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 17	Valor de Sub Concepto 04	Núm.	211	224	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 18	Cod. De Sub concepto 05	Núm.	225	226	2	OPC	Se colocar "05" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 19	Valor de Sub Concepto 05	Núm.	227	240	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 20	Cod. De Sub concepto 06	Núm.	241	242	2	OPC	Se colocar "06" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 21	Valor de Sub Concepto 06	Núm.	243	256	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 22	Cod. De Sub concepto 07	Núm.	257	258	2	OPC	Se colocar "07" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 23	Valor de Sub Concepto 07	Núm.	259	272	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 24	Cod. De Sub concepto 08	Núm.	273	274	2	OPC	Se colocar "08" en caso halla subconcepto, si no lo hubiera se coloca "00"
        rTxtLineBBVA += '00';

        // 25	Valor de Sub Concepto 08	Núm.	275	288	14	OPC	Se colocara el monto: 12 enteros y 2 decimales sin punto ni comas.Si no hay se coloca 14 ceros (S)
        rTxtLineBBVA += PADSTR('', 14, '0');

        // 26	Vacio	Alfnúm.	289	360	72	OBL	Rellenar con espacios en Blanco
        // 					360	OBL = Obligatorio, OPC= Opcional 	
        rTxtLineBBVA += PADSTR('', 72, ' ');

    end;

    local procedure BBVATotalStructure(pTotalReg: Integer; pTotalAmoun: Decimal) rTxTotalBBVA: Text
    var
        lclAmountTxt: Text;
        lclTemp: Text;
    begin
        // 1	Tipo de Registro	Núm.	1	2	2	OBL	Indicador de totales 03 (*)	03
        rTxTotalBBVA := '03';

        // 2	Cantidad de Registros Cobrables	Núm.	3	11	9	OBL	Indica la cantidad de registro a cobrar (*)	El sistema deberá calcular esto
        rTxTotalBBVA += PADSTR('', 9 - STRLEN(format(pTotalReg)), '0') + format(pTotalReg);

        // 3	Total de los importes máximos a recaudar	Núm.	12	29	18	OBL	Es el total de la suma de los importes maximos de todos los registros (***)	El sistema deberá calcular esto
        lclAmountTxt := DelChr(FORMAT(pTotalAmoun, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 18 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxTotalBBVA += lclTemp;

        // 4	Total de los importes mínimos a recaudar	Núm.	30	47	18	OBL	Es el total de la suma de los importes minimos de todos los registros (****)	El sistema deberá calcular esto
        lclAmountTxt := DelChr(FORMAT(pTotalAmoun, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 18 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxTotalBBVA += lclTemp;

        // 5	Datos adicionales	Núm.	48	65	18	OBL	Rellenar de 18 ceros. Uso exclusivo del banco.	000000000000000000
        rTxTotalBBVA += PADSTR('', 18, '0');

        // 6	Vacio	Alfnúm.	66	360	295	OBL	Rellenar con espacios en Blanco	
        rTxTotalBBVA += PADSTR('', 295, ' ');

        // 					360	OBL = Obligatorio, OPC= Opcional 		

    end;

    local procedure SetValuesSCOTIA(var pBankAccountNo: Code[20]; var pCurrencyCode: Code[10]) rText: Text
    var
        BankAccount: Record "Bank Account";
        BankAccNoTxt: Text;
        Currecncy: Text;
    begin
        BankAccount.get(pBankAccountNo);
        case pCurrencyCode of
            '':
                begin
                    case BankAccount."Bank Account Type" of
                        BankAccount."Bank Account Type"::"Current Account":
                            Currecncy := '01';
                        BankAccount."Bank Account Type"::"Savings Account":
                            Currecncy := '14';
                    end;
                    SecuenceSBP := '001';
                end;
            'USD':
                begin
                    case BankAccount."Bank Account Type" of
                        BankAccount."Bank Account Type"::"Current Account":
                            Currecncy := '07';
                        BankAccount."Bank Account Type"::"Savings Account":
                            Currecncy := '83';
                    end;
                    SecuenceSBP := '002';
                end;
            else
                SecuenceSBP := '003';
        end;
        BankAccNoTxt := DelChr(BankAccount."Bank Account No.", '=', '- ');
        rText := CopyStr(BankAccNoTxt, 4, StrLen(BankAccNoTxt)) + CopyStr(BankAccNoTxt, 1, 3) + Currecncy; //+ '  ';
        exit(rText);
    end;

    local procedure SCOTIAHeaderStructure(pProcessDate: date; pBankNo: code[20]; pCurrencyCode: code[10]; pTotalRecords: Integer; pTotalAmountDoc: Decimal) rTxtHeaderSB: Text
    var
        lclTemp: Text;
        lclAmountTxt: Text;
        lclAmount1: Decimal;
        lclAmount2: Decimal;
    begin
        //1 Tipo de registro
        rTxtHeaderSB := 'H';

        //2 Cuenta empresa
        // Debe ser de 12 o 14 caracteres. En caso de 12 por Ejm. N° cta: 000 1234567, 
        // colocar a la inversa: 123456700001, donde: 1234567 es Nro de cta ; 
        // 000 es el nro de agencia; 01=Tipo Cta Tipos de cta: 
        // 01=Cta.C.Soles; 07:Cta.C.US;14:Cta.A. Soles; 83:Cta.A.US
        gCompanyInformation.get();
        gCompanyInformation.TestField("Bank Account No.");
        case pCurrencyCode OF
            '':
                begin
                    SecuenceSBP := '001';
                    rTxtHeaderSB += gCompanyInformation."Bank Account No." + '  ';
                end;

            else begin
                    SecuenceSBP := '002';
                    rTxtHeaderSB += gCompanyInformation."Bank Account No." + '  ';
                end;

        end;
        // SetValuesSCOTIA(pBankNo, pCurrencyCode) + '  ';

        if SecuenceSBP = '001' then begin
            lclAmount1 := pTotalAmountDoc;
            lclAmount2 := 0;
        end else begin
            lclAmount2 := pTotalAmountDoc;
            lclAmount1 := 0;
        end;

        //3 Secuencia/Servicio
        rTxtHeaderSB += SecuenceSBP;

        //4 Cantidad registros
        lclTemp := PADSTR('', 7 - STRLEN(FORMAT(pTotalRecords)), '0') + FORMAT(pTotalRecords);
        rTxtHeaderSB += lclTemp;

        //5 Total soles
        lclAmountTxt := DelChr(FORMAT(lclAmount1, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 17 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtHeaderSB += lclTemp;

        //6 Total dolares
        lclAmountTxt := DelChr(FORMAT(lclAmount2, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 17 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtHeaderSB += lclTemp;

        //7 RUC Empresa
        rTxtHeaderSB += CompanyInformation."VAT Registration No.";

        //8 Fecha envio
        rTxtHeaderSB += GetDate(pProcessDate);

        //9 Fecha vigencia
        rTxtHeaderSB += '20301231';

        //10    Filler
        rTxtHeaderSB += '000';

        //11    Dias mora
        rTxtHeaderSB += '000';

        //12    Tipo mora
        rTxtHeaderSB += '00';

        //13    Mora flat
        lclTemp := PADSTR('', 11, '0');
        rTxtHeaderSB += lclTemp;

        //14    Porcentaje mora
        lclTemp := PADSTR('', 8, '0');
        rTxtHeaderSB += lclTemp;

        //15    Monto fijo
        lclTemp := PADSTR('', 11, '0');
        rTxtHeaderSB += lclTemp;

        //16    Tipo descuento
        lclTemp := PADSTR('', 2, '0');
        rTxtHeaderSB += lclTemp;

        //17    Monto a descontar
        lclTemp := PADSTR('', 11, '0');
        rTxtHeaderSB += lclTemp;

        //18    Porcentaje descuento
        lclTemp := PADSTR('', 8, '0');
        rTxtHeaderSB += lclTemp;

        //19    Dias descuento
        lclTemp := PADSTR('', 3, '0');
        rTxtHeaderSB += lclTemp;

        //20    Fecha de inicio CA
        rTxtHeaderSB += GetDate(pProcessDate);

        //21    Fecha de fin CA
        rTxtHeaderSB += GetDate(pProcessDate);

        //22    Ind. mod de fechas
        rTxtHeaderSB += '1';

        //23    Filler
        lclTemp := PADSTR('', 124, ' ');
        rTxtHeaderSB += lclTemp;

        //24    Fin de registro
        rTxtHeaderSB += '*';
    end;

    local procedure SCOTIALineStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary; pBankNo: code[20]; pCurrencyCode: code[10]; pTRecord: text) rTxtLineSB: Text
    var
        lclTemp: Text;
        lclAmountTxt: Text;
        lclName: Text;
    begin
        // TIPO DE REGISTRO CHAR(01) "D" 1 1 1
        rTxtLineSB := 'D';

        // CUENTA EMPRESA CHAR(14) CUENTA EMPRESA 2 15 14
        //2 Cuenta empresa
        gCompanyInformation.get();
        case pCurrencyCode OF
            '':
                begin
                    SecuenceSBP := '001';
                    rTxtLineSB += gCompanyInformation."Bank Account No." + '  ';
                end;

            else begin
                    SecuenceSBP := '002';
                    rTxtLineSB += gCompanyInformation."Bank Account No." + '  ';
                end;

        end;
        //rTxtLineSB += SetValuesSCOTIA(pBankNo, pCurrencyCode) + '  ';


        // SECUENCIA/SERVICIO NUM(03) CODIGO DEL SERVICIO 16 18 3
        rTxtLineSB += SecuenceSBP;

        // CODIGO USUARIO CHAR(15) CODIGO DEL USUARIO 19 33 15
        lclTemp := pRecCollectionBuffer."No. Suministro";
        rTxtLineSB += lclTemp + PADSTR('', 15 - STRLEN(lclTemp), ' ');

        // NUMERO RECIBO CHAR(15) NUMERO DEL RECIBO O DOCUMENTO 34 48 15
        lclTemp := delchr(pRecCollectionBuffer."Document No.", '=', '-');
        rTxtLineSB += lclTemp + PADSTR('', 15 - STRLEN(lclTemp), ' ');

        // CODIGO AGRUPACION CHAR(11) RUC DE AGRUPACION DEUDA INSTITUCION 49 59 11
        // rTxtLineSB += pRecCollectionBuffer."Customer No." + PADSTR('', 11 - STRLEN(pRecCollectionBuffer."Customer No."), '0');
        rTxtLineSB += '' + PADSTR('', 11, ' ');

        // SITUACION CHAR(01) 0:PENDIENTE 60 60 1
        rTxtLineSB += '0';

        // MONEDA DE COBRO NUM(04) 0000:SOLES 0001:DOLARES 61 64 4
        if pRecCollectionBuffer."Currency Code" = '' then
            rTxtLineSB += '0000'
        else
            if pRecCollectionBuffer."Currency Code" = 'USD' then
                rTxtLineSB += '0001';

        // NOMBRE DEL USUARIO CHAR(20) NOMBRE DEL USUARIO 65 84 20
        lclName := fnReplAceaccentmark(pRecCollectionBuffer."Customer Name");
        lclName := CopyStr(lclName, 1, 20);
        rTxtLineSB += lclName + PADSTR('', 20 - STRLEN(lclName), ' ');

        // REFERENCIA RECIBO CHAR(30) DESCRIPCION DE LA DEUDA 85 114 30
        lclTemp := fnReplAceaccentmark(pRecCollectionBuffer.Description);
        if StrLen(lclTemp) > 30 then
            lclTemp := CopyStr(lclTemp, 1, 30);
        rTxtLineSB += lclTemp + PADSTR('', 30 - STRLEN(lclTemp), ' ');

        // CONCEPTO A COBRAR 1 NUM(02) CODIGO DE CONCEPTO 1 115 116 2
        rTxtLineSB += '01';

        // IMPORTE A COBRAR 1 NUM(9,2) IMPORTE DEL CONCEPTO 1 117 127 11
        lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // CONCEPTO A COBRAR 2 NUM(02) CODIGO DE CONCEPTO 2 128 129 2
        rTxtLineSB += '  ';

        // IMPORTE A COBRAR 2 NUM(9,2) IMPORTE DEL CONCEPTO 2 130 140 11
        lclAmountTxt := '0';
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // CONCEPTO A COBRAR 3 NUM(02) CODIGO DE CONCEPTO 3 141 142 2
        rTxtLineSB += '  ';

        // IMPORTE A COBRAR 3 NUM(9,2) IMPORTE DEL CONCEPTO 3 143 153 11
        lclAmountTxt := '0';
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // CONCEPTO A COBRAR 4 NUM(02) CODIGO DE CONCEPTO 4 154 155 2
        rTxtLineSB += '  ';

        // IMPORTE A COBRAR 4 NUM(9,2) IMPORTE DEL CONCEPTO 4 156 166 11
        lclAmountTxt := '0';
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // CONCEPTO A COBRAR 5 NUM(02) CODIGO DE CONCEPTO 5 167 168 2
        rTxtLineSB += '  ';

        // IMPORTE A COBRAR 5 NUM(9,2) IMPORTE DEL CONCEPTO 5 169 179 11
        lclAmountTxt := '0';
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // CONCEPTO A COBRAR 6 NUM(02) CODIGO DE CONCEPTO 6 180 181 2
        rTxtLineSB += '  ';

        // IMPORTE A COBRAR 6 NUM(9,2) IMPORTE DEL CONCEPTO 6 182 192 11
        lclAmountTxt := '0';
        lclTemp := PADSTR('', 11 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // TOTAL A COBRAR NUM(13,2) SUMATORIA DE CONCEPTO A COBRAR 193 207 15
        lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLineSB += lclTemp;

        // SALDO DE LA DEUDA NUM(13,2) SALDO DEL DOCUMENTO 208 222 15
        rTxtLineSB += lclTemp;

        // PORCENTAJE MINIMO NUM(4,4) SOLO PARA PAGOS PARCIALES 223 230 8
        rTxtLineSB += PADSTR('', 8, '0');

        // ORDEN CRONOLOGICO NUM(01) 0:CRONOLOGICO 1:CUALQUIER FECHA 2:DEUDA CONSOLIDADA 231 231 1
        rTxtLineSB += '0';

        // FECHA DE EMISION CHAR(08) FECHA DE EMISION DEL RECIBO O DOCUMENTO 232 239 8
        rTxtLineSB += GetDate(pRecCollectionBuffer."Document Date");

        // FECHA DE VENCIMIENTO CHAR(08) FECHA DE VENCIMIENTO DEL RECIBO O DOC. 240 247 8
        rTxtLineSB += GetDate(pRecCollectionBuffer."Due Date");

        // DIAS DE PRORROGA NUM(03) PERMITE PAGAR DESPUES DEL VCTO 248 250 3
        if WorkDate() > pRecCollectionBuffer."Due Date" then
            rTxtLineSB += '900'
        else
            rTxtLineSB += '900';

        // CUENTA CARGO CHAR(14) CUENTA CARGO 251 264 14
        rTxtLineSB += PADSTR('', 14, ' ');

        // INDICADOR DE CARGO AUTOMATICO   01 = Cuotas Variables    02 = Cargo Automático 265 266 2
        rTxtLineSB += '01';

        // IND. TIPO DE AFILIACION  A= Adición  E= Eliminación M=Modificación  R=Reemplazo 267 267 1
        rTxtLineSB += pTRecord;

        // FECHA DE INICIO DE CARGO AUTOMATICO 268 275 8  // FECHA INICIO DE C.A CHAR(8) 
        rTxtLineSB += PADSTR('', 8, ' ');

        // FECHA FIN DE C.A CHAR(8) FECHA FIN DE CARGO AUTOMATICO 276 283 8 
        rTxtLineSB += PADSTR('', 8, ' ');

        //FILLER
        rTxtLineSB += PADSTR('', 6, ' ');

        // FIN DE REGISTRO CHAR(01) ULTIMA POSICION CON ASTERISCO "*" 290 290 1
        rTxtLineSB += '*';
    end;

    local procedure SCOTIATotalStructure(pBankNo: code[20]; pCurrencyCode: Code[10]) rTxtTotalSB: Text
    var
        lclTemp: Text;
        lclAmountTxt: Text;
    begin
        // TIPO DE REGISTRO CHAR(01) "D" 1 1 1
        rTxtTotalSB := 'C';

        //CUENTA EMPRESA
        gCompanyInformation.get();
        case pCurrencyCode OF
            '':
                begin
                    SecuenceSBP := '001';
                    rTxtTotalSB += gCompanyInformation."Bank Account No." + '  ';
                end;

            else begin
                    SecuenceSBP := '002';
                    rTxtTotalSB += gCompanyInformation."Bank Account No." + '  ';
                end;

        end;
        // rTxtTotalSB += SetValuesSCOTIA(pBankNo, pCurrencyCode) + '  ';

        //SECUENCIA/SERVICIO
        rTxtTotalSB += SecuenceSBP;

        //CODIGO CONCEPTO
        rTxtTotalSB += '01';

        //DESCRIPCION CONCEPTO
        if pCurrencyCode = '' then
            lclTemp := 'SUMINISTRO DE ENERGIA EN SOLES'
        else
            lclTemp := 'SUMINISTRO DE ENERGIA EN DOLAR';

        rTxtTotalSB += lclTemp + PADSTR(lclTemp, 30 - StrLen(lclTemp), ' ');

        //AFECTO AL PAGO PARCIAL
        rTxtTotalSB += '0';

        //CUENTA DE ABONO
        lclTemp := SetValuesSCOTIA(pBankNo, pCurrencyCode);
        rTxtTotalSB += lclTemp + PADSTR('', 14 - StrLen(lclTemp), ' ');

        //FILLER
        rTxtTotalSB += PADSTR('', 224, ' ');

        //FIN DE REGISTRO
        rTxtTotalSB += '*';
    end;

    local procedure INTERBANKHeaderStructure(pProcessDate: date; pCurrencyCode: code[10]; pTotalRecords: Integer; pTotalAmount: Decimal; pTRecord: Text) rTxtHeaderIBK: Text
    var
        lclAmountTxt: Text;
        lclAmountTxt1: Text;
        lclAmountTxt2: Text;
        lclTemp: Text;
    begin
        // Registro de Cabecera	Longitud	Inicio	Fin	Tipo	Enteros	Decimales	Descripción
        // 1	Tipo de registro	2	1	2	N	2		Valor fijo (ver valores)
        case gTipoRegistro of
            'Data Completa':
                rTxtHeaderIBK := '11';
            else
                rTxtHeaderIBK := '01';
        end;


        // 2	Código de grupo	2	3	4	N	2		Valor fijo (ver valores)
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += '00';
            else
                rTxtHeaderIBK += '21';
        end;
        // 3	Código de rubro	2	5	6	N	2		Código asignado por el banco
        // rTxtHeaderIBK += '00';

        // 4	Código de empresa	3	7	9	N	3		Código asignado por el banco
        // rTxtHeaderIBK += '000';

        // 5	Código de servicio	2	10	11	N	2		Código asignado por el banco
        // rTxtHeaderIBK += '00';

        // 6	Código de solicitud	2	12	13	N	2		Código que identifica a la solicitud 
        // rTxtHeaderIBK += '00';
        rTxtHeaderIBK += '074010101';

        // 7	Descripción de solicitud	30	14	43	A	30		Descripción de la solicitud
        rTxtHeaderIBK += PADSTR('', 30, ' ');

        // 8	Origen de la Solicitud	1	44	44	N	1		
        // Modalidad de ingreso solo para Pago Automático caso contrario cero
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += '1';
            else
                rTxtHeaderIBK += '0';
        end;

        // 9	Código de requerimiento	3	45	47	N	3		Valor fijo (ver valores)
        case gTipoRegistro of
            'Data Parcial':
                rTxtHeaderIBK += '001';
            'Data Completa':
                rTxtHeaderIBK += '002';
            'Pago Automatico':
                rTxtHeaderIBK += '000';
        end;
        // 10	Canal de envío	1	48	48	N	1		Valor fijo (ver valores)
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += '0';
            else
                rTxtHeaderIBK += '1';
        end;

        // 11	Tipo de información	1	49	49	A	1		
        // Tipo de información (ver valores) solo para Data Parcial y Data Completa caso contrario blanco
        rTxtHeaderIBK += pTRecord;

        // 12	Número de registros	15	50	64	N	15		Número de Registros de detalle 
        lclTemp := Format(pTotalRecords);
        rTxtHeaderIBK += PADSTR('', 15 - StrLen(lclTemp), '0') + lclTemp;

        // 13	Código único	10	65	74	N	10		Código asignado por el banco
        // rTxtHeaderIBK += PADSTR('', 10, '0');
        rTxtHeaderIBK += '0010793291';

        // 14	Fecha de proceso	8	75	82	N	8		Fecha a cargar/grabación de la información (Formato YYYYMMDD)
        rTxtHeaderIBK += GetDate(pProcessDate);

        // 15	Fecha de Inicio de Cargos	8	83	90	N	8		
        // Fecha de inicio de cargos recurrentes (Formato YYYYMMDD) solo para Pago Automático caso contrario ceros
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += GetDate(pProcessDate);
            else
                rTxtHeaderIBK += PADSTR('', 8, '0');
        end;
        case pCurrencyCode of
            '':
                begin
                    lclAmountTxt1 := DelChr(FORMAT(pTotalAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                    lclAmountTxt2 := PADSTR('', 15, '0');
                    lclTemp := '01';
                end;
            'USD':
                begin
                    lclAmountTxt2 := DelChr(FORMAT(pTotalAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                    lclAmountTxt1 := PADSTR('', 15, '0');
                    lclTemp := '02';
                end;
        end;
        // 16	Moneda	2	91	92	N	2		
        // Código de la moneda (ver valores) en la que esta incrita la empresa  solo para Pago Automático caso contrario ceros
        rTxtHeaderIBK += lclTemp;

        // 17	Importe total 1	15	93	107	N	13	2	Importe total en soles a cobrar (si la cobranza es en soles) solo para Data Completa, Importe total a cargar solo para Pago Automático caso contrario ceros
        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt1), '0') + lclAmountTxt1;
        rTxtHeaderIBK += lclTemp;

        // 18	Importe total 2	15	108	122	N	13	2	Importe total en dólares a cobrar (si la cobranza es en dólares) solo para Data Completa caso contrario ceros
        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt2), '0') + lclAmountTxt2;
        rTxtHeaderIBK += lclTemp;

        // 19	Tipo de Glosa	1	123	123	A	1		
        // Tipo de glosa (ver valores) a utilizar en las notas de abono/débito solo para Pago Automático
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += 'G';
            else
                rTxtHeaderIBK += ' ';
        end;

        // 20	Glosa General	50	124	173	A	50		
        // Relacionada al tipo de glosa solo para Pago Automático caso contrario blancos
        lclTemp := 'cobros automáticos';
        case gTipoRegistro of
            'Pago Automatico':
                rTxtHeaderIBK += lclTemp + PADSTR('', 50 - StrLen(lclTemp), ' ');
            else
                rTxtHeaderIBK += PADSTR('', 50, ' ');
        end;
        // 21	Libre	221	174	394	A	221		Blancos
        rTxtHeaderIBK += PADSTR('', 221, ' ');

        // 22	Tipo Formato	2	395	396	N	2		Valor fijo (ver valores)
        // 01: Data Parcial; 02: Data Completa; 03: Pago Automático
        // rTxtHeaderIBK += pTRecord;
        case gTipoRegistro of
            'Data Parcial':
                rTxtHeaderIBK += '01';
            'Data Completa':
                rTxtHeaderIBK += '02';
            'Pago Automatico':
                rTxtHeaderIBK += '03';
        end;

        // 23	Código fijo	4	397	400	N	4		Valor fijo (ver valores)
        rTxtHeaderIBK += '0000';
    end;

    local procedure INTERBANKQuotaPostStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary) rTxtQuotaIBK: Text
    var
        lclTemp: Text;
        lclDocNo: Text;
    begin
        // 1	Tipo de registro	2	1	2	N	2		Valor fijo (ver valores)
        rTxtQuotaIBK += '12';

        // 2	Código de cuota	8	3	10	A	8		Si no maneja cuotas llenar con ceros
        /*lclDocNo := pRecCollectionBuffer."Document No.";
        lclDocNo := fnFormatDocumentNo(lclDocNo);
        lclTemp := CopyStr(lclDocNo, StrPos(lclDocNo, '-') + 1, StrLen(lclDocNo));*/
        rTxtQuotaIBK += lclTemp + PADSTR('', 8 - StrLen(lclTemp), '0');

        // 3	Número de conceptos	1	11	11	N	1		Si no maneja conceptos llenar con 1
        rTxtQuotaIBK += '1';

        // 4	Descripción del concepto 1	10	12	21	A	10		Si no maneja conceptos llenar la descripción 1
        rTxtQuotaIBK += PADSTR('', 9, ' ') + '1';
        // 5	Descripción del concepto 2	10	22	31	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 6	Descripción del concepto 3	10	32	41	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 7	Descripción del concepto 4	10	42	51	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 8	Descripción del concepto 5	10	52	61	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 9	Descripción del concepto 6	10	62	71	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 10	Descripción del concepto 7	10	72	81	A	10		Si no maneja conceptos llenar con blancos
        rTxtQuotaIBK += PADSTR('', 10, ' ');

        // 11	Libre	313	82	394	A	313		Blancos
        rTxtQuotaIBK += PADSTR('', 313, ' ');

        // 12	Tipo Formato	2	395	396	N	2		Valor fijo (ver valores)
        case gTipoRegistro of
            'Data Completa':
                rTxtQuotaIBK += '02';
            else
                rTxtQuotaIBK += PADSTR('', 2, ' ');
        end;
        // 13	Código fijo	4	397	400	N	4		Valor fijo (ver valores)
        rTxtQuotaIBK += '0000';
    end;

    local procedure INTERBANKLinesStructure(var pRecCollectionBuffer: Record "Collection Payment Buffer" temporary;
                                                  pCurrencyCode: text;
                                                  TRecord: Text) rTxtLinesIBK: Text
    var
        lclTemp: Text;
        lclDocNo: Text;
        lclAmountTxt: Text;
    begin
        // 1	Tipo de registro	2	1	2	N	2		Valor fijo (ver valores)
        case gTipoRegistro of
            'Data Completa':
                rTxtLinesIBK := '13';
            else
                rTxtLinesIBK := '02';
        end;
        // 2	Código de deudor	20	3	22	A	20		Código numérico o Alfanumérico (alineado a la izquierda)
        // lclTemp := pRecCollectionBuffer."Customer No.";
        lclTemp := pRecCollectionBuffer."No. Suministro";
        lclTemp := DelChr(lclTemp, '=', gCaracteresNoValidos);
        rTxtLinesIBK += lclTemp + PADSTR('', 20 - StrLen(lclTemp), ' ');

        // 3	Nombre del deudor	30	23	52	A	30		
        // Nombre del Deudor solo para Data Parcial y Data Completa caso contrario espacios
        lclTemp := fnAdjsText(pRecCollectionBuffer."Customer Name", 30);
        lclTemp := DelChr(lclTemp, '=', gCaracteresNoValidos);
        rTxtLinesIBK += lclTemp + PADSTR('', 30 - StrLen(lclTemp), ' ');

        // 4	Referencia 1	10	53	62	A	10		
        // Referencia de Operación 1 solo para Data Parcial y Data Completa caso contrario espacios
        lclTemp := fnAdjsText(pRecCollectionBuffer."Customer No.", 10);
        case gTipoRegistro of
            'Data Parcial':
                rTxtLinesIBK += lclTemp;
            'Data Completa':
                rTxtLinesIBK += lclTemp;
            else
                rTxtLinesIBK += PADSTR('', 10, ' ');
        end;

        // 5	Referencia 2	10	63	72	A	10		
        // Referencia de Operación 2 solo para Data Parcial y Data Completa caso contrario espacios
        rTxtLinesIBK += PADSTR('', 10, ' ');

        // 6	Tipo de Operación	1	73	73	A	1		
        // Tipo de operación (ver valores) solo para Data Completa caso contrario espacio
        case gTipoOperacion of
            gTipoOperacion::Adicionar:
                rTxtLinesIBK += 'A';
            gTipoOperacion::Descargar:
                rTxtLinesIBK += 'D';
            gTipoOperacion::Eliminar:
                rTxtLinesIBK += 'E';
            gTipoOperacion::Modificar:
                rTxtLinesIBK += 'M';
            else
                rTxtLinesIBK += ' ';
        end;

        // 7	Código de cuota	8	74	81	A	8		
        // Código de Cuota (alineado a la izquierda) solo para Data Completa caso contrario espacios
        lclDocNo := pRecCollectionBuffer."Document No.";
        //lclDocNo := fnFormatDocumentNo(lclDocNo);
        lclDocNo := DelChr(lclDocNo, '=', '-');
        lclDocNo := CopyStr(lclDocNo, 5, 8);
        lclDocNo := PADSTR('', 8 - StrLen(lclDocNo), '0') + lclDocNo;
        case gTipoRegistro of
            'Data Completa':
                //rTxtLinesIBK += PADSTR('', 8, '0');
                rTxtLinesIBK += lclDocNo;
            else
                rTxtLinesIBK += PADSTR('', 8, '0');
        end;
        // 8	Fecha de emisión	8	82	89	N	8		
        // Fecha de emisión del documento a cobrar Formato YYYYMMDD solo para Data Completa caso contrario ceros
        rTxtLinesIBK += GetDate(pRecCollectionBuffer."Document Date");

        // 9	Fecha de vencimiento	8	90	97	N	8		
        // Fecha de Vencimiento del documento a cobrar Formato YYYYMMDD solo para Data Completa caso contrario ceros
        rTxtLinesIBK += GetDate(pRecCollectionBuffer."Due Date");

        // 10	Número de documento	15	98	112	A	15		
        // Número de Documento relacionado al cobro solo para Data Completa caso contrario espacios
        lclTemp := copystr(pRecCollectionBuffer."Document No.", 1, 15);
        lclTemp := DelChr(lclTemp, '=', '-');
        rTxtLinesIBK += lclTemp + PADSTR('', 15 - StrLen(lclTemp), ' ');

        // 11	Moneda de la deuda	2	113	114	N	2		Código de la moneda (ver valores) en la que esta incrita la empresa solo para Data Completa caso contrario ceros
        case pCurrencyCode of
            '':
                begin
                    rTxtLinesIBK += '01';
                    lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amt. (LCY)", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                end;
            'USD':
                begin
                    rTxtLinesIBK += '10';
                    lclAmountTxt := DelChr(FORMAT(pRecCollectionBuffer."Remaining Amount", 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                end;
        end;

        // 12	Importe del concepto 1	9	115	123	N	7	2	Si no maneja conceptos enviar el importe de la deuda solo para Data Completa caso contrario ceros
        lclTemp := PADSTR('', 9 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        rTxtLinesIBK += lclTemp;
        // rTxtLinesIBK += PADSTR('', 9, ' ');

        // 13	Importe del concepto 2	9	124	132	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 14	Importe del concepto 3	9	131	141	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 15	Importe del concepto 4	9	142	150	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 16	Importe del concepto 5	9	151	159	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 17	Importe del concepto 6	9	160	168	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 18	Importe del concepto 7	9	169	177	N	7	2	
        // Si no maneja conceptos enviar ceros solo para Data Completa caso contrario ceros
        rTxtLinesIBK += PADSTR('', 9, '0');

        // 19	Tipo de la cuenta Principal	1	178	178	A	1		
        // Tipo de la cuenta en que se va a cargar solo para Pago Automático caso contrario espacio
        case gTipoRegistro of
            'Pago Automatico':
                rTxtLinesIBK += 'D';
            else
                rTxtLinesIBK += ' ';
        end;
        // 20	Producto de la cuenta principal	3	179	181	A	3		
        // Producto de la cuenta del cliente a quien se le debitara (si es cuenta de depósitos) 
        // solo para Pago Automático caso contrario espacios
        case gTipoRegistro of
            'Pago Automatico':
                begin
                    case gRecBankAccount."Bank Account Type" of
                        gRecBankAccount."Bank Account Type"::"Current Account":
                            rTxtLinesIBK += '001';
                        gRecBankAccount."Bank Account Type"::"Savings Account":
                            rTxtLinesIBK += '002';
                        else
                            rTxtLinesIBK += PADSTR('', 3, ' ');
                    end;
                end;
            else
                rTxtLinesIBK += PADSTR('', 3, ' ');
        end;


        // 21	Moneda de la cuenta Principal	2	182	183	A	2		
        // Moneda de la cuenta del cliente a quien se le debitara (si es cuenta de depósitos) 
        // solo para Pago Automático caso contrario espacios
        case gTipoRegistro of
            'Pago Automatico':
                begin
                    case pRecCollectionBuffer."Currency Code" of
                        '':
                            rTxtLinesIBK += '01';
                        else
                            rTxtLinesIBK += '10';
                    end;
                end;
            else
                rTxtLinesIBK += PADSTR('', 2, ' ');
        end;
        // 22	Numero de la cuenta Principal	20	184	203	A	20		
        // Número de la cuenta del cliente a quien se le debitara solo para Pago Automático caso contrario espacios
        case gTipoRegistro of
            'Pago Automatico':
                begin
                    case gRecBankAccount."Bank Account Type" of
                        gRecBankAccount."Bank Account Type"::"Interbank Account":
                            rTxtLinesIBK += fnAdjsText(gRecBankAccount."Bank Account CCI", 20) + PADSTR('', 20 - STRLEN(fnAdjsText(gRecBankAccount."Bank Account CCI", 20)), ' ');
                        else
                            rTxtLinesIBK += fnAdjsText(gRecBankAccount."Bank Account No.", 20) + PADSTR('', 20 - STRLEN(fnAdjsText(gRecBankAccount."Bank Account No.", 20)), ' ');
                    end;
                end;
            else
                rTxtLinesIBK += PADSTR('', 20, ' ');
        end;


        // 23	Importe a abonar cuenta 1	15	204	218	N	13	2	
        // Importe a abonar en la cuenta recaudadora 1 solo para Pago Automático caso contrario ceros
        lclTemp := PADSTR('', 15 - STRLEN(lclAmountTxt), '0') + lclAmountTxt;
        case gTipoRegistro of
            'Pago Automatico':
                rTxtLinesIBK += lclTemp;
            else
                rTxtLinesIBK += PADSTR('', 15, '0');
        end;


        // 24	Tipo de la cuenta Secundaria	1	219	219	A	1		
        // Tipo de la cuenta secundaria en que se va a cargar solo para Pago Automático caso contrario espacio
        rTxtLinesIBK += PADSTR('', 1, ' ');

        // 25	Producto de la cuenta Secundaria	3	220	222	A	3		
        // Producto de la cuenta secundaria del cliente a quien se le debitara (si es cuenta de depósitos) 
        // solo para Pago Automático caso contrario espacios
        rTxtLinesIBK += PADSTR('', 3, ' ');

        // 26	Moneda de la cuenta Secundaria	2	223	224	A	2		
        // Moneda de la cuenta secundaria del cliente a quien se le debitara (si es cuenta de depósitos) 
        // solo para Pago Automático caso contrario espacios
        rTxtLinesIBK += PADSTR('', 2, ' ');

        // 27	Numero de la cuenta Secundaria	20	225	244	A	20		
        // Número de la cuenta secundaria del cliente a quien se le debitara solo para Pago Automático caso contrario espacios
        rTxtLinesIBK += PADSTR('', 20, ' ');

        // 28	Importe a abonar cuenta 2	15	245	259	N	13	2	
        // Importe a abonar en la cuenta recaudadora 2 solo para Pago Automático caso contrario ceros
        rTxtLinesIBK += PADSTR('', 15, '0');

        // 29	Glosa Particular	67	260	326	A	67		
        // Relacionada al tipo de glosa solo para Pago Automático caso contrario espacios
        lclTemp := 'Interbank pago automático';
        case gTipoRegistro of
            'Pago Automatico':
                rTxtLinesIBK += lclTemp + PADSTR('', 67 - StrLen(lclTemp), ' ');
            else
                rTxtLinesIBK += PADSTR('', 67, ' ');
        end;
        // 30	Libre	68	327	394	A	68		Blancos
        rTxtLinesIBK += PADSTR('', 68, ' ');

        // 31	Tipo Formato	2	395	396	N	2		Valor fijo (ver valores)
        case gTipoRegistro of
            'Data Parcial':
                rTxtLinesIBK += '01';
            'Data Completa':
                rTxtLinesIBK += '02';
            'Pago Automatico':
                rTxtLinesIBK += '03';
        end;
        // 32	Código fijo	4	397	400	N	4		Valor fijo (ver valores)
        rTxtLinesIBK += PADSTR('', 4, '0');
    end;

    procedure SetOpType(pTypeOp: text; pTypeFormat: text)
    begin
        TipoOperacionIBK := pTypeOp;
        TipoFormatoIBK := pTypeFormat;
    end;

    procedure SetInfoAditional(pBankCollection: Text; pBankNo: code[20];
     pCurrencyCode: Code[10]; pTipoArchivo: Option " ","Archivo de Reemplazo","Archivo de Actualización"
    ; pTipoRegistro: text;
     pTipoOperacion: option " ","Adicionar","Modificar","Eliminar","Descargar")
    begin
        //PC 26.05.21 ++++
        //--Save values globals
        gBankCollection := '';
        gCurrencyCode := '';
        gBankNo := '';
        gBankCollection := pBankCollection;
        gCurrencyCode := pCurrencyCode;
        gBankNo := pBankNo;
        gTipoArchivo := pTipoArchivo;
        gTipoRegistro := pTipoRegistro;
        gTipoOperacion := pTipoOperacion;

        gRecBankAccount.get(gBankNo);
        gRecBankAccount.TestField("Bank Account Type");
        if gRecBankAccount."Bank Account Type" = gRecBankAccount."Bank Account Type"::"Interbank Account" then
            gRecBankAccount.TestField("Bank Account CCI")
        else
            gRecBankAccount.TestField("Bank Account No.");
        //PC 26.05.21 ----
    end;

    local procedure fnFormatDocumentNo(pDocument: Text): Text
    var
        lclDocument: Text;
    begin
        lclDocument := pDocument;

        if StrPos(lclDocument, '-') = 0 then
            if UpperCase(CopyStr(lclDocument, 1, 1)) = 'V' then
                lclDocument := CopyStr(lclDocument, 2, 4) + '-' + CopyStr(lclDocument, 6, StrLen(lclDocument))
            else
                lclDocument := CopyStr(lclDocument, 1, 4) + '-' + CopyStr(lclDocument, 5, StrLen(lclDocument));

        exit(lclDocument);

    end;

    local procedure fngetNumberDocument(pDocument: Text): Integer
    var
        lclDocument: Text;
        lclletters: Label 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ-.';
        lclNumber: Integer;
    begin
        lclDocument := pDocument;

        if StrPos(lclDocument, '-') = 0 then
            lclDocument := DelChr(lclDocument, '=', lclletters)
        else
            lclDocument := CopyStr(lclDocument, StrPos(lclDocument, '-') + 1, StrLen(lclDocument));

        Evaluate(lclNumber, lclDocument);
        exit(lclNumber);
    end;


    procedure ShowNotificationForReconLineObserved(StatementNo: Code[20]; StatementType: Integer; BankAccountNo: Code[20]; pMessage: Text)
    var
        Notification: Notification;
        SeeHere: label 'See here', Comment = 'ESM="Ver aquí"';
    begin
        Notification.Message(pMessage);
        Notification.Scope := NotificationScope::LocalScope;
        Notification.SetData('StatementNo', StatementNo);
        Notification.SetData('StatementType', Format(StatementType));
        Notification.SetData('BankAccountNo', BankAccountNo);
        Notification.AddAction(SeeHere, Codeunit::"Mgmt Collection", 'OpenObservedListReconciliationLine');
        Notification.Send();
    end;

    procedure OpenObservedListReconciliationLine(Notification: Notification)
    var
        CBBAccReconLineObs: Page "CB Bank Acc. Recon. Line Obs";
        StatementNo: Code[20];
        StatementType: Text;
        BankAccountNo: Code[20];
        StatementTypeInt: Integer;
    begin
        StatementNo := Notification.GetData('StatementNo');
        StatementType := Notification.GetData('StatementType');
        BankAccountNo := Notification.GetData('BankAccountNo');
        Evaluate(StatementTypeInt, StatementType);
        SearchObserved(StatementNo, StatementTypeInt, BankAccountNo);
        Clear(CBBAccReconLineObs);
        CBBAccReconLineObs.SaveRecordTemporary(BankAccReconciliationLineTemp);
        CBBAccReconLineObs.RunModal();
    end;

    procedure IsExistObserved(): Boolean
    begin
        BankAccReconciliationLineTemp.Reset();
        exit(BankAccReconciliationLineTemp.FindFirst());
    end;

    local procedure fnAdjsText(pText: Text; pLongitud: Integer): Text
    begin
        if StrLen(pText) > pLongitud then
            exit(CopyStr(pText, 1, pLongitud));

        exit(pText);

    end;

    procedure SearchObserved(StatementNo: Code[20]; StatementType: Integer; BankAccountNo: Code[20])
    var
        DataExchField: Record "Data Exch. Field";
        ApplyType: Option "Document No.","Entry No.";
        DataExchNo: Integer;
        StatementLineNoAux: Integer;
        MyTransactionDateText: Text[250];
        MyStatementAmountText: Text[250];
        MyDay: Integer;
        MyMonth: Integer;
        MyYear: Integer;
    begin
        BankAccReconciliationLine.Reset();
        BankAccReconciliationLine.SetRange("Statement No.", StatementNo);
        BankAccReconciliationLine.SetRange("Statement Type", StatementType);
        BankAccReconciliationLine.SetRange("Bank Account No.", BankAccountNo);
        if BankAccReconciliationLine.FindFirst() then
            DataExchNo := BankAccReconciliationLine."Data Exch. Entry No.";

        if DataExchNo = 0 then
            exit;

        StatementLineNoAux := 0;

        DataExchField.Reset();
        DataExchField.SetRange("Data Exch. No.", DataExchNo);
        DataExchField.SetRange("Column No.", 1);//Document No
        if DataExchField.FindFirst() then
            repeat
                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Statement No.", StatementNo);
                BankAccReconciliationLine.SetRange("Statement Type", StatementType);
                BankAccReconciliationLine.SetRange("Bank Account No.", BankAccountNo);
                BankAccReconciliationLine.SetRange("Document No.", DataExchField.Value);
                if BankAccReconciliationLine.FindFirst() then begin
                    if BankAccReconciliationLine."Document No." <> GetAppliedNo(BankAccReconciliationLine, ApplyType::"Document No.") then begin
                        StatementLineNoAux += 10000;
                        BankAccReconciliationLineTemp.Init();
                        BankAccReconciliationLineTemp."Statement No." := StatementNo;
                        BankAccReconciliationLineTemp."Statement Type" := StatementType;
                        BankAccReconciliationLineTemp."Bank Account No." := BankAccountNo;
                        BankAccReconciliationLineTemp."Statement Line No." := StatementLineNoAux;
                        BankAccReconciliationLineTemp."Document No." := DataExchField.Value;
                        BankAccReconciliationLineTemp."Suministro No" := BankAccReconciliationLine."Suministro No";
                        MyTransactionDateText := GetValueFromDataExchFiel(DataExchNo, DataExchField."Line No.", 2);
                        Evaluate(MyDay, CopyStr(MyTransactionDateText, 1, 2));
                        Evaluate(MyMonth, CopyStr(MyTransactionDateText, 4, 2));
                        Evaluate(MyYear, CopyStr(MyTransactionDateText, 7, 4));
                        BankAccReconciliationLineTemp."Transaction Date" := DMY2Date(MyDay, MyMonth, MyYear);
                        MyStatementAmountText := GetValueFromDataExchFiel(DataExchNo, DataExchField."Line No.", 4);
                        Evaluate(BankAccReconciliationLineTemp."Statement Amount", MyStatementAmountText);
                        BankAccReconciliationLineTemp.Description := BankAccReconciliationLine.Description;
                        //BankAccReconciliationLineTemp.Insert();
                    end;
                end;

                BankAccReconciliationLine.Reset();
                BankAccReconciliationLine.SetRange("Statement No.", StatementNo);
                BankAccReconciliationLine.SetRange("Statement Type", StatementType);
                BankAccReconciliationLine.SetRange("Bank Account No.", BankAccountNo);
                BankAccReconciliationLine.SetRange("Document No.", DataExchField.Value);
                if BankAccReconciliationLine.IsEmpty then begin
                    StatementLineNoAux += 10000;
                    BankAccReconciliationLineTemp.Init();
                    BankAccReconciliationLineTemp."Statement No." := StatementNo;
                    BankAccReconciliationLineTemp."Statement Type" := StatementType;
                    BankAccReconciliationLineTemp."Bank Account No." := BankAccountNo;
                    BankAccReconciliationLineTemp."Statement Line No." := StatementLineNoAux;
                    BankAccReconciliationLineTemp."Document No." := DataExchField.Value;
                    BankAccReconciliationLineTemp."Suministro No" := BankAccReconciliationLine."Suministro No";
                    MyTransactionDateText := GetValueFromDataExchFiel(DataExchNo, DataExchField."Line No.", 2);
                    Evaluate(MyDay, CopyStr(MyTransactionDateText, 1, 2));
                    Evaluate(MyMonth, CopyStr(MyTransactionDateText, 4, 2));
                    Evaluate(MyYear, CopyStr(MyTransactionDateText, 7, 4));
                    BankAccReconciliationLineTemp."Transaction Date" := DMY2Date(MyDay, MyMonth, MyYear);
                    MyStatementAmountText := GetValueFromDataExchFiel(DataExchNo, DataExchField."Line No.", 4);
                    Evaluate(BankAccReconciliationLineTemp."Statement Amount", MyStatementAmountText);
                    BankAccReconciliationLineTemp.Insert();
                end;
            until DataExchField.Next() = 0;
    end;

    local procedure GetValueFromDataExchFiel(pDataExchNo: Integer; pLineNo: Integer; pColumnNo: Integer): Text[250]
    var
        DataExchField2: Record "Data Exch. Field";
    begin
        DataExchField2.SetRange("Data Exch. No.", pDataExchNo);
        DataExchField2.SetRange("Line No.", pLineNo);
        DataExchField2.SetRange("Column No.", pColumnNo);
        if DataExchField2.FindFirst() then
            exit(DataExchField2.Value);
        exit('');
    end;

    local procedure GetAppliedNo(pBankAccReconLine: Record "Bank Acc. Reconciliation Line"; ApplyType: Option "Document No.","Entry No."): Text
    var
        AppliedPaymentEntry: Record "Applied Payment Entry";
        AppliedNumbers: Text;
    begin
        AppliedPaymentEntry.SetRange("Statement Type", pBankAccReconLine."Statement Type");
        AppliedPaymentEntry.SetRange("Bank Account No.", pBankAccReconLine."Bank Account No.");
        AppliedPaymentEntry.SetRange("Statement No.", pBankAccReconLine."Statement No.");
        AppliedPaymentEntry.SetRange("Statement Line No.", pBankAccReconLine."Statement Line No.");

        AppliedNumbers := '';
        if AppliedPaymentEntry.FindSet then begin
            repeat
                if ApplyType = ApplyType::"Document No." then begin
                    if AppliedPaymentEntry."Document No." <> '' then
                        if AppliedNumbers = '' then
                            AppliedNumbers := AppliedPaymentEntry."Document No."
                        else
                            AppliedNumbers := AppliedNumbers + ', ' + AppliedPaymentEntry."Document No.";
                end else begin
                    if AppliedPaymentEntry."Applies-to Entry No." <> 0 then
                        if AppliedNumbers = '' then
                            AppliedNumbers := Format(AppliedPaymentEntry."Applies-to Entry No.")
                        else
                            AppliedNumbers := AppliedNumbers + ', ' + Format(AppliedPaymentEntry."Applies-to Entry No.");
                end;
            until AppliedPaymentEntry.Next = 0;
        end;

        exit(AppliedNumbers);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Payments", 'OnInitCustomerLedgerEntriesMatchingBufferSetFilter', '', false, false)]
    local procedure CU1255_OnInitCustomerLedgerEntriesMatchingBufferSetFilter(var CustLedgerEntry: Record "Cust. Ledger Entry"; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        BankAccReconciliationLine2: Record "Bank Acc. Reconciliation Line";
        DataExchField: Record "Data Exch. Field";
        FilterDocumentNo: Text;
    begin
        FilterDocumentNo := '';
        // BankAccReconciliationLine2.Reset();
        // BankAccReconciliationLine2.SetRange("Statement Type", BankAccReconciliationLine."Statement Type");
        // BankAccReconciliationLine2.SetRange("Bank Account No.", BankAccReconciliationLine."Bank Account No.");
        // BankAccReconciliationLine2.SetRange("Statement No.", BankAccReconciliationLine."Statement No.");
        // if BankAccReconciliationLine2.FindFirst() then
        //     repeat
        //         if FilterDocumentNo = '' then
        //             FilterDocumentNo := BankAccReconciliationLine2."Document No."
        //         else
        //             FilterDocumentNo += '|' + BankAccReconciliationLine2."Document No.";
        //     until BankAccReconciliationLine2.Next() = 0;
        DataExchField.Reset();
        DataExchField.SetRange("Data Exch. No.", BankAccReconciliationLine."Data Exch. Entry No.");
        DataExchField.SetRange("Column No.", 1);
        if DataExchField.FindFirst() then
            repeat
                if FilterDocumentNo = '' then
                    FilterDocumentNo := DataExchField.Value
                else
                    FilterDocumentNo += '|' + DataExchField.Value;
            until DataExchField.Next() = 0;
        if FilterDocumentNo <> '' then
            CustLedgerEntry.SetFilter("Document No.", FilterDocumentNo);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Payments", 'OnInitBankAccLedgerEntriesMatchingBufferSetFilter', '', false, false)]
    local procedure OnInitBankAccLedgerEntriesMatchingBufferSetFilter(var BankAccountLedgerEntry: Record "Bank Account Ledger Entry"; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        BankAccountLedgerEntry.SetRange("Document No.", 'BANKENTRYDOCNOEMPTY');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Payments", 'OnInitVendorLedgerEntriesMatchingBufferSetFilter', '', false, false)]
    local procedure OnInitVendorLedgerEntriesMatchingBufferSetFilter(var VendorLedgerEntry: Record "Vendor Ledger Entry"; var BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    begin
        VendorLedgerEntry.SetRange("Document No.", 'VENDENTRYDOCNOEMPTY');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Bank Acc. Reconciliation Post", 'OnPostPaymentApplicationsOnAfterInitGenJnlLine', '', false, false)]
    local procedure OnPostPaymentApplicationsOnAfterInitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line")
    var
        SLSetup: Record "Setup Localization";
        pag1294: page 1294;
        CurrExchRate: Record "Currency Exchange Rate";
        GLSetup: Record "General Ledger Setup";
    begin
        SLSetup.Get();
        GLSetup.Get();
        if not SLSetup."Validate Curr. Exch. Posting" then
            exit;
        CurrExchRate.Reset();
        CurrExchRate.SetRange("Currency Code", GLSetup."Additional Reporting Currency");
        CurrExchRate.SetRange("Starting Date", Today);
        CurrExchRate.FindFirst();

        //FMM 07.02.22
        CurrExchRate.Reset();
        CurrExchRate.SetRange("Currency Code", GLSetup."Additional Reporting Currency");
        CurrExchRate.SetRange("Starting Date", GenJournalLine."Posting Date");
        CurrExchRate.FindFirst();

        SLSetup.TestField("RB Journal Template Name");
        SLSetup.TestField("RB Journal Batch Name");
        GenJournalLine."Journal Template Name" := SLSetup."RB Journal Template Name";
        GenJournalLine."Journal Batch Name" := SLSetup."RB Journal Batch Name";
        GenJournalLine."External Document No." := BankAccReconciliationLine."Transaction ID";
        GenJournalLine."ST Document No. Conciliation" := BankAccReconciliationLine.GetAppliedToDocumentNo();
        GenJournalLine."ST IS Conciliation" := true;
    end;

    [EventSubscriber(ObjectType::Table, database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(VAR CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        SLSetup: Record "Setup Localization";
        pag1294: page 1294;
    begin
        SLSetup.Get();
        if GenJournalLine."ST IS Conciliation" then
            CustLedgerEntry."External Document No." := GenJournalLine."ST Document No. Conciliation";
    end;

    local procedure fnRemoveCero(pValor: Text): Text
    begin
        if pValor = '' then
            exit(pValor);

        if CopyStr(pValor, 1, 1) <> '0' then
            exit(pValor);

        while CopyStr(pValor, 1, 1) = '0' DO begin
            pValor := CopyStr(pValor, 2, StrLen(pValor));
        end;

        exit(pValor);

    end;

    local procedure fnReplAceaccentmark(pValor: Text): Text
    begin
        pValor := DelChr(pValor, '=', gCaracteresNoValidos);
        pValor := pValor.Replace('á', 'a');
        pValor := pValor.Replace('é', 'e');
        pValor := pValor.Replace('í', 'i');
        pValor := pValor.Replace('ó', 'o');
        pValor := pValor.Replace('ú', 'u');
        pValor := pValor.Replace('Á', 'A');
        pValor := pValor.Replace('É', 'E');
        pValor := pValor.Replace('Í', 'I');
        pValor := pValor.Replace('Ó', 'O');
        pValor := pValor.Replace('Ú', 'U');

        pValor := pValor.Replace('à', 'a');
        pValor := pValor.Replace('è', 'e');
        pValor := pValor.Replace('è', 'i');
        pValor := pValor.Replace('ò', 'o');
        pValor := pValor.Replace('ù', 'u');
        pValor := pValor.Replace('À', 'A');
        pValor := pValor.Replace('È', 'E');
        pValor := pValor.Replace('Ì', 'I');
        pValor := pValor.Replace('Ò', 'O');
        pValor := pValor.Replace('Ù', 'U');
        exit(pValor);
    end;

    var
        SLSetup: Record "Setup Localization";
        gCurrencyCode: Text;
        gBankNo: Text;
        gBankCollection: Text;
        gTipoArchivo: option " ","Archivo de Reemplazo","Archivo de Actualización";
        gCaracteresNoValidos: Label '-/][{}-.ª!""·$$%&%$&/(&/()=?¿*^Ç';
        gCaracteresNoValidosBCP: Label '/][{}.ª!""·$$%&%$&/(&/()=?¿*^Ç';
        gGeneratearrears: Boolean;
        gOnlyNumbers: Label '-/][{}-.ª!""·$$%&%$&/(&/()=?¿*^ÇABCDEFGHIJOKLMNÑOPQRSTUVWXYZabcdefghijklmnñopqrstuvwxyz';
        gTipoOperacion: option " ","Adicionar","Modificar","Eliminar","Descargar";
        gTipoRegistro: Text;
        gRecBankAccount: Record "Bank Account";
        gReconciliationLineBuffer: Record "BankReconciliation Line Buffer";
        gBankAccountCod: Text;
        gStatementNo: Text;
        gStatementLine: Integer;
        gCompanyInformation: Record "Company Information";
    // [EventSubscriber(ObjectType::Codeunit, Codeunit::"Match Bank Pmt. Appl.", 'OnAfterMatchBankPayments', '', false, false)]
    // local procedure OnAfterMatchBankPayments(var BankAccReconciliation: Record "Bank Acc. Reconciliation")
    // var
    // begin

    // end;
}
