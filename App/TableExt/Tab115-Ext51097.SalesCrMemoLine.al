tableextension 51097 "FT Sales Cr.Memo Line" extends "Sales Cr.Memo Line"
{
    fields
    {
        // Add changes to table fields here
        field(51015; "FT Free Title Line"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Free Title Line';
        }
        field(51907; "Cluster Items"; code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Cluster Items', Comment = 'ESM="Prod. Agrupador"';
            TableRelation = Item."No.";
        }
    }
}