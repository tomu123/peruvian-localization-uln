tableextension 51113 "Employee Ledger Entry" extends "Employee Ledger Entry"
{
    fields
    {
        // Add changes to table fields here 51000..51020
        field(51002; "Source Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Currency Factor', Comment = 'ESM="Factor divisa de origen"';
        }
        field(51004; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Texto registro"';
        }
        field(51005; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen procesos"';
        }

        field(51006; "Closed by Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Closed by Currency Code', Comment = 'ESM="Cerrado por cód. divisa"';
            TableRelation = Currency;
        }
        field(51007; "Closed by Currency Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Closed by Currency Amount', Comment = 'ESM="Cerrado por importe en divisa"';
            AutoFormatType = 1;
            AutoFormatExpression = "Closed by Currency Code";
            AccessByPermission = tabledata Currency = R;
        }
        // field(51008; "Adjusted Currency Factor"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Adjusted Currency Factor', Comment = 'ESM="Factor divisa ajustada"';
        // }
        // field(51009; "Original Currency Factor"; Decimal)
        // {
        //     DataClassification = ToBeClassified;
        //     Caption = 'Original Currency Factor', Comment = 'ESM="Factor divisa original"';
        // }
        field(51010; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
            Caption = 'External Document No.', Comment = 'ESM="N° Documento Externo"';
        }
        field(51011; "Payment Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Bank Account No.', Comment = 'ESM="Cód. Banco pago"';
            TableRelation = "ST Employee Bank Account"."Payment Bank Account No." where("Employee No." = field("Employee No."));
            ValidateTableRelation = false;
        }
        field(51012; "Payment is check"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment is check', Comment = 'ESM="Pago con cheque"';
        }
        field(51013; "Recipient Bank Account"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Recipient Bank Account', Comment = 'ESM="Cta. bancaria destinatario"';
            TableRelation = "ST Employee Bank Account".Code where("Employee No." = field("Employee No."));
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
            Caption = 'Payables Account', Comment = 'ESM="Cuenta empleado"';
        }
        field(51022; "Diff. reversal posting date"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Diff. reversal posting date', Comment = 'ESM="Reversión con fecha diferida"';
        }

        //Payment Schedule
        field(51041; "PS Not Show Payment Schedule"; Boolean)
        {
            CalcFormula = lookup("Employee Posting Group"."PS Not Show" WHERE(Code = FIELD("Employee Posting Group")));
            Caption = 'Not Show Payment Schedule', Comment = 'ESM="No Mostrar en Crono. Pagos"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51042; "PS Due Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Due Date', Comment = 'ESM="Fecha Vencimiento"';
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
        Codeunit224: Codeunit 224;
        table21: Record 21;
}