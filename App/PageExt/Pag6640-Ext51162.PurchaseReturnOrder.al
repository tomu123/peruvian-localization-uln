pageextension 51162 "LD Purchase Return Order" extends "Purchase Return Order"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            group(Localization)
            {
                Caption = 'Peruvian Localization';
                field("Legal Document"; "Legal Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Legal Status"; "Legal Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration Type"; "VAT Registration Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(LegalPropertyType)
                {
                    Caption = 'Legal Property Type';
                    grid(LegalPropertyTypeGrid)
                    {
                        GridLayout = Columns;
                        group(GridGroupLPT1)
                        {
                            ShowCaption = false;
                            field("Legal Property Type"; "Legal Property Type")
                            {
                                ApplicationArea = All;
                                ShowCaption = false;
                                trigger OnValidate()
                                begin
                                    CurrPage.Update();
                                end;
                            }
                        }
                        group(GridGroupLPT2)
                        {
                            ShowCaption = false;
                            field("Legal Property Type Name"; ShowLegalPropertyName())
                            {
                                ApplicationArea = All;
                                ShowCaption = false;
                                Editable = false;
                            }
                        }
                    }
                }
            }

        }
    }

    procedure ShowLegalPropertyName(): Text[250]
    var
        MyLegalDocument: Record "Legal Document";
    begin
        MyLegalDocument.Reset();
        MyLegalDocument.SetRange("Option Type", MyLegalDocument."Option Type"::"SUNAT Table");
        MyLegalDocument.SetRange("Type Code", '30');
        MyLegalDocument.SetRange("Legal No.", "Legal Property Type");
        if MyLegalDocument.Find('-') then
            exit(MyLegalDocument.Description);
        exit('');
    end;

    var
        myInt: Integer;
}