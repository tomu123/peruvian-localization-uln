tableextension 51230 "ST FA Ledger Entry" extends "FA Ledger Entry"
{
    fields
    {
        // Add changes to table fields here 51005..51015
        field(51000; "Source Currency Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Code', Comment = 'ESM="Cod. Divisa Origen"';

        }
        field(51001; "Source Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Amount', Comment = 'ESM="Importe Origen"';

        }
        field(51002; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Code', Comment = 'ESM="Factor Divisa Origen"';

        }
        field(51003; "Source Exchange rate"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Exchange rate', Comment = 'ESM="Tipo de Cambio Origen"';

        }
    }
}