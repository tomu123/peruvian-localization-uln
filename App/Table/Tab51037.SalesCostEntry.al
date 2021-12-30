table 51037 "SL Cost sale Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'Cost sale Entry', Comment = 'ESM="Mov. Costo venta"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="N° Mov."';
        }
        field(2; "Job No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job No.', Comment = 'ESM="N° Proyecto"';
        }
        field(3; "Job Task No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Task No.', Comment = 'ESM="N° Tarea proyecto"';
        }
        field(4; "Job Planning Lines No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Job Planning Lines No.', Comment = 'ESM="N° Linea de planificación de proyecto"';
        }
        field(5; "Cost sale processed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Cost sale processed', Comment = 'ESM="Costo venta procesado"';
        }
        field(6; "No. Sale processed"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'No. sale processed', Comment = 'ESM="N° Venta procesado"';
        }
        field(7; "Date process"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Date processed', Comment = 'ESM="Fecha proceso"';
        }
        field(8; "Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Percentage', Comment = 'ESM="Porcentaje"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}