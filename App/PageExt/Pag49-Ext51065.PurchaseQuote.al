pageextension 51065 "Ubigeo Purchase Quote" extends "Purchase Quote"
{
    layout
    {
        // Add changes to page layout here
        //PosCode = Departamento
        //City = Provincia
        //County = County

        //******************************* BEGIN Buy-from ***********************************
        addafter("Buy-from Address 2")
        {
            field(BuyFromCountryRegionCode; "Buy-from Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(BuyFromPostCode; "Buy-from Post Code")
            {
                ApplicationArea = All;
            }
            field(BuyFromCity2; "Buy-from City")
            {
                ApplicationArea = All;
            }
            field(BuyFromCounty; "Buy-from County")
            {
                ApplicationArea = All;
            }
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Buy-from Country/Region Code", "Buy-from Post Code", "Buy-from City", "Buy-from County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Buy-from Post Code")
        {
            Visible = false;
        }
        modify("Buy-from City")
        {
            Visible = false;
        }
        modify("Buy-from County")
        {
            Visible = false;
        }
        //******************************* END Buy-from *************************************

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

        //******************************* BEGIN Pay-to *************************************
        addafter("Pay-to Address 2")
        {
            field(PayToCountryRegionCode; "Pay-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PayToPostCode; "Pay-to Post Code")
            {
                ApplicationArea = All;
            }
            field(PayToCity2; "Pay-to City")
            {
                ApplicationArea = All;
            }
            field(PayToCounty; "Pay-to County")
            {
                ApplicationArea = All;
            }
            field(PayToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Pay-to Country/Region Code", "Pay-to Post Code", "Pay-to City", "Pay-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Pay-to Post Code")
        {
            Visible = false;
        }
        modify("Pay-to City")
        {
            Visible = false;
        }
        modify("Pay-to County")
        {
            Visible = false;
        }
        //******************************* END Pay-to *************************************

    }

    /*layout
    {
        // Add changes to page layout here
        addafter("Pay-to Address 2")
        {
            field(PayToCountryRegionCode; "Pay-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PayToPostCode; "Pay-to Post Code")
            {
                ApplicationArea = All;
            }
            field(PayToCity2; "Pay-to City")
            {
                ApplicationArea = All;
            }
        }
        addafter("Pay-to County")
        {
            field(PayToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Pay-to Country/Region Code", "Pay-to Post Code", "Pay-to City", "Pay-to County"))
            {
                ApplicationArea = All;
            }
        }
        //PosCode = Departamento
        //City = Provincia
        //County = County
        modify("Pay-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Pay-to Post Code")
        {
            Visible = false;
        }
        modify("Pay-to City")
        {
            Visible = false;
        }
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
        }
        addafter("Ship-to County")
        {
            field(ShipToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Ship-to Country/Region Code", "Ship-to Post Code", "Ship-to City", "Ship-to County"))
            {
                ApplicationArea = All;
            }
        }
        //PosCode = Departamento
        //City = Provincia
        //County = County
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
        addafter("Buy-from Address 2")
        {
            field(BuyFromCountryRegionCode; "Buy-from Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(BuyFromPostCode; "Buy-from Post Code")
            {
                ApplicationArea = All;
            }
            field(BuyFromCity2; "Buy-from City")
            {
                ApplicationArea = All;
            }
        }
        addafter("Buy-from County")
        {
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Buy-from Country/Region Code", "Buy-from Post Code", "Buy-from City", "Buy-from County"))
            {
                ApplicationArea = All;
            }
        }
        //PosCode = Departamento
        //City = Provincia
        //County = County
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Buy-from Post Code")
        {
            Visible = false;
        }
        modify("Buy-from City")
        {
            Visible = false;
        }
    }*/

    actions
    {
        // Add changes to page actions here
    }

    var
        UbigeoMgt: Codeunit "Ubigeo Management";
        page20: Page 20;
}