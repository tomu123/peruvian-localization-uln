pageextension 51001 "Legal Doc. Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Setup Source Code to User"; "Setup Source Code to User")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(PostAndSend)
        {
            Visible = false;
            Enabled = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
            Enabled = false;
        }
        addafter("Co&mments")
        {
            // action(ClearPostingNo)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Clear Posting No', Comment = 'ESM="Limpiar N° Registro"';
            //     Image = ClearLog;
            //     trigger OnAction()
            //     var
            //         FactVen: Record "Sales Header";
            //         Int: Integer;
            //     begin
            //         Int := 0;
            //         CurrPage.SetSelectionFilter(FactVen);
            //         if FactVen.FindSet() then
            //             repeat
            //                 FactVen."Posting No." := '';
            //                 FactVen.Modify();
            //                 Int += 1;
            //             until FactVen.Next() = 0;
            //         Message('Se limpiaron %1 documentos.', Int);
            //     end;
            // }
        }
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        FilterGroup(2);
        SetFilter("Internal Consumption", '%1', false);
        FilterGroup(0);
    end;
}