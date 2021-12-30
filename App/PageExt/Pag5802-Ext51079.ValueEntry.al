pageextension 51079 "Import Value Entry" extends "Value Entries"
{
    layout
    {
        addafter("External Document No.")
        {
            // control with underlying datasource
            field("Importation No."; "Importation No.")
            {
                ApplicationArea = All;
            }
            field(Nationalization; Nationalization)
            {
                ApplicationArea = All;
            }
        }
    }
}