pageextension 51031 "Cnslt. Ruc Vendor List" extends "Vendor List"
{
    layout
    {
        addafter("Phone No.")
        {
            field("Good Contributor12877"; "Good Contributor")
            {
                ApplicationArea = All;
            }
            field("Perception Agent22928"; "Perception Agent")
            {
                ApplicationArea = All;
            }
            field("Retention Agent69247"; "Retention Agent")
            {
                ApplicationArea = All;
            }
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Location Code")
        {
            Visible = false;
        }
        modify("Phone No.")
        {
            Visible = false;
        }
        modify(Contact)
        {
            Visible = false;
        }
        addafter("Search Name")
        {
            field("Vendor Posting Group03009"; "Vendor Posting Group")
            {
                ApplicationArea = All;
            }
            field("Preferred Bank Account Code64783"; "Preferred Bank Account Code")
            {
                ApplicationArea = All;
            }
            field("Preferred Bank Account Code ME72953"; "Preferred Bank Account Code ME")
            {
                ApplicationArea = All;
            }
        }
        addafter(Name)
        {
            field("VAT Registration Type12834"; "VAT Registration Type")
            {
                ApplicationArea = All;
            }
        }
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
                    CnsltRucMgt.VendorConsultRuc(Rec);
                end;
            }
            action(SaldoGCProveedor)
            {
                ApplicationArea = All;
                Caption = 'Vendor AC Balance', Comment = 'ESM="Salgo GC Proveedor"';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Vendor AC Balance";
            }
        }
    }

    var
        myInt: Integer;
}