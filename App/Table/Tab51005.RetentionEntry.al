table 51005 "Retention Ledger Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.', Comment = 'ESM="No. Movimiento"';
        }
        field(51001; "Retention No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention No.', Comment = 'ESM="No. Retención"';
        }
        field(51002; "Retention Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Posting Date', Comment = 'ESM="Fecha Registro Retención"';
        }
        field(51003; "Retention Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Legal Document', Comment = 'ESM="Documento Legal Retención"';
        }
        field(51004; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.', Comment = 'ESM="No. Proveedor"';
        }
        field(51005; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name', Comment = 'ESM="Nombre Proveedor"';
        }
        field(51006; "Amount Invoice"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Invoice" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Invoice', Comment = 'ESM="Importe Factura"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51007; "Amount Invoice LCY"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Invoice LCY" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Invoice LCY', Comment = 'ESM="Importe Factura DL"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51008; "Amount Paid"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Paid" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Paid', Comment = 'ESM="Importe Pagado"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51009; "Amount Paid LCY"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Paid LCY" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Paid LCY', Comment = 'ESM="Importe Pagado DL"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51010; "Amount Retention"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Retention" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Retention', Comment = 'ESM="Importe Retención"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51011; "Amount Retention LCY"; Decimal)
        {
            CalcFormula = Sum("Detailed Retention Ledg. Entry"."Amount Retention LCY" WHERE("Retention No." = field("Retention No.")));
            Caption = 'Amount Retention LCY', Comment = 'ESM="Importe Retención DL"';
            Editable = false;
            FieldClass = FlowField;
        }
        field(51012; "Source Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Document No.', Comment = 'ESM="No. Documento Origen"';
        }
        field(51013; "Source Jnl Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Jnl Template Name';
        }
        field(51014; "Source Jnl Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Jnl Batch Name';
        }
        field(51015; "Assing User ID"; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Assign User ID', Comment = 'ESM="ID Usuario Asignado"';
        }
        field(51016; "Electronic Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Processed,"In Process",Duplicated;
            OptionCaption = ' ,Processed,In Process,Duplicated';
        }
        field(51017; "Electronic Response"; Text[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Response';
        }
        field(51018; "Elec. Response Description"; Text[2045])
        {
            DataClassification = ToBeClassified;
            Caption = 'Elec. Resp. Description';
        }
        field(51019; "Hash Code"; Text[150])
        {
            DataClassification = ToBeClassified;
            Caption = 'Hash Code', Comment = 'ESM="Cód. Hash"';
        }
        field(51020; "Reversion Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversion Date', Comment = 'ESM="Fecha Reversión"';
        }
        field(51021; "Reversion Motive"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversion Motive', Comment = 'ESM="Motivo Reversión"';
        }
        field(51022; "Reversion XML File"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversion XML File Name';
        }
        field(51023; "Error Code"; Code[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Error Code', Comment = 'ESM="Cód. Error"';
        }
        field(51024; "Reversed"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversed', Comment = 'ESM="Reversado"';
            trigger OnValidate()
            begin
                ReverseDetail();
            end;
        }
        field(51025; "Manual Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Retention', Comment = 'ESM= "Retención Manual"';
        }
        field(51026; "Legal Status"; Option)
        {
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }

    var
        DtldRetentionLedgEntry: Record "Detailed Retention Ledg. Entry";

    local procedure ReverseDetail()
    begin
        if IsEmpty then
            exit;
        DtldRetentionLedgEntry.Reset();
        DtldRetentionLedgEntry.SetRange("Retention No.", "Retention No.");
        DtldRetentionLedgEntry.ModifyAll(Reversed, Reversed);
    end;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}