report 51004 "General Ledger Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    Caption = 'General Ledger Report', Comment = 'ESM="Diario Mayor"';
    RDLCLayout = './App/Report/RDLC/GeneralLedgerRecord.rdl';

    dataset
    {
        dataitem(GenJnlBookBuffer; "Gen. Journal Book Buffer")
        {
            UseTemporary = true;
            RequestFilterFields = "G/L Account No.", "Legal Document No.";
            column(Period; Period)
            {
                IncludeCaption = true;
            }
            column(Transaction_CUO; "Transaction CUO")
            {
                IncludeCaption = true;
            }
            column(Posting_Date_Filter; "Posting Date Filter")
            {
                IncludeCaption = true;
            }
            column(Gloss_and_description; "Gloss and description")
            {
                IncludeCaption = true;
            }
            column(Document_No_; "Document No.")
            {
                IncludeCaption = true;
            }
            column(G_L_Account_No_; "G/L Account No.")
            {
                IncludeCaption = true;
            }
            column(G_L_Account_Name; "G/L Account Name")
            {
                IncludeCaption = true;
            }
            column(Debit_Amount; "Debit Amount")
            {
                IncludeCaption = true;
            }
            column(Credit_Amount; "Credit Amount")
            {
                IncludeCaption = true;
            }
            column(PeriodDescription; PeriodDescription)
            {
            }
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(CompanyVATRegNo; CompInf."VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(CompanyVATRegName; CompInf.Name)
            {
                IncludeCaption = true;
            }
            column(SaldoInicial; SaldoInicial)
            {
            }
            trigger OnAfterGetRecord()
            begin
                if LastAccNo <> GenJnlBookBuffer."G/L Account No." then begin
                    LastAccNo := GenJnlBookBuffer."G/L Account No.";
                    TotalDebit := 0;
                    TotalCredit := 0;
                    SaldoInicial := 0;
                    FechaAntes := CALCDATE('<-1D>', StartDate);

                    IF DATE2DMY(StartDate, 2) > 1 THEN BEGIN

                        "G/L Account".SETRANGE("Date Filter", 0D, fechaantes);
                        "G/L Account".SETFILTER("No.", GenJnlBookBuffer."G/L Account No.");
                        IF "G/L Account".FIND('-') THEN BEGIN
                            "G/L Account".CALCFIELDS("Additional-Currency Net Change", "Net Change");

                            //IF PrintAmountsInAddCurrency THEN BEGIN
                            /*IF "G/L Account"."Additional-Currency Net Change" > 0 THEN
                                TotalDebit := TotalDebit + "G/L Account"."Additional-Currency Net Change"
                            ELSE
                                TotalCredit := TotalCredit + ABS("G/L Account"."Additional-Currency Net Change");*/
                            //END ELSE BEGIN
                            IF "G/L Account"."Net Change" > 0 THEN
                                TotalDebit := TotalDebit + "G/L Account"."Net Change"
                            ELSE
                                TotalCredit := TotalCredit + ABS("G/L Account"."Net Change");

                            SaldoInicial := TotalDebit - TotalCredit;
                        END;
                    end;

                end;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Information', Comment = 'ESM="Información"';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Start Date', Comment = 'ESM="Fecha Inicio"';
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                        Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
                    }
                    field(PeriodDescription; PeriodDescription)
                    {
                        ApplicationArea = All;
                        Caption = 'Period Description', Comment = 'ESM="Descripción Periodo"';
                    }
                    field(AutomaticEBook; AutomaticEBook)
                    {
                        ApplicationArea = All;
                        Caption = 'Automatic EBook', Comment = 'ESM="Generar Electrónico (PLE)"';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    trigger OnPreReport()
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error(ShowErrorEmptyDate);
        AccBookMgt.SetDate(StartDate, EndDate);
        AccBookMgt.GenJournalBooks('601', AutomaticEBook);
        AccBookMgt.GetGenJnlBookBuffer(GenJnlBookBuffer);
        CompInf.Get();
    end;

    var
        LastAccNo: Code[20];
        TotalDebit: Decimal;
        TotalCredit: Decimal;
        "G/L Account": Record "G/L Account";
        FechaAntes: Date;
        SaldoInicial: Decimal;
        StartDate: Date;
        EndDate: Date;
        PeriodDescription: text[100];
        TitlePurchaseRecors: Text[100];
        LegalDocumentDescription: Text[100];
        AutomaticEBook: Boolean;
        CompInf: Record "Company Information";
        AccBookMgt: Codeunit "Accountant Book Management";
        ShowErrorEmptyDate: Label 'Enter Start Date and End Date to continue.', Comment = 'ESM="Ingrese fecha de inicio y fin para continuar."';
}