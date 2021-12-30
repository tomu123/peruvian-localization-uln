pageextension 51219 "BP Purchase Order List" extends "Purchase Order List"
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
        addafter(Status)
        {
            field("Excede Presupuesto contable"; "Excede Presupuesto contable")
            {
                ApplicationArea = All;
                Importance = Additional;
                Editable = false;
                Visible = true;
            }
        }
    }


    actions
    {
        // Add changes to page actions here
    }

    var
        CUPurchValidate: Codeunit "PR Purchase Validate";

    trigger OnAfterGetRecord()
    begin
        // CUPurchValidate.SearchAndUpdate(Rec);
    end;

    trigger OnOpenPage()
    begin
        //FilterGroup(4);
        SetFilter("Assigned User ID", UserId);
        //FilterGroup(0)
    end;
}