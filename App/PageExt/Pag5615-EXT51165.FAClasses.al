pageextension 51165 "LD FA Classes" extends "FA Classes"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field(Leasing; Leasing)
            {
                ApplicationArea = All;
            }
            field("LD Intangible Status"; "LD Intangible Status")
            {
                ApplicationArea = All;
            }
        }
    }
}