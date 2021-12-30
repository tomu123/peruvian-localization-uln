tableextension 51077 "Import Item Journal Line" extends 83
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Importation No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.';
        }
    }

    var
        codeunit90: codeunit 90;
        ItemJournalLine: Record 83;
}