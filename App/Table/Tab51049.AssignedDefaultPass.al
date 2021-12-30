table 51049 "Assigned Default Pass"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type Table"; Option)
        {
            //DataClassification = ToBeClassified;
            OptionMembers = Employee,Vendor;
        }
        field(2; "Document No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Password"; Text[30])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Type Table", "Document No.")
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