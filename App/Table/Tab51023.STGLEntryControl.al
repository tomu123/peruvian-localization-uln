table 51023 "ST G/L Entry - Control"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(59000; "Entry No. 2"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(52; "Transaction No."; Integer)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No. 2")
        {
            Clustered = true;
        }
    }
}