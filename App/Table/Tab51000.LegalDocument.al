table 51000 "Legal Document"
{
    DataClassification = ToBeClassified;
    Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';

    fields
    {
        field(51001; "Option Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Option Type', Comment = 'ESM="Tipo Opción Tabla"';
            OptionMembers = "SUNAT Table","Catalogue SUNAT","Others";
            OptionCaption = 'SUNAT Table,Catalogue SUNAT,Others', Comment = 'ESM="Tablas SUNAT,Catalogo SUNAT,Otros"';
        }
        field(51002; "Type Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Code', Comment = 'ESM="Cód. Tipo"';
        }
        field(51003; "Legal No."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal No.', Comment = 'ESM="N° Legal"';
        }
        field(51004; "Description Type"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description type', Comment = 'ESM="Descripción Tipo"';
        }
        field(51005; "Description"; Code[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description', Comment = 'ESM="Descripción"';
        }
        field(51006; "Description 2"; Code[60])
        {
            DataClassification = ToBeClassified;
            Caption = 'Description 2', Comment = 'ESM="Descripción 2"';
        }
        field(51007; "Apply Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Apply Retention', Comment = 'ESM="Aplica Retención"';
        }
        field(51008; "Serie Lenght"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Serie Lenght', Comment = 'ESM="Longitud Serie"';
        }
        field(51009; "Number Lenght"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number Lenght', Comment = 'ESM="Longitud Número"';
        }
        field(51010; "Min. Serie Lenght"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Min. Serie Lenght', Comment = 'ESM="Longitud minima Serie"';
        }
        field(51011; "Min. Number Lenght"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Min. Number Lenght', Comment = 'ESM="Longitud minima Número"';
        }
        field(51012; "Serie Allow Alphanumeric"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Serie Allow Alphanumeric', Comment = 'ESM="Serie Permite alfanumericos"';
        }
        field(51013; "Number Allow Alphanumeric"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Number Allow Alphanumeric', Comment = 'ESM="Número Permite alfanumericos"';
        }
        field(51014; "Adjust Serie"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Adjust Serie', Comment = 'ESM="Ajustar Serie"';
        }
        field(51015; "Adjust Number"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Adjust Number', Comment = 'ESM="Ajustar Número"';
        }
        field(51016; "Related Document Not Address"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Related Document Not Address', Comment = 'ESM="No domiciliado Doc. Relacionado"';
        }
        field(51017; "Document Type"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Document Type', Comment = 'ESM="Tipo documento"';
            OptionMembers = " ","Invoice","Credit Memo","Debit Note";
            OptionCaption = ' ,Invoice,Credit Memo,Debit Note', Comment = 'ESM=" ,Factura,Nota de Crédito,Nota de Débito"';
        }
        field(51018; "Generic Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Generic Code', Comment = 'ESM="Código Genérico"';
        }
        field(51019; "Alternative Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Alternative Code', Comment = 'ESM="Cód. Alternativo"';
        }
        field(51020; "TAX Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'TAX Code', Comment = 'ESM="Cód. Impuesto"';
        }
        field(51021; "Affectation"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Affectation', Comment = 'ESM="Afectación"';
        }
        field(51022; "Amount %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount %', Comment = 'ESM="Importe %"';
        }
        field(51023; "Applied Level"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applied Level', Comment = 'ESM="Nivel Aplicación"';
            OptionMembers = " ","Header","Line";
            OptionCaption = ' ,Header,Line', Comment = 'ESM=" ,Cabecera,Linea"';
        }
        field(51024; "UN ECE 5305"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'UN ECE 5305';
        }

        field(51025; "Type Fiduciary"; Text[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type Fiduciary', Comment = 'ESM="Cod. Tipo Fiduciario"';

        }
        field(51900; "Nick Name Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Nickname', Comment = 'ESM="Apodo"';
        }
    }

    keys
    {
        key(PK; "Option Type", "Type Code", "Legal No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Legal No.", Description)
        {

        }
    }
}