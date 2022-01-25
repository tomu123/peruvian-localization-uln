enum 51001 "ST Source Code Type"
{
    Extensible = true;

    value(0; " ")
    {
        Caption = ' ';
    }
    value(1; "Payment Schedule")
    {
        Caption = 'Payment Schedule', Comment = 'ESM="Cronograma pagos"';
    }
    value(2; "PrePayment Control")
    {
        Caption = 'PrePayment Control', Comment = 'ESM="Control anticipo"';
    }
    value(3; "Payment EAP")
    {
        Caption = 'Payment EAP', Comment = 'ESM="Pago AGR"';
    }
    value(4; "Applied-to EAP")
    {
        Caption = 'Applied-to EAP', Comment = 'ESM="Applicación AGR"';
    }
    value(5; "Bounce EAP")
    {
        Caption = 'Bounce EAP', Comment = 'ESM="Rebote AGR"';
    }
    value(6; "Schedule Provision")
    {
        Caption = 'Schedule Provision', Comment = 'ESM="Provisión Cronograma SAVA"';
    }
    value(7; "Costo Diferido")
    {
        Caption = 'Costo Diferido', Comment = 'ESM="Costo Diferido"';
    }
    value(8; "Ingreso Diferido")
    {
        Caption = 'Ingreso Diferido', Comment = 'ESM="Ingreso Diferido"';
    }
    value(9; "Refinancing")
    {
        Caption = 'Refinancing', Comment = 'ESM="Refinanciamiento"';
    }
    value(10; "Invoice from Interest Ref.")
    {
        Caption = 'Invoice from Interest Refinancing', Comment = 'ESM="Factura de Interés Refinanciamineto"';
    }
    value(11; "Invoice Quota Ref.")
    {
        Caption = 'Invoice Quota Ref.', Comment = 'ESM="Factura Cuota Refinanciamiento"';
    }
    value(12; "Bulk Load Invoices")
    {
        Caption = 'Bulk Load Invoices', Comment = 'ESM="Factura Carga Masiva"';
    }
    value(13; "Invoice Integration")
    {
        Caption = 'Invoice Integration', Comment = 'ESM="Factura Integración"';
    }
    value(14; "Invoice Interest CyM")
    {
        Caption = 'Invoice Interest CyM', Comment = 'ESM="Factura Interés Comp. y Mora."';
    }
    value(15; Financing)
    {
        Caption = 'Financing', Comment = 'ESM="Financiamiento"';
    }

    value(16; "Quota Financing")
    {
        Caption = 'Quota Financing', Comment = 'ESM="Cuota Financiamiento"';
    }
    value(17; "Cr. Memo Quota Ref.")
    {
        Caption = 'Cr. Memo Quota Ref.', Comment = 'ESM="NC Cuota Ref."';
    }
    value(18; "Uncollectible Prov. Quota")
    {
        Caption = 'Uncollectible Prov. Quota', Comment = 'ESM="Cuota Prov. Incobrable"';
    }
    value(19; "Deferred Interest")
    {
        Caption = 'Deferred Interest', Comment = 'ESM="Interés Diferido"';
    }
    value(20; "Mutual Disbursement")
    {
        Caption = 'Mutual Disbursement', Comment = 'ESM="Desembolso Mutuos"';
    }
    value(21; "Uncollectible Prov. Reversal")
    {
        Caption = 'Uncollectible Prov. Reversal', Comment = 'ESM="Cuota Rever. Incobrable"';
    }
    value(22; "Adenda Prov. Reversal")
    {
        Caption = 'Adenda Prov. Reversal', Comment = 'ESM="Prov. Reversión Adenda"';
    }
    value(23; "Invoice Quota Finan.")
    {
        Caption = 'Invoice Quota Finan.', Comment = 'ESM="Factura Cuota Financiamiento"';
    }
    value(24; "Cr. Memo Quota Fin.")
    {
        Caption = 'Cr. Memo Quota Fin.', Comment = 'ESM="NC Cuota Fin."';
    }
    value(25; "Capital Inv. Quota Fin.")
    {
        Caption = 'Capital Quota Fin.', Comment = 'ESM="Cuota Capital Fin."';
    }
    value(26; "Interest Inv. Quota Fin.")
    {
        Caption = 'Interest Quota Fin.', Comment = 'ESM="Cuota Interés Fin."';
    }
    value(27; "Diferido Inv. Quota Fin.")
    {
        Caption = 'Diferido Quota Fin.', Comment = 'ESM="Cuota Diferido Fin."';
    }
    value(28; "Capital CrMemo Quota Fin.")
    {
        Caption = 'Capital CrMemo Quota Fin.', Comment = 'ESM="NC Cuota Capital Fin."';
    }
    value(29; "Interest CrMemo Quota Fin.")
    {
        Caption = 'Interest CrMemo Quota Fin.', Comment = 'ESM="NC Cuota Interés Fin."';
    }
    value(30; "Diferido CrMemo Quota Fin.")
    {
        Caption = 'Diferido CrMemo Quota Fin.', Comment = 'ESM="NC Cuota Diferido Fin."';
    }
    value(31; "Sava Invoice")
    {
        Caption = 'Sava Invoice', Comment = 'ESM="Factura Sava"';
    }
    value(32; "Quota Sava Implicito")
    {
        Caption = 'Quota Sava Implicito', Comment = 'ESM="Cuota Sava Implícito"';
    }
    value(33; "Quota Sava Mixto Implicito")
    {
        Caption = 'Quota Sava Mixto Implicito', Comment = 'ESM="Cuota Sava Mixto Implícito"';
    }
    value(34; "Sava Cash Invoice")
    {
        Caption = 'Sava Cash Invoice', Comment = 'ESM="Factura Sava Cash"';
    }
    value(35; "Financing Cancelled Total")
    {
        Caption = 'Financing Cancelled Total', Comment = 'ESM="Canc. Total Financiamiento"';
    }
    value(36; "Settlement DDLL")
    {
        Caption = 'Settlement DDLL', Comment = 'ESM="Liquidación DDLL"';
    }
    value(37; "Reverse Provision")
    {
        Caption = 'Reverse Provision', Comment = 'ESM="Revertir Provisión"';
    }
    value(38; "Cr. Memo Quota Sava")
    {
        Caption = 'Cr. Memo Quota Sava', Comment = 'ESM="NC Cuota Sava"';
    }
}