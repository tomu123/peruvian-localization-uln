report 51015 "Customer AC Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Customer AC Balance.rdl';

    Caption = 'Customer AC Balance', Comment = 'ESM="Saldo GC Cliente"';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer Posting Group", "Currency Code", "Customer No.";
            column(CustomerNo_CustLedgerEntry; "Cust. Ledger Entry"."Customer No.")
            {
            }
            column(CurrencyCode_CustLedgerEntry; "Cust. Ledger Entry"."Currency Code")
            {
            }
            column(PostingDate_CustLedgerEntry; "Cust. Ledger Entry"."Posting Date")
            {
            }
            column(RemainingAmount_CustLedgerEntry; "Cust. Ledger Entry"."Remaining Amount")
            {
            }
            column(FechaEmision; "Cust. Ledger Entry"."Document Date")
            {
            }
            column(DocumentNo_CustLedgerEntry; "Cust. Ledger Entry"."Document No.")
            {
            }
            column(OriginalAmount_CustLedgerEntry; "Cust. Ledger Entry"."Original Amount")
            {
            }
            column(OriginalAmtLCY_CustLedgerEntry; "Cust. Ledger Entry"."Original Amt. (LCY)")
            {
            }
            column(RemainingAmtLCY_CustLedgerEntry; "Cust. Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(DueDate_CustLedgerEntry; "Cust. Ledger Entry"."Due Date")
            {
            }
            column(Open_CustLedgerEntry; "Cust. Ledger Entry".Open)
            {
            }
            column(UserID_CustLedgerEntry; "Cust. Ledger Entry"."User ID")
            {
            }
            column(TipoDoc; "Cust. Ledger Entry"."Legal Document")
            {
            }
            column(GrupoContableCliente; "Cust. Ledger Entry"."Customer Posting Group")
            {
            }
            column(ExternalDocumentNo_CustLedgerEntry; gExternalDoc)
            {
            }
            column(CustomerPostingGroup_CustLedgerEntry; "Cust. Ledger Entry"."Customer Posting Group")
            {
            }
            column(Descripcion; "Cust. Ledger Entry".Description)
            {
            }
            column(DiasVencidos; DiasVencidos)
            {
            }
            column(TipoDocumento; "Cust. Ledger Entry"."Document Type")
            {
            }
            dataitem(Customer; Customer)
            {
                DataItemLink = "No." = FIELD("Customer No.");
                //DataItemTableView = WHERE("" = CONST(Cliente));
                column(Name_Customer; Customer.Name)
                {
                }
                column(VATRegistrationNo_Customer; Customer."VAT Registration No.")
                {
                }
                column(Num_Cta_Cliente; ErNoCta)
                {
                }
                column(lOGO_REP; Logo_rep.Picture)
                {
                }
                column(Razon_social; Logo_rep.Name)
                {
                }
                column(Direc_Fiscals; Logo_rep.Address)
                {
                }
                column(Ruc; Logo_rep."VAT Registration No.")
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
                if ErCtaCL.GET("Customer Posting Group") then;
                ErNoCta := ErCtaCL."Receivables Account";

                CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");

                DiasVencidos := 0;
                if (EndDate > "Due Date") then begin
                    DiasVencidos := EndDate - "Due Date";
                end;

                if "Remaining Amount" = 0 then
                    CurrReport.SKIP;

                gExternalDoc := DELCHR("Cust. Ledger Entry"."External Document No.", '=', DELCHR("Cust. Ledger Entry"."External Document No.", '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789*-/()'));
            end;

            trigger OnPreDataItem();
            begin
                Logo_rep.GET;
                Logo_rep.CALCFIELDS(Picture);

                SETFILTER("Cust. Ledger Entry"."Date Filter", '%1..%2', 0D, EndDate);
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
        ErNoCta: Code[20];
        ErCtaCL: Record "Customer Posting Group";
        Logo_rep: Record "Company Information";
        StartDate: Date;
        EndDate: Date;
        Cta_clie: Code[50];
        DiasVencidos: Integer;
        gExternalDoc: Text[50];
}

