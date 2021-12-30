report 51032 "Cashbook and Bank Acct. Cdr."
{
    //LIBRO 1.2
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Cashbook and Bank Acct. Cdr.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Cashbook and Bank Acct. Cdr.', Comment = 'ESM="Libro Caja y Bancos Cta. Cte."';

    dataset
    {
        dataitem(Cuenta; "G/L Account")
        {
            DataItemTableView = WHERE("No." = FILTER('104*' | '106*' | '107*'));
            column(UserInfo; UsuarioInfo)
            {
            }
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(empresa; empresa)
            {
            }
            column(BankName; gBankName)
            {
            }
            column(BankSunat; gBankSunat)
            {
            }
            column(BankAccNo; gBankAccNo)
            {
            }
            column(CodCtaCte; CodCtaCte)
            {
            }
            column(ruc; ruc)
            {
            }
            column(MesPeriodo; MesPeriodo)
            {
            }
            column(Cuenta_Cuenta_Name; Cuenta.Name)
            {
            }
            column(Cuenta_Cuenta__No__; Cuenta."No.")
            {
            }
            column(SaldoIniDeudor; SaldoIniDeudor)
            {
            }
            column(SaldoIniAcreedor; SaldoIniAcreedor)
            {
            }
            column(Cuenta_Cuenta_Name_Control1000000017; Cuenta.Name)
            {
            }
            column(Cuenta_Cuenta__No___Control1000000026; Cuenta."No.")
            {
            }
            column(SaldoFinalDeudorFooter; SaldoFinalDeudorFooter)
            {
            }
            column(TotalFinalCtaDeudorFooter; TotalFinalCtaDeudorFooter)
            {
            }
            column(SaldoFinalAcreedorFooter; SaldoFinalAcreedorFooter)
            {
            }
            column(TotalFinalCtaAcreedorFooter; TotalFinalCtaAcreedorFooter)
            {
            }
            column(MensajeErrorFinal; MensajeErrorFinal)
            {
            }
            column(MensajeCtasConError; MensajeCtasConError)
            {
            }
            column(RAZON_SOCIALCaption; RAZON_SOCIALCaptionLbl)
            {
            }
            column(RUCCaption; RUCCaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_LA_CUENTA_CORRIENTECaption; LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_LA_CUENTA_CORRIENTECaptionLbl)
            {
            }
            column(ACREEDORCaption; ACREEDORCaptionLbl)
            {
            }
            column(SALDOS_Y_MOVIMIENTOSCaption; SALDOS_Y_MOVIMIENTOSCaptionLbl)
            {
            }
            column(DEUDORCaption; DEUDORCaptionLbl)
            {
            }
            column(DENOMINACIONCaption; DENOMINACIONCaptionLbl)
            {
            }
            column(CUENTA_CONTABLE_ASOCIADACaption; CUENTA_CONTABLE_ASOCIADACaptionLbl)
            {
            }
            column(CODIGOCaption; CODIGOCaptionLbl)
            {
            }
            column(OPERACIONES_BANCARIASCaption; OPERACIONES_BANCARIASCaptionLbl)
            {
            }
            column(FECHA_DE_LA_OPERACIONCaption; FECHA_DE_LA_OPERACIONCaptionLbl)
            {
            }
            column(No__ASIENTOCaption; No__ASIENTOCaptionLbl)
            {
            }
            column(MEDIO_PAGOCaption; MEDIO_PAGOCaptionLbl)
            {
            }
            column(DESCRIPCION_OPERACIONCaption; DESCRIPCION_OPERACIONCaptionLbl)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIALCaption; DENOMINACION_O_RAZON_SOCIALCaptionLbl)
            {
            }
            column(NUM__TRANS_Caption; NUM__TRANS_CaptionLbl)
            {
            }
            column(Saldo_InicialCaption; Saldo_InicialCaptionLbl)
            {
            }
            column(Saldo_FinalCaption; Saldo_FinalCaptionLbl)
            {
            }
            column(Total_Final_x_CuentaCaption; Total_Final_x_CuentaCaptionLbl)
            {
            }
            column(Suma_y_Sigue__Caption; Suma_y_Sigue__CaptionLbl)
            {
            }
            column(TOTAL_SALDO_FINAL_Caption; TOTAL_SALDO_FINAL_CaptionLbl)
            {
            }
            column(TOTAL_FINAL_X_CUENTACaption_Control1000000001; TOTAL_FINAL_X_CUENTACaption_Control1000000001Lbl)
            {
            }
            column(TFTotalDebitAmt; TFTotalDebitAmt)
            {
            }
            column(TFTotalCreditAmt; TFTotalCreditAmt)
            {
            }
            column(SaldoFinalDetalle; SaldoFinalDetalle)
            {
            }
            column(sumaCredit; sumaCredit)
            {
            }
            column(sumaDebit; sumaDebit)
            {
            }
            column(PrintDate; gPrintDate)
            {
            }
            column(dSaldoIniDeudorTotal; dSaldoIniDeudorTotal)
            {
            }
            column(dSaldoIniAcreedorTotal; dSaldoIniAcreedorTotal)
            {
            }
            column(iflag; iflag)
            {
            }
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("Posting Date")
                                    ORDER(Ascending);
                RequestFilterFields = "G/L Account No.", "Posting Date";
                column(G_L_Entry__Posting_Date_; "Posting Date")
                {
                }
                column(G_L_Entry__G_L_Entry___Transaction_No__; "G/L Entry"."Transaction No.")
                {
                }
                column(G_L_Entry__G_L_Entry___G_L_Account_No__; "G/L Entry"."G/L Account No.")
                {
                }
                column(G_L_Entry__Debit_Amount_; "Debit Amount")
                {
                }
                column(G_L_Entry__Credit_Amount_; "Credit Amount")
                {
                }
                column(SaldoFinAcreedor; SaldoFinAcreedor)
                {
                }
                column(SaldoFinDeudor; SaldoFinDeudor)
                {
                }
                column(G_L_Entry__G_L_Entry__Description; "G/L Entry".Description)
                {
                }
                column(G_L_Entry__G_L_Entry___Document_No__; "G/L Entry"."Document No.")
                {
                }
                column(MensajeError; MensajeError)
                {
                }
                column(MedioPago2; MedioPago)
                {
                }
                column(Total_Mov__x_CuentaCaption; Total_Mov__x_CuentaCaptionLbl)
                {
                }
                column(TFCuentaHaber; TFCuentaHaber)
                {
                }
                column(TFCuentaDebe; TFCuentaDebe)
                {
                }
                column(G_L_Entry_Entry_No_; "Entry No.")
                {
                }
                dataitem("<G/L Entry 2>"; "G/L Entry")
                {
                    DataItemLink = "Document No." = FIELD("Document No."),
                                   "Posting Date" = FIELD("Posting Date"),
                                   "Transaction No." = FIELD("Transaction No.");
                    DataItemTableView = SORTING("Posting Date")
                                        ORDER(Ascending);
                    column(SaldoTotalIniAcreedor; gSaldoTotalIniAcreedor)
                    {
                    }
                    column(SaldoTotalIniDeudor; gSaldoTotalIniDeudor)
                    {
                    }
                    column(DetalleDebit; DetalleDebit)
                    {
                    }
                    column(DetalleCredit; DetalleCredit)
                    {
                    }
                    column(NameAccountDetalle; NameAccountDetalle)
                    {
                    }
                    column(TransCredit; TransCredit)
                    {
                    }
                    column(TransDebit; TransDebit)
                    {
                    }
                    column(G_L_Entry_2___G_L_Account_No__; "G/L Account No.")
                    {
                    }
                    column(G_L_Entry___Entry_No__; "G/L Entry"."Entry No.")
                    {
                    }
                    column(G_L_Entry_2__Description; Description)
                    {
                    }
                    column(descripcionOperacion; descripcionOperacion)
                    {
                    }
                    column(iValItem; iValItem)
                    {
                    }
                    column(G_L_Entry_2___Posting_Date_; "Posting Date")
                    {
                    }
                    column(G_L_Entry_2___Transaction_No__; "Transaction No.")
                    {
                    }
                    column(G_L_Entry_2__Entry_No_; "Entry No.")
                    {
                    }
                    column(G_L_Entry_2__Document_No_; "Document No.")
                    {
                    }
                    column(ExternalDocumentNo_GLEntry2; "<G/L Entry 2>"."External Document No.")
                    {
                    }
                    column(DenomRazonSocial; gDescripcion)
                    {
                    }
                    column(MedioPago; MedioPago)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        IF skipReporte = TRUE THEN BEGIN
                            CurrReport.SKIP;
                        END;

                        DetalleDebit := 0;
                        DetalleCredit := 0;
                        iValItem := 0;

                        DetalleDebit := "<G/L Entry 2>"."Debit Amount";
                        DetalleCredit := "<G/L Entry 2>"."Credit Amount";

                        IF "<G/L Entry 2>".Reversed = TRUE THEN BEGIN
                            IF ("<G/L Entry 2>"."Debit Amount" < 0) THEN BEGIN
                                DetalleCredit := ABS("<G/L Entry 2>"."Debit Amount");
                                DetalleDebit := ABS("<G/L Entry 2>"."Credit Amount");
                            END;
                            IF ("<G/L Entry 2>"."Credit Amount" < 0) THEN BEGIN
                                DetalleDebit := ABS("<G/L Entry 2>"."Credit Amount");
                                DetalleCredit := ABS("<G/L Entry 2>"."Debit Amount");
                            END;
                        END;

                        sumaDebit := sumaDebit + DetalleDebit;
                        sumaCredit := sumaCredit + DetalleCredit;

                        StrCuenta := COPYSTR("G/L Entry"."G/L Account No.", 1, 20);

                        TFTotalDebitAmt := TFTotalDebitAmt + DetalleDebit;
                        TFTotalCreditAmt := TFTotalCreditAmt + DetalleCredit;

                        TransDebit := TransDebit + "<G/L Entry 2>"."Debit Amount";
                        TransCredit := TransCredit + "<G/L Entry 2>"."Credit Amount";

                        iValItem := 1;

                        "G/L Account".RESET;
                        "G/L Account".SETRANGE("G/L Account"."No.", "<G/L Entry 2>"."G/L Account No.");
                        "G/L Account".FIND('-');
                        NameAccountDetalle := "G/L Account".Name;

                        MedioPago := '';
                        DenomRazonSocial := '';
                        NumTX := '';
                        // MedioPago := "Payment Method Code";

                        IF MedioPago = '' THEN BEGIN
                            GLEntry.RESET;
                            GLEntry.SETRANGE("Document No.", "<G/L Entry 2>"."Document No.");
                            GLEntry.SETFILTER("G/L Account No.", '%1', '10*');
                            // GLEntry.SETFILTER("Payment Method Code", '<>%1', '');
                            IF GLEntry.FINDSET THEN
                                MedioPago := '';// GLEntry."Payment Method Code";
                        END;

                        recCliente.RESET;
                        recCliente.SETCURRENTKEY("No.");
                        recCliente.SETRANGE(recCliente."No.", "<G/L Entry 2>"."Source No.");
                        IF recCliente.FINDSET THEN BEGIN
                            DenomRazonSocial := recCliente.Name;
                        END;

                        BankAccountLedgerEntry.RESET;
                        BankAccountLedgerEntry.SETRANGE("Document No.", "<G/L Entry 2>"."Document No.");
                        //BankAccountLedgerEntry.SETFILTER(Beneficiario, '<>%1', '');
                        IF BankAccountLedgerEntry.FINDSET THEN
                            gDescripcion := BankAccountLedgerEntry.Description// BankAccountLedgerEntry.Beneficiario
                        ELSE BEGIN
                            /*IF "G/L Entry".Beneficiario <> '' THEN
                                gDescripcion := "<G/L Entry 2>".Beneficiario
                            ELSE*/
                            gDescripcion := "<G/L Entry 2>".Description;
                        END;

                        IF DenomRazonSocial = '' THEN BEGIN
                            recVendor.RESET;
                            recVendor.SETCURRENTKEY("No.");
                            recVendor.SETRANGE(recVendor."No.", "<G/L Entry 2>"."Source No.");
                            IF recVendor.FINDSET THEN BEGIN
                                DenomRazonSocial := recVendor.Name;
                            END;
                        END;

                        IF DenomRazonSocial = '' THEN BEGIN
                            recBank.RESET;
                            recBank.SETCURRENTKEY("No.");
                            recBank.SETRANGE(recBank."No.", "<G/L Entry 2>"."Bal. Account No.");
                            IF recBank.FINDSET THEN BEGIN
                                DenomRazonSocial := recBank.Name;
                                CodigoBank := recBank."Transit No.";
                                CodigoCuentaCorriente := recBank."Bank Account No.";
                            END;
                        END;
                    end;

                    trigger OnPreDataItem()
                    begin
                        skipReporte := FALSE;
                        MensajeError := '';
                        IF vueltaUno = 0 THEN BEGIN
                            vueltaUno := 1;
                        END;
                        IF vueltaUno = 1 THEN BEGIN
                            fechaAnterior := "G/L Entry"."Posting Date";
                            documentoAnterior := "G/L Entry"."Document No.";
                            transaccionAnterior := "G/L Entry"."Transaction No.";
                        END;
                        IF vueltaUno <> 1 THEN BEGIN
                            IF ("G/L Entry"."Posting Date" = fechaAnterior) AND
                              ("G/L Entry"."Document No." = documentoAnterior) AND
                              ("G/L Entry"."Transaction No." = transaccionAnterior)
                              THEN BEGIN
                                skipReporte := TRUE;
                                CurrReport.SKIP;
                            END
                            ELSE BEGIN
                                fechaAnterior := "G/L Entry"."Posting Date";
                                documentoAnterior := "G/L Entry"."Document No.";
                                transaccionAnterior := "G/L Entry"."Transaction No.";
                            END
                        END
                        ELSE BEGIN
                            vueltaUno := 2;
                        END;

                        SETFILTER("G/L Account No.", '<>%1', "G/L Entry"."G/L Account No.");
                        SETFILTER("Document No.", '<>%1', 'APER*');
                        SETRANGE("Analityc Entry", FALSE);
                    end;
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(gDescripcion);
                    EncontroDifAsiento := FALSE;

                    SumaContrapartidas := 0;
                    GLEntrySumaContrapartida.RESET;
                    GLEntrySumaContrapartida.SETRANGE(GLEntrySumaContrapartida."Document No.", "Document No.");
                    GLEntrySumaContrapartida.SETRANGE(GLEntrySumaContrapartida."Posting Date", "Posting Date");
                    GLEntrySumaContrapartida.SETRANGE(GLEntrySumaContrapartida."Transaction No.", "Transaction No.");
                    IF GLEntrySumaContrapartida.FINDSET THEN BEGIN
                        REPEAT
                            SumaContrapartidas := SumaContrapartidas + GLEntrySumaContrapartida.Amount;
                        UNTIL GLEntrySumaContrapartida.NEXT = 0
                    END;
                    IF SumaContrapartidas <> 0 THEN BEGIN
                        EncontroDifAsiento := TRUE;
                    END;
                end;

                trigger OnPostDataItem()
                begin
                    SaldoFinal := ("G/L Entry"."Debit Amount" - "G/L Entry"."Credit Amount") + SaldoInicial;

                    IF SaldoFinal > 0 THEN
                        SaldoFinAcreedor := SaldoFinal
                    ELSE
                        SaldoFinDeudor := ABS(SaldoFinal);

                    TFCuentaDebe := TFTotalCreditAmt + SaldoIniDeudor + SaldoFinDeudor;
                    TFCuentaHaber := TFTotalDebitAmt + SaldoIniAcreedor + SaldoFinAcreedor;

                    SaldoFinalDetalle := (TFTotalCreditAmt - TFTotalDebitAmt) + SaldoInicial;

                    IF SaldoFinalDetalle <> SaldoFinal THEN BEGIN

                        MensajeError := 'REVISAR SALDOS....DETALLE.' + FORMAT(SaldoFinalDetalle) + '...CUENTA.' + FORMAT(SaldoFinal) +
                         '...DIF.' + FORMAT(ABS(SaldoFinalDetalle - SaldoFinal));
                        MensajeErrorFinal := 'NO CUADRAN LOS SALDOS DE CTA. BANCOS CON SALDO DE CTAS. CONTRAPARTIDAS.VERIFIQUE:';
                    END
                    ELSE BEGIN
                        MensajeError := '';
                    END;

                    iValItem := 0;
                end;

                trigger OnPreDataItem()
                begin
                    intPrimeraVuelta := 0;

                    SETFILTER("G/L Entry"."Posting Date", '%1..%2', FechaInicio, FechaFin);
                    SETRANGE("Analityc Entry", FALSE);
                    GLFilter := "G/L Entry".GETFILTERS;

                    SaldoIniAcreedor := 0;
                    SaldoIniDeudor := 0;
                    SaldoFinAcreedor := 0;
                    SaldoFinDeudor := 0;



                    gSaldoTotalIniDeudor := 0;
                    gSaldoTotalIniAcreedor := 0;

                    TFTotalCreditAmt := 0;
                    TFTotalDebitAmt := 0;

                    TFCuentaDebe := 0;
                    TFCuentaHaber := 0;

                    IF SaldoInicial > 0 THEN BEGIN
                        SaldoIniDeudor := ABS(SaldoInicial);
                        dSaldoIniDeudorTotal += SaldoIniDeudor;
                        iflag += 1;
                    END
                    ELSE BEGIN
                        SaldoIniAcreedor := ABS(SaldoInicial);
                        dSaldoIniAcreedorTotal += ABS(SaldoIniAcreedor);
                        iflag += 1;
                    END;

                    sumaDebit := sumaDebit + SaldoIniDeudor;
                    sumaCredit := sumaCredit + SaldoIniAcreedor;

                    glacc3.SETRANGE(glacc3."No.", "G/L Entry"."G/L Account No.");
                    IF glacc3.FIND('-') THEN BEGIN
                        NomCta := glacc3.Name;
                    END;

                    SETFILTER("Document No.", '<>%1', 'APER*');
                end;
            }

            trigger OnAfterGetRecord()
            var
                LCLglentry: Record "G/L Entry";
            begin
                gValidaReg := FALSE;
                gBankAccount.RESET;
                gBankAccount.SETAUTOCALCFIELDS("G/L Account No.");
                gBankAccount.SETRANGE("G/L Account No.", Cuenta."No.");
                IF NOT gBankAccount.FINDSET THEN CurrReport.SKIP;

                TotalDebit := 0;
                TotalCredit := 0;
                fechaantes := FechaInicio - 1;

                fechaantes := CLOSINGDATE(fechaantes);

                SaldoIniAcreedor := 0;
                SaldoIniDeudor := 0;
                gSaldoTotalIniAcreedor := 0;
                gSaldoTotalIniDeudor := 0;
                SaldoInicial := 0;
                SaldoFinal := 0;
                SaldoFinDeudor := 0;
                SaldoFinAcreedor := 0;
                TFCuentaDebe := 0;
                TFCuentaHaber := 0;



                "G/L Account".RESET;
                "G/L Account".SETRANGE("Date Filter", 0D, fechaantes);
                "G/L Account".SETFILTER("No.", "No.");
                IF "G/L Account".FIND('-') THEN BEGIN
                    "G/L Account".CALCFIELDS("Additional-Currency Net Change", "Net Change");
                    IF "G/L Account"."Net Change" > 0 THEN
                        SaldoIniDeudor := "G/L Account"."Net Change"
                    ELSE
                        SaldoIniAcreedor := ABS("G/L Account"."Net Change");

                    SaldoInicial := SaldoIniDeudor - SaldoIniAcreedor;
                    SaldoFinDeudor := SaldoIniAcreedor;
                    SaldoFinAcreedor := SaldoIniDeudor;
                    TFCuentaDebe := ABS(SaldoInicial);
                    TFCuentaHaber := ABS(SaldoInicial);
                END;
                LCLglentry.RESET;
                LCLglentry.SETRANGE("G/L Account No.", "No.");
                LCLglentry.SETFILTER("Document No.", '%1', 'APER*');
                LCLglentry.SETRANGE("Posting Date", FechaInicio, FechaFin);
                IF LCLglentry.FINDSET THEN
                    REPEAT
                        SaldoInicial += LCLglentry.Amount;
                    UNTIL LCLglentry.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                Cuenta.SETCURRENTKEY("No.");
                reccompany.SETRANGE(reccompany.Name);
                reccompany.FIND('-');
                empresa := reccompany.Name;
                ruc := reccompany."VAT Registration No.";

                IF FechaInicio = 0D THEN
                    ERROR('Ingresar Fecha de Inicio');

                IF FechaFin = 0D THEN
                    ERROR('Ingresar Fecha Final.');

                IF gBankNo <> '' THEN
                    IF gRecBank.GET(gBankNo) THEN BEGIN
                        gBankName := gRecBank.Name;
                        gBankSunat := gRecBank."Legal Document";
                        CodCtaCte := gRecBank."Bank Account No.";
                        IF gRecBankPostGroup.GET(gRecBank."Bank Acc. Posting Group") THEN BEGIN
                            gBankAccNo := gRecBankPostGroup."G/L Bank Account No.";
                            SETRANGE("No.", gBankAccNo);
                        END;
                    END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(gBankNo; gBankNo)
                {
                    Caption = 'Bank', Comment = 'ESM="Banco"';
                    TableRelation = "Bank Account"."No." WHERE("Bank Account No." = FILTER(<> ' '));
                }
                field(mosfr; mosfr)
                {
                    Caption = 'Aõo de Referencia', Comment = 'ESM="Aõo de Referencia"';

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            mescab := DATE2DMY(TODAY, 3)
                        END ELSE BEGIN
                            mescab := 0;
                        END;
                    end;
                }
                field(ARef; mescab)
                {
                    Caption = 'Aõo de Referencia', Comment = 'ESM="Aõo de Referencia"';
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Fecha de Referencia', Comment = 'ESM="Fecha de Referencia"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                    end;
                }
                field(FechaInicio; FechaInicio)
                {
                    Caption = 'Fecha Inicio', Comment = 'ESM="Fecha Inicio"';
                }
                field(FechaFin; FechaFin)
                {
                    Caption = 'Fecha Fin', Comment = 'ESM="Fecha Fin"';
                }
                field(MesPeriodo; MesPeriodo)
                {
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';
                }
                field(gPrintDate; gPrintDate)
                {
                    Caption = 'Fecha Impresión', Comment = 'ESM="Fecha Impresión"';
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

    trigger OnInitReport()
    begin
        TransDebit := 0;
        TransCredit := 0;

        SaldoFinalDeudorFooter := 0;
        SaldoFinalAcreedorFooter := 0;
        TotalFinalCtaDeudorFooter := 0;
        TotalFinalCtaAcreedorFooter := 0;
        dSaldoIniDeudorTotal := 0;
        dSaldoIniAcreedorTotal := 0;
        dSaldoIniDeudorTotaltmp := 0;
        dSaldoIniAcreedorTotaltmp := 0;
        iflag := 0;

        vueltaUno := 0;
        skipReporte := FALSE;
    end;

    var
        "G/L Account": Record "G/L Account";
        empresa: Text[250];
        ruc: Text[30];
        reccompany: Record "Company Information";
        Text1100005: Label 'There is not any period in this range of date';
        GLFilterAccType: Text[30];
        GLFilterAcc: Text[30];
        HeaderText: Text[40];
        GLFilter: Text[250];
        NameAcc: Text[30];
        Num: Integer;
        i: Integer;
        FromDate: Date;
        ToDate: Date;
        PostDate: Date;
        InitPeriodDate: Date;
        DateClose: Date;
        EndPeriodDate: Date;
        DateOpen: Date;
        LastDate: Date;
        NormPostDate: Date;
        PrintAmountsInAddCurrency: Boolean;
        Print: Boolean;
        PrintClosing: Boolean;
        HaveEntries: Boolean;
        NotFound: Boolean;
        Found: Boolean;
        Open: Boolean;
        TFTotalDebitAmt: Decimal;
        TFTotalCreditAmt: Decimal;
        TFGLBalance: Decimal;
        TD: Decimal;
        TC: Decimal;
        TB: Decimal;
        TotalDebit: Decimal;
        TotalBalance: Decimal;
        TotalCredit: Decimal;
        GLBalance: Decimal;
        CloseTotalDebitEntries: Decimal;
        CloseTotalCreditEntries: Decimal;
        CloseGLBalanceEntries: Decimal;
        TransDebit: Decimal;
        TransCredit: Decimal;
        NewPagePerAcc: Boolean;
        PreviusData: Boolean;
        IncludeAccountBalance: Boolean;
        GLAcc2: Record "G/L Account";
        IncludeZeroBalance: Boolean;
        GLFilterDim1: Code[20];
        GLFilterDim2: Code[20];
        LineNo: Integer;
        MaxLines: Integer;
        NotFooterHeader: Boolean;
        Text1100004: Label '';
        fechaantes: Date;
        NomCta: Text[100];
        glacc3: Record "G/L Account";
        intPrimeraVuelta: Integer;
        SaldoInicial: Decimal;
        Mes: Text[30];
        FechaInicio: Date;
        FechaFin: Date;
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        SaldoIniAcreedor: Decimal;
        SaldoIniDeudor: Decimal;
        SaldoFinAcreedor: Decimal;
        SaldoFinDeudor: Decimal;
        SaldoFinal: Decimal;
        MedioPago: Text[30];
        DenomRazonSocial: Text[150];
        NumTX: Text[30];
        NameAccountDetalle: Text[100];
        recCliente: Record Customer;
        recVendor: Record Vendor;
        recBank: Record "Bank Account";
        TFCuentaDebe: Decimal;
        TFCuentaHaber: Decimal;
        StrCuenta: Text[30];
        SaldoFinalDeudorFooter: Decimal;
        SaldoFinalAcreedorFooter: Decimal;
        TotalFinalCtaDeudorFooter: Decimal;
        TotalFinalCtaAcreedorFooter: Decimal;
        SaldoFinalFooterTemp: Decimal;
        descripcionOperacion: Text[1024];
        GLEntrySumaContrapartida: Record "G/L Entry";
        SumaContrapartidas: Decimal;
        EncontroDifAsiento: Boolean;
        fechaAnterior: Date;
        documentoAnterior: Text[100];
        transaccionAnterior: Integer;
        vueltaUno: Integer;
        skipReporte: Boolean;
        MensajeError: Text[500];
        SaldoFinalDetalle: Decimal;
        DetalleDebit: Decimal;
        DetalleCredit: Decimal;
        MensajeErrorFinal: Text[100];
        MensajeCtasConError: Text[1000];
        FechaImpresion: Date;
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        Text0001: Label 'Trial Balance';
        Text0002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        ExcelBuf: Record "Excel Buffer";
        PrintToExcel: Boolean;
        bExportarTxt: Boolean;
        outfile: File;
        //    folder: Automation;
        strDirectorio: Text[100];
        strFile: Text[100];
        CodigoBank: Text[2];
        CodigoCuentaCorriente: Text[30];
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        RAZON_SOCIALCaptionLbl: Label 'RAZON SOCIAL';
        RUCCaptionLbl: Label 'RUC';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        LIBRO_CAJA_Y_BANCOS___DETALLE_DE_LOS_MOVIMIENTOS_DE_LA_CUENTA_CORRIENTECaptionLbl: Label 'LIBRO CAJA Y BANCOS - DETALLE DE LOS MOVIMIENTOS DE LA CUENTA CORRIENTE';
        ACREEDORCaptionLbl: Label 'ACREEDOR';
        SALDOS_Y_MOVIMIENTOSCaptionLbl: Label 'SALDOS Y MOVIMIENTOS';
        DEUDORCaptionLbl: Label 'DEUDOR';
        DENOMINACIONCaptionLbl: Label 'DENOMINACION';
        CUENTA_CONTABLE_ASOCIADACaptionLbl: Label 'CUENTA CONTABLE ASOCIADA';
        CODIGOCaptionLbl: Label 'CODIGO';
        OPERACIONES_BANCARIASCaptionLbl: Label 'OPERACIONES BANCARIAS';
        FECHA_DE_LA_OPERACIONCaptionLbl: Label 'FECHA DE LA OPERACION';
        No__ASIENTOCaptionLbl: Label 'No. ASIENTO';
        MEDIO_PAGOCaptionLbl: Label 'MEDIO PAGO';
        DESCRIPCION_OPERACIONCaptionLbl: Label 'DESCRIPCION OPERACION';
        DENOMINACION_O_RAZON_SOCIALCaptionLbl: Label 'DENOMINACION O RAZON SOCIAL';
        NUM__TRANS_CaptionLbl: Label 'NUM. TRANS.';
        Saldo_InicialCaptionLbl: Label 'Saldo Inicial';
        Saldo_FinalCaptionLbl: Label 'Saldo Final';
        Total_Final_x_CuentaCaptionLbl: Label 'Total Final x Cuenta';
        Suma_y_Sigue__CaptionLbl: Label 'Suma y Sigue..';
        TOTAL_SALDO_FINAL_CaptionLbl: Label 'TOTAL SALDO FINAL ';
        TOTAL_FINAL_X_CUENTACaption_Control1000000001Lbl: Label 'TOTAL FINAL X CUENTA';
        Total_Mov__x_CuentaCaptionLbl: Label 'Total Mov. x Cuenta';
        iValItem: Integer;
        gBankNo: Code[20];
        gText001: Label 'Debe seleccionar un Banco';
        gBankAccNo: Code[20];
        gRecBank: Record "Bank Account";
        gRecBankPostGroup: Record "Bank Account Posting Group";
        gBankName: Text[50];
        gPrintDate: Date;
        CodCtaCte: Code[45];
        gBankAccount: Record "Bank Account";
        recGLENTRY: Record "G/L Entry";
        sumaCredit: Decimal;
        sumaDebit: Decimal;
        gSaldoTotalIniAcreedor: Decimal;
        gSaldoTotalIniDeudor: Decimal;
        gGLAccountBanck: Code[20];
        gValidaReg: Boolean;
        dSaldoIniDeudorTotal: Decimal;
        dSaldoIniAcreedorTotal: Decimal;
        iflag: Integer;
        dSaldoIniDeudorTotaltmp: Decimal;
        dSaldoIniAcreedorTotaltmp: Decimal;
        gDescripcion: Text;
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        GLEntry: Record "G/L Entry";
        gBankSunat: Text;

    procedure LookUpPeriodo()
    var
        recAccountingPeriod: Record "Accounting Period";
        fini: Date;
        ffin: Date;
    begin
        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod.SETFILTER(recAccountingPeriod."Starting Date", '>=%1&<=%2', fini, ffin);
        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN
            verperiodo := '';
        FechaInicio := 0D;
        FechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        FechaInicio := recAccountingPeriod."Starting Date";
        EVALUATE(FechaFin, FunctionFechaFin(recAccountingPeriod."Starting Date"));
        MesPeriodo := recAccountingPeriod.Name + ' del ' + FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaño": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaño := DATE2DMY(fechaing, 3);
        IF calaño MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
        END;
    end;
}

