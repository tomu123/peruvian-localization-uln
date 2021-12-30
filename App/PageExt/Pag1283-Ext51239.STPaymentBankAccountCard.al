pageextension 51239 "ST Payment Bank Account Card" extends "Payment Bank Account Card"
{
    layout
    {
        ////ULN::PC    002 Begin Conciliación ++++
        addafter("Bank Statement Import Format")
        {
            field("Import Format Bank statement"; "Import Format Statement")
            {
                ApplicationArea = All;
            }
        }
        //ULN::PC    002 Begin Conciliación ----
    }
}