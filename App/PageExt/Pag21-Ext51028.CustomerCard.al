pageextension 51028 "Cnslt. Ruc Customer Card" extends "Customer Card"
{
    layout
    {
        // Add changes to page layout here
        modify("Preferred Bank Account Code")
        {
            Caption = 'Preferred Bank Acc. Code MN', Comment = 'ESM="Banco Recaudación MN"';
        }
        addafter("Preferred Bank Account Code")
        {
            field("Preferred Bank Account Code ME"; "Preferred Bank Account Code ME")
            {
                ApplicationArea = All;
                Caption = 'Preferred Bank Acc. Code ME', Comment = 'ESM="Banco Recaudación ME"';
            }
        }
        addafter("VAT Registration No.")
        {
            field("SUNAT Status"; "SUNAT Status")
            {
                ApplicationArea = All;
            }
            field("SUNAT Condition"; "SUNAT Condition")
            {
                ApplicationArea = All;
            }
            field(Ubigeo; Ubigeo)
            {
                ApplicationArea = All;
            }
        }
        addbefore("VAT Registration No.")
        {
            field("VAT Registration Type"; "VAT Registration Type")
            {
                ApplicationArea = All;
            }
        }
        //Ubigeo Begin  
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
                Caption = 'Departament Code', Comment = 'ESM="Cód. Departamento"';
            }
            field(City2; City)
            {
                ApplicationArea = All;
                Caption = 'Province Code', Comment = 'ESM="Cód. Provincia"';
                trigger OnValidate()
                begin
                    if xRec.City <> Rec.City then
                        County := '';
                end;
            }
            field(County2; County)
            {
                ApplicationArea = All;
                Caption = 'District Code', Comment = 'ESM="Cód. Distrito"';
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
        modify("County")
        {
            Visible = false;
        }
        modify("Customer Posting Group")
        {
            Visible = true;
            trigger OnAfterValidate()
            var
                RecCustomerPostingGroup: Record "Customer Posting Group";
            begin
                RecCustomerPostingGroup.Reset();
                RecCustomerPostingGroup.SetRange(code, "Customer Posting Group");
                if RecCustomerPostingGroup.FindSet() then
                    "Currency Code" := RecCustomerPostingGroup."Currency Code";
            end;
        }
        modify("Currency Code")
        {
            Editable = false;
        }

        //Ubigeo End
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(ConsultRuc)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Consult Ruc';
                Image = ElectronicNumber;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Basic Line';

                trigger OnAction()
                var
                    CnsltRucMgt: Codeunit "Cnslt. Ruc Management";
                    Vendor: Record Vendor;
                begin
                    CnsltRucMgt.CustomerConsultRuc(Rec);
                end;
            }
            action(BalanceACCustomer)
            {
                ApplicationArea = All;
                Caption = 'Customer AC Balance', Comment = 'ESM="Salgo GC Cliente"';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Customer AC Balance";
            }
        }
    }

    var
        UbigeoMgt: Codeunit "Ubigeo Management";
}