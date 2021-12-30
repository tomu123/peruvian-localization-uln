tableextension 51120 "Setup Sales Inv. Header" extends "Sales Invoice Header"
{
    fields
    {
        // Add changes to table fields here 51050..51059
        //Legal Document Begin
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
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

        }
        field(51011; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        field(51012; "Legal Property Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Property Type', Comment = 'ESM="Tipo de bien"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('30'));
            ValidateTableRelation = false;
        }
        field(51013; "Ext/Anul. User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ext/Anul. User Id.', Comment = 'ESM="Ext/Anul. User Id."';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            Editable = false;
        }
        field(51030; "Manual Document Ref."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Document Ref.', Comment = 'ESM="Documento Manual Ref."';
        }
        field(51031; "Electronic Doc. Ref"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Doc. Ref.', Comment = 'ESM="Documento Electrónico Ref."';
        }
        field(51032; "Applies-to Doc. No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Doc. No. Ref.', Comment = 'ESM="Liq. por N° Documento Ref."';
            TableRelation = if ("Manual Document Ref." = Const(false)) "Sales Invoice Header"."No." where("Legal Status" = const(Success), "Legal Document" = field("Legal Document Ref."), "Sell-to Customer No." = field("Sell-to Customer No."));
            ValidateTableRelation = false;
        }
        field(51033; "Applies-to Serie Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Serie Ref.', Comment = 'ESM="Liq. serie doc. Ref."';
        }
        field(51034; "Applies-to Number Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Number Ref.', Comment = 'ESM="Liq. número doc. Ref."';
        }
        field(51035; "Applies-to Document Date Ref."; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Document Date Ref.', Comment = 'ESM="Liq. Fecha Emisión Ref."';
        }
        //Legal Document End

        field(51050; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
            //TableRelation = "Master Data".Code where("Type Table" = const('STPSOURCECODE'));
        }
        field(51051; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Glosa Principal"';
        }
        //Detracc BEGIN
        field(51020; "Sales Detraction"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Detraction', Comment = 'ESM="Detracción"';
        }
        field(51021; "Sales % Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales % Detraction', Comment = 'ESM="% Detracción"';
        }

        field(51022; "Sales Amt Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Amt Detraction', Comment = 'ESM="Importe detracción"';
        }

        field(51023; "Sales Amt Detraction (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Amt Detraction (LCY)', Comment = 'ESM="Importe detracción (DL)"';
        }

        field(51024; "Operation Type Detrac"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Operation Type Detraction', Comment = 'ESM="Tipo operación detracción"';
        }

        field(51025; "Service Type Detrac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Type Detraction', Comment = 'ESM="TIpo servicio detracción"';
        }
        field(51026; "Payment Method Code Detrac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method Code Detrac', Comment = 'ESM="Cód. Forma Pago Detracción"';
            TableRelation = "Payment Method";
        }
        //Detracc END

        //Free title
        field(51015; "FT Free Title"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Free Title', Comment = 'ESM="Título gratuito"';
            Editable = false;
        }
        field(51052; "Setup Source Code to User"; Enum "Source Code to User")
        {
            DataClassification = ToBeClassified;
            Caption = 'Setup Source Code to User', Comment = 'ESM="Cód. Origen Usuario"';
        }

        //Internal Consumption
        field(51060; "Internal Consumption"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Consumption', Comment = 'ESM="Consumo Interno"';
        }
        //SUMINISTRO-ATRIA
        field(57100; "Active Supply No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Active Supply No.', Comment = 'ESM=No. Suministro Activo';
        }
    }
}