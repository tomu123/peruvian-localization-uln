tableextension 51045 "Setup Vend. Ledger Entry" extends "Vendor Ledger Entry"
{
    fields
    {
        // Add changes to table fields here 51002..51004,51020..51025
        field(51002; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Factor', Comment = 'ESM="Factor div. origen"';
        }
        field(51004; "Posting Text"; Text[250])
        {
            Caption = 'Posting Text', Comment = 'ESM="Texto registro"';
        }
        field(51005; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
        }
        field(51020; "Payment Terms Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Terms Code', Comment = 'ESM="Cód. Términos de pago"';
            TableRelation = "Payment Terms";
        }
        field(51021; "Payables Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payables Account', Comment = 'ESM="Cuenta pago"';
        }
        field(51022; "Diff. reversal posting date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Diff. reversal posting date', Comment = 'ESM="Reversión con fecha diferida"';
        }
        /*field(51022; "Applies-to Acc. Group Mixed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to accountant group mixed', Comment = 'ESM="Liq. Grupo contable mixto"';
        }*/
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

        //Retentions Begin
        field(51010; "Retention No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention No.', Comment = 'ESM="N° Retención"';
        }
        field(51011; "Retention Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Amount', Comment = 'ESM="Importe retención"';
        }
        field(51012; "Retention Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Amount LCY', Comment = 'ESM="Importe Retención (DL)"';
        }
        field(51013; "Applied Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applied Retention', Comment = 'ESM="Retención aplicada"';
        }
        //Retentions End

        //Paymetn Schedule
        field(51031; "PS Not Show Payment Schedule"; Boolean)
        {
            CalcFormula = lookup("Vendor Posting Group"."PS Not Show" WHERE(Code = FIELD("Vendor Posting Group")));
            Caption = 'Not Show Payment Schedule', Comment = 'ESM="No Mostrar en Crono. Pagos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51055; "Accountant receipt date"; date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Accountant receipt date', Comment = 'ESM="Fecha recepción contabilidad"';
            Editable = false;

        }
        field(57001; "Payment Bank Account No."; Code[10])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Vendor No."));
            Caption = 'Payment Bank Account No.', Comment = 'ESM="N° banco de pago"';
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

    var
        myInt: Integer;
}