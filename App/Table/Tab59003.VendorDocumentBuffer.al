table 59003 "PS Vendor Document Buffer"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(59000; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(59001; "Document Type"; Text[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59002; "BC Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59003; "Document Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59004; "Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59005; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59006; "Vendor Name"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(59007; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59008; "Vendor Invoice No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59009; "Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59010; "Currency Amount Type"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59011; "Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59012; "Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59013; "Posting text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(59014; "Applied Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(59015; "Applied Posting Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59016; "Applied Currency Code"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(59017; "Applied Curr. Amt Type"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59018; "Applied Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59019; "Applied Amount LCY"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(59020; "Payment Schedule Date"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(59021; "Status"; Text[50])
        {
            DataClassification = ToBeClassified;
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
        myInt: Integer;

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