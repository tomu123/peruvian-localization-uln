pageextension 51064 "Ubigeo Location Card" extends "Location Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Address 2")
        {
            field(CountryRegionCode; "Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PostCode; "Post Code")
            {
                ApplicationArea = All;
            }
            field(City2; City)
            {
                ApplicationArea = All;
            }
            field(County; County)
            {
                ApplicationArea = All;
            }
            field(UbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Country/Region Code", "Post Code", City, County))
            {
                ApplicationArea = All;
            }
        }
        /*modify(Contr)
        {
            Visible = false;
        }*/
        //PosCode = Departamento
        //City = Provincia
        //County = County
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    var
        UbigeoMgt: Codeunit "Ubigeo Management";
}