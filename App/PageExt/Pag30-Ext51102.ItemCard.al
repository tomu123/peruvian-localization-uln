pageextension 51102 "Setup Item Card" extends "Item Card"
{
    layout
    {
        // Add changes to page layout here    
        addafter("No.")
        {

            field("No. 2"; "No. 2")
            {
                ApplicationArea = All;
            }

        }
        addlast("Prices & Sales")
        {

        }
        addafter(Warehouse)
        {
            group(SetupLocalization)
            {
                Caption = 'Setup Localization';
                field(FirstField; FirstField)
                {
                    Visible = false;
                    Editable = false;
                }
                field("Exclude Items Dll"; "Exclude Items Dll")
                {
                    Editable = true;
                    ApplicationArea = All;
                }
            }
            group(PeruvianBooks)
            {
                Caption = 'PLE';
                field("Type of Existence"; "Type of Existence")
                {
                    ApplicationArea = All;
                }
                field(Catalog; Catalog)
                {
                    ApplicationArea = All;
                }
                field("Existence Code BSO"; "Existence Code BSO")
                {
                    ApplicationArea = All;
                }
                field("Value Method"; "Value Method")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    var
        FirstField: Text;
}