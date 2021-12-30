pageextension 51107 "Setup Bank Account Card" extends "Bank Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Bank Account No.")
        {
            field("Bank Account CCI"; Rec."Bank Account CCI")
            {
                ApplicationArea = All;
                Caption = 'Bank Account CCI', Comment = 'ESM="N° Cuenta CCI"';
            }
        }
        addbefore("Bank Account No.")
        {
            field("Bank Account Type"; Rec."Bank Account Type")
            {
                ApplicationArea = All;
                Caption = 'Bank Account Type', Comment = 'ESM="Tipo de cuenta banco"';
            }
        }

        addafter(Transfer)
        {
            group(SetupPersonalization)
            {
                Caption = 'Setup Localization', Comment = 'ESM="Configuración de localización"';
                field(FirstField; FirstField)
                {
                    Editable = false;
                    Visible = false;
                }
                field("Is Check Bank"; Rec."Is Check Bank")
                {
                    ApplicationArea = All;
                }
            }
        }
        //Legal Document Begin
        addbefore("Bank Account No.")
        {
            field("Legal Document"; Rec."Legal Document")
            {
                ApplicationArea = All;
                Caption = 'Legal Document', Comment = 'ESM="Documenta Legal"';
            }
            field("Process Type BBVA"; Rec."Process Type BBVA")
            {
                ApplicationArea = All;
            }
        }
        //Legal Document End

        addafter("Process Type BBVA")
        {
            field("Process Bank"; "Process Bank")
            {
                ApplicationArea = All;

            }
        }
        //ULN::PC    002 Begin Conciliación ++++

        addafter("Bank Statement Import Format")
        {
            field("Import Format Conciliation"; "Import Format Statement")
            {
                ApplicationArea = All;
                trigger OnLookup(var Text: Text): Boolean
                var
                    lcRecBankExport: Record "Bank Export/Import Setup";
                    lcPageBankExport: Page "Bank Export/Import Setup";
                begin
                    Clear(lcPageBankExport);
                    lcRecBankExport.Reset();
                    lcRecBankExport.SetRange(Direction, lcRecBankExport.Direction::Import);
                    lcRecBankExport.SetRange("ST Bank statement", true);
                    lcPageBankExport.SETTABLEVIEW(lcRecBankExport);

                    lcPageBankExport.LOOKUPMODE(TRUE);

                    IF lcPageBankExport.RUNMODAL = ACTION::LookupOK THEN BEGIN

                        lcPageBankExport.GETRECORD(lcRecBankExport);

                        "Import Format Statement" := lcRecBankExport.Code;

                    END;
                end;
            }
        }
        modify("Bank Statement Import Format")
        {
            ApplicationArea = All;
            Caption = 'Bank Statement Import Format Recaudation', Comment = 'ESM="Formato de importación de estado de cuenta de banco Recaudación"';
            trigger OnLookup(var Text: Text): Boolean
            var
                lcRecBankExport: Record "Bank Export/Import Setup";
                lcPageBankExport: Page "Bank Export/Import Setup";
            begin
                Clear(lcPageBankExport);
                lcRecBankExport.Reset();
                lcRecBankExport.SetRange(Direction, lcRecBankExport.Direction::Import);
                lcRecBankExport.SetRange("ST Bank statement", false);
                lcPageBankExport.SETTABLEVIEW(lcRecBankExport);

                lcPageBankExport.LOOKUPMODE(TRUE);

                IF lcPageBankExport.RUNMODAL = ACTION::LookupOK THEN BEGIN

                    lcPageBankExport.GETRECORD(lcRecBankExport);

                    "Bank Statement Import Format" := lcRecBankExport.Code;

                END;
            end;
        }
        //ULN::PC    002 Begin Conciliación ----
    }

    var
        FirstField: Text;
        Report1320: Report 1320;
}