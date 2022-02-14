pageextension 51243 "ST Bank AccReconciliationLines" extends "Bank Acc. Reconciliation Lines"
{
    layout
    {

        addafter("Document No.")
        {
            field("Transaction Text"; "Transaction Text")
            {
                ApplicationArea = All;
                Editable = False;
            }
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
                Editable = False;
            }
        }
        addafter(Control16)
        {
            group(control96)
            {
                ShowCaption = false;
                field(gDiferencia; gDiferencia)
                {
                    Caption = 'Residuo final', Comment = 'ESM="Residuo final"';
                    Editable = false;
                    ApplicationArea = All;
                }
                group(control99)
                {
                    ShowCaption = false;
                }
            }
        }

        modify("Transaction Date")
        {
            Editable = False;
        }
        modify("Document No.")
        {
            Editable = False;
        }
        modify("Statement Amount")
        {
            Editable = False;
        }
        modify(Description)
        {
            Editable = False;
        }
        modify("Additional Transaction Info")
        {
            Editable = False;
        }
        modify(Type)
        {
            Editable = False;
        }
        modify("Applied Amount")
        {
            Editable = False;
        }
        modify(Difference)
        {
            Editable = False;
        }
        modify(TotalDiff)
        {
            Caption = 'Total Movimientos', Comment = 'ESM="Total Movimientos"';
            Editable = False;
        }

    }

    trigger OnAfterGetCurrRecord()
    var
    begin
        IF "Statement Line No." <> 0 THEN
            fnCalculateDiference();
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fnCalculateDiference();
    end;

    local procedure fnCalculateDiference()
    var
        TotalBalance: Decimal;
        TempBankAccReconLine: Record "Bank Acc. Reconciliation Line";
        BankAccRecon: Record "Bank Acc. Reconciliation";
        TotalDiff: Decimal;
        Balance: Decimal;

    begin
        gDiferencia := 0;
        IF BankAccRecon.GET("Statement Type", "Bank Account No.", "Statement No.") THEN;

        TempBankAccReconLine.COPY(Rec);

        TotalDiff := -Difference;
        IF TempBankAccReconLine.CALCSUMS(Difference) THEN BEGIN
            TotalDiff := TotalDiff + TempBankAccReconLine.Difference;

        END ELSE
            TotalBalance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
            TotalBalance := TotalBalance + TempBankAccReconLine."Statement Amount";

        END ELSE
            Balance := BankAccRecon."Balance Last Statement" - "Statement Amount";
        TempBankAccReconLine.SETRANGE("Statement Line No.", 0, (xRec."Statement Line No."));
        IF TempBankAccReconLine.CALCSUMS("Statement Amount") THEN BEGIN
            Balance := Balance + TempBankAccReconLine."Statement Amount";
        END;

        gDiferencia := (TotalBalance) - BankAccRecon."Statement Ending Balance";
    end;

    var
        gDiferencia: Decimal;
}