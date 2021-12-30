tableextension 51225 "ST Data Exch. Def" extends "Data Exch. Def"
{
    fields
    { //ULN::PC    002 Begin Conciliación ++++
        field(51000; "ST Footer Tag"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Footer Tag', Comment = 'ESM="Etiqueta de pie de página"';
        }
        field(51001; "ST Header Lines"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Header Lines', Comment = 'ESM="Líneas de encabezado"';
        }
        field(51002; "ST Adjust Format"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Adjust Format', Comment = 'ESM="Ajustar Formato"';

        }
        field(51003; "ST ITF"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exists ITF', Comment = 'ESM="Existe ITF"';

        }
        field(51004; "ST ITF Column"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ITF Column', Comment = 'ESM="Nro Columna ITF"';

        }
        field(51005; "ST ITF Column Amount"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'ITF Column Amount', Comment = 'ESM="Nro Columna Importe Principal"';

        }
        //ULN::PC    002 Begin Conciliación ----
    }
}