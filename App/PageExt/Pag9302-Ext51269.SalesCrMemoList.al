pageextension 51269 "ST Sales Cr. Memos" extends "Sales Credit Memos"
{
    layout
    {
        // Add changes to page layout here
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
            //         SalesCrMemo: Record "Sales Header";
            //         Int: Integer;
            //     begin
            //         Int := 0;
            //         CurrPage.SetSelectionFilter(SalesCrMemo);
            //         if SalesCrMemo.FindSet() then
            //             repeat
            //                 SalesCrMemo."Posting No." := '';
            //                 SalesCrMemo.Modify();
            //                 Int += 1;
            //             until SalesCrMemo.Next() = 0;
            //         Message('Se limpiaron %1 documentos.', Int);
            //     end;
            // }
        }
    }

    var
        myInt: Integer;
}