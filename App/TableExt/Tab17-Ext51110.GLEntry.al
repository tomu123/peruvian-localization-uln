tableextension 51110 "Setup G/L Entry" extends "G/L Entry"
{
    fields
    {
        // Add changes to table fields here 51008..51008,51030..51049
        field(51002; "Transaction CUO"; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Transaction CUO', Comment = 'ESM="N° Asiento CUO"';
        }
        field(51003; "Correlative CUO"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Correlative CUO', Comment = 'ESM="Correlativo CUO"';
        }
        field(51004; "Opening"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Opening', Comment = 'ESM="Apertura / Cierre"';
        }
        field(51005; "Analityc Entry"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Analityc Entry', Comment = 'ESM="Mov. Analítica"';
        }
        field(51006; "Analityc Base Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Analityc Base Entry No.', Comment = 'ESM="N° Mov. Analítica Base"';
        }
        field(51008; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Glosa Principal"';
        }
        field(51009; "Ref. Source Type"; Option)
        {
            Caption = 'Ref. Source Type', Comment = 'ESM="Tipo procedencia mov. Adjmt"';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset', Comment = 'ESM=" ,Cliente,Proveedor,Banco,Activo"';

        }
        field(51012; "Ref. Source No."; Code[20])
        {
            Caption = 'Ref. Source No.', Comment = 'ESM="Cód. procedencia mov. Adjmt"';
            DataClassification = ToBeClassified;
            TableRelation = IF ("Ref. Source Type" = CONST(Customer)) Customer ELSE
            IF ("Ref. Source Type" = CONST(Vendor)) Vendor ELSE
            IF ("Ref. Source Type" = CONST("Bank Account")) "Bank Account" ELSE
            IF ("Ref. Source Type" = CONST("Fixed Asset")) "Fixed Asset";
        }
        field(51011; "Ref. Document No."; Code[20])
        {
            Caption = 'Ref. Document No.', Comment = 'ESM="Nº documento Adjmt"';
            DataClassification = ToBeClassified;
        }
        field(51030; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
            //TableRelation = "Master Data".Code where("Type Table" = const('STPSOURCECODE'));
        }
        field(51031; "Global Dimension 3 Code"; Code[20])
        {
            CaptionClass = '1,1,3';
            Caption = 'Global Dimension 3 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3));
        }
        field(51032; "Global Dimension 4 Code"; Code[20])
        {
            CaptionClass = '1,1,4';
            Caption = 'Global Dimension 4 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4));
        }
        field(51033; "Global Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,1,5';
            Caption = 'Global Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5));
        }
        field(51034; "Global Dimension 6 Code"; Code[20])
        {
            CaptionClass = '1,1,6';
            Caption = 'Global Dimension 6 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6));
        }
        field(51035; "Global Dimension 7 Code"; Code[20])
        {
            CaptionClass = '1,1,7';
            Caption = 'Global Dimension 7 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7));
        }
        field(51036; "Global Dimension 8 Code"; Code[20])
        {
            CaptionClass = '1,1,8';
            Caption = 'Global Dimension 8 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8));
        }
        field(51037; "Applies-to Acc. Group Mixed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to accountant group mixed', Comment = 'ESM="Liq. Grupo contable mixto"';
        }
        field(51038; "Applies-to GC Mixed Create"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to GC Mixed Create', Comment = 'ESM="Liq. GC mixto creado"';
        }
        field(51039; "Acc. Gr. Mixed Base Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Acc. Gr. Mixed Base Entry No.', Comment = 'ESM="N° Mov. Origen Liq. GC Mixto"';
        }
        field(51040; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Factor', Comment = 'ESM="Factor divisa origen"';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(51041; "Source Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Code', Comment = 'ESM="Cód. Origen Divisa"';
        }
        field(51042; "Source Currency Type"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Type', Comment = 'ESM="Tipo de cambio Origen"';
            DecimalPlaces = 0 : 4;
            Editable = false;
            MinValue = 0;
        }
        field(51043; "Diff. reversal posting date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Diff. reversal posting date', Comment = 'ESM="Reversión con fecha diferida"';
        }

        //Legal Document Begin
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
            Caption = 'Legal Status', Comment = 'ESM="Estado Legal"';
            OptionMembers = "Success","Anulled","OutFlow";
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }
        //Legal Document End

        //Retentions
        field(51010; "Retention No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention No.', Comment = 'ESM="N° Retención"';
        }

        //Import
        field(51007; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESM="M° Importación"';
        }
        field(51051; "ST Document CV"; Code[20])
        {
            Description = 'ULN::PC 001';
            DataClassification = ToBeClassified;
            Caption = 'Document CV', Comment = 'ESM="Documento CV"';
        }
        field(51052; "ST Account CV"; Code[20])
        {
            Description = 'ULN::PC 001';
            DataClassification = ToBeClassified;
            Caption = 'Account CV', Comment = 'ESM="Cuenta CV"';
        }
        field(51053; "ST Date CV"; Date)
        {
            Description = 'ULN::PC 001';
            DataClassification = ToBeClassified;
            Caption = 'Date CV', Comment = 'ESM="Fecha Real CV"';
        }
        field(57002; "Global Dimension FCT"; Code[20])
        {
            Caption = 'Global Dimension FCT', Comment = 'ESM="FCT"';
        }
        field(57003; "Global Dimension FE"; Code[20])
        {
            Caption = 'Global Dimension FE', Comment = 'ESM="FE"';
        }
    }
    keys
    {
        key(PK1; "Analityc Base Entry No.")
        {

        }
    }
}