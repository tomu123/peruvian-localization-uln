pageextension 51251 "ST Recurring General Journal" extends "Recurring General Journal"
{
    layout
    {
        // Add changes to page layout here
        addafter(Description)
        {
            field("Posting Text"; rec."Posting Text")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        addbefore("Gen. Bus. Posting Group")
        {
            field("Payment Method Code"; Rec."Payment Method Code")
            {
                ApplicationArea = All;
            }
            field("Posting Group"; rec."Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
            }
        }
        modify("VAT Prod. Posting Group")
        {
            Visible = true;
            Editable = true;
        }
        modify("Expiration Date")
        {
            Visible = false;

        }
        modify("Allocated Amt. (LCY)")
        {
            Visible = false;

        }
        modify("Currency Code")
        {
            Editable = "Account Type" = "Account Type"::"G/L Account";
        }
        modify("Total Balance")
        {
            Caption = 'Total Balance (DL)', Comment = 'ESM="Saldo Total (DL)"';
        }
        modify(TotalBalance)
        {
            Caption = 'Total Balance (DL)', Comment = 'ESM="Saldo Total (DL)"';
        }
        modify("Amount (LCY)")
        {
            Caption = 'Amount (DL)', Comment = 'ESM="Importe (DL)"';
        }
        addbefore(Control1903866901)
        {
            group("Total Debit 1")
            {
                Caption = 'Total Debit', Comment = 'ESM="Total DébitO"';
                //Visible = IsSimplePage;
                field(DisplayTotalDebit1; GetTotalDebitAmt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Debit';
                    Editable = false;
                    ToolTip = 'Specifies the total debit amount in the general journal.';
                }
            }
            group("Total Credit 1")
            {
                Caption = 'Total Credit', Comment = 'ESM="Total Crédito"';
                //Visible = IsSimplePage;
                field(DisplayTotalCredit1; GetTotalCreditAmt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Total Credit';
                    Editable = false;
                    ToolTip = 'Specifies the total credit amount in the general journal.';
                }
            }
        }
        addafter("Total Balance")
        {
            group("Total Balance ME")
            {
                Caption = 'Total Balance (ME)', Comment = 'ESM="Saldo Total (ME)"';
                field(TotalBalanceME; TotalBalanceME + Amount - xRec.Amount)
                {
                    ApplicationArea = All;
                    AutoFormatType = 1;
                    Caption = 'Total Balance (ME)', Comment = 'ESM="Saldo Total (ME)"';
                    Editable = false;
                    ToolTip = 'Specifies the total balance ME in the general journal.';
                    //Visible = TotalBalanceVisible;
                }
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }
    trigger OnAfterGetCurrRecord()
    begin
        if ClientTypeManagement.GetCurrentClientType <> CLIENTTYPE::ODataV4 then
            CalcBalanceME(Rec, xRec, TotalBalanceME, ShowTotalBalanceME);
    end;

    procedure CalcBalanceME(var GenJnlLine: Record "Gen. Journal Line"; LastGenJnlLine: Record "Gen. Journal Line"; var TotalBalance: Decimal; var ShowTotalBalance: Boolean)
    var
        TempGenJnlLine: Record "Gen. Journal Line";
    begin
        TempGenJnlLine.CopyFilters(GenJnlLine);
        TempGenJnlLine.SetRange("Currency Code", 'USD');
        if CurrentClientType in [CLIENTTYPE::SOAP, CLIENTTYPE::OData, CLIENTTYPE::ODataV4, CLIENTTYPE::Api] then
            ShowTotalBalance := false
        else
            ShowTotalBalance := TempGenJnlLine.CalcSums(Amount);

        if ShowTotalBalance then begin
            TotalBalance := TempGenJnlLine.Amount;
            if GenJnlLine."Line No." = 0 then
                TotalBalance := TotalBalance + LastGenJnlLine.Amount;
        end;

    end;

    local procedure GetTotalDebitAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJournalLine.SetRange("Document No.", "Document No.");
        GenJournalLine.CalcSums("Debit Amount");
        exit(GenJournalLine."Debit Amount");
    end;

    local procedure GetTotalCreditAmt(): Decimal
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        GenJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        GenJournalLine.SetRange("Document No.", "Document No.");
        GenJournalLine.CalcSums("Credit Amount");
        exit(GenJournalLine."Credit Amount");
    end;

    var
        myInt: Integer;
        TotalBalanceME: Decimal;
        ClientTypeManagement: Codeunit "Client Type Management";
        ShowTotalBalanceME: Boolean;


}
