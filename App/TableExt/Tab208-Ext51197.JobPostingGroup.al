tableextension 51197 "ST Job Posting Group" extends "Job Posting Group"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "ST Destination Prod. 79"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Destination Prod. 79', Comment = 'ESM="Destinos Prod. 79"';
            TableRelation = "G/L Account";
        }
        field(51001; "ST Destination Prod. 92"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Destination Prod. 92', Comment = 'ESM="Destinos Prod. 92"';
            TableRelation = "G/L Account";
        }
        field(51002; "ST Application Cost PT"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Application Cost PT', Comment = 'ESM="Applicación Costo Término"';
            TableRelation = "G/L Account";
        }


    }

    var
        myInt: Integer;
}