report 51730 "Sales Record"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    Caption = 'Sles Record', Comment = 'ESM="Registro de Ventas"';
    RDLCLayout = './App/Report/RDLC/SalesRecord.rdl';

    dataset
    {
        dataitem(SalesRecord; "Sales Record Buffer")
        {
            UseTemporary = true;
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
            column(FechaEmision; "Document Date")
            {
                IncludeCaption = true;
            }
            column(Payment_Due_Date; "Payment Due Date")
            {
                IncludeCaption = true;
            }
            column(DocTypeSUNAT; "Legal Document")
            {
                IncludeCaption = true;
            }
            column(NoDoc; "Number Document")
            {
                IncludeCaption = true;
            }
            column(TipoDoc; "Legal Document")
            {
                IncludeCaption = true;
            }
            column(Legal_Document; "Legal Document")
            {
                IncludeCaption = true;
            }
            column(SerieDoc; "Serie Document")
            {
                IncludeCaption = true;
            }
            column(Serie_Document; "Serie Document")
            {
                IncludeCaption = true;
            }

            column(Number_Document; "Number Document")
            {
                IncludeCaption = true;
            }
            column(Field_9_Total_Amount; "Field 9 Total Amount")
            {
                IncludeCaption = true;
            }
            column(VAT_Registration_Type; "VAT Registration Type")
            {
                IncludeCaption = true;
            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(Customer_Name; "Customer Name")
            {
                IncludeCaption = true;
            }
            column(Exportacion; formatByLegalDocument("Amount Export invoiced", "Legal Document"))
            {
                // IncludeCaption = true;
            }
            column(BaseImponible; formatByLegalDocument("Taxed Base", "Legal Document"))
            {
                //IncludeCaption = true;
            }
            column(Exonerada; formatByLegalDocument("Total Amount Exonerated", "Legal Document"))
            {
                //IncludeCaption = true;
            }
            column(Inafecta; formatByLegalDocument("Total Amount Unaffected", "Legal Document"))
            {
                //IncludeCaption = true;
            }
            column(IGV; formatByLegalDocument("Taxed VAT", "Legal Document"))
            {
                // IncludeCaption = true;
            }

            column(ISC; formatByLegalDocument("ISC Amount", "Legal Document"))
            {
                // IncludeCaption = true;
            }
            column(Others_Amount; "Others Amount")
            {
                IncludeCaption = true;
            }
            column(ImporteTotal; formatByLegalDocument("Total Amount", "Legal Document"))
            {

            }
            column(Currency_Code; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(TipoCambio; "Currency Amount")
            {
                IncludeCaption = true;
            }
            column(FechaRef; "Mod. Document Date")
            {
                IncludeCaption = true;
            }
            column(TipoRef; "Mod. Legal Document")
            {
                IncludeCaption = true;
            }
            column(SerieRef; "Mod. Serie")
            {
                IncludeCaption = true;
            }

            column(NoRef; "Mod. Document")
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
            column(TitlePurchaseRecors; TitlePurchaseRecors)
            {
            }
            column(Document_No_; "Document No.")
            {
                IncludeCaption = true;
            }
            column(LegalDocumentDescription; LegalDocumentDescription)
            {

            }
            column(DefinicionGratuito; gDefinicionGratuito)
            {

            }
            trigger OnAfterGetRecord()
            var
                LegalDocumentRec: Record "Legal Document";
            begin
                LegalDocumentRec.Reset();
                LegalDocumentRec.SetRange("Option Type", LegalDocumentRec."Option Type"::"SUNAT Table");
                LegalDocumentRec.SetRange("Type Code", '10');
                LegalDocumentRec.SetRange("Legal No.", "Legal Document");
                if LegalDocumentRec.Find('-') then
                    LegalDocumentDescription := LegalDocumentRec.Description;

                TaxedBaseIGV := 0;
                TotalAmountIGV := 0;

                if "Legal Document" = '50' then begin
                    TaxedBaseIGV := ("Taxed VAT" * 100) / 18;
                    TotalAmountIGV := TaxedBaseIGV + "Taxed VAT";

                end else begin
                    TaxedBaseIGV := "Taxed Base";
                    TotalAmountIGV := "Total Amount";
                end;
            end;

            trigger OnPreDataItem()
            begin
                if ShowRH then
                    exit;
                SetFilter("Legal Document", '<>%1', '02');
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
                    Caption = 'Information';
                    field(StartDate; StartDate)
                    {
                        Caption = 'StartDate', Comment = 'ESM="Fecha Inicial"';
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        Caption = 'EndDate', Comment = 'ESM="Fecha Final"';
                        ApplicationArea = All;
                    }
                    field(PeriodDescription; PeriodDescription)
                    {
                        Caption = 'PeriodDescription', Comment = 'ESM="Descripción"';
                        ApplicationArea = All;
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

        TitlePurchaseRecors := 'Formato 14.1: REGISTROS DE VENTAS';
        AccBookMgt.SalesRecord('1401', AutomaticEBook);
        AccBookMgt.GetSalesRecordBuffer(SalesRecord);
        SalesRecord.Reset();

        CompInf.Get();
    end;

    local procedure formatByLegalDocument(pAmount: Decimal; pLegalDocument: Code[10]): Decimal
    var

    begin
        IF pLegalDocument IN ['07', '87', '97'] then
            pAmount := -(ABS(pAmount))
        else
            pAmount := ABS(pAmount);

        exit(pAmount);
    end;

    var
        gDefinicionGratuito: Boolean;
        StartDate: Date;
        EndDate: Date;
        TaxedBaseIGV: Decimal;
        TotalAmountIGV: Decimal;
        PeriodDescription: text[100];
        TitlePurchaseRecors: Text[100];
        LegalDocumentDescription: Text[100];
        ShowRH: Boolean;
        NotAddress: Boolean;
        AutomaticEBook: Boolean;
        CompInf: Record "Company Information";
        AccBookMgt: Codeunit "Accountant Book Management";
        ShowErrorEmptyDate: Label 'Enter Start Date and End Date to continue.', Comment = 'ESM="Ingrese fecha de inicio y fin para continuar."';
}