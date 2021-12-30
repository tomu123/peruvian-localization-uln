report 51148 "Vendor AC Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Vendor AC Balance.rdl';

    Caption = 'Vendor AC Balance', Comment = 'ESM="Saldo GC Proveedor"';

    dataset
    {
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            RequestFilterFields = "Vendor No.", "Currency Code", "Vendor Posting Group";
            column(VendorNo_VendorLedgerEntry; "Vendor Ledger Entry"."Vendor No.")
            {
            }
            column(ExternalDocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."External Document No.")
            {
            }
            column(DocumentDate_VendorLedgerEntry; "Vendor Ledger Entry"."Document Date")
            {
            }
            column(DueDate_VendorLedgerEntry; "Vendor Ledger Entry"."Due Date")
            {
            }
            column(Open_VendorLedgerEntry; "Vendor Ledger Entry".Open)
            {
            }
            column(VendorPostingGroup_VendorLedgerEntry; "Vendor Ledger Entry"."Vendor Posting Group")
            {
            }
            column(DocumentNo_VendorLedgerEntry; "Vendor Ledger Entry"."Document No.")
            {
            }
            column(RemainingAmtLCY_VendorLedgerEntry; "Vendor Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(RemainingAmount_VendorLedgerEntry; "Vendor Ledger Entry"."Remaining Amount")
            {
            }
            column(TipoDocumento; "Vendor Ledger Entry"."Document Type")
            {
            }
            column(OriginalAmtLCY_VendorLedgerEntry; "Vendor Ledger Entry"."Original Amt. (LCY)")
            {
            }
            column(TipoDoc; "Vendor Ledger Entry"."Legal Document")
            {
            }
            column(GrupoContavleProveedor; "Vendor Ledger Entry"."Vendor Posting Group")
            {
            }
            column(OriginalAmount_VendorLedgerEntry; "Vendor Ledger Entry"."Original Amount")
            {
            }
            column(FechaEmision; "Vendor Ledger Entry"."Document Date")
            {
            }
            column(CurrencyCode_VendorLedgerEntry; "Vendor Ledger Entry"."Currency Code")
            {
            }
            column(PostingDate_VendorLedgerEntry; "Vendor Ledger Entry"."Posting Date")
            {
            }
            column(DiasVencidos; DiasVencidos)
            {
            }
            column(Description; gDescription)
            {
            }
            dataitem(Vendor; Vendor)
            {
                DataItemLink = "No." = FIELD("Vendor No.");
                column(VATRegistrationNo_Vendor; Vendor."VAT Registration No.")
                {
                }
                column(Name_Vendor; Vendor.Name)
                {
                }
                column(Logo_rep; Logo_rep.Picture)
                {
                }
                column(ErCtaProv; ErCtaProv)
                {
                }
                column(Razon_social; Logo_rep.Name)
                {
                }
                column(Direc_fis; Logo_rep.Address)
                {
                }
                column(ruc_1; Logo_rep."VAT Registration No.")
                {
                }
                column(Fecha_ini; StartDate)
                {
                }
                column(Fecha_fin; EndDate)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                //ER001-ULN240216

                if ErGcProv.GET("Vendor Posting Group") then;
                ErCtaProv := ErGcProv."Payables Account";

                //IF COPYSTR(ErNoCta,1,2) <> '16' THEN CurrReport.SKIP;

                CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");

                if "Remaining Amount" = 0 then CurrReport.SKIP;

                //ER001-ULN240216

                //002
                gDescription := '';
                if "Vendor Ledger Entry"."Posting Text" <> '' then
                    gDescription := "Vendor Ledger Entry"."Posting Text"
                else
                    gDescription := "Vendor Ledger Entry".Description;
                //002

                DiasVencidos := 0;
                if (EndDate > "Due Date") then begin
                    DiasVencidos := EndDate - "Due Date";
                end;
            end;

            trigger OnPreDataItem();
            begin
                Logo_rep.GET;
                Logo_rep.CALCFIELDS(Picture);

                SETFILTER("Vendor Ledger Entry"."Date Filter", '%1..%2', 0D, EndDate)
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
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
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ErGcProv: Record "Vendor Posting Group";
        Logo_rep: Record "Company Information";
        ErCtaProv: Code[20];
        StartDate: Date;
        EndDate: Date;
        gDescription: Text[250];
        DiasVencidos: Integer;
}

