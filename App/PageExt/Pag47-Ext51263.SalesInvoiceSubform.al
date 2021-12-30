pageextension 51263 "ST Sales Invoice Subform" extends "Sales Invoice Subform"
{
    layout
    {
        modify("Depreciation Book Code")
        {
            Visible = true;
        }
        modify("Duplicate in Depreciation Book")
        {
            Visible = true;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}