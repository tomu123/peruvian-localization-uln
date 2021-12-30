table 51004 "Detraction Services Operation"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type Services/Operation"; Option)
        {
            Caption = 'Type Services/Operation';
            OptionCaption = 'Tipo Servicio,Tipo Operacion';
            OptionMembers = "Tipo Servicio","Tipo Operacion";
            DataClassification = ToBeClassified;

        }
        field(2; Code; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Description; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Detraction Percentage"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(5; "Detraction Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Detraction Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Type Services/Operation", Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;
        tb12: Record "Sales Header";

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