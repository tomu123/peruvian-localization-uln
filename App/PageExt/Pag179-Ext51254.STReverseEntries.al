pageextension 51254 "ST Reverse Entries" extends "Reverse Entries"
{
    actions
    {
        // Add changes to page actions here
        modify(Reverse)
        {
            trigger OnBeforeAction()
            begin
                if not STSetup."ST Enabled Reverse" then
                    exit;
                ReverseMgtLoc.SetReverseDate()
            end;
        }
    }

    trigger OnOpenPage()
    begin
        STSetup.Get()
    end;

    var
        STSetup: Record "Setup Localization";
        ReverseMgtLoc: Codeunit "Reverse Mgt. Localization";
}