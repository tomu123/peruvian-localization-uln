tableextension 51036 "Analityc Dimension Value" extends "Dimension Value"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Analityc"; Boolean)
        {
            Caption = 'Analityc';
            DataClassification = ToBeClassified;
        }
        field(51001; "Debit Analityc G/L Acc. No."; Code[20])
        {
            Caption = 'Debit Analityc Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
        field(51002; "Credit Analityc G/L Acc. No."; Code[20])
        {
            Caption = 'Credit Analityc Account No.';
            DataClassification = ToBeClassified;
            TableRelation = "G/L Account"."No.";
        }
    }

    var
        myInt: Integer;
}