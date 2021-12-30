table 51048 "Format FDC Setup"
{
    DataClassification = ToBeClassified;
    Caption = 'Format FDC Setup', Comment = 'ESM="Configuración Formato FDC"';

    fields
    {
        field(50000; "Orden"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indentation', Comment = 'ESM="Orden"';
        }
        field(51017; "Sub Orden"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Indentation', Comment = 'ESM="Orden"';
        }
        field(50001; "Primary Category"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Primary Category', Comment = 'ESM="Categoría principal"';
        }
        field(50002; "Secondary category"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Secondary category', Comment = 'ESM="Categoría secundaria"';
        }
        field(51002; "Filter Account"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Account', Comment = 'ESM="Filtros de Cuenta contable"';
        }


        field(51010; "Filter Dimension FE"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Dimension FE', Comment = 'ESM="Filtro Val.Dimension FE"';
        }
        field(51011; "Filter Cod.Origen"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter  Cod.Origen', Comment = 'ESM="Filtro  Cod.Origen"';
        }
        field(51012; "Source Type"; Enum "Gen. Journal Source Type")
        {
            Caption = 'Source Type', Comment = 'ESM="Filtro Tipo Contrapartida"';

        }
        field(51013; "Source No."; Code[20])
        {
            Caption = 'Source No.', Comment = 'ESM="Filtro Cod.  Origen"';
            TableRelation = IF ("Source Type" = CONST(Customer)) Customer
            ELSE
            IF ("Source Type" = CONST(Vendor)) Vendor
            ELSE
            IF ("Source Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Source Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Source Type" = CONST(Employee)) Employee;
        }
        field(51014; "Filter Dimension FCT"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Filter Dimension FCT', Comment = 'ESM="Filtro Val.Dimension FCT"';
        }
        field(51015; "Document Type"; Enum "Gen. Journal Document Type")
        {
            Caption = 'Document Type', Comment = 'ESM="Filtro Tipo Documento"';
        }
        field(51016; "Filter Posting Group"; Text[250])
        {
            Caption = 'Filter Posting Group', Comment = 'ESM="Filtro Grupo registro"';
        }
        field(51018; "Review Bank"; Boolean)
        {
            Caption = 'Review Ba', Comment = 'ESM="Revisar Dimensiones en Linea Banco"';
        }
        field(51019; Ingreso; Boolean)
        {
            Caption = 'Ingreso', Comment = 'ESM="Es Ingreso"';
        }
        field(51020; Egreso; Boolean)
        {
            Caption = 'Engreso', Comment = 'ESM="Es Egreso"';
        }
        field(51021; "Calcular Retencion"; Boolean)
        {
            Caption = 'Calcular Retención', Comment = 'ESM="Calcular Retención"';
        }
    }
    keys
    {
        key(PK; "Primary Category", "Secondary category", "Source Type", "Filter Dimension FCT", "Filter Dimension FE")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Orden, "Primary Category", "Secondary category")
        {

        }
    }
}