report 51024 "Input Voucher"
{
    // version NAVW11.00,ULNLPE.v1

    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Input Voucher.rdl';
    Caption = 'Input voucher', Comment = 'ESM="Comprobante de Ingreso"';

    dataset
    {
        dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
        {
            column(Picture_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(NombreCIA; CompanyInformation.Name)
            {
            }
            column(VATCIA; CompanyInformation."VAT Registration No.")
            {
            }
            column(PostingDate_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(CurrencyCode_BankAccountLedgerEntry; glCurrencyCode)
            {
            }
            column(DocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(Amount_BankAccountLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }
            column(glTextAmount; glTextAmount)
            {
            }
            column(RelationalExchRateAmount_CurrencyExchangeRate; CurrencyExchangeRate."Relational Exch. Rate Amount")
            {
            }
            column(Name_BankAccount; BankAccount.Name)
            {
            }
            column(BankAccountNo_BankAccount; BankAccount."Bank Account No.")
            {
            }
            column(Beneficiario_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(Description_BankAccountLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(ExternalDocumentNo_BankAccountLedgerEntry; "Bank Account Ledger Entry"."External Document No.")
            {
            }
            column(Reversed_BankAccountLedgerEntry; "Bank Account Ledger Entry".Reversed)
            {
            }
            dataitem(VoucherBuffer; "Voucher Buffer")
            {
                UseTemporary = true;
                column(Text1_GlobalVoucherBuffer; VoucherBuffer.Text1)
                {
                }
                column(Text2_GlobalVoucherBuffer; VoucherBuffer.Text2)
                {
                }
                column(Text3_GlobalVoucherBuffer; VoucherBuffer.Text3)
                {
                }
                column(Text4_GlobalVoucherBuffer; VoucherBuffer.Text4)
                {
                }
                column(Text5_GlobalVoucherBuffer; VoucherBuffer.Text5)
                {
                }
                column(Text6_GlobalVoucherBuffer; VoucherBuffer.Text6)
                {
                }
                column(Decimal1_GlobalVoucherBuffer; VoucherBuffer.Decimal1)
                {
                }
                column(Decimal2_GlobalVoucherBuffer; VoucherBuffer.Decimal2)
                {
                }
                column(Integer1_GlobalVoucherBuffer; VoucherBuffer.Integer1)
                {
                }
                column(Text7_GlobalVoucherBuffer; VoucherBuffer.Text7)
                {
                }

                trigger OnPreDataItem();
                begin
                    VoucherBuffer.SETRANGE("Book Code", BookCode);
                    VoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);

                glTextAmount := '';
                AmountInLetters.FormatNoText(TextArray, ABS("Bank Account Ledger Entry".Amount));

                glTextAmount := TextArray[1];

                if ABS("Bank Account Ledger Entry".Amount) = 1000 then
                    glTextAmount := 'UN' + TextArray[1];

                AmountInLetters.FormatNoText2(glDecimalText, ABS("Bank Account Ledger Entry".Amount));
                glTextAmount += glDecimalText;

                if "Bank Account Ledger Entry"."Currency Code" = '' then begin
                    glCurrencyCode := 'S/';
                    glTextAmount += ' SOLES';
                    CurrencyExchangeRate.RESET;
                    CurrencyExchangeRate.SETRANGE("Currency Code", 'USD');
                    CurrencyExchangeRate.SETRANGE("Starting Date", "Bank Account Ledger Entry"."Posting Date");
                    CurrencyExchangeRate.FINDSET;
                end else begin
                    glCurrencyCode := "Bank Account Ledger Entry"."Currency Code";
                    Currency.GET("Bank Account Ledger Entry"."Currency Code");
                    glTextAmount += ' ' + Currency.Description;
                    CurrencyExchangeRate.RESET;
                    CurrencyExchangeRate.SETRANGE("Currency Code", "Bank Account Ledger Entry"."Currency Code");
                    CurrencyExchangeRate.SETRANGE("Starting Date", "Bank Account Ledger Entry"."Posting Date");
                    CurrencyExchangeRate.FINDSET;
                end;

                CheckLedgerEntry.RESET;
                CheckLedgerEntry.SETRANGE("Check No.", "Bank Account Ledger Entry"."Document No.");
                if CheckLedgerEntry.FINDSET then
                    glCheckNo := CheckLedgerEntry."Check No.";

                BankAccount.GET("Bank Account Ledger Entry"."Bank Account No.");

                glTalonarioNo := '';
                /*CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
                CustLedgerEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
                CustLedgerEntry.SETFILTER("Serie Talonario", '<>%1', '');
                CustLedgerEntry.SETFILTER("N° Talonario", '<>%1', '');
                if CustLedgerEntry.FINDSET then
                    glTalonarioNo := CustLedgerEntry."Serie Talonario" + '-' + CustLedgerEntry."N° Talonario";*/

                Counter := 0;
                glAppliedDocument := false;
                fnAddClosedCustomerLedgerEntries;
                fnAddOpenCustomerLedgerEntries;
                fnAddClosedVendorLedgerEntries;
                fnAddOpenVendorLedgerEntries;
                fnAddClosedEmployeeLedgerEntries;
                fnAddOpenEmployeeLedgerEntries;
                fnAddGLEntries;
                fnAddRetention;
                fnAddBankLedgerEntry;
            end;

            trigger OnPostDataItem();
            begin
                CLEAR(GlobalVoucherBuffer);

                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
                GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
                GlobalVoucherBuffer.DELETEALL;

                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB25');
                GlobalVoucherBuffer.DELETEALL;

                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB21');
                GlobalVoucherBuffer.DELETEALL;

                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB5222');
                GlobalVoucherBuffer.DELETEALL;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        GlobalVoucherBuffer: Record "Voucher Buffer";
        Counter: Integer;
        RetentionDetailedList: Record "Detailed Retention Ledg. Entry";
        BookCode: Label 'REP50164';
        Vendor: Record Vendor;
        CompanyInformation: Record "Company Information";
        CheckLedgerEntry: Record "Check Ledger Entry";
        glCurrencyCode: Text;
        glCheckNo: Code[20];
        glTextAmount: Text;
        AmountInLetters: Codeunit "Amount in letters";
        TextArray: array[10] of Text;
        glDecimalText: Text;
        Currency: Record Currency;
        CurrencyExchangeRate: Record "Currency Exchange Rate";
        BankAccount: Record "Bank Account";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        glAppliedDocument: Boolean;
        glInteger: Integer;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        Customer: Record Customer;
        glTalonarioNo: Text[50];
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLEntry: Record "G/L Entry";
        SourceCode: Record "Source Code";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        Employee: Record Employee;
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        EmployeePostingGroup: Record "Employee Posting Group";
        BankAccountPostingGroup: Record "Bank Account Posting Group";

    local procedure fnAddClosedVendorLedgerEntries();
    begin
        glAppliedDocument := false;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if VendorLedgerEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer."Book Code" := 'TAB25';
                GlobalVoucherBuffer.Key := FORMAT(VendorLedgerEntry."Entry No.");
                GlobalVoucherBuffer.INSERT;
            until VendorLedgerEntry.NEXT = 0;

        DetailedVendorLedgEntry.RESET;
        DetailedVendorLedgEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if DetailedVendorLedgEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB25');
                GlobalVoucherBuffer.SETRANGE(Key, FORMAT(DetailedVendorLedgEntry."Vendor Ledger Entry No."));
                if not GlobalVoucherBuffer.FINDSET then begin
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Entry No.", DetailedVendorLedgEntry."Vendor Ledger Entry No.");
                    VendorLedgerEntry.SETRANGE("Legal Status", VendorLedgerEntry."Legal Status"::Success);
                    VendorLedgerEntry.SETAUTOCALCFIELDS(Amount);
                    if VendorLedgerEntry.FINDSET then begin
                        glAppliedDocument := true;
                        Vendor.GET(VendorLedgerEntry."Vendor No.");
                        VendorPostingGroup.GET(VendorLedgerEntry."Vendor Posting Group");
                        fnInsertGlobalVoucherBufferLine(Vendor."No.",
                          Vendor.Name,
                          '',
                          VendorLedgerEntry."External Document No.",
                          fnGetCurrencyCode(VendorLedgerEntry."Currency Code"),
                          ABS(VendorLedgerEntry.Amount),
                          DetailedVendorLedgEntry.Amount,
                          0, false,
                          VendorPostingGroup."Payables Account");
                    end;
                end;
            until DetailedVendorLedgEntry.NEXT = 0;
    end;

    local procedure fnAddOpenVendorLedgerEntries();
    begin
        if not glAppliedDocument then begin
            VendorLedgerEntry.RESET;
            VendorLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            VendorLedgerEntry.SETRANGE("Legal Status", VendorLedgerEntry."Legal Status"::Success);
            VendorLedgerEntry.SETAUTOCALCFIELDS(Amount);
            if VendorLedgerEntry.FINDSET then
                repeat
                    Vendor.GET(VendorLedgerEntry."Vendor No.");
                    VendorPostingGroup.GET(VendorLedgerEntry."Vendor Posting Group");
                    fnInsertGlobalVoucherBufferLine(Vendor."No.",
                      Vendor.Name,
                      '',
                      VendorLedgerEntry."External Document No.",
                      fnGetCurrencyCode(VendorLedgerEntry."Currency Code"),
                      ABS(VendorLedgerEntry.Amount),
                      ABS(VendorLedgerEntry.Amount),
                      0,
                      true,
                      VendorPostingGroup."Payables Account");
                until VendorLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnAddClosedCustomerLedgerEntries();
    begin
        glAppliedDocument := false;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if CustLedgerEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer."Book Code" := 'TAB21';
                GlobalVoucherBuffer.Key := FORMAT(CustLedgerEntry."Entry No.");
                GlobalVoucherBuffer.INSERT;
            until CustLedgerEntry.NEXT = 0;

        DetailedCustLedgEntry.RESET;
        DetailedCustLedgEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if DetailedCustLedgEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB21');
                GlobalVoucherBuffer.SETRANGE(Key, FORMAT(DetailedCustLedgEntry."Cust. Ledger Entry No."));
                if not GlobalVoucherBuffer.FINDSET then begin
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Entry No.", DetailedCustLedgEntry."Cust. Ledger Entry No.");
                    CustLedgerEntry.SETRANGE("Legal Status", CustLedgerEntry."Legal Status"::Success);
                    CustLedgerEntry.SETAUTOCALCFIELDS(Amount);
                    if CustLedgerEntry.FINDSET then begin
                        glAppliedDocument := true;
                        Customer.GET(CustLedgerEntry."Customer No.");
                        CustomerPostingGroup.GET(CustLedgerEntry."Customer Posting Group");
                        fnInsertGlobalVoucherBufferLine(Customer."No.",
                          Customer.Name,
                          '',//CustLedgerEntry."Promissory Doc No.",
                          CustLedgerEntry."Document No.",
                          fnGetCurrencyCode(CustLedgerEntry."Currency Code"),
                          CustLedgerEntry.Amount * -1,
                          DetailedCustLedgEntry.Amount,
                          0,
                          false,
                          CustomerPostingGroup."Receivables Account");
                    end;
                end;
            until DetailedCustLedgEntry.NEXT = 0;
    end;

    local procedure fnAddOpenCustomerLedgerEntries();
    begin
        if not glAppliedDocument then begin
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            CustLedgerEntry.SETRANGE("Legal Status", CustLedgerEntry."Legal Status"::Success);
            CustLedgerEntry.SETAUTOCALCFIELDS(Amount);
            if CustLedgerEntry.FINDSET then
                repeat
                    Customer.GET(CustLedgerEntry."Customer No.");
                    CustomerPostingGroup.GET(CustLedgerEntry."Customer Posting Group");
                    fnInsertGlobalVoucherBufferLine(Customer."No.",
                      Customer.Name,
                      '',//CustLedgerEntry."Promissory Doc No.",
                      CustLedgerEntry."Document No.",
                      fnGetCurrencyCode(CustLedgerEntry."Currency Code"),
                      CustLedgerEntry.Amount * -1,
                      CustLedgerEntry.Amount * -1,
                      0,
                      true,
                      CustomerPostingGroup."Receivables Account");
                until CustLedgerEntry.NEXT = 0;
        end else begin
            CustLedgerEntry.RESET;
            CustLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            CustLedgerEntry.SETFILTER("Remaining Amount", '<>%1', 0);
            CustLedgerEntry.SETRANGE("Legal Status", CustLedgerEntry."Legal Status"::Success);
            CustLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");
            if CustLedgerEntry.FINDSET then
                repeat
                    Customer.GET(CustLedgerEntry."Customer No.");
                    CustomerPostingGroup.GET(CustLedgerEntry."Customer Posting Group");
                    fnInsertGlobalVoucherBufferLine(Customer."No.",
                      Customer.Name,
                      '',//CustLedgerEntry."Promissory Doc No.",
                      'PENDIENTE',
                      fnGetCurrencyCode(CustLedgerEntry."Currency Code"),
                      CustLedgerEntry."Remaining Amount",
                      CustLedgerEntry."Remaining Amount",
                      0,
                      true,
                      CustomerPostingGroup."Receivables Account");
                until CustLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnAddClosedEmployeeLedgerEntries();
    begin
        glAppliedDocument := false;
        EmployeeLedgerEntry.RESET;
        EmployeeLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if EmployeeLedgerEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer."Book Code" := 'TAB5222';
                GlobalVoucherBuffer.Key := FORMAT(EmployeeLedgerEntry."Entry No.");
                GlobalVoucherBuffer.INSERT;
            until EmployeeLedgerEntry.NEXT = 0;

        DetailedEmployeeLedgerEntry.RESET;
        DetailedEmployeeLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if DetailedEmployeeLedgerEntry.FINDSET then
            repeat
                CLEAR(GlobalVoucherBuffer);
                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", 'TAB5222');
                GlobalVoucherBuffer.SETRANGE(Key, FORMAT(DetailedEmployeeLedgerEntry."Employee Ledger Entry No."));
                if not GlobalVoucherBuffer.FINDSET then begin
                    EmployeeLedgerEntry.RESET;
                    EmployeeLedgerEntry.SETRANGE("Entry No.", DetailedEmployeeLedgerEntry."Employee Ledger Entry No.");
                    EmployeeLedgerEntry.SETAUTOCALCFIELDS(Amount);
                    if EmployeeLedgerEntry.FINDSET then begin
                        glAppliedDocument := true;
                        Employee.GET(EmployeeLedgerEntry."Employee No.");
                        EmployeePostingGroup.GET(Employee."Employee Posting Group");
                        fnInsertGlobalVoucherBufferLine(Employee."No.",
                          Employee."First Name" + ' ' + Employee."Last Name",
                          EmployeeLedgerEntry."External Document No.",
                          EmployeeLedgerEntry."Document No.",
                          fnGetCurrencyCode(EmployeeLedgerEntry."Currency Code"),
                          EmployeeLedgerEntry.Amount * -1,
                          DetailedEmployeeLedgerEntry.Amount,
                          0,
                          false,
                          EmployeePostingGroup."Payables Account");
                    end;
                end;
            until DetailedEmployeeLedgerEntry.NEXT = 0;
    end;

    local procedure fnAddOpenEmployeeLedgerEntries();
    begin
        if not glAppliedDocument then begin
            EmployeeLedgerEntry.RESET;
            EmployeeLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            EmployeeLedgerEntry.SETAUTOCALCFIELDS(Amount);
            if EmployeeLedgerEntry.FINDSET then
                repeat
                    Employee.GET(EmployeeLedgerEntry."Employee No.");
                    EmployeePostingGroup.GET(EmployeeLedgerEntry."Employee Posting Group");
                    fnInsertGlobalVoucherBufferLine(Employee."No.",
                      Employee."First Name" + ' ' + Employee."Last Name",
                      EmployeeLedgerEntry."External Document No.",
                      EmployeeLedgerEntry."Document No.",
                      fnGetCurrencyCode(EmployeeLedgerEntry."Currency Code"),
                      EmployeeLedgerEntry.Amount * -1,
                      EmployeeLedgerEntry.Amount * -1,
                      0,
                      true,
                      EmployeePostingGroup."Payables Account");
                until EmployeeLedgerEntry.NEXT = 0;
        end else begin
            EmployeeLedgerEntry.RESET;
            EmployeeLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            EmployeeLedgerEntry.SETFILTER("Remaining Amount", '<>%1', 0);
            EmployeeLedgerEntry.SETAUTOCALCFIELDS("Remaining Amount");
            if EmployeeLedgerEntry.FINDSET then
                repeat
                    Employee.GET(EmployeeLedgerEntry."Employee No.");
                    EmployeePostingGroup.GET(Employee."Employee Posting Group");
                    fnInsertGlobalVoucherBufferLine(Employee."No.",
                      Employee."First Name" + ' ' + Employee."Last Name",
                      EmployeeLedgerEntry."External Document No.",
                      'PENDIENTE',
                      fnGetCurrencyCode(EmployeeLedgerEntry."Currency Code"),
                      EmployeeLedgerEntry."Remaining Amount",
                      EmployeeLedgerEntry."Remaining Amount",
                      0,
                      true,
                      EmployeePostingGroup."Payables Account");
                until EmployeeLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnAddGLEntries();
    var
        lcAmount: Decimal;
    begin
        BankAccountLedgerEntry.RESET;
        BankAccountLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        CLEAR(GlobalVoucherBuffer);
        GlobalVoucherBuffer.RESET;
        GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
        if (GlobalVoucherBuffer.COUNT = 0) and (BankAccountLedgerEntry.COUNT = 1) then begin
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
            GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
            GLEntry.SETRANGE("Analityc Entry", false);
            if GLEntry.FINDFIRST then begin
                if "Bank Account Ledger Entry"."Currency Code" = '' then
                    lcAmount := GLEntry.Amount
                else begin
                    lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
                end;
                fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
                  GLEntry.Description,
                  '',
                  GLEntry."Document No.",
                  glCurrencyCode,
                  ABS(lcAmount),
                  lcAmount,
                  0,
                  false, GLEntry."G/L Account No.");
            end;
        end;

        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
        GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
        GLEntry.SETRANGE("Analityc Entry", false);
        GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::" ");
        GLEntry.SETFILTER("G/L Account No.", '<>%1', '401141');
        if GLEntry.FINDFIRST then begin
            if "Bank Account Ledger Entry"."Currency Code" = '' then
                lcAmount := GLEntry.Amount
            else begin
                lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
            end;
            fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
              GLEntry.Description,
              '',
              GLEntry."Document No.",
              glCurrencyCode,
              ABS(lcAmount),
              lcAmount,
              0,
              false, GLEntry."G/L Account No.");
        end;
    end;

    local procedure fnAddRetention();
    begin
        RetentionDetailedList.RESET;
        RetentionDetailedList.SETRANGE("Retention No.", "Bank Account Ledger Entry"."Document No.");
        RetentionDetailedList.SETRANGE(Reversed, false);
        if RetentionDetailedList.FINDSET then begin
            RetentionDetailedList.CALCSUMS("Amount Retention LCY");
            fnInsertGlobalVoucherBufferLine(RetentionDetailedList."Vendor No.",
              fnGetVendorName_VatNo(RetentionDetailedList."Vendor No."),
              '',
              RetentionDetailedList."Retention No.",
              glCurrencyCode,
              RetentionDetailedList."Amount Retention LCY",
              RetentionDetailedList."Amount Retention LCY",
              0,
              false, '');
        end;
    end;

    local procedure fnAddBankLedgerEntry();
    var
        lcCounter: Integer;
    begin
        Counter += 1;
        lcCounter := 0;
        BankAccountLedgerEntry.RESET;
        BankAccountLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if BankAccountLedgerEntry.FINDSET then
            repeat
                lcCounter += 1;
                if "Bank Account Ledger Entry".Reversed and (lcCounter > 1) then
                    exit;
                BankAccountPostingGroup.GET(BankAccountLedgerEntry."Bank Acc. Posting Group");
                fnInsertGlobalVoucherBufferLine(BankAccountLedgerEntry."Bank Account No.",
                  BankAccountLedgerEntry.Description,//Beneficiario
                  '',
                  BankAccountLedgerEntry."External Document No.",
                  glCurrencyCode,
                  BankAccountLedgerEntry.Amount,
                  BankAccountLedgerEntry.Amount,
                  1,
                  true, BankAccountPostingGroup."G/L Bank Account No.");
            until BankAccountLedgerEntry.NEXT = 0;
    end;

    local procedure fnInsertGlobalVoucherBufferLine(pText1: Text[100]; pText2: Text[100]; pText3: Text[100]; pText5: Text[100]; pText6: Text[100]; pDecimal1: Decimal; pDecimal2: Decimal; pInteger1: Integer; pForceInsertion: Boolean; pText7: Text[100]);
    begin
        CLEAR(GlobalVoucherBuffer);
        GlobalVoucherBuffer.RESET;
        GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
        GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
        GlobalVoucherBuffer.SETRANGE(Text1, pText1);
        GlobalVoucherBuffer.SETRANGE(Text5, pText5);
        if GlobalVoucherBuffer.FINDSET and (not pForceInsertion or "Bank Account Ledger Entry".Reversed) then
            exit;

        Counter += 1;
        CLEAR(GlobalVoucherBuffer);
        GlobalVoucherBuffer.INIT;
        GlobalVoucherBuffer."Book Code" := BookCode;
        GlobalVoucherBuffer.Key := FORMAT("Bank Account Ledger Entry"."Entry No.") + '-' + FORMAT(Counter);
        GlobalVoucherBuffer.Text1 := pText1;
        GlobalVoucherBuffer.Text2 := pText2;
        GlobalVoucherBuffer.Text3 := pText3;
        GlobalVoucherBuffer.Text4 := glTalonarioNo;
        GlobalVoucherBuffer.Text5 := pText5;
        GlobalVoucherBuffer.Text6 := pText6;
        GlobalVoucherBuffer.Decimal1 := pDecimal1;
        GlobalVoucherBuffer.Decimal2 := pDecimal2;
        GlobalVoucherBuffer.Integer1 := pInteger1;
        GlobalVoucherBuffer.Text7 := pText7;
        GlobalVoucherBuffer.INSERT;
    end;

    local procedure fnGetVendorName_VatNo(pVatNo: Text[20]): Text;
    begin
        Vendor.RESET;
        Vendor.SETRANGE("VAT Registration No.", pVatNo);
        if Vendor.FINDSET then
            exit(Vendor.Name);
        exit('');
    end;

    local procedure fnGetCurrencyCode(pCurrencyCode: Text): Text[100];
    begin
        if pCurrencyCode = '' then
            exit('S/');
        exit(pCurrencyCode);
    end;
}

