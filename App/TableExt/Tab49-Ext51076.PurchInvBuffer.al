tableextension 51076 "Import Purch. Inv. Buffer" extends "Invoice Post. Buffer"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Importation No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    var
        codeunit90: codeunit 90;
        InvoicePostBuffer: Record 49;
}