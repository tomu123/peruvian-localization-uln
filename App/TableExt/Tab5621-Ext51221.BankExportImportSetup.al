tableextension 51221 "ST Bank Export/Import Setup" extends "Bank Export/Import Setup"
{
    fields
    {
        //ULN::PC    002 Begin Conciliación +++++++++++
        field(51000; "ST Bank statement"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Bank statement', Comment = 'ESM="Extracto bancario"';
            trigger OnValidate()
            begin

            end;
        }
        //ULN::PC    002 Begin Conciliación ----------
    }

    var
        myInt: Page "Bank Acc. Reconciliation";
}