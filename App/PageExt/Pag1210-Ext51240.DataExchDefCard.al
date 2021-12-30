pageextension 51240 "ST Data Exch Def Card" extends "Data Exch Def Card"
{
    layout
    {

        addlast("File Type: Variable/Fixed")
        {
            field("ST Adjust Format"; "ST Adjust Format")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                begin
                    "Column Separator" := "Column Separator"::Semicolon;
                    "Header Lines" := 0;
                    "Footer Tag" := '';
                    gIsImportType := "ST Adjust Format";
                    CurrPage.Update();
                end;
            }
        }
        //ULN::PC    002 Begin Conciliación ++++
        addbefore("Type: Import")
        {

            group("ST Type: Import")
            {
                Caption = 'ST Type: Import', Comment = 'ESM="Tipo: Ajuste de Importación"';
                Enabled = gIsImportType;
                Visible = gIsImportType;
                field("ST Header Lines"; "ST Header Lines")
                {
                    ApplicationArea = All;
                }
                field("ST Footer Tag"; "ST Footer Tag")
                {
                    ApplicationArea = All;
                }
            }


        }
        addlast("ST Type: Import")
        {
            field("ST ITF"; "ST ITF")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                begin
                    gIsImportITF := "ST ITF";
                    CurrPage.Update();
                end;
            }
            group(ITF)
            {
                Caption = 'ITF', Comment = 'ESM="Configuración ITF"';
                Enabled = gIsImportITF;
                Visible = gIsImportITF;
                field("ST ITF Column"; "ST ITF Column")
                {
                    ApplicationArea = All;
                }
                field("ST ITF Column Amount"; "ST ITF Column Amount")
                {
                    ApplicationArea = All;
                }

            }
        }
        //ULN::PC    002 Begin Conciliación ----
    }
    trigger OnOpenPage()
    begin
        gIsImportType := Rec."ST Adjust Format";
        gIsImportITF := Rec."ST ITF";
    end;

    var
        gIsImportType: Boolean;
        gIsImportITF: Boolean;
}