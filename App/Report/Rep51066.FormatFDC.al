report 51066 "Format FDC"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/FormatFDC.rdl';
    Caption = 'FLUJO CAJA HISTÓRICO', Comment = 'ESM="FLUJO CAJA HISTÓRICO"';
    UsageCategory = ReportsAndAnalysis;
    Permissions = tabledata "Employee Ledger Entry" = rim, tabledata "Vendor Ledger Entry" = rim, tabledata "G/L Entry" = rim;
    ApplicationArea = All;
    dataset
    {
        dataitem("Format FDC Setup"; "Format FDC Setup")
        {
            column(FDC_Orden; orden)
            {
            }
            column(FDC_SubOrden; "Sub Orden")
            {
            }
            column(FDC_Cat1; "Format FDC Setup"."Primary Category")
            {
            }
            column(FDC_Cat2; "Format FDC Setup"."Secondary category")
            {
            }

            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(FiltroFecha; format(FechaInicial) + '...' + Format(FechaFinal))
            {
            }
            column(SaldoInicial; SaldoInicial)
            {
            }
            column(SaldoFinal; SaldoFinal)
            {
            }

            dataitem(DateVirtual; Date)
            {
                DataItemTableView = SORTING("Period Start") ORDER(Ascending);
                column(ImporteFDC; ImporteFDC)
                {
                }
                column(PeriodoName; DateVirtual."Period Name")
                {
                }
                column(PeriodStart; DateVirtual."Period Start")
                {
                }
                column(PeriodEnd; DateVirtual."Period End")
                {
                }
                column(PeriodNo; DateVirtual."Period No.")
                {
                }

                trigger OnPreDataItem()
                begin
                    SetRange("Period Type", "Period Type"::Month);
                    SetRange("Period Start", FechaInicial, FechaFinal);
                    //SetRange("Period End", FechaFinal);

                end;

                trigger OnAfterGetRecord()
                begin
                    SaldoInicial := GetSaldoInicial();

                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Vendor then
                        InitVendorLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Customer then
                        InitCustomerLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Employee then
                        InitEmployeeLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::"Bank Account" then
                        InitBankLedgerEntry();



                    ImporteFDC := 0;

                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Vendor then
                        ImporteFDC := fnGetAmountVendorLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::" " then
                        ImporteFDC := fnGetAmountGLEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Employee then
                        ImporteFDC := fnGetAmountEmployeeLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::"Bank Account" then
                        ImporteFDC := fnGetAmountBankLedgerEntry();
                    if "Format FDC Setup"."Source Type" = "Format FDC Setup"."Source Type"::Customer then
                        ImporteFDC := fnGetAmountCustomerLedgerEntry();

                    if "Format FDC Setup".Ingreso then
                        ImporteFDC := Abs(ImporteFDC);

                    if "Format FDC Setup".Egreso then
                        ImporteFDC := Abs(ImporteFDC) * -1;

                    ImporteAcumulado := ImporteFDC;
                    SaldoFinal := SaldoInicial + ImporteAcumulado;
                end;
            }

            trigger OnPreDataItem()
            begin
                InitGLEntry();
            end;

            trigger OnAfterGetRecord()
            begin
                IF "Filter Account" = '' then
                    CurrReport.Skip();


            end;

            trigger OnPostDataItem()
            begin

            end;

        }





    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Opciones)
                {
                    field(FechaInicial; FechaInicial)
                    {
                        ApplicationArea = All;
                    }
                    field(FechaFinal; FechaFinal)
                    {
                        ApplicationArea = All;
                    }
                    field(IsDollarized; IsDollarized)
                    {

                        Caption = 'Dolarizar';
                        ApplicationArea = All;
                    }
                }

            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        IsDollarized := true;
        CompanyInformation.get();
        CompanyInformation.CalcFields(Picture);
    end;

    trigger OnPreReport();
    begin
        if (FechaInicial = 0D) OR (FechaFinal = 0D) then
            Error('Rango de fecha incorrecto.');
    end;

    local procedure fnIsOpen(var pGLEntry: Record "G/L Entry"): Boolean
    var
        lclCustLedgerEntry: Record "Cust. Ledger Entry";
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lclEmployeeLedgerEntry: Record "Employee Ledger Entry";
    begin
        case pGLEntry."Source Type" of
            pGLEntry."Source Type"::Customer:
                begin
                    lclCustLedgerEntry.Reset();
                    lclCustLedgerEntry.SetRange("Document No.", pGLEntry."Document No.");
                    lclCustLedgerEntry.SetRange("Posting Date", pGLEntry."Posting Date");
                    lclCustLedgerEntry.SetRange("Customer No.", pGLEntry."Source No.");
                    lclCustLedgerEntry.SetRange(Open, true);
                    if lclCustLedgerEntry.FindSet() then
                        exit(true);
                end;
            pGLEntry."Source Type"::Vendor:
                begin
                    lclVendorLedgerEntry.Reset();
                    lclVendorLedgerEntry.SetRange("Document No.", pGLEntry."Document No.");
                    lclVendorLedgerEntry.SetRange("Posting Date", pGLEntry."Posting Date");
                    lclVendorLedgerEntry.SetRange("Vendor No.", pGLEntry."Source No.");
                    lclVendorLedgerEntry.SetRange(Open, true);
                    if lclVendorLedgerEntry.FindSet() then
                        exit(true);
                end;
            pGLEntry."Source Type"::Employee:
                begin
                    lclEmployeeLedgerEntry.Reset();
                    lclEmployeeLedgerEntry.SetRange("Document No.", pGLEntry."Document No.");
                    lclEmployeeLedgerEntry.SetRange("Posting Date", pGLEntry."Posting Date");
                    lclEmployeeLedgerEntry.SetRange("Employee No.", pGLEntry."Source No.");
                    lclEmployeeLedgerEntry.SetRange(Open, true);
                    if lclEmployeeLedgerEntry.FindSet() then
                        exit(true);
                end;
        end;
    end;

    local procedure InitVendorLedgerEntry()
    var
        lcVendorLedgerEntry: Record "Vendor Ledger Entry";
        lclDimensionSetEntry: Record "Dimension Set Entry";
        lclBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        lcGLEntry: Record "G/L Entry";
    begin
        lcVendorLedgerEntry.Reset();
        lcVendorLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lcVendorLedgerEntry.SetRange(lcVendorLedgerEntry."Document Type", "Format FDC Setup"."Document Type");
        if "Format FDC Setup"."Source No." <> '' then
            lcVendorLedgerEntry.SetFilter("Vendor No.", "Format FDC Setup"."Source No.");
        if lcVendorLedgerEntry.FindSet() then
            repeat
                //Insert Dimensions FCT
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcVendorLedgerEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                IF lclDimensionSetEntry.FindSet() then
                    lcVendorLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                //Insert Dimensions FE  
                lcGLEntry.Reset();
                lcGLEntry.SetRange("Document No.", lcVendorLedgerEntry."Document No.");
                lcGLEntry.SetRange("Document Date", lcVendorLedgerEntry."Document Date");
                lcGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Filter Account");
                lcGLEntry.SetFilter("Global Dimension 8 Code", '<>%1', '');
                if lcGLEntry.FindFirst() then
                    lcVendorLedgerEntry."Global Dimension FE" := lcGLEntry."Global Dimension 8 Code";

                if "Format FDC Setup"."Review Bank" then begin
                    lclBankAccountLedgerEntry.SetRange("Posting Date", lcVendorLedgerEntry."Posting Date");
                    lclBankAccountLedgerEntry.SetRange("Document No.", lcVendorLedgerEntry."Document No.");
                    if lclBankAccountLedgerEntry.FindFirst() then begin
                        //Dimen FCT
                        lclDimensionSetEntry.Reset();
                        lclDimensionSetEntry.SetRange("Dimension Set ID", lclBankAccountLedgerEntry."Dimension Set ID");
                        lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                        IF lclDimensionSetEntry.FindSet() then
                            lcVendorLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                        //Dimen FE
                        lclDimensionSetEntry.Reset();
                        lclDimensionSetEntry.SetRange("Dimension Set ID", lclBankAccountLedgerEntry."Dimension Set ID");
                        lclDimensionSetEntry.SetRange("Dimension Code", 'FE');
                        IF lclDimensionSetEntry.FindSet() then
                            lcVendorLedgerEntry."Global Dimension FE" := lclDimensionSetEntry."Dimension Value Code";


                    end;
                end;
                lcVendorLedgerEntry.Modify(false);
            until lcVendorLedgerEntry.Next = 0;


    end;

    local procedure InitEmployeeLedgerEntry()
    var
        lcEmployeeLedgerEntry: Record "Employee Ledger Entry";
        lclDimensionSetEntry: Record "Dimension Set Entry";
        lcGLEntry: Record "G/L Entry";
    begin
        lcEmployeeLedgerEntry.Reset();
        lcEmployeeLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        lcEmployeeLedgerEntry.SetRange("Document Type", lcEmployeeLedgerEntry."Document Type"::Payment);
        if "Format FDC Setup"."Source No." <> '' then
            lcEmployeeLedgerEntry.SetFilter("Employee No.", "Format FDC Setup"."Source No.");
        if lcEmployeeLedgerEntry.FindSet() then
            repeat
                //Insert Dimensions FCT
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcEmployeeLedgerEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                IF lclDimensionSetEntry.FindSet() then
                    lcEmployeeLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                //Insert Dimensions FE  
                lcGLEntry.Reset();
                lcGLEntry.SetRange("Document No.", lcEmployeeLedgerEntry."Document No.");
                lcGLEntry.SetRange("Posting Date", lcEmployeeLedgerEntry."Posting Date");
                lcGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Filter Account");
                lcGLEntry.SetFilter("Global Dimension 8 Code", '<>%1', '');
                if lcGLEntry.FindFirst() then
                    lcEmployeeLedgerEntry."Global Dimension FE" := lcGLEntry."Global Dimension 8 Code";

                lcEmployeeLedgerEntry.Modify(false);
            until lcEmployeeLedgerEntry.Next = 0;
    end;

    local procedure InitCustomerLedgerEntry()
    var
        lcCustLedgerEntry: Record "Cust. Ledger Entry";
        lclDimensionSetEntry: Record "Dimension Set Entry";
        lcGLEntry: Record "G/L Entry";
        lclBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        lcCustLedgerEntry.Reset();
        lcCustLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lcCustLedgerEntry.SetRange("Document Type", lcCustLedgerEntry."Document Type"::Payment);
        if "Format FDC Setup"."Source No." <> '' then
            lcCustLedgerEntry.SetFilter("Customer No.", "Format FDC Setup"."Source No.");
        if lcCustLedgerEntry.FindSet() then
            repeat
                //Insert Dimensions FCT
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcCustLedgerEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                IF lclDimensionSetEntry.FindSet() then
                    lcCustLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                //Insert Dimensions FE  
                lcGLEntry.Reset();
                lcGLEntry.SetRange("Document No.", lcCustLedgerEntry."Document No.");
                lcGLEntry.SetRange("Posting Date", lcCustLedgerEntry."Posting Date");
                lcGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Filter Account");
                lcGLEntry.SetFilter("Global Dimension 8 Code", '<>%1', '');
                if lcGLEntry.FindFirst() then
                    lcCustLedgerEntry."Global Dimension FE" := lcGLEntry."Global Dimension 8 Code";

                if "Format FDC Setup"."Review Bank" then begin
                    lclBankAccountLedgerEntry.SetRange("Posting Date", lcCustLedgerEntry."Posting Date");
                    lclBankAccountLedgerEntry.SetRange("Document No.", lcCustLedgerEntry."Document No.");
                    if lclBankAccountLedgerEntry.FindFirst() then begin
                        //Dimen FCT
                        lclDimensionSetEntry.Reset();
                        lclDimensionSetEntry.SetRange("Dimension Set ID", lclBankAccountLedgerEntry."Dimension Set ID");
                        lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                        IF lclDimensionSetEntry.FindSet() then
                            lcCustLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                        //Dimen FE
                        lclDimensionSetEntry.Reset();
                        lclDimensionSetEntry.SetRange("Dimension Set ID", lclBankAccountLedgerEntry."Dimension Set ID");
                        lclDimensionSetEntry.SetRange("Dimension Code", 'FE');
                        IF lclDimensionSetEntry.FindSet() then
                            lcCustLedgerEntry."Global Dimension FE" := lclDimensionSetEntry."Dimension Value Code";


                    end;
                end;
                lcCustLedgerEntry.Modify(false);
            until lcCustLedgerEntry.Next = 0;
    end;

    local procedure InitGLEntry()
    var

        lclDimensionSetEntry: Record "Dimension Set Entry";
        lcGLEntry: Record "G/L Entry";
    begin
        lcGLEntry.Reset();
        lcGLEntry.SetRange("Posting Date", FechaInicial, FechaFinal);

        if "Format FDC Setup"."Source No." <> '' then
            lcGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Source No.");
        if lcGLEntry.FindSet() then
            repeat
                //Insert Dimensions FCT
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcGLEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                IF lclDimensionSetEntry.FindSet() then
                    lcGLEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                //Insert Dimensions FE  
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcGLEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FE');
                IF lclDimensionSetEntry.FindSet() then
                    lcGLEntry."Global Dimension FE" := lclDimensionSetEntry."Dimension Value Code";

                lcGLEntry.Modify(false);
            until lcGLEntry.Next = 0;
    end;

    local procedure InitBankLedgerEntry()
    var
        lcBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        lclDimensionSetEntry: Record "Dimension Set Entry";
        lcGLEntry: Record "G/L Entry";
    begin
        lcBankAccountLedgerEntry.Reset();
        lcBankAccountLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        //lcBankAccountLedgerEntry.SetRange("Document Type", lcBankAccountLedgerEntry."Document Type"::Payment);
        if "Format FDC Setup"."Source No." <> '' then
            lcBankAccountLedgerEntry.SetFilter("Bal. Account No.", "Format FDC Setup"."Source No.");
        if lcBankAccountLedgerEntry.FindSet() then
            repeat
                //Insert Dimensions FCT
                lclDimensionSetEntry.Reset();
                lclDimensionSetEntry.SetRange("Dimension Set ID", lcBankAccountLedgerEntry."Dimension Set ID");
                lclDimensionSetEntry.SetRange("Dimension Code", 'FCT');
                IF lclDimensionSetEntry.FindSet() then
                    lcBankAccountLedgerEntry."Global Dimension FCT" := lclDimensionSetEntry."Dimension Value Code";
                //Insert Dimensions FE  
                lcGLEntry.Reset();
                lcGLEntry.SetRange("Document No.", lcBankAccountLedgerEntry."Document No.");
                lcGLEntry.SetRange("Posting Date", lcBankAccountLedgerEntry."Posting Date");
                lcGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Filter Account");
                lcGLEntry.SetFilter("Global Dimension 8 Code", '<>%1', '');
                if lcGLEntry.FindFirst() then
                    lcBankAccountLedgerEntry."Global Dimension FE" := lcGLEntry."Global Dimension 8 Code";

                lcBankAccountLedgerEntry.Modify(false);
            until lcBankAccountLedgerEntry.Next = 0;
    end;

    local procedure fnGetAmountGLEntry(): Decimal
    var
        lclGLEntry: Record "G/L Entry";
        lclAmount: Decimal;
    begin
        lclGLEntry.Reset();
        lclGLEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Filter Account" <> '' then
            lclGLEntry.SetFilter("G/L Account No.", "Format FDC Setup"."Filter Account");
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclGLEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");

        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclGLEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Dimension FCT" = 'NULL' then
            lclGLEntry.SetFilter("Global Dimension FCT", '%1', '');
        if "Format FDC Setup"."Filter Cod.Origen" <> '' then
            lclGLEntry.SetFilter("Source Code", "Format FDC Setup"."Filter Cod.Origen");

        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lclGLEntry.SetRange("Document Type", "Format FDC Setup"."Document Type");
        if lclGLEntry.FindSet() then
            repeat

                if IsDollarized then
                    if lclGLEntry."Source Currency Code" <> '' then
                        lclAmount += lclGLEntry."Additional-Currency Amount"
                    else
                        lclAmount += lclGLEntry.Amount / fnGetTipoCambio('', lclGLEntry."Posting Date")
                else
                    lclAmount += lclGLEntry.Amount;
            until lclGLEntry.Next() = 0;

        exit(lclAmount);
    end;

    local procedure fnGetAmountVendorLedgerEntry(): Decimal
    var
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lclAmount: Decimal;
        lclAmountTotal: Decimal;
        lclVendor: Record Vendor;
        lclSetupLocalization: Record "Setup Localization";
        lclAmountRetention: Decimal;
        lcGLEntry: Record "G/L Entry";
        lclTipoCambio: Decimal;
    begin
        lclSetupLocalization.Get();
        lclVendorLedgerEntry.Reset();
        lclVendorLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Source No." <> '' then
            lclVendorLedgerEntry.SetFilter("Vendor No.", "Format FDC Setup"."Source No.");
        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lclVendorLedgerEntry.SetRange("Document Type", lclVendorLedgerEntry."Document Type"::Payment);
        // lclVendorLedgerEntry.SetFilter("Remaining Amount", '%1', 0);
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclVendorLedgerEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclVendorLedgerEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Dimension FCT" = 'NULL' then
            lclVendorLedgerEntry.SetFilter("Global Dimension FCT", '%1', '');

        if "Format FDC Setup"."Filter Posting Group" <> '' then
            lclVendorLedgerEntry.SetFilter("Vendor Posting Group", "Format FDC Setup"."Filter Posting Group");
        if lclVendorLedgerEntry.FindSet() then
            repeat
                lclAmount := 0;
                IF not lclVendor.get(lclVendorLedgerEntry."Vendor No.") then
                    Clear(lclVendor);
                lclVendorLedgerEntry.CalcFields(Amount);
                lclVendorLedgerEntry.CalcFields("Amount (LCY)");
                if IsDollarized then begin
                    if lclVendorLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclVendorLedgerEntry.Amount;

                    if lclVendorLedgerEntry."Currency Code" = '' then
                        lclAmount += lclVendorLedgerEntry.Amount / fnGetTipoCambioVendor(lclVendorLedgerEntry, lclVendorLedgerEntry."Currency Code", lclVendorLedgerEntry."Posting Date");

                end;
                if not IsDollarized then begin
                    if lclVendorLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclVendorLedgerEntry."Amount (LCY)";

                    if lclVendorLedgerEntry."Currency Code" = '' then
                        lclAmount += lclVendorLedgerEntry.Amount;
                end;

                //Si es retencion
                if "Format FDC Setup"."Calcular Retencion" then
                    if lclVendor."Retention Agent" then begin
                        if lclSetupLocalization."Retention Percentage %" <> 0 then begin
                            lclAmountRetention := 0;
                            lclAmountRetention := lclAmount * (lclSetupLocalization."Retention Percentage %" / 100);
                            lclAmount -= lclAmountRetention;
                        end;
                    end;
                lclAmountTotal += lclAmount;
            until lclVendorLedgerEntry.Next() = 0;
        exit(lclAmountTotal);
    end;

    local procedure fnGetTipoCambioVendor(pVendorLedgerEntry: Record "Vendor Ledger Entry"; pCurrency: Code[20]; pPostingDate: Date): Decimal
    var
        lclCurrencyExchangeRate: Record "Currency Exchange Rate";
        lclGLEntry: Record "G/L Entry";
    begin
        lclGLEntry.Reset();
        lclGLEntry.SetRange("Document No.", pVendorLedgerEntry."Document No.");
        lclGLEntry.SetRange("Posting Date", pVendorLedgerEntry."Posting Date");
        lclGLEntry.SetFilter("G/L Account No.", '%1', '10*');
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclGLEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclGLEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        IF lclGLEntry.FindFirst() then
            exit(lclGLEntry.Amount / lclGLEntry."Additional-Currency Amount");

        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');

        lclCurrencyExchangeRate.SetFilter("Starting Date", '%1', pPostingDate);
        if lclCurrencyExchangeRate.FindSet() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');
        lclCurrencyExchangeRate.SetAscending("Starting Date", true);
        lclCurrencyExchangeRate.SetFilter("Starting Date", '..%1', pPostingDate);
        if lclCurrencyExchangeRate.FindLast() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        exit(1);
    end;

    local procedure fnGetTipoCambioCustomer(pCustomerLedgerEntry: Record "Cust. Ledger Entry"; pCurrency: Code[20]; pPostingDate: Date): Decimal
    var
        lclCurrencyExchangeRate: Record "Currency Exchange Rate";
        lclGLEntry: Record "G/L Entry";
    begin
        lclGLEntry.Reset();
        lclGLEntry.SetRange("Document No.", pCustomerLedgerEntry."Document No.");
        lclGLEntry.SetRange("Posting Date", pCustomerLedgerEntry."Posting Date");
        lclGLEntry.SetFilter("G/L Account No.", '%1', '10*');
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclGLEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclGLEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        IF lclGLEntry.FindFirst() then
            exit(lclGLEntry.Amount / lclGLEntry."Additional-Currency Amount");

        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');

        lclCurrencyExchangeRate.SetFilter("Starting Date", '%1', pPostingDate);
        if lclCurrencyExchangeRate.FindSet() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');
        lclCurrencyExchangeRate.SetAscending("Starting Date", true);
        lclCurrencyExchangeRate.SetFilter("Starting Date", '..%1', pPostingDate);
        if lclCurrencyExchangeRate.FindLast() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        exit(1);
    end;

    local procedure fnGetTipoCambio(pCurrency: Code[20]; pPostingDate: Date): Decimal
    var
        lclCurrencyExchangeRate: Record "Currency Exchange Rate";
        lclGLEntry: Record "G/L Entry";
    begin
        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');

        lclCurrencyExchangeRate.SetFilter("Starting Date", '%1', pPostingDate);
        if lclCurrencyExchangeRate.FindSet() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        lclCurrencyExchangeRate.Reset();
        if pCurrency <> '' then
            lclCurrencyExchangeRate.SetRange("Currency Code", pCurrency)
        else
            lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');
        lclCurrencyExchangeRate.SetAscending("Starting Date", true);
        lclCurrencyExchangeRate.SetFilter("Starting Date", '..%1', pPostingDate);
        if lclCurrencyExchangeRate.FindLast() then
            exit(lclCurrencyExchangeRate."Relational Exch. Rate Amount");

        exit(1);
    end;

    local procedure fnGetAmountCustomerLedgerEntry(): Decimal
    var
        lclCustLedgerEntry: Record "Cust. Ledger Entry";
        lclAmount: Decimal;
    begin
        lclCustLedgerEntry.Reset();
        lclCustLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Source No." <> '' then
            lclCustLedgerEntry.SetFilter("Customer No.", "Format FDC Setup"."Source No.");
        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lclCustLedgerEntry.SetRange("Document Type", lclCustLedgerEntry."Document Type"::Payment);
        //lclCustLedgerEntry.SetFilter("Remaining Amount", '%1', 0);
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclCustLedgerEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclCustLedgerEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");

        if "Format FDC Setup"."Filter Posting Group" <> '' then
            lclCustLedgerEntry.SetFilter("Customer Posting Group", "Format FDC Setup"."Filter Posting Group");
        if lclCustLedgerEntry.FindSet() then
            repeat
                lclCustLedgerEntry.CalcFields(Amount);
                lclCustLedgerEntry.CalcFields("Amount (LCY)");
                if IsDollarized then begin
                    if lclCustLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclCustLedgerEntry.Amount;

                    if lclCustLedgerEntry."Currency Code" = '' then
                        lclAmount += lclCustLedgerEntry.Amount / fnGetTipoCambioCustomer(lclCustLedgerEntry, lclCustLedgerEntry."Currency Code", lclCustLedgerEntry."Posting Date");
                end;
                if not IsDollarized then begin
                    if lclCustLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclCustLedgerEntry."Amount (LCY)";

                    if lclCustLedgerEntry."Currency Code" = '' then
                        lclAmount += lclCustLedgerEntry.Amount;
                end;
            until lclCustLedgerEntry.Next() = 0;
        exit(lclAmount);
    end;

    local procedure fnGetAmountEmployeeLedgerEntry(): Decimal
    var
        lclEmployeeLedgerEntry: Record "Employee Ledger Entry";
        lclAmount: Decimal;
    begin
        lclEmployeeLedgerEntry.Reset();
        lclEmployeeLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Source No." <> '' then
            lclEmployeeLedgerEntry.SetFilter("Employee No.", "Format FDC Setup"."Source No.");
        lclEmployeeLedgerEntry.SetRange("Document Type", lclEmployeeLedgerEntry."Document Type"::Payment);
        lclEmployeeLedgerEntry.SetFilter("Remaining Amount", '%1', 0);
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclEmployeeLedgerEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclEmployeeLedgerEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Posting Group" <> '' then
            lclEmployeeLedgerEntry.SetFilter("Employee Posting Group", "Format FDC Setup"."Filter Posting Group");
        if lclEmployeeLedgerEntry.FindSet() then
            repeat
                lclEmployeeLedgerEntry.CalcFields(Amount);
                lclEmployeeLedgerEntry.CalcFields("Amount (LCY)");
                if IsDollarized then begin
                    if lclEmployeeLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclEmployeeLedgerEntry.Amount;

                    if lclEmployeeLedgerEntry."Currency Code" = '' then
                        lclAmount += lclEmployeeLedgerEntry.Amount / fnGetTipoCambio(lclEmployeeLedgerEntry."Currency Code", lclEmployeeLedgerEntry."Posting Date");
                end;
                if not IsDollarized then begin
                    if lclEmployeeLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclEmployeeLedgerEntry."Amount (LCY)";

                    if lclEmployeeLedgerEntry."Currency Code" = '' then
                        lclAmount += lclEmployeeLedgerEntry.Amount;
                end;
            until lclEmployeeLedgerEntry.Next() = 0;
        exit(lclAmount);
    end;

    local procedure fnGetAmountBankLedgerEntry(): Decimal
    var
        lclBankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        lclAmount: Decimal;
    begin
        lclBankAccountLedgerEntry.Reset();
        lclBankAccountLedgerEntry.SetRange("Posting Date", DateVirtual."Period Start", DateVirtual."Period End");
        if "Format FDC Setup"."Source No." <> '' then
            lclBankAccountLedgerEntry.SetFilter("Bank Account No.", "Format FDC Setup"."Source No.");
        if "Format FDC Setup"."Document Type" <> "Format FDC Setup"."Document Type"::" " then
            lclBankAccountLedgerEntry.SetRange("Document Type", lclBankAccountLedgerEntry."Document Type"::Payment);
        //lclBankAccountLedgerEntry.SetFilter("Remaining Amount", '%1', 0);
        if "Format FDC Setup"."Filter Dimension FE" <> '' then
            lclBankAccountLedgerEntry.SetFilter("Global Dimension FE", "Format FDC Setup"."Filter Dimension FE");
        if "Format FDC Setup"."Filter Dimension FCT" <> '' then
            lclBankAccountLedgerEntry.SetFilter("Global Dimension FCT", "Format FDC Setup"."Filter Dimension FCT");
        if "Format FDC Setup"."Filter Dimension FCT" = 'NULL' then
            lclBankAccountLedgerEntry.SetFilter("Global Dimension FCT", '%1', '');
        if "Format FDC Setup"."Filter Posting Group" <> '' then
            lclBankAccountLedgerEntry.SetFilter("Bank Acc. Posting Group", "Format FDC Setup"."Filter Posting Group");
        if lclBankAccountLedgerEntry.FindSet() then
            repeat

                if IsDollarized then begin
                    if lclBankAccountLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclBankAccountLedgerEntry.Amount;

                    if lclBankAccountLedgerEntry."Currency Code" = '' then
                        lclAmount += lclBankAccountLedgerEntry.Amount / fnGetTipoCambio(lclBankAccountLedgerEntry."Currency Code", lclBankAccountLedgerEntry."Posting Date");
                end;
                if not IsDollarized then begin
                    if lclBankAccountLedgerEntry."Currency Code" <> '' then
                        lclAmount += lclBankAccountLedgerEntry."Amount (LCY)";

                    if lclBankAccountLedgerEntry."Currency Code" = '' then
                        lclAmount += lclBankAccountLedgerEntry.Amount;
                end;
            until lclBankAccountLedgerEntry.Next() = 0;
        exit(lclAmount);
    end;

    local procedure GetSaldoInicial(): Decimal
    var
        lclGLAccount: Record "G/L Account";
        lclAmount: Decimal;
    begin
        lclGLAccount.Reset();
        lclGLAccount.SetRange("Date Filter", 0D, CalcDate('<-1D>', DateVirtual."Period Start"));
        lclGLAccount.SetFilter("No.", '10*');
        lclGLAccount.SetFilter(lclGLAccount."Account Type", '%1', lclGLAccount."Account Type"::Posting);
        if lclGLAccount.FindSet() then
            repeat
                lclGLAccount.CalcFields("Balance at Date");
                lclGLAccount.CalcFields("Add.-Currency Balance at Date");
                if IsDollarized then
                    lclAmount += lclGLAccount."Add.-Currency Balance at Date"
                else
                    lclAmount += lclGLAccount."Balance at Date";
            until lclGLAccount.Next() = 0;
        exit(lclAmount);
    end;

    local procedure GetSaldoInicialBAK(): Decimal
    var
        lclGLEntry: Record "G/L Entry";
        lclAmount: Decimal;
    begin
        lclGLEntry.Reset();
        lclGLEntry.SetRange("Posting Date", 0D, CalcDate('<1D>', FechaInicial));
        lclGLEntry.SetFilter("G/L Account No.", '10*');
        lclGLEntry.SetFilter("G/L Account No.", '10*');
        if lclGLEntry.FindSet() then
            repeat
                if IsDollarized then
                    lclAmount += lclGLEntry."Additional-Currency Amount"
                else begin
                    IF lclGLEntry."Source Currency Code" <> '' then
                        lclAmount += lclGLEntry.Amount / lclGLEntry."Source Currency Factor";
                    IF lclGLEntry."Source Currency Code" = '' then
                        lclAmount += lclGLEntry.Amount;
                end;


            until lclGLEntry.Next() = 0;
        exit(lclAmount);
    end;

    var
        SaldoInicial: Decimal;
        SaldoFinal: Decimal;
        ImporteAcumulado: Decimal;
        FechaInicial: Date;
        FechaFinal: Date;
        ImporteFDC: Decimal;
        IsDollarized: Boolean;
        CompanyInformation: record "Company Information";

}

