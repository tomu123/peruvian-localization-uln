report 51047 "Doc. Pendientes Clientes"
{
    // LIBRO 3.16.1

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Doc. Pendientes Clientes.rdl';

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer No.", "Date Filter", "Document No.", "External Document No.", "Currency Code", "Customer Posting Group", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(TxtFiltro; STRSUBSTNO(Text000, FORMAT(GETRANGEMAX("Date Filter"))))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(MostrarFiltros; GETFILTERS)
            {
            }
            column(GrupoContable; "Customer Posting Group")
            {
            }
            column(CodCliente; "Customer No.")
            {
            }
            column(NomCliente; GRecCustomer.Name + ' ' + GRecCustomer."Name 2")
            {
            }
            column(FechaRegistro; "Posting Date")
            {
            }
            column(TipoDoc; "Document Type")
            {
            }
            column(DocNo; "Document No.")
            {
            }
            column(Descripcion; Description)
            {
            }
            column(Letra; '')//PC 25.06.11 pendiente revision' "Promissory Doc No."')
            {
            }
            column(ImpPendDA; GDcImpDA)
            {
            }
            column(ImpPendDL; GDcImpDL)
            {
            }
            column(Divisa; "Currency Code")
            {
            }
            column(CtaGC; GRecCPG."Receivables Account")
            {
            }

            trigger OnAfterGetRecord()
            begin
                CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)");

                IF "Remaining Amt. (LCY)" = 0 THEN
                    CurrReport.SKIP;

                IF ("Cust. Ledger Entry"."Source Code" = 'MIGRACION') AND ("Cust. Ledger Entry".Open = FALSE) THEN
                    CurrReport.SKIP;

                GRecCPG.RESET;
                IF NOT (GRecCPG.GET("Customer Posting Group")) THEN GRecCPG.INIT;
                GRecCustomer.RESET;
                IF NOT (GRecCustomer.GET("Customer No.")) THEN GRecCustomer.INIT;

                CLEAR(GDcImpDL);
                CLEAR(GDcImpDA);
                GDcImpDL := "Remaining Amt. (LCY)";
                IF "Currency Code" <> '' THEN
                    GDcImpDA := "Remaining Amount";
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
        GRecCPG: Record "Customer Posting Group";
        GRecCustomer: Record Customer;
        Text000: Label 'Balance on %1';
        TituloPagina: Label 'Customer - Balance to Date';
        CurrReportPageNoCaptionLbl: Label 'Page';
        GDcImpDL: Decimal;
        GDcImpDA: Decimal;
}

