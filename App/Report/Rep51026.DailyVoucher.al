report 51026 "LU Daily Voucher"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Daily Voucher.rdl';
    Caption = 'Daily Voucher', Comment = 'ESM="Voucher diario"';

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
        {
            column(Name_CompanyInf; CompanyInf.Name + ' ' + CompanyInf."Name 2")
            {
            }
            column(Ruc_CompanyInf; CompanyInf."VAT Registration No.")
            {
            }
            column(MyFilters; MyFilters)
            {
            }
            column(FechaImp; PrintDate)
            {
            }
            column(Picture_CompanyInf; CompanyInf.Picture)
            {
            }
            column(GLAccountNo_GLEntry; "G/L Entry"."G/L Account No.")
            {
            }
            column(PostingDate_GLEntry; "G/L Entry"."Posting Date")
            {
            }
            column(DocumentType_GLEntry; "G/L Entry"."Document Type")
            {
            }
            column(DocumentNo_GLEntry; "G/L Entry"."Document No.")
            {
            }
            column(ExternalDocumentNo_GLEntry; "G/L Entry"."External Document No.")
            {
            }
            column(SourceType_GLEntry; "G/L Entry"."Source Type")
            {
            }
            column(SourceNo_GLEntry; "G/L Entry"."Source No.")
            {
            }
            column(Description_GLEntry; "G/L Entry".Description)
            {
            }
            column(TextoRegistro_GLEntry; "G/L Entry"."Posting Text")
            {
            }
            column(DebitAmount_GLEntry; "G/L Entry"."Debit Amount")
            {
            }
            column(CreditAmount_GLEntry; "G/L Entry"."Credit Amount")
            {
            }
            column(BalAccountNo_GLEntry; "G/L Entry"."Bal. Account No.")
            {
            }
            column(No_Proyecto; "G/L Entry"."Job No.")
            {
            }
            column(CodDivOrigen; "G/L Entry"."Source Code")// "Source Currency Code")
            {
            }
            column(ImpDebeUSD; ABS(gImpDebeUSD))
            {
            }
            column(ImpHaberUSD; ABS(gImpHaberUSD))
            {
            }
            column(NombreProcedencia; gNombreProcedencia)
            {
            }

            trigger OnAfterGetRecord();
            begin

                gImpDebeUSD := 0;
                gImpHaberUSD := 0;
                /*case "G/L Entry"."Source Currency Code" of
                    'USD':
                        begin
                            if "G/L Entry".Amount > 0 then begin
                                gImpDebeUSD := "G/L Entry".Amount * "G/L Entry"."Source Currency Factor";
                            end else begin
                                gImpHaberUSD := "G/L Entry".Amount * "G/L Entry"."Source Currency Factor";
                            end;
                        end;
                end;*/

                if "G/L Entry"."Source No." <> '' then begin
                    case "G/L Entry"."Source Type" of
                        "Source Type"::Employee:
                            begin
                                grecEmployee.GET("G/L Entry"."Source No.");
                                gNombreProcedencia := grecEmployee."First Name";
                            end;
                        "Source Type"::Customer:
                            begin
                                grecCustomer.GET("G/L Entry"."Source No.");
                                gNombreProcedencia := grecCustomer.Name;
                            end;
                        "Source Type"::Vendor:
                            begin
                                grecVendor.GET("G/L Entry"."Source No.");
                                gNombreProcedencia := grecVendor.Name;
                            end;
                        "Source Type"::"Bank Account":
                            begin
                                grecBank.GET("G/L Entry"."Source No.");
                                gNombreProcedencia := grecBank.Name;
                            end;
                    end;
                end;
            end;

            trigger OnPreDataItem();
            begin
                MyFilters := "G/L Entry".GetFilters();
                CompanyInf.Get();
                CompanyInf.CalcFields(Picture);
                if not reqShowAnalyticEntries then
                    "G/L Entry".SetRange("Analityc Entry", false);

                PrintDate := WorkDate();
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(reqShowAnalyticEntries; reqShowAnalyticEntries)
                {
                    Caption = 'Analytic entries', Comment = 'ESM="Mov. Analíticos"';
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
        reqShowAnalyticEntries := false;
    end;

    var
        CompanyInf: Record "Company Information";
        MyFilters: Text;
        reqShowAnalyticEntries: Boolean;
        gCompanyName: Text;
        gImpDebeUSD: Decimal;
        gImpHaberUSD: Decimal;
        PrintDate: Date;
        grecVendor: Record Vendor;
        grecCustomer: Record Customer;
        grecEmployee: Record Employee;
        grecBank: Record "Bank Account";
        grecAccount: Record "G/L Account";
        gNombreProcedencia: Text;
}

