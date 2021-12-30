pageextension 51132 "ST Customer Ledger Entries" extends "Customer Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter("Document No.")
        {
            field("External Document No.2"; "External Document No.")
            {
                ApplicationArea = All;
            }
        }
        addfirst(Control1)
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Posting Date")
        {
            field("Document Date"; "Document Date")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Exported to Payment File")
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
            }
            field("Setup Source Code"; "Setup Source Code")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("Receivables Account"; "Receivables Account")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = All;
            }
        }
        addlast(Control1)
        {
            field("Bank Cash Outly"; "Bank Cash Outly")
            {
                ApplicationArea = All;
            }
            field("Bank Reference"; "Bank Reference")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        // Add changes to page actions here
        addlast("F&unctions")
        {
            action("Obtener Banco Referencia")
            {
                Visible = true;
                trigger OnAction()
                var
                    lclSetupLocalization: Codeunit "Setup Localization";
                    lclrecCustLedgerEntry: Record "Cust. Ledger Entry";
                begin
                    lclrecCustLedgerEntry.Reset();
                    lclrecCustLedgerEntry.SetFilter("Bank Reference", '%1', '');
                    if lclrecCustLedgerEntry.FindSet() then
                        repeat
                            lclSetupLocalization.fngetBankReference(lclrecCustLedgerEntry);
                            lclrecCustLedgerEntry.Modify();
                        until lclrecCustLedgerEntry.Next() = 0;
                    Message('Actualizado ! ');
                end;
            }
        }
        addafter(ReverseTransaction)
        {
            action(ReverseTransactionLocalization)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Reverse Transaction Loc.', Comment = 'ESM="Revertir Transacción Loc."';
                Ellipsis = true;
                Image = ReverseRegister;
                Promoted = true;
                PromotedCategory = Process;
                Visible = ReverseTransactionEnabled;
                Scope = Repeater;
                ToolTip = 'Reverse an erroneous customer ledger entry.', Comment = 'ESM="Revierte movimiento de clientes errados"';

                trigger OnAction()
                var
                    ReversalEntry: Record "Reversal Entry";
                begin
                    Clear(ReversalEntry);
                    if Reversed then
                        ReversalEntry.AlreadyReversedEntry(TableCaption, "Entry No.");
                    if "Journal Batch Name" = '' then
                        ReversalEntry.TestFieldError;
                    TestField("Transaction No.");
                    Clear(ReverseMgtLoc);
                    ReverseMgtLoc.SetEnabledProcess();
                    ReverseMgtLoc.SetReverseDate("Posting Date");
                    ReverseMgtLoc.SetReverseReason(Description);
                    ReversalEntry.ReverseTransaction("Transaction No.");
                end;
            }
        }
        modify(ReverseTransaction)
        {
            // Visible = not ReverseTransactionEnabled;
            // Enabled = not ReverseTransactionEnabled;
            trigger OnBeforeAction()
            begin
                Clear(ReverseMgtLoc);
                ReverseMgtLoc.SetDisabledProcess();
            end;
        }
    }

    trigger OnOpenPage()
    begin
        // if STSetup.Get() then
        //     ReverseTransactionEnabled := STSetup."ST Enabled Reverse";
        if STSetupUser.Get(UserId) then
            ReverseTransactionEnabled := STSetupUser."Reverse Transaction";
    end;

    var
        STSetup: Record "Setup Localization";
        STSetupUser: Record "User Setup";
        ReverseMgtLoc: Codeunit "Reverse Mgt. Localization";
        ReverseTransactionEnabled: Boolean;
}