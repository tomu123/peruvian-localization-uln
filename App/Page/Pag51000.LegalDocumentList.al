page 51000 "Legal Document List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    Editable = true;
    SourceTable = "Legal Document";

    layout
    {
        area(Content)
        {
            repeater(ListDocumentsTypes)
            {
                field("Option Type"; Rec."Option Type")
                {
                    ApplicationArea = All;
                }
                field("Type Code"; Rec."Type Code")
                {
                    ApplicationArea = All;
                }
                field("Legal No."; Rec."Legal No.")
                {
                    ApplicationArea = All;
                }
                field("Description"; Rec."Description")
                {
                    ApplicationArea = All;
                }
                field("Serie Allow Alphanumeric"; Rec."Serie Allow Alphanumeric")
                {
                    ApplicationArea = All;
                }
                field("Serie Lenght"; Rec."Serie Lenght")
                {
                    ApplicationArea = All;
                }
                field("Number Allow Alphanumeric"; Rec."Number Allow Alphanumeric")
                {
                    ApplicationArea = All;
                }
                field("Number Lenght"; Rec."Number Lenght")
                {
                    ApplicationArea = All;
                }
                field("Min. Serie Lenght"; Rec."Min. Serie Lenght")
                {
                    ApplicationArea = All;
                }
                field("Min. Number Lenght"; Rec."Min. Number Lenght")
                {
                    ApplicationArea = All;
                }
                field("Adjust Serie"; Rec."Adjust Serie")
                {
                    ApplicationArea = All;
                }
                field("Adjust Number"; Rec."Adjust Number")
                {
                    ApplicationArea = All;
                }
                field("Description Type"; Rec."Description Type")
                {
                    ApplicationArea = All;
                }
                field("Generic Code"; Rec."Generic Code")
                {
                    ApplicationArea = All;
                }
                field("Alternative Code"; Rec."Alternative Code")
                {
                    ApplicationArea = All;
                }
                field("TAX Code"; Rec."TAX Code")
                {
                    ApplicationArea = All;
                }
                field(Affectation; Rec.Affectation)
                {
                    ApplicationArea = All;
                }
                field("Applied Level"; Rec."Applied Level")
                {
                    ApplicationArea = All;
                }
                field("UN ECE 5305"; Rec."UN ECE 5305")
                {
                    ApplicationArea = All;
                }
                field("Type Fiduciary"; Rec."Type Fiduciary")
                {
                    ApplicationArea = All;
                }
                field("Nick Name Code"; "Nick Name Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }
}