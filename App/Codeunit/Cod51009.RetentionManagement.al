codeunit 51009 "Retention Management"
{
    SingleInstance = true;
    trigger OnRun()
    begin

    end;

    //***  Begin Calculate Retention ***
    procedure CalculateRetention(pGenJnlLine: Record "Gen. Journal Line"; IsManual: Boolean)
    var
        IsInvoice: Boolean;
        IsCrMemo: Boolean;
        IsLetter: Boolean;
        TotalAmount: Decimal;
        TotalRetentionAmt: Decimal;
    begin
        SetSetup();
        CheckSetup(IsManual);
        CheckCalculate(pGenJnlLine);
        InitCalculation(pGenJnlLine);
        CheckParameterCalculation();
        DeleteBankEntries(pGenJnlLine);
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Document No.", pGenJnlLine."Document No.");
            SetRange("Account Type", "Account Type"::Vendor);
            SetRange("Apply Retention To Line", true);
            if FindSet() then begin
                repeat
                    OnBeforeCalculateRetention(GenJnlLine);
                    GetSourceTypeVendorLedgerEntry(GenJnlLine, IsInvoice, IsCrMemo, IsLetter);
                    if IsInvoice or IsCrMemo or IsLetter then
                        "Retention Amount" += Round((Amount * Setup."Retention Percentage %") / 100, 0.01);
                    if IsInvoice then
                        "Retention Amount" := "Retention Amount" * -1;
                    if IsLetter then
                        "Retention Amount" := Abs("Retention Amount");
                    //"Document Type" := "Document Type"::" ";
                    "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                    "Bal. Account No." := '';
                    "Manual Retention" := IsManual;
                    "Retention Applies-to Entry No." := "Applies-to Entry No.";
                    if "Currency Code" <> '' then
                        "Retention Amount LCY" := Round("Retention Amount" / "Currency Factor", 0.01)
                    else
                        "Retention Amount LCY" := "Retention Amount";
                    "Applied Retention" := "Retention Amount" <> 0;
                    TotalAmount += Amount;
                    TotalRetentionAmt += "Retention Amount";
                    Modify();
                until Next() = 0;
                CreateGenJnLineForRetention(pGenJnlLine, TotalAmount, TotalRetentionAmt);
            end;
        end;
    end;

    procedure CalculateRetentionWithApplyEmployeeLedgerEntry(pGenJnlLine: Record "Gen. Journal Line"; IsManual: Boolean)
    var
        IsInvoice: Boolean;
        IsCrMemo: Boolean;
        IsLetter: Boolean;
        TotalAmount: Decimal;
        TotalRetentionAmt: Decimal;
    begin
        SetSetup();
        CheckSetup(IsManual);
        CheckCalculate(pGenJnlLine);
        InitCalculation(pGenJnlLine);
        CheckParameterCalculation();
        DeleteBankEntries(pGenJnlLine);
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Document No.", pGenJnlLine."Document No.");
            SetRange("Account Type", "Account Type"::Vendor);
            SetRange("Apply Retention To Line", true);
            if FindSet() then begin
                repeat
                    OnBeforeCalculateRetention(GenJnlLine);
                    GetSourceTypeVendorLedgerEntry(GenJnlLine, IsInvoice, IsCrMemo, IsLetter);
                    if IsInvoice or IsCrMemo or IsLetter then
                        "Retention Amount" += (Amount * Setup."Retention Percentage %") / 100;
                    if IsInvoice then
                        "Retention Amount" := "Retention Amount" * -1;
                    if IsLetter then
                        "Retention Amount" := Abs("Retention Amount");
                    "Document Type" := "Document Type"::" ";
                    "Bal. Account Type" := "Bal. Account Type"::"G/L Account";
                    "Bal. Account No." := '';
                    "Manual Retention" := IsManual;
                    "Retention Applies-to Entry No." := "Applies-to Entry No.";
                    if "Currency Code" <> '' then
                        "Retention Amount LCY" := Round("Retention Amount" / "Currency Factor", 0.01)
                    else
                        "Retention Amount LCY" := "Retention Amount";
                    "Applied Retention" := "Retention Amount" <> 0;
                    TotalAmount += Amount;
                    TotalRetentionAmt += "Retention Amount";
                    Modify();
                until Next() = 0;
                CreateGenJnLineForRetentionWithApplyEmployeeLedgerEntry(pGenJnlLine, TotalAmount, TotalRetentionAmt);
            end;
        end;
    end;

    local procedure DeleteBankEntries(var pGenJnlLine: Record "Gen. Journal Line")
    begin
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", pGenJnlLine."Account Type"::"Bank Account");
        if GenJnlLine.FindSet() then begin
            DestinationBankNo := GenJnlLine."Account No.";
            GenJnlLine.DeleteAll();
        end;
    end;

    local procedure SetSetup()
    begin
        Setup.Get();
        Clear(LastVendorNo);
        DtldRetLedgerEntryBuffer.Reset();
        DtldRetLedgerEntryBuffer.DeleteAll();
    end;

    local procedure CheckSetup(IsManual: Boolean)
    begin
        with Setup do begin
            TestField("Retention Percentage %");
            TestField("Retention Limit Amount");
            TestField("Retention G/L Account No.");
            if IsManual then begin
                TestField("Retention Physical Nos");
                TestField("Max. Line. Retention Report");
            end else begin
                TestField("Retention Electronic Nos");
                TestField("Regime Retention Code");
            end;
        end;
    end;

    local procedure CheckCalculate(pGenJnlLiene: Record "Gen. Journal Line")
    var
        ErrorRetention: Label 'There are lines with a limited withholding amount or with a marked withholding check.', Comment = 'ESM="Existen lineas que no superan el importe limite o la retención ya fué calculada."';
        EmptyRetentionLinesMark: Label 'Does not have lines marked for retention.', Comment = 'ESM="No tiene ninguna linea marcada para retención."';
    begin
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Document No.", pGenJnlLiene."Document No.");
            SetRange("Journal Template Name", pGenJnlLiene."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLiene."Journal Batch Name");
            SetRange("Applied Retention", true);
            if Count = 0 then
                Error(EmptyRetentionLinesMark);
            SetRange("Applied Retention");
            SetFilter("Retention Amount", '<>%1', 0);
            if FindFirst() then
                Error(ErrorRetention);
            SetRange("Retention Amount");
            SetRange("Apply Retention To Line", true);
            if FindFirst() then
                Error(ErrorRetention);
            SetRange("Retention Amount");
            SetRange("Apply Retention To Line");
            SetRange("Applied Retention", true);
            SetRange("Account Type", "Account Type"::Vendor);
            if FindFirst() then
                repeat
                    Vendor.Get("Account No.");

                until Next() = 0;
        end;
    end;

    local procedure InitCalculation(var pGenJnlLine: Record "Gen. Journal Line")
    var
        LineNo: Integer;
    begin
        ClearBuffer();
        LineNo := 0;
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Document No.", pGenJnlLine."Document No.");
            SetRange("Account Type", "Account Type"::Vendor);
            SetRange("Applied Retention", true);
            if FindFirst() then
                repeat
                    GenJnlLineBuffer.Reset();
                    GenJnlLineBuffer.SetRange("Journal Template Name", "Journal Template Name");
                    GenJnlLineBuffer.SetRange("Journal Batch Name", "Journal Batch Name");
                    GenJnlLineBuffer.SetRange("Account No.", "Account No.");
                    GenJnlLineBuffer.SetRange("Document No.", "Document No.");
                    if GenJnlLineBuffer.FindSet() then begin
                        GenJnlLineBuffer."Amount (LCY)" += "Amount (LCY)";
                        GenJnlLineBuffer.Amount += Amount;
                        GenJnlLineBuffer.Modify();
                    end else begin
                        LineNo += 1;
                        GenJnlLineBuffer.Init();
                        GenJnlLineBuffer."Journal Template Name" := "Journal Template Name";
                        GenJnlLineBuffer."Journal Batch Name" := "Journal Batch Name";
                        GenJnlLineBuffer."Line No." := LineNo;
                        GenJnlLineBuffer."Document No." := "Document No.";
                        GenJnlLineBuffer."Account No." := "Account No.";
                        GenJnlLineBuffer.Amount := Amount;
                        GenJnlLineBuffer."Amount (LCY)" := "Amount (LCY)";
                        GenJnlLineBuffer.Insert();
                    end;
                until Next() = 0;
        end;
    end;

    local procedure CheckParameterCalculation()
    begin
        with GenJnlLineBuffer do begin
            Reset();
            if FindFirst() then
                repeat
                    GenJnlLine.Reset();
                    GenJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    GenJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
                    GenJnlLine.SetRange("Document No.", "Document No.");
                    GenJnlLine.SetRange("Account No.", "Account No.");
                    GenJnlLine.SetRange("Applied Retention", true);
                    if "Amount (LCY)" >= Setup."Retention Limit Amount" then
                        GenJnlLine.ModifyAll("Apply Retention To Line", true)
                    else begin
                        if GenJnlLine.FindFirst() then
                            repeat
                                GenJnlLine."Applied Retention" := false;
                                GenJnlLine."Apply Retention To Line" := false;
                                GenJnlLine."Retention No." := '';
                                GenJnlLine."Retention Amount" := 0;
                                GenJnlLine."Retention Amount LCY" := 0;
                                GenJnlLine.Modify();
                            until GenJnlLine.Next() = 0;
                    end;
                until Next() = 0;
        end;
    end;

    local procedure ClearBuffer()
    begin
        GenJnlLineBuffer.Reset();
        GenJnlLineBuffer.DeleteAll();
    end;

    local procedure CreateGenJnLineForRetention(var pGenJnlLine: Record "Gen. Journal Line"; pTotalAmount: Decimal; pTotalRetentionAmt: Decimal)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine2: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        BankAcc: Record "Bank Account";
        GenJnlTemplate: Record "Gen. Journal Template";
        CurrencyCode: Code[10];
        RetentionAmount: Decimal;
        BankAmount: Decimal;
        BalanceLCY: Decimal;
        LineNo: Integer;
    begin
        RetentionAmount := 0;
        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        GenJnlTemplate.Get(pGenJnlLine."Journal Template Name");

        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetFilter("Account Type", '%1', "Account Type"::"Bank Account");
            if IsEmpty then
                SetRange("Account Type");
            if FindLast() then
                LineNo := "Line No.";

            Reset();
            SetCurrentKey("Document No.", "Account No.");
            //SetRange("Journal Batch Name", pGenJnlLine."Journal Template Name"); //FMM::07-12 Se estaba repitiendo el filtro
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetFilter("Account Type", '<>%1', "Account Type"::"Bank Account");
            if IsEmpty then
                SetRange("Account Type");
            SetFilter("Retention Amount", '<>%1', 0);
            if FindSet() then
                repeat
                    //LineNo += 1;
                    NewGenJnlLine.Init();
                    NewGenJnlLine."Journal Template Name" := "Journal Template Name";
                    NewGenJnlLine."Journal Batch Name" := "Journal Batch Name";
                    NewGenJnlLine."Line No." := "Line No." + 100;
                    if GenJnlTemplate.Type = GenJnlTemplate."Type"::Payments then
                        NewGenJnlLine."Document Type" := NewGenJnlLine."Document Type"::Payment;
                    NewGenJnlLine."Document No." := "Document No.";
                    NewGenJnlLine."Posting Date" := "Posting Date";
                    NewGenJnlLine."Account Type" := "Account Type"::"G/L Account";
                    NewGenJnlLine.Validate("Account No.", Setup."Retention G/L Account No.");
                    NewGenJnlLine."Currency Factor" := 0;
                    NewGenJnlLine."Currency Code" := '';
                    NewGenJnlLine."Source Code" := "Source Code";
                    NewGenJnlLine."External Document No." := "External Document No.";
                    NewGenJnlLine."Payment Method Code" := "Payment Method Code";
                    NewGenJnlLine."Payment Terms Code" := "Payment Terms Code";
                    NewGenJnlLine."Retention Applies-to Entry No." := "Applies-to Entry No.";
                    NewGenJnlLine."Setup Source Code" := pGenJnlLine."Setup Source Code";
                    NewGenJnlLine.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    NewGenJnlLine.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    NewGenJnlLine."Source Entry No. apply to ret." := "Line No.";
                    if GenJnlBatch."Posting No. Series" <> '' then
                        NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    NewGenJnlLine.Validate(Amount, "Retention Amount LCY");
                    if "Retention Amount" > 0 then
                        RetentionAmount += -"Retention Amount"
                    else
                        RetentionAmount += Abs("Retention Amount");
                    NewGenJnlLine.Insert();
                until Next() = 0;

            /*Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Account Type", "Account Type"::"Bank Account");
            if FindFirst() then begin
                Validate(Amount, Amount + Abs(RetentionAmount));
                Modify();
            end;*/

            GenJnlLine2.Reset();
            GenJnlLine2.SetCurrentKey("Document No.", "Account No.");
            GenJnlLine2.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            GenJnlLine2.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            GenJnlLine2.SetRange("Account Type", "Account Type"::Employee);
            GenJnlLine2.SetRange("Applied Retention", true);
            if GenJnlLine2.FindFirst() then
                Error('Proceso no soportado para tipo empleados');

            FindFirst();

            LineNo += 10000;
            NewGenJnlLine.INIT;
            NewGenJnlLine."Journal Batch Name" := "Journal Batch Name";
            NewGenJnlLine."Journal Template Name" := "Journal Template Name";
            NewGenJnlLine."Line No." := LineNo;
            if GenJnlTemplate.Type = GenJnlTemplate."Type"::Payments then
                NewGenJnlLine."Document Type" := NewGenJnlLine."Document Type"::Payment;
            NewGenJnlLine."Document No." := "Document No.";
            NewGenJnlLine."Posting Date" := "Posting Date";
            NewGenJnlLine."Account Type" := "Account Type"::"Bank Account";
            if DestinationBankNo <> '' then
                NewGenJnlLine.Validate("Account No.", DestinationBankNo)
            else
                NewGenJnlLine.Validate("Account No.", GenJnlBatch."Bank Account No. FICO");
            BankAcc.Get(NewGenJnlLine."Account No.");
            NewGenJnlLine.Validate("Currency Code", BankAcc."Currency Code");
            if NewGenJnlLine."Currency Code" <> '' then
                NewGenJnlLine.Validate("Currency Factor", CurrExchRate.ExchangeRate(NewGenJnlLine."Posting Date", NewGenJnlLine."Currency Code"));
            //NewGenJnlLine."Currency Code" := "Currency Code";
            //NewGenJnlLine."Currency Factor" := "Currency Factor";
            NewGenJnlLine."Source Code" := "Source Code";
            BankAmount := GetBalanceGenJnlLine(pGenJnlLine);
            if NewGenJnlLine."Currency Code" <> '' then
                BankAmount := Round(BankAmount * NewGenJnlLine."Currency Factor", 0.01);
            NewGenJnlLine.Validate(Amount, -BankAmount);
            NewGenJnlLine."Payment Method Code" := "Payment Method Code";
            NewGenJnlLine."Payment Terms Code" := "Payment Terms Code";
            //IF GenJnlBatch."Is Batch Check" THEN
            //    NewGenJnlLine."Bank Payment Type" := "Bank Payment Type"::"Manual Check";
            NewGenJnlLine.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            NewGenJnlLine.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
            NewGenJnlLine."Setup Source Code" := pGenJnlLine."Setup Source Code";
            if GenJnlBatch."Posting No. Series" <> '' then
                NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
            NewGenJnlLine.Insert();
            //NewGenJnlLine.CheckIfPrivacyBlocked;
        end;
    end;

    local procedure CreateGenJnLineForRetentionWithApplyEmployeeLedgerEntry(var pGenJnlLine: Record "Gen. Journal Line"; pTotalAmount: Decimal; pTotalRetentionAmt: Decimal)
    var
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine2: Record "Gen. Journal Line";
        NewGenJnlLine: Record "Gen. Journal Line";
        CurrExchRate: Record "Currency Exchange Rate";
        BankAcc: Record "Bank Account";
        GenJnlTemplate: Record "Gen. Journal Template";
        CurrencyCode: Code[10];
        RetentionAmount: Decimal;
        ReferenceToApplyEntryAmountLCY: Decimal;
        BalanceLCY: Decimal;
        LineNo: Integer;
    begin
        RetentionAmount := 0;
        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        GenJnlTemplate.Get(pGenJnlLine."Journal Template Name");

        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetFilter("Account Type", '%1', "Account Type"::"Bank Account");
            if IsEmpty then
                SetRange("Account Type");
            if FindLast() then
                LineNo := "Line No.";

            Reset();
            SetCurrentKey("Document No.", "Account No.");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetFilter("Account Type", '%1', "Account Type"::"Bank Account");
            if IsEmpty then
                SetRange("Account Type");
            SetFilter("Retention Amount", '<>%1', 0);
            if FindSet() then
                repeat
                    LineNo += 1;
                    NewGenJnlLine.Init();
                    NewGenJnlLine."Journal Template Name" := "Journal Template Name";
                    NewGenJnlLine."Journal Batch Name" := "Journal Batch Name";
                    NewGenJnlLine."Line No." := LineNo;
                    NewGenJnlLine."Document No." := "Document No.";
                    NewGenJnlLine."Posting Date" := "Posting Date";
                    NewGenJnlLine."Account Type" := "Account Type"::"G/L Account";
                    NewGenJnlLine.Validate("Account No.", Setup."Retention G/L Account No.");
                    NewGenJnlLine."Currency Factor" := 0;
                    NewGenJnlLine."Currency Code" := '';
                    NewGenJnlLine."Source Code" := "Source Code";
                    NewGenJnlLine."External Document No." := "External Document No.";
                    NewGenJnlLine."Posting Text" := "Posting Text";
                    NewGenJnlLine."Payment Method Code" := "Payment Method Code";
                    NewGenJnlLine."Payment Terms Code" := "Payment Terms Code";
                    NewGenJnlLine."Retention Applies-to Entry No." := "Applies-to Entry No.";
                    NewGenJnlLine."Setup Source Code" := pGenJnlLine."Setup Source Code";
                    NewGenJnlLine.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
                    NewGenJnlLine.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
                    NewGenJnlLine."Reference to apply No." := pGenJnlLine."Reference to apply No.";
                    NewGenJnlLine."Source Entry No. apply to ret." := "Line No.";
                    if GenJnlBatch."Posting No. Series" <> '' then
                        NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
                    NewGenJnlLine.Validate(Amount, "Retention Amount LCY");
                    if "Retention Amount" > 0 then
                        RetentionAmount += -"Retention Amount"
                    else
                        RetentionAmount += Abs("Retention Amount");
                    NewGenJnlLine.Insert();
                    DecreaseForRetentionAmount(NewGenJnlLine);
                until Next() = 0;

            GenJnlLine2.Reset();
            GenJnlLine2.SetCurrentKey("Document No.", "Account No.");
            GenJnlLine2.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            GenJnlLine2.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            GenJnlLine2.SetRange("Account Type", "Account Type"::Employee);
            GenJnlLine2.SetRange("Applied Retention", true);
            if GenJnlLine2.FindFirst() then
                Error('Proceso no soportado para tipo empleados');
        end;
    end;

    local procedure DecreaseForRetentionAmount(var pGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        with GenJnlLine do begin
            Reset();
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Account No.", pGenJnlLine."Reference to apply No.");
            if FindSet() then begin
                Validate("Amount (LCY)", "Amount (LCY)" - pGenJnlLine."Amount (LCY)");
                Modify()
            end;
        end;
    end;

    local procedure GetSourceTypeVendorLedgerEntry(var pGenJnlLine: Record "Gen. Journal Line"; var IsInvoice: Boolean; var IsCrMemo: Boolean; var IsLetter: Boolean)
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        VendorLE: Record "Vendor Ledger Entry";
    begin
        IsInvoice := false;
        IsCrMemo := false;
        IsLetter := false;

        if pGenJnlLine."Applies-to Doc. No." = '' then
            exit;

        if not (IsInvoice and IsCrMemo and IsLetter) then
            IsInvoice := PurchInvHeader.Get(pGenJnlLine."Applies-to Doc. No.");
        if not (IsInvoice and IsCrMemo and IsLetter) then
            IsCrMemo := PurchCrMemoHdr.Get(pGenJnlLine."Applies-to Doc. No.");

        if (IsInvoice = false) and (IsCrMemo = false) and (IsLetter = false) then begin
            VendorLE.Reset();
            VendorLE.SetRange("Document No.", pGenJnlLine."Applies-to Doc. No.");
            if VendorLE.FindFirst() then begin
                case VendorLE."Document Type" of
                    VendorLE."Document Type"::Invoice:
                        IsInvoice := true;
                    VendorLE."Document Type"::"Credit Memo":
                        IsCrMemo := true;
                end
            end;
        end;
        OnAfterGetSourceTypeVendorLedgerEntry(pGenJnlLine, IsInvoice, IsCrMemo, IsLetter)
    end;

    local procedure GetBalanceGenJnlLine(var pGenJnlLine: Record "Gen. Journal Line"): Decimal
    var
        BankAmount: Decimal;
        CurrentCurrencyCode: Code[10];
        CurrencyFactor: Decimal;
    begin
        with GenJnlLine do begin
            Reset();
            SetRange("Journal Batch Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            if FindFirst() then
                repeat
                    /*if CurrentCurrencyCode = '' then begin
                        if "Currency Code" = '' then
                            CurrentCurrencyCode := 'PEN'
                        else begin
                            CurrentCurrencyCode := "Currency Code";
                            CurrencyFactor := "Currency Factor";
                        end;
                    end;*/
                    BankAmount += "Amount (LCY)";
                until Next() = 0;
            //if CurrentCurrencyCode <> 'PEN' then
            //    BankAmount := Round("Amount (LCY)" * CurrencyFactor, 0.01);
            exit(BankAmount);
        end;
    end;

    local procedure InsertRoundingLine(var pGenJnlLine: Record "Gen. Journal Line")
    var
        AmountLCY: Decimal;
        LastLineNo: Integer;
        NewGenJnlLine: Record "Gen. Journal Line";
        GenJnlBatch: Record "Gen. Journal Batch";
        Currency: Record Currency;
    begin
        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Journal Template Name", "Journal Batch Name", "Line No.");
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            CalcSums("Amount (LCY)");
            AmountLCY := "Amount (LCY)";
            if FindLast() then
                LastLineNo := "Line No.";

            if AmountLCY = 0 then
                exit;

            LastLineNo += 10000;
            NewGenJnlLine.Init();
            NewGenJnlLine."Journal Template Name" := "Journal Template Name";
            NewGenJnlLine."Journal Batch Name" := "Journal Batch Name";
            NewGenJnlLine."Line No." := LastLineNo;
            NewGenJnlLine."Document No." := "Document No.";
            NewGenJnlLine."Posting Date" := "Posting Date";
            NewGenJnlLine."Account Type" := "Account Type"::"G/L Account";

            if "Currency Code" <> '' then
                Currency.Get("Currency Code")
            else
                Currency.Get('USD');
            Currency.TestField("Conv. LCY Rndg. Debit Acc.");
            Currency.TestField("Conv. LCY Rndg. Credit Acc.");
            if AmountLCY <= 0 then
                NewGenJnlLine.Validate("Account No.", Currency."Conv. LCY Rndg. Debit Acc.")
            else
                NewGenJnlLine.Validate("Account No.", Currency."Conv. LCY Rndg. Credit Acc.");
            NewGenJnlLine."Currency Factor" := 0;
            NewGenJnlLine."Currency Code" := '';
            NewGenJnlLine.Validate(Amount, AmountLCY * -1);
            NewGenJnlLine."Source Code" := "Source Code";
            NewGenJnlLine."External Document No." := "External Document No.";
            NewGenJnlLine."Payment Method Code" := "Payment Method Code";
            NewGenJnlLine."Payment Terms Code" := "Payment Terms Code";
            NewGenJnlLine.Validate("Shortcut Dimension 1 Code", "Shortcut Dimension 1 Code");
            NewGenJnlLine.Validate("Shortcut Dimension 2 Code", "Shortcut Dimension 2 Code");
            NewGenJnlLine."Bal. Account No." := '';
            NewGenJnlLine."Bal. Account Type" := "Bal. Account Type"::"G/L Account";
            if GenJnlBatch."Posting No. Series" <> '' then
                NewGenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
            NewGenJnlLine.Insert();
        end;
    end;

    //***  End Calculate Retention ***

    //***  Begin PDT 626 ***
    local procedure OpenWindows(CreateFileFlag: Boolean)
    var
        ContaintText: Text[200];
    begin
        ContaintText := Processing;
        if CreateFileFlag then
            ContaintText += CreatingFile;
        Windows.Open(ContaintText);
    end;

    local procedure UpdateWindows(Number: Integer; Counter: Integer; Total: Integer)
    begin
        Windows.Update(Number, ROUND(Counter / Total * 10000, 2));
    end;

    local procedure CloseWindows()
    begin
        Windows.Close();
    end;

    procedure CreatePDT626()
    var
        CountRecords: Integer;
        TotalRecords: Integer;
    begin
        if not SetDate() then
            exit;
        OpenWindows(true);
        DtldRetentionLedgEntry.Reset();
        DtldRetentionLedgEntry.SetRange("Retention Posting Date", StartDate, EndDate);
        TotalRecords := DtldRetentionLedgEntry.Count;
        if DtldRetentionLedgEntry.FindFirst() then
            repeat
                CountRecords += 1;
                DtldRetLedgerEntryBuffer.Init();
                DtldRetLedgerEntryBuffer.TransferFields(DtldRetentionLedgEntry, true);
                DtldRetLedgerEntryBuffer.Insert();
                UpdateWindows(1, CountRecords, TotalRecords);
            until DtldRetentionLedgEntry.Next() = 0;
        CreateFilePDT626();
        CloseWindows();
    end;

    local procedure CreateFilePDT626()
    var
        CompanyInf: Record "Company Information";
        MyLineText: Text[1024];
        MySeparator: Text[10];
        Position: Integer;
        TotalRecords: Integer;
        CountRecords: Integer;
        IsExistsFile: Boolean;
        FileName: text;
    begin
        CreateTempFile();
        CountRecords := 0;
        MySeparator := '|';
        CompanyInf.Get();
        with DtldRetLedgerEntryBuffer do begin
            Reset();
            TotalRecords := Count;
            if FindFirst() then
                repeat
                    MyLineText := '';
                    CountRecords += 1;
                    IsExistsFile := true;
                    RetentionLedgerEntry.Reset();
                    RetentionLedgerEntry.SetRange("Retention No.", "Retention No.");
                    RetentionLedgerEntry.FindFirst();
                    RetentionLedgerEntry.CalcFields("Amount Paid LCY");
                    if FileName = '' then
                        FileName := '0626' + Format(CompanyInf."VAT Registration No.") + Format(RetentionLedgerEntry."Retention Posting Date", 10, '<Year4><Month,2>.');
                    //*********************************************************************************
                    Vendor.Get("Vendor No.");
                    MyLineText += DelChr("Vendor No.", '=', '´,.-_;"/\') + MySeparator;//Field 01
                    MyLineText += DelChr("Vendor Name", '=', '´,.-_;"/\') + MySeparator;//Field 02
                    MyLineText += MySeparator;//Field 03
                    MyLineText += MySeparator;//Field 04
                    MyLineText += MySeparator;//Field 05
                    Position := StrPos("Retention No.", '-');
                    MyLineText += CopyStr("Retention No.", 1, Position - 1) + MySeparator;//Field 06
                    MyLineText += CopyStr("Retention No.", Position + 1, 20) + MySeparator;//Field 07
                    MyLineText += Format("Retention Posting Date", 10, '<Day,2>/<Month,2>/<Year4>.') + MySeparator;//Field 08
                    MyLineText += Format(RetentionLedgerEntry."Amount Paid LCY", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 09
                    Position := StrPos("Vendor Invoice No.", '-');
                    MyLineText += "Vendor Doc. Legal Document" + MySeparator;//Field 10
                    MyLineText += CopyStr("Vendor Invoice No.", 1, Position - 1) + MySeparator;//Field 11
                    MyLineText += CopyStr("Vendor Invoice No.", Position + 1, 20) + MySeparator;//Field 12
                    MyLineText += Format("Vendor Document Date", 10, '<Day,2>/<Month,2>/<Year4>.') + MySeparator;//Field 13
                    MyLineText += Format("Amount Retention LCY", 0, '<Precision,2:2><Standard Format,2>') + MySeparator;//Field 14
                    //*********************************************************************************
                    InsertLineToTempFile(MyLineText);
                    UpdateWindows(2, CountRecords, TotalRecords);
                until Next() = 0;
            if IsExistsFile then
                PostFileToControlFileRecord(FileName);
        end;
    end;

    local procedure CreateTempFile()
    begin
        TempFileBlob.CreateOutStream(ConstrutOutStream, TextEncoding::UTF8);
    end;

    local procedure InsertLineToTempFile(LineText: Text[1024])
    begin
        ConstrutOutStream.WriteText(LineText);
        ConstrutOutStream.WriteText;
    end;

    local procedure SetDate(): Boolean
    var
        SetDatePDT: Page "Setup Set Date";
    begin
        Clear(SetDatePDT);
        SetDatePDT.SetBookCode('0626');
        if SetDatePDT.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            SetDatePDT.SetFilterDate(StartDate, EndDate);
            exit(true);
        end;
        exit(false);
    end;

    local procedure CheckDateExists(): Boolean
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Message(CheckDateExistsMessage);
        if EndDate > CalcDate('<+CM>', StartDate) then
            Message(ErrorSelectedDate);
        exit(not (StartDate = 0D) or (EndDate = 0D) or (EndDate > CalcDate('<+CM>', StartDate)));
    end;

    procedure PostFileToControlFileRecord(FileName: Text)
    var
        CompInf: Record "Company Information";
        ControlFile: Record "ST Control File";
        NewFileInStream: InStream;
        FileExt: Text;
        EntryNo: Integer;
        ConfirmDownload: Label 'Do you want to download the following file?';
    begin
        CompInf.Get();
        TempFileBlob.CreateInStream(NewFileInStream);
        FileExt := 'txt';
        EntryNo := ControlFile.CreateControlFileRecord('', FileName, FileExt, StartDate, EndDate, NewFileInStream);
        if EntryNo <> 0 then
            if Confirm(ConfirmDownload, false) then begin
                ControlFile.Get(EntryNo);
                ControlFile.DownLoadFile(ControlFile);
            end;
    end;

    local procedure SetPreview(Preview: Boolean)
    begin
        PreviewMde := Preview;
    end;
    //***  End PDT 626 ***

    //Integration proccess
    //local procedure OnBeforeCode(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    //OnBeforeCode(var GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean; var IsPosted: Boolean; var GLReg: Record "G/L Register")
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Batch", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCodeBatch(var GenJournalLine: Record "Gen. Journal Line"; PreviewMode: Boolean; CommitIsSuppressed: Boolean)
    begin
        SetPreview(PreviewMode);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeCode', '', false, false)]
    local procedure OnBeforeCode(var GenJnlLine: Record "Gen. Journal Line"; CheckLine: Boolean; var IsPosted: Boolean; var GLReg: Record "G/L Register")
    var
        GenJnlLineForCheck: Record "Gen. Journal Line";
        GenJnlLineForCheck2: Record "Gen. Journal Line";
        EmptyLineForRetention: Label 'Line %1 has the retention check marked, please calculate withholding for the line.', Comment = 'ESM="La linea %1 tiene marcado el check de retención, favor de calcular retención para la linea."';
    begin
        GenJnlLineForCheck.Reset();
        GenJnlLineForCheck.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLineForCheck.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
        GenJnlLineForCheck.SetRange("Applied Retention", true);
        if GenJnlLineForCheck.FindFirst() then
            repeat
                GenJnlLineForCheck2.Reset();
                GenJnlLineForCheck2.SetRange("Journal Template Name", GenJnlLineForCheck."Journal Template Name");
                GenJnlLineForCheck2.SetRange("Journal Batch Name", GenJnlLineForCheck."Journal Batch Name");
                GenJnlLineForCheck2.SetRange("Source Entry No. apply to ret.", GenJnlLineForCheck."Line No.");
                if GenJnlLineForCheck2.IsEmpty then
                    Error(EmptyLineForRetention, GenJnlLineForCheck."Line No.");
            until GenJnlLineForCheck.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    local procedure CreateRetentionLedgerEntry(var TempGLEntryBuf: Record "G/L Entry" temporary; var GenJournalLine: Record "Gen. Journal Line"; var BalanceCheckAmount: Decimal; var BalanceCheckAmount2: Decimal; var BalanceCheckAddCurrAmount: Decimal; var BalanceCheckAddCurrAmount2: Decimal; var NextEntryNo: Integer)
    begin
        SetSetup();
        with GenJnlLine do begin
            Reset();
            SetCurrentKey("Journal Template Name", "Journal Batch Name", "Account No.");
            SetRange("Journal Template Name", GenJournalLine."Journal Template Name");
            SetRange("Journal Batch Name", GenJournalLine."Journal Batch Name");
            SetFilter("Retention Amount", '<>%1', 0);
            SetFilter("Retention Applies-to Entry No.", '<>%1', 0);
            if IsEmpty then
                exit;
            NextRetLedgerEntryNo := SetNextEntryNoRetentionLedgerEntry();
            NextDtldRetLedgerEntryNo := SetNextEntryNoDtldRetLedgerEntry();
            FindSet();
            repeat
                CheckSetup("Manual Retention");
                VendorLedgerEntry.Get("Retention Applies-to Entry No.");
                ValidateRententionInsert(VendorLedgerEntry);
                VendorLedgerEntry.CalcFields("Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");
                NextRetentionNo();
                CreateDetailedRetentionLedgerEntry(TempGLEntryBuf);
                "Retention Applies-to Entry No." := 0;
                //"Retention No." := RetentionNo;
                Modify();
            until Next() = 0;
            CreateRetentionEntry();
            //Define Electronic Retention
        end;
    end;

    local procedure ValidateRententionInsert(VendLE: Record "Vendor Ledger Entry")
    var
        myInt: Integer;
        Vendor: Record Vendor;
        UbigeoMngt: Codeunit "Ubigeo Management";
        Ubigeo: Record Ubigeo;
        UndefinedDepartement: Label 'Departament undefined for "Country Code" %1.', Comment = 'ESM="Departamento no definido para Cód. País %1"';
    begin
        Vendor.Get(VendLE."Vendor No.");
        if Vendor."VAT Registration Type" = '6' then begin
            Vendor.TestField("Country/Region Code");
            if Vendor."Post Code" = '' then
                Error('El campo departamento no debe de estar vacío para el proveedor %1', Vendor."No.");
            if Vendor."City" = '' then
                Error('El campo ciudad no debe de estar vacío para el proveedor %1', Vendor."No.");
            if Vendor.County = '' then
                Error('El campo Provincia no debe de estar vacío para el proveedor %1', Vendor."No.");
            if Vendor."Country/Region Code" <> 'PE' then
                Error(StrSubstNo(UndefinedDepartement, Vendor."Country/Region Code"));
            Ubigeo.Reset();
            Ubigeo.SetRange("Departament Code", Vendor."Post Code");
            Ubigeo.SetRange("Province Code", '00');
            Ubigeo.SetRange("District Code", '00');
            if Ubigeo.IsEmpty then
                Error('No existe el departamento %1 del proveedor %2', Vendor."Post Code", Vendor."No.");

            Ubigeo.Reset();
            Ubigeo.SetRange("Departament Code", Vendor."Post Code");
            Ubigeo.SetRange("Province Code", Vendor.City);
            Ubigeo.SetRange("District Code", '00');
            if Ubigeo.IsEmpty then
                Error('No existe la provincia %1 del proveedor %2', Vendor.City, Vendor."No.");

        end;
    end;

    local procedure CreateDetailedRetentionLedgerEntry(var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyFactor: Decimal;
        CurrencyAmount: Decimal;
        GLEntry: Record "G/L Entry";
        VendLE: Record "Vendor Ledger Entry";
    begin
        Vendor.Get(GenJnlLine."Account No.");
        with DtldRetentionLedgEntry do begin
            Init();
            "Entry No." := NextDtldRetLedgerEntryNo;
            "Retention No." := RetentionNo;
            "Retention Posting Date" := GenJnlLine."Posting Date";
            "Retention Legal Document" := '20';
            "Vendor No." := Vendor."VAT Registration No.";
            "Vendor Name" := Vendor.Name;
            "Vendor Doc. Legal Document" := VendorLedgerEntry."Legal Document";
            "Vendor Invoice No." := GetVendorInvNo_VendorCrMemoNo();
            "Vendor External Document No." := VendorLedgerEntry."External Document No.";
            "Vendor Document No." := VendorLedgerEntry."Document No.";
            "Vendor Doc. Posting Date" := VendorLedgerEntry."Posting Date";
            "Vendor Document Date" := VendorLedgerEntry."Document Date";
            "Source Document No." := TempGLEntryBuf."Document No.";
            if GenJnlLine."Currency Code" <> '' then begin
                CurrExchRate.Get(GenJnlLine."Currency Code", GenJnlLine."Posting Date");
                CurrencyAmount := CurrExchRate."Relational Adjmt Exch Rate Amt";
                CurrencyFactor := 1 / CurrExchRate."Relational Adjmt Exch Rate Amt";
            end;
            "Amount Paid" := GenJnlLine.Amount;
            "Amount Paid LCY" := GenJnlLine."Amount (LCY)";
            "Amount Invoice" := VendorLedgerEntry."Original Amount";
            "Amount Invoice LCY" := VendorLedgerEntry."Original Amt. (LCY)";
            "Amount Retention" := GenJnlLine."Retention Amount";
            "Amount Retention LCY" := GenJnlLine."Retention Amount LCY";
            //"Amount Invoice LCY" := GenJnlLine."Retention Amount";
            //if VendorLedgerEntry."Currency Code" <> '' then begin
            //    "Amount Retention" := Round(GenJnlLine."Retention Amount" / CurrencyAmount, 0.01);
            //    "Amount Invoice LCY" := Round(GenJnlLine."Retention Amount", 0.01);
            //end;
            "Currency Code" := GenJnlLine."Currency Code";
            "Currency Factor" := GenJnlLine."Currency Factor";
            VendorLedgerEntry."Retention No." := RetentionNo;
            VendorLedgerEntry."Applied Retention" := true;
            VendorLedgerEntry."Retention Amount" := "Amount Retention";
            VendorLedgerEntry."Retention Amount LCY" := "Amount Retention LCY";
            VendorLedgerEntry.Modify();

            "Source Jnl Batch Name" := GenJnlLine."Journal Batch Name";
            "Source Jnl Template Name" := GenJnlLine."Journal Template Name";
            "Manual Retention" := GenJnlLine."Manual Retention";
            GLEntry.Reset();
            GLEntry.SetRange("Document No.", TempGLEntryBuf."Document No.");
            if GLEntry.FindSet() then
                repeat
                    GLEntry."Retention No." := RetentionNo;
                    GLEntry.Modify();
                until GLEntry.Next() = 0;
            VendLE.Reset();
            VendLE.SetRange("Document No.", TempGLEntryBuf."Document No.");
            VendLE.SetRange("External Document No.", GenJnlLine."External Document No.");
            if VendLE.FindFirst() then begin
                if VendLE."Retention No." = '' then begin
                    VendLE."Retention No." := RetentionNo;
                    VendLE."Retention Amount" := "Amount Retention";
                    VendLE."Retention Amount LCY" := "Amount Retention LCY";
                    VendLE.Modify();
                end;
            end;
            Insert();
            SaveRetention();
            NextDtldRetLedgerEntryNo += 1;
        end;
    end;

    local procedure CreateRetentionEntry()
    begin
        With DtldRetLedgerEntryBuffer do begin
            Reset();
            if FindFirst() then
                repeat
                    RetentionLedgerEntry.Init();
                    RetentionLedgerEntry."Entry No." := NextRetLedgerEntryNo;
                    RetentionLedgerEntry."Retention No." := "Retention No.";
                    RetentionLedgerEntry."Retention Posting Date" := "Retention Posting Date";
                    RetentionLedgerEntry."Retention Legal Document" := "Retention Legal Document";
                    RetentionLedgerEntry."Vendor No." := "Vendor No.";
                    RetentionLedgerEntry."Vendor Name" := "Vendor Name";
                    RetentionLedgerEntry."Source Document No." := "Source Document No.";
                    RetentionLedgerEntry."Assing User ID" := UserId;
                    RetentionLedgerEntry."Source Jnl Batch Name" := "Source Jnl Batch Name";
                    RetentionLedgerEntry."Source Jnl Template Name" := "Source Jnl Template Name";
                    RetentionLedgerEntry."Manual Retention" := "Manual Retention";
                    RetentionLedgerEntry.Insert();
                    NextRetLedgerEntryNo += 1;
                    OnAfterInsertRetentionLedgerEntry(RetentionLedgerEntry, PreviewMde);
                until Next() = 0;
        end;
    end;

    local procedure SaveRetention()
    begin
        DtldRetLedgerEntryBuffer.Reset();
        DtldRetLedgerEntryBuffer.SetRange("Retention No.", RetentionNo);
        if DtldRetLedgerEntryBuffer.IsEmpty then begin
            DtldRetLedgerEntryBuffer.Init();
            DtldRetLedgerEntryBuffer.TransferFields(DtldRetentionLedgEntry, true);
            DtldRetLedgerEntryBuffer.Insert();
        end;
    end;

    local procedure GetVendorInvNo_VendorCrMemoNo(): code[20];
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        case VendorLedgerEntry."Legal Document" of
            '01', '03', '08':
                begin
                    if PurchInvHeader.Get(VendorLedgerEntry."Document No.") then
                        exit(PurchInvHeader."Vendor Invoice No.")
                    else
                        exit(VendorLedgerEntry."External Document No.");
                end;
            '07':
                begin
                    if PurchCrMemoHdr.Get(VendorLedgerEntry."Document No.") then
                        exit(PurchCrMemoHdr."Vendor Cr. Memo No.")
                    else
                        exit(VendorLedgerEntry."External Document No.");
                end;
            else
                exit(VendorLedgerEntry."External Document No.");
        end;
    end;

    local procedure SetNextEntryNoRetentionLedgerEntry(): Integer
    var
        RetentionLedgerEntry: Record "Retention Ledger Entry";
    begin
        RetentionLedgerEntry.SetCurrentKey("Entry No.");
        RetentionLedgerEntry.Ascending(true);
        if RetentionLedgerEntry.FindLast() then
            exit(RetentionLedgerEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure SetNextEntryNoDtldRetLedgerEntry(): Integer
    var
        DtldRetentionLdgEntry: Record "Detailed Retention Ledg. Entry";
    begin
        DtldRetentionLdgEntry.SetCurrentKey("Entry No.");
        DtldRetentionLdgEntry.Ascending(true);
        if DtldRetentionLdgEntry.FindLast() then
            exit(DtldRetentionLdgEntry."Entry No." + 1);
        exit(1);
    end;

    local procedure NextRetentionNo()
    begin
        if LastVendorNo <> GenJnlLine."Account No." then begin
            IsManualRetention := GenJnlLine."Manual Retention";
            if IsManualRetention then
                RetentionNo := NoSerieMgt.GetNextNo(Setup."Retention Physical Nos", WorkDate(), true)
            else
                RetentionNo := NoSerieMgt.GetNextNo(Setup."Retention Electronic Nos", WorkDate(), true);
            LastVendorNo := GenJnlLine."Account No.";
            if StrPos(ListRetentionNos, RetentionNo) = 0 then
                ListRetentionNos += RetentionNo + ' \ ';
        end;
    end;

    procedure ValidateRetention(AppliedRetention: Boolean; VendorNo: Code[20]; AppliedToDocNo: Code[20]; PostingDate: Date)
    var
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
        ErrorDocumentDetraction: Label 'Document No %1 is detraction.', Comment = 'ESM="El documento N° %1 tiene detracción."';
        UbigeoMngt: Codeunit "Ubigeo Management";
    begin
        if not AppliedRetention then
            exit;
        Vendor.Get(VendorNo);
        if (Vendor."Good Contributor") and (PostingDate >= Vendor."Good Contributor Start Date") then
            Vendor.TestField("Good Contributor", false);
        if (Vendor."Perception Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            Vendor.TestField("Perception Agent", false);
        if (Vendor."Retention Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            Vendor.TestField("Retention Agent", false);
        if AppliedToDocNo <> '' then
            if PurchInvHeader.Get(AppliedToDocNo) then
                if PurchInvHeader."Purch. Detraction" then
                    Error(ErrorDocumentDetraction, PurchInvHeader."No.");
    end;

    procedure ValidateStatusVendorAndDocumentNoForRetention(VendorNo: Code[20]; AppliedToDocNo: Code[20]; PostingDate: Date): Boolean
    var
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
        ErrorDocumentDetraction: Label 'Document No %1 is detraction.', Comment = 'ESM="El documento N° %1 tiene detracción."';
        lcVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        Vendor.Get(VendorNo);
        if (Vendor."Good Contributor") and (PostingDate >= Vendor."Good Contributor Start Date") then
            exit(false);
        if (Vendor."Perception Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            exit(false);
        if (Vendor."Retention Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            exit(false);
        if AppliedToDocNo <> '' then
            if PurchInvHeader.Get(AppliedToDocNo) then begin
                if PurchInvHeader."Legal Document" in ['01', '03', '07', '08'] = false then
                    exit(false);
                if PurchInvHeader."Purch. Detraction" then
                    exit(false);
            end else begin
                lcVendorLedgerEntry.Reset();
                lcVendorLedgerEntry.SetCurrentKey("Document No.");
                lcVendorLedgerEntry.SetRange("Document No.", AppliedToDocNo);
                lcVendorLedgerEntry.SetFilter("Legal Document", '<>01&<>03&<>07&<>08');
                if lcVendorLedgerEntry.FindFirst() then
                    exit(false);
            end;
        exit(true);
    end;

    procedure ValidateStatusForAmountRetention(AmountLCY: Decimal): Boolean
    begin
        Setup.Get();
        if AmountLCY >= Setup."Retention Limit Amount" then
            exit(true);
        exit(false);
    end;

    procedure SetAutomateRetentionCheck(var RetentionStatus: Boolean; VendorNo: Code[20]; PostingDate: Date; AppliedToDocNo: Code[20]; AmountLCY: Decimal)
    var
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
        lcVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        RetentionStatus := true;
        Setup.Get();
        Vendor.Get(VendorNo);
        if (Vendor."Good Contributor") and (PostingDate >= Vendor."Good Contributor Start Date") then
            RetentionStatus := false;
        if (Vendor."Perception Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            RetentionStatus := false;
        if (Vendor."Retention Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            RetentionStatus := false;
        if AppliedToDocNo <> '' then
            if PurchInvHeader.Get(AppliedToDocNo) then begin
                if PurchInvHeader."Legal Document" in ['01', '03', '07', '08'] = false then
                    RetentionStatus := false;
                if PurchInvHeader."Purch. Detraction" then
                    RetentionStatus := false;
            end else begin
                lcVendorLedgerEntry.Reset();
                lcVendorLedgerEntry.SetCurrentKey("Document No.");
                lcVendorLedgerEntry.SetRange("Document No.", AppliedToDocNo);
                lcVendorLedgerEntry.SetFilter("Legal Document", '<>01&<>03&<>07&<>08');
                if lcVendorLedgerEntry.FindFirst() then
                    RetentionStatus := false;
            end;
        if AmountLCY < Setup."Retention Limit Amount" then
            RetentionStatus := false;
    end;

    procedure SetAutomateRetentionForVendor(var RetentionStatus: Boolean; VendorNo: Code[20]; PostingDate: Date; AppliedToDocNo: Code[20])
    var
        Vendor: Record Vendor;
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        RetentionStatus := true;
        Setup.Get();
        Vendor.Get(VendorNo);
        if (Vendor."Good Contributor") and (PostingDate >= Vendor."Good Contributor Start Date") then
            RetentionStatus := false;
        if (Vendor."Perception Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            RetentionStatus := false;
        if (Vendor."Retention Agent") and (PostingDate >= Vendor."Perception Agent Start Date") then
            RetentionStatus := false;
        if AppliedToDocNo <> '' then
            if PurchInvHeader.Get(AppliedToDocNo) then
                if PurchInvHeader."Purch. Detraction" then
                    RetentionStatus := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforePostGenJnlLine', '', false, false)]
    local procedure OnBeforePostGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; Balancing: Boolean)
    var
        CustPostGroup: Record "Customer Posting Group";
        VendPostGroup: Record "Vendor Posting Group";
        BankAccount: Record "Bank Account Posting Group";
        EmpPostGroup: Record "Employee Posting Group";
        PostingGroupErr: Label 'Todos los movimientos debe ser en la misma divisa.';
    begin
        with GenJournalLine do begin
            case "Account Type" of
                "Account Type"::"G/L Account":
                    begin
                        //CheckGLAccDimError(GenJournalLine, GenJournalLine."Account No.");
                        if "Bal. Account No." <> '' then
                            CheckPostingGroupError(GenJournalLine);
                    end;
                "Account Type"::Customer:
                    begin
                        CustPostGroup.Get(GenJournalLine."Posting Group");
                        //CheckGLAccDimError(GenJournalLine, CustPostGroup."Receivables Account");
                        if "Currency Code" <> CustPostGroup."Currency Code" then
                            Error(PostingGroupErr);
                    end;
                "Account Type"::Vendor:
                    begin
                        VendPostGroup.Get(GenJournalLine."Posting Group");
                        //CheckGLAccDimError(GenJournalLine, VendPostGroup."Payables Account");
                        if "Currency Code" <> VendPostGroup."Currency Code" then
                            Error(PostingGroupErr);
                    end;
                "Account Type"::Employee:
                    begin
                        EmpPostGroup.Get(GenJournalLine."Posting Group");
                        //CheckGLAccDimError(GenJournalLine, EmpPostGroup."Payables Account");
                        if "Currency Code" <> EmpPostGroup."Currency Code" then
                            Error(PostingGroupErr);
                    end;
                "Account Type"::"Bank Account":
                    begin
                        BankAccount.Get(GenJournalLine."Account No.");
                        //CheckGLAccDimError(GenJournalLine, BankAccount."G/L Account No.");
                        if "Bal. Account No." <> '' then
                            CheckPostingGroupError(GenJournalLine);
                    end;
            end;
        end;
    end;

    local procedure CheckPostingGroupError(pGenJournalLine: Record "Gen. Journal Line")
    var
        CustPostGroup: Record "Customer Posting Group";
        VendPostGroup: Record "Vendor Posting Group";
        BankAccount: Record "Bank Account Posting Group";
        EmpPostGroup: Record "Employee Posting Group";
        PostingGroupErr: Label 'Todos los movimientos debe ser en la misma divisa.';
    begin
        case pGenJournalLine."Bal. Account Type" of
            pGenJournalLine."Bal. Account Type"::Customer:
                begin
                    CustPostGroup.Get(pGenJournalLine."Posting Group");
                    if pGenJournalLine."Currency Code" <> CustPostGroup."Currency Code" then
                        Error(PostingGroupErr);
                end;
            pGenJournalLine."Bal. Account Type"::Vendor:
                begin
                    VendPostGroup.Get(pGenJournalLine."Posting Group");
                    if pGenJournalLine."Currency Code" <> VendPostGroup."Currency Code" then
                        Error(PostingGroupErr);
                end;
            pGenJournalLine."Bal. Account Type"::Employee:
                begin
                    EmpPostGroup.Get(pGenJournalLine."Posting Group");
                    if pGenJournalLine."Currency Code" <> EmpPostGroup."Currency Code" then
                        Error(PostingGroupErr);
                end;
        end;
    end;

    local procedure CheckGLAccDimError(GenJnlLine: Record "Gen. Journal Line"; GLAccNo: Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
        TableID: array[10] of Integer;
        AccNo: array[10] of Code[20];
        DimensionUsedErr: Label 'A dimension used in %1 %2, %3, %4 has caused an error. %5.', Comment = 'ESM="Una dimensión utilizada en %1 %2, %3, %4 ha causado un error. %5."';
    begin
        if (GenJnlLine.Amount = 0) and (GenJnlLine."Amount (LCY)" = 0) then
            exit;

        TableID[1] := DATABASE::"G/L Account";
        AccNo[1] := GLAccNo;
        if DimMgt.CheckDimValuePosting(TableID, AccNo, GenJnlLine."Dimension Set ID") then
            exit;

        if GenJnlLine."Line No." <> 0 then
            Error(
              DimensionUsedErr,
              GenJnlLine.TableCaption, GenJnlLine."Journal Template Name",
              GenJnlLine."Journal Batch Name", GenJnlLine."Line No.",
              DimMgt.GetDimValuePostingErr);

        Error(DimMgt.GetDimValuePostingErr);
    end;

    procedure ReverseRetention(RetentionLE: Record "Retention Ledger Entry")
    var
        VendorLE: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        UserSetup: Record "User Setup";
        Num: Integer;
        j_line: Record "Gen. Journal Line";
        SetupLoca: Record "Setup Localization";
        ImporteProvRet: Decimal;
        BoolCurrencyCode: Boolean;
        Diario: Code[20];
        Seccion: Code[20];
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlManagement: Codeunit GenJnlManagement;
        Parameter: array[4] of Text;
        ValueParameter: array[4] of Text;
        MsgNotification: Label 'Existen registros en el diario, revisar información para evitar errores';
        ViewHere: Label 'Ver Diario';
        FunctionName: Label 'ViewTemplateBatch';
        SLSetupMgt: Codeunit "Setup Localization";
    begin
        SetupLoca.Get();
        Diario := SetupLoca."Retention Journal Template";
        Seccion := SetupLoca."Retention Journal Batch";
        j_line.Reset();
        j_line.SetRange("Journal Template Name", Diario);
        j_line.SetRange("Journal Batch Name", Seccion);
        if j_line.FindFirst() then begin
            Parameter[1] := 'TemplateName';
            Parameter[2] := 'BatchName';
            ValueParameter[1] := j_line."Journal Template Name";
            ValueParameter[2] := j_line."Journal Batch Name";
            SLSetupMgt.AlertAndViewWhitNotification(MsgNotification, ViewHere, Codeunit::"Retention Management", FunctionName, Parameter, ValueParameter);
            exit;

        end;
        BoolCurrencyCode := false;
        VendorLE.RESET;
        VendorLE.SetRange("Vendor No.", RetentionLE."Vendor No.");
        VendorLE.SetRange("Document No.", RetentionLE."Source Document No.");
        VendorLE.SetRange(Open, true);
        VendorLE.SetAutoCalcFields("Remaining Amount");
        IF VendorLE.FINDSET THEN
            REPEAT
                if VendorLE."Currency Code" <> '' then
                    BoolCurrencyCode := true;
                Vendor.GET(VendorLE."Vendor No.");
                Vendor.TestField(Blocked, Vendor.Blocked::" ");
                UserSetup.GET(USERID);
                Num := Num + 1000;
                j_line.INIT;
                j_line."Journal Template Name" := Diario;
                j_line."Journal Batch Name" := Seccion;
                j_line."Line No." := Num;
                //    j_line."Document Type":=j_line."Document Type"::Payment;
                j_line."Posting Date" := TODAY;
                j_line."Document Date" := TODAY;
                j_line."Account Type" := j_line."Account Type"::Vendor;
                j_line.VALIDATE("Account No.", VendorLE."Vendor No.");
                j_line.Description := VendorLE.Description;
                j_line.VALIDATE("Applies-to Doc. No.", VendorLE."Document No.");
                j_line.VALIDATE("Posting Group", VendorLE."Vendor Posting Group");
                j_line."Applies-to Doc. Type" := VendorLE."Document Type";
                j_line."Document No." := VendorLE."Document No.";
                j_line."External Document No." := VendorLE."External Document No.";
                j_line.VALIDATE(Amount, -VendorLE."Remaining Amount");
                ImporteProvRet += -VendorLE."Remaining Amount";
                //  j_line."Amount (LCY)" :=-Importe;
                j_line."Source Code" := 'DIAPAGOS';
                j_line.VALIDATE("Dimension Set ID", VendorLE."Dimension Set ID");
                j_line."Posting Text" := VendorLE."Posting Text";
                j_line."Applies-to Entry No." := VendorLE."Entry No.";
                j_line."Setup Source Code" := j_line."Setup Source Code"::"Reverse Retention";
                j_line.INSERT;
                if VendorLE."Retention No." <> '' then begin
                    j_line.INIT;
                    Num := Num + 1000;
                    j_line."Journal Template Name" := Diario;
                    j_line."Journal Batch Name" := Seccion;
                    j_line."Line No." := Num;
                    j_line."Posting Date" := TODAY;
                    //  j_line."Document Date":=CustLedgerEntry."Document Date";
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", SetupLoca."Retention G/L Account No.");
                    j_line.Description := 'REVERSION DE RETENCION' + VendorLE."Document No.";
                    j_line."Document No." := VendorLE."Document No.";
                    j_line."External Document No." := VendorLE."External Document No.";
                    j_line.VALIDATE(Amount, VendorLE."Retention Amount");
                    ImporteProvRet += VendorLE."Retention Amount";
                    j_line."Source Code" := 'DIACOBROS';
                    //  j_line."Payment Terms Code":=CustLedgerEntry."Payment Terms Code";
                    //  j_line.VALIDATE("Dimension Set ID",CustLedgerEntry."Dimension Set ID");
                    j_line."Posting Text" := 'REVERSION DE RETENCION' + VendorLE."Document No.";
                    j_line."Setup Source Code" := j_line."Setup Source Code"::"Reverse Retention";
                    j_line.INSERT;
                end;
            UNTIL VendorLE.NEXT = 0;
        j_line.INIT;
        Num := Num + 1000;
        j_line.INIT;
        j_line."Journal Template Name" := Diario;
        j_line."Journal Batch Name" := Seccion;
        j_line."Line No." := Num;
        //    j_line."Document Type":=j_line."Document Type"::Payment;
        j_line."Posting Date" := TODAY;
        j_line."Document Date" := TODAY;
        j_line."Account Type" := j_line."Account Type"::Vendor;
        j_line.VALIDATE("Account No.", RetentionLE."Vendor No.");
        j_line.Description := 'PROVISION DE RETENCION' + RetentionLE."Retention No.";
        if not BoolCurrencyCode then
            j_line.VALIDATE("Posting Group", SetupLoca."Rev. Ret. Posting Group MN")
        else
            j_line.VALIDATE("Posting Group", SetupLoca."Rev. Ret. Posting Group ME");
        j_line."Document No." := RetentionLE."Source Document No.";
        j_line."External Document No." := VendorLE."External Document No.";
        j_line.VALIDATE(Amount, -ImporteProvRet);
        //  j_line."Amount (LCY)" :=-Importe;
        j_line."Source Code" := 'DIAPAGOS';
        j_line."Posting Text" := 'REVERSION DE RETENCION' + RetentionLE."Retention No.";
        j_line."Setup Source Code" := j_line."Setup Source Code"::"Reverse Retention";
        j_line.INSERT;

        GenJnlBatch.GET(Diario, Seccion);
        GenJnlManagement.TemplateSelectionFromBatch(GenJnlBatch);
    end;

    procedure ViewTemplateBatch(pNotification: Notification)
    var
        TemplateName: Text;
        BatchName: Text;
        GenJnlBatch2: Record "Gen. Journal Batch";
    begin
        TemplateName := pNotification.GetData('TemplateName');
        BatchName := pNotification.GetData('BatchName');
        GenJnlBatch2.Get(TemplateName, BatchName);
        GenJnlMgt.TemplateSelectionFromBatch(GenJnlBatch2);
    end;
    //--   
    [IntegrationEvent(false, false)]
    procedure OnAfterGetSourceTypeVendorLedgerEntry(var pGenJnlLine: Record "Gen. Journal Line"; var IsInvoice: Boolean; var IsCrMemo: Boolean; var IsLetter: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalculateRetention(var pGenJnlLine: Record "Gen. Journal Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertRetentionLedgerEntry(var RetentionLE: Record "Retention Ledger Entry"; var PreviewMode: Boolean)
    begin
    end;

    var
        PreviewMde: Boolean;
        Setup: Record "Setup Localization";
        GenJnlLine: Record "Gen. Journal Line";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        RetentionLedgerEntry: Record "Retention Ledger Entry";
        DtldRetentionLedgEntry: Record "Detailed Retention Ledg. Entry";
        Vendor: Record Vendor;
        GenJnlLineBuffer: Record "Gen. Journal Line" temporary;
        DtldRetLedgerEntryBuffer: Record "Detailed Retention Ledg. Entry" temporary;
        ConstrutOutStream: OutStream;
        NoSerieMgt: Codeunit NoSeriesManagement;
        TempFileBlob: Codeunit "Temp Blob";
        StartDate: Date;
        EndDate: Date;
        Windows: Dialog;
        NextRetLedgerEntryNo: Integer;
        NextDtldRetLedgerEntryNo: Integer;
        RetentionNo: Code[20];
        LastVendorNo: Code[20];
        DestinationBankNo: Code[20];
        IsManualRetention: Boolean;
        ListRetentionNos: Text;
        CheckDateExistsMessage: Label 'Enter Start Date and End Date to continue.';
        ErrorSelectedDate: Label 'You can only generate the PDT for one period at a time.';
        Processing: Label 'Processing  #1#######################\';
        CreatingFile: Label 'CreatingFile  #2#######################\';
        GenJnlMgt: Codeunit GenJnlManagement;
}