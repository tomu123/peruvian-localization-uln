pageextension 51035 "Analityc Dimension Values" extends "Dimension Values"
{
    layout
    {
        // Add changes to page layout here
        addafter(Blocked)
        {
            field(Analityc; Analityc)
            {
                ApplicationArea = All;
            }
            field("Debit Analityc G/L Acc. No."; "Debit Analityc G/L Acc. No.")
            {
                ApplicationArea = All;
            }
            field("Credit Analityc G/L Acc. No."; "Credit Analityc G/L Acc. No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}