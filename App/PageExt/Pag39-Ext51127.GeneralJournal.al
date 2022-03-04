pageextension 51127 "ST General Journal" extends "General Journal"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Posting Date")
        {
            field("Line No."; "Line No.")
            {
                Editable = false;
                ApplicationArea = All;
            }
        }
        addafter("Posting Date")
        {
            field("Due Date"; "Due Date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;

            }
        }
        moveafter("Posting Date"; "Document Date")
        modify("Document Date")
        {
            Visible = true;
        }
        modify("Currency Code")
        {
            Editable = "Account Type" = "Account Type"::"G/L Account";
        }
        addafter("Applies-to Doc. No.")
        {

            field("Applies-to Entry No."; "Applies-to Entry No.")
            {
                ApplicationArea = all;
                Caption = 'Applied-to Entry No.';
            }
        }
        addafter("Currency Code")
        {
            field("Currency Factor"; "Currency Factor")
            {
                ApplicationArea = all;
            }

            field("Payment Method Code"; "Payment Method Code")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Currency Code")
        {
            field("Posting Group"; "Posting Group")
            {
                ApplicationArea = All;
                Editable = true;

                trigger OnValidate()
                begin
                    SLSetupMgt.ValidatePostingGroup(Rec);
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    SLSetupMgt.LookUpPostingGroup(Rec);
                end;
            }
        }
        addafter(Comment)
        {
            field("Job No."; "Job No.")
            {
                ApplicationArea = All;
            }
            field("Job Task No."; "Job Task No.")
            {
                ApplicationArea = All;
                trigger onvalidate()
                var
                    myInt: Integer;
                begin
                    if ("Job No." <> '') and ("Job Task No." <> '') then
                        Validate("Job Quantity", 1);

                end;
            }
            field("Job Quantity"; "Job Quantity")
            {
                ApplicationArea = All;
            }

        }
        modify("Applies-to Doc. No.")
        {
            Editable = true;
            Visible = true;
        }
        modify("Document Type")
        {
            Visible = false;
        }
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("EU 3-Party Trade")
        {
            Visible = false;
        }
        modify("Bal. Gen. Posting Type")
        {
            Visible = false;
        }
        modify("Bal. Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        modify("Bal. Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Posting Type")
        {
            Visible = false;
        }
        moveafter("Bal. Account Type"; "Bal. Account No.")
        modify("Deferral Code")
        {
            Visible = false;
        }
        modify(Correction)
        {
            Visible = false;
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
        addbefore("Total Debit")
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
        addlast("F&unctions")
        {
            group("Planilla")
            {
                Image = Planning;
                action("Imp. Planilla")
                {
                    ApplicationArea = all;
                    Caption = 'Importar Planilla';
                    Image = ImportExcel;
                    Promoted = false;
                    RunObject = Report "GenJournalReturn";


                }

            }

        }
        modify(Post)
        {
            trigger OnBeforeAction()
            var
                recgenJoLin: Record 81;
            begin
                recgenJoLin.Reset;
                recgenJoLin.SetRange("Journal Template Name", "Journal Template Name");
                recgenJoLin.SetRange("Journal Batch Name", "Journal Batch Name");
                if recgenJoLin.FindSet() then begin
                    repeat
                        if recgenJoLin."Applies-to Doc. No." <> '' then begin
                            if recgenJoLin."Applies-to Entry No." = 0 then
                                Error('El numero movimiento aplicado no puede estar vacio');

                        end;
                    until recgenJoLin.Next = 0;
                end;

            end;

        }

    }

    var
        SLSetupMgt: Codeunit "Setup Localization";
        TotalBalanceME: Decimal;
        ClientTypeManagement: Codeunit "Client Type Management";
        ShowTotalBalanceME: Boolean;

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
}