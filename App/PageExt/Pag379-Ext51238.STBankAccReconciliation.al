pageextension 51238 "ST Bank Acc. Reconciliation" extends "Bank Acc. Reconciliation"
{
    layout
    {
    }

    actions
    { //ULN::PC    002 Begin Conciliación ++++
        modify(ImportBankStatement)
        {
            Visible = false;
            trigger OnBeforeAction()
            begin

            end;

            trigger OnAfterAction()
            begin

            end;
        }
        addlast("Ba&nk")
        {
            action(ImportBankStatement2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Bank Statement', Comment = 'ESM="Importar Estado..Cuenta Banco"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Import electronic bank statements from your bank to populate with data about actual bank transactions.', Comment = 'ESM="Importe extractos bancarios electrónicos de su banco para completar con datos sobre transacciones bancarias reales."';
                ;

                trigger OnAction()
                var
                    Notification: Notification;
                begin
                    CurrPage.UPDATE;
                    ImportBankStatementConcilation();

                end;

            }
            action(ImportExtractBank)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Extracto del banco', Comment = 'ESM="Importar Extracto del banco"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Import Extract bank statements from your bank to populate with data about actual bank transactions.', Comment = 'ESM="Importe extractos bancarios electrónicos de su banco para completar con datos sobre transacciones bancarias reales."';
                ;

                trigger OnAction()
                var

                begin
                    CurrPage.UPDATE;
                    gMgtmConciliation.fnImportExtractBank(Rec);

                end;

            }
        }
        //ULN::PC    002 Begin Conciliación ----
    }




    procedure fnReviewConcilationAfter()
    begin
        gRecBankAccount."Bank Statement Import Format" := gImportCode1;
        gRecBankAccount.Modify();
        CurrPage.Update();
    end;



    var
        gImportCode1: Code[20];
        gImportCode2: Code[20];
        gRecBankAccount: Record "Bank Account";
        gMgtmConciliation: Codeunit "Mgtm Conciliation";
}