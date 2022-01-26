page 51014 "SUNAT Vendor Register List"
{
    ApplicationArea = All;
    Caption = 'SUNAT Vendor Register List', Comment = 'ESM="Lista de proveedores - inf. (SUNAT)"';
    PageType = List;
    Editable = false;
    UsageCategory = Lists;
    SourceTable = Vendor;
    SourceTableView = where("VAT Registration Type" = const('6'));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }

                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Retention Agent"; "Retention Agent")
                {
                    ApplicationArea = All;
                }
                field("Retention Agent Start Date"; "Retention Agent Start Date")
                {
                    ApplicationArea = All;
                }
                field("Retention Agent End Date"; "Retention Agent End Date")
                {
                    ApplicationArea = All;
                }
                field("Retention Agent Resolution"; "Retention Agent Resolution")
                {
                    ApplicationArea = All;
                }
                field("withholding File Date"; "withholding File Date")
                {
                    ApplicationArea = All;
                }
                field("Date of last withholding load"; "Date of last withholding load")
                {
                    ApplicationArea = All;
                }
                field("Perception Agent"; "Perception Agent")
                {
                    ApplicationArea = All;
                }
                field("Perception Agent Start Date"; "Perception Agent Start Date")
                {
                    ApplicationArea = All;
                }
                field("Perception Agent End Date"; "Perception Agent End Date")
                {
                    ApplicationArea = All;
                }
                field("Perception Agent Resolution"; "Perception Agent Resolution")
                {
                    ApplicationArea = All;
                }
                field("Perception File Date"; "Perception File Date")
                {
                    ApplicationArea = All;
                }
                field("Date of last Perception load"; "Date of last Perception load")
                {
                    ApplicationArea = All;
                }
                field("Good Contributor"; "Good Contributor")
                {
                    ApplicationArea = All;
                }
                field("Good Contributor Start Date"; "Good Contributor Start Date")
                {
                    ApplicationArea = All;
                }
                field("Good Contributor End Date"; "Good Contributor End Date")
                {
                    ApplicationArea = All;
                }
                field("Good Contributor Resolution"; "Good Contributor Resolution")
                {
                    ApplicationArea = All;
                }
                field("Good contrib. File Date"; "Good contrib. File Date")
                {
                    ApplicationArea = All;
                }
                field("Date last good contrib. load"; "Date last good contrib. load")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action("Upload Retention Agent")
            {
                ApplicationArea = All;
                Caption = 'Upload Retention Agent', Comment = 'ESM="Importar Agente Retención"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CalculateDiscount;
                RunObject = xmlport "Import Rgtr. Retention Agent";
            }
            action("Upload Perception Agent")
            {
                ApplicationArea = All;
                Caption = 'Upload Perception Agent', Comment = 'ESM="Importar Agente Percepción"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CalculateDepreciation;
                RunObject = xmlport "Import Rgtr. Perception Agent";
            }
            action("Upload Good Contributor")
            {
                ApplicationArea = All;
                Caption = 'Upload Good Contributor', Comment = 'ESM="Importar Buen Contribuyente"';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = UserCertificate;
                RunObject = xmlport "Import Rgtr. Good Contributor ";
            }
        }
    }
}