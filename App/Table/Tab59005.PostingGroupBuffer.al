table 59005 "SL Posting Group Buffer"
{
    DataClassification = ToBeClassified;
    Caption = 'Posting Group', Comment = 'ESM="Grupos Registro"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="N° Mov."';
        }
        field(2; "Type Source"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Source', Comment = 'ESM="Tipo de Origen"';
            OptionMembers = "Vendor Entries","Customer Entries","Employee Entries";
            OptionCaption = 'Vendor,Customer,Employee', Comment = 'ESM="Proveedor,Cliente,Empleado"';
        }
        field(3; "Posting Group"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Group', Comment = 'ESM="Grupo Registro"';
        }
        field(4; "Amount (LCY)"; Decimal)
        {
            CalcFormula = Sum("Payment Schedule"."Amount LCY" WHERE("Posting Group" = FIELD("Posting Group"),
                                                                         "Type Source" = FIELD("Type Source")));
            Caption = 'Amount (LCY)', Comment = 'ESM="Importe (DL)"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Amount dollar"; Decimal)
        {
            CalcFormula = Sum("Payment Schedule".Dollarized WHERE("Posting Group" = FIELD("Posting Group"),
                                                                         "Type Source" = FIELD("Type Source")));
            Caption = 'Amount (USD)', Comment = 'ESM="Importe Dolar"';
            Editable = false;
            FieldClass = FlowField;
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
        Table21: Record 21;

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