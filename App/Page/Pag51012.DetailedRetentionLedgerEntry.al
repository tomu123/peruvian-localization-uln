page 51012 "Detailed Retention Ledg. Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Detailed Retention Ledg. Entry";
    Editable = false;

    layout
    {
        area(Content)
        {
            repeater(DtldRetLedgerEntryRepeater)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Retention Legal Document"; Rec."Retention Legal Document")
                {
                    ApplicationArea = All;
                }
                field("Retention No."; Rec."Retention No.")
                {
                    ApplicationArea = All;
                }
                field("Retention Posting Date"; Rec."Retention Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Doc. Legal Document"; Rec."Vendor Doc. Legal Document")
                {
                    ApplicationArea = All;
                }
                field("Vendor Doc. Posting Date"; Rec."Vendor Doc. Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Document Date"; Rec."Vendor Document Date")
                {
                    ApplicationArea = All;
                }
                field("Vendor Document No."; Rec."Vendor Document No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor External Document No."; Rec."Vendor External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Amount Invoice"; Rec."Amount Invoice")
                {
                    ApplicationArea = All;
                }
                field("Amount Invoice LCY"; Rec."Amount Invoice LCY")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid LCY"; Rec."Amount Paid LCY")
                {
                    ApplicationArea = All;
                }
                field("Amount Retention"; Rec."Amount Retention")
                {
                    ApplicationArea = All;
                }
                field("Amount Retention LCY"; Rec."Amount Retention LCY")
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}