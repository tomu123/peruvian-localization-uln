tableextension 51232 "ST Item" extends Item
{
    fields
    {
        // Add changes to table fields here
        field(51001; "Type of Existence"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type of Existence', Comment = 'ESM="Tipo de existencia"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('05'));
        }
        field(51002; "Catalog"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Catalog', Comment = 'ESM="Catálogo"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("Catalogue SUNAT"), "Type Code" = const('13'));
        }
        field(51003; "Existence Code BSO"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Existence Code BSO', Comment = 'ESM="Existencia Code BSO"';
        }
        field(51004; "Value Method"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Value Method', Comment = 'ESM="Metodo de Valuación"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('14'));

        }
        field(51005; "Exclude Items Dll"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exclude Items Dll', Comment = 'ESM="Excluir Producto en Dll"';
        }
    }

    var
        myInt: Integer;
}