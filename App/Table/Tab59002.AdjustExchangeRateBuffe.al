table 59002 "ST Adjust Exchange Rate Buffer"
{
    Caption = 'Adjust Exchange Rate Buffer';
    ReplicateData = false;

    fields
    {
        field(1; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            DataClassification = SystemMetadata;
            TableRelation = Currency;
        }
        field(2; "Posting Group"; Code[20])
        {
            Caption = 'Posting Group';
            DataClassification = SystemMetadata;
        }
        field(3; AdjBase; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBase';
            DataClassification = SystemMetadata;
        }
        field(4; AdjBaseLCY; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjBaseLCY';
            DataClassification = SystemMetadata;
        }
        field(5; AdjAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'AdjAmount';
            DataClassification = SystemMetadata;
        }
        field(6; TotalGainsAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalGainsAmount';
            DataClassification = SystemMetadata;
        }
        field(7; TotalLossesAmount; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TotalLossesAmount';
            DataClassification = SystemMetadata;
        }
        field(8; "Dimension Entry No."; Integer)
        {
            Caption = 'Dimension Entry No.';
            DataClassification = SystemMetadata;
        }
        field(9; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
            DataClassification = SystemMetadata;
        }
        field(10; "IC Partner Code"; Code[20])
        {
            Caption = 'IC Partner Code';
            DataClassification = SystemMetadata;
        }
        field(11; Index; Integer)
        {
            Caption = 'Index';
            DataClassification = SystemMetadata;
        }
        field(51000; "Ref. Source Type"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
        }
        field(51001; "Ref. Source No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ref. Source No.';
        }
        field(51002; "Ref. Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ref. Document No.';
        }
    }

    keys
    {
        key(Key1; "Currency Code", "Posting Group", "Dimension Entry No.", "Posting Date", "IC Partner Code", "Ref. Source No.", "Ref. Document No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
