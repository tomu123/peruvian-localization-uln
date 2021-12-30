pageextension 51246 "ST FA Ledger Entries" extends "FA Ledger Entries"
{
    layout
    {
        addbefore("FA Posting Date")
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Source Currency Code"; "Source Currency Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Source Amount"; "Source Amount")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Source Exchange rate"; "Source Exchange rate")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}