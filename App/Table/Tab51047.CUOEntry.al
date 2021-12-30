table 51047 "ULN CUO Entry"
{
    DataClassification = ToBeClassified;
    Caption = 'CUO Entry', Comment = 'ESM="Movimiento de (CUO)"';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="N° Movimiento"';
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.', Comment = 'ESM="N° Documento"';
        }
        field(3; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Date', Comment = 'ESM="Fecha Registro"';
        }
        field(4; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction No.', Comment = 'ESM="N° Asiento"';
        }
        field(5; "CUO Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'CUO Transaction No.', Comment = 'ESM="N° Asiento (CUO)"';
        }
        field(6; "Last. used CUO Correlative"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Last used CUO Correlative', Comment = 'ESM="Último correlativo (CUO) usado"';
        }
        field(7; "User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'User Id.', Comment = 'ESM="Id Usuario"';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Group1; "Document No.") { }
        key(Group2; "Document No.", "Posting Date") { }
        key(Group3; "Document No.", "Posting Date", "Transaction No.") { }
        key(Group4; "Document No.", "Posting Date", "Transaction No.", "CUO Transaction No.") { }
    }
}