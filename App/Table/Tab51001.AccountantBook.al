table 51001 "Accountant Book"
{
    DataClassification = ToBeClassified;
    Caption = 'Accountant Book', Comment = 'ESM="Libros Contables"';

    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
            Caption = 'Entry No.', Comment = 'ESM="N° Mov."';
        }
        field(51001; "EBook Code"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'EBook Code', Comment = 'ESM="Cód. Libro PLE"';
        }
        field(51002; "Book Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Book Code', Comment = 'ESM="Cód. Libro"';
        }

        field(51003; "Book Name"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Book Name', Comment = 'ESM="Nombre Libro"';
        }

        field(51004; "Mandatory"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Mandotary', Comment = 'ESM="Obligatorio"';
        }
        field(51005; "Level"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Level', Comment = 'ESM="Nivel"';
        }
        field(51006; "Format DateTime"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Format Datetime', Comment = 'ESM="Formato Fecha"';
        }
        field(51007; "Report ID"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Report ID', Comment = 'ESM="Id. Reporte"';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(51008; "Type Solution"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type solution', Comment = 'ESM="Tipo solución"';
            OptionMembers = "Bookerper Cabin","Contingency Electronic Invoice";
            OptionCaption = 'Bookerper Cabin,Contingency Electronic Invoice', Comment = 'ESM="Cabina contador,Contingencia fact. electrónica"';
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
        Table77: Record 77;

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