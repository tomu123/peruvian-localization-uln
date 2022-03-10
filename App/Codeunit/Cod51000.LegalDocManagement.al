codeunit 51000 "Legal Document Management"
{
    var
        /*Codeunit12: Codeunit 20;
        Page256: Page 39;
        CancellingOnly: Boolean;
        IsOutFlowLegelDocument: Boolean;
        IsCancellLegelDocument: Boolean;
        IsCancellLegalDocument: Boolean;
        CorrectPostedInvoiceQst: Label 'The posted sales invoice will be canceled, and a new version of the sales invoice will be created so that you can make the correction.\ \Do you want to continue?';
        PostingCreditMemoFailedOpenPostedCMQst: Label 'Canceling the invoice failed because of the following Error: \\%1\\A credit memo is posted. Do you want to open the posted credit memo?';
        PostingCreditMemoFailedOpenCMQst: Label 'Canceling the invoice failed because of the following Error: \\%1\\A credit memo is created but not posted. Do you want to open the credit memo?';
        CreatingCreditMemoFailedNothingCreatedErr: Label 'Canceling the invoice failed because of the following Error: \\%1.';
        WrongDocumentTypeForCopyDocumentErr: Label 'You cannot correct or cancel this type of document.';
        CancelPostedSalesInvoiceQst: Label 'The posted sales invoice will be canceled, and a sales credit memo will be created and posted, which reverses the posted sales invoice.\ \Do you want to continue?';
        OpenPostedSalesCreditMemoQst: Label 'A credit memo was successfully created. Do you want to open the posted credit memo?';

        CancelPostedPurchInvoiceQst: Label 'The posted purchase invoice will be canceled, and a purchase credit memo will be created and posted, which reverses the posted purchase invoice.\ \Do you want to continue?';
        OpenPostedPurchCreditMemoQst: Label 'A credit memo was successfully created. Do you want to open the posted credit memo?';

        CancelPostedSalesCrMemoQst: Label 'The posted sales credit memo will be canceled, and a sales invoice will be created and posted, which reverses the posted sales credit memo. Do you want to continue?';

        OpenPostedSalesInvQst: Label 'The invoice was successfully created. Do you want to open the posted invoice?';

        CancelPostedPurchCrMemoQst: Label 'The posted purchase credit memo will be canceled, and a purchase invoice will be created and posted, which reverses the posted purchase credit memo. Do you want to continue?';

        OpenPostedPurchInvQst: Label 'The invoice was successfully created. Do you want to open the posted invoice?';*/
        ErrorVatRegistrationNo: Label 'The length of the document does not meet the required length and format.';

    trigger OnRun()
    begin

    end;

    //Validations
    procedure validateLegalDocumentFormat(DocumentNo: Code[50]; LegalNo: Code[10]; var Serie: Code[20]; var Number: Code[20]; Onlyvalidate: Boolean; ShowError: Boolean)
    var
        LegalDocument: Record "Legal Document";
        MySerie: Code[20];
        MyNumber: Code[20];
        AllowCharactersAlphanumeric: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        AllosCharactersNumeric: Label '0123456789';
        ErrorLegalDocument: Label 'The serial number and document do not correspond to the configuration of the "Legal Document" table.';
        MessageLegalDocument: Label 'The serial number and document do not correspond to the configuration of the "Legal Document" table.';
    begin
        Clear(Serie);
        Clear(Number);
        if StrPos(DocumentNo, '-') > 0 then begin
            MySerie := CopyStr(DocumentNo, 1, StrPos(DocumentNo, '-') - 1);
            MyNumber := CopyStr(DocumentNo, StrPos(DocumentNo, '-') + 1, 50)
        end else begin
            MySerie := '';
            MyNumber := DocumentNo;
        end;

        LegalDocument.Reset();
        LegalDocument.SetRange("Document Type", LegalDocument."Option Type"::"SUNAT Table");
        LegalDocument.SetRange("Type Code", '10');
        LegalDocument.SetRange("Legal No.", LegalNo);
        if LegalDocument.FindSet() then begin

            if LegalDocument."Serie Allow Alphanumeric" then
                MySerie := DelChr(MySerie, '=', DelChr(MySerie, '=', AllowCharactersAlphanumeric))
            else
                MySerie := DelChr(MySerie, '=', DelChr(MySerie, '=', AllosCharactersNumeric));

            if LegalDocument."Number Allow Alphanumeric" then
                MyNumber := DelChr(MyNumber, '=', DelChr(MyNumber, '=', AllowCharactersAlphanumeric))
            else
                MyNumber := DelChr(MyNumber, '=', DelChr(MyNumber, '=', AllosCharactersNumeric));

            if (LegalDocument."Serie Lenght" > STRLEN(MySerie)) and (STRLEN(MySerie) > 0) and (LegalDocument."Adjust Serie") then
                MySerie := PADSTR('', LegalDocument."Serie Lenght" - STRLEN(MySerie), '0') + MySerie;

            if (LegalDocument."Number Lenght" > STRLEN(MyNumber)) and (LegalDocument."Adjust Number") then
                MyNumber := PADSTR('', LegalDocument."Number Lenght" - STRLEN(MyNumber), '0') + MyNumber;

            if (LegalDocument."Serie Lenght" < STRLEN(MySerie)) then
                MySerie := COPYSTR(MySerie, STRLEN(MySerie) - LegalDocument."Serie Lenght" + 1, 20);

            if (LegalDocument."Number Lenght" < STRLEN(MyNumber)) then
                MyNumber := COPYSTR(MyNumber, STRLEN(MyNumber) - LegalDocument."Number Lenght" + 1, 20);

            if Onlyvalidate then begin
                if (Serie <> MySerie) or (Number <> MyNumber) then begin
                    if ShowError then
                        Error(ErrorLegalDocument)
                    else
                        Message(MessageLegalDocument);
                end
                else begin
                    Serie := MySerie;
                    Number := MyNumber;
                end;
            end else begin
                Serie := MySerie;
                Number := MyNumber;
            end;
            //end;
        end else begin
            Serie := MySerie;
            Number := MyNumber;
        end;

    end;

    //Process
    procedure AssignandControlLegalDocumentsValue(var NoSerieCode: Code[20]; var LegalDoc: Code[10]; var LegalStatus: option; var LegalDocRef: Code[10]; ShowError: Boolean; CorrectValues: Boolean)
    var
        NoSeries: Record "No. Series";
    begin
        NoSeries.Reset();
        NoSeries.SetRange(Code, NoSerieCode);
        if NoSeries.FindFirst() then begin
            if ShowError then begin
                NoSeries.TestField("Legal Document", LegalDoc);
                NoSeries.TestField("Legal Status", LegalStatus);
                NoSeries.TestField("Legal Document Ref.", LegalDocRef);
            end;
            if CorrectValues then begin
                LegalDoc := NoSeries."Legal Document";
                LegalStatus := NoSeries."Legal Status";
                LegalDocRef := NoSeries."Legal Document Ref.";
            end;
        end;
    end;

    //Integrations for validations
    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterModifyEvent', '', true, true)]
    local procedure CustAlterModifyEvent(RunTrigger: Boolean; var Rec: Record Customer; var xRec: Record Customer)
    begin
        if xRec."VAT Registration No." <> Rec."VAT Registration No." then
            if Rec."VAT Registration No." <> '' then
                if ((Rec."VAT Registration Type" <> '') and (Rec."VAT Registration Type" = '1') and
                    (StrLen(Rec."VAT Registration No.") <> 8)) or
                    ((Rec."VAT Registration Type" <> '') and (Rec."VAT Registration Type" = '6') and
                    (StrLen(Rec."VAT Registration No.") <> 11)) then
                    Error(ErrorVatRegistrationNo);
    end;

    [EventSubscriber(ObjectType::Table, Database::Vendor, 'OnAfterModifyEvent', '', true, true)]
    local procedure VendAlterModifyEvent(RunTrigger: Boolean; var Rec: Record Vendor; var xRec: Record Vendor)
    begin
        if xRec."VAT Registration No." <> Rec."VAT Registration No." then
            if Rec."VAT Registration No." <> '' then
                if ((Rec."VAT Registration Type" <> '') and (Rec."VAT Registration Type" = '1') and
                    (StrLen(Rec."VAT Registration No.") <> 8)) or
                    ((Rec."VAT Registration Type" <> '') and (Rec."VAT Registration Type" = '6') and
                    (StrLen(Rec."VAT Registration No.") <> 11)) then
                    Error(ErrorVatRegistrationNo);
    end;

    //Integrations and suscriptions
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCustomerEntry', '', true, true)]
    procedure SetCustTransferLegalDocument(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line")
    var
        Codeunit80: Codeunit 80;
    begin
        GenJnlLine."Legal Document" := SalesHeader."Legal Document";
        GenJnlLine."Legal Status" := SalesHeader."Legal Status";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostVendorEntry', '', true, true)]
    procedure SetVendTransferLegalDocument(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; var TotalPurchLine: Record "Purchase Line"; var TotalPurchLineLCY: Record "Purchase Line")
    var
        Codeunit90: Codeunit 90;
    begin
        GenJnlLine."Legal Document" := PurchHeader."Legal Document";
        //GenJnlLine."Legal Status" := PurchHeader."Legal Status";
        case PurchHeader."Legal Status" of
            PurchHeader."Legal Status"::Success:
                GenJnlLine."Legal Status" := GenJnlLine."Legal Status"::Success;
            PurchHeader."Legal Status"::OutFlow:
                GenJnlLine."Legal Status" := GenJnlLine."Legal Status"::OutFlow;
        end;
        GenJnlLine."Accountant receipt date" := PurchHeader."Accountant receipt date";
    end;

    [EventSubscriber(ObjectType::Table, DataBase::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', true, true)]
    procedure SetCopyCustLedgerEntryFromGenJnlLine(var CustLedgerEntry: Record "Cust. Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        CustLedgerEntry."Legal Document" := GenJournalLine."Legal Document";
        CustLedgerEntry."Legal Status" := GenJournalLine."Legal Status";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', true, true)]
    procedure SetCopyVendLedgerEntryFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    var
        DtldRetentionLedgEntry: Record "Detailed Retention Ledg. Entry";
        RetentionLE: Record "Retention Ledger Entry";
    begin
        VendorLedgerEntry."Legal Document" := GenJournalLine."Legal Document";
        VendorLedgerEntry."Legal Status" := GenJournalLine."Legal Status";
        VendorLedgerEntry."Accountant receipt date" := GenJournalLine."Accountant receipt date";
        VendorLedgerEntry."Retention No." := GenJournalLine."Retention No.";
        if VendorLedgerEntry."Retention No." = '' then begin
            DtldRetentionLedgEntry.Reset();
            DtldRetentionLedgEntry.SetRange("Vendor External Document No.", VendorLedgerEntry."External Document No.");
            DtldRetentionLedgEntry.SetRange("Vendor No.", VendorLedgerEntry."Vendor No.");
            DtldRetentionLedgEntry.SetRange("Source Document No.", VendorLedgerEntry."Document No.");
            if DtldRetentionLedgEntry.FindFirst() then begin
                VendorLedgerEntry."Retention No." := DtldRetentionLedgEntry."Retention No.";
                VendorLedgerEntry."Retention Amount" := DtldRetentionLedgEntry."Amount Retention";
                VendorLedgerEntry."Retention Amount LCY" := DtldRetentionLedgEntry."Amount Retention LCY";
            end;
            if GenJournalLine."Setup Source Code" = GenJournalLine."Setup Source Code"::"Reverse Retention" then begin
                RetentionLE.Reset();
                RetentionLE.SetRange("Retention No.", VendorLedgerEntry."Retention No.");
                if RetentionLE.FindFirst() then begin
                    RetentionLE."Legal Status" := RetentionLE."Legal Status"::Anulled;
                    RetentionLE.Modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"VAT Entry", 'OnAfterCopyFromGenJnlLine', '', true, true)]
    procedure SetCopyVATEntryFromGenJnlLine(var VATEntry: Record "VAT Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VATEntry."Legal Document" := GenJournalLine."Legal Document";
        VATEntry."Legal Status" := GenJournalLine."Legal Status";
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    procedure SetCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    var
        DtldRetentionLedgEntry: Record "Detailed Retention Ledg. Entry";
    begin
        GLEntry."Legal Document" := GenJournalLine."Legal Document";
        GLEntry."Legal Status" := GenJournalLine."Legal Status";
        GLEntry."Retention No." := GenJournalLine."Retention No.";
        if GLEntry."Retention No." = '' then begin
            DtldRetentionLedgEntry.Reset();
            DtldRetentionLedgEntry.SetRange("Vendor External Document No.", GLEntry."External Document No.");
            DtldRetentionLedgEntry.SetRange("Source Document No.", GLEntry."Document No.");
            if DtldRetentionLedgEntry.FindFirst() then begin
                GLEntry."Retention No." := DtldRetentionLedgEntry."Retention No.";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', true, true)]
    local procedure SetCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Legal Status" := SalesHeader."Legal Status";
        GenJournalLine."Legal Document" := SalesHeader."Legal Document";
        GenJournalLine."Legal Document Ref." := SalesHeader."Legal Document Ref.";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', true, true)]
    local procedure SetCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        //GenJournalLine."Legal Status" := PurchaseHeader."Legal Status";
        case PurchaseHeader."Legal Status" of
            PurchaseHeader."Legal Status"::Success:
                GenJournalLine."Legal Status" := GenJournalLine."Legal Status"::Success;
            PurchaseHeader."Legal Status"::OutFlow:
                GenJournalLine."Legal Status" := GenJournalLine."Legal Status"::OutFlow;
        end;
        GenJournalLine."Legal Document" := PurchaseHeader."Legal Document";
        GenJournalLine."Legal Document Ref." := PurchaseHeader."Legal Document Ref.";
        GenJournalLine."Accountant receipt date" := PurchaseHeader."Accountant receipt date";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitRecord', '', true, true)]
    procedure AssignLegalDocumentValues(var SalesHeader: Record "Sales Header")
    begin
        AssignandControlLegalDocumentsValue(SalesHeader."Posting No. Series", SalesHeader."Legal Document", SalesHeader."Legal Status", SalesHeader."Legal Document Ref.", False, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyBuyFromVendorFieldsFromVendor', '', true, true)]
    local procedure SetAfterCopyBuyFromVendorFieldsFromVendor(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor; xPurchaseHeader: Record "Purchase Header")
    begin
        PurchaseHeader."VAT Registration Type" := Vendor."VAT Registration Type";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCopySellToCustomerAddressFieldsFromCustomer', '', true, true)]
    local procedure SetOnAfterCopySellToCustomerAddressFieldsFromCustomer(var SalesHeader: Record "Sales Header"; SellToCustomer: Record Customer; CurrentFieldNo: Integer)
    begin
        SalesHeader."VAT Registration Type" := SellToCustomer."VAT Registration Type";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptHeaderInsert', '', true, true)]
    local procedure SetOnAfterPurchRcptHeaderInsert(var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchaseHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        PurchRcptHeader."Legal Document" := PurchaseHeader."Legal Document";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeReturnShptHeaderInsert', '', true, true)]
    local procedure SetOnBeforeReturnShptHeaderInsert(var ReturnShptHeader: Record "Return Shipment Header"; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean)
    begin
        //OnBeforeReturnShptHeaderInsert(ReturnShptHeader, PurchHeader, SuppressCommit);
        ReturnShptHeader."Legal Document" := PurchHeader."Legal Document";
        //ReturnShptHeader."Legal Status" := PurchHeader."Legal Status";
        case PurchHeader."Legal Status" of
            PurchHeader."Legal Status"::Success:
                ReturnShptHeader."Legal Status" := ReturnShptHeader."Legal Status"::Success;
            PurchHeader."Legal Status"::OutFlow:
                ReturnShptHeader."Legal Status" := ReturnShptHeader."Legal Status"::OutFlow;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    procedure OnBeforeConfirmPost(var PurchaseHeader: Record "Purchase Header");
    begin
        if (PurchaseHeader."Legal Status" = PurchaseHeader."Legal Status"::Success) and
            ((PurchaseHeader."Legal Document" = '08') or
            (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::"Credit Memo")) then begin
            PurchaseHeader.TestField("Legal Document Ref.");
            PurchaseHeader.TestField("Applies-to Serie Ref.");
            PurchaseHeader.TestField("Applies-to Number Ref.");
            PurchaseHeader.TestField("Applies-to Document Date Ref.");
        end;

        if PurchaseHeader."Legal Status" <> PurchaseHeader."Legal Status"::Success then
            PurchaseHeader.TestField("Applies-to Doc. No.");
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post (Yes/No)", 'OnBeforeConfirmSalesPost', '', true, true)]
    procedure OnBeforeConfirmPostSales(var SalesHeader: Record "Sales Header");
    var
        CU91: Codeunit "Purch.-Post (Yes/No)";
    begin
        //ULN::PC 001  2020.06.01 v.001 Begin 
        //Agregado Solicitado por liseth
        if (not SalesHeader."Internal Consumption") and (SalesHeader."Legal Status" = SalesHeader."Legal Status"::Success) and
            ((SalesHeader."Legal Document" = '08') or
            (SalesHeader."Document Type" = SalesHeader."Document Type"::"Credit Memo")) then begin
            SalesHeader.TestField("Legal Document Ref.");
            SalesHeader.TestField("Applies-to Serie Ref.");
            SalesHeader.TestField("Applies-to Number Ref.");
            SalesHeader.TestField("Applies-to Document Date Ref.");
            //ULN::PC 001  2020.06.01 v.001 End
        end;

        if SalesHeader."Legal Status" <> SalesHeader."Legal Status"::Success then
            SalesHeader.TestField("Applies-to Doc. No.");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterRunWithoutCheck', '', false, false)]
    procedure Set_OnAfterRunWithoutCheck(var GenJnlLine: Record "Gen. Journal Line")
    var
        GLSetup: Record "General Ledger Setup";
        SLSetup: Record "Setup Localization";
        GenJnlLine_: Record "Gen. Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SLSetup.Get();
        GLSetup.Get();
        SourceCodeSetup.Get();
        if not SLSetup."Validate Curr. Exch. Posting" then
            exit;

        if SourceCodeSetup."Code Close" = GenJnlLine."Source Code" then
            exit;
        CurrExchRate.Reset();
        CurrExchRate.SetRange("Currency Code", GLSetup."Additional Reporting Currency");
        CurrExchRate.SetRange("Starting Date", Today);
        CurrExchRate.FindFirst();

        //FMM 07.02.22
        if GenJnlLine."Posting Date" <> 0D then begin
            CurrExchRate.Reset();
            CurrExchRate.SetRange("Currency Code", GLSetup."Additional Reporting Currency");
            CurrExchRate.SetRange("Starting Date", GenJnlLine."Posting Date");
            CurrExchRate.FindFirst();
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    procedure Set_OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        if PurchaseHeader."Legal Document" = '' then
            Error('El campo Documento legal no puede estar vacío.');
    end;
    /*
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnBeforeAutoArchiveSalesDocument', '', true, true)]
    procedure OnBeforeDeleteSalesHeader(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        SalesHeader."Posting No." := '';
    end;
    */
}