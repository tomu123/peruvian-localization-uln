report 51054 "Reg.Act.Fijos-Det.Dif.Cambio"
{
    //LIBRO 7.3
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Reg.Act.Fijos-Det.Dif.Cambio.rdl';

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(RazonSocial; recCompanyInfo.Name)
            {
            }
            column(RUC; recCompanyInfo."VAT Registration No.")
            {
            }
            column(FechaInicio; gStartDate)
            {
            }
            column(FechaFinnal; gEndDate)
            {
            }
            column(YEAR; gYear)
            {
            }

            trigger OnPreDataItem()
            begin
                gYear := DATE2DMY(gEndDate, 3);
            end;
        }
        dataitem("FA Ledger Entry"; "FA Ledger Entry")
        {
            RequestFilterFields = "FA Posting Group";
            column(CodActivoFijo; "FA Ledger Entry"."FA No.")
            {
            }
            column(Modena; gCurrencyCode)
            {
            }
            column(FechaAdquisicion; gFechaAdquisicion)
            {
            }
            column(ValorAdqMoneExtranjera; gValorAdqMoneExtranjera)
            {
            }
            column(gValorAdqMoneExtranjera; gValorAdqMoneExtranjera)
            {
            }
            column(gTipoCambioEnFechaAdq; gTipoCambioEnFechaAdq)
            {
            }
            column(gValorAdqMonNacional; gValorAdqMonNacional)
            {
            }
            column(gTipoCambio3112; gTipoCambio3112)
            {
            }
            column(gAjusteXDiferenciaCambio; gAjusteXDiferenciaCambio)
            {
            }
            column(gValorModedaNacional; gValorModedaNacional)
            {
            }
            column(gDelEjercicio; gDelEjercicio)
            {
            }
            column(gDeRetirosYOBajas; gDeRetirosYOBajas)
            {
            }
            column(gDeOtrosAjustes; gDeOtrosAjustes)
            {
            }
            column(gAcumuladaHistorico; gAcumuladaHistorico)
            {
            }
            column(FAPostingGroup_FALedgerEntry; "FA Ledger Entry"."FA Posting Group")
            {
            }
            column(PAPostingGroupDescription; gAcquisitionCostAccount.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if not isCurrencyUSD() then
                    CurrReport.Skip();

                gFiltro1 := '';
                glRecDepBook.RESET;
                glRecDepBook.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                IF glRecDepBook.FINDFIRST THEN
                    gFiltro1 := glRecDepBook."Depreciation Book Code";

                IF (gFiltro1 = 'CONTABLE') AND (gFiltro1 <> '') AND (gOldNoAF <> "FA Ledger Entry"."FA No.") THEN BEGIN


                    //CALCFIELDS("FA Ledger Entry"."Currency Code");
                    gCurrencyCode := gCurrencyVendorLedgerEntry;

                    //
                    gFechaAdquisicion := "FA Ledger Entry"."Document Date";

                    //-------------------------------------------------------------------------------------------------
                    gValorAdqMoneExtranjera := 0;
                    gValorAdqMonNacional := 0;
                    gTipoCambioEnFechaAdq := 0;
                    gNroMovimiento := 0;
                    recMovProveedor.RESET;
                    recMovProveedor.SETRANGE(recMovProveedor."Document No.", "FA Ledger Entry"."Document No.");
                    IF recMovProveedor.FINDSET THEN BEGIN
                        recMovProveedor.CALCFIELDS(Amount, "Amount (LCY)", "Remaining Amt. (LCY)");

                        gNroMovimiento := recMovProveedor."Closed by Entry No.";

                        gPurchInvLine.RESET;
                        gPurchInvLine.SETRANGE("Document No.", recMovProveedor."Document No.");
                        gPurchInvLine.SETRANGE(Type, gPurchInvLine.Type::"Fixed Asset");
                        IF gPurchInvLine.FINDSET THEN BEGIN
                            //gPurchInvLine.CALCSUMS("Amount Including VAT");

                            //(A)--> VALOR. ADQ. EN MDA. EXTRANJERA.
                            gValorAdqMoneExtranjera := ABS(gPurchInvLine."Line Amount");
                            //(C)--> VALOR DE ADQ. EN MON. NACIONAL
                            gPurchInvHeader.RESET;
                            gPurchInvHeader.SETRANGE("No.", gPurchInvLine."Document No.");
                            IF gPurchInvHeader.FINDSET THEN BEGIN
                                gValorAdqMonNacional := ABS(gPurchInvLine."Line Amount" / gPurchInvHeader."Currency Factor");//PC 25.05.21 "Amount Including VAT"
                                gTipoCambioEnFechaAdq := ROUND(1 / (gPurchInvHeader."Currency Factor"), 0.001);
                            END;
                        END ELSE BEGIN
                            gPurchCrMemoLine.RESET;
                            gPurchCrMemoLine.SETRANGE("Document No.", recMovProveedor."Document No.");
                            gPurchCrMemoLine.SETRANGE(Type, gPurchCrMemoLine.Type::"Fixed Asset");
                            IF gPurchCrMemoLine.FINDSET THEN BEGIN
                                //(A)--> VALOR. ADQ. EN MDA. EXTRANJERA.
                                gValorAdqMoneExtranjera := ABS(gPurchCrMemoLine."Line Amount");//PC 25.05.21 "Amount Including VAT"
                                                                                               //(C)--> VALOR DE ADQ. EN MON. NACIONAL
                                gPurchCrMemoHdr.RESET;
                                gPurchCrMemoHdr.SETRANGE("No.", gPurchCrMemoLine."Document No.");
                                IF gPurchCrMemoHdr.FINDSET THEN BEGIN
                                    gValorAdqMonNacional := ABS(gPurchCrMemoLine."Line Amount" / gPurchCrMemoHdr."Currency Factor");//PC 25.05.21
                                    gTipoCambioEnFechaAdq := ROUND(1 / (gPurchCrMemoHdr."Currency Factor"), 0.001);
                                END;
                            END;
                        END;

                        IF recMovProveedor."Remaining Amt. (LCY)" = 0 THEN BEGIN
                            gCurrencyExchangeRate.RESET;
                            gCurrencyExchangeRate.SETRANGE("Starting Date", recMovProveedor."Closed at Date");
                            gCurrencyExchangeRate.SETRANGE("Currency Code", recMovProveedor."Closed by Currency Code");
                            IF gCurrencyExchangeRate.FINDSET THEN
                                gTipoCambio3112 := gCurrencyExchangeRate."Relational Exch. Rate Amount";
                        END;

                    END;

                    IF gTipoCambio3112 = 0 THEN BEGIN
                        gCurrencyExchangeRate.RESET;
                        gCurrencyExchangeRate.SETRANGE("Starting Date", gEndDate);
                        gCurrencyExchangeRate.SETRANGE("Currency Code", 'USD');
                        IF gCurrencyExchangeRate.FINDSET THEN
                            gTipoCambio3112 := gCurrencyExchangeRate."Relational Exch. Rate Amount";
                    END;


                    IF gTipoCambio3112 = 0 THEN BEGIN
                        recMovProveedor.RESET;
                        recMovProveedor.SETRANGE(recMovProveedor."Posting Date", gEndDate);
                        IF recMovProveedor.FINDSET THEN BEGIN
                            gTipoCambio3112 := ROUND(1 / recMovProveedor."Original Currency Factor", 0.001);
                        END;
                    END;


                    //(E)--> AJUSTE POR DIF. DE CAMBIO
                    gAjusteXDiferenciaCambio := 0;
                    gAjusteXDiferenciaCambio := (gValorAdqMoneExtranjera * gTipoCambioEnFechaAdq) - (gValorAdqMoneExtranjera * gTipoCambio3112);

                    //(F)--> VALOR EN MON. NACIONAL AL 3112
                    gValorModedaNacional := 0;
                    gValorModedaNacional := (gValorAdqMoneExtranjera * gTipoCambio3112);

                    //(G)--> DEL EJERCICIO

                    //--[Depreciación acumulada al cierre del ejercicio anterior.]
                    glDepAcumAnterior := 0;
                    gDelEjercicio := 0;
                    glLedgerEntry2.RESET;
                    glLedgerEntry2.SETRANGE("FA No.", "FA Ledger Entry"."FA No.");
                    glLedgerEntry2.SETRANGE("FA Posting Date", gStartDate, gEndDate);
                    IF glLedgerEntry2.FINDSET THEN
                        REPEAT
                            IF glLedgerEntry2."FA Posting Type" = glLedgerEntry2."FA Posting Type"::Depreciation THEN BEGIN
                                glDepAcumAnterior += ABS(glLedgerEntry2.Amount);
                            END;
                        UNTIL glLedgerEntry2.NEXT = 0;

                    gDelEjercicio := glDepAcumAnterior;

                    //(H)--> DE LOS RETIROS Y/O BAJAS

                    gDeRetirosYOBajas := 0;

                    //(I)--> DE OTROS AJUSTES
                    //--[Porcentaje de la depreciación]
                    glRecDepBook.RESET;
                    glPorcentajeDep := 0;
                    gDeOtrosAjustes := 0;
                    glRecDepBook.SETRANGE(glRecDepBook."FA No.", "FA Ledger Entry"."FA No.");
                    IF glRecDepBook.FINDSET THEN BEGIN
                        IF glRecDepBook."No. of Depreciation Years" <> 0 THEN BEGIN
                            glPorcentajeDep := ROUND(100 / glRecDepBook."No. of Depreciation Years", 0.01, '>');
                        END;
                    END;
                    gDeOtrosAjustes := ABS(gAjusteXDiferenciaCambio * (glPorcentajeDep / 100));

                    //(J)--> ACUMULADA HISTORICO
                    gAcumuladaHistorico := (gDelEjercicio + gDeRetirosYOBajas + gDeOtrosAjustes);
                END ELSE BEGIN
                    CurrReport.SKIP;
                END;

                gOldNoAF := "FA Ledger Entry"."FA No.";

                gFAPostingGroup.RESET;
                gFAPostingGroup.SETRANGE(Code, "FA Ledger Entry"."FA Posting Group");
                IF gFAPostingGroup.FINDSET THEN BEGIN
                    gAcquisitionCostAccount.Reset();
                    gAcquisitionCostAccount.SetRange("No.", gFAPostingGroup."Acquisition Cost Account");
                    if gAcquisitionCostAccount.FindSet() then begin end;
                END;
                //  gFAPostingGroup.CALCFIELDS(Description);
            end;

            trigger OnPreDataItem()
            begin
                gFiltro2 := "FA Ledger Entry".GETFILTER("FA Posting Group");
                IF gFiltro2 <> '' THEN
                    SETRANGE("FA Ledger Entry"."FA Posting Group", gFiltro2);
                SETRANGE("FA Posting Date", gStartDate, gEndDate);

                //CALCFIELDS("FA Ledger Entry"."Currency Code");
                //SETRANGE("FA Ledger Entry"."Currency Code", 'USD');
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Inicio"; gStartDate)
                {
                }
                field("Fecha Fin"; gEndDate)
                {
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

    trigger OnPreReport()
    begin
        recCompanyInfo.GET;
    end;

    local procedure isCurrencyUSD(): Boolean
    var
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        gCurrencyVendorLedgerEntry := '';
        lclVendorLedgerEntry.Reset();
        lclVendorLedgerEntry.SetRange("Document No.", "FA Ledger Entry"."Document No.");
        lclVendorLedgerEntry.SetRange("Posting Date", "FA Ledger Entry"."Posting Date");
        lclVendorLedgerEntry.SetRange("Currency Code", 'USD');
        if lclVendorLedgerEntry.FindSet() then begin
            gCurrencyVendorLedgerEntry := lclVendorLedgerEntry."Currency Code";
            exit(true);
        end
        else
            exit(false);

        exit(false);
    end;

    var
        gCurrencyVendorLedgerEntry: Text[20];
        recCompanyInfo: Record "Company Information";
        gStartDate: Date;
        gEndDate: Date;
        glRecDepBook: Record "FA Depreciation Book";
        glAdqGroup: Text;
        glPostingGroup: Record "FA Posting Group";
        gYear: Integer;
        gFechaAdquisicion: Date;
        gCurrencyCode: Code[10];
        recMovProveedor: Record "Vendor Ledger Entry";
        gValorAdqMoneExtranjera: Decimal;
        gTipoCambioEnFechaAdq: Decimal;
        gValorAdqMonNacional: Decimal;
        gTipoCambio3112: Decimal;
        gAjusteXDiferenciaCambio: Decimal;
        gValorModedaNacional: Decimal;
        gDelEjercicio: Decimal;
        gDeRetirosYOBajas: Decimal;
        gDeOtrosAjustes: Decimal;
        gAcumuladaHistorico: Decimal;
        gNroMovimiento: Integer;
        glPorcentajeDep: Decimal;
        glDepAcumAnterior: Decimal;
        glLedgerEntry2: Record "FA Ledger Entry";
        gFiltro1: Code[25];
        gOldNoAF: Code[35];
        gFiltro2: Code[35];
        gFAPostingGroup: Record "FA Posting Group";
        gCurrencyExchangeRate: Record "Currency Exchange Rate";
        gPurchInvHeader: Record "Purch. Inv. Header";
        gPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        gPurchInvLine: Record "Purch. Inv. Line";
        gPurchCrMemoLine: Record "Purch. Cr. Memo Line";
        gAcquisitionCostAccount: Record "G/L Account";
}

