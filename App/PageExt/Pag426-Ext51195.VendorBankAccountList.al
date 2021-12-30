pageextension 51195 PageExtension50001 extends "Vendor Bank Account List"
{
    layout
    {
        addafter(Name)
        {
            field("Reference Bank Acc. No.42606"; "Reference Bank Acc. No.")
            {
                ApplicationArea = All;
            }
            field("Currency Code91366"; "Currency Code")
            {
                ApplicationArea = All;
            }
            field("Bank Account Type90696"; "Bank Account Type")
            {
                ApplicationArea = All;
            }
            field("Bank Account No.25525"; "Bank Account No.")
            {
                ApplicationArea = All;
            }
        }
        modify("Phone No.")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
    }
}
