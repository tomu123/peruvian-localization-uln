pageextension 51150 "ST Employee Card" extends "Employee Card"
{
    layout
    {
        // Add changes to page layout here
        addafter(General)
        {
            group(Localization)
            {
                Caption = 'Localization', Comment = 'ESM="Configuración localización"';
                field("Preferred Bank Account Code MN"; "Preferred Bank Account Code MN")
                {
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code ME"; "Preferred Bank Account Code ME")
                {
                    ApplicationArea = All;
                }
            }
        }
        //Legal Document Begin
        addafter("Company E-Mail")
        {
            field("VAT Registration Type"; "VAT Registration Type")
            {
                ApplicationArea = All;
            }
            field("VAT Registration No."; "VAT Registration No.")
            {
                ApplicationArea = All;
            }
        }
        //Legal Document End

        //Ubigeo Begin **********************************************************************************************************
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
        //Ubigeo End **********************************************************************************************************
    }

    actions
    {
        // Add changes to page actions here
        addafter(PayEmployee)
        {
            action(BalanceACEmployee)
            {
                ApplicationArea = All;
                Caption = 'Employee AC Balance', Comment = 'ESM="Salgo GC Empleado"';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Employee AC Balance";
            }
            action(EmployeeBanks)
            {
                ApplicationArea = All;
                Caption = 'Banks', Comment = 'ESM="Bancos"';
                Image = BankContact;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "ST Employee Bank Account List";
                RunPageLink = "Employee No." = field("No.");
            }
        }
    }

    var
        UbigeoMgt: Codeunit "Ubigeo Management";
}