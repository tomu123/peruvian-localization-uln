pageextension 51157 "ST Purch. Invoice Subform" extends "Purch. Invoice Subform"
{
    layout
    {
        // Add changes to page layout here
        addafter("VAT Prod. Posting Group")
        {
            field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
            {
                ApplicationArea = All;
            }
            field("Posting Group"; "Posting Group")
            {
                ApplicationArea = All;
            }
            field("Purchase Standard Code"; "Purchase Standard Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }

        modify("VAT Prod. Posting Group")
        {
            Visible = true;
        }

        //Import
        addafter("Variant Code")
        {
            // control with underlying datasource
            field("Importation No."; "Importation No.")
            {
                ApplicationArea = All;
            }
        }
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
