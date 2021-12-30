/*table 59015 "Response XML"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Response Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; Status; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Response Text"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Response Code")
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

}*/