tableextension 51007 "Legal Doc. No Series" extends "No. Series"
{
    fields
    {
        //Add field here 51000..51003,51005..51010
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
        }

        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }

        field(51002; "Legal Document Ref."; Code[10])
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Document Ref.', Comment = 'ESM="Documento Legal Ref."';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
        }
        field(51003; "Internal Operation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Operation', comment = 'ESM="Operación Internal"';
        }
        field(51005; "Operation Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Operation Type', Comment = 'ESM="Tipo operación"';
            OptionMembers = " ",Sales,Purchase;
            OptionCaption = ' ,Sales,Purchase', Comment = 'ESM=" ,Ventas,Compras"';
        }

    }
}