pageextension 51237 "ST Bank Export Import Setup" extends "Bank Export/Import Setup"
{
    layout
    {
        //ULN::PC    002 Begin Conciliación ++++
        addafter(Direction)
        {
            field("ST Bank statement"; "ST Bank statement")
            {
                ApplicationArea = All;
            }
        }
        //ULN::PC    002 Begin Conciliación ----
    }
}