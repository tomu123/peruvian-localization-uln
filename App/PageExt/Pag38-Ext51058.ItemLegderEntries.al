pageextension 51058 "Import Item Ledger Entries" extends "Item Ledger Entries"
{
    layout
    {
        addafter("Applied Entry to Adjust")
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
            field("Closed Import"; "Closed Import")
            {
                ApplicationArea = All;
            }
        }
    }
}