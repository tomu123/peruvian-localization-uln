pageextension 51185 "General Journal Templates-ADD" extends 101
{
    layout
    {
        // Add changes to page layout here
        addbefore("No. Series")
        {
            field(ImportarPlanilla; ImportarPlanilla)
            {
                Caption = 'Importar Planilla';
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}