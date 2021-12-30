table 59006 "Collection Payment Buffer"
{
    DataClassification = ToBeClassified;

    fields

    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(3; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(6; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(8; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(11; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(13; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(14; "Remaining Amount"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry".Amount WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                         "Posting Date" = FIELD("Date Filter")));
            Caption = 'Remaining Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; "Original Amt. (LCY)"; Decimal)
        {
            Caption = 'Original Amt. (LCY)';
        }
        field(16; "Remaining Amt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE("Cust. Ledger Entry No." = FIELD("Entry No."),
                                                                                 "Posting Date" = FIELD("Date Filter")));
            Caption = 'Remaining Amt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(21; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
        }
        field(28; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(37; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(62; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(76; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
        }
        field(50000; "Post File"; Text[50])
        {
            Caption = 'Tipo Archivo';
        }
        field(50001; "Post Type"; Text[50])
        {
            Caption = 'Tipo Registro';
        }
        field(50002; "Bank Account No."; code[20])
        {
            Caption = 'Cuenta recaudo banco no.';
        }
        field(50003; "Collection Bank"; Text[50])
        {
            Caption = 'Banco Proceso';
        }
        field(52003; "No. Suministro"; Code[20])
        {
            DataClassification = ToBeClassified;
            // TableRelation = Suministros."No. Suministro" where("Customer No." = field("Customer No."));
        }
        field(50004; "Post Type Descripción"; Text[90])
        {
            Caption = 'Tipo Registro';
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
        myInt: Record 21;

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

    [IntegrationEvent(true, false)]
    procedure onAfterCopyFromCustLedgEntry(var Rec: Record "Collection Payment Buffer"; var recCust: Record "Cust. Ledger Entry");
    begin
    end;
}