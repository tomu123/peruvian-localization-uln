tableextension 51151 "LD Warehouse Receipt Header" extends "Warehouse Receipt Header"
{
    fields
    {
        // Add changes to table fields here 51000..51005
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                myInt: Integer;
            begin

            end;
        }
    }

    var
        myInt: Integer;
}