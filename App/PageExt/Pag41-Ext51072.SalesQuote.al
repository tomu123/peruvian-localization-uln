pageextension 51072 "Ubigeo Sales Quote" extends "Sales Quote"
{
    layout
    {
        // Add changes to page layout here
        //PosCode = Departamento
        //City = Provincia
        //County = County

        //******************************* BEGIN Sell-to ***********************************
        addafter("Sell-to Address 2")
        {
            field(BuyFromCountryRegionCode; "Sell-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(BuyFromPostCode; "Sell-to Post Code")
            {
                ApplicationArea = All;
            }
            field(BuyFromCity2; "Sell-to City")
            {
                ApplicationArea = All;
            }
            field(BuyFromCounty; "Sell-to County")
            {
                ApplicationArea = All;
            }
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Sell-to Country/Region Code", "Sell-to Post Code", "Sell-to City", "Sell-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Sell-to City")
        {
            Visible = false;
        }
        modify("Sell-to County")
        {
            Visible = false;
        }
        //******************************* END Sell-to *************************************

        //******************************* BEGIN Ship-to ***********************************
        addafter("Ship-to Address 2")
        {
            field(ShipToCountryRegionCode; "Ship-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(ShipToPostCode; "Ship-to Post Code")
            {
                ApplicationArea = All;
            }
            field(ShipToCity2; "Ship-to City")
            {
                ApplicationArea = All;
            }
            field(ShipToCounty; "Ship-to County")
            {
                ApplicationArea = All;
            }
            field(ShipToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Ship-to Country/Region Code", "Ship-to Post Code", "Ship-to City", "Ship-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Post Code")
        {
            Visible = false;
        }
        modify("Ship-to City")
        {
            Visible = false;
        }
        modify("Ship-to County")
        {
            Visible = false;
        }
        //******************************* END Ship-to *************************************

        //******************************* BEGIN Bill-to *************************************
        addafter("Bill-to Address 2")
        {
            field(PayToCountryRegionCode; "Bill-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PayToPostCode; "Bill-to Post Code")
            {
                ApplicationArea = All;
            }
            field(PayToCity2; "Bill-to City")
            {
                ApplicationArea = All;
            }
            field(PayToCounty; "Bill-to County")
            {
                ApplicationArea = All;
            }
            field(PayToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Bill-to Country/Region Code", "Bill-to Post Code", "Bill-to City", "Bill-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Bill-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Bill-to Post Code")
        {
            Visible = false;
        }
        modify("Bill-to City")
        {
            Visible = false;
        }
        modify("Bill-to County")
        {
            Visible = false;
        }
        //******************************* END Bill-to *************************************

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        UbigeoMgt: Codeunit "Ubigeo Management";
}