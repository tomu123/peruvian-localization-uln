tableextension 51152 "LD Purch. Rcpt. Header" extends "Purch. Rcpt. Header"
{
    fields
    {
        // Add changes to table fields here 51000..51005
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
            Editable = false;
        }
    }

    var
        myInt: Integer;
}