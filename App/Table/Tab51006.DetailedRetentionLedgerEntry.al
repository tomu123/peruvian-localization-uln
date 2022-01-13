table 51006 "Detailed Retention Ledg. Entry"
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
        field(51006; "Vendor Doc. Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Doc. Legal Document', Comment = 'ESM="Documento Legal Proveedor"';
        }
        field(51007; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Invoice No.', Comment = 'ESM="No. Factura Proveedor"';
        }
        field(51008; "Vendor External Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor External Document No.', Comment = 'ESM="No. Documento Externo Proveedor"';
        }
        field(51009; "Vendor Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'vendor Document No.', Comment = 'ESM="No. Documento Proveedor"';
        }
        field(51010; "Vendor Doc. Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Doc. Posting Date', Comment = 'ESM="Fecha Registro Doc. Proveedor"';
        }
        field(51011; "Vendor Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Document Date', Comment = 'ESM="Fecha Emisión Proveedor"';
        }
        field(51012; "Amount Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Invoice', Comment = 'ESM="Importe Factura"';
        }
        field(51013; "Amount Invoice LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Invoice LCY', Comment = 'ESM="Importe Factura DL"';
        }
        field(51014; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Paid', Comment = 'ESM="Importe Pagado"';
        }
        field(51015; "Amount Paid LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Paid LCY', Comment = 'ESM="Importe Pagado DL"';
        }
        field(51016; "Amount Retention"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Retention', Comment = 'ESM="Importe Retención"';
        }
        field(51017; "Amount Retention LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Retention LCY', Comment = 'ESM="Importe Reteciones DL"';
        }
        field(51018; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Factor', Comment = 'ESM="Factor Divisa"';
        }
        field(51019; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code', Comment = 'ESM="Cód. Divisa"';
        }
        field(51020; "Electronic Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Invoice', Comment = 'ESM="Factura Electrónica"';
        }
        field(51021; "Source Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Document No.', Comment = 'ESM="No. Documento Origen"';
        }
        field(51022; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversed', Comment = 'ESM="Reversado"';
        }
        field(51023; "Source Jnl Template Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Jnl Template Name';
        }
        field(51024; "Source Jnl Batch Name"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Jnl Batch Name';
        }
        field(51025; "Manual Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Retention', Comment = 'ESM= "Retención Manual"';
        }
        field(51026; "Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Line No.', Comment = 'ESM= "N° Linea"';
        }
        field(51027; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Document No.', Comment = 'ESM= "N° Linea"';
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(PK2; "Vendor No.", "Retention No.")
        {

        }

        key(PK3; "Retention No.", "Entry No.")
        {

        }
    }

    var
        Page349: Page Navigate;

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