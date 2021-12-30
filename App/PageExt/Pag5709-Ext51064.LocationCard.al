pageextension 51264 "LC Get Receipt Lines" extends "Get Receipt Lines"
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; "Description 2")
            {
                ApplicationArea = All;
            }
        }
    }
}