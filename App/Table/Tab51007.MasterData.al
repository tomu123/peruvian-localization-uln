table 51007 "Master Data"
{
    DataClassification = ToBeClassified;
    //51000..51004,51040..51060
    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(51001; "Type Table"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Table';
        }
        field(51002; "Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Code';
        }
        field(51003; "Description"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description';
        }
        field(51004; "Amount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount %';
        }
        field(1; "G/L Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "G/L Entry Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(51040; "Dimension Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(51041; "Dimension Value Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Dimension Value Code';
            TableRelation = "Dimension Value".Code where("Dimension Code" = field("Dimension Code"));
        }
        field(51042; "Type Table ref"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(51043; "Code ref"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51144; "Open"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        //Begin - Campos para envio FE
        field(51300; "EB Status Send Doc. Cust"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Status Send Doc. Cust', Comment = 'ESM="Estado envio doc. a cliente"';
            OptionMembers = Open,Send;
            OptionCaption = 'Open,Send', Comment = 'ESM="Pendiente,Enviado"';
        }
        field(51301; "EB Send Date"; DateTime)
        {
            DataClassification = ToBeClassified;
            Caption = 'Send Date', Comment = 'ESM="Fecha de envío"';
        }
        field(51302; "EB Send User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Send User Id.', Comment = 'ESM="Enviado por.."';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(51303; "EB Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
        }
        //End --
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; Code, Description)
        {

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