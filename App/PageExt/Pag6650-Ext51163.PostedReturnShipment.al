pageextension 51163 "LD Posted Return Shipment" extends "Posted Return Shipment"
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
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
            }

        }
    }
    var
        Record6650: record 6650;
}