pageextension 51066 "Ubigeo Order Address" extends "Order Address"
{
    layout
    {
        // Add changes to page layout here
        addafter("Address 2")
        {
            field(CountryRegionCode; "Country/Region Code")
            {
                ApplicationArea = All;
            }
        }
        modify("Country/Region Code")
        {
            Visible = false;
        }
        addafter(County)
        {
            field(UbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Country/Region Code", "Post Code", City, County))
            {
                ApplicationArea = All;
            }
        }
    }
    var
        UbigeoMgt: Codeunit "Ubigeo Management";
        record38: record 38;
        OrderAddr: Record "Order Address";
}