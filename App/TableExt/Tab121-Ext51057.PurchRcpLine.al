tableextension 51057 "Import Purch. Rcp. Line" extends "Purch. Rcpt. Line"
{
    fields
    {
        field(51001; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(51004; "Closed Import"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
}