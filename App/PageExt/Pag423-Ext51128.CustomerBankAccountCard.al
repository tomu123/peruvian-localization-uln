pageextension 51128 "ST Customer Bank Account Card" extends "Customer Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Name)
        {
            field("Cust. Name/Business Name"; "Cust. Name/Business Name")
            {
                ApplicationArea = All;
            }
        }

        addafter(General)
        {
            group(SetupLocalization)
            {
                Caption = '';
                field("Bank Account Type"; "Bank Account Type")
                {
                    ApplicationArea = All;
                }
                field("Bank Type Check"; "Bank Type Check")
                {
                    ApplicationArea = All;
                }
                field("Check Manager"; "Check Manager")
                {
                    ApplicationArea = All;
                }
                field("Reference Bank Acc. No."; "Reference Bank Acc. No.")
                {
                    ApplicationArea = All;
                }
                field("Bank Account CCI"; "Bank Account CCI")
                {
                    ApplicationArea = All;
                }
            }
        }

        //Legal Document Begin
        addbefore("Bank Account No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
                Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            }
        }
        //Legal Document End
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: page "Customer Bank Account Card";
}