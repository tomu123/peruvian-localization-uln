pageextension 51256 "ST Bank Account Statement List" extends "Bank Account Statement List"
{
    layout
    {
    }

    actions
    {
        addlast(Processing)
        {
            action(Conciliation)
            {
                Caption = 'Conciliation', Comment = 'ESM="conciliación"';
                Image = Report;
                trigger OnAction()
                begin
                    SETRECFILTER;
                    REPORT.RUNMODAL(51065, TRUE, TRUE, Rec);
                    RESET;
                    SETRANGE("Bank Account No.", "Bank Account No.");
                    CurrPage.UPDATE;
                end;
            }





        }

    }




    var

}