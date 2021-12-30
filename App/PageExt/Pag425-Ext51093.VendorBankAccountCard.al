pageextension 51093 "ST Vendor Bank Account Card" extends "Vendor Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addbefore(Name)
        {
            field("Vend. Name/Business Name"; "Vend. Name/Business Name")
            {
                ApplicationArea = All;
            }
        }

        addafter(General)
        {
            group(SetupLocalization)
            {
                Caption = 'Setup localization', Comment = 'ESM="Configuración localización"';
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
            //Telecredit

            group("Telecredit")
            {
                Caption = 'Telecredit', Comment = 'ESM="Telecreditos"';
                field("Fiduciary"; Rec."Fiduciary")
                {
                    trigger OnValidate()
                    begin
                        fnFieldsEditables();
                    end;
                }
                field("Type Fiduciary"; Rec."Type Fiduciary")
                {
                    Editable = gFieldEditable;
                    Enabled = gFieldEditable;
                }
            }

        }
        //Legal Document Begin
        addbefore("Bank Account No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }
        }
        //Legal Document End

        modify("Transit No.")
        {
            Caption = 'Transit No.', Comment = 'ESM="Identidad Fic."';
        }
    }


    procedure fnFieldsEditables()
    begin
        gFieldEditable := false;

        if Rec.Fiduciary then
            gFieldEditable := true
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        myInt: Integer;
    begin
        TestField(Code);
        TestField(Name);
        //TestField("Currency Code");
        TestField("Legal Document");
        TestField("Bank Account No.");
        TestField("Reference Bank Acc. No.");
        //TestField("Bank Account CCI");
        if "Bank Account Type" = "Bank Account Type"::" " then
            Error('Debe de elegir un tipo de cuenta bancaria.');
    end;

    var
        gFieldEditable: Boolean;
}