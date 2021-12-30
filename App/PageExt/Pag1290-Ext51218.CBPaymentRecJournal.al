pageextension 51218 "CB Payment Rec Journal" extends "Payment Reconciliation Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(GetAppliedToDocumentNo)
        {
            field("Suministro No"; "Suministro No")
            {
                ApplicationArea = All;
                Caption = 'Suministro No.';
                Editable = false;
            }
        }
    }
    actions
    {
        // Add changes to page actions here
        addafter(PostPaymentsOnly)
        {
            action(DeleteMatchConfidenceNoneTypeEntries)
            {
                ApplicationArea = All;
                Caption = 'Delete "none" type lines', Comment = 'ESM="Eliminar lineas tipo (Ninguno)';
                Image = DeleteRow;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    BankAccReconciliationLine: Record "Bank Acc. Reconciliation Line";
                begin
                    if IsEmpty then
                        exit;

                    BankAccReconciliationLine.Reset();
                    BankAccReconciliationLine.SetRange("Statement No.", "Statement No.");
                    BankAccReconciliationLine.SetRange("Bank Account No.", "Bank Account No.");
                    BankAccReconciliationLine.SetRange("Match Confidence", "Match Confidence"::None);
                    if not BankAccReconciliationLine.IsEmpty then
                        if Confirm('¿Desea eliminar la(s) %1 linea(s)?', false, BankAccReconciliationLine.Count) then
                            BankAccReconciliationLine.DeleteAll();
                end;
            }
        }
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
    }

    trigger OnAfterGetRecord()
    begin
        if (not OnlyOnce) and (not IsEmpty) then begin
            MgtConColletion.SearchObserved("Statement No.", "Statement Type", "Bank Account No.");
            if MgtConColletion.IsExistObserved() then begin
                MgtConColletion.ShowNotificationForReconLineObserved("Statement No.", "Statement Type", "Bank Account No.", MyMessage);
                OnlyOnce := true;
            end;
        end;
    end;

    var
        MgtConColletion: Codeunit "Mgmt Collection";
        MyMessage: Label 'Existen movimiento de conciliación que no fueron liquidados, para revisar.';
        OnlyOnce: Boolean;

    /*local procedure ValidateDocumentNo(var pBanAccRecLine: Record "Bank Acc. Reconciliation Line")
    var
        DocNo: Code[20];
    begin
        if not pBanAccRecLine.FindFirst then
            exit;

        repeat
            DocNo := getDocNo(pBanAccRecLine."Data Exch. Entry No.", 5, pBanAccRecLine."Transaction ID");
            if DocNo <> '' then begin
                pBanAccRecLine."Document No." := DocNo;
                pBanAccRecLine.Modify;
            end;
        until pBanAccRecLine.Next = 0;
    end;

    local procedure getDocNo(pEntryNo: Integer; pColumn: Integer;
                                        pValue: Text[250]) rDocNo: Code[20]
    var
        DataExchField: Record "Data Exch. Field";
        DataExchFieldDoc: Record "Data Exch. Field";
    begin
        DataExchField.Reset();
        DataExchField.SetRange("Data Exch. No.", pEntryNo);
        DataExchField.SetRange("Column No.", pColumn);
        DataExchField.SetRange(Value, pValue);
        if DataExchField.FindFirst then begin
            DataExchFieldDoc.SetRange("Data Exch. No.", pEntryNo);
            DataExchFieldDoc.SetRange("Column No.", 1);
            DataExchFieldDoc.SetRange("Line No.", DataExchField."Line No.");
            if DataExchFieldDoc.FindFirst then
                rDocNo := DataExchFieldDoc.Value;
        end;
        exit(rDocNo);
    end;*/
}