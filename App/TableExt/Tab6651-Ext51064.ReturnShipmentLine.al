tableextension 51064 "Import Return Shipment Line" extends "Return Shipment Line"
{
    fields
    {
        field(51001; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.';
        }

    }
}