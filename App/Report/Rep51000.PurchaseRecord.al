report 51000 "Purchase Record"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    Caption = 'Purchase Record', Comment = 'ESM="Registro de compras"';
    RDLCLayout = './App/Report/RDLC/PurchaseRecord.rdl';

    dataset
    {
        dataitem(PurchaseRecord; "Purchase Record Buffer")
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
            column(Document_Date; "Document Date")
            {
                IncludeCaption = true;
            }
            column(Payment_Due_Date; "Payment Due Date")
            {
                IncludeCaption = true;
            }
            column(Legal_Document; "Legal Document")
            {
                IncludeCaption = true;
            }
            column(Serie_Document; "Serie Document")
            {
                IncludeCaption = true;
            }
            column(DUA_Document_Year; "DUA Document Year")
            {
                IncludeCaption = true;
            }
            column(Number_Document; "Number Document")
            {
                IncludeCaption = true;
            }
            column(Field_10_Total_Amount; "Field 10 Total Amount")
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
            column(Vendor_Name; "Vendor Name")
            {
                IncludeCaption = true;
            }
            column(Taxed_Base; TaxedBaseIGV)
            {
                //IncludeCaption = true;
            }
            column(Taxed_VAT; "Taxed VAT")
            {
                IncludeCaption = true;
            }
            column(Untaxed_Base; "Untaxed Base")
            {
                IncludeCaption = true;
            }
            column(Untaxed_VAT; "Untaxed VAT")
            {
                IncludeCaption = true;
            }
            column(Refund_Base; "Refund Base")
            {
                IncludeCaption = true;
            }
            column(Refund_VAT; "Refund VAT")
            {
                IncludeCaption = true;
            }
            column(NOT_Taxed_VAT; "NOT Taxed VAT")

            {
                IncludeCaption = true;
            }
            column(ISC_Amount; "ISC Amount")
            {
                IncludeCaption = true;
            }
            column(Others_Amount; "Others Amount")
            {
                IncludeCaption = true;
            }
            column(ICBPER; ICBPER)
            {
                IncludeCaption = true;
            }
            column(Total_Amount; TotalAmountIGV)
            {
                //IncludeCaption = true;
            }
            column(Currency_Code; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(Currency_Amount; "Currency Amount")
            {
                IncludeCaption = true;
            }
            column(Mod__Document_Date; "Mod. Document Date")
            {
                IncludeCaption = true;
            }
            column(Mod__Legal_Document; "Mod. Legal Document")
            {
                IncludeCaption = true;
            }
            column(Mod__Serie; "Mod. Serie")
            {
                IncludeCaption = true;
            }
            column(DUA_Code; "DUA Code")
            {
                IncludeCaption = true;
            }
            column(Mod__Document; "Mod. Document")
            {
                IncludeCaption = true;
            }
            column(Ref__Number_Not_Address_; "Ref. Number Not Address.")
            {
                IncludeCaption = true;
            }
            column(Detraction_Emision_Date; "Detraction Emision Date")
            {
                IncludeCaption = true;
            }
            column(Detraction_Operation_No_; "Detraction Operation No.")
            {
                IncludeCaption = true;
            }
            column(Retention_Mark; "Retention Mark")
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
            trigger OnAfterGetRecord()
            var
                LegalDocumentRec: Record "Legal Document";
            begin
                LegalDocumentRec.Reset();
                LegalDocumentRec.SetRange("Option Type", LegalDocumentRec."Option Type"::"SUNAT Table");
                LegalDocumentRec.SetRange("Type Code", '10');
                LegalDocumentRec.SetRange("Legal No.", "Legal Document");
                if LegalDocumentRec.Find('-') then
                    LegalDocumentDescription := CopyStr(LegalDocumentRec.Description, 1, 100);

                TaxedBaseIGV := 0;
                TotalAmountIGV := 0;

                if "Legal Document" = '50' then begin
                    TaxedBaseIGV := ("Taxed VAT" * 100) / 18;
                    TotalAmountIGV := TaxedBaseIGV + "Taxed VAT";
                    "NOT Taxed VAT" := 0;
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
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                    field(PeriodDescription; PeriodDescription)
                    {
                        ApplicationArea = All;
                    }
                    field(ShowRH; ShowRH)
                    {
                        ApplicationArea = All;
                    }
                    field(NotAddress; NotAddress)
                    {
                        ApplicationArea = All;
                    }
                    field(AutomaticEBook; AutomaticEBook)
                    {
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
        if NotAddress then begin
            TitlePurchaseRecors := 'Formato 8.2: REGISTROS DE COMPRAS NO DOMICILIADOS';
            AccBookMgt.PurchaserRecord('802', AutomaticEBook);
        end else begin
            TitlePurchaseRecors := 'Formato 8.1: REGISTROS DE COMPRAS';
            AccBookMgt.PurchaserRecord('801', AutomaticEBook);
            AccBookMgt.GetPuchRecordBuffer(PurchaseRecord);
            PurchaseRecord.Reset();
        end;
        CompInf.Get();
    end;

    var
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