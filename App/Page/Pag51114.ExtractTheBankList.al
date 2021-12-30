page 51114 "Extract The Bank List"
{   //ULN::PC    002 OBJECT CREATED
    AutoSplitKey = true;
    Caption = 'Bank Acc. Reconciliation Line', Comment = 'ESM="extracto del banco"';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Extract The Bank";
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Transaction Date"; "Transaction Date")
                {
                    Editable = false;
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies the posting date of the bank account or check ledger entry on the reconciliation line when the Suggest Lines function is used.';
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies a number of your choice that will appear on the reconciliation line.';
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a description for the transaction on the reconciliation line.';
                    Editable = false;
                }
                field("Description 2"; "Description 2")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = StyleTxt;
                    ToolTip = 'Specifies a description for the transaction on the reconciliation line.';
                    Editable = NOT Closed;
                }

                field("Transaction Text"; "Transaction Text")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }
                field("Closed"; Closed)
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

                field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = Basic, Suite;
                    Editable = false;
                }

            }

        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportBankStatement2)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Import Extract the bank', Comment = 'ESM="Importar Extracto del Banco"';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Extract the bank   from your bank to populate with data about actual bank transactions.', Comment = 'ESM="Importe extractos bancarios electrónicos de su banco para completar con datos sobre transacciones bancarias reales."';
                ;

                trigger OnAction()
                var
                    CUMgtmConciliation: Codeunit "Mgtm Conciliation";
                begin
                    CurrPage.UPDATE;
                    CUMgtmConciliation.ImportExtractbank(fnGetBank());

                end;

            }
            action(ClosedToEntries)
            {
                ApplicationArea = All;
                Caption = 'Close To Entries', Comment = 'ESM="Cerrar Movs. Bancos"';
                Image = PostApplication;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                trigger OnAction()
                var
                    lclExtractTheBank: Record "Extract The Bank";
                    lclClosedCount: Integer;
                    lclOpenCount: Integer;
                    lclText001: Label 'Process Finished Closed %1 | Open 2% ', Comment = 'ESM="Proceso Finalizado Mov. cerrados %1 | Mov. abiertos %2 "';
                    lclExtractTheBankGeneral: Record "Extract The Bank";
                begin
                    if not Confirm('¿Desea modificar los Movs. Bancos?', false) then
                        exit;

                    CurrPage.SetSelectionFilter(lclExtractTheBank);
                    lclExtractTheBank.SetFilter("Description 2", '%1', '');
                    if lclExtractTheBank.FindSet() then
                        Error('Descripción Atria debe tener valor ,Nro Documento ' + lclExtractTheBank."Document No.");

                    CurrPage.SetSelectionFilter(lclExtractTheBank);


                    if lclExtractTheBank.FindSet() then
                        repeat
                            case lclExtractTheBank.Closed OF
                                true:
                                    begin
                                        lclOpenCount += 1;
                                        lclExtractTheBank.Closed := false;
                                    end;
                                false:
                                    begin
                                        lclExtractTheBank.Closed := true;
                                        lclClosedCount += 1;
                                    end;
                            END;

                            lclExtractTheBank.Modify();
                        until lclExtractTheBank.Next() = 0;

                    lclClosedCount := 0;
                    lclOpenCount := 0;

                    lclExtractTheBankGeneral.Reset();
                    lclExtractTheBankGeneral.SetRange("Bank Account No.", gBankCode);
                    lclExtractTheBankGeneral.SetFilter(Closed, '%1', true);
                    if lclExtractTheBankGeneral.FindSet() then
                        lclClosedCount := lclExtractTheBankGeneral.Count;

                    lclExtractTheBankGeneral.Reset();
                    lclExtractTheBankGeneral.SetRange("Bank Account No.", gBankCode);
                    lclExtractTheBankGeneral.SetFilter(Closed, '%1', false);
                    if lclExtractTheBankGeneral.FindSet() then
                        lclOpenCount := lclExtractTheBankGeneral.Count;

                    Message(StrSubstNo(lclText001, lclClosedCount, lclOpenCount));
                end;
            }

        }
    }

    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnAfterGetRecord()
    begin

    end;

    trigger OnDeleteRecord(): Boolean
    begin

    end;

    trigger OnInit()
    begin
        BalanceEnable := true;
        TotalBalanceEnable := true;
        TotalDiffEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin

    end;

    procedure fnSetBank(pBank: code[20])
    begin
        gBankCode := pBank;
    end;

    procedure fnGetBank(): code[20]
    begin
        exit(gBankCode);
    end;

    var
        gExtractTheBank: Record "Extract The Bank";
        StyleTxt: Text;
        TotalDiff: Decimal;
        Balance: Decimal;
        TotalBalance: Decimal;
        [InDataSet]
        TotalDiffEnable: Boolean;
        [InDataSet]
        TotalBalanceEnable: Boolean;
        [InDataSet]
        BalanceEnable: Boolean;
        ApplyEntriesAllowed: Boolean;
        gBankCode: code[20];


}
