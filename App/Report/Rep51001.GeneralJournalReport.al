report 51001 "General Journal Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    Caption = 'General Journal Report', Comment = 'ESM="Diario General"';
    RDLCLayout = './App/Report/RDLC/GeneralJournalRecord.rdl';


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
            column(Correlative_cuo; "Correlative cuo")
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
            column(Book_Code_Ref; "Book Code Ref")
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
                    Caption = 'Information';
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
        AccBookMgt.GenJournalBooks('501', AutomaticEBook);
        AccBookMgt.GetGenJnlBookBuffer(GenJnlBookBuffer);
        CompInf.Get();
    end;

    var
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