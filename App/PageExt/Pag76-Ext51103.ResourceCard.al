pageextension 51103 "Setup Resource Card" extends "Resource Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Personal Data")
        {
            group(SetupLocalization)
            {
                Caption = 'Setup Localization';
                field(FirstField; FirstField)
                {
                    Visible = false;
                    Editable = false;
                }
            }
        }
    }

    var
        FirstField: Text;
}