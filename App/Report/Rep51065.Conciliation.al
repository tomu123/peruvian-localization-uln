report 51065 Conciliacion
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Conciliacion.rdl';
    UsageCategory = Administration;
    ApplicationArea = All;
    dataset
    {
        dataitem("Bank Account Statement"; "Bank Account Statement")
        {
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CurrencyFactor; gCurrencyFactor)
            {
            }
            column(BankAccountNo_BankAccReconciliation; "Bank Account Statement"."Bank Account No.")
            {
            }
            column(StatementNo_BankAccReconciliation; "Bank Account Statement"."Statement No.")
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(StatementDate_BankAccReconciliation; "Bank Account Statement"."Statement Date")
            {
            }
            column(SaldoPerido; gBankAccount."Net Change")
            {
            }
            column(SaldoEstracto; "Bank Account Statement"."Statement Ending Balance")
            {
            }
            column(CurrecyCode; CurrecyCode)
            {
            }
            column(gFecha; gFecha)
            {
            }
            column(Saldo; gBankAccount."Net Change")
            {
            }
            column(SaldoLCY; gBankAccount."Net Change (LCY)")
            {
            }
            dataitem("Bank Account Statement Line"; "Bank Account Statement Line")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No."),
                               "Statement No." = FIELD("Statement No.");
                column(TransactionDate_BankAccReconciliationLine; "Bank Account Statement Line"."Transaction Date")
                {
                }
                column(Type_BankAccReconciliationLine; "Bank Account Statement Line"."Source Type")
                {
                }
                column(DocumentNo_BankAccReconciliationLine; "Bank Account Statement Line"."Document No.")
                {
                }
                column(Description_BankAccReconciliationLine; "Bank Account Statement Line".Description)
                {
                }
                column(AppliedAmount_BankAccReconciliationLine; "Bank Account Statement Line"."Statement Amount")
                {
                }
                column(CodOrigen; "Bank Account Statement Line"."Source Code")
                {
                }
                column(CheckNo_BankAccountStatementLine; "Bank Account Statement Line"."Check No.")
                {
                }
                column(Saldos; Saldos[1])
                {
                }
                column(Saldos2; Saldos[2])
                {
                }
                column(Saldos3; Saldos[3])
                {
                }
                column(Saldos4; Saldos[4])
                {
                }
                column(Saldos5; Saldos[5])
                {
                }
                column(Saldos6; Saldos[6])
                {
                }
                column(Saldos7; Saldos[7])
                {
                }
                column(Saldos8; Saldos[8])
                {
                }
                column(Saldos10; Saldos[10])
                {
                }
                column(Saldos12; Saldos[12])
                {
                }
                column(Imp1; Imp[1])
                {
                }
                column(Imp2; Imp[2])
                {
                }
                column(Flag; Flag)
                {
                }
                column(TotalAjusNeg; TotalAjusNeg)
                {
                }
                column(TotalAjustPos; TotalAjustPos)
                {
                }
                column(Estado; EstadoLineasConciliacion)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    CLEAR(Flag);

                    EstadoLineasConciliacion := TRUE;

                    Imp[1] := "Bank Account Statement Line"."Applied Amount";

                    IF "Bank Account Statement Line"."Entry Type" = "Bank Account Statement Line"."Entry Type"::Ajuste THEN BEGIN
                        Imp[1] := "Bank Account Statement Line".Difference;
                        Imp[2] := 0;
                    END
                    ELSE BEGIN
                        Imp[2] := "Bank Account Statement Line".Difference;
                        TotalDiferencia += "Bank Account Statement Line".Difference;
                    END;

                    CASE "Bank Account Statement Line"."Entry Type" OF
                        "Bank Account Statement Line"."Entry Type"::Cheque:
                            Flag := 'Cheques';
                        "Bank Account Statement Line"."Entry Type"::"Cheque Pendiente":
                            Flag := 'Cheques Pendientes';
                        "Bank Account Statement Line"."Entry Type"::Deposito:
                            IF UPPERCASE("Bank Account Statement Line"."Source Code") = UPPERCASE('DIACOBROS') THEN
                                Flag := 'Abonos'
                            ELSE
                                Flag := 'Cargos';
                        "Bank Account Statement Line"."Entry Type"::"Deposito Pendiente":
                            Flag := 'Depositos Pendientes';
                        "Bank Account Statement Line"."Entry Type"::Ajuste:
                            IF Imp[1] < 0 THEN BEGIN
                                Flag := 'Ajuste Negativo';
                                TotalAjusNeg += Imp[1];

                            END
                            ELSE
                                IF Imp[1] > 0 THEN BEGIN
                                    Flag := 'Ajuste Positivo';
                                    TotalAjustPos += Imp[1];
                                END
                    END;

                    //Flag :=  FORMAT("Bank Account Statement Line"."Entry Type");
                end;

                trigger OnPreDataItem()
                begin
                    //"Bank Acc. Reconciliation Line".CALCFIELDS("Applied Entries");
                    TotalDiferencia := 0;
                    TotalAjustPos := 0;
                    TotalAjusNeg := 0;
                end;
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = FIELD("Bank Account No.");
                DataItemTableView = SORTING("Bank Account No.", "Posting Date")
                                    ORDER(Ascending)
                                    WHERE(Open = FILTER(true));
                column(TransactionDate_BankAccReconciliationLine2; "Bank Account Ledger Entry"."Posting Date")
                {
                }
                column(Type_BankAccReconciliationLine2; "Bank Account Ledger Entry"."Document Type")
                {
                }
                column(DocumentNo_BankAccReconciliationLine2; "Bank Account Ledger Entry"."Document No.")
                {
                }
                column(Description_BankAccReconciliationLine2; "Bank Account Ledger Entry".Description)
                {
                }
                column(AppliedAmount_BankAccReconciliationLine2; "Bank Account Ledger Entry".Amount)
                {
                }
                column(Flag2; Flag2)
                {
                }
                column(Saldos9; Saldos[9])
                {
                }
                column(Saldos11; Saldos[11])
                {
                }
                column(TotalCheque; TotalCheque)
                {
                }
                column(TotalDeposito; TotalDeposito)
                {
                }
                column(TotalDiferencia; TotalDiferencia)
                {
                }
                column(Estado1; EstadoLineasConciliacion)
                {
                }

                trigger OnAfterGetRecord()
                begin

                    Flag := '';
                    "Bank Account Ledger Entry".CALCFIELDS("Bank Account Ledger Entry"."Check Ledger Entries");
                    IF "Bank Account Ledger Entry"."Check Ledger Entries" <> 0 THEN BEGIN
                        Flag2 := 'Cheques Pendientes';
                        TotalCheque += "Bank Account Ledger Entry".Amount;
                    END
                    ELSE BEGIN
                        Flag2 := 'Depositos Pendientes';
                        TotalDeposito += "Bank Account Ledger Entry".Amount;
                    END;

                    EstadoLineasConciliacion := TRUE;
                end;

                trigger OnPostDataItem()
                begin
                    //Saldos[11] := TotalCheque;
                    //Saldos[9] :=TotalDeposito;

                    Saldos[10] := gImporteEstracto - ABS(Saldos[9]);

                    Saldos[12] := gImporteEstracto - ABS(Saldos[11]);
                end;

                trigger OnPreDataItem()
                begin
                    //"Bank Account Ledger Entry".SETRANGE(Open,TRUE);
                    TotalCheque := 0;
                    TotalDeposito := 0;
                    SETRANGE(Reversed, FALSE);
                    "Bank Account Ledger Entry".SETFILTER("Posting Date", '..%1', "Bank Account Statement"."Statement Date");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                GetVariables("Bank Account Statement");
                Saldos[2] := 0;
                IF i = 0 THEN BEGIN
                    gBankAccount.RESET;
                    gBankAccount.SETRANGE("No.", "Bank Account No.");// gBanco);
                    gBankAccount.SETFILTER("Date Filter", '..%1', "Bank Account Statement"."Statement Date");
                    //<<JAA
                    gBankAccount.SETAUTOCALCFIELDS("Net Change", "Net Change (LCY)");
                    //>>JAA
                    IF gBankAccount.FINDSET THEN BEGIN
                        //gBankAccount.CALCFIELDS("Net Change");
                        CurrecyCode := gBankAccount."Currency Code";
                    END;
                END;
                gFecha := "Bank Account Statement"."Statement Date";
                i += 1;
                gBankAccStatLine.RESET;
                gBankAccStatLine.SETRANGE("Bank Account No.", "Bank Account No.");//gBanco);
                gBankAccStatLine.SETRANGE("Statement No.", "Bank Account Statement"."Statement No.");
                IF gBankAccStatLine.FINDSET THEN
                    REPEAT
                        //gBankAccStatLine.CALCSUMS("Amount (LCY)");
                        Saldos[2] += gBankAccStatLine."Statement Amount";
                    UNTIL gBankAccStatLine.NEXT = 0;
            end;

            trigger OnPreDataItem()
            begin
                //"Bank Account Statement".SETRANGE("Bank Account Statement"."Bank Account No.",gBanco);
                //"Bank Account Statement".SETRANGE("Bank Account Statement"."Statement No.",gStatement);
                //"Bank Account Statement".SETFILTER("Bank Account Statement"."Bank Account No.",'%1',gBanco);
                //"Bank Account Statement".SETFILTER("Bank Account Statement"."Statement No.",'%1',gStatement);
                EstadoLineasConciliacion := FALSE; //001
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(gbanco; gBanco)
                {
                    Caption = 'Bank Account', Comment = 'ESM="Banco"';
                    Editable = false;
                    Visible = false;
                }
                field(gStatement; gStatement)
                {
                    Caption = 'Statement';
                    Editable = false;
                    Visible = false;
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
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture)
    end;

    var
        CompanyInformation: Record "Company Information";
        Saldos: array[12] of Decimal;
        Imp: array[2] of Decimal;
        Flag: Text;
        gBankAccount: Record "Bank Account";
        gFecha: Date;
        gImporteEstracto: Decimal;
        gBanco: Code[20];
        gBankAccStatLine: Record "Bank Account Statement Line";
        gStatement: Code[10];
        gCurrencyFactor: Decimal;
        Flag2: Text[100];
        TotalCheque: Decimal;
        TotalDeposito: Decimal;
        TotalDiferencia: Decimal;
        CurrecyCode: Code[20];
        TotalAjustPos: Decimal;
        TotalAjusNeg: Decimal;
        i: Integer;
        EstadoLineasConciliacion: Boolean;
        d: Report 1496;

    procedure GetVariables(var pBankAccountStatement: Record "Bank Account Statement")
    var
        lclCurrencyExchangeRate: Record "Currency Exchange Rate";
    begin
        gFecha := pBankAccountStatement."Statement Date";
        gImporteEstracto := pBankAccountStatement."Statement Ending Balance";
        gBanco := pBankAccountStatement."Bank Account No.";
        gStatement := pBankAccountStatement."Statement No.";


        lclCurrencyExchangeRate.Reset();
        lclCurrencyExchangeRate.SetRange("Currency Code", 'USD');
        lclCurrencyExchangeRate.SetRange("Starting Date", pBankAccountStatement."Statement Date");
        lclCurrencyExchangeRate.FindSet();

        gCurrencyFactor := lclCurrencyExchangeRate."Relational Exch. Rate Amount";
    end;
}

