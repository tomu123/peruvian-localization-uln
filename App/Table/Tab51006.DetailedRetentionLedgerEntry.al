table 51006 "Detailed Retention Ledg. Entry"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(51000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Entry No.';
        }
        field(51001; "Retention No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention No.';
        }
        field(51002; "Retention Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Posting Date';
        }
        field(51003; "Retention Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Retention Legal Document';
        }
        field(51004; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor No.';
        }
        field(51005; "Vendor Name"; Text[100])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Name';
        }
        field(51006; "Vendor Doc. Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Doc. Legal Document';
        }
        field(51007; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Invoice No.';
        }
        field(51008; "Vendor External Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor External Document No.';
        }
        field(51009; "Vendor Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'vendor Document No.';
        }
        field(51010; "Vendor Doc. Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Doc. Posting Date';
        }
        field(51011; "Vendor Document Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Vendor Document Date';
        }
        field(51012; "Amount Invoice"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Invoice';
        }
        field(51013; "Amount Invoice LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Invoice LCY';
        }
        field(51014; "Amount Paid"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Paid';
        }
        field(51015; "Amount Paid LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Paid LCY';
        }
        field(51016; "Amount Retention"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Retention';
        }
        field(51017; "Amount Retention LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Retention LCY';
        }
        field(51018; "Currency Factor"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Factor';
        }
        field(51019; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Currency Code';
        }
        field(51020; "Electronic Invoice"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Invoice';
        }
        field(51021; "Source Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Document No.';
        }
        field(51022; Reversed; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Reversed';
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