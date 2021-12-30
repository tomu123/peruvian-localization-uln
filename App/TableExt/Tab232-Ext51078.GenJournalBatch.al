tableextension 51078 "Setup Gen Journal Batch" extends "Gen. Journal Batch"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51002; "Bank Account No. FICO"; Code[20])
        {
            Caption = 'FICO Bank Account No.', Comment = 'ESM="Banco FICO"';
            TableRelation = "Bank Account"."No.";
            trigger OnValidate();
            var
                BankAccount: Record "Bank Account";
            begin
                if "Bank Account No. FICO" <> '' then
                    exit;
                BankAccount.Get("Bank Account No. FICO");
            end;
        }
        field(51003; Deposits; Boolean)
        {
            Caption = 'Deposits', Comment = 'ESM="Depósitos"';
        }
        field(51004; "Static Value"; Boolean)
        {
            Caption = 'Static Value', Comment = 'ESM="Valor estático"';
        }
        field(51005; "Is Batch Check"; Boolean)
        {
            Caption = 'Is Batch Check', Comment = 'ESM="Banco Cheque"';
        }
        field(51006; "Net Balance"; Decimal)
        {
            //AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Gen. Journal Line".Amount where("Journal Template Name" = field("Journal Template Name"),
                                                                "Journal Batch Name" = field(Name),
                                                                "Account Type" = filter(<> "Bank Account")));
            Caption = 'Net Balance', Comment = 'ESM="Saldo"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51007; "Net Balance (LCY)"; Decimal)
        {
            //AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Gen. Journal Line"."Amount (LCY)" where("Journal Template Name" = field("Journal Template Name"),
                                                                "Journal Batch Name" = field(Name),
                                                                "Account Type" = filter(<> "Bank Account")));
            Caption = 'Net Balance (LCY)', Comment = 'ESM="Saldo (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    var
        Page43: page 43;
        recor172: Record 172;
}
