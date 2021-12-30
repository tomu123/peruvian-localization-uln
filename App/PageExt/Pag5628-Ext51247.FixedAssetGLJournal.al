pageextension 51247 "ST Fixed Asset G/L Journal" extends "Fixed Asset G/L Journal"
{
    layout
    {
        // Add changes to page layout here
        modify("Currency Code")
        {
            Visible = true;
            Editable = true;
        }
    }
}