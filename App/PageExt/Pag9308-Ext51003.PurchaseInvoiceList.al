pageextension 51003 "Legal Doc. Purchase Invoices" extends "Purchase Invoices"
{
    layout
    {
        // Add changes to page layout here
        addafter("Buy-from Vendor Name")
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
            }
        }
        addafter(Amount)
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        FilterGroup(4);
        SetFilter("Legal Document", '<>%1', '02');
        FilterGroup(0);
    end;

    var
        myInt: Integer;
}