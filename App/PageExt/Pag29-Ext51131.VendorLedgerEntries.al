pageextension 51131 "ST Vendor Ledger Entries" extends "Vendor Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addfirst(Control1)
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addbefore("Document Type")
        {
            field("Document No"; "Document No.")
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
            }
            field("Payment Terms Code"; "Payment Terms Code")
            {
                ApplicationArea = All;
            }
            field("Payables Account"; "Payables Account")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("Retention No."; "Retention No.")
            {
                ApplicationArea = All;
            }
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = All;
            }
        }
        //Payment Schedule
        addafter("Vendor No.")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = All;
            }
        }

        addafter("Exported to Payment File")
        {
            field("PS Not Show Payment Schedule"; "PS Not Show Payment Schedule")
            {
                ApplicationArea = All;
            }
        }

        addbefore("Due Date")
        {
            field("Accountant receipt date"; "Accountant receipt date")
            {
                ApplicationArea = All;
            }
        }
        addafter("Payment Reference")
        {
            field("Payment Bank Account No."; "Payment Bank Account No.")
            {
                ApplicationArea = All;
            }
            field("Global Dimension FCT"; "Global Dimension FCT")
            {
                ApplicationArea = All;
            }
            field("Global Dimension FE"; "Global Dimension FE")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(UnapplyEntries)
        {
            action(UnapplyUniqueEntries)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Unapply Unique Entries', Comment = 'ESM="Desliquidar mov. único"';
                Ellipsis = true;
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Unselect one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    STVendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                begin
                    STVendEntryApplyPostedEntries.UnApplyVendLedgEntry("Entry No.");
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
                ToolTip = 'Reverse an erroneous vendor ledger entry.', Comment = 'ESM="Revierte movimiento de proveedor errados"';

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