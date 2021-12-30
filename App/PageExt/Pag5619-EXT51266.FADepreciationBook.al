pageextension 51267 "ST FA Depreciation Books" extends "FA Depreciation Books"
{
    layout
    {
        addlast(Control1)
        {
            field("Acquisition Cost"; "Acquisition Cost")
            {
                ApplicationArea = All;
            }
            field(Depreciation; Depreciation)
            {
                ApplicationArea = All;
            }
        }
    }
}