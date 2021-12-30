tableextension 51153 "LD Return Shipment Header" extends "Return Shipment Header"
{
    fields
    {
        // Add changes to table fields here
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            Editable = false;

        }

        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }
    }

    var
        Codeunit90: codeunit 90;
}