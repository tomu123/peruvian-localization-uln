pageextension 51021 "Setup Business Mgt. RC" extends "Business Manager Role Center"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        Addlast(sections)
        {
            group(PeruvianLocalization)
            {
                Caption = 'Setup Localization', Comment = 'ESM="Conf. Localizado"';
                Image = Administration;
                action(SetupLocalization)
                {
                    ApplicationArea = All;
                    Caption = 'Setup', Comment = 'ESM="Configuración"';
                    Image = Setup;
                    RunObject = page "Setup Localization";
                }
                action(LegalDocument)
                {
                    ApplicationArea = All;
                    Caption = 'Legal Documents', Comment = 'ESM="Documentos legales"';
                    Image = CodesList;
                    RunObject = page "Legal Document List";
                }
                action(AccountantBooks)
                {
                    ApplicationArea = All;
                    Caption = 'Accountant BooK', Comment = 'ESM="Libros Contables"';
                    Image = Accounts;
                    RunObject = page "Accountant Book";
                }
            }
        }
        addafter(BankAccountReconciliations)
        {
            action(RetentionEntry)
            {
                Caption = 'Retention Entries', Comment = 'ESM="Movimientos de retención"';
                ApplicationArea = All;
                RunObject = page "Retention Ledger Entry";
            }
        }
        addafter("Posted Purchase Return Shipments")
        {
            action(SunatVendorStatus)
            {
                ApplicationArea = All;
                Caption = 'Sunat Vendor Status', Comment = 'ESM="Proveedor Estado SUNAT"';
                Image = Register;
                RunObject = page "SUNAT Vendor Register List";
            }
        }
        addafter("<Page Purchase Invoices>")
        {
            action(RetRHPurchInvoice)
            {
                ApplicationArea = All;
                Caption = 'RH Purchase Invoice', Comment = 'ESM="Recibos por honorarios"';
                Image = CodesList;
                RunObject = page "Ret. RH Purchase Invoices";
            }
        }
        addafter("<Page Posted Purchase Invoices>")
        {
            action(RetRHPostedPurchInvoice)
            {
                ApplicationArea = All;
                Caption = 'RH Postde Purchase Invoice', Comment = 'ESM="Historico Recibos por honorarios"';
                Image = CodesList;
                RunObject = page "Ret. RH Posted Purch. Invoices";
            }
        }
        addafter("Purchase Quotes")
        {
            action(PRPurchaseRequest)
            {
                ApplicationArea = All;
                Caption = 'Purchase Request List', Comment = 'ESM="Solicitud de compra"';
                Image = SendApprovalRequest;
                RunObject = Page "PR Purchase Request List";
            }
        }
        addafter(BankAccountReconciliations)
        {
            action(PaymentSchedule)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Payment Schedule', Comment = 'ESM="Cronograma pagos"';
                Image = PaymentDays;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Schedule";
            }
            action(PostedPaymentSchedule)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Posted Payment Schedule', Comment = 'ESM="Cronograma pagos registrados"';
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Posted Payment Schedule";
            }
            action(ListPaymentCollection)
            {
                ApplicationArea = All;
                Caption = 'Payment - Collection', Comment = 'ESM="Cobros - Recaudacion"';
                Image = PaymentHistory;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Payment Collection";
            }
        }
        addafter("Posted Sales Return Receipts")
        {
            group(InternalConsumption)
            {
                Caption = 'Internal Consumption', Comment = 'ESM="Consumo Interno"';
                action(InvoiceInternalConsumption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Inv. Int. Consumption', Comment = 'ESM="Fact. Consumo interno"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Internal Consumption List";
                }
                action(RetunrInternalConsumption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Retunr Int. Consumption', Comment = 'ESM="Devolución Consumo interno"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "CI Return Int. Consump. List";
                }
            }
            group(PostedInternalConsumption)
            {
                Caption = 'Posted Internal Consumption', Comment = 'ESM="Histórico de Consumo Interno"';
                action(PostedInvoiceInternalConsumption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Inv. Int. Consumption', Comment = 'ESM="Hist. Factura Consumo interno"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Posted Sales Invoicess";
                }
                action(PostedRetunrInternalConsumption)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Posted Retunr Int. Consumption', Comment = 'ESM="Hist. Devolución Consumo interno"';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = page "Posted Return Int. Consump.";
                }
            }
        }
    }
}