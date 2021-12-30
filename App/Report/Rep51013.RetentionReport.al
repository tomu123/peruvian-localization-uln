report 51014 "RET Retention Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/RET Retention Report.rdl';

    Caption = 'Retentions Records';

    dataset
    {
        dataitem("Detailed Retention Ledg. Entry"; "Detailed Retention Ledg. Entry")
        {
            RequestFilterFields = "Retention Posting Date";
            column(CompanyAddress; CompanyInf.Address)
            {
            }
            column(CompanyVATRegistration; CompanyInf."VAT Registration No.")
            {
            }
            column(CompanyName; CompanyInf.Name)
            {
            }
            column(Periodo; Period)
            {
            }
            column(ShowTable; ShowTable)
            {
            }

            trigger OnAfterGetRecord();
            var
                lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
                lclRecCheckLedgerEntry: Record "Check Ledger Entry";
            begin
                //Documento Liquidado
                lclRecVendorLedgerEntry.Reset();
                lclRecVendorLedgerEntry.SetRange("Vendor No.", "Detailed Retention Ledg. Entry"."Vendor No.");
                lclRecVendorLedgerEntry.SetRange("External Document No.", "Detailed Retention Ledg. Entry"."Vendor External Document No.");
                lclRecVendorLedgerEntry.SetRange(Reversed, false);
                if lclRecVendorLedgerEntry.FINDSET then begin
                    LastEntryNo += 1;
                    DtldRetentionLedgEntry.Init();
                    DtldRetentionLedgEntry."Entry No." := LastEntryNo;
                    DtldRetentionLedgEntry."Retention Posting Date" := lclRecVendorLedgerEntry."Document Date"; //Fecha Emision
                    DtldRetentionLedgEntry."Vendor External Document No." := lclRecVendorLedgerEntry."External Document No."; //Documento (Numero Doc. Comprobante a pagar)
                    DtldRetentionLedgEntry."Vendor Document No." := 'Documento Pagar'; //Nro. Documento del Diario
                    case lclRecVendorLedgerEntry."Legal Document" of
                        '01':
                            DtldRetentionLedgEntry."Vendor External Document No." := 'FAC ' + DtldRetentionLedgEntry."Vendor External Document No.";
                        '07':
                            DtldRetentionLedgEntry."Vendor External Document No." := 'NC ' + DtldRetentionLedgEntry."Vendor External Document No.";
                        '08':
                            DtldRetentionLedgEntry."Vendor External Document No." := 'ND ' + DtldRetentionLedgEntry."Vendor External Document No.";
                    end;
                    DtldRetentionLedgEntry."Retention No." := 'Compra'; //Tipo Operación
                    if not Reversed then begin
                        if "Detailed Retention Ledg. Entry"."Currency Code" <> '' then begin
                            if "Detailed Retention Ledg. Entry"."Amount Paid" < 0 then begin
                                DtldRetentionLedgEntry."Amount Invoice" := Abs("Detailed Retention Ledg. Entry"."Amount Paid");//Importe Debe USD
                                DtldRetentionLedgEntry."Amount Invoice LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Paid LCY");//Importe Debe S/.
                            end else begin
                                DtldRetentionLedgEntry."Amount Paid" := "Detailed Retention Ledg. Entry"."Amount Paid";//Importe Haber USD
                                DtldRetentionLedgEntry."Amount Paid LCY" := "Detailed Retention Ledg. Entry"."Amount Paid LCY";//Importe Haber S/.
                            end;
                        end else begin
                            if "Detailed Retention Ledg. Entry"."Amount Paid" < 0 then
                                DtldRetentionLedgEntry."Amount Invoice LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Paid")//Importe Debe S/.
                            else
                                DtldRetentionLedgEntry."Amount Paid LCY" := "Detailed Retention Ledg. Entry"."Amount Paid";//Importe Haber S/.
                        end;
                    end;
                    DtldRetentionLedgEntry."Retention No." := "Detailed Retention Ledg. Entry"."Retention No."; //Comporbante de Retencion
                    DtldRetentionLedgEntry."Currency Factor" := "Detailed Retention Ledg. Entry"."Currency Factor";//Tipo Cambio
                    DtldRetentionLedgEntry."Entry No." := 1;//Documento a liquidar se asigna el valor 1, para ordenar en el Layout
                    DtldRetentionLedgEntry."Vendor No." := "Detailed Retention Ledg. Entry"."Vendor No.";
                    DtldRetentionLedgEntry.Reversed := "Detailed Retention Ledg. Entry".Reversed;
                    DtldRetentionLedgEntry.Insert();
                end;

                //RETENCION
                LastEntryNo += 1;
                DtldRetentionLedgEntry.Init();
                DtldRetentionLedgEntry."Entry No." := LastEntryNo;
                DtldRetentionLedgEntry."Retention Posting Date" := "Detailed Retention Ledg. Entry"."Retention Posting Date"; //Fecha Emision
                DtldRetentionLedgEntry."Vendor External Document No." := 'RET ' + "Detailed Retention Ledg. Entry"."Retention No."; //Documento (Numero Doc. Comprobante a pagar)
                DtldRetentionLedgEntry."Vendor Document No." := "Detailed Retention Ledg. Entry"."Vendor Document No."; //Nro. Documento del Diario
                DtldRetentionLedgEntry."Retention No." := 'Retencion'; //Tipo Operación
                if not Reversed then begin
                    if "Detailed Retention Ledg. Entry"."Currency Code" <> '' then begin
                        if "Detailed Retention Ledg. Entry"."Amount Retention" < 0 then begin
                            DtldRetentionLedgEntry."Amount Invoice" := Abs("Detailed Retention Ledg. Entry"."Amount Retention");//Importe Debe USD
                            DtldRetentionLedgEntry."Amount Invoice LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Retention LCY");//Importe Debe S/.
                        end else begin
                            DtldRetentionLedgEntry."Amount Paid" := "Detailed Retention Ledg. Entry"."Amount Retention";//Importe Haber USD
                            DtldRetentionLedgEntry."Amount Paid LCY" := "Detailed Retention Ledg. Entry"."Amount Retention LCY";//Importe Haber S/.
                        end;
                    end else begin
                        if "Detailed Retention Ledg. Entry"."Amount Retention" < 0 then
                            DtldRetentionLedgEntry."Amount Invoice LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Retention")//Importe Debe S/.
                        else
                            DtldRetentionLedgEntry."Amount Paid LCY" := "Detailed Retention Ledg. Entry"."Amount Retention";//Importe Haber S/.
                    end;
                end;
                DtldRetentionLedgEntry."Retention No." := "Detailed Retention Ledg. Entry"."Retention No."; //Comporbante de Retencion
                DtldRetentionLedgEntry."Currency Factor" := "Detailed Retention Ledg. Entry"."Currency Factor";//Tipo Cambio
                if not Reversed then
                    DtldRetentionLedgEntry."Amount Retention" := "Detailed Retention Ledg. Entry"."Amount Retention" * -1;
                DtldRetentionLedgEntry."Vendor No." := "Detailed Retention Ledg. Entry"."Vendor No.";
                DtldRetentionLedgEntry."Entry No." := 2;//Retención se asigna el valor 1, para ordenar en el Layout
                DtldRetentionLedgEntry.Reversed := "Detailed Retention Ledg. Entry".Reversed;
                DtldRetentionLedgEntry.Insert();

                //Pago a Proveedor
                LastEntryNo += 1;
                DtldRetentionLedgEntry.Init();
                DtldRetentionLedgEntry."Entry No." := LastEntryNo;
                DtldRetentionLedgEntry."Retention Posting Date" := "Detailed Retention Ledg. Entry"."Retention Posting Date"; //Fecha Emision
                DtldRetentionLedgEntry."Vendor External Document No." := "Detailed Retention Ledg. Entry"."Retention No."; //Documento (Numero Doc. Comprobante a pagar)
                DtldRetentionLedgEntry."Vendor Document No." := "Detailed Retention Ledg. Entry"."Vendor Document No."; //Nro. Documento del Diario
                lclRecCheckLedgerEntry.Reset();
                lclRecCheckLedgerEntry.SetRange("Check No.", DtldRetentionLedgEntry."Vendor Document No.");
                if lclRecCheckLedgerEntry.FINDSET then
                    if STRLEN(DtldRetentionLedgEntry."Vendor External Document No.") < 17 then
                        DtldRetentionLedgEntry."Vendor External Document No." := 'CHE ' + DtldRetentionLedgEntry."Vendor External Document No.";
                DtldRetentionLedgEntry."Retention No." := 'Pago Proveedor'; //Tipo Operación
                if not Reversed then begin
                    if "Detailed Retention Ledg. Entry"."Currency Code" <> '' then begin
                        if ("Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention") > 0 then begin
                            DtldRetentionLedgEntry."Amount Invoice" := "Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention";//Importe Debe USD
                            DtldRetentionLedgEntry."Amount Invoice LCY" := "Detailed Retention Ledg. Entry"."Amount Paid LCY" + "Detailed Retention Ledg. Entry"."Amount Retention LCY";//Importe Debe S/.
                        end else begin
                            DtldRetentionLedgEntry."Amount Paid" := Abs("Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention");//Importe Haber USD
                            DtldRetentionLedgEntry."Amount Paid LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Paid LCY" + "Detailed Retention Ledg. Entry"."Amount Retention LCY");//Importe Haber S/.
                        end;
                    end else begin
                        if ("Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention") > 0 then
                            DtldRetentionLedgEntry."Amount Invoice LCY" := "Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention"//Importe Debe S/.
                        else
                            DtldRetentionLedgEntry."Amount Paid LCY" := Abs("Detailed Retention Ledg. Entry"."Amount Paid" + "Detailed Retention Ledg. Entry"."Amount Retention");//Importe Haber S/.
                    end;
                end;
                DtldRetentionLedgEntry."Retention No." := "Detailed Retention Ledg. Entry"."Retention No."; //Comporbante de Retencion
                DtldRetentionLedgEntry."Currency Factor" := "Detailed Retention Ledg. Entry"."Currency Factor";//Tipo Cambio
                DtldRetentionLedgEntry."Vendor No." := "Detailed Retention Ledg. Entry"."Vendor No.";
                DtldRetentionLedgEntry."Entry No." := 3;//Retención se asigna el valor 1, para ordenar en el Layout
                DtldRetentionLedgEntry.Reversed := "Detailed Retention Ledg. Entry".Reversed;
                DtldRetentionLedgEntry.Insert();
            end;

            trigger OnPreDataItem();
            begin
                CompanyInf.GET;
                DtldRetentionLedgEntry.DeleteAll();
                ;
                LastEntryNo := 0;
                if GroupOptionReport = GroupOptionReport::"Vendor Group" then
                    ShowTable := 'Agrupado Proveedor'
                else
                    ShowTable := 'Comprobante Retencion';
            end;
        }
        dataitem("Integer"; "Integer")
        {
            column(FechaEmision; DtldRetentionLedgEntry."Retention Posting Date")
            {
            }
            column(Documento; DtldRetentionLedgEntry."Vendor External Document No.")
            {
            }
            column(DocumentoDiario; DtldRetentionLedgEntry."Vendor Document No.")
            {
            }
            column(TipoOperacion; DtldRetentionLedgEntry."Retention No.")
            {
            }
            column(ImporteDebeUSD; DtldRetentionLedgEntry."Amount Invoice")
            {
            }
            column(ImporteHaberUSD; DtldRetentionLedgEntry."Amount Paid")
            {
            }
            column(SaldoUSD; NetAmountUSD)
            {
            }
            column(TipoCombio; DtldRetentionLedgEntry."Currency Factor")
            {
            }
            column(ImporteDebeDL; DtldRetentionLedgEntry."Amount Invoice LCY")
            {
            }
            column(ImporteHaberDL; DtldRetentionLedgEntry."Amount Paid LCY")
            {
            }
            column(SaldoDL; NetAmountLCY)
            {
            }
            column(TotalRetenido; DtldRetentionLedgEntry."Amount Retention")
            {
            }
            column(DocumentoRetencion; DtldRetentionLedgEntry."Retention No.")
            {
            }
            column(Linea; DtldRetentionLedgEntry."Entry No.")
            {
            }
            column(RucProveedor; DtldRetentionLedgEntry."Vendor No.")
            {
            }
            column(NombreProveedor; Vendor.Name)
            {
            }
            column(TotalRetencionesSoles; RetentionAmtLCY)
            {
            }
            column(TotalRetencionesUSD; TotalRetentionUSD)
            {
            }
            column(TotalPagoProveedorSoles; VendorTotalAmountPaymentLCY)
            {
            }
            column(TotalPagoProveedorUSD; VendorTotalAmountPaymentUSD)
            {
            }
            column(TotalPeriodoPagoProveedoresSoles; TotalPeriodVendorAmtLCY)
            {
            }
            column(TotalPeriodoPagoProveedoresUSD; TotalPeriodVendorAmtUSD)
            {
            }
            column(TotalPeriodoRetencionSoles; TotalPeriodRetentionAmtLCY)
            {
            }
            column(TotalPeriodoRetencionUSD; TotalPeriodRetentionAmtUSD)
            {
            }
            column(Anulado; Anulled)
            {
            }

            trigger OnAfterGetRecord();
            begin
                if Number = 1 then
                    DtldRetentionLedgEntry.FindFirst()
                else
                    DtldRetentionLedgEntry.Next();

                Vendor.Get(DtldRetentionLedgEntry."Vendor No.");

                if DtldRetentionLedgEntry.Reversed then
                    Anulled := '***ANULADO***'
                else
                    Anulled := '';

                if LastRetentionNo <> DtldRetentionLedgEntry."Retention No." then begin
                    CLEAR(NetAmountUSD);
                    CLEAR(NetAmountLCY);
                    NetAmountLCY := DtldRetentionLedgEntry."Amount Paid LCY" - DtldRetentionLedgEntry."Amount Invoice LCY"; //Haber DL - Debe DL
                    NetAmountUSD := DtldRetentionLedgEntry."Amount Paid" - DtldRetentionLedgEntry."Amount Invoice"; //Haber USD - Debe USD
                    LastRetentionNo := DtldRetentionLedgEntry."Retention No.";
                end else begin
                    NetAmountLCY += DtldRetentionLedgEntry."Amount Paid LCY" - DtldRetentionLedgEntry."Amount Invoice LCY"; //Haber DL - Debe DL
                    NetAmountUSD += DtldRetentionLedgEntry."Amount Paid" - DtldRetentionLedgEntry."Amount Invoice"; //Haber USD - Debe USD
                    LastRetentionNo := DtldRetentionLedgEntry."Retention No.";
                end;

                if GroupOptionReport = GroupOptionReport::"Vendor Group" then begin
                    DtldRetentionLedgEntry2.Reset();
                    DtldRetentionLedgEntry2.SetCurrentKey("Vendor No.", "Retention No.");
                    DtldRetentionLedgEntry2.SetRange("Vendor No.", DtldRetentionLedgEntry."Vendor No.");
                    DtldRetentionLedgEntry2.SetRange("Retention No.", 'RETENCION');
                    DtldRetentionLedgEntry2.CalcSums("Amount Invoice", "Amount Invoice LCY", "Amount Paid", "Amount Paid LCY");
                    RetentionAmtLCY := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid LCY") - Abs(DtldRetentionLedgEntry2."Amount Invoice LCY")); //Haber - Debe soles
                    TotalRetentionUSD := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid") - Abs(DtldRetentionLedgEntry2."Amount Invoice"));//Haber - Debe Dolares

                    DtldRetentionLedgEntry2.Reset();
                    DtldRetentionLedgEntry2.SetCurrentKey("Vendor No.", "Retention No.");
                    DtldRetentionLedgEntry2.SetRange("Vendor No.", DtldRetentionLedgEntry."Vendor No.");
                    DtldRetentionLedgEntry2.SetRange("Retention No.", 'PAGO PROVEEDOR');
                    DtldRetentionLedgEntry2.CalcSums("Amount Invoice", "Amount Invoice LCY", "Amount Paid", "Amount Paid LCY");
                    VendorTotalAmountPaymentLCY := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid LCY") - Abs(DtldRetentionLedgEntry2."Amount Invoice LCY")); //Haber - Debe soles
                    VendorTotalAmountPaymentUSD := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid") - Abs(DtldRetentionLedgEntry2."Amount Invoice"));//Haber - Debe Dolares

                end;

                DtldRetentionLedgEntry2.Reset();
                DtldRetentionLedgEntry2.SetCurrentKey("Retention No.");
                DtldRetentionLedgEntry2.SetRange("Retention No.", 'RETENCION');
                DtldRetentionLedgEntry2.CalcSums("Amount Invoice", "Amount Invoice LCY", "Amount Paid", "Amount Paid LCY");
                TotalPeriodRetentionAmtLCY := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid LCY") - Abs(DtldRetentionLedgEntry2."Amount Invoice LCY")); //Haber - Debe soles
                TotalPeriodRetentionAmtUSD := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid") - Abs(DtldRetentionLedgEntry2."Amount Invoice"));//Haber - Debe Dolares

                DtldRetentionLedgEntry2.Reset();
                DtldRetentionLedgEntry2.SetCurrentKey("Retention No.");
                DtldRetentionLedgEntry2.SetRange("Retention No.", 'PAGO PROVEEDOR');
                DtldRetentionLedgEntry2.CalcSums("Amount Invoice", "Amount Invoice LCY", "Amount Paid", "Amount Paid LCY");
                TotalPeriodVendorAmtLCY := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid LCY") - Abs(DtldRetentionLedgEntry2."Amount Invoice LCY")); //Haber - Debe soles
                TotalPeriodVendorAmtUSD := Abs(Abs(DtldRetentionLedgEntry2."Amount Paid") - Abs(DtldRetentionLedgEntry2."Amount Invoice"));//Haber - Debe Dolares
            end;

            trigger OnPreDataItem();
            begin
                DtldRetentionLedgEntry.Reset();
                if DtldRetentionLedgEntry.FINDSET then
                    repeat
                        DtldRetentionLedgEntry2.Init();
                        DtldRetentionLedgEntry2.TRANSFERFIELDS(DtldRetentionLedgEntry);
                        DtldRetentionLedgEntry2.Insert();
                    until DtldRetentionLedgEntry.NEXT = 0;

                DtldRetentionLedgEntry.SetCurrentKey("Retention No.", "Entry No.");

                SetRange(Number, 1, DtldRetentionLedgEntry.COUNT);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Periodo; Period)
                {
                    ApplicationArea = All;
                    Caption = 'Periodo';
                }
                field(GroupOptionReport; GroupOptionReport)
                {
                    ApplicationArea = All;
                    Caption = 'Mostrar';
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
        CompanyInf: Record "Company Information";
        DtldRetentionLedgEntry: Record "Detailed Retention Ledg. Entry" temporary;
        DtldRetentionLedgEntry2: Record "Detailed Retention Ledg. Entry" temporary;
        Vendor: Record Vendor;
        LastRetentionNo: Code[20];
        GroupOptionReport: Option "Vendor Group","Retention Group";
        LastEntryNo: Integer;
        NetAmountUSD: Decimal;
        NetAmountLCY: Decimal;
        RetentionAmtLCY: Decimal;
        TotalRetentionUSD: Decimal;
        VendorTotalAmountPaymentLCY: Decimal;
        VendorTotalAmountPaymentUSD: Decimal;
        TotalPeriodRetentionAmtLCY: Decimal;
        TotalPeriodRetentionAmtUSD: Decimal;
        TotalPeriodVendorAmtLCY: Decimal;
        TotalPeriodVendorAmtUSD: Decimal;
        Period: Text[30];
        Anulled: Text;
        ShowTable: Text;
}

