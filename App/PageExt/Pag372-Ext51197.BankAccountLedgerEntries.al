pageextension 51197 "LU Bank Acc. Ledger Entries" extends "Bank Account Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Posting Date")
        {
            field("Transaction No."; "Transaction No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Document No.")
        {
            field("External Document No."; "External Document No.")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter("Reverse Transaction")
        {
            action(PrintVoucher)
            {
                ApplicationArea = All;
                Caption = 'Print Voucher', Comment = 'ESM="Imprimir Voucher"';
                Image = Report;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Report;

            }
        }
    }

    var
        BankAccLedgerEntry: Record "Bank Account Ledger Entry";
        BankAccLedgerEntry2: Record "Bank Account Ledger Entry";
        SourceCode: Record "Source Code";
        BankAccount: Record "Bank Account";
        OutputVoucher: Report "Output Voucher";
        InputVoucher: Report "Input Voucher";

    local procedure PrintVoucher()
    begin
        CurrPage.SetSelectionFilter(BankAccLedgerEntry2);

        SourceCode.Reset();
        SourceCode.SetRange(Code, "Source Code");
        if SourceCode.FindSet() then begin
            if (BankAccount.Get(Rec."Bal. Account No.")) and ("Bal. Account Type" = "Bal. Account Type"::"Bank Account") then begin
                OutputVoucher.SetTableView(BankAccLedgerEntry2);
                OutputVoucher.Run();
                //REPORT.RUNMODAL(51139, true, true, BankAccLedgerEntry2);
            end else
                if Reversed then begin
                    BankAccLedgerEntry.Reset();
                    BankAccLedgerEntry.SetRange("Document No.", Rec."Document No.");
                    BankAccLedgerEntry.SetCurrentKey("Entry No.");
                    if BankAccLedgerEntry.FindFirst() then begin
                        BankAccLedgerEntry2.GET(BankAccLedgerEntry."Entry No.");
                        if BankAccLedgerEntry.Amount > 0 then begin
                            InputVoucher.SetTableView(BankAccLedgerEntry2);
                            InputVoucher.Run();
                        end else begin
                            OutputVoucher.SetTableView(BankAccLedgerEntry2);
                            OutputVoucher.Run();
                        end;
                        /*if BankAccLedgerEntry.Amount > 0 then
                            REPORT.RUNMODAL(51140, true, true, BankAccLedgerEntry2)
                        else
                            REPORT.RUNMODAL(51139, true, true, BankAccLedgerEntry2);*/
                    end;
                end else begin
                    SourceCode.TestField(SourceCode."Input / output");
                    if SourceCode."Input / output" = SourceCode."Input / output"::Input then begin
                        InputVoucher.SetTableView(BankAccLedgerEntry2);
                        InputVoucher.Run();
                        //REPORT.RUNMODAL(51140, true, true, BankAccLedgerEntry2)
                    end else begin
                        OutputVoucher.SetTableView(BankAccLedgerEntry2);
                        OutputVoucher.Run();
                        //REPORT.RUNMODAL(51139, true, true, BankAccLedgerEntry2);
                    end;
                end;
        end else begin
            OutputVoucher.SetTableView(BankAccLedgerEntry2);
            OutputVoucher.Run();
            //REPORT.RUNMODAL(51139, true, true, BankAccLedgerEntry2);
        end;
    end;
}