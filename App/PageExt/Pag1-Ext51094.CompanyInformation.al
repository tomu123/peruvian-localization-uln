pageextension 51094 "LD Company Information" extends "Company Information"
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
        }
        addafter(County)
        {
            field(UbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Country/Region Code", "Post Code", City, County))
            {
                ApplicationArea = All;
            }
        }
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
        addbefore("VAT Registration No.")
        {
            field("VAT Registration Type"; "VAT Registration Type")
            {
                ApplicationArea = All;
                Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        UbigeoMgt: Codeunit "Ubigeo Management";
}