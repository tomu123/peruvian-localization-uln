pageextension 51266 "ST FA Deprec. Books Subform" extends "FA Depreciation Books Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("Depreciation Ending Date")
        {
            field("Current Asset"; "Current Asset")
            {
                ApplicationArea = all;
                trigger OnValidate()
                begin
                    CurrPage.Update();
                end;
            }
        }
        modify("Depreciation Starting Date")
        {
            Editable = not "Current Asset";
        }
        modify("No. of Depreciation Years")
        {
            Editable = not "Current Asset";
        }
        modify("Depreciation Ending Date")
        {
            Editable = not "Current Asset";
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}