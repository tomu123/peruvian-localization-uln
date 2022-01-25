codeunit 51001 "Accountant Book Management"
{
    trigger OnRun()
    begin

    end;
    //Global Functions

    local procedure OpenWindows(CreateFileFlag: Boolean)
    var
        ContaintText: Text[200];
    begin
        ContaintText := Processing;
        if CreateFileFlag then
            ContaintText += CreatingFile;
        Windows.Open(ContaintText);
    end;

    local procedure UpdateWindows(Number: Integer; Counter: Integer; Total: Integer)
    begin
        Windows.Update(Number, ROUND(Counter / Total * 10000, 2));
    end;

    local procedure CloseWindows()
    begin
        Windows.Close();
    end;

    local procedure GetCurrencyCode(SourceCurrencyCode: Code[20]; var DestCurrencyCode: Code[20])
    begin
        if SourceCurrencyCode = '' then
            DestCurrencyCode := 'PEN'
        else
            DestCurrencyCode := SourceCurrencyCode;
    end;

    //General Journal Books
    procedure GenJournalBooks(pBookCode: Code[10]; IsEBook: Boolean)
    begin
        BookCode := pBookCode;
        if not NotRequestDate then
            if not SetDate() then
                exit;
        if not CheckDateExists() then
            exit;
        OpenWindows(IsEBook);
        CreateGenJnlTempRecord();
        if IsEBook then
            CreateFileEBookFromGenJournalRecord();
        CloseWindows();
    end;

    local procedure CreateGenJnlTempRecord()
    var
        GLEntry: Record "G/L Entry";
        GLAccount: Record "G/L Account";
        EntryNo: Integer;
        TotalRecords: Integer;
        CountRecords: Integer;
        GenJnlBookBufferFilter: Record "Gen. Journal Book Buffer" temporary;
    begin
        EntryNo := 0;
        CountRecords := 0;
        case BookCode of
            '501':
                begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Posting Date", StartDate, ClosingDate(EndDate));
                    GLEntry.SetFilter("Source Code", '<>%1&<>%2', 'DESLVENTA', 'DESLCOMPR');
                    GLEntry.SetFilter("Transaction CUO", '<>%1', 0);
                    TotalRecords := GLEntry.Count;
                    if GLEntry.FindFirst() then
                        repeat
                            EntryNo += 1;
                            CountRecords += 1;
                            GLEntry.CalcFields("G/L Account Name");
                            GenJnlBookBuffer.Init();
                            GenJnlBookBuffer."Entry No." := EntryNo;
                            GenJnlBookBuffer."Document No." := GLEntry."Document No.";
                            GenJnlBookBuffer.Period := Format(EndDate, 0, '<Year4><Month,2>') + '00';
                            GenJnlBookBuffer."Transaction CUO" := GLEntry."Transaction CUO";
                            GenJnlBookBuffer."Correlative cuo" := GLEntry."Correlative CUO";
                            GenJnlBookBuffer."G/L Account No." := GLEntry."G/L Account No.";
                            GenJnlBookBuffer."G/L Account Name" := GLEntry."G/L Account Name";
                            SetInformationFromEntry(GLEntry);
                            GenJnlBookBuffer."Source Code" := GLEntry."Source Code";
                            GenJnlBookBuffer."Legal Document" := GLEntry."Legal Document";
                            GenJnlBookBuffer."Posting Date Filter" := GLEntry."Posting Date";
                            GenJnlBookBuffer.Insert();
                            UpdateWindows(1, CountRecords, TotalRecords);
                        until GLEntry.Next() = 0;
                end;
            '601':
                begin
                    GLEntry.Reset();
                    GLEntry.SetRange("Posting Date", StartDate, ClosingDate(EndDate));
                    GLEntry.SetFilter("Source Code", '<>%1&<>%2', 'DESLVENTA', 'DESLCOMPR');
                    GLEntry.SetFilter("Transaction CUO", '<>%1', 0);
                    TotalRecords := GLEntry.Count;
                    if GLEntry.FindFirst() then
                        repeat
                            EntryNo += 1;
                            CountRecords += 1;
                            GLEntry.CalcFields("G/L Account Name");
                            GenJnlBookBuffer.Init();
                            GenJnlBookBuffer."Entry No." := EntryNo;
                            GenJnlBookBuffer."Document No." := GLEntry."Document No.";
                            GenJnlBookBuffer.Period := Format(EndDate, 0, '<Year4><Month,2>') + '00';
                            GenJnlBookBuffer."Transaction CUO" := GLEntry."Transaction CUO";
                            GenJnlBookBuffer."Correlative cuo" := GLEntry."Correlative CUO";
                            GenJnlBookBuffer."G/L Account No." := GLEntry."G/L Account No.";
                            GenJnlBookBuffer."G/L Account Name" := GLEntry."G/L Account Name";
                            SetInformationFromEntry(GLEntry);
                            GenJnlBookBuffer."Source Code" := GLEntry."Source Code";
                            GenJnlBookBuffer."Legal Document" := GLEntry."Legal Document";
                            GenJnlBookBuffer."Posting Date Filter" := GLEntry."Posting Date";
                            GenJnlBookBuffer.Insert();
                            UpdateWindows(1, CountRecords, TotalRecords);
                        until GLEntry.Next() = 0;
                    GLAccount.RESET;
                    GLAccount.SetRange("Date Filter", 0D, CalcDate('<-1D>', StartDate));
                    //GLAccount.CalcFields("Balance at Date");
                    GLAccount.SetFilter("Balance at Date", '<>0');
                    if (GLAccount.FINDSET) then
                        repeat
                            GenJnlBookBuffer.Reset();
                            GenJnlBookBuffer.SetFilter("G/L Account No.", GLAccount."No.");
                            if (Not GenJnlBookBuffer.FINDSET) then begin
                                EntryNo += 1;
                                GenJnlBookBuffer.Init();
                                GenJnlBookBuffer."Entry No." := EntryNo;
                                GenJnlBookBuffer."G/L Account No." := GLAccount."No.";
                                GenJnlBookBuffer."G/L Account Name" := GLAccount.Name;
                                GenJnlBookBuffer.Insert();
                            end;
                        until GLAccount.Next() = 0;
                end;
            '503':
                begin
                    GLAccount.RESET;
                    GLAccount.SetFilter("No.", '<>%1', 'M*');
                    GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
                    TotalRecords := GLAccount.Count;
                    if GLAccount.FindSet() then
                        repeat
                            CountRecords += 1;
                            GLAccountBuffer.Init();
                            GLAccountBuffer.TransferFields(GLAccount, true);
                            GLAccountBuffer.Insert();
                            UpdateWindows(1, CountRecords, TotalRecords);
                        until GLAccount.Next() = 0;
                end;
        end;
        /*GenJnlBookBuffer.Reset();
        GenJnlBookBuffer.SetRange("Correlative cuo", '');
        repeat begin
            GenJnlBookBuffer.FindFirst();
            GenJnlBookBufferFilter.TransferFields(GenJnlBookBuffer);
            GenJnlBookBuffer.Reset();
            GenJnlBookBuffer.SetFilter("Posting Date Filter", '%1', GenJnlBookBufferFilter."Posting Date Filter");
            GenJnlBookBuffer.SetFilter("Transaction CUO", '%1', GenJnlBookBufferFilter."Transaction CUO");
            GenJnlBookBuffer.DeleteAll();
            GenJnlBookBuffer.Reset();
            GenJnlBookBuffer.SetRange("Correlative cuo", '');
        end until GenJnlBookBuffer.Count() = 0;*/
    end;

    local procedure SetInformationFromEntry(var GLEntry: Record "G/L Entry")
    var
        NoSerie: Record "No. Series";
        GLAccount: Record "G/L Account";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendLedgerEntry: Record "Vendor Ledger Entry";
        EmplLedgerEntry: Record "Employee Ledger Entry";
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        Cust: Record Customer;
        Vend: Record Vendor;
        Empl: Record Employee;
    begin
        case GLEntry."Source Type" of
            GLEntry."Source Type"::Vendor:
                begin
                    VendLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                    VendLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                    VendLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                    if VendLedgerEntry.Find('-') then begin
                        GetCurrencyCode(VendLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                        GenJnlBookBuffer."Legal Document No." := VendLedgerEntry."Legal Document";
                        GenJnlBookBuffer."Document No." := VendLedgerEntry."Document No.";
                        GenJnlBookBuffer."Due Date" := VendLedgerEntry."Due Date";
                        if VendLedgerEntry."External Document No." <> '' then
                            GenJnlBookBuffer."Document No." := VendLedgerEntry."External Document No."
                        else
                            GenJnlBookBuffer."Document No." := VendLedgerEntry."Document No.";
                    end;
                    Vend.Get(GLEntry."Source No.");
                    GenJnlBookBuffer."VAT Registration Type" := Vend."VAT Registration Type";
                    GenJnlBookBuffer."VAT Registration No." := Vend."VAT Registration No.";
                end;
            GLEntry."Source Type"::Customer:
                begin
                    CustLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                    CustLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                    if CustLedgerEntry.Find('-') then begin
                        GetCurrencyCode(CustLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                        GenJnlBookBuffer."Legal Document No." := CustLedgerEntry."Legal Document";
                        GenJnlBookBuffer."Document No." := CustLedgerEntry."Document No.";
                        GenJnlBookBuffer."Due Date" := CustLedgerEntry."Due Date";
                        GenJnlBookBuffer."Operation Date" := CustLedgerEntry."Document Date";
                    end;
                    Cust.Get(GLEntry."Source No.");
                    GenJnlBookBuffer."VAT Registration Type" := Cust."VAT Registration Type";
                    GenJnlBookBuffer."VAT Registration No." := Cust."VAT Registration No.";
                end;
            GLEntry."Source Type"::Employee:
                begin
                    EmplLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                    EmplLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                    EmplLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                    if EmplLedgerEntry.Find('-') then begin
                        GetCurrencyCode(EmplLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                        GenJnlBookBuffer."Document No." := EmplLedgerEntry."Document No.";
                    end;
                    GenJnlBookBuffer."Legal Document No." := '00';
                    Empl.Get(GLEntry."Source No.");
                    GenJnlBookBuffer."VAT Registration Type" := Empl."VAT Registration Type";
                    GenJnlBookBuffer."VAT Registration No." := Empl."VAT Registration No.";
                end;
            GLEntry."Source Type"::" ", GLEntry."Source Type"::"Bank Account", GLEntry."Source Type"::"Fixed Asset":
                begin
                    VendLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                    VendLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                    VendLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                    if VendLedgerEntry.Find('-') then begin
                        GetCurrencyCode(VendLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                        GenJnlBookBuffer."Legal Document No." := VendLedgerEntry."Legal Document";
                        Vend.Get(VendLedgerEntry."Vendor No.");
                        GenJnlBookBuffer."VAT Registration Type" := Vend."VAT Registration Type";
                        GenJnlBookBuffer."VAT Registration No." := Vend."VAT Registration No.";
                        GenJnlBookBuffer."Due Date" := VendLedgerEntry."Due Date";
                        GenJnlBookBuffer."Operation Date" := VendLedgerEntry."Document Date";
                        if VendLedgerEntry."External Document No." <> '' then
                            GenJnlBookBuffer."Document No." := VendLedgerEntry."External Document No."
                        else
                            GenJnlBookBuffer."Document No." := VendLedgerEntry."Document No.";
                    end else begin
                        CustLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                        CustLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                        if CustLedgerEntry.Find('-') then begin
                            GetCurrencyCode(CustLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                            GenJnlBookBuffer."Legal Document No." := CustLedgerEntry."Legal Document";
                            Cust.Get(CustLedgerEntry."Customer No.");
                            GenJnlBookBuffer."VAT Registration Type" := Cust."VAT Registration Type";
                            GenJnlBookBuffer."VAT Registration No." := Cust."VAT Registration No.";
                            GenJnlBookBuffer."Document No." := CustLedgerEntry."Document No.";
                            GenJnlBookBuffer."Due Date" := CustLedgerEntry."Due Date";
                            GenJnlBookBuffer."Operation Date" := CustLedgerEntry."Document Date";
                        end else begin
                            EmplLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                            EmplLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                            EmplLedgerEntry.SetFilter("Currency Code", '<>%1', '');
                            if EmplLedgerEntry.Find('-') then begin
                                GetCurrencyCode(EmplLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                                GenJnlBookBuffer."Legal Document No." := '00';
                                Empl.Get(EmplLedgerEntry."Employee No.");
                                GenJnlBookBuffer."VAT Registration Type" := Empl."VAT Registration Type";
                                GenJnlBookBuffer."VAT Registration No." := Empl."VAT Registration No.";
                                GenJnlBookBuffer."Document No." := EmplLedgerEntry."Document No.";
                            end else begin
                                BankAccLedgerEntry.SetRange("Document No.", GLEntry."Document No.");
                                BankAccLedgerEntry.SetRange("Posting Date", GLEntry."Posting Date");
                                if BankAccLedgerEntry.Find('-') then begin
                                    GetCurrencyCode(BankAccLedgerEntry."Currency Code", GenJnlBookBuffer."Currency Code");
                                    GenJnlBookBuffer."Legal Document No." := '00';
                                    GenJnlBookBuffer."Operation Date" := BankAccLedgerEntry."Document Date";
                                    if BankAccLedgerEntry."External Document No." <> '' then
                                        GenJnlBookBuffer."Document No." := BankAccLedgerEntry."External Document No."
                                    else
                                        GenJnlBookBuffer."Document No." := BankAccLedgerEntry."Document No.";
                                end else begin
                                    GenJnlBookBuffer."Legal Document No." := GLEntry."Legal Document";
                                    GenJnlBookBuffer."Operation Date" := GLEntry."Document Date";
                                    if GLEntry."External Document No." <> '' then
                                        GenJnlBookBuffer."Document No." := GLEntry."External Document No."
                                    else
                                        GenJnlBookBuffer."Document No." := GLEntry."Document No.";
                                end;
                            end;
                        end;
                    end;
                end;//End Case others
        end;//End Case Sentence
        if GenJnlBookBuffer."Legal Document No." = '' then
            GenJnlBookBuffer."Legal Document No." := '00';

        if GenJnlBookBuffer."Due Date" = 0D then
            GenJnlBookBuffer."Due Date" := GLEntry."Posting Date";
        if GenJnlBookBuffer."Operation Date" = 0D then
            GenJnlBookBuffer."Operation Date" := GLEntry."Document Date";
        if GenJnlBookBuffer."Operation Date" = 0D then
            GenJnlBookBuffer."Operation Date" := GLEntry."Posting Date";
        GenJnlBookBuffer."Account Date" := GLEntry."Posting Date";
        GenJnlBookBuffer."Gloss and description" := GLEntry.Description;
        if GLEntry."Debit Amount" < 0 then
            GenJnlBookBuffer."Credit Amount" := Abs(GLEntry."Debit Amount")
        else
            GenJnlBookBuffer."Debit Amount" := GLEntry."Debit Amount";
        if GLEntry."Credit Amount" < 0 then
            GenJnlBookBuffer."Debit Amount" := Abs(GLEntry."Credit Amount")
        else
            GenJnlBookBuffer."Credit Amount" := GLEntry."Credit Amount";
        GenJnlBookBuffer."Operation Status" := 1;
        if GLEntry."Legal Status" = GLEntry."Legal Status"::OutFlow then
            GenJnlBookBuffer."Legal Document No." := '00';
        LegalDocMgt.ValidateLegalDocumentFormat(GenJnlBookBuffer."Document No.", GenJnlBookBuffer."Legal Document No.", GenJnlBookBuffer."Serie Document", GenJnlBookBuffer."Number Document", false, false);
    end;

    procedure "CreateFileEBookFromGenJournalRecord"()
    var
        MyLineText: Text[1024];
        MySeparator: Text[10];
        TotalRecords: Integer;
        CountRecords: Integer;
        IsFileWithData: Boolean;
        CodLibro: Text[10];
    begin
        CreateTempFile();
        CountRecords := 0;
        MySeparator := '|';
        IsFileWithData := false;
        case BookCode of
            '501', '601':
                begin
                    with GenJnlBookBuffer do begin
                        Reset();
                        if BookCode = '501' then
                            SetCurrentKey("G/L Account No.", "Posting Date");
                        if BookCode = '601' then
                            SetCurrentKey("Posting Date", "Transaction No.");
                        TotalRecords := Count;
                        if FindFirst() then begin
                            IsFileWithData := true;
                            repeat
                                MyLineText := '';
                                CountRecords += 1;
                                MyLineText += Period + MySeparator;//Field 01
                                MyLineText += Format("Transaction CUO") + MySeparator;//Field 02
                                MyLineText += "Correlative cuo" + MySeparator;//Field 03
                                MyLineText += "G/L Account No." + MySeparator;//Field 04
                                MyLineText += "Unit Operation Code" + MySeparator;//Field 05
                                MyLineText += "Center Cost Code" + MySeparator;//Field 06
                                MyLineText += FormatCurrency("Currency Code") + MySeparator;//Field 07
                                MyLineText += MySeparator;//Field 08
                                MyLineText += MySeparator;//Field 09
                                MyLineText += "Legal Document No." + MySeparator;//Field 10
                                MyLineText += "Serie Document" + MySeparator;//Field 11
                                MyLineText += "Number Document" + MySeparator;//Field 12
                                MyLineText += Format("Account Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 13
                                MyLineText += Format("Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 14
                                MyLineText += Format("Operation Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 15
                                MyLineText += "Gloss and description" + MySeparator;//Field 16
                                MyLineText += "Gloss an description ref." + MySeparator;//Field 17
                                MyLineText += Format("Debit Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 18
                                MyLineText += Format("Credit Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 19
                                if GenJnlBookBuffer."Source Code" = 'VENTAS' then begin
                                    CodLibro := '140100';
                                    MyLineText += StrSubstNo('%1&%2&%3&%4', CodLibro, Period, "Transaction CUO", "Correlative cuo");
                                end else begin
                                    if GenJnlBookBuffer."Source Code" = 'COMPRAS' then begin
                                        if (GenJnlBookBuffer."Legal Document" = '91') or (GenJnlBookBuffer."Legal Document" = '97') or (GenJnlBookBuffer."Legal Document" = '98') then begin
                                            CodLibro := '080200';
                                        end else begin
                                            CodLibro := '080100';
                                        end;
                                        MyLineText += StrSubstNo('%1&%2&%3&%4', CodLibro, Period, "Transaction CUO", "Correlative cuo");
                                    end
                                end;
                                MyLineText += MySeparator;//Field 20
                                MyLineText += Format("Operation Status") + MySeparator;//Field 21
                                MyLineText += "Free Field";//Field 22
                                InsertLineToTempFile(MyLineText);
                                UpdateWindows(2, CountRecords, TotalRecords);
                            until Next() = 0;
                        end;

                    end;
                end;
            '503':
                begin
                    with GLAccountBuffer do begin
                        Reset();
                        if FindFirst() then begin
                            IsFileWithData := true;
                            repeat
                                MyLineText := '';
                                CountRecords += 1;
                                MyLineText += Format(EndDate, 0, '<Year4><Month,2><Day,2>') + MySeparator;//Field 01
                                MyLineText += GLAccountBuffer."No." + MySeparator;//Field 02
                                MyLineText += GLAccountBuffer.Name + MySeparator;//Field 03
                                MyLineText += '01' + MySeparator;//Field 04
                                MyLineText += 'PLAN CONTABLE GENERAL EMPRESARIAL' + MySeparator;//Field 05
                                MyLineText += '' + MySeparator;//Field 06
                                MyLineText += '' + MySeparator;//Field 07
                                MyLineText += '1' + MySeparator;//Field 08
                                InsertLineToTempFile(MyLineText);
                            until Next() = 0;
                        end;

                    end;
                end;
        end;
        PostFileToControlFileRecord(IsFileWithData);
    end;

    procedure GetGenJnlBookBuffer(var pGenJnlBookBuffer: Record "Gen. Journal Book Buffer" temporary)
    begin
        GenJnlBookBuffer.Reset();
        if GenJnlBookBuffer.FindFirst() then
            repeat
                pGenJnlBookBuffer.Init();
                pGenJnlBookBuffer.TransferFields(GenJnlBookBuffer, true);
                pGenJnlBookBuffer.Insert();
            until GenJnlBookBuffer.Next() = 0;
    end;

    //Purchase Record Function

    procedure PurchaserRecord(pBookCode: Code[10]; IsEBook: Boolean)
    var
        VATEntry: Record "VAT Entry";
        EntryNo: Integer;
        TotalRecords: Integer;
        CountRecords: Integer;
    begin
        EntryNo := 0;
        SLSetup.Get();
        CountRecords := 0;
        BookCode := pBookCode;
        if not NotRequestDate then
            if not SetDate() then
                exit;
        if not CheckDateExists() then
            exit;
        OpenWindows(IsEBook);
        VATEntry.Reset();
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
        VATEntry.SetFilter("Legal Status", '%1|%2', VATEntry."Legal Status"::Success, VATEntry."Legal Status"::Anulled);
        VATEntry.SetRange(Type, VATEntry.Type::Purchase);
        case BookCode of
            '801':
                VATEntry.SetFilter("Legal Document", '<>%1&<>%2&<>%3&<>%4&<>%5', '91', '97', '98', '00', '02');
            '802':
                VATEntry.SetFilter("Legal Document", '%1|%2|%3|%4', '91', '97', '98');
        end;
        TotalRecords := VATEntry.Count;
        if VATEntry.FindFirst() then
            repeat
                if isPurchInvoice(VATEntry) then begin
                    CountRecords += 1;
                    PurchRecordBuffer.Reset();
                    PurchRecordBuffer.SetRange("Document No.", VATEntry."Document No.");
                    PurchRecordBuffer.SetRange("Legal Document", VATEntry."Legal Document");
                    IF PurchRecordBuffer.FindSet() then begin
                        if VATEntry."Legal Status" = VATEntry."Legal Status"::Success then
                            AddPurchTaxedValues(VATEntry);
                        PurchRecordBuffer.Modify();
                    end else begin
                        EntryNo += 1;
                        PurchRecordBuffer.Init();
                        PurchRecordBuffer."Document No." := VATEntry."Document No.";
                        PurchRecordBuffer."Entry No." := EntryNo;
                        PurchRecordBuffer.Period := Format(VATEntry."Posting Date", 0, '<Year4><Month,2>') + '00'; //FMM::Cambio Fecha Documento a Fecha Registro
                        SetInformationCUO(VATEntry."Entry No.");
                        PurchRecordBuffer."Document Date" := VATEntry."Document Date";
                        PurchRecordBuffer."Legal Document" := VATEntry."Legal Document";
                        SetInformationFromPurchDocument(VATEntry);
                        if VATEntry."Legal Status" = VATEntry."Legal Status"::Success then
                            AddPurchTaxedValues(VATEntry);
                        PurchRecordBuffer.Cancelled := VATEntry."Legal Status" = VATEntry."Legal Status"::Anulled;
                        PurchRecordBuffer.Insert();
                    end;
                end;
                UpdateWindows(1, CountRecords, TotalRecords);
            until VATEntry.Next() = 0;

        if IsEBook then
            CreateFileEBookFromPurchaseRecord();
        CloseWindows();
    end;

    local procedure isSalesInvoice(pVATEntry: Record "VAT Entry"): Boolean
    var
        lcCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        lcCustLedgerEntry.Reset();
        lcCustLedgerEntry.SetRange("Document No.", pVATEntry."Document No.");
        lcCustLedgerEntry.SetRange("Posting Date", pVATEntry."Posting Date");
        lcCustLedgerEntry.SetRange("Document Type", lcCustLedgerEntry."Document Type"::Invoice);
        if lcCustLedgerEntry.FindFirst() then
            exit(true);
        exit(false);
    end;

    local procedure isPurchInvoice(pVATEntry: Record "VAT Entry"): Boolean
    var
        lcVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        lcVendorLedgerEntry.Reset();
        lcVendorLedgerEntry.SetRange("Document No.", pVATEntry."Document No.");
        lcVendorLedgerEntry.SetRange("Posting Date", pVATEntry."Posting Date");
        lcVendorLedgerEntry.SetRange("Document Type", lcVendorLedgerEntry."Document Type"::Invoice);
        if lcVendorLedgerEntry.FindFirst() then
            exit(true);
        exit(false);
    end;

    local procedure fnGetSalesPaymentIndicador(pVATEntry: Record "VAT Entry"): Integer
    var
        lcCustLedgerEntry: Record "Cust. Ledger Entry";
        lcDetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        lcCustLedgerEntry.Reset();
        lcCustLedgerEntry.SetRange("Document No.", pVATEntry."Document No.");
        lcCustLedgerEntry.SetRange("Posting Date", pVATEntry."Posting Date");
        lcCustLedgerEntry.SetRange("Document Type", lcCustLedgerEntry."Document Type"::Invoice);
        if lcCustLedgerEntry.FindFirst() then begin
            lcDetailedCustLedgEntry.SetRange("Cust. Ledger Entry No.", lcCustLedgerEntry."Entry No.");
            lcDetailedCustLedgEntry.SetRange("Posting Date", StartDate, EndDate);
            lcDetailedCustLedgEntry.SetRange("Entry Type", lcDetailedCustLedgEntry."Entry Type"::Application);
            if lcDetailedCustLedgEntry.FindFirst() then
                exit(1);
        end;

    end;

    local procedure fnGetPurchPaymentIndicador(pVATEntry: Record "VAT Entry"): Integer
    var
        lcVendLedgerEntry: Record "Vendor Ledger Entry";
        lcVendLedgerEntry1: Record "Vendor Ledger Entry";
        lcDetailedVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        lcVendLedgerEntry.Reset();
        lcVendLedgerEntry.SetRange("Document No.", pVATEntry."Document No.");
        lcVendLedgerEntry.SetRange("Posting Date", pVATEntry."Posting Date");
        lcVendLedgerEntry.SetRange("Document Type", lcVendLedgerEntry."Document Type"::Invoice);
        lcVendLedgerEntry.SetFilter("Closed by Entry No.", '<>%1', 0);
        if lcVendLedgerEntry.FindFirst() then begin
            lcVendLedgerEntry1.SetRange("Entry No.", lcVendLedgerEntry."Closed by Entry No.");
            lcVendLedgerEntry1.SetRange("Posting Date", StartDate, EndDate);
            lcVendLedgerEntry1.SetFilter("Payment Method Code", '<>%1', '');
            if lcVendLedgerEntry1.FindFirst() then
                exit(1);
        end;

    end;

    procedure SalesRecord(pBookCode: Code[10]; IsEBook: Boolean)
    var
        VATEntry: Record "VAT Entry";
        lclRecNoSeries: Record "No. Series";
        EntryNo: Integer;
        TotalRecords: Integer;
        CountRecords: Integer;
    begin
        EntryNo := 0;
        SLSetup.Get();
        CountRecords := 0;
        BookCode := pBookCode;
        if not NotRequestDate then
            if not SetDate() then
                exit;
        if not CheckDateExists() then
            exit;
        OpenWindows(IsEBook);
        VATEntry.Reset();
        VATEntry.SetRange("Posting Date", StartDate, EndDate);
        VATEntry.SetFilter("Legal Status", '%1|%2', VATEntry."Legal Status"::Success, VATEntry."Legal Status"::Anulled);
        VATEntry.SetRange(Type, VATEntry.Type::Sale);
        case BookCode of
            '1401':
                VATEntry.SETFILTER("Legal Document", '<>%1&<>%2&<>%3&<>%4&<>%5', '91', '97', '98', '02', '00');
        end;
        TotalRecords := VATEntry.Count;
        if VATEntry.FindFirst() then
            repeat
                if isSalesInvoice(VATEntry) then //PC 26.Oct.21 KT Sltdo
                    IF (lclRecNoSeries.GET(VATEntry."No. Series")) AND (NOT lclRecNoSeries."Internal Operation") THEN begin


                        CountRecords += 1;
                        SalesRecordBuffer.Reset();
                        SalesRecordBuffer.SetRange("Document No.", VATEntry."Document No.");
                        SalesRecordBuffer.SetRange("Legal Document", VATEntry."Legal Document");
                        IF SalesRecordBuffer.FindSet() then begin
                            if VATEntry."Legal Status" = VATEntry."Legal Status"::Success then
                                AddSalesTaxedValues(VATEntry);
                            SalesRecordBuffer.Modify();
                        end else begin
                            EntryNo += 1;
                            SalesRecordBuffer.Init();
                            SalesRecordBuffer."Document No." := VATEntry."Document No.";
                            SalesRecordBuffer."Entry No." := EntryNo;
                            SalesRecordBuffer.Period := Format(VATEntry."Document Date", 0, '<Year4><Month,2>') + '00';
                            SetSalesInformationCUO(VATEntry."Entry No.");
                            SalesRecordBuffer."Document Date" := VATEntry."Document Date";
                            SalesRecordBuffer."Legal Document" := VATEntry."Legal Document";
                            SetInformationFromSalesDocument(VATEntry);
                            if VATEntry."Legal Status" = VATEntry."Legal Status"::Success then
                                AddSalesTaxedValues(VATEntry);
                            //SalesRecordBuffer.Cancelled := VATEntry."Legal Status" = VATEntry."Legal Status"::Anulled;
                            SalesRecordBuffer.Insert();
                        end;
                        UpdateWindows(1, CountRecords, TotalRecords);

                    end;
            until VATEntry.Next() = 0;

        if IsEBook then
            CreateFileEBookFromSalesRecord();
        CloseWindows();
    end;

    local procedure SetInformationCUO(VATEntryNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        GLEntryLinkVATEntry: Record "G/L Entry - VAT Entry Link";
        GLEntry: Record "G/L Entry";
    begin
        GLEntryLinkVATEntry.SetRange("VAT Entry No.", VATEntryNo);
        if GLEntryLinkVATEntry.FindFirst() then begin
            if GLEntry.Get(GLEntryLinkVATEntry."G/L Entry No.") then begin
                PurchRecordBuffer."Transaction CUO" := GLEntry."Transaction CUO";
                PurchRecordBuffer."Correlative cuo" := GLEntry."Correlative CUO";
            end;
        end;
    end;

    local procedure SetSalesInformationCUO(VATEntryNo: Integer)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        GLEntryLinkVATEntry: Record "G/L Entry - VAT Entry Link";
        GLEntry: Record "G/L Entry";
    begin
        GLEntryLinkVATEntry.SetRange("VAT Entry No.", VATEntryNo);
        if GLEntryLinkVATEntry.FindFirst() then begin
            if GLEntry.Get(GLEntryLinkVATEntry."G/L Entry No.") then begin
                SalesRecordBuffer."Transaction CUO" := GLEntry."Transaction CUO";
                SalesRecordBuffer."Correlative cuo" := GLEntry."Correlative CUO";
            end;
        end;
    end;

    local procedure SetInformationFromPurchDocument(var VATEntry: record "VAT Entry")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchInvHeader2: Record "Purch. Inv. Header";
        PurchCrMemoHdr2: Record "Purch. Cr. Memo Hdr.";
        LegalDocMgt: Codeunit "Legal Document Management";
    begin
        if VATEntry."Legal Document" = '07' then begin
            if PurchCrMemoHdr.Get(VATEntry."Document No.") then begin
                PurchRecordBuffer."Payment Due Date" := PurchCrMemoHdr."Due Date";
                LegalDocMgt.ValidateLegalDocumentFormat(PurchCrMemoHdr."Vendor Cr. Memo No.",
                                                            VATEntry."Legal Document",
                                                            PurchRecordBuffer."Serie Document",
                                                            PurchRecordBuffer."Number Document",
                                                            false,
                                                            false);
                if VATEntry."Legal Document" = '50' then
                    Evaluate(PurchRecordBuffer."DUA Document Year", Format(VATEntry."Document Date", 0, '<Year4>'));
                PurchRecordBuffer."Field 10 Total Amount" := 0;
                SetVendorFromPurchCrMemo(PurchCrMemoHdr);
                GetCurrencyCode(PurchCrMemoHdr."Currency Code", PurchRecordBuffer."Currency Code");
                if PurchCrMemoHdr."Currency Code" = '' then
                    PurchRecordBuffer."Currency Amount" := 1
                else
                    PurchRecordBuffer."Currency Amount" := 1 / PurchCrMemoHdr."Currency Factor";
                if PurchCrMemoHdr."Legal Document" in ['07', '08'] then begin
                    if PurchCrMemoHdr."Manual Document Ref." then begin
                        PurchRecordBuffer."Mod. Document Date" := PurchCrMemoHdr."Applies-to Document Date Ref.";
                        PurchRecordBuffer."Mod. Legal Document" := PurchCrMemoHdr."Legal Document Ref.";
                        PurchRecordBuffer."Mod. Serie" := PurchCrMemoHdr."Applies-to Serie Ref.";
                        PurchRecordBuffer."Mod. Document" := PurchCrMemoHdr."Applies-to Number Ref.";
                        LegalDocMgt.ValidateLegalDocumentFormat(PurchRecordBuffer."Mod. Serie" + '-' + PurchRecordBuffer."Mod. Document",
                                                                PurchRecordBuffer."Mod. Legal Document",
                                                                PurchRecordBuffer."Mod. Serie",
                                                                PurchRecordBuffer."Mod. Document",
                                                                false,
                                                                false);
                    end else
                        if PurchCrMemoHdr."Applies-to Doc. No. Ref." <> '' then
                            SetPurchRecordBufferFromPurchCrMemoHdrModicated(PurchCrMemoHdr)
                        else
                            if PurchCrMemoHdr."Applies-to Doc. No." <> '' then begin
                                if PurchCrMemoHdr2.Get(PurchCrMemoHdr."Applies-to Doc. No.") then
                                    SetPurchRecordBufferFromPurchCrMemoHdrModicated(PurchCrMemoHdr2)
                                else begin
                                    PurchCrMemoHdr2.Reset();
                                    PurchCrMemoHdr2.SetRange("Buy-from Vendor No.", PurchCrMemoHdr."Buy-from Vendor No.");
                                    PurchCrMemoHdr2.SetRange("Vendor Cr. Memo No.", PurchCrMemoHdr."Applies-to Doc. No.");
                                    if PurchCrMemoHdr2.Find('-') then
                                        SetPurchRecordBufferFromPurchCrMemoHdrModicated(PurchCrMemoHdr2);
                                end;
                            end;
                end;
                PurchRecordBuffer."Clas. Property and Services" := PurchCrMemoHdr."Legal Property Type";
                if VATEntry."Legal Document" in ['03', '16', '21'] then
                    PurchRecordBuffer.Status := 0
                else begin
                    case true of
                        (Date2DMY(VATEntry."Document Date", 2) = Date2DMY(VATEntry."Posting Date", 2)) and
                        (Date2DMY(VATEntry."Document Date", 3) = Date2DMY(VATEntry."Posting Date", 3)):
                            PurchRecordBuffer.Status := 1;
                        (Date2DMY(VATEntry."Document Date", 2) < Date2DMY(VATEntry."Posting Date", 2)) or
                        (Date2DMY(VATEntry."Document Date", 3) < Date2DMY(VATEntry."Posting Date", 3)):
                            PurchRecordBuffer.Status := 6;
                        (VATEntry."Posting Date" - VATEntry."Document Date") > 365:
                            PurchRecordBuffer.Status := 7;
                        (VATEntry."Document Date" > Today()) or (VATEntry."Document Date" > EndDate):
                            PurchRecordBuffer."Field Free" := 'Error fecha emisión'
                    end;
                end;
            end;
        end else begin
            if PurchInvHeader.Get(VATEntry."Document No.") then begin
                PurchRecordBuffer."Payment Due Date" := PurchInvHeader."Due Date";
                LegalDocMgt.ValidateLegalDocumentFormat(VATEntry."External Document No.",//ojito
                                                            VATEntry."Legal Document",
                                                            PurchRecordBuffer."Serie Document",
                                                            PurchRecordBuffer."Number Document",
                                                            false,
                                                            false);
                if VATEntry."Legal Document" = '50' then
                    Evaluate(PurchRecordBuffer."DUA Document Year", Format(VATEntry."Document Date", 0, '<Year4>'));
                PurchRecordBuffer."Field 10 Total Amount" := 0;
                SetVendorFromPurchInvoice(PurchInvHeader);
                GetCurrencyCode(PurchInvHeader."Currency Code", PurchRecordBuffer."Currency Code");
                if PurchInvHeader."Currency Code" = '' then
                    PurchRecordBuffer."Currency Amount" := 1
                else
                    PurchRecordBuffer."Currency Amount" := 1 / PurchInvHeader."Currency Factor";
                if PurchInvHeader."Legal Document" in ['07', '08'] then begin
                    if PurchInvHeader."Applies-to Doc. No." <> '' then begin
                        if PurchInvHeader2.Get(PurchInvHeader."Applies-to Doc. No.") then
                            SetPurchRecordBufferFromPurchInvHdrModicated(PurchInvHeader2)
                        else begin
                            PurchInvHeader2.Reset();
                            PurchInvHeader2.SetRange("Buy-from Vendor No.", PurchInvHeader."Buy-from Vendor No.");
                            PurchInvHeader2.SetRange("Vendor Invoice No.", PurchInvHeader."Applies-to Doc. No.");
                            if PurchInvHeader2.Find('-') then
                                SetPurchRecordBufferFromPurchInvHdrModicated(PurchInvHeader2);
                        end;
                    end else
                        if PurchInvHeader."Applies-to Doc. No. Ref." <> '' then
                            SetPurchRecordBufferFromPurchInvHdrModicated(PurchInvHeader);

                end;
                PurchRecordBuffer."Clas. Property and Services" := PurchInvHeader."Legal Property Type";
                if VATEntry."Legal Document" in ['03', '16', '21'] then
                    PurchRecordBuffer.Status := 0
                else begin
                    case true of
                        (Date2DMY(VATEntry."Document Date", 2) = Date2DMY(VATEntry."Posting Date", 2)) and
                        (Date2DMY(VATEntry."Document Date", 3) = Date2DMY(VATEntry."Posting Date", 3)):
                            PurchRecordBuffer.Status := 1;
                        (Date2DMY(VATEntry."Document Date", 2) < Date2DMY(VATEntry."Posting Date", 2)) or
                        (Date2DMY(VATEntry."Document Date", 3) < Date2DMY(VATEntry."Posting Date", 3)):
                            PurchRecordBuffer.Status := 6;
                        (VATEntry."Posting Date" - VATEntry."Document Date") > 365:
                            PurchRecordBuffer.Status := 7;
                        (VATEntry."Document Date" > Today()) or (VATEntry."Document Date" > EndDate):
                            PurchRecordBuffer."Field Free" := 'Error fecha emisión'
                    end;
                end;
            end;
        end;

        OnAfterSetInformationFromPurchDocument(PurchRecordBuffer, VATEntry);
    end;

    local procedure SetInformationFromSalesDocument(var VATEntry: record "VAT Entry")
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesInvHeader2: Record "Sales Invoice Header";
        SalesCrMemoHdr2: Record "Sales Cr.Memo Header";
        LegalDocMgt: Codeunit "Legal Document Management";
    begin
        if VATEntry."Legal Document" = '07' then begin
            if SalesCrMemoHdr.Get(VATEntry."Document No.") then begin
                SalesRecordBuffer."Payment Due Date" := SalesCrMemoHdr."Due Date";
                LegalDocMgt.ValidateLegalDocumentFormat(SalesCrMemoHdr."No.",
                                                            VATEntry."Legal Document",
                                                            SalesRecordBuffer."Serie Document",
                                                            SalesRecordBuffer."Number Document",
                                                            false,
                                                            false);
                //if VATEntry."Legal Document" = '50' then
                //  Evaluate(SalesRecordBuffer."DUA Document Year", Format(VATEntry."Document Date", 0, '<Year4>'));
                SalesRecordBuffer."Field 9 Total Amount" := 0;
                SetCustomerFromSalesCrMemo(SalesCrMemoHdr);
                GetCurrencyCode(SalesCrMemoHdr."Currency Code", SalesRecordBuffer."Currency Code");
                if SalesCrMemoHdr."Currency Code" = '' then
                    SalesRecordBuffer."Currency Amount" := 1
                else
                    SalesRecordBuffer."Currency Amount" := 1 / SalesCrMemoHdr."Currency Factor";
                if SalesCrMemoHdr."Legal Document" in ['07', '08'] then begin
                    if SalesCrMemoHdr."Manual Document Ref." then begin
                        SalesRecordBuffer."Mod. Document Date" := SalesCrMemoHdr."Applies-to Document Date Ref.";
                        SalesRecordBuffer."Mod. Legal Document" := SalesCrMemoHdr."Legal Document Ref.";
                        SalesRecordBuffer."Mod. Serie" := SalesCrMemoHdr."Applies-to Serie Ref.";
                        SalesRecordBuffer."Mod. Document" := SalesCrMemoHdr."Applies-to Number Ref.";
                        LegalDocMgt.ValidateLegalDocumentFormat(SalesRecordBuffer."Mod. Serie" + '-' + SalesRecordBuffer."Mod. Document",
                                                                SalesRecordBuffer."Mod. Legal Document",
                                                                SalesRecordBuffer."Mod. Serie",
                                                                SalesRecordBuffer."Mod. Document",
                                                                false,
                                                                false);
                    end else
                        if SalesCrMemoHdr."Applies-to Doc. No. Ref." <> '' then
                            SetSalesRecordBufferFromSalesCrMemoHdrModicated(SalesCrMemoHdr)
                        else
                            if SalesCrMemoHdr."Applies-to Doc. No." <> '' then begin
                                if SalesCrMemoHdr2.Get(SalesCrMemoHdr."Applies-to Doc. No.") then
                                    SetSalesRecordBufferFromSalesCrMemoHdrModicated(SalesCrMemoHdr2)
                                else begin
                                    SalesCrMemoHdr2.Reset();
                                    SalesCrMemoHdr2.SetRange("Sell-to Customer No.", SalesCrMemoHdr."Sell-to Customer No.");
                                    SalesCrMemoHdr2.SetRange("No.", SalesCrMemoHdr."Applies-to Doc. No.");
                                    if SalesCrMemoHdr2.Find('-') then
                                        SetSalesRecordBufferFromSalesCrMemoHdrModicated(SalesCrMemoHdr2);
                                end;
                            end;
                end;
                // SalesRecordBuffer."Clas. Property and Services" := SalesCrMemoHdr."Legal Property Type";
                if VATEntry."Legal Document" in ['03', '16', '21'] then
                    SalesRecordBuffer.Status := 0
                else begin
                    case true of
                        (Date2DMY(VATEntry."Document Date", 2) = Date2DMY(VATEntry."Posting Date", 2)) and
                        (Date2DMY(VATEntry."Document Date", 3) = Date2DMY(VATEntry."Posting Date", 3)):
                            SalesRecordBuffer.Status := 1;
                        (Date2DMY(VATEntry."Document Date", 2) < Date2DMY(VATEntry."Posting Date", 2)) or
                        (Date2DMY(VATEntry."Document Date", 3) < Date2DMY(VATEntry."Posting Date", 3)):
                            SalesRecordBuffer.Status := 6;
                        (VATEntry."Posting Date" - VATEntry."Document Date") > 365:
                            SalesRecordBuffer.Status := 7;
                        (VATEntry."Document Date" > Today()) or (VATEntry."Document Date" > EndDate):
                            SalesRecordBuffer."Field Free" := 'Error fecha emisión'
                    end;
                end;
            end;
        end else begin
            if SalesInvHeader.Get(VATEntry."Document No.") then begin
                SalesRecordBuffer."Payment Due Date" := SalesInvHeader."Due Date";
                LegalDocMgt.ValidateLegalDocumentFormat(VATEntry."Document No.",//ojito
                                                            VATEntry."Legal Document",
                                                            SalesRecordBuffer."Serie Document",
                                                            SalesRecordBuffer."Number Document",
                                                            false,
                                                            false);
                //if VATEntry."Legal Document" = '50' then
                //  Evaluate(SalesRecordBuffer."DUA Document Year", Format(VATEntry."Document Date", 0, '<Year4>'));
                SalesRecordBuffer."Field 9 Total Amount" := 0;
                SetCustomerFromSalesInvoice(SalesInvHeader);
                GetCurrencyCode(SalesInvHeader."Currency Code", SalesRecordBuffer."Currency Code");
                if SalesInvHeader."Currency Code" = '' then
                    SalesRecordBuffer."Currency Amount" := 1
                else
                    SalesRecordBuffer."Currency Amount" := 1 / SalesInvHeader."Currency Factor";
                if SalesInvHeader."Legal Document" in ['07', '08'] then begin
                    if SalesInvHeader."Applies-to Doc. No." <> '' then begin
                        if SalesInvHeader2.Get(SalesInvHeader."Applies-to Doc. No.") then
                            SetSalesRecordBufferFromSalesInvHdrModicated(SalesInvHeader2)
                        else begin
                            SalesInvHeader2.Reset();
                            SalesInvHeader2.SetRange("Sell-to Customer No.", SalesInvHeader."Sell-to Customer No.");
                            SalesInvHeader2.SetRange("No.", SalesInvHeader."Applies-to Doc. No.");
                            if SalesInvHeader2.Find('-') then
                                SetSalesRecordBufferFromSalesInvHdrModicated(SalesInvHeader2);
                        end;
                    end else
                        if SalesInvHeader."Applies-to Doc. No. Ref." <> '' then
                            SetSalesRecordBufferFromSalesInvHdrModicated(SalesInvHeader);

                end;
                //SalesRecordBuffer."Clas. Property and Services" := SalesInvHeader."Legal Property Type";
                if VATEntry."Legal Document" in ['03', '16', '21'] then
                    SalesRecordBuffer.Status := 0
                else begin
                    case true of
                        (Date2DMY(VATEntry."Document Date", 2) = Date2DMY(VATEntry."Posting Date", 2)) and
                        (Date2DMY(VATEntry."Document Date", 3) = Date2DMY(VATEntry."Posting Date", 3)):
                            SalesRecordBuffer.Status := 1;
                        (Date2DMY(VATEntry."Document Date", 2) < Date2DMY(VATEntry."Posting Date", 2)) or
                        (Date2DMY(VATEntry."Document Date", 3) < Date2DMY(VATEntry."Posting Date", 3)):
                            SalesRecordBuffer.Status := 6;
                        (VATEntry."Posting Date" - VATEntry."Document Date") > 365:
                            SalesRecordBuffer.Status := 7;
                        (VATEntry."Document Date" > Today()) or (VATEntry."Document Date" > EndDate):
                            SalesRecordBuffer."Field Free" := 'Error fecha emisión'
                    end;
                end;
            end;
        end;
        //Agregado para anulado
        case VATEntry."Legal Status" OF
            VATEntry."Legal Status"::Anulled:
                SalesRecordBuffer.Status := 2;
        end;
        OnAfterSetInformationFromSalesDocument(SalesRecordBuffer, VATEntry);
    end;


    local procedure SetVendorFromPurchInvoice(var pPurchInvHdr: Record "Purch. Inv. Header")
    var
        Vendor: Record Vendor;
    begin
        case SLSetup."AB Field reference purch. book" of
            SLSetup."AB Field reference purch. book"::"Buy-Vendor":
                begin
                    Vendor.Get(pPurchInvHdr."Buy-from Vendor No.");
                    PurchRecordBuffer."VAT Registration Type" := Vendor."VAT Registration Type";
                    PurchRecordBuffer."VAT Registration No." := Vendor."VAT Registration No.";
                    PurchRecordBuffer."Vendor Name" := pPurchInvHdr."Buy-from Vendor Name";
                    PurchRecordBuffer."Country Residence Not Address" := fnGetCodeCountry(Vendor."Country/Region Code");
                    PurchRecordBuffer."Foreing Residence Not Address" := Vendor.Address;
                    PurchRecordBuffer."Link between taxpayer" := Vendor."Economic Linkages Type";
                end;
            SLSetup."AB Field reference purch. book"::"Pay-Vendor":
                begin
                    Vendor.Get(pPurchInvHdr."Pay-to Vendor No.");
                    PurchRecordBuffer."VAT Registration Type" := Vendor."VAT Registration Type";
                    PurchRecordBuffer."VAT Registration No." := Vendor."VAT Registration No.";
                    PurchRecordBuffer."Vendor Name" := pPurchInvHdr."Pay-to Name";
                    PurchRecordBuffer."Country Residence Not Address" := fnGetCodeCountry(Vendor."Country/Region Code");
                    PurchRecordBuffer."Foreing Residence Not Address" := Vendor.Address;
                    PurchRecordBuffer."Link between taxpayer" := Vendor."Economic Linkages Type";

                end;
        end;
    end;

    local procedure SetVendorFromPurchCrMemo(var pPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    var
        Vendor: Record Vendor;
    begin
        case SLSetup."AB Field reference purch. book" of
            SLSetup."AB Field reference purch. book"::"Buy-Vendor":
                begin
                    Vendor.Get(pPurchCrMemoHdr."Buy-from Vendor No.");
                    PurchRecordBuffer."VAT Registration Type" := Vendor."VAT Registration Type";
                    PurchRecordBuffer."VAT Registration No." := Vendor."VAT Registration No.";
                    PurchRecordBuffer."Country Residence Not Address" := fnGetCodeCountry(Vendor."Country/Region Code");
                    PurchRecordBuffer."Vendor Name" := pPurchCrMemoHdr."Buy-from Vendor Name";
                    PurchRecordBuffer."Link between taxpayer" := Vendor."Economic Linkages Type";

                end;
            SLSetup."AB Field reference purch. book"::"Pay-Vendor":
                begin
                    Vendor.Get(pPurchCrMemoHdr."Pay-to Vendor No.");
                    PurchRecordBuffer."VAT Registration Type" := Vendor."VAT Registration Type";
                    PurchRecordBuffer."VAT Registration No." := Vendor."VAT Registration No.";
                    PurchRecordBuffer."Country Residence Not Address" := fnGetCodeCountry(Vendor."Country/Region Code");
                    PurchRecordBuffer."Vendor Name" := pPurchCrMemoHdr."Pay-to Name";
                    PurchRecordBuffer."Link between taxpayer" := Vendor."Economic Linkages Type";

                end;
        end;
    end;

    local procedure SetCustomerFromSalesInvoice(var pSalesInvHdr: Record "Sales Invoice Header")
    var
        Customer: Record Customer;
        lblAnulled: Label 'Anulled', Comment = 'ESM="Anulado"';
    begin
        case SLSetup."AB Field reference sales. book" of
            SLSetup."AB Field reference sales. book"::"Sell-Customer":
                begin
                    Customer.Get(pSalesInvHdr."Sell-to Customer No.");
                    SalesRecordBuffer."VAT Registration Type" := Customer."VAT Registration Type";
                    SalesRecordBuffer."VAT Registration No." := Customer."VAT Registration No.";
                    SalesRecordBuffer."Customer Name" := pSalesInvHdr."Sell-to Customer Name";
                end;
            SLSetup."AB Field reference sales. book"::"Bill-Customer":
                begin
                    Customer.Get(pSalesInvHdr."Bill-to Customer No.");
                    SalesRecordBuffer."VAT Registration Type" := Customer."VAT Registration Type";
                    SalesRecordBuffer."VAT Registration No." := Customer."VAT Registration No.";
                    SalesRecordBuffer."Customer Name" := pSalesInvHdr."Bill-to Customer No.";
                end;
        end;
        CASE pSalesInvHdr."Legal Status" OF
            pSalesInvHdr."Legal Status"::Anulled:
                begin
                    SalesRecordBuffer."Customer Name" := lblAnulled;
                end;
        END
    end;

    local procedure SetCustomerFromSalesCrMemo(var pSalesCrMemoHdr: Record "Sales Cr.Memo Header")
    var
        Customer: Record Customer;
    begin
        case SLSetup."AB Field reference sales. book" of
            SLSetup."AB Field reference sales. book"::"Sell-Customer":
                begin
                    Customer.Get(pSalesCrMemoHdr."Sell-to Customer No.");
                    SalesRecordBuffer."VAT Registration Type" := Customer."VAT Registration Type";
                    SalesRecordBuffer."VAT Registration No." := Customer."VAT Registration No.";
                    SalesRecordBuffer."Customer Name" := pSalesCrMemoHdr."Sell-to Customer Name";
                end;
            SLSetup."AB Field reference sales. book"::"Bill-Customer":
                begin
                    Customer.Get(pSalesCrMemoHdr."Bill-to Customer No.");
                    SalesRecordBuffer."VAT Registration Type" := Customer."VAT Registration Type";
                    SalesRecordBuffer."VAT Registration No." := Customer."VAT Registration No.";
                    SalesRecordBuffer."Customer Name" := pSalesCrMemoHdr."Bill-to Customer No.";
                end;
        end;
    end;

    local procedure AddPurchTaxedValues(var VATEntry: Record "VAT Entry")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");

        with PurchRecordBuffer do begin
            case VATPostingSetup."Purchase Record Type" of
                VATPostingSetup."Purchase Record Type"::"TAXED AND / OR EXPORTED":
                    begin
                        "Taxed Base" += VATEntry.Base;
                        "Taxed VAT" += VATEntry.Amount;
                        if VATEntry."Legal Document" in ['46', '50'] then begin
                            "Taxed Base" := 0;
                            "NOT Taxed VAT" += VATEntry.Base + VATEntry.Amount;
                        end;
                    end;
                VATPostingSetup."Purchase Record Type"::"TAXED AND / OR EXPORTED AND TO OPERATIONS NOT TAXED":
                    begin
                        "Untaxed Base" += VATEntry.Base;
                        "Untaxed VAT" += VATEntry.Amount;
                    end;
                VATPostingSetup."Purchase Record Type"::"TAX REFUND":
                    begin
                        "Refund Base" += VATEntry.Base;
                        "Refund VAT" += VATEntry.Amount;
                    end;
                VATPostingSetup."Purchase Record Type"::"NOT TAXED":
                    "NOT Taxed VAT" += VATEntry.Base;
                VATPostingSetup."Purchase Record Type"::ISC:
                    "ISC Amount" += VATEntry.Base;
                VATPostingSetup."Purchase Record Type"::"OTHER TAXES AND CHARGES":
                    "Others Amount" += VATEntry.Base;
            end;
            "Total Amount" := "Taxed Base" + "Taxed VAT" + "Untaxed Base" + "Untaxed VAT" + "Refund Base" + "Refund VAT" + "NOT Taxed VAT" + "ISC Amount" + "Others Amount";
            "Payment indicator" := fnGetPurchPaymentIndicador(VATEntry); //ULN FM 06-12-21 Indicador de pago
        end;

    end;

    local procedure AddSalesTaxedValues(var VATEntry: Record "VAT Entry")
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        VATPostingSetup.Get(VATEntry."VAT Bus. Posting Group", VATEntry."VAT Prod. Posting Group");
        formatByLegalDocument(VATEntry.Base);
        formatByLegalDocument(VATEntry.Amount);
        with SalesRecordBuffer do begin
            case VATPostingSetup."Sales Record Type" of
                VATPostingSetup."Sales Record Type"::EXPORTS:
                    begin
                        "Amount Export invoiced" += VATEntry.Base;
                    end;
                VATPostingSetup."Sales Record Type"::TAXES:
                    begin
                        "Taxed Base" += VATEntry.Base;
                        "Taxed VAT" += VATEntry.Amount;
                    end;
                VATPostingSetup."Sales Record Type"::"STACKED RICE":
                    begin
                        "Taxed Stacked Rice" += VATEntry.Base;
                        "Taxed VAT  Stacked Rice" += VATEntry.Base;
                    end;
                VATPostingSetup."Sales Record Type"::EXONERATED:
                    "Total Amount Exonerated" += VATEntry.Base;
                VATPostingSetup."Sales Record Type"::INAFFECTS:
                    "Total Amount Unaffected" += VATEntry.Base;
                VATPostingSetup."Sales Record Type"::ISC:
                    "ISC Amount" += VATEntry.Base;
                VATPostingSetup."Sales Record Type"::"OTHER TAXES AND CHARGES":
                    "Others Amount" += VATEntry.Base;
            end;
            "Total Amount" := "Taxed Base" + "Taxed VAT" + "Amount Export invoiced" + "Taxed Stacked Rice" + "Taxed VAT  Stacked Rice"
             + "Total Amount Exonerated" + "Total Amount Unaffected" + "ISC Amount" + "Others Amount";
            "Payment indicator" := fnGetSalesPaymentIndicador(VATEntry); //ULN PC 26.Oct.21 Indicador de pago
        end;

    end;

    local procedure formatByLegalDocument(var pAmount: Decimal)
    var

    begin
        IF SalesRecordBuffer."Legal Document" IN ['07', '87', '97'] then
            pAmount := pAmount
        else
            pAmount := ABS(pAmount);
    end;

    procedure SetPurchRecordBufferFromPurchInvHdrModicated(var PurchInvHeader: Record "Purch. Inv. Header")
    begin
        PurchRecordBuffer."Mod. Document Date" := PurchInvHeader."Applies-to Document Date Ref.";
        PurchRecordBuffer."Mod. Legal Document" := PurchInvHeader."Legal Document Ref.";
        PurchRecordBuffer."Mod. Serie" := PurchInvHeader."Applies-to Serie Ref.";
        PurchRecordBuffer."Mod. Document" := PurchInvHeader."Applies-to Number Ref.";
        LegalDocMgt.ValidateLegalDocumentFormat(PurchInvHeader."Vendor Invoice No.",
                                                PurchRecordBuffer."Mod. Legal Document",
                                                PurchRecordBuffer."Serie Document",
                                                PurchRecordBuffer."Number Document",
                                                false,
                                                false);
    end;

    procedure SetSalesRecordBufferFromSalesInvHdrModicated(var SalesInvHeader: Record "Sales Invoice Header")
    begin
        SalesRecordBuffer."Mod. Document Date" := SalesInvHeader."Applies-to Document Date Ref.";
        SalesRecordBuffer."Mod. Legal Document" := SalesInvHeader."Legal Document Ref.";
        SalesRecordBuffer."Mod. Serie" := SalesInvHeader."Applies-to Serie Ref.";
        SalesRecordBuffer."Mod. Document" := SalesInvHeader."Applies-to Number Ref.";
        LegalDocMgt.ValidateLegalDocumentFormat(SalesInvHeader."External Document No.",
                                                SalesRecordBuffer."Mod. Legal Document",
                                                SalesRecordBuffer."Serie Document",
                                                SalesRecordBuffer."Number Document",
                                                false,
                                                false);
    end;

    procedure SetPurchRecordBufferFromPurchCrMemoHdrModicated(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.")
    begin
        PurchRecordBuffer."Mod. Document Date" := PurchCrMemoHdr."Applies-to Document Date Ref.";
        PurchRecordBuffer."Mod. Legal Document" := PurchCrMemoHdr."Legal Document Ref.";
        PurchRecordBuffer."Mod. Serie" := PurchCrMemoHdr."Applies-to Serie Ref.";
        PurchRecordBuffer."Mod. Document" := PurchCrMemoHdr."Applies-to Number Ref.";
        LegalDocMgt.ValidateLegalDocumentFormat(PurchCrMemoHdr."Vendor Cr. Memo No.",
                                                PurchRecordBuffer."Mod. Legal Document",
                                                PurchRecordBuffer."Serie Document",
                                                PurchRecordBuffer."Number Document",
                                                false,
                                                false);
    end;

    procedure SetSalesRecordBufferFromSalesCrMemoHdrModicated(var SalesCrMemoHdr: Record "Sales Cr.Memo Header")
    begin
        SalesRecordBuffer."Mod. Document Date" := SalesCrMemoHdr."Applies-to Document Date Ref.";
        SalesRecordBuffer."Mod. Legal Document" := SalesCrMemoHdr."Legal Document Ref.";
        SalesRecordBuffer."Mod. Serie" := SalesCrMemoHdr."Applies-to Serie Ref.";
        SalesRecordBuffer."Mod. Document" := SalesCrMemoHdr."Applies-to Number Ref.";
        LegalDocMgt.ValidateLegalDocumentFormat(SalesCrMemoHdr."External Document No.",
                                                PurchRecordBuffer."Mod. Legal Document",
                                                PurchRecordBuffer."Serie Document",
                                                PurchRecordBuffer."Number Document",
                                                false,
                                                false);
    end;

    procedure "CreateFileEBookFromPurchaseRecord"()
    var
        MyLineText: Text[1024];
        MySeparator: Text[10];
        TotalRecords: Integer;
        CountRecords: Integer;
        IsFileWithData: Boolean;
    begin
        CreateTempFile();
        CountRecords := 0;
        MySeparator := '|';
        IsFileWithData := false;
        case BookCode of
            '801':
                begin
                    with PurchRecordBuffer do begin
                        Reset();
                        TotalRecords := Count;
                        if FindFirst() then begin
                            IsFileWithData := true;
                            repeat
                                MyLineText := '';
                                CountRecords += 1;
                                MyLineText += Period + MySeparator;//Field 01
                                MyLineText += Format("Transaction CUO") + MySeparator;//Field 02
                                MyLineText += "Correlative cuo" + MySeparator;//Field 03
                                MyLineText += Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 04
                                MyLineText += Format("Payment Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 05
                                MyLineText += "Legal Document" + MySeparator;//Field 06
                                if "Legal Document" <> '05' then //FMM::24-12-21 Segun regla de comprobantes para el tipo 05
                                    MyLineText += "Serie Document" + MySeparator//Field 07
                                else
                                    MyLineText += '3' + MySeparator;//Field 07
                                if "DUA Document Year" = 0 then
                                    MyLineText += MySeparator
                                else
                                    MyLineText += format("DUA Document Year") + MySeparator;//Field 08
                                MyLineText += format("Number Document") + MySeparator;//Field 09
                                MyLineText += MySeparator;//Field 10
                                MyLineText += "VAT Registration Type" + MySeparator;//Field 11
                                MyLineText += "VAT Registration No." + MySeparator;//Field 12
                                MyLineText += "Vendor Name" + MySeparator;//Field 13
                                MyLineText += Format("Taxed Base", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 14
                                MyLineText += Format("Taxed VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 15
                                MyLineText += Format("Untaxed Base", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 16
                                MyLineText += Format("Untaxed VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 17
                                MyLineText += Format("Refund Base", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 18
                                MyLineText += Format("Refund VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 19
                                MyLineText += Format("NOT Taxed VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 20
                                MyLineText += Format("ISC Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 21
                                MyLineText += '0.00' + MySeparator;//Field 22 Impuesto a la bolsa
                                MyLineText += Format("Others Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 23
                                MyLineText += Format("Total Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 24
                                MyLineText += FormatCurrency("Currency Code") + MySeparator;//Field 25
                                MyLineText += Format("Currency Amount", 0, '<Precision,3:3><Standard Format,2>') + MySeparator;//Field 26 //FMM 21.01.22 No aparecian los 3 decimales en tipo cambio
                                MyLineText += Format("Mod. Document Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Fiedl 27
                                MyLineText += "Mod. Legal Document" + MySeparator;//Field 28
                                MyLineText += "Mod. Serie" + MySeparator;//Field 29
                                MyLineText += "DUA Code" + MySeparator;//Field 30
                                MyLineText += "Mod. Document" + MySeparator;//Field 31
                                MyLineText += Format("Detraction Emision Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 32
                                MyLineText += "Detraction Operation No." + MySeparator;//Field 33
                                if "Retention Mark" then
                                    MyLineText += '1' + MySeparator//Field 34
                                else
                                    MyLineText += '' + MySeparator;//Field 34
                                MyLineText += "Clas. Property and Services" + MySeparator;//Field 35
                                MyLineText += MySeparator;//Field 36
                                MyLineText += MySeparator;//Field 37
                                MyLineText += MySeparator;//Field 38
                                MyLineText += MySeparator;//Field 39
                                MyLineText += MySeparator;//Field 40
                                //MyLineText += MySeparator;//Field 41
                                if "Payment indicator" <> 0 then
                                    MyLineText += Format("Payment indicator") + MySeparator//Field 41
                                else
                                    MyLineText += MySeparator;//Field 41
                                MyLineText += Format(Status);//Field 42
                                MyLineText += MySeparator;//Field 43
                                InsertLineToTempFile(MyLineText);
                                UpdateWindows(2, CountRecords, TotalRecords);
                            until Next() = 0;
                        end;
                        PostFileToControlFileRecord(IsFileWithData);
                    end;
                end;
            '802':
                begin
                    with PurchRecordBuffer do begin
                        Reset();
                        TotalRecords := Count;
                        if FindFirst() then begin
                            IsFileWithData := true;
                            repeat
                                MyLineText := '';
                                CountRecords += 1;
                                MyLineText += Period + MySeparator;//Field 01
                                MyLineText += Format("Transaction CUO") + MySeparator;//Field 02
                                MyLineText += "Correlative cuo" + MySeparator;//Field 03
                                MyLineText += Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 04
                                MyLineText += "Legal Document" + MySeparator;//Field 05
                                MyLineText += "Serie Document" + MySeparator;//Field 06
                                MyLineText += format("Number Document") + MySeparator;//Field 07
                                MyLineText += '0.00' + MySeparator;//Field 08
                                MyLineText += '0.00' + MySeparator;//Field 09
                                MyLineText += Format("Taxed Base", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 10
                                MyLineText += '' + MySeparator;//Field 11
                                MyLineText += "Serie Document" + MySeparator;//Field 12
                                MyLineText += '' + MySeparator;// Field 13
                                MyLineText += '' + MySeparator;//Field 14
                                MyLineText += Format("Taxed VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 15
                                MyLineText += FormatCurrency("Currency Code") + MySeparator;//Field 16
                                MyLineText += Format("Currency Amount", 0, '<Precision,3:3><Standard Format,2>') + MySeparator;//Field 17 //FMM 21.01.22 No aparecian los 3 decimales en tipo cambio
                                MyLineText += "Country Residence Not Address" + MySeparator;//Field 18
                                MyLineText += "Vendor Name" + MySeparator;//Field 19
                                MyLineText += "Foreing Residence Not Address" + MySeparator;//Field 20
                                MyLineText += "VAT Registration No." + MySeparator;//Field 21
                                MyLineText += "VAT Registration No." + MySeparator;//Field 22
                                MyLineText += "Vendor Name" + MySeparator;//Field 23
                                MyLineText += "Country Residence Not Address" + MySeparator;//Field 24
                                MyLineText += '' + MySeparator;//Field 25
                                MyLineText += '' + MySeparator;//Field 26
                                MyLineText += '' + MySeparator;//Field 27
                                MyLineText += '' + MySeparator;//Field 28
                                MyLineText += '' + MySeparator;//Field 29
                                MyLineText += '' + MySeparator;//Field 30
                                MyLineText += '00' + MySeparator;//Field 31
                                MyLineText += '' + MySeparator;//Field 32
                                MyLineText += '' + MySeparator;//Field 33
                                MyLineText += '' + MySeparator;//Field 34
                                MyLineText += '' + MySeparator;//Field 35
                                MyLineText += Format(Status);//Field 36
                                MyLineText += '' + MySeparator;//Field 37
                                InsertLineToTempFile(MyLineText);
                                UpdateWindows(2, CountRecords, TotalRecords);
                            until Next() = 0;
                        end;
                        PostFileToControlFileRecord(IsFileWithData);
                    end;
                end;
        end;
    end;

    procedure "CreateFileEBookFromSalesRecord"()
    var
        MyLineText: Text[1024];
        MySeparator: Text[10];
        TotalRecords: Integer;
        CountRecords: Integer;
        IsFileWithData: Boolean;
    begin
        CreateTempFile();
        CountRecords := 0;
        MySeparator := '|';
        IsFileWithData := false;
        case BookCode of
            '1401':
                begin
                    with SalesRecordBuffer do begin
                        Reset();
                        TotalRecords := Count;
                        if FindFirst() then begin
                            IsFileWithData := true;
                            repeat
                                MyLineText := '';
                                CountRecords += 1;
                                MyLineText += Period + MySeparator;//Field 01
                                MyLineText += Format("Transaction CUO") + MySeparator;//Field 02
                                MyLineText += "Correlative cuo" + MySeparator;//Field 03
                                MyLineText += Format("Document Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 04
                                MyLineText += Format("Payment Due Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Field 05
                                MyLineText += "Legal Document" + MySeparator;//Field 06
                                MyLineText += "Serie Document" + MySeparator;//Field 07
                                MyLineText += format("Number Document") + MySeparator;//Field 08
                                IF "Legal Document" IN ['00', '12', '13', '87'] = FALSE then //FMM 21.01.22 Kath solicito quitar para las boletas
                                    MyLineText += MySeparator //Field 09
                                ELSE
                                    MyLineText += Format("Field 9 Total Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 09
                                MyLineText += "VAT Registration Type" + MySeparator;//Field 10
                                MyLineText += "VAT Registration No." + MySeparator;//Field 11
                                MyLineText += "Customer Name" + MySeparator;//Field 12
                                MyLineText += Format("Amount Export invoiced", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 13
                                MyLineText += Format("Taxed Base", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 14
                                MyLineText += Format("Taxed Base Discount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 15
                                MyLineText += Format("Taxed VAT", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 16
                                MyLineText += Format("Disc. Municipal Promotion Tax", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 17
                                MyLineText += Format("Total Amount Exonerated", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 18
                                MyLineText += Format("Total Amount Unaffected", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 19
                                MyLineText += Format("ISC Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 20
                                MyLineText += Format("Taxed Stacked Rice", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 21
                                MyLineText += Format("Taxed VAT  Stacked Rice", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 22
                                MyLineText += Format("Bag tax", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 23                            
                                MyLineText += Format("Others Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 24
                                MyLineText += Format("Total Amount", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 25
                                if "Currency Code" = '' then
                                    MyLineText += 'PEN' + MySeparator//Field 26 
                                else
                                    MyLineText += "Currency Code" + MySeparator;//Field 26
                                MyLineText += Format("Currency Amount", 0, '<Precision,3:3><Standard Format,2>') + MySeparator;//Field 27 //FMM 21.01.22 No aparecian los 3 decimales en tipo cambio
                                MyLineText += Format("Mod. Document Date", 0, '<Day,2>/<Month,2>/<Year4>') + MySeparator;//Fiedl 28
                                MyLineText += "Mod. Legal Document" + MySeparator;//Field 29
                                MyLineText += "Mod. Serie" + MySeparator;//Field 30
                                MyLineText += "Mod. Document" + MySeparator;//Field 31
                                MyLineText += "Contract Identification" + MySeparator;//Field 32
                                MyLineText += MySeparator;//Field 33
                                if "Payment indicator" <> 0 then
                                    MyLineText += Format("Payment indicator") + MySeparator//Field 34
                                else
                                    MyLineText += MySeparator;//Field 34
                                MyLineText += format(Status) + MySeparator;//Field 35
                                MyLineText += "Field Free" + MySeparator;//Field 36
                                InsertLineToTempFile(MyLineText);
                                UpdateWindows(2, CountRecords, TotalRecords);
                            until Next() = 0;
                        end;
                        PostFileToControlFileRecord(IsFileWithData);
                    end;
                end;

        end;
    end;

    procedure GetPuchRecordBuffer(var pPurchRecordBuffer: Record "Purchase Record Buffer" temporary)
    begin
        PurchRecordBuffer.Reset();
        if PurchRecordBuffer.FindFirst() then
            repeat
                pPurchRecordBuffer.Init();
                pPurchRecordBuffer.TransferFields(PurchRecordBuffer, true);
                pPurchRecordBuffer.Insert();
            until PurchRecordBuffer.Next() = 0;
    end;

    procedure GetSalesRecordBuffer(var pSalesRecordBuffer: Record "Sales Record Buffer" temporary)
    begin
        SalesRecordBuffer.Reset();
        if SalesRecordBuffer.FindFirst() then
            repeat
                pSalesRecordBuffer.Init();
                pSalesRecordBuffer.TransferFields(SalesRecordBuffer, true);
                pSalesRecordBuffer.Insert();
            until SalesRecordBuffer.Next() = 0;
    end;
    //File Management functions
    local procedure CreateTempFile()
    begin
        TempFileBlob.CreateOutStream(ConstrutOutStream, TextEncoding::UTF8);
    end;

    local procedure InsertLineToTempFile(LineText: Text[1024])
    begin
        ConstrutOutStream.WriteText(LineText);
        ConstrutOutStream.WriteText;
    end;

    procedure PostFileToControlFileRecord(IsFileWithData: Boolean)
    var
        CompInf: Record "Company Information";
        ControlFile: Record "ST Control File";
        NewFileInStream: InStream;
        FileName: Text;
        FileExt: Text;
        EntryNo: Integer;
        ContentIndicator: Text;
        ConfirmDownload: Label 'Do you want to download the following file?', Comment = 'ESM="¿Quieres descargar el siguiente archivo?"';
    begin
        ContentIndicator := '0';
        if IsFileWithData then
            ContentIndicator := '1';

        CompInf.Get();
        TempFileBlob.CreateInStream(NewFileInStream, TextEncoding::UTF8);
        FileName := 'LE' + CompInf."VAT Registration No." + Format(EndDate, 0, '<Year4><Month,2>000') + BookCode + '00001' + ContentIndicator + '11';
        CASE BookCode OF
            '1401':
                FileName := 'LE' + CompInf."VAT Registration No." + Format(EndDate, 0, '<Year4><Month,2>00') + BookCode + '00001' + ContentIndicator + '11';

        END;
        FileExt := 'txt';
        EntryNo := ControlFile.CreateControlFileRecord(BookCode, FileName, FileExt, StartDate, EndDate, NewFileInStream);
        if EntryNo <> 0 then
            if Confirm(ConfirmDownload, false) then begin
                ControlFile.Get(EntryNo);
                if (IsFileWithData) then
                    ControlFile.DownLoadFile(ControlFile)
                else
                    ControlFile.DownloadEmptyFile(ControlFile);
            end;
    end;

    //Set Parameter Book Management
    local procedure SetDate(): Boolean
    var
        SetDateToBook: Page "Set Date to Book";
    begin
        Clear(SetDateToBook);
        SetDateToBook.SetBookCode(BookCode);
        if SetDateToBook.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            SetDateToBook.SetFilterDate(StartDate, EndDate);
            exit(true);
        end;
        exit(false);
    end;

    procedure SetDate(pStartDate: Date; pEndDate: Date)
    begin
        StartDate := pStartDate;
        EndDate := pEndDate;
        NotRequestDate := true;
    end;

    local procedure CheckDateExists(): Boolean
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Message(CheckDateExistsMessage);
        if EndDate > CalcDate('<+CM>', StartDate) then
            Message(ErrorSelectedDate);
        exit(not (StartDate = 0D) or (EndDate = 0D) or (EndDate > CalcDate('<+CM>', StartDate)));
    end;

    //Suscriber Events
    [EventSubscriber(ObjectType::Codeunit, CodeUnit::"Gen. Jnl.-Post Line", 'OnAfterGLFinishPosting', '', true, true)]
    procedure CorrelativeAndCUOControl(GLEntry: Record "G/L Entry"; var GenJnlLine: Record "Gen. Journal Line"; IsTransactionConsistent: Boolean; FirstTransactionNo: Integer; var GLRegister: Record "G/L Register"; var TempGLEntryBuf: Record "G/L Entry" temporary; var NextEntryNo: Integer; var NextTransactionNo: Integer)
    var
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        GLEntry1: Record "G/L Entry";
        GLEntry2: Record "G/L Entry";
        GLEntry3: Record "G/L Entry";
        TempGLEntryBuf2: Record 17 temporary;
        LastTransactionCUO: Integer;
        LastCorrelativeCUO: Code[10];
        LastDocumentNo: Code[20];
    begin
        SLSetup.Get();
        if SLSetup."Enabled Posting (CUO)" then
            exit;
        Clear(GLEntry1);
        GLEntry1.SetCurrentKey("Transaction CUO");
        GLEntry1.SetRange("Document No.", GenJnlLine."Document No.");
        GLEntry1.SetFilter("Transaction CUO", '<>%1', 0);
        if GLEntry1.FindLast() then
            LastTransactionCUO := GLEntry1."Transaction CUO";

        if LastTransactionCUO = 0 then begin
            Clear(GLEntry1);
            GLEntry1.SetCurrentKey("Transaction CUO");
            GLEntry1.SetFilter("Transaction CUO", '<>%1', 0);
            if GLEntry1.FindLast() then
                LastTransactionCUO := GLEntry1."Transaction CUO" + 1
            else
                LastTransactionCUO := 1;
        end;

        Clear(GLEntry2);
        GLEntry2.SetCurrentKey("Correlative CUO");
        GLEntry2.SetRange("Document No.", GenJnlLine."Document No.");
        GLEntry2.SetFilter("Correlative CUO", '<>%1', '');
        if GLEntry2.FindLast() then begin
            LastCorrelativeCUO := IncStr(GLEntry2."Correlative CUO");
        end else begin
            Clear(GLEntry2);
            GLEntry2.SetCurrentKey("Correlative CUO");
            GLEntry2.SetRange("Document No.", GenJnlLine."Document No.");
            if GLEntry2.FindFirst() then begin
                case true of
                    GLEntry2.Opening:
                        LastCorrelativeCUO := 'A000000001';
                    (GLEntry2."Posting Date" = ClosingDate(GLEntry2."Posting Date")) and
                    (NOT GLEntry2.Opening):
                        LastCorrelativeCUO := 'C000000001';
                    else
                        LastCorrelativeCUO := 'M000000001';
                end;
            end;
        end;

        Clear(GLEntry3);
        GLEntry3.SetCurrentKey("Correlative CUO");
        GLEntry3.SetRange("Entry No.", GLRegister."From Entry No.", GLRegister."To Entry No.");
        GLEntry3.SetRange("Correlative CUO", '');
        if GLEntry3.FindSet(true, true) then begin
            repeat
                TempGLEntryBuf2.Init();
                TempGLEntryBuf2."Entry No." := GLEntry3."Entry No.";
                TempGLEntryBuf2."Correlative CUO" := LastCorrelativeCUO;
                TempGLEntryBuf2."Transaction CUO" := LastTransactionCUO;
                TempGLEntryBuf2.Insert();
                LastCorrelativeCUO := IncStr(LastCorrelativeCUO);
            until GLEntry3.Next = 0;
        end;

        TempGLEntryBuf2.Reset();
        IF TempGLEntryBuf2.FindSet() then
            repeat
                Clear(GLEntry3);
                GLEntry3.SetCurrentKey("Entry No.");
                GLEntry3.SetRange("Entry No.", TempGLEntryBuf2."Entry No.");
                if GLEntry3.FindSet() then begin
                    GLEntry3."Correlative CUO" := TempGLEntryBuf2."Correlative CUO";
                    GLEntry3."Transaction CUO" := TempGLEntryBuf2."Transaction CUO";
                    GLEntry3.Modify();
                end;
            until TempGLEntryBuf2.Next() = 0;

    end;

    //Publisher Events
    [IntegrationEvent(false, false)]
    procedure OnAfterSetInformationFromPurchDocument(var PurchRecordBuffer: Record "Purchase Record Buffer" temporary; var VATEntry: Record "VAT Entry")
    begin
    end;
    //Publisher Events
    [IntegrationEvent(false, false)]
    procedure OnAfterSetInformationFromSalesDocument(var SalesRecordBuffer: Record "Sales Record Buffer" temporary; var VATEntry: Record "VAT Entry")
    begin
    end;

    //Functions for init dev.
    procedure InitializeConfigurationAccountantBook()
    begin
        CreateAccountantBook(3, '3', '3', 0, 'LIBRO DE INVENTARIO Y BALANCES', 1);
        CreateAccountantBook(31, '5', '5', 0, 'LIBRO DIARIO', 1);
        CreateAccountantBook(35, '7', '7', 0, 'REGISTRO DE ACTIVOS FIJOS', 1);
        CreateAccountantBook(39, '8', '8', 0, 'REGISTRO DE COMPRAS', 1);
        CreateAccountantBook(42, '9', '9', 0, 'REGISTRO DE CONSIGNACIONES', 1);
        CreateAccountantBook(45, '10', '10', 0, 'REGISTRO DE COSTOS', 1);
        CreateAccountantBook(52, '30300', '3.3.0', 0, 'OTROS LIBROS DE INVETARIOS Y BALANCES', 1);
        CreateAccountantBook(53, '30301', '3.3.1', 0, 'AUXILIAR LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 12 CUENTAS POR COBRAR COMERCIALES – TERCEROS Y 13 CUENTAS POR COBRAR COMERCIALES – RELACIONADAS', 2);
        CreateAccountantBook(54, '30302', '3.3.2', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 18 - SERVICIOS Y OTROS CONTRATADOS POR ANTICIPADO', 2);
        CreateAccountantBook(55, '30303', '3.3.3', 0, 'LIBRO DE INVENTARIOS Y BALANCES - TRIBUTOS,CONTRAPRESTACIONES Y APORTES AL SISTEMA DE PENSIONES Y SALUD POR PAGAR', 2);
        CreateAccountantBook(56, '30304', '3.3.4', 0, 'LIBRO DE INVENTARIOS Y BALANCES - CUENTA 45 OBLIGACIONES FINANCIERAS', 2);
        CreateAccountantBook(57, '30305', '3.3.5', 0, 'AUXILIAR LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 42 CUENTAS POR PAGAR COMERCIALES – TERCEROS Y LA CUENTA 43 CUENTAS POR PAGAR COMERCIALES – RELACIONADAS ', 2);
        CreateAccountantBook(58, '30306', '3.3.6', 0, 'AUXILIAR LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 46 CUENTAS POR PAGAR DIVERSAS – TERCEROS Y DE LA CUENTA 47 CUENTAS POR PAGAR DIVERSAS – RELACIONADAS', 2);
        CreateAccountantBook(59, '30307', '3.3.7', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 32 - ACTIVOS ADQUIRIDOS EN ARRENDAMIENTO FINANCIERO', 2);
        CreateAccountantBook(60, '30308', '3.3.8', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 25 - MATERIALES AUXILIARES , SUMINISTROS Y REPUESTOS', 2);
        CreateAccountantBook(61, '30309', '3.3.9', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 33 - INMUEBLES , MAQUINARIAS Y EQUIPO', 2);
        CreateAccountantBook(62, '303010', '3.3.10', 0, 'AUXILIAR LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 39 - DEPRECIACIÓN INMUEBLES , MAQUINARIAS Y EQUIPO', 2);
        CreateAccountantBook(46, '1001', '10.1', 0, 'REGISTRO DE COSTOS - ESTADO DE COSTO DE VENTAS ANUAL', 2);
        CreateAccountantBook(47, '1002', '10.2', 0, 'REGISTRO DE COSTOS - ELEMENTOS DEL COSTO MENSUAL', 2);
        CreateAccountantBook(48, '1003', '10.3', 0, 'REGISTRO DE COSTOS - ESTADO DE COSTO DE PRODUCCION VALORIZADO ANUAL', 2);
        CreateAccountantBook(1, '101', '1.1', 0, 'LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DEL EFECTIVO', 1);
        CreateAccountantBook(2, '102', '1.2', 0, 'LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DE LA CUENTA CORRIENTE', 1);
        CreateAccountantBook(49, '1201', '12.1', 0, 'REGISTRO DEL INVENTARIO PERMANENTE EN UNIDADES FÍSICAS - DETALLE DEL INVENTARIO PERMANENTE EN UNIDADES FÍSICAS', 1);
        CreateAccountantBook(50, '1301', '13.1', 0, 'REGISTRO DEL INVENTARIO PERMANENTE VALORIZADO - DETALLE DEL INVENTARIO VALORIZADO', 1);
        CreateAccountantBook(51, '1401', '14.1', 0, 'REGISTRO DE VENTAS E INGRESOS', 1);
        CreateAccountantBook(4, '301', '3.1', 0, 'LIBRO DE INVENTARIOS Y BALANCES - BALANCE GENERAL', 2);
        CreateAccountantBook(5, '302', '3.2', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 10 EFECTIVO Y EQUIVALENTES DE EFECTIVO (2)', 2);
        CreateAccountantBook(6, '303', '3.3', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 12 CUENTAS POR COBRAR COMERCIALES – TERCEROS Y 13 CUENTAS POR COBRAR COMERCIALES – RELACIONADAS', 2);
        CreateAccountantBook(7, '304', '3.4', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO  DE LA CUENTA 14 CUENTAS POR COBRAR AL PERSONAL, A LOS ACCIONISTAS (SOCIOS), DIRECTORES Y GERENTES (2)', 2);
        CreateAccountantBook(8, '305', '3.5', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO  DE LA CUENTA 16 CUENTAS POR COBRAR DIVERSAS - TERCEROS O CUENTA 17 - CUENTAS POR COBRAR DIVERSAS - RELACIONADAS', 2);
        CreateAccountantBook(9, '306', '3.6', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 19 ESTIMACIÓN DE CUENTAS DE COBRANZA DUDOSA', 2);
        CreateAccountantBook(10, '307', '3.7', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 20 - MERCADERIAS Y LA CUENTA 21 - PRODUCTOS TERMINADOS (2)', 2);
        CreateAccountantBook(11, '308', '3.8', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 30 INVERSIONES MOBILIARIAS  (2)', 2);
        CreateAccountantBook(12, '309', '3.9', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 34 - INTANGIBLES', 2);
        CreateAccountantBook(13, '311', '3.11', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 41 REMUNERACIONES Y PARTICIPACIONES POR PAGAR (2)', 2);
        CreateAccountantBook(14, '312', '3.12', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 42 CUENTAS POR PAGAR COMERCIALES – TERCEROS Y LA CUENTA 43 CUENTAS POR PAGAR COMERCIALES – RELACIONADAS ', 2);
        CreateAccountantBook(15, '313', '3.13', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 46 CUENTAS POR PAGAR DIVERSAS – TERCEROS Y DE LA CUENTA 47 CUENTAS POR PAGAR DIVERSAS – RELACIONADAS', 2);
        CreateAccountantBook(16, '314', '3.14', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 47 - BENEFICIOS SOCIALES DE LOS TRABAJADORES (PCGR) - NO APLICABLE PARA EL PCGE (2)', 2);
        CreateAccountantBook(17, '315', '3.15', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 49 PASIVO DIFERIDO', 2);
        CreateAccountantBook(18, '316', '3.16', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 50 CAPITAL', 2);
        CreateAccountantBook(19, '31601', '3.16.1', 0, '3.16.1 DETALLE DEL SALDO DE LA CUENTA 50 - CAPITAL ', 3);
        CreateAccountantBook(20, '31602', '3.16.2', 0, '3.16.2 ESTRUCTURA DE LA PARTICIPACIÓN ACCIONARIA O DE PARTICIPACIONES SOCIALES', 3);
        CreateAccountantBook(21, '317', '3.17', 0, 'LIBRO DE INVENTARIOS Y BALANCES - BALANCE DE COMPROBACIÓN', 2);
        CreateAccountantBook(22, '318', '3.18', 0, 'LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE FLUJOS DE EFECTIVO', 2);
        CreateAccountantBook(23, '319', '3.19', 0, 'LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE CAMBIOS EN EL PATRIMONIO NETO', 2);
        CreateAccountantBook(24, '320', '3.2', 0, 'LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE GANANCIAS Y PÉRDIDAS POR FUNCIÓN', 2);
        CreateAccountantBook(25, '321', '3.21', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL PLAN CONTABLE UTILIZADO', 2);
        CreateAccountantBook(26, '322', '3.22', 0, 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DE LAS CUENTAS Y/O PARTIDAS DE LOS ESTADOS FINANCIEROS', 2);
        CreateAccountantBook(27, '323', '3.23', 0, 'LIBRO DE INVENTARIOS Y BALANCES - NOTAS A LOS ESTADOS FINANCIEROS (3)', 2);
        CreateAccountantBook(28, '324', '3.24', 0, 'LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE RESULTADO INTEGRALES', 2);
        CreateAccountantBook(29, '325', '3.25', 0, 'LIBRO DE INVENTARIOS Y BALANCES - ESTADO DE FLUJOS DE EFECTIVOS - MÉTODO INDIRECTO', 2);
        CreateAccountantBook(30, '401', '4.1', 0, 'LIBRO DE RETENCIONES INCISO E) Y F) DEL ART. 34° DE LA LEY DEL IMPUESTO A LA RENTA', 1);
        CreateAccountantBook(32, '501', '5.1', 51001, 'LIBRO DIARIO', 2);
        CreateAccountantBook(33, '503', '5.3', 0, 'LIBRO DIARIO - DETALLE DEL PLAN CONTABLE UTILIZADO', 2);
        CreateAccountantBook(34, '601', '6.1', 51004, 'LIBRO MAYOR', 1);
        CreateAccountantBook(36, '701', '7.1', 0, 'REGISTRO DE ACTIVOS FIJOS - DETALLE DE LOS ACTIVOS FIJOS REVALUADOS Y NO REVALUADOS', 2);
        CreateAccountantBook(37, '703', '7.3', 0, 'REGISTRO DE ACTIVOS FIJOS - DETALLE DE LA DIFERENCIA DE CAMBIO', 2);
        CreateAccountantBook(38, '704', '7.4', 0, 'REGISTRO DE ACTIVOS FIJOS - DETALLE DE LOS ACTIVOS FIJOS BAJO LA MODALIDAD DE ARRENDAMIENTO FINANCIERO AL 31.12', 2);
        CreateAccountantBook(40, '801', '8.1', 51000, 'REGISTRO DE COMPRAS', 2);
        CreateAccountantBook(41, '802', '8.2', 0, 'REGISTRO DE COMPRAS - NO DOMICILIADOS', 2);
        CreateAccountantBook(43, '901', '9.1', 0, 'REGISTRO DE CONSIGNACIONES - PARA EL CONSIGNADOR - CONTROL DE BIENES ENTREGADOS EN CONSIGNACIÓN', 2);
        CreateAccountantBook(44, '902', '9.2', 0, 'REGISTRO DE CONSIGNACIONES - PARA EL CONSIGNATARIO - CONTROL DE BIENES RECIBIDOS EN CONSIGNACIÓN', 2);
    end;

    procedure CopyConfigurationAccountantBook()
    var
        lclPageDialogPage: Page "Standard Dialog Page";
        lclFromCompanyName: Text;
        lcRecFromAccountantBook: Record "Accountant Book";
        lcRecToAccountantBook: Record "Accountant Book";
    begin
        Clear(lclPageDialogPage);
        lclPageDialogPage.SetType(4);
        lclPageDialogPage.RunModal();
        lclFromCompanyName := lclPageDialogPage.GetCompanyName();

        if lclFromCompanyName = '' then
            Message('Debe seleccionar la empresa origen a Copiar.');

        if lclFromCompanyName = '' then
            exit;

        lcRecFromAccountantBook.Reset();
        lcRecFromAccountantBook.ChangeCompany(lclFromCompanyName);
        if lcRecFromAccountantBook.FindSet() then begin
            lcRecToAccountantBook.Reset();
            lcRecToAccountantBook.DeleteAll();
            repeat
                lcRecToAccountantBook.Init();
                lcRecToAccountantBook.Copy(lcRecFromAccountantBook);
                lcRecToAccountantBook.Insert();
            until lcRecFromAccountantBook.Next() = 0;
            Message('Copia Realizada.');
        end;
    end;

    local procedure CreateAccountantBook("EntryNo.": Integer; EBookCode: Text[10]; BookCode: Code[20]; ReportID: Integer; BookName: Text[250]; Level: Integer)
    var
        AccountantBook: Record "Accountant Book";
    begin
        AccountantBook.Init();
        AccountantBook."Entry No." := "EntryNo.";
        AccountantBook."EBook Code" := EBookCode;
        AccountantBook."Book Code" := BookCode;
        AccountantBook."Book Name" := BookName;
        AccountantBook.Level := Level;
        AccountantBook.Mandatory := true;
        AccountantBook."Type Solution" := AccountantBook."Type Solution"::"Bookerper Cabin";
        AccountantBook."Report ID" := ReportID;
        AccountantBook.Insert();
    end;

    procedure GenerateCostRecordFormat(FechaInicio: Date; FechaFin: Date; Formato: Code[10])
    var
        lclGlEntryTemp: Record "G/L Entry" temporary;
        recGenProductPostingGroup: Record "Gen. Product Posting Group";
        booAddFreTitle: Boolean;
        recItem: Record "Item";
    begin
        gTemporalPurchSalesRec.RESET;
        IF gTemporalPurchSalesRec.FINDSET THEN
            gTemporalPurchSalesRec.DELETEALL;

        SetearVariableRegistroCostos();

        IF (Formato = '10.2') OR (Formato = '10.3') THEN BEGIN
            gTemporalPurchSalesRec."Entry No." := 1;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := DATE2DMY(FechaFin, 3);
            gTemporalPurchSalesRec."Consumo Produccion" := '1- Materiales y Suministros Directos';
            gTemporalPurchSalesRec.Enero := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec."Entry No." := 2;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := DATE2DMY(FechaFin, 3);
            gTemporalPurchSalesRec."Consumo Produccion" := '2- Mano de Obra Directa';
            gTemporalPurchSalesRec.Enero := 0;
            gTemporalPurchSalesRec.INSERT;
        END;

        recItemLedgerEntry.RESET;
        recItemLedgerEntry.SETRANGE("Posting Date", FechaInicio, FechaFin);
        recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Entry Type", recItemLedgerEntry."Entry Type"::Purchase);
        gCant := recItemLedgerEntry.COUNT() + 2;

        IF recItemLedgerEntry.FINDSET THEN
            REPEAT

                // Get Config Posting Group
                booAddFreTitle := FALSE;
                CLEAR(recGenProductPostingGroup);
                CLEAR(recItem);
                recItem.GET(recItemLedgerEntry."Item No.");

                recGenProductPostingGroup.SETRANGE(Code, recItem."Gen. Prod. Posting Group");
                recGenProductPostingGroup.SETRANGE("Free Title", TRUE);
                IF recGenProductPostingGroup.FIND('-') THEN
                    booAddFreTitle := TRUE;

                gTemporalPurchSalesRec.INIT;
                gCounter += 1;
                recItemLedgerEntry.CALCFIELDS(recItemLedgerEntry."Cost Amount (Actual)");
                gTemporalPurchSalesRec."Entry No." := gCounter + 2;
                gTemporalPurchSalesRec.Purchases := FALSE;
                gTemporalPurchSalesRec.Usuario := 'RPT';
                gTemporalPurchSalesRec."Consumo Produccion" := '3- Otros Costos Directos';

                gMes := DATE2DMY(recItemLedgerEntry."Posting Date", 2);

                gPeriodo := DATE2DMY(recItemLedgerEntry."Posting Date", 3);

                gTemporalPurchSalesRec.Periodo := gPeriodo;

                gTemporalPurchSalesRec."Posting Date" := recItemLedgerEntry."Posting Date";

                CASE gMes OF
                    1:
                        gTemporalPurchSalesRec.Enero := recItemLedgerEntry."Cost Amount (Actual)";
                    2:
                        gTemporalPurchSalesRec.Febrero := recItemLedgerEntry."Cost Amount (Actual)";
                    3:
                        gTemporalPurchSalesRec.Marzo := recItemLedgerEntry."Cost Amount (Actual)";
                    4:
                        gTemporalPurchSalesRec.Abril := recItemLedgerEntry."Cost Amount (Actual)";
                    5:
                        gTemporalPurchSalesRec.Mayo := recItemLedgerEntry."Cost Amount (Actual)";
                    6:
                        gTemporalPurchSalesRec.Junio := recItemLedgerEntry."Cost Amount (Actual)";
                    7:
                        gTemporalPurchSalesRec.Julio := recItemLedgerEntry."Cost Amount (Actual)";
                    8:
                        gTemporalPurchSalesRec.Agosto := recItemLedgerEntry."Cost Amount (Actual)";
                    9:
                        gTemporalPurchSalesRec.Septiembre := recItemLedgerEntry."Cost Amount (Actual)";
                    10:
                        gTemporalPurchSalesRec.Octubre := recItemLedgerEntry."Cost Amount (Actual)";
                    11:
                        gTemporalPurchSalesRec.Noviembre := recItemLedgerEntry."Cost Amount (Actual)";
                    12:
                        gTemporalPurchSalesRec.Deciembre := recItemLedgerEntry."Cost Amount (Actual)";
                END;
                IF booAddFreTitle = FALSE THEN BEGIN
                    gSumTotal := gSumTotal + recItemLedgerEntry."Cost Amount (Actual)";
                    gTemporalPurchSalesRec.Total := gSumTotal;
                    gTemporalPurchSalesRec.INSERT;
                END;

            UNTIL recItemLedgerEntry.NEXT = 0;

        "#InsertarElementoConsumoProduccion"(Formato, DATE2DMY(recItemLedgerEntry."Posting Date", 3), gCant);
    end;


    local procedure "SetearVariableRegistroCostos"()
    begin
        //Seteando Variable
        gSumEnero := 0;
        gSumFebrero := 0;
        gSumMarzo := 0;
        gSumAbril := 0;
        gSumMayo := 0;
        gSumJunio := 0;
        gSumJulio := 0;
        gSumAgosto := 0;
        gSumSeptiembre := 0;
        gSumOctubre := 0;
        gSumNoviembre := 0;
        gSumDiciembre := 0;
    end;

    local procedure "#InsertarElementoConsumoProduccion"(Formato: Code[10]; Periodo: Integer; Cantidad: Integer)
    begin
        //--Se ingresa el registro en forma directa, porque el cliente no va declarar estos consumos
        gTemporalPurchSalesRec.INIT;
        IF (Formato = '10.2') OR (Formato = '10.3') THEN BEGIN
            IF Formato = '10.3' THEN BEGIN
                gTemporalPurchSalesRec."Entry No." := Cantidad + 1;
                gTemporalPurchSalesRec.Purchases := FALSE;
                gTemporalPurchSalesRec.Usuario := 'RPT';
                gTemporalPurchSalesRec.Periodo := Periodo;
                gTemporalPurchSalesRec."Consumo Produccion" := '2- Mano de Obra Directa';
                gTemporalPurchSalesRec.Deciembre := 0;
                gTemporalPurchSalesRec.INSERT;

                gTemporalPurchSalesRec.INIT;
                gTemporalPurchSalesRec."Entry No." := Cantidad + 2;
                gTemporalPurchSalesRec.Purchases := FALSE;
                gTemporalPurchSalesRec.Usuario := 'RPT';
                gTemporalPurchSalesRec.Periodo := Periodo;
                gTemporalPurchSalesRec."Consumo Produccion" := '3- Otros Costos Directos';
                gTemporalPurchSalesRec.Deciembre := 0;
                gTemporalPurchSalesRec.INSERT;
            END;
            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 3;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := '4- Mano de Obra Directa';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 4;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := '.   4.1-  Materiales y Suministros Indirectos';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 5;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := '.   4.2-  Mano de Obra Directa';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 6;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := '.   4.3-  Otros Gastos de Producción Indirectos';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;
        END;

        IF (Formato = '10.3') THEN BEGIN
            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 7;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := 'TOTAL CONSUMO EN LA PRODUCCIÛN';

            WITH gPurchasesSalesRecordsAux DO BEGIN
                RESET;
                SETRANGE(Usuario, 'RPT');
                SETRANGE("Consumo Produccion", '3- OTROS COSTOS DIRECTOS');
                CALCSUMS(Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Deciembre);
                gTemporalPurchSalesRec.Enero := (Enero + Febrero + Marzo + Abril + Mayo + Junio + Julio + Agosto + Septiembre + Octubre + Noviembre + Deciembre);
            END;

            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 8;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := 'Inventario Inicial de Productos en Proceso';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 9;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := 'Inventario Final de Productos en Proceso';
            gTemporalPurchSalesRec.Deciembre := 0;
            gTemporalPurchSalesRec.INSERT;

            gTemporalPurchSalesRec.INIT;
            gTemporalPurchSalesRec."Entry No." := Cantidad + 10;
            gTemporalPurchSalesRec.Purchases := FALSE;
            gTemporalPurchSalesRec.Usuario := 'RPT';
            gTemporalPurchSalesRec.Periodo := Periodo;
            gTemporalPurchSalesRec."Consumo Produccion" := 'Costo Producción';
            WITH gPurchasesSalesRecordsAux DO BEGIN
                RESET;
                SETRANGE(Usuario, 'RPT');
                SETRANGE("Consumo Produccion", '3- OTROS COSTOS DIRECTOS');
                CALCSUMS(Enero, Febrero, Marzo, Abril, Mayo, Junio, Julio, Agosto, Septiembre, Octubre, Noviembre, Deciembre);
                gTemporalPurchSalesRec.Enero := (Enero + Febrero + Marzo + Abril + Mayo + Junio + Julio + Agosto + Septiembre + Octubre + Noviembre + Deciembre);
            END;
            gTemporalPurchSalesRec.INSERT;
        END;
    end;

    local procedure FormatCurrency(pCurrency: Text): Text
    begin
        if pCurrency = '' then
            exit('PEN')
        ELSE
            exit(pCurrency);
    end;

    local procedure fnGetCodeCountry(pCode: Code[20]): Text
    var
        lclRecCountryRegion: Record "Country/Region";
    begin
        if pCode = '' then
            exit(pCode);

        if lclRecCountryRegion.Get(pCode) then
            exit(lclRecCountryRegion."Cod. Sunat");
    end;

    var
        PurchRecordBuffer: Record "Purchase Record Buffer" temporary;
        SalesRecordBuffer: Record "Sales Record Buffer" temporary;
        GenJnlBookBuffer: Record "Gen. Journal Book Buffer" temporary;
        GLAccountBuffer: Record "G/L Account" temporary;
        SLSetup: Record "Setup Localization";
        StartDate: Date;
        EndDate: Date;
        BookCode: Code[10];
        NotRequestDate: Boolean;
        Windows: Dialog;
        ConstrutOutStream: OutStream;
        LegalDocMgt: Codeunit "Legal Document Management";
        TempFileBlob: Codeunit "Temp Blob";
        CheckDateExistsMessage: Label 'Enter Start Date and End Date to continue.', Comment = 'ESM="Ingrese la fecha de inicio y fin para continuar."';
        ErrorSelectedDate: Label 'You can only generate the Electronic Book for one period at a time.', Comment = 'ESM="Solo puede generar un libro electrónico por periodo"';
        Processing: Label 'Processing  #1#######################\', Comment = 'ESM="Procesando  #1#######################\"';
        CreatingFile: Label 'CreatingFile  #2#######################\', Comment = 'ESM="Creando archivo  #2#######################\"';
        gTemporalPurchSalesRec: Record "Purchases / Sales Records";
        gPurchasesSalesRecordsAux: Record "Purchases / Sales Records";
        recItemLedgerEntry: Record "Item Ledger Entry";
        gCant: Integer;
        gCounter: Integer;
        gMes: Integer;
        gPeriodo: Integer;
        gSumTotal: Decimal;
        gSumEnero: Decimal;
        gSumFebrero: Decimal;
        gSumMarzo: Decimal;
        gSumAbril: Decimal;
        gSumMayo: Decimal;
        gSumJunio: Decimal;
        gSumJulio: Decimal;
        gSumAgosto: Decimal;
        gSumSeptiembre: Decimal;
        gSumOctubre: Decimal;
        gSumNoviembre: Decimal;
        gSumDiciembre: Decimal;
}