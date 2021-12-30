page 51067 "ULN CUO Entries"
{
    PageType = List;
    Caption = 'CUO Entries', Comment = 'ESM="Movimientos de CUO"';
    ApplicationArea = All;
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;
    SourceTable = "ULN CUO Entry";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("CUO Transaction No."; "CUO Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("Last. used CUO Correlative"; "Last. used CUO Correlative")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(CorrectionCUO)
            {
                ApplicationArea = All;
                Caption = 'Correction CUO Entries', Comment = 'ESM="Corregir mov. de CUO"';
                Visible = EnabledAdminUser;
                Enabled = EnabledAdminUser;
                Image = CancelledEntries;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Clear(CUOMgt);
                    if not Confirm(ConfirmCorrect) then
                        exit;
                    CUOMgt.CreateCUOForBlankLines()
                end;
            }
            action(CreateCUOForBlankLines)
            {
                ApplicationArea = All;
                Caption = 'Create CUOs', Comment = 'ESM="Crear Lines de CUO"';
                Visible = EnabledAdminUser;
                Enabled = EnabledAdminUser;
                Image = CreateLinesFromJob;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Clear(CUOMgt);
                    if not Confirm(ConfirmCreateLine) then
                        exit;
                    CUOMgt.CreateCUOForBlankLines()
                end;
            }
        }
    }

    var
        SLSetup: Record "Setup Localization";
        CUOMgt: Codeunit "CUO Management";
        EnabledAdminUser: Boolean;

        ConfirmCorrect: Label 'You want to correct the movement of document %1?', Comment = 'ESM="¿Desea corregir los movimientos del documento %1?"';
        ConfirmCreateLine: Label 'You want to create CUO lines for blank documents?', Comment = 'ESM="¿Desea crear los registro CUOs para los movimientos de contabilidad sin CUOs asignados?"';

    trigger OnOpenPage()
    begin
        SLSetup.Get();
        EnabledAdminUser := SLSetup."User Id. CUO Administrator" = UserId;
    end;
}