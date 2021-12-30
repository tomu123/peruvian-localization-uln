report 51023 "Output Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Output Voucher.rdl';

    Caption = 'Output voucher', comment = 'ESM="Comprobante de Egreso"';

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
            column(PostingDate_BankAccLedgerEntry; "Bank Account Ledger Entry"."Posting Date")
            {
            }
            column(DocumentNo_BankAccLedgerEntry; "Bank Account Ledger Entry"."Document No.")
            {
            }
            column(CurrencyCode_BankAccLedgerEntry; glCurrencyCode)
            {
            }
            column(Amount_BankAccLedgerEntry; "Bank Account Ledger Entry".Amount)
            {
            }
            column(glCheckNo; glCheckNo)
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
            column(Beneficiario_BankAccLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column(Description_BankAccLedgerEntry; "Bank Account Ledger Entry".Description)
            {
            }
            column("Count"; gCount)
            {
            }
            column(Reversed_BankAccLedgerEntry; "Bank Account Ledger Entry".Reversed)
            {
            }
            dataitem(VoucherBuffer; "Voucher Buffer")
            {
                UseTemporary = true;
                column(ImporteTotal; gImporteTotal)
                {
                }
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
                column(Decimal1_GlobalVoucherBuffer; VoucherBuffer.Decimal1)
                {
                }
                column(Decimal2_GlobalVoucherBuffer; VoucherBuffer.Decimal2)
                {
                }
                column(Text5_GlobalVoucherBuffer; VoucherBuffer.Text5)
                {
                }
                column(Integer1_GlobalVoucherBuffer; VoucherBuffer.Integer1)
                {
                }
                column(Text7_GlobalVoucherBuffer; VoucherBuffer.Text7)
                {
                }
                column(CurrencyCode2; glCurrencyCode2)
                {
                }
                column(TextAmount2; glTextAmount2)
                {
                }
                column(gMoneda; gMoneda)
                {
                }

                trigger OnAfterGetRecord();
                var
                    lcrecBankAccount: Record "Bank Account";
                begin

                    if (VoucherBuffer.Integer1 = 1) and (VoucherBuffer.Decimal2 < 0) then begin
                        gImporteTotal += ABS(VoucherBuffer.Decimal2);
                        glCurrencyCode2 := gSinboloMoneda + ' ' + FORMAT(gImporteTotal);

                        glTextAmount2 := '';
                        AmountInLetters.FormatNoText(TextArray, ABS(gImporteTotal));

                        glTextAmount2 := TextArray[1];

                        if ABS(gImporteTotal) = 1000 then
                            glTextAmount2 := 'UN' + TextArray[1];

                        AmountInLetters.FormatNoText2(glDecimalText, ABS(gImporteTotal));
                        glTextAmount2 += glDecimalText;

                        glTextAmount2 += ' ' + glTextAmountSimbolo2;
                    end;

                    lcrecBankAccount.RESET;
                    lcrecBankAccount.SETRANGE("No.", VoucherBuffer.Text1);
                    if lcrecBankAccount.FINDFIRST then begin
                        case lcrecBankAccount."Currency Code" of
                            '':
                                gMoneda := 'S/';
                            'USD':
                                gMoneda := 'USD';
                        end;
                    end;
                    //= Iif(Fields!Integer1_GlobalVoucherBuffer.Value = 1 and Fields!Decimal2_GlobalVoucherBuffer.Value<0, "LightGrey", "No Color")
                end;

                trigger OnPostDataItem();
                begin
                    //BEGIN ULN::RHF 001 20190614(++)
                    "Bank Account Ledger Entry".SETFILTER("Document No.", '<>%1', "Bank Account Ledger Entry"."Document No.");
                    //BEGIN ULN::RHF 001 20190614(++)
                end;

                trigger OnPreDataItem();
                begin
                    VoucherBuffer.SETRANGE("Book Code", BookCode);
                    VoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
                    gCountMov := VoucherBuffer.COUNT();

                    gImporteTotal := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);

                gCount += 1;
                gImporteTotal += ABS("Bank Account Ledger Entry".Amount);

                glTextAmount := '';
                AmountInLetters.FormatNoText(TextArray, ABS("Bank Account Ledger Entry".Amount));

                glTextAmount := TextArray[1];

                if ABS("Bank Account Ledger Entry".Amount) = 1000 then
                    glTextAmount := 'UN' + TextArray[1];

                AmountInLetters.FormatNoText2(glDecimalText, ABS("Bank Account Ledger Entry".Amount));
                glTextAmount += glDecimalText;

                if "Bank Account Ledger Entry"."Currency Code" = '' then begin
                    glCurrencyCode := 'S/';
                    gSinboloMoneda := 'S/';

                    glTextAmount += ' SOLES';
                    glTextAmountSimbolo2 := ' SOLES';

                    CurrencyExchangeRate.RESET;
                    CurrencyExchangeRate.SETRANGE("Currency Code", 'USD');
                    CurrencyExchangeRate.SETRANGE("Starting Date", "Bank Account Ledger Entry"."Posting Date");
                    CurrencyExchangeRate.FINDSET;
                end else begin
                    glCurrencyCode := "Bank Account Ledger Entry"."Currency Code";
                    gSinboloMoneda := "Bank Account Ledger Entry"."Currency Code";
                    Currency.GET("Bank Account Ledger Entry"."Currency Code");

                    glTextAmount += ' ' + Currency.Description;
                    glTextAmountSimbolo2 := Currency.Description;

                    CurrencyExchangeRate.RESET;
                    CurrencyExchangeRate.SETRANGE("Currency Code", "Bank Account Ledger Entry"."Currency Code");
                    CurrencyExchangeRate.SETRANGE("Starting Date", "Bank Account Ledger Entry"."Posting Date");
                    CurrencyExchangeRate.FINDSET;
                end;

                CheckLedgerEntry.RESET;
                CheckLedgerEntry.SETRANGE("Check No.", "Bank Account Ledger Entry"."Document No.");
                if CheckLedgerEntry.FINDSET then
                    glCheckNo := CheckLedgerEntry."Check No.";

                //BEGIN ULN::RHF 001 20190614(++)
                grecBankAccLedEntry.RESET;
                grecBankAccLedEntry.SETRANGE("Document No.", "Document No.");
                gCountMov := grecBankAccLedEntry.COUNT();
                if gCountMov > 1 then begin
                    grecBankAccLedEntry.SETFILTER(Amount, '<%1', 0);
                    if grecBankAccLedEntry.FINDSET then begin
                        BankAccount.GET(grecBankAccLedEntry."Bank Account No.");
                    end;
                end else begin
                    //END ULN::RHF 001 20190614(++)

                    BankAccount.GET("Bank Account Ledger Entry"."Bank Account No.");
                end;




                GlobalVoucherBuffer.RESET;
                GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
                GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
                GlobalVoucherBuffer.DELETEALL;

                Counter := 0;
                glAppliedDocument := false;
                //1
                fnAddClosedVendorLedgerEntries;
                //2
                fnAddOpenVendorLedgerEntries;
                //3
                fnAddClosedCustomerLedgerEntries;
                //4
                fnAddOpenCustomerLedgerEntries;
                //5
                fnAddClosedEmployeeLegerEntries;
                //6
                fnAddOpenEmployeeLedgerEntries;
                //7
                fnAddRetention;
                //8
                fnAddGLEntries;
                //9
                fnAddBankLedgerEntries;
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
        BookCode: Label 'REP50165';
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
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        GLEntry: Record "G/L Entry";
        SourceCode: Record "Source Code";
        EmployeeLedgerEntry: Record "Employee Ledger Entry";
        DetailedEmployeeLedgerEntry: Record "Detailed Employee Ledger Entry";
        Employee: Record Employee;
        CustomerPostingGroup: Record "Customer Posting Group";
        VendorPostingGroup: Record "Vendor Posting Group";
        EmployeePostingGroup: Record "Employee Posting Group";
        BankAccountPostingGroup: Record "Bank Account Posting Group";
        grecBankAccLedEntry: Record "Bank Account Ledger Entry";
        gCountMov: Integer;
        gNroMov: Code[10];
        "---New---": Integer;
        gImporteTotal: Decimal;
        gCount: Integer;
        glCurrencyCode2: Text;
        gSinboloMoneda: Text;
        glTextAmount2: Text;
        glTextAmountSimbolo2: Text;
        gMoneda: Text;

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
        DetailedVendorLedgEntry.SETFILTER(Amount, '<>%1', 0);
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

                        if VendorLedgerEntry."External Document No." = '' then
                            VendorLedgerEntry."External Document No." := "Bank Account Ledger Entry"."Document No.";

                        fnInsertGlobalVoucherBufferLine(Vendor."No.",
                                                 Vendor.Name,
                                                 VendorLedgerEntry."External Document No.",
                                                 fnGetCurrencyCode(VendorLedgerEntry."Currency Code"),
                                                 ABS(VendorLedgerEntry.Amount),
                                                 DetailedVendorLedgEntry.Amount,
                                                 VendorLedgerEntry."Document No.",
                                                 0, false, VendorLedgerEntry."Legal Document",
                                                 VendorPostingGroup."Payables Account"
                                                 );
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
                                              VendorLedgerEntry."External Document No.",
                                              fnGetCurrencyCode(VendorLedgerEntry."Currency Code"),
                                              ABS(VendorLedgerEntry.Amount),
                                              ABS(VendorLedgerEntry.Amount),
                                              VendorLedgerEntry."Document No.",
                                              0,
                                              true, VendorLedgerEntry."Legal Document",
                                              VendorPostingGroup."Payables Account"
                                             );
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
        DetailedCustLedgEntry.SETFILTER(Amount, '<>%1', 0);
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

                        if CustLedgerEntry."External Document No." = '' then
                            CustLedgerEntry."External Document No." := "Bank Account Ledger Entry"."Document No.";

                        CustomerPostingGroup.GET(CustLedgerEntry."Customer Posting Group");

                        fnInsertGlobalVoucherBufferLine(Customer."No.",
                                                 Customer.Name,
                                                 CustLedgerEntry."Document No.",
                                                 fnGetCurrencyCode(CustLedgerEntry."Currency Code"),
                                                 ABS(CustLedgerEntry.Amount),
                                                 DetailedCustLedgEntry.Amount,
                                                 CustLedgerEntry."External Document No.",
                                                 0, false, CustLedgerEntry."Legal Document",
                                                 CustomerPostingGroup."Receivables Account"
                                                );
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
                                              CustLedgerEntry."Document No.",
                                              fnGetCurrencyCode(CustLedgerEntry."Currency Code"),
                                              ABS(CustLedgerEntry.Amount),
                                              ABS(CustLedgerEntry.Amount),
                                              CustLedgerEntry."External Document No.",
                                              0,
                                              true, CustLedgerEntry."Legal Document",
                                              CustomerPostingGroup."Receivables Account"
                                             );
                until CustLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnAddClosedEmployeeLegerEntries();
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
        DetailedEmployeeLedgerEntry.SETFILTER(Amount, '<>%1', 0);
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
                        if EmployeeLedgerEntry."External Document No." = '' then
                            EmployeeLedgerEntry."External Document No." := "Bank Account Ledger Entry"."Document No.";

                        //--
                        EmployeePostingGroup.GET(EmployeeLedgerEntry."Employee Posting Group");

                        fnInsertGlobalVoucherBufferLine(Employee."No.",
                                                 Employee."First Name" + ' ' + Employee."Last Name",
                                                 EmployeeLedgerEntry."Document No.",
                                                 fnGetCurrencyCode(EmployeeLedgerEntry."Currency Code"),
                                                 ABS(EmployeeLedgerEntry.Amount),
                                                 DetailedEmployeeLedgerEntry.Amount,
                                                 EmployeeLedgerEntry."External Document No.",
                                                 0, false, '',
                                                 EmployeePostingGroup."Payables Account"
                                                );
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
                                             EmployeeLedgerEntry."Document No.",
                                             fnGetCurrencyCode(EmployeeLedgerEntry."Currency Code"),
                                             ABS(EmployeeLedgerEntry.Amount),
                                             ABS(EmployeeLedgerEntry.Amount),
                                             EmployeeLedgerEntry."External Document No.",
                                             0,
                                             true, '',
                                             EmployeePostingGroup."Payables Account"
                                            );
                until EmployeeLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnAddRetention();
    var
        lclCant: Integer;
    begin
        RetentionDetailedList.RESET;
        RetentionDetailedList.SETRANGE("Retention No.", "Bank Account Ledger Entry"."Document No.");
        RetentionDetailedList.SETRANGE(Reversed, false);
        lclCant := RetentionDetailedList.COUNT;
        if RetentionDetailedList.FINDSET then
            repeat
                //RetentionDetailedList.CALCSUMS("Amount Retenida (LCY)");

                fnInsertGlobalVoucherBufferLine(RetentionDetailedList."Vendor No.",
                                          fnGetVendorName_VatNo(RetentionDetailedList."Vendor No."),
                                          RetentionDetailedList."Retention No.",
                                          glCurrencyCode,
                                          RetentionDetailedList."Amount Retention LCY",
                                          RetentionDetailedList."Amount Retention LCY",
                                          RetentionDetailedList."Vendor External Document No.",
                                          0, true, '', '401141'
                                         );
            until RetentionDetailedList.NEXT = 0;
    end;

    local procedure fnAddGLEntries();
    var
        lcAmount: Decimal;
    begin
        BankAccLedgerEntry.RESET;
        BankAccLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        CLEAR(GlobalVoucherBuffer);
        GlobalVoucherBuffer.RESET;
        GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
        GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
        if (GlobalVoucherBuffer.COUNT = 0) and (BankAccLedgerEntry.COUNT = 1) then begin
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
            GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::" ");
            GLEntry.SETRANGE("System-Created Entry", false);
            GLEntry.SETRANGE("Analityc Entry", false);
            if GLEntry.FINDSET then
                repeat
                    if "Bank Account Ledger Entry"."Currency Code" = '' then
                        lcAmount := GLEntry.Amount
                    else begin
                        lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
                    end;

                    fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
                                             GLEntry.Description,
                                             GLEntry."Document No.",
                                             glCurrencyCode,
                                             ABS(lcAmount),
                                             lcAmount,
                                             GLEntry."Document No.",
                                             0,
                                             true, '', GLEntry."G/L Account No."
                                            );
                until GLEntry.NEXT = 0;

        end else begin
            //BEGIN ULN::RHF (++)
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
            GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::" ");
            GLEntry.SETRANGE("Analityc Entry", false);
            GLEntry.SETFILTER("G/L Account No.", '<>%1', '401141');
            if GLEntry.FINDFIRST then
                repeat
                    if "Bank Account Ledger Entry"."Currency Code" = '' then
                        lcAmount := GLEntry.Amount
                    else begin
                        lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
                    end;

                    fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
                                              GLEntry.Description,
                                              GLEntry."Document No.",
                                              glCurrencyCode,
                                              ABS(lcAmount),
                                              lcAmount,
                                              GLEntry."Document No.",
                                              0,
                                              true, '', GLEntry."G/L Account No." //FALSE, '', GLEntry."G/L Account No."
                                            );
                until GLEntry.NEXT = 0;
            //END ULN::RHF (++)
        end;

        //BEGIN (--)
        /*
        GLEntry.RESET;
        GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
        GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
        GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::" ");
        GLEntry.SETRANGE("Analityc Entry No.", FALSE);
        GLEntry.SETFILTER("G/L Account No.", '<>%1', '401141');
        IF GLEntry.FINDFIRST THEN
        REPEAT
            IF "Bank Account Ledger Entry"."Currency Code" = '' THEN
              lcAmount := GLEntry.Amount
            ELSE BEGIN
              lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
            END;
        
            fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
                                     GLEntry.Description,
                                     GLEntry."Document No.",
                                     glCurrencyCode,
                                     ABS(lcAmount),
                                     lcAmount,
                                     GLEntry."Document No.",
                                     0,
                                     TRUE, '', GLEntry."G/L Account No." //FALSE, '', GLEntry."G/L Account No."
                                    );
        UNTIL GLEntry.NEXT=0;
        */
        GlobalVoucherBuffer.RESET;
        GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
        GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
        if (GlobalVoucherBuffer.COUNT = 0) and (BankAccLedgerEntry.COUNT = 1) then begin
            GLEntry.RESET;
            GLEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
            GLEntry.SETRANGE("Posting Date", "Bank Account Ledger Entry"."Posting Date");
            GLEntry.SETRANGE("Transaction No.", "Bank Account Ledger Entry"."Transaction No.");
            GLEntry.SETRANGE("Source Type", GLEntry."Source Type"::"Bank Account");
            GLEntry.SETRANGE("Bal. Account Type", GLEntry."Bal. Account Type"::"Bank Account");
            GLEntry.SETRANGE("Analityc Entry", false);
            GLEntry.SETRANGE("System-Created Entry", false);
            if GLEntry.FINDSET then
                repeat
                    if "Bank Account Ledger Entry"."Currency Code" = '' then
                        lcAmount := GLEntry.Amount
                    else begin
                        lcAmount := GLEntry.Amount / CurrencyExchangeRate."Relational Adjmt Exch Rate Amt";
                    end;

                    fnInsertGlobalVoucherBufferLine(GLEntry."G/L Account No.",
                                             GLEntry.Description,
                                             GLEntry."Document No.",
                                             glCurrencyCode,
                                             ABS(lcAmount),
                                             lcAmount,
                                             GLEntry."Document No.",
                                             0,
                                             true, '', GLEntry."G/L Account No."
                                            );
                until GLEntry.NEXT = 0;
        end;

    end;

    local procedure fnAddBankLedgerEntries();
    var
        lcDocumentNo: Text[50];
    begin
        Counter += 1;
        BankAccLedgerEntry.RESET;
        BankAccLedgerEntry.SETRANGE("Document No.", "Bank Account Ledger Entry"."Document No.");
        if BankAccLedgerEntry.FINDSET then
            repeat
                SourceCode.RESET;
                SourceCode.SETRANGE(Code, BankAccLedgerEntry."Source Code");
                //SourceCode.SETFILTER("Input Output", '<>%1', SourceCode."Input Output"::" ");
                if SourceCode.FINDSET or (BankAccLedgerEntry."Entry No." = "Bank Account Ledger Entry"."Entry No.") then begin
                    lcDocumentNo := '';
                    if BankAccLedgerEntry.Amount > 0 then
                        lcDocumentNo := BankAccLedgerEntry."Document No.";

                    BankAccountPostingGroup.GET(BankAccLedgerEntry."Bank Acc. Posting Group");

                    fnInsertGlobalVoucherBufferLine(BankAccLedgerEntry."Bank Account No.",
                                             BankAccLedgerEntry.Description,//BankAccLedgerEntry.Beneficiario,
                                             BankAccLedgerEntry."External Document No.",
                                             glCurrencyCode,
                                             ABS(BankAccLedgerEntry.Amount),
                                             BankAccLedgerEntry.Amount,
                                             lcDocumentNo,
                                             1,
                                             true, '',
                                             BankAccountPostingGroup."G/L Bank Account No."
                                            );
                end;
            until BankAccLedgerEntry.NEXT = 0;
    end;

    local procedure fnInsertGlobalVoucherBufferLine(pText1: Text[100]; pText2: Text[100]; pText3: Text[100]; pText4: Text[100]; pDecimal1: Decimal; pDecimal2: Decimal; pText5: Text[100]; pInteger1: Integer; pForceInsertion: Boolean; pText6: Text[100]; pText7: Text[100]);
    begin
        if (pText3 = '') and not pForceInsertion then
            exit;

        CLEAR(GlobalVoucherBuffer);
        // GlobalVoucherBuffer.RESET;
        // GlobalVoucherBuffer.SETRANGE("Book Code", BookCode);
        // GlobalVoucherBuffer.SETFILTER(Key, '%1', FORMAT("Bank Account Ledger Entry"."Entry No.") + '-*');
        // GlobalVoucherBuffer.SETRANGE(Text1, pText1);
        // GlobalVoucherBuffer.SETRANGE(Text3, pText3);
        // GlobalVoucherBuffer.SETRANGE(Text5, pText5);
        // IF pText6 <> '' THEN
        //  GlobalVoucherBuffer.SETRANGE(Text6, pText6);
        //
        // IF GlobalVoucherBuffer.FINDSET AND (NOT pForceInsertion OR "Bank Account Ledger Entry".Reversed) THEN
        if ("Bank Account Ledger Entry".Reversed) then
            exit;

        Counter += 1;
        CLEAR(GlobalVoucherBuffer);
        GlobalVoucherBuffer.INIT;
        GlobalVoucherBuffer."Book Code" := BookCode;
        GlobalVoucherBuffer.Key := FORMAT("Bank Account Ledger Entry"."Entry No.") + '-' + FORMAT(Counter);
        GlobalVoucherBuffer.Text1 := pText1;
        GlobalVoucherBuffer.Text2 := pText2;
        GlobalVoucherBuffer.Text3 := pText3;
        GlobalVoucherBuffer.Text4 := pText4;
        GlobalVoucherBuffer.Decimal1 := pDecimal1;
        GlobalVoucherBuffer.Decimal2 := pDecimal2;
        GlobalVoucherBuffer.Text5 := pText5;
        GlobalVoucherBuffer.Integer1 := pInteger1;
        GlobalVoucherBuffer.Text6 := pText6;
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

