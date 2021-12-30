codeunit 51013 "Massive Banks Payments"
{
    trigger OnRun()
    begin

    end;
    //Global Functions
    local procedure OpenWindows(CreateFileFlag: Boolean)
    var
        ContaintText: Text[200];
    begin
        ContaintText := Processing;
        if CreateFileFlag then
            ContaintText += CreatingFile;
        Windows.Open(ContaintText);
    end;

    local procedure UpdateWindows(Number: integer; Counter: integer; Total: integer)
    begin
        Windows.Update(Number, ROUND(Counter / Total * 10000, 2));
    end;

    local procedure CloseWindows()
    begin
        Windows.Close();
    end;


    procedure fnGenerateSalaryTelecreditEmployee(pGenJnlLine: Record "Gen. Journal Line")
    begin
        if fnDefineTypeTelecredit(pGenJnlLine) = 1 then begin
            fnGenerateSalaryTelecreditVendor(pGenJnlLine);
            exit;
        end;
    end;

    procedure fnGenerateVendorTelecreditBCP(pGenJnlLine: Record "Gen. Journal Line"; pHBS: Boolean; pCTS: Boolean)
    var
        GenJnlLine2: Record "Gen. Journal Line";
        lcBankAccountNo: Code[20];
        lclTexto: Text[1024];
        lclCampos: Text[1024];
        lcI: integer;
        lclAmountLCY: Decimal;
        lclTotalCheckSum: Decimal;
        lclCheckSumDec: Decimal;
        lclLine: integer;
        lclNotaCargo: Text;
        lclGenJLine2: Record "Gen. Journal Line";
        lclTipoPago: Text;
        lclBank: Record "Bank Account";
        lclSoles: Boolean;
        lclChekSum: Text[1024];
        lclNumCount2: integer;
        pBankAmount: Decimal;
        lclFile: File;
        lclWindow: Dialog;
        ConcatBanco: Text;
        lclGenJnlLine: Record "Gen. Journal Line";
        lclVendorBankAccount: Record "Vendor Bank Account";
        Checksum: Biginteger;
        lclCampos2: Text;
        lcMultiple: Boolean;
        lclVendor: Record Vendor;
        lcNameVendor: Text;
        lcVendorinvoiceNo: Code[30];
        lcRecPurchinvHeader: Record "Purch. inv. Header";
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcRecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lcAdditionalReference: Text;
        gNewAcc: Text;
        lclint: integer;
        lcAmount: Decimal;
        lcAmountText: Text;
        lcFileName: Text;
    begin
        //003
        CompanyInf.Get();
        lclLine := 0;
        if CONFIRM('Desea Nota de cargo') then begin
            lclNotaCargo := '1'
        end else begin
            lclNotaCargo := '0';
        end;

        lclGenJLine2.Reset();
        lclGenJLine2.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJLine2.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJLine2.SETFILTER("Account Type", '%1', lclGenJLine2."Account Type"::"Bank Account");
        lclGenJLine2.FinDSET;
        pGenJnlLine.COPY(lclGenJLine2);


        pGenJnlLine.TestField("Account Type", pGenJnlLine."Account Type"::"Bank Account"); //no tocar
        lclTipoPago := CopyStr(Format(pGenJnlLine."Bulk Payment Type"), 1, 1);

        if (lclBank.Get(pGenJnlLine."Account No.")) and (lclBank."Currency Code" = 'USD') then begin
            lclSoles := false
        end else begin
            lclSoles := true;
        end;

        pGenJnlLine.TestField(Amount);
        pBankAmount := ABS(pGenJnlLine.Amount);

        lclWindow.Open(Processing);

        Clear(lclFile);
        CreateTempFile();

        lclChekSum := '';
        pGenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        pGenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        pGenJnlLine.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
        //begin ULN::RHF 20190701 (++)
        pGenJnlLine.SetCurrentKey(pGenJnlLine."Account No.");
        pGenJnlLine.SETASCendinG(pGenJnlLine."Account No.", true);
        //end ULN::RHF 20190701 (++)
        if pGenJnlLine.FindSet() then
            repeat
                lclNumCount2 += 1;
                lclWindow.UPDATE(1, ROUND(lclNumCount2 / pGenJnlLine.COUNT * 10000, 1));
                Clear(lclCampos);
                lclLine += 1;

                //Make Header
                if lclLine = 1 then begin
                    if pHBS then begin
                        lclCampos := '#1HC';
                    end else begin
                        lclCampos := '#1PC';
                    end;

                    if pCTS then begin
                        lclCampos := '2' + PadStr('', 14, ' ');
                    end;

                    lclBank.TestField("Bank Account No.");
                    if (lclBank."Bank Account Type" = lclBank."Bank Account Type"::"Current Account") or (lclBank."Bank Account Type" = lclBank."Bank Account Type"::"Master Account") then begin
                        EVALUATE(lclCheckSumDec, CopyStr(lclBank."Bank Account No.", 5, 7) + DelChr(CopyStr(lclBank."Bank Account No.", 12, 10), '=', '-'));
                        ConcatBanco := CopyStr(lclBank."Bank Account No.", 1, 3) + '0' + CopyStr(lclBank."Bank Account No.", 5, 7) + DelChr(CopyStr(lclBank."Bank Account No.", 12, 10), '=', '-');
                    end;

                    if (lclBank."Bank Account Type" = lclBank."Bank Account Type"::"Savings Account") then begin
                        EVALUATE(lclCheckSumDec, CopyStr(lclBank."Bank Account No.", 5, 8) + DelChr(CopyStr(lclBank."Bank Account No.", 12, 10), '=', '-'));
                        ConcatBanco := CopyStr(lclBank."Bank Account No.", 1, 3) + CopyStr(lclBank."Bank Account No.", 5, 8) + DelChr(CopyStr(lclBank."Bank Account No.", 13, 10), '=', '-');
                    end;

                    lclCampos := lclCampos + PadStr(ConcatBanco, 20, ' ');
                    if lclSoles then begin
                        if pCTS then begin
                            lclCampos := lclCampos + 'MN'
                        end else begin
                            lclCampos := lclCampos + 'S/'
                        end;
                    end else begin
                        if pCTS then begin
                            lclCampos := lclCampos + 'ME'
                        end else begin
                            lclCampos := lclCampos + 'US';
                        end;
                    end;

                    if pCTS then begin
                        CompanyInf.TestField("VAT Registration No.");
                        CompanyInf.TestField(Name);
                        CompanyInf.TestField(Address);
                        lclCampos := lclCampos + PadStr('', 6, ' ');
                        CompanyInf.GET;
                        lclCampos := lclCampos + CompanyInf."VAT Registration No." + '00000000000' + PadStr('', 6, ' ');
                    end;

                    lclCampos := lclCampos + PadStr('', 15 - StrLen(fnGetFormatAmt(false, pBankAmount)), '0') + fnGetFormatAmt(false, pBankAmount);

                    if pCTS then begin
                        lclCampos := lclCampos + PadStr('', 5 - StrLen(Format(pGenJnlLine.COUNT)), '0') + Format(pGenJnlLine.COUNT) + PadStr('', 10, ' ') + 'R1 ';
                        lclCampos := lclCampos + CompanyInf.Name + PadStr('', 40 - StrLen(CompanyInf.Name));
                        if StrLen(CompanyInf.Address) < 40 then begin
                            lclCampos := lclCampos + CompanyInf.Address + PadStr('', 40 - StrLen(CompanyInf.Address))
                        end else begin
                            lclCampos := lclCampos + CopyStr(CompanyInf.Address, 1, 40);
                        end;

                        lclCampos := lclCampos + PadStr('', 35, ' ');
                        lclCampos := lclCampos + '@';
                    end else begin
                        lclCampos := lclCampos + Format(pGenJnlLine."Posting Date", 8, '<Day,2><Month,2><Year4>');
                        lclCampos := lclCampos + DelChr(pGenJnlLine."document No.", '=', 'Ñ/&%$#"!°|,._') + PadStr('', 20 - StrLen(DelChr(pGenJnlLine."document No.", '=', 'Ñ/&%$#"!°|,._')), ' '); //RRR

                        lclGenJnlLine.Reset();
                        lclGenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
                        lclGenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
                        lclGenJnlLine.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
                        if lclGenJnlLine.FindSet() then
                            repeat
                                lclint := 0;
                                lclGenJnlLine.TestField("Recipient Bank Account");

                                lclVendorBankAccount.Reset();
                                lclVendorBankAccount.SetRange("Vendor No.", lclGenJnlLine."Account No.");
                                lclVendorBankAccount.SetRange(Code, lclGenJnlLine."Recipient Bank Account");
                                if lclVendorBankAccount.FindSet() then begin
                                    if Not lclVendorBankAccount."Check Manager" then begin
                                        lclVendorBankAccount.TestField("Bank Account Type");
                                        if (lclVendorBankAccount."Bank Account Type" = lclVendorBankAccount."Bank Account Type"::"Current Account")
                                            or (lclVendorBankAccount."Bank Account Type" = lclVendorBankAccount."Bank Account Type"::"Master Account") then begin
                                            lclVendorBankAccount.TestField("Bank Account No.");
                                            if StrLen(lclVendorBankAccount."Bank Account No.") = 20 then
                                                EVALUATE(lclCheckSumDec, CopyStr(lclVendorBankAccount."Bank Account No.", 10, 10))
                                            else begin
                                                if Not EVALUATE(lclCheckSumDec, DelChr(CopyStr(lclVendorBankAccount."Bank Account No.", 5, 7), '=', '-') + DelChr(CopyStr(lclVendorBankAccount."Bank Account No.", 12, 10), '=', '-')) then
                                                    Error(BankAccountTypeError, lclVendorBankAccount.Code, lclGenJnlLine."Line No.");
                                            end;
                                        end;

                                        if (lclVendorBankAccount."Bank Account Type" = lclVendorBankAccount."Bank Account Type"::"Savings Account") then begin
                                            lclVendorBankAccount.TestField("Bank Account No.");
                                            if Not EVALUATE(lclCheckSumDec, DelChr(CopyStr(lclVendorBankAccount."Bank Account No.", 5, 8), '=', '-') + DelChr(CopyStr(lclVendorBankAccount."Bank Account No.", 13, 10), '=', '-')) then
                                                Error(BankAccountTypeError, lclVendorBankAccount.Code, lclGenJnlLine."Line No.");
                                        end;

                                        lclTotalCheckSum += lclCheckSumDec;
                                    end;
                                end else begin
                                    Error('Cuenta Banco Proveedor %1 no existe', lclGenJnlLine."Account No.");
                                end;
                            until lclGenJnlLine.NEXT = 0;


                        Checksum := lclTotalCheckSum + lclCheckSumDec;
                        lclCampos := lclCampos + PadStr('', 15 - StrLen(Format(Checksum)), '0') + Format(Checksum);
                        if pHBS then begin
                            lclCampos := lclCampos + PadStr('', 6 - StrLen(Format(pGenJnlLine.COUNT)), '0') + Format(pGenJnlLine.COUNT) + lclTipoPago + PadStr('', 15, ' ') + lclNotaCargo
                        end else begin
                            lclCampos := lclCampos + PadStr('', 6 - StrLen(Format(pGenJnlLine.COUNT)), '0') + Format(pGenJnlLine.COUNT) + '0' + PadStr('', 15, ' ') + lclNotaCargo;
                        end;
                    end;
                    //ULN::PC 001  2020.06.01 v.001 begin 
                    //lclFile.WRITE(lclCampos);
                    insertLineToTempFile(lclCampos);
                    //ULN::PC 001  2020.06.01 v.001 end                   

                end;

                //Make Body ----------------------------------------------------------------------------
                GenJnlLine2.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
                GenJnlLine2.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
                GenJnlLine2.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
                if GenJnlLine2.FindSet() then begin
                    if GenJnlLine2.COUNT > 1 then
                        lcMultiple := true
                    else
                        lcMultiple := false
                end;

                CompanyInf.GET;

                lclVendorBankAccount.Reset();
                lclVendorBankAccount.SetRange("Vendor No.", pGenJnlLine."Account No.");
                lclVendorBankAccount.SetRange(Code, pGenJnlLine."Recipient Bank Account");
                if lclVendorBankAccount.FindSet() then begin
                    lclCampos2 := ' 3';
                    if lclVendorBankAccount."Check Manager" then begin
                        lclCampos := ' 0G' + PadStr('', 20, ' ');
                        if lclVendor.Get(lclVendorBankAccount."Vendor No.") then begin
                            lclCampos := lclCampos + CONVERTSTR(CopyStr(DelChr(lclVendor.Name, '=', ',&-'), 1, 40), 'ñÑ', 'nN') + PadStr('', 40 - StrLen(CopyStr(DelChr(lclVendor.Name, '=', ',&-'), 1, 40)), ' ');
                        end;
                        if lclVendorBankAccount."Currency Code" = '' then
                            lclCampos := lclCampos + 'S/'
                        else
                            lclCampos := lclCampos + 'US';
                        lclCampos := lclCampos + PadStr('', 15 - StrLen(fnGetFormatAmt(false, ABS(pGenJnlLine.Amount))), '0') + fnGetFormatAmt(false, ABS(pGenJnlLine.Amount));
                        case lclVendor."VAT Registration Type" of
                            '1':
                                lclCampos := lclCampos + 'DNI';
                            '3':
                                lclCampos := lclCampos + 'CE';
                            '4':
                                lclCampos := lclCampos + 'PAS';
                            '6':
                                lclCampos := lclCampos + 'RUC';
                        end;
                        lclCampos := lclCampos + lclVendor."VAT Registration No." + PadStr('', 12 - StrLen(lclVendor."VAT Registration No."), ' ');

                        pGenJnlLine.TestField("Applies-to doc. Type");

                        if (pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::invoice) or (lclVendor."VAT Registration Type" = '1') then begin
                            lcVendorinvoiceNo := '';
                            lclCampos := lclCampos + 'F';
                            lclCampos2 += 'F';
                            lcRecPurchinvHeader.Reset();
                            lcRecPurchinvHeader.SetRange("No.", pGenJnlLine."Applies-to doc. No.");
                            if lcRecPurchinvHeader.FindSet() then
                                lcVendorinvoiceNo := lcRecPurchinvHeader."Vendor invoice No."
                            else begin
                                lclVendorLedgerEntry.Reset();
                                lclVendorLedgerEntry.SetRange(lclVendorLedgerEntry."document No.", pGenJnlLine."Applies-to doc. No.");
                                if lclVendorLedgerEntry.FindSet() then
                                    lcVendorinvoiceNo := lclVendorLedgerEntry."document No.";
                            end;
                        end;
                        if pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::"Credit Memo" then begin
                            lcVendorinvoiceNo := '';
                            lclCampos := lclCampos + 'N';
                            lclCampos2 += 'N';
                            lcRecPurchCrMemoHdr.Reset();
                            lcRecPurchCrMemoHdr.SetRange("No.", pGenJnlLine."Applies-to doc. No.");
                            if lcRecPurchCrMemoHdr.FindSet() then
                                lcVendorinvoiceNo := lcRecPurchCrMemoHdr."Vendor Cr. Memo No."
                            else begin
                                lclVendorLedgerEntry.Reset();
                                lclVendorLedgerEntry.SetRange(lclVendorLedgerEntry."document No.", pGenJnlLine."Applies-to doc. No.");
                                if lclVendorLedgerEntry.FindSet() then
                                    lcVendorinvoiceNo := lclVendorLedgerEntry."document No.";
                            end;
                        end;
                        if (pGenJnlLine."Applies-to Entry No." = 0) then begin
                            lcVendorinvoiceNo := '';
                            lclCampos := lclCampos + 'F';
                            lclCampos2 += 'F';
                            if pGenJnlLine."External document No." <> '' then
                                lcVendorinvoiceNo := pGenJnlLine."External document No."
                            else
                                lcVendorinvoiceNo := pGenJnlLine."document No.";
                        end;
                        Clear(lcAdditionalReference);
                        lclCampos2 += PadStr('', 15 - StrLen(Format(DelChr(lcVendorinvoiceNo, '=', DelChr(lcVendorinvoiceNo, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')))), '0') + lcVendorinvoiceNo;//RRR
                        lcVendorinvoiceNo := pGenJnlLine."External document No.";
                        lcVendorinvoiceNo := DelChr(lcVendorinvoiceNo, '=', '-');
                        //        if StrLen(lcVendorinvoiceNo)>10 then
                        //           lcVendorinvoiceNo:=CopyStr(lcVendorinvoiceNo,StrLen(lcVendorinvoiceNo)-10,StrLen(lcVendorinvoiceNo));
                        //        lclCampos := lclCampos + PadStr(DelChr(lcVendorinvoiceNo,'=','-'),10,'0');
                        //           lcVendorinvoiceNo:=CopyStr(lcVendorinvoiceNo,StrLen(lcVendorinvoiceNo)-10,StrLen(lcVendorinvoiceNo));
                        if StrLen(lcVendorinvoiceNo) > 10 then
                            lclCampos += CopyStr(lcVendorinvoiceNo, StrLen(lcVendorinvoiceNo) - 10, 10)
                        else
                            lclCampos += PadStr('', StrLen(lcVendorinvoiceNo) - 10, '0') + lcVendorinvoiceNo;//lcVendorinvoiceNo + PadStr('',10,'0');
                        if lcMultiple then
                            lclCampos += '2'
                        else
                            lclCampos += '1';

                        lclVendorLedgerEntry.Reset();
                        lclVendorLedgerEntry.SetRange("Entry No.", pGenJnlLine."Applies-to Entry No.");
                        if lclVendorLedgerEntry.FindSet() then;
                        lcAdditionalReference := DelChr(lclVendorLedgerEntry."External document No.", '=', 'Ñ/&%$#"!°|,._');
                        if StrLen(lcAdditionalReference) <= 40 then
                            lclCampos += lcAdditionalReference + PadStr('', 40 - StrLen(lcAdditionalReference), ' ')//PadStr('',40,' ');
                        else
                            lclCampos += CopyStr(lcAdditionalReference, 1, 40);
                        lclCampos += '001';
                    end else begin
                        lclCampos := ' 2';

                        if lclVendorBankAccount."Bank Account Type" <> lclVendorBankAccount."Bank Account Type"::"Interbank Account" then begin
                            if StrLen(DelChr(lclVendorBankAccount."Bank Account No.", '=', '-')) < 14 then begin
                                gNewAcc := CopyStr(lclVendorBankAccount."Bank Account No.", 1, 3) + '0' + CopyStr(lclVendorBankAccount."Bank Account No.", 4, StrLen(lclVendorBankAccount."Bank Account No.") - 3);
                                lcBankAccountNo := gNewAcc;
                                //lclCampos := lclCampos+PadStr(DelChr(gNewAcc,'=','-'),20,' ');
                            end else
                                lcBankAccountNo := lclVendorBankAccount."Bank Account No.";
                        end;
                        //else 
                        // lclCampos := lclCampos+PadStr(DelChr(lclVendorBankAccount."Bank Account No.",'=','-'),20,' ');

                        case lclVendorBankAccount."Bank Account Type" of
                            lclVendorBankAccount."Bank Account Type"::"Current Account":
                                begin
                                    lclCampos := lclCampos + 'C';
                                    lclCampos := lclCampos + PadStr(DelChr(lcBankAccountNo, '=', '-'), 20, ' ');
                                end;
                            lclVendorBankAccount."Bank Account Type"::"Master Account":
                                begin
                                    lclCampos := lclCampos + 'M';
                                    lclCampos := lclCampos + PadStr(DelChr(lcBankAccountNo, '=', '-'), 20, ' ');
                                end;
                            lclVendorBankAccount."Bank Account Type"::"Savings Account":
                                begin
                                    lclCampos := lclCampos + 'A';
                                    lclCampos := lclCampos + PadStr(DelChr(lcBankAccountNo, '=', '-'), 20, ' ');
                                end;
                            lclVendorBankAccount."Bank Account Type"::"Interbank Account":
                                begin
                                    lclCampos := lclCampos + 'B';
                                    lclCampos += fnGetTextAdjust(lclVendorBankAccount."Bank Account CCI", 20, '<', ' ');
                                end;
                        end;


                        if lclVendor.Get(pGenJnlLine."Account No.") then begin
                            lcNameVendor := CONVERTSTR(lclVendor.Name, 'áéíóúñÁÉÍÓÚÑ', 'aeiounAEIOUN');
                            lcNameVendor := DelChr(lcNameVendor, '=', DelChr(lcNameVendor, '=', TextPermissionCharacters));
                            lclCampos := lclCampos + fnGetTextAdjust(lcNameVendor, 40, '<', ' ');
                            //lclCampos := lclCampos + CONVERTSTR(CopyStr(DelChr(lclVendor.Name,'=',',&-'),1,40),'ñÑ','nN') + PadStr('',40-StrLen(CopyStr(DelChr(lclVendor.Name,'=',',&-'),1,40)),' ');
                            if lclVendorBankAccount."Currency Code" = '' then
                                lclCampos := lclCampos + 'S/'
                            else
                                lclCampos := lclCampos + 'US';
                            case true of
                                (pGenJnlLine.Amount < 0) and (pGenJnlLine."Currency Code" <> ''):
                                    lcAmount := pGenJnlLine.Amount + ABS(ROUND(pGenJnlLine."Retention Amount", 0.01, '>') * pGenJnlLine."Currency Factor");
                                (pGenJnlLine.Amount < 0) and (pGenJnlLine."Currency Code" = ''):
                                    lcAmount := pGenJnlLine.Amount + ABS(ROUND(pGenJnlLine."Retention Amount", 0.01, '>'));
                                (pGenJnlLine.Amount > 0) and (pGenJnlLine."Currency Code" <> ''):
                                    lcAmount := pGenJnlLine.Amount - ABS(ROUND(pGenJnlLine."Retention Amount", 0.01, '>') * pGenJnlLine."Currency Factor");
                                (pGenJnlLine.Amount > 0) and (pGenJnlLine."Currency Code" = ''):
                                    lcAmount := pGenJnlLine.Amount - ABS(ROUND(pGenJnlLine."Retention Amount", 0.01, '>'));
                            end;
                            //           lcAmountText := fnGetFormatAmt(false,lcAmount); //begin LIZETH Error DECIMAL
                            lcAmountText := DelChr(Format(lcAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                            //lclCampos += fnGetTextAdjust(lcAmountText,15,'>','0');
                            lclCampos += fnGetTextAdjust(fnGetFormatAmt(false, lcAmount), 15, '>', '0');
                            //           lclCampos := lclCampos + PadStr('', 15 - StrLen(lcAmountText),'0') + lcAmountText;
                            //           lclCampos := lclCampos + PadStr('', 15 - StrLen(gCuPeruvianBooks."#GetFormatAmt"(false,ABS(pGenJnlLine.Amount))),'0') + gCuPeruvianBooks."#GetFormatAmt"(false,ABS(pGenJnlLine.Amount));
                            if pHBS then begin
                                lclCampos := lclCampos + PadStr('', 40, ' ') + '1';
                            end;
                            case lclVendor."VAT Registration Type" of
                                '1':
                                    lclCampos := lclCampos + 'DNI';
                                '3':
                                    lclCampos := lclCampos + 'CE';
                                '4':
                                    lclCampos := lclCampos + 'PAS';
                                '6':
                                    lclCampos := lclCampos + 'RUC';
                            end;
                            lclCampos := lclCampos + lclVendor."VAT Registration No." + PadStr('', 12 - StrLen(lclVendor."VAT Registration No."), ' ');
                            if Not pHBS then begin
                                //              pGenJnlLine.TestField("Applies-to doc. Type");
                                if pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::invoice then begin
                                    lcVendorinvoiceNo := '';
                                    lclCampos := lclCampos + 'F';
                                    lclCampos2 += 'F';
                                    lcRecPurchinvHeader.Reset();
                                    lcRecPurchinvHeader.SetRange("No.", pGenJnlLine."Applies-to doc. No.");
                                    if lcRecPurchinvHeader.FindSet() then
                                        lcVendorinvoiceNo := lcRecPurchinvHeader."Vendor invoice No."
                                    else begin
                                        lclVendorLedgerEntry.Reset();
                                        lclVendorLedgerEntry.SetRange(lclVendorLedgerEntry."document No.", pGenJnlLine."Applies-to doc. No.");
                                        if lclVendorLedgerEntry.FindSet() then
                                            lcVendorinvoiceNo := lclVendorLedgerEntry."document No.";
                                    end;
                                end;
                                if pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::"Credit Memo" then begin
                                    lcVendorinvoiceNo := '';
                                    lclCampos := lclCampos + 'N';
                                    lclCampos2 += 'N';
                                    lcRecPurchCrMemoHdr.Reset();
                                    lcRecPurchCrMemoHdr.SetRange("No.", pGenJnlLine."Applies-to doc. No.");
                                    if lcRecPurchCrMemoHdr.FindSet() then
                                        lcVendorinvoiceNo := lcRecPurchCrMemoHdr."Vendor Cr. Memo No."
                                    else begin
                                        lclVendorLedgerEntry.Reset();
                                        lclVendorLedgerEntry.SetRange(lclVendorLedgerEntry."document No.", pGenJnlLine."Applies-to doc. No.");
                                        if lclVendorLedgerEntry.FindSet() then
                                            lcVendorinvoiceNo := lclVendorLedgerEntry."document No.";
                                    end;
                                end;
                                if pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::Payment then begin
                                    lclCampos := lclCampos + 'D';
                                    lclCampos2 += 'D';
                                end;
                                if (pGenJnlLine."Applies-to Entry No." = 0) or (pGenJnlLine."Applies-to doc. Type" = pGenJnlLine."Applies-to doc. Type"::" ") then begin
                                    lcVendorinvoiceNo := '';
                                    lclCampos := lclCampos + 'F';
                                    lclCampos2 += 'F';
                                    if pGenJnlLine."External document No." <> '' then
                                        lcVendorinvoiceNo := pGenJnlLine."External document No."
                                    else
                                        lcVendorinvoiceNo := pGenJnlLine."document No.";
                                end;
                                lcVendorinvoiceNo := DelChr(pGenJnlLine."External document No.", '=', '-');
                                if StrLen(lcVendorinvoiceNo) > 10 then begin
                                    //lcSerieVendorinvoiceNo := CopyStr(lcVendorinvoiceNo,2,STRPOS(lcVendorinvoiceNo,'-')-2);
                                    //lcNumberVendorinvoiceNo := CopyStr(lcVendorinvoiceNo,StrLen(lcVendorinvoiceNo)-6,StrLen(lcVendorinvoiceNo));
                                    //lcVendorinvoiceNo := lcSerieVendorinvoiceNo + lcNumberVendorinvoiceNo 
                                    lclCampos += CopyStr(lcVendorinvoiceNo, StrLen(lcVendorinvoiceNo) - 9, 10);
                                end else
                                    lclCampos += lcVendorinvoiceNo + PadStr('', 10 - StrLen(lcVendorinvoiceNo), '0');
                                //lclCampos := lclCampos + PadStr(DelChr(lcVendorinvoiceNo,'=','-'),10,'0');

                                if lcMultiple then
                                    lclCampos += '2'
                                else
                                    lclCampos += '1';

                                lclVendorLedgerEntry.Reset();
                                lclVendorLedgerEntry.SetRange("Entry No.", pGenJnlLine."Applies-to Entry No.");
                                if lclVendorLedgerEntry.FindSet() then;
                                lcAdditionalReference := DelChr(lclVendorLedgerEntry."External document No.", '=', 'Ñ-/&%$#"!°|,._');
                                if StrLen(lcAdditionalReference) <= 40 then
                                    lclCampos += lcAdditionalReference + PadStr('', 40 - StrLen(lcAdditionalReference), ' ')
                                else
                                    lclCampos += CopyStr(lcAdditionalReference, 1, 40);
                                lclCampos += '001';
                                lclCampos2 += PadStr('', 15 - StrLen(Format(DelChr(lcVendorinvoiceNo, '=', DelChr(lcVendorinvoiceNo, '=', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789')))), '0') + lcVendorinvoiceNo;//RRR
                            end;
                            if pHBS then
                                lclCampos := lclCampos + '0';

                            lclCampos2 += PadStr('', 17 - StrLen(DelChr(Format(pGenJnlLine.Amount), '=', ',')), '0') + DelChr(Format(pGenJnlLine.Amount), '=', ',');
                        end;
                    end;
                end;
                lclCampos := DelChr(lclCampos, '=', DelChr(lclCampos, '=', TextPermissionCharacters));

                //ULN::PC 001  2020.06.01 v.001 begin 
                insertLineToTempFile(lclCampos);
            //ULN::PC 001  2020.06.01 v.001 end               
            until pGenJnlLine.NEXT = 0;

        if pHBS then
            lcFileName := ' HABERES';
        if pCTS then
            lcFileName := ' CTS';
        if (Not pHBS) and (Not pCTS) then
            lcFileName := ' PROVEEDORES';

        PostFileToControlFileRecord(pGenJnlLine."document No.", STRSUBSTNO(TeleCreditdocumentLabel, 'BCP' + pGenJnlLine."document No.", lcFileName), 'BCP');
        lclWindow.CLOSE;
        //003
    end;

    procedure fnGenerateVendorTelecreditBCPV2(pGenJnlLine: Record "Gen. Journal Line"; pHBS: Boolean; pCTS: Boolean)
    var
        lclGenJnlLineBank: Record "Gen. Journal Line";
        lclGenJnlLineVendors: Record "Gen. Journal Line";
        lclGenJnlLineEmployees: Record "Gen. Journal Line";
        lclGenJnlLineREVIEW: Record "Gen. Journal Line";
        lclWindow: Dialog;
        lclCampos: Text;
        lclCountVendorLines: Integer;
        lclCountEmployeeLines: Integer;
        lcBankAccount: Record "Bank Account";
        lcVendorBankAccount: Record "Vendor Bank Account";
        lcVendor: Record Vendor;
        lcActualVendorNo: Text;
        lcEmployeeBankAccount: Record "ST Employee Bank Account";
        lcEmployee: Record Employee;
    begin
        lclWindow.Open(Processing);

        CreateTempFile();
        //Validacion 1
        lclGenJnlLineREVIEW.Reset();
        lclGenJnlLineREVIEW.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJnlLineREVIEW.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJnlLineREVIEW.SETFILTER("Currency Code", '<>%1&<>%2', ' ', 'USD');
        IF lclGenJnlLineREVIEW.FinDSET then
            Error(StrSubstNo('proceso no disponible , para moneda %1'), lclGenJnlLineREVIEW."Currency Code");

        //Info Banco
        lclGenJnlLineBank.Reset();
        lclGenJnlLineBank.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJnlLineBank.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJnlLineBank.SETFILTER("Account Type", '%1', pGenJnlLine."Account Type"::"Bank Account");
        lclGenJnlLineBank.FinDSET;

        lcBankAccount.Get(lclGenJnlLineBank."Account No.");

        //Info Proveedores
        lclGenJnlLineVendors.SetCurrentKey("Account No.");
        lclGenJnlLineVendors.SETASCendinG("Account No.", true);
        lclGenJnlLineVendors.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJnlLineVendors.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJnlLineVendors.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
        lclCountVendorLines := lclGenJnlLineVendors.Count;
        if lclGenJnlLineVendors.FindSet() then begin
            //1:Line Bank
            //CAMPO 1 : Tipo de registro
            lclCampos := '1';
            //CAMPO 2 : Cantidad de abonos de la planilla
            lclCampos += fnGetTextAdjust(format(lclCountVendorLines), 6, '>', '0');
            //CAMPO 3:Fecha de proceso
            lclCampos += Format(lclGenJnlLineBank."Posting Date", 0, '<Year4><Month,2><Day,2>');
            //CAMPO 4:Tipo de la cuenta de cargo
            case lcBankAccount."Bank Account Type" of
                lcBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
            end;
            //CAMPO 5:Moneda de la cuenta de cargo
            case lclGenJnlLineBank."Currency Code" of
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            end;
            //CAMPO 6:Número de la cuenta de cargo
            lclCampos += fnGetTextAdjust(lcBankAccount."Bank Account No.", 20, '<', ' ');
            //CAMPO 7:Monto total de la planilla
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, ABS(lclGenJnlLineBank.Amount)), 17, '>', '0');
            //CAMPO 8:Referencia de la planilla
            if strlen(lclGenJnlLineBank."Check Name") > 40 then
                lclGenJnlLineBank."Check Name" := CopyStr(lclGenJnlLineBank.Description, 1, 40)
            else
                lclGenJnlLineBank."Check Name" := lclGenJnlLineBank.Description;
            lclCampos += fnGetTextAdjust(lclGenJnlLineBank.Description, 40, '<', ' ');
            //CAMPO 9:Flag de exoneración ITF
            lclCampos += 'N';
            //CAMPO 10:Total de control (checksum)
            lclCampos += fnGetTextAdjust(fnCalculateControlTotalCheckSum(pGenJnlLine, lcBankAccount), 15, '>', '0');
            insertLineToTempFile(lclCampos);
            //Clear lclCampos
            Clear(lclCampos);
            repeat

                lcVendor.get(lclGenJnlLineVendors."Account No.");
                lcVendorBankAccount.Get(lcVendor."No.", lclGenJnlLineVendors."Recipient Bank Account");
                fnCheckVendorBankAccount(lcVendorBankAccount);

                // if lcActualVendorNo <> lclGenJnlLineVendors."Account No." then begin
                //2:Lines Detalle Proveedores
                lclCampos := fngetLineVendor(lclGenJnlLineVendors, lcVendor);
                insertLineToTempFile(lclCampos);
                // end;

                //3:Lines Detalle por proveedor
                Clear(lclCampos);
                lclCampos := fngetLineVendorDetails(lclGenJnlLineVendors, lcVendor);
                insertLineToTempFile(lclCampos);

            //  lcActualVendorNo := lclGenJnlLineVendors."Account No.";
            until lclGenJnlLineVendors.Next() = 0;
        end;
        //Info Employees

        lclGenJnlLineEmployees.SetCurrentKey("Account No.");
        lclGenJnlLineEmployees.SETASCendinG("Account No.", true);
        lclGenJnlLineEmployees.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJnlLineEmployees.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJnlLineEmployees.SetRange("Account Type", pGenJnlLine."Account Type"::Employee);
        lclCountEmployeeLines := lclGenJnlLineEmployees.Count;
        if lclGenJnlLineEmployees.FindSet() then begin
            //1:Line Bank
            //CAMPO 1 : Tipo de registro
            lclCampos := '1';
            //CAMPO 2 : Cantidad de abonos de la planilla
            lclCampos += fnGetTextAdjust(format(lclCountEmployeeLines), 6, '>', '0');
            //CAMPO 3:Fecha de proceso
            lclCampos += Format(lclGenJnlLineBank."Posting Date", 0, '<Year4><Month,2><Day,2>');
            //CAMPO 4:Tipo de la cuenta de cargo
            case lcBankAccount."Bank Account Type" of
                lcBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
            end;
            //CAMPO 5:Moneda de la cuenta de cargo
            case lclGenJnlLineBank."Currency Code" of
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            end;
            //CAMPO 6:Número de la cuenta de cargo
            lclCampos += fnGetTextAdjust(lcBankAccount."Bank Account No.", 20, '<', ' ');
            //CAMPO 7:Monto total de la planilla
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, ABS(lclGenJnlLineBank.Amount)), 17, '>', '0');
            //CAMPO 8:Referencia de la planilla
            if strlen(lclGenJnlLineBank."Check Name") > 40 then
                lclGenJnlLineBank."Check Name" := CopyStr(lclGenJnlLineBank.Description, 1, 40)
            else
                lclGenJnlLineBank."Check Name" := lclGenJnlLineBank.Description;
            lclCampos += fnGetTextAdjust(lclGenJnlLineBank.Description, 40, '<', ' ');
            //CAMPO 9:Flag de exoneración ITF
            lclCampos += 'N';
            //CAMPO 10:Total de control (checksum)
            lclCampos += fnGetTextAdjust(fnCalculateControlTotalCheckSum(pGenJnlLine, lcBankAccount), 15, '>', '0');
            insertLineToTempFile(lclCampos);
            //Clear lclCampos
            Clear(lclCampos);
            repeat
                lcEmployee.get(lclGenJnlLineEmployees."Account No.");
                lcEmployeeBankAccount.Get(lcEmployee."No.", lclGenJnlLineEmployees."Recipient Bank Account");
                //RPA fnCheckEmployeeBankAccount(lcEmployeeBankAccount);

                // if lcActualVendorNo <> lclGenJnlLineVendors."Account No." then begin
                //2:Lines Detalle Proveedores
                lclCampos := fngetLineEmployee(lclGenJnlLineEmployees, lcEmployee);
                insertLineToTempFile(lclCampos);
                // end;

                //3:Lines Detalle por proveedor
                Clear(lclCampos);
                lclCampos := fngetLineEmployeeDetails(lclGenJnlLineEmployees, lcEmployee);
                insertLineToTempFile(lclCampos);

            until lclGenJnlLineEmployees.Next() = 0;
        end;

        PostFileToControlFileRecord(pGenJnlLine."document No.", STRSUBSTNO(TeleCreditdocumentLabel, 'BCP' + pGenJnlLine."document No.", ' PROVEEDORES'), 'BCP');
        lclWindow.CLOSE;
    end;

    procedure fngetLineVendor(pGenJnlLine: Record "Gen. Journal Line"; pVendor: Record Vendor): Text
    var
        lcVendorBankAccount: Record "Vendor Bank Account";
        lclCampos: Text;
        lclLegalDocument: Record "Legal Document";
    begin
        if NOT lcVendorBankAccount.Get(pVendor."No.", pGenJnlLine."Recipient Bank Account") then begin
            Error('Cuenta Banco Proveedor %1 no existe', pGenJnlLine."Account No.");
        end;
        //CAMPO 1:Tipo de registro
        lclCampos := '2';
        lcVendorBankAccount.Reset();
        lcVendorBankAccount.SetRange("Vendor No.", pVendor."No.");
        lcVendorBankAccount.SetRange(Code, pGenJnlLine."Recipient Bank Account");
        lcVendorBankAccount.SetRange(Fiduciary, true);
        if lcVendorBankAccount.FindSet() then begin
            //CAMPO 2: Tipo de la cuenta de abono  
            case lcVendorBankAccount."Bank Account Type" of
                lcVendorBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcVendorBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
                lcVendorBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += 'B';
                lcVendorBankAccount."Bank Account Type"::"Savings Account":
                    lclCampos += 'A';
                lcVendorBankAccount."Bank Account Type"::" ":
                    lclCampos += ' ';

            end;
            //CAMPO 3: Número de la cuenta de abono  
            case lcVendorBankAccount."Bank Account Type" of
                lcVendorBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Bank Account CCI", 20, '<', ' ');
                else
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Bank Account No.", 20, '<', ' ');
            end;
            //CAMPO 4: Modalidad de pago
            case lcVendorBankAccount."Check Manager" of
                true:
                    lclCampos += '2';
                false:
                    lclCampos += '1';
            END;
            //CAMPO 5:Tipo de documento del proveedor

            case lcVendorBankAccount."Type Fiduciary" of
                lcVendorBankAccount."Type Fiduciary"::"Bank Fiduciary":
                    lclCampos += '7';
                lcVendorBankAccount."Type Fiduciary"::"Vendor Fiduciary":
                    begin
                        lclLegalDocument.Reset();
                        lclLegalDocument.SetRange("Type Code", '02');
                        lclLegalDocument.SetRange("Legal No.", pVendor."VAT Registration Type");
                        if lclLegalDocument.FindSet() then
                            lclCampos += lclLegalDocument."Type Fiduciary";
                    end;
            END;
            //CAMPO 6:Número de documento del proveedor
            case lcVendorBankAccount."Type Fiduciary" of
                lcVendorBankAccount."Type Fiduciary"::"Bank Fiduciary":
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Transit No.", 12, '<', ' ');
                lcVendorBankAccount."Type Fiduciary"::"Vendor Fiduciary":
                    lclCampos += fnGetTextAdjust(pVendor."VAT Registration No.", 12, '<', ' ');
            END;
            //CAMPO 7:Correlativo de documento del proveedor
            lclCampos += '   ';
            //CAMPO 8:Nombre del proveedor
            IF StrLen(lcVendorBankAccount.Name) >= 75 then
                lcVendorBankAccount.Name := CONVERTSTR(CopyStr(lcVendorBankAccount.Name, 1, 75), 'Ññ', 'Nn');

            lclCampos += fnGetTextAdjust(CONVERTSTR(lcVendorBankAccount.Name, 'Ññ', 'Nn'), 75, '<', ' ');
            //campo 9 :Referencia para el beneficiario
            lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 40, '<', ' ');
            //campo 10 :Referencia para la empresa
            if pGenJnlLine."Applies-to Doc. No." = '' then
                lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 20, '<', ' ')
            else
                lclCampos += fnGetTextAdjust(pGenJnlLine."Applies-to Doc. No.", 20, '<', ' ');
            //ULN::RRR 04/11/2020 
            /*case lcVendorBankAccount."Type Fiduciary" of
                lcVendorBankAccount."Type Fiduciary"::"Bank Fiduciary":
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Transit No.", 20, '<', ' ');
                lcVendorBankAccount."Type Fiduciary"::"Vendor Fiduciary":
                    lclCampos += fnGetTextAdjust(pVendor."VAT Registration No.", 20, '<', ' ');
            END;*/

            //campo 11 :Moneda del importe a abonar
            CASE pGenJnlLine."Currency Code" OF
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            END;
            //campo 12 :Importe a abonar
            if pGenJnlLine."Applied Retention" then
                lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, (pGenJnlLine.Amount + pGenJnlLine."Retention Amount")), 17, '>', '0')
            else
                lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
            //campo 13 :Flag validar IDC
            lclCampos += 'S';
            exit(lclCampos);
        end
        ELSE begin
            lcVendorBankAccount.Reset();
            lcVendorBankAccount.Get(pVendor."No.", pGenJnlLine."Recipient Bank Account");
            //CAMPO 2: Tipo de la cuenta de abono  
            case lcVendorBankAccount."Bank Account Type" of
                lcVendorBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcVendorBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
                lcVendorBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += 'B';
                lcVendorBankAccount."Bank Account Type"::"Savings Account":
                    lclCampos += 'A';
                lcVendorBankAccount."Bank Account Type"::" ":
                    lclCampos += ' ';

            end;
            //CAMPO 3: Número de la cuenta de abono  
            case lcVendorBankAccount."Bank Account Type" of
                lcVendorBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Bank Account CCI", 20, '<', ' ');
                else
                    lclCampos += fnGetTextAdjust(lcVendorBankAccount."Bank Account No.", 20, '<', ' ');
            end;

            //CAMPO 4: Modalidad de pago
            case lcVendorBankAccount."Check Manager" of
                true:
                    lclCampos += '2';
                false:
                    lclCampos += '1';
            END;
            //CAMPO 5:Tipo de documento del proveedor
            lclLegalDocument.Reset();
            lclLegalDocument.SetRange("Type Code", '02');
            lclLegalDocument.SetRange("Legal No.", pVendor."VAT Registration Type");
            if lclLegalDocument.FindSet() then
                lclCampos += lclLegalDocument."Type Fiduciary";
            //CAMPO 6:Número de documento del proveedor
            lclCampos += fnGetTextAdjust(pVendor."VAT Registration No.", 12, '<', ' ');
            //CAMPO 7:Correlativo de documento del proveedor
            lclCampos += '   ';
            //CAMPO 8:Nombre del proveedor
            IF StrLen(pVendor.Name) >= 75 then
                pVendor.Name := ConvertStr(CopyStr(pVendor.Name, 1, 75), 'Ññ', 'Nn');

            lclCampos += fnGetTextAdjust(ConvertStr(pVendor.Name, 'Ññ', 'Nn'), 75, '<', ' ');
            //campo 9 :Referencia para el beneficiario
            lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 40, '<', ' ');
            //campo 10 :Referencia para la empresa
            if pGenJnlLine."Applies-to Doc. No." = '' then
                lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 20, '<', ' ')
            else
                lclCampos += fnGetTextAdjust(pGenJnlLine."Applies-to Doc. No.", 20, '<', ' '); //pVendor."VAT Registration No.", 20, '<', ' ');
            //campo 11 :Moneda del importe a abonar
            CASE pGenJnlLine."Currency Code" OF
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            END;
            //campo 12 :Importe a abonar
            if pGenJnlLine."Applied Retention" then
                lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, (pGenJnlLine.Amount + pGenJnlLine."Retention Amount")), 17, '>', '0')
            else
                lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
            //campo 13 :Flag validar IDC
            lclCampos += 'S';
            exit(lclCampos);
        end;
    end;

    procedure fngetLineEmployee(pGenJnlLine: Record "Gen. Journal Line"; pEmployee: Record Employee): Text
    var
        lcEmployeeBankAccount: Record "ST Employee Bank Account";
        lclCampos: Text;
        lclLegalDocument: Record "Legal Document";
        lclEmployeeName: text;
    begin
        if NOT lcEmployeeBankAccount.Get(pEmployee."No.", pGenJnlLine."Recipient Bank Account") then begin
            Error('Cuenta Banco Proveedor %1 no existe', pGenJnlLine."Account No.");
        end;
        //CAMPO 1:Tipo de registro
        lclCampos := '2';
        lcEmployeeBankAccount.Reset();
        lcEmployeeBankAccount.SetRange("Employee No.", pEmployee."No.");
        lcEmployeeBankAccount.SetRange(Code, pGenJnlLine."Recipient Bank Account");
        //rpA-lcEmployeeBankAccount.SetRange(Fiduciary, true);
        if lcEmployeeBankAccount.FindSet() then begin
            //CAMPO 2: Tipo de la cuenta de abono  
            case lcEmployeeBankAccount."Bank Account Type" of
                lcEmployeeBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcEmployeeBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
                lcEmployeeBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += 'B';
                lcEmployeeBankAccount."Bank Account Type"::"Savings Account":
                    lclCampos += 'A';
                lcEmployeeBankAccount."Bank Account Type"::" ":
                    lclCampos += ' ';

            end;
            //CAMPO 3: Número de la cuenta de abono  
            case lcEmployeeBankAccount."Bank Account Type" of
                lcEmployeeBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += fnGetTextAdjust(lcEmployeeBankAccount."Bank Account CCI", 20, '<', ' ');
                else
                    lclCampos += fnGetTextAdjust(lcEmployeeBankAccount."Bank Account No.", 20, '<', ' ');
            end;
            //CAMPO 4: Modalidad de pago
            case lcEmployeeBankAccount."Check Manager" of
                true:
                    lclCampos += '2';
                false:
                    lclCampos += '1';
            END;
            //CAMPO 5:Tipo de documento del proveedor


            lclLegalDocument.Reset();
            lclLegalDocument.SetRange("Type Code", '02');
            lclLegalDocument.SetRange("Legal No.", pEmployee."VAT Registration Type");
            if lclLegalDocument.FindSet() then
                lclCampos += lclLegalDocument."Type Fiduciary";

            //CAMPO 6:Número de documento del proveedor
            lclCampos += fnGetTextAdjust(pEmployee."VAT Registration No.", 12, '<', ' ');


            //CAMPO 7:Correlativo de documento del proveedor
            lclCampos += '   ';
            //CAMPO 8:Nombre del proveedor
            lclEmployeeName := pEmployee.FullName();
            IF StrLen(lclEmployeeName) >= 75 then
                lclEmployeeName := CopyStr(lclEmployeeName, 1, 75);

            lclCampos += fnGetTextAdjust(lclEmployeeName, 75, '<', ' ');

            //campo 9 :Referencia para el beneficiario
            lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 40, '<', ' ');

            //campo 10 :Referencia para la empresa
            if pGenJnlLine."Applies-to Doc. No." = '' then
                lclCampos += fnGetTextAdjust(pEmployee."VAT Registration No.", 20, '<', ' ');
            if pGenJnlLine."Applies-to Doc. No." <> '' then
                lclCampos += fnGetTextAdjust(pGenJnlLine."Applies-to Doc. No.", 20, '<', ' ');

            //campo 11 :Moneda del importe a abonar
            CASE pGenJnlLine."Currency Code" OF
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            END;
            //campo 12 :Importe a abonar
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
            //campo 13 :Flag validar IDC
            lclCampos += 'S';
            exit(lclCampos);
        end
        ELSE begin
            lcEmployeeBankAccount.Reset();
            lcEmployeeBankAccount.Get(pEmployee."No.", pGenJnlLine."Recipient Bank Account");
            //CAMPO 2: Tipo de la cuenta de abono  
            case lcEmployeeBankAccount."Bank Account Type" of
                lcEmployeeBankAccount."Bank Account Type"::"Current Account":
                    lclCampos += 'C';
                lcEmployeeBankAccount."Bank Account Type"::"Master Account":
                    lclCampos += 'M';
                lcEmployeeBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += 'B';
                lcEmployeeBankAccount."Bank Account Type"::"Savings Account":
                    lclCampos += 'A';
                lcEmployeeBankAccount."Bank Account Type"::" ":
                    lclCampos += ' ';

            end;
            //CAMPO 3: Número de la cuenta de abono  
            case lcEmployeeBankAccount."Bank Account Type" of
                lcEmployeeBankAccount."Bank Account Type"::"Interbank Account":
                    lclCampos += fnGetTextAdjust(lcEmployeeBankAccount."Bank Account CCI", 20, '<', ' ');
                else
                    lclCampos += fnGetTextAdjust(lcEmployeeBankAccount."Bank Account No.", 20, '<', ' ');
            end;

            //CAMPO 4: Modalidad de pago
            case lcEmployeeBankAccount."Check Manager" of
                true:
                    lclCampos += '2';
                false:
                    lclCampos += '1';
            END;
            //CAMPO 5:Tipo de documento del proveedor
            lclLegalDocument.Reset();
            lclLegalDocument.SetRange("Type Code", '02');
            lclLegalDocument.SetRange("Legal No.", pEmployee."VAT Registration Type");
            if lclLegalDocument.FindSet() then
                lclCampos += lclLegalDocument."Type Fiduciary";
            //CAMPO 6:Número de documento del proveedor
            lclCampos += fnGetTextAdjust(pEmployee."VAT Registration No.", 12, '<', ' ');
            //CAMPO 7:Correlativo de documento del proveedor
            lclCampos += '   ';
            //CAMPO 8:Nombre del proveedor
            IF StrLen(pEmployee."Search Name") >= 75 then
                pEmployee."Search Name" := CopyStr(pEmployee."Search Name", 1, 75);

            lclCampos += fnGetTextAdjust(pEmployee."Search Name", 75, '<', ' ');
            //campo 9 :Referencia para el beneficiario
            lclCampos += fnGetTextAdjust(pGenJnlLine."Message to Recipient", 40, '<', ' ');
            //campo 10 :Referencia para la empresa
            lclCampos += fnGetTextAdjust(pEmployee."VAT Registration No.", 20, '<', ' ');
            //campo 11 :Moneda del importe a abonar
            CASE pGenJnlLine."Currency Code" OF
                '':
                    lclCampos += '0001';
                'USD':
                    lclCampos += '1001';
            END;
            //campo 12 :Importe a abonar
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
            //campo 13 :Flag validar IDC
            lclCampos += 'S';
            exit(lclCampos);
        end;
    end;

    procedure fngetLineVendorDetails(pGenJnlLine: Record "Gen. Journal Line"; pVendor: Record Vendor): Text
    var
        lclCampos: Text;
        lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        //CAMPO 1:Tipo de registro
        lclCampos := '3';
        //CAMPO 2:Tipo de documento a pagar
        if pGenJnlLine."Applies-to Entry No." <> 0 then begin
            lclRecVendorLedgerEntry.get(pGenJnlLine."Applies-to Entry No.");
            case lclRecVendorLedgerEntry."Legal Document" of
                '01', '91':
                    lclCampos += 'F';
                '07', '97':
                    lclCampos += 'N';
                '08', '98':
                    lclCampos += 'C';
                else
                    lclCampos += 'D';
            end;
        end
        else
            lclCampos += 'D';


        //CAMPO 3:Número de documento a pagar
        pGenJnlLine.TestField("External Document No.");
        lclCampos += fnGetTextAdjust(DelChr(pGenJnlLine."External Document No.", '=', '-'), 15, '>', '0');
        //campo 4:Importe a abonar
        if pGenJnlLine."Applied Retention" then
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, (pGenJnlLine.Amount + pGenJnlLine."Retention Amount")), 17, '>', '0')
        else
            lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
        exit(lclCampos);

    end;

    procedure fngetLineEmployeeDetails(pGenJnlLine: Record "Gen. Journal Line"; pEmployee: Record Employee): Text
    var
        lclCampos: Text;
        lclEmployeeLedgerEntry: Record "Employee Ledger Entry";
    begin
        //CAMPO 1:Tipo de registro
        lclCampos := '3';
        //CAMPO 2:Tipo de documento a pagar
        lclCampos += 'D';


        //CAMPO 3:Número de documento a pagar
        pGenJnlLine.TestField("External Document No.");
        lclCampos += fnGetTextAdjust(DelChr(pGenJnlLine."External Document No.", '=', '-'), 15, '>', '0');
        //campo 4:Importe a abonar
        lclCampos += fnGetTextAdjust(fnGetFormatAmt(true, pGenJnlLine.Amount), 17, '>', '0');
        exit(lclCampos);

    end;

    procedure fnCalculateControlTotalCheckSum(pGenJnlLine: Record "Gen. Journal Line"; pBankAccount: Record "Bank Account"): Text;
    var
        lclGenJnlLineVendors: Record "Gen. Journal Line";
        lclCountVendorLines: Integer;
        lcBankAccount: Record "Bank Account";
        lcVendorBankAccount: Record "Vendor Bank Account";
        lcVendor: Record Vendor;
        lclCheckSumVendor: Decimal;
        lclCheckSumBank: Decimal;
        lclTotalCheckSumVendor: Decimal;
        lcBankAccountNo: Code[20];
        lclTextFormatCuenta: Text;
    begin
        lclGenJnlLineVendors.Reset();
        lclGenJnlLineVendors.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Account No.");
        lclGenJnlLineVendors.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclGenJnlLineVendors.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclGenJnlLineVendors.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
        if lclGenJnlLineVendors.FindSet() then
            repeat
                lcVendor.Get(lclGenJnlLineVendors."Account No.");
                if lclGenJnlLineVendors."Currency Code" <> '' then
                    lcVendor.TestField("Preferred Bank Account Code ME")
                else
                    lcVendor.TestField("Preferred Bank Account Code");
                lcVendorBankAccount.Get(lcVendor."No.", lclGenJnlLineVendors."Recipient Bank Account");
                fnCheckVendorBankAccount(lcVendorBankAccount);
                if (lcVendorBankAccount."Bank Account No." <> '') or (lcVendorBankAccount."Bank Account CCI" <> '') then begin
                    lclCheckSumVendor := 0;

                    case lcVendorBankAccount."Bank Account Type" OF
                        lcVendorBankAccount."Bank Account Type"::"Current Account":
                            begin
                                if strlen(lcVendorBankAccount."Bank Account No.") < 13 then
                                    Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");
                                lcBankAccountNo := CopyStr(lcVendorBankAccount."Bank Account No.", 4, 11);
                            end;

                        lcVendorBankAccount."Bank Account Type"::"Master Account":
                            begin
                                if strlen(lcVendorBankAccount."Bank Account No.") < 13 then
                                    Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");
                                lcBankAccountNo := CopyStr(lcVendorBankAccount."Bank Account No.", 4, 11);
                            end;
                        lcVendorBankAccount."Bank Account Type"::"Savings Account":
                            begin
                                if strlen(lcVendorBankAccount."Bank Account No.") < 14 then
                                    Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");

                                lcBankAccountNo := CopyStr(lcVendorBankAccount."Bank Account No.", 4, 12);
                            end;
                        lcVendorBankAccount."Bank Account Type"::"Interbank Account":
                            begin
                                if strlen(lcVendorBankAccount."Bank Account CCI") < 20 then
                                    Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");

                                lcBankAccountNo := CopyStr(lcVendorBankAccount."Bank Account CCI", 11, 20);
                            end;
                        lcVendorBankAccount."Bank Account Type"::" ":
                            begin
                                lcBankAccountNo := lcVendorBankAccount."Bank Account No.".Replace(TextCharacters, '0');
                            end;
                    END;

                    if lcVendorBankAccount."Check Manager" then
                        lcBankAccountNo := lcVendorBankAccount."Bank Account No.".Replace(TextCharacters, '0');

                    lcBankAccountNo := DelChr(lcBankAccountNo, '=', TextCharacters);

                    EVALUATE(lclCheckSumVendor, lcBankAccountNo);

                    lclTotalCheckSumVendor += lclCheckSumVendor;
                end else
                    Error('Cuenta Banco o CCI del empleado %1 no existe', lcVendor."No.");

            //lcLastEmployeeNo := GenJnlLine2."Account No.";//15-02-2019
            until lclGenJnlLineVendors.NEXT = 0;


        //Banco Cuenta para Checksum
        case pBankAccount."Bank Account Type" OF
            pBankAccount."Bank Account Type"::"Current Account":
                begin
                    if strlen(pBankAccount."Bank Account No.") < 13 then
                        Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");
                    lcBankAccountNo := CopyStr(pBankAccount."Bank Account No.", 4, 11);
                end;

            pBankAccount."Bank Account Type"::"Master Account":
                begin
                    if strlen(pBankAccount."Bank Account No.") < 13 then
                        Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");
                    lcBankAccountNo := CopyStr(pBankAccount."Bank Account No.", 4, 11);
                end;
            pBankAccount."Bank Account Type"::"Savings Account":
                begin
                    if strlen(pBankAccount."Bank Account No.") < 14 then
                        Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");

                    lcBankAccountNo := CopyStr(pBankAccount."Bank Account No.", 4, 12);
                end;
            pBankAccount."Bank Account Type"::"Interbank Account":
                begin
                    if strlen(pBankAccount."Bank Account CCI") < 20 then
                        Error('Cuenta Banco o CCI del proveedor %1 no cumple longitud requerida', lcVendor."No.");

                    lcBankAccountNo := CopyStr(pBankAccount."Bank Account CCI", 11, 20);
                end;
            pBankAccount."Bank Account Type"::" ":
                begin
                    lcBankAccountNo := pBankAccount."Bank Account No.".Replace(TextCharacters, '0');
                end;
        END;
        EVALUATE(lclCheckSumBank, DelChr(lcBankAccountNo, '=', TextCharacters));
        //----------------

        lclTotalCheckSumVendor += lclCheckSumBank;
        lclTextFormatCuenta := DelChr(format(lclTotalCheckSumVendor), '=', ',.');

        exit(lclTextFormatCuenta);
    end;

    procedure fnGenerateVendorTelecreditBBVA(pGenJnlLine: Record "Gen. Journal Line")
    var
        lclRecBank: Record "Bank Account";
        lclRecVendorBankAccount: Record "Vendor Bank Account";
        lclRecGenJnlLine: Record "Gen. Journal Line";
        lclRecVendor: Record "Vendor";
        lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
        lclText002: Label 'Procesando       @1@@@@@@@@@@@@@\';
        lclRecGenJLine2: Record "Gen. Journal Line";
        lclFileInStream: InStream;
        lclFileOutStream: OutStream;
        lclCampos: Text[1024];
        lclFile: File;
        lclWindow: Dialog;
        lclBankAmount: Decimal;
        lclNumberRecords: Integer;
        lclText003: Label 'There is no line of Type Account Bank in the Payment Journal', Comment = 'ESM="No tiene una línea de banco en el diario."';
        lclText004: Label 'Enter the Account Number for Bank %1', Comment = 'ESM="Ingrese un número de cuenta para el banco %1"';
        lclText005: Label 'Bank Account Number %1, must have 20 digits without dash', Comment = 'ESM="Número de cuenta banco %1", debe de tener 20 digitos sin guiones."';
        lclImportePagar: Decimal;
        lclCampoTemporal: Text;
        lclText006: Label 'The Length of the Identity Document must have a length equal to %1 for Vendor %2', Comment = 'ESM="La cantidad de caracteres del documento de identidad debe ser igual a %1 para el proveedor %2."';
        lclText007: Label 'The Type of Identity Document (Sunat Document) on Vendors Card %1 must have a value and/or be different from 0', Comment = 'ESM="La cantidad de caracteres del documento de identidad en la ficha de proveedor debe tener un valor diferente de cero."';
        lclText008: Label 'Bank Account Number %1 from Vendor %2, must have %3 digits without dash', Comment = 'ESM="Número de cuenta banco %1 para el proveedor %2, debe de tener %3 digitos sin guiones."';
        lclText009: Label 'Interbank Account Number %1 from Vendor %2, must have %3 digits without dash', Comment = 'ESM="Número de cuenta Interbank %1 para el proveedor %2. debe tener %2 digitos sin guiones."';
        lclText010: Label 'Applies-to Doc. No. must have a value in line %1', Comment = 'ESM="Liq. N° Document debe de tener un valor en la línea %1';
        lclText011: Label 'It was not found Applies-to Doc. No. in the Entry Ledger Vendor on line %1', Comment = 'ESM="No se encontró (Liq. por N° Documento) en el proveedor del libro mayor de entrada en la línea %1"';
        lclText012: Label 'The Document No. to be Settled on line% 1 does not have an External Supplier Document No.', Comment = 'ESM="El Num. Doc. a Liquidar en la línea %1, no tiene un Núm. Doc. Externo de Proveedor"';
        lclDashPosition: Integer;
        lclText013: Label 'Select a type of process for the bank %1', Comment = 'ESM="Seleccione un tipo de proceso para el banco %1"';
        lclFechaProceso: Date;
        lclTipoProceso: Text;
        lclText014: Label 'The process date must be greater than todays date %1.', Comment = 'ESM="La fecha de proceso debe ser mayor que la fecha %1 de hoy."';
        lclText015: Label 'The maximum allowed process date can not be longer in 6 months of Today %1', Comment = 'ESM="La fecha de proceso máxima permitida no puede ser más larga en 6 meses de Hoy %1"';
        lclTextDia: Text[2];
        lclTextMes: Text[2];
        lclTextAnio: Text[4];
        lclText016: Label 'Select a processing time for the bank %1.', Comment = 'ESM="Seleccione un tiempo de procesamiento para el banco %1."';
        lcCuMPWUtilities: Codeunit "Telecredit Utility";
        lcAmount: Decimal;
        lcFileName: Text;
        lcRecGenJnlLine2: Record "Gen. Journal Line";
        lcMultiple: Boolean;
        lcVendorInvoiceNo: Code[30];
        lcRecPurchInvHeader: Record "Purch. Inv. Header";
        lcRecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lcAdditionalReference: Text;
        lcSerieVendorInvoiceNo: Text;
        lcNumberVendorInvoiceNo: Text;
        lcText0015: Label 'Telécredito %1 documento %2.';
        lcOption: Integer;
    begin
        lcOption := StrMenu('Premiun,Net Cash', 1, 'Seleccione el tipo de telecrédito:');
        case lcOption of
            2:
                begin
                    fnCreateNetCash(pGenJnlLine);
                    exit;
                end;
            0:
                exit;
        end;
        Clear(lclFile);
        CreateTempFile();

        //---------------------------- Make Header ----------------------------------------------
        lclCampos := '750';//Tipo de Registro

        lclRecGenJnlLine.RESET;
        lclRecGenJnlLine.SETRANGE("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclRecGenJnlLine.SETRANGE("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclRecGenJnlLine.SETFILTER("Account Type", '%1', lclRecGenJnlLine."Account Type"::"Bank Account");
        IF lclRecGenJnlLine.FINDSET THEN BEGIN
            lclRecGenJnlLine.TESTFIELD("Account No.");
            lclRecBank.GET(lclRecGenJnlLine."Account No.");
            IF lclRecBank."Bank Account No." = '' THEN
                ERROR(lclText004, lclRecGenJnlLine."Account No.")
            ELSE BEGIN
                //Cuenta de Cargo
                IF STRLEN(DELCHR(lclRecBank."Bank Account No.", '=', '-')) = 20 THEN
                    lclCampos := lclCampos + DELCHR(lclRecBank."Bank Account No.", '=', '-')
                ELSE
                    ERROR(lclText005, lclRecBank."No.");
                //Moneda de Cuenta de Cargo
                IF lclRecBank."Currency Code" = '' THEN
                    lclCampos := lclCampos + 'PEN'
                ELSE
                    lclCampos := lclCampos + lclRecBank."Currency Code";
            END;
        END ELSE
            ERROR(lclText003);

        //Importe a Cargar
        lclRecGenJnlLine.RESET;
        lclRecGenJnlLine.SETRANGE("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclRecGenJnlLine.SETRANGE("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclRecGenJnlLine.SETFILTER("Account Type", '%1', lclRecGenJnlLine."Account Type"::"Bank Account");
        IF lclRecGenJnlLine.FINDSET THEN BEGIN
            REPEAT
                lclImportePagar := lclImportePagar + lclRecGenJnlLine.Amount
            UNTIL lclRecGenJnlLine.NEXT = 0;
            lclImportePagar := ABS(lclImportePagar);
            lclCampoTemporal := DELCHR(FORMAT(lclImportePagar, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
            IF STRLEN(lclCampoTemporal) < 15 THEN
                lclCampoTemporal := PADSTR('', 15 - STRLEN(lclCampoTemporal), '0') + lclCampoTemporal;
            lclCampos := lclCampos + lclCampoTemporal;
        END;

        //Tipo de Proceso
        IF lclRecBank."Process Type BBVA" = lclRecBank."Process Type BBVA"::" " THEN
            ERROR(lclText013, lclRecBank."No.");
        lclTipoProceso := ' ';
        CASE lclRecBank."Process Type BBVA" OF
            lclRecBank."Process Type BBVA"::Immediate:
                lclTipoProceso := 'A';
            lclRecBank."Process Type BBVA"::"Date":
                BEGIN
                    MESSAGE('Se debe configurar el obtener fecha de proceso, consultar a sistemas.');
                    //                                              EVALUATE(lclFechaProceso,"#DialogInput"('Fecha Proceso','Ingrese la Fecha (DD/MM/AAAA) :'));
                    lclTipoProceso := 'F';
                END;
            lclRecBank."Process Type BBVA"::Hour:
                lclTipoProceso := 'H';
        END;
        lclCampos := lclCampos + lclTipoProceso;

        //Fecha de Proceso
        IF lclTipoProceso = 'F' THEN BEGIN
            IF (lclFechaProceso - WORKDATE) <= 0 THEN
                ERROR(lclText014, WORKDATE);
            IF lclFechaProceso > (CALCDATE('<+6M>', WORKDATE)) THEN
                ERROR(lclText015, WORKDATE);
            lclTextDia := FORMAT(DATE2DMY(lclFechaProceso, 1));
            lclTextMes := FORMAT(DATE2DMY(lclFechaProceso, 2));
            lclTextAnio := FORMAT(DATE2DMY(lclFechaProceso, 3));
            IF STRLEN(lclTextDia) = 1 THEN
                lclTextDia := '0' + lclTextDia;
            IF STRLEN(lclTextMes) = 1 THEN
                lclTextMes := '0' + lclTextMes;
            lclCampoTemporal := lclTextDia + lclTextMes + lclTextAnio;
        END ELSE
            lclCampoTemporal := PADSTR('', 8, '0');
        //IF STRLEN(lclCampoTemporal) < 8 THEN
        //  lclCampoTemporal := lclCampoTemporal + PADSTR('', 8 - STRLEN(lclCampoTemporal),' ');
        lclCampos := lclCampos + lclCampoTemporal;

        //Hora de proceso
        IF lclTipoProceso = 'H' THEN BEGIN
            IF lclRecBank."Process Hour" = lclRecBank."Process Hour"::" " THEN
                ERROR(lclText016, lclRecBank."No.");
            lclCampos := lclCampos + COPYSTR(FORMAT(lclRecBank), 1, 1); // B , C  o D
        END ELSE
            lclCampos := lclCampos + ' ';

        //Referencia
        lclCampoTemporal := COPYSTR(lclRecGenJnlLine."Posting Text", 1, 25);
        IF STRLEN(lclCampoTemporal) < 25 THEN
            lclCampoTemporal := lclCampoTemporal + PADSTR('', 25 - STRLEN(lclCampoTemporal), ' ');
        lclCampos := lclCampos + lclCampoTemporal;

        //Total de Registros
        lclRecGenJnlLine.RESET;
        lclRecGenJnlLine.SETRANGE("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclRecGenJnlLine.SETRANGE("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclRecGenJnlLine.SETFILTER("Account Type", '%1', lclRecGenJnlLine."Account Type"::Vendor);
        lclCampoTemporal := FORMAT(lclRecGenJnlLine.COUNT);
        IF STRLEN(lclCampoTemporal) < 6 THEN
            lclCampoTemporal := PADSTR('', 6 - STRLEN(lclCampoTemporal), '0') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;

        //Validación de Pertenencia
        lclCampos := lclCampos + 'S';

        //Valor de Control
        lclCampoTemporal := '';
        IF STRLEN(lclCampoTemporal) < 15 THEN
            lclCampoTemporal := PADSTR('', 15 - STRLEN(lclCampoTemporal), '0') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;

        //Indicador de Proceso
        lclCampoTemporal := '';
        IF STRLEN(lclCampoTemporal) < 3 THEN
            lclCampoTemporal := PADSTR('', 3 - STRLEN(lclCampoTemporal), '0') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;

        //Descripción
        lclCampoTemporal := '';
        IF STRLEN(lclCampoTemporal) < 30 THEN
            lclCampoTemporal := PADSTR('', 30 - STRLEN(lclCampoTemporal), ' ') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;

        //Importe máximo por registro
        lclCampoTemporal := '';
        IF STRLEN(lclCampoTemporal) < 15 THEN
            lclCampoTemporal := PADSTR('', 15 - STRLEN(lclCampoTemporal), ' ') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;

        //Filler
        lclCampoTemporal := '';
        IF STRLEN(lclCampoTemporal) < 5 THEN
            lclCampoTemporal := PADSTR('', 5 - STRLEN(lclCampoTemporal), ' ') + lclCampoTemporal;
        lclCampos := lclCampos + lclCampoTemporal;


        insertLineToTempFile(lclCampos);
        //-----------------------------Make Body --------------------------

        lclWindow.OPEN(lclText002);
        lclRecGenJnlLine.RESET;
        lclRecGenJnlLine.SETRANGE("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclRecGenJnlLine.SETRANGE("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclRecGenJnlLine.SETFILTER("Account Type", '%1', lclRecGenJnlLine."Account Type"::Vendor);
        IF lclRecGenJnlLine.FINDSET THEN BEGIN
            REPEAT
                CLEAR(lclCampos);

                lclNumberRecords += 1;
                lclWindow.UPDATE(1, ROUND(lclNumberRecords / lclRecGenJnlLine.COUNT * 10000, 1));
                //Tipo de Registro
                lclCampos := lclCampos + '002';

                lclRecVendor.RESET;
                lclRecVendor.SETRANGE("No.", lclRecGenJnlLine."Account No.");
                IF lclRecVendor.FINDSET THEN BEGIN
                    //DOI - Tipo
                    CASE lclRecVendor."VAT Registration Type" OF
                        '1':
                            BEGIN
                                lclCampoTemporal := 'L';
                                IF STRLEN(FORMAT(lclRecGenJnlLine."Account No.")) <> 8 THEN
                                    ERROR(lclText006, '8', lclRecGenJnlLine."Account No.");
                            END;
                        '4':
                            lclCampoTemporal := 'E';
                        '6':
                            BEGIN
                                lclCampoTemporal := 'R';
                                IF STRLEN(FORMAT(lclRecGenJnlLine."Account No.")) <> 11 THEN
                                    ERROR(lclText006, '11', lclRecGenJnlLine."Account No.");
                            END;
                        '7':
                            lclCampoTemporal := 'P';
                        ELSE
                            ERROR(lclText007, lclRecGenJnlLine."Account No.");
                    END;
                    lclCampos := lclCampos + lclCampoTemporal;
                END;

                //DOI - Número
                lclCampoTemporal := lclRecGenJnlLine."Account No.";
                IF STRLEN(lclCampoTemporal) < 12 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 12 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Tipo de abono
                lclRecGenJLine2.RESET;
                lclRecGenJLine2.SETRANGE("Journal Template Name", pGenJnlLine."Journal Template Name");
                lclRecGenJLine2.SETRANGE("Journal Batch Name", pGenJnlLine."Journal Batch Name");
                lclRecGenJLine2.SETFILTER("Account Type", '%1', lclRecGenJLine2."Account Type"::"Bank Account");
                IF lclRecGenJLine2.FINDSET THEN;

                lclRecVendorBankAccount.GET(lclRecGenJnlLine."Account No.", lclRecGenJnlLine."Recipient Bank Account");
                IF lclRecVendorBankAccount."Check Manager" THEN
                    lclCampoTemporal := 'O'
                ELSE BEGIN
                    lclRecVendorBankAccount.TESTFIELD("Reference Bank Acc. No.");
                    IF lclRecVendorBankAccount."Reference Bank Acc. No." = lclRecGenJLine2."Account No." THEN
                        lclCampoTemporal := 'P'
                    ELSE
                        lclCampoTemporal := 'I';
                END;
                lclCampos := lclCampos + lclCampoTemporal;

                //Número de cuenta de abono
                IF lclCampoTemporal = 'P' THEN BEGIN
                    lclRecVendorBankAccount.TESTFIELD("Bank Account No.");
                    IF STRLEN(DELCHR(FORMAT(lclRecVendorBankAccount."Bank Account No."), '=', '-./')) <> 20 THEN
                        ERROR(lclText008, lclRecVendorBankAccount.Code, lclRecGenJnlLine."Account No.", '20');
                    lclCampos := lclCampos + DELCHR(FORMAT(lclRecVendorBankAccount."Bank Account No."), '=', '-./');
                END ELSE
                    IF lclCampoTemporal = 'I' THEN BEGIN
                        lclRecVendorBankAccount.TESTFIELD("Bank Account CCI");
                        IF STRLEN(DELCHR(FORMAT(lclRecVendorBankAccount."Bank Account CCI"), '=', '-./')) <> 20 THEN
                            ERROR(lclText009, lclRecVendorBankAccount.Code, lclRecGenJnlLine."Account No.", '20');
                        lclCampos := lclCampos + DELCHR(FORMAT(lclRecVendorBankAccount."Bank Account CCI"), '=', '-./');
                    END ELSE
                        lclCampos := lclCampos + '                    ';

                //Nombre de Beneficiario
                IF lclRecGenJnlLine.Description <> '' THEN BEGIN
                    IF STRLEN(lclRecGenJnlLine.Description) > 40 THEN
                        lclCampoTemporal := COPYSTR(lclRecGenJnlLine.Description, 1, 40)
                    ELSE
                        lclCampoTemporal := lclRecGenJnlLine.Description;
                END;
                IF lclRecGenJnlLine."Check Name" <> '' THEN BEGIN
                    IF STRLEN(lclRecGenJnlLine."Check Name") > 40 THEN
                        lclCampoTemporal := COPYSTR(lclRecGenJnlLine."Check Name", 1, 40)
                    ELSE
                        lclCampoTemporal := lclRecGenJnlLine."Check Name";
                END;
                IF STRLEN(lclCampoTemporal) < 40 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 40 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Importe a Abonar
                CASE TRUE OF
                    (lclRecGenJnlLine.Amount < 0) AND (lclRecGenJnlLine."Currency Code" <> ''):
                        lcAmount := lclRecGenJnlLine.Amount + ABS(lclRecGenJnlLine."Retention Amount" * lclRecGenJnlLine."Currency Factor");
                    (lclRecGenJnlLine.Amount < 0) AND (lclRecGenJnlLine."Currency Code" = ''):
                        lcAmount := lclRecGenJnlLine.Amount + ABS(lclRecGenJnlLine."Retention Amount");
                    (lclRecGenJnlLine.Amount > 0) AND (lclRecGenJnlLine."Currency Code" <> ''):
                        lcAmount := lclRecGenJnlLine.Amount - ABS(lclRecGenJnlLine."Retention Amount" * lclRecGenJnlLine."Currency Factor");
                    (lclRecGenJnlLine.Amount > 0) AND (lclRecGenJnlLine."Currency Code" = ''):
                        lcAmount := lclRecGenJnlLine.Amount - ABS(lclRecGenJnlLine."Retention Amount");
                END;
                lclCampoTemporal := fnGetFormatAmt(FALSE, lcAmount);
                //    lclCampoTemporal := DELCHR(FORMAT(lclRecGenJnlLine.Amount - lclRecGenJnlLine."Retention Amount",0,
                //                                       '<Precision,2:2><Standard Format,0>'),'=',',.');
                IF STRLEN(lclCampoTemporal) < 15 THEN
                    lclCampoTemporal := PADSTR('', 15 - STRLEN(lclCampoTemporal), '0') + lclCampoTemporal;
                lclCampos := lclCampos + lclCampoTemporal;

                IF lclRecGenJnlLine."Applies-to Doc. No." <> '' THEN BEGIN
                    lclCampoTemporal := ' ';
                    lclRecVendorLedgerEntry.RESET;
                    lclRecVendorLedgerEntry.SETRANGE("Vendor No.", lclRecGenJnlLine."Account No.");
                    lclRecVendorLedgerEntry.SETRANGE("Document No.", lclRecGenJnlLine."Applies-to Doc. No.");
                    lclRecVendorLedgerEntry.SETRANGE("Currency Code", lclRecGenJnlLine."Currency Code");
                    lclRecVendorLedgerEntry.SETRANGE(Open, TRUE);
                    lclRecVendorLedgerEntry.SETRANGE(Reversed, FALSE);
                    IF lclRecVendorLedgerEntry.FINDSET THEN BEGIN
                        //Tipo de Documento
                        CASE lclRecVendorLedgerEntry."Legal Document" OF
                            '03':
                                lclCampoTemporal := 'B';
                            '07':
                                lclCampoTemporal := 'N';
                            ELSE
                                lclCampoTemporal := 'F';
                        END;
                        lclCampos := lclCampos + lclCampoTemporal;

                        //Número de Documento
                        lclCampoTemporal := '            ';
                        IF lclRecVendorLedgerEntry."External Document No." <> '' THEN BEGIN
                            lclCampoTemporal := COPYSTR(lclRecVendorLedgerEntry."External Document No.", 1, 12);
                            IF STRLEN(lclCampoTemporal) < 12 THEN
                                lclCampoTemporal := lclCampoTemporal + PADSTR('', 12 - STRLEN(lclCampoTemporal), ' ');
                        END ELSE
                            ERROR(lclText012, lclRecGenJnlLine."Line No.");
                        lclCampos := lclCampos + lclCampoTemporal;
                    END ELSE
                        ERROR(lclText011, lclRecGenJnlLine."Line No.")
                END ELSE BEGIN
                    lclCampoTemporal := 'F';
                    lclCampos += lclCampoTemporal;
                    lclCampoTemporal := '            ';
                    IF lclRecGenJnlLine."External Document No." <> '' THEN BEGIN
                        lclCampoTemporal := COPYSTR(lclRecGenJnlLine."External Document No.", 1, 12);
                        IF STRLEN(lclCampoTemporal) < 12 THEN
                            lclCampoTemporal := lclCampoTemporal + PADSTR('', 12 - STRLEN(lclCampoTemporal), ' ');
                    END;
                    lclCampos += lclCampoTemporal;
                    //ERROR(lclText010,lclRecGenJnlLine."Line No.");
                END;

                //Abono Agrupado
                lclCampos := lclCampos + 'N';

                //Referencia
                lclCampoTemporal := '';
                IF lclRecGenJnlLine."Posting Text" <> '' THEN
                    lclCampoTemporal := COPYSTR(lclRecGenJnlLine."Posting Text", 1, 40);

                IF STRLEN(lclCampoTemporal) < 40 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 40 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Indicador de Aviso
                lclCampos := lclCampos + 'E'; //  E = E-mail , C = Celular

                //Medio de Aviso
                lclCampoTemporal := '';
                IF lclRecVendor."E-Mail" <> '' THEN
                    lclCampoTemporal := COPYSTR(lclRecVendor."E-Mail", 1, 50);

                IF STRLEN(lclCampoTemporal) < 50 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 50 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Persona de Contacto
                lclCampoTemporal := '';
                IF lclRecVendor.Contact <> '' THEN
                    lclCampoTemporal := COPYSTR(lclRecVendor.Contact, 1, 30);
                IF STRLEN(lclCampoTemporal) < 30 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 30 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Indicador de Proceso
                lclCampos := lclCampos + '  ';

                //Descripción
                lclCampoTemporal := '';
                IF STRLEN(lclCampoTemporal) < 30 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 30 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                //Filler
                lclCampoTemporal := '';
                IF STRLEN(lclCampoTemporal) < 18 THEN
                    lclCampoTemporal := lclCampoTemporal + PADSTR('', 18 - STRLEN(lclCampoTemporal), ' ');
                lclCampos := lclCampos + lclCampoTemporal;

                insertLineToTempFile(lclCampos);
            UNTIL lclRecGenJnlLine.NEXT = 0;
        END;
        PostFileToControlFileRecord(pGenJnlLine."document No.", STRSUBSTNO(TeleCreditdocumentLabel, 'BBVA-PR', pGenJnlLine."document No."), 'BBVA-PR');
    end;

    procedure fnGenerateVendorTelecreditITBK(pGenJnlLine: Record "Gen. Journal Line")
    var
        lclínearray: array[50] of Text[80];
        lcWindow: Dialog;
        lcTotalRecords: integer;
        lcRecVendLedgrEntry: Record "Vendor Ledger Entry";
        lcOperationAmount: Decimal;
        Employee: Record Employee;
        //EmployeeBankAccount: Record "Employee Bank Account";
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TelecreditUtility: Codeunit "Telecredit Utility";
        lcNameCode: Code[75];
        lcLasNameCode: Code[75];
        lcLasname2Code: Code[75];
        lclEmployeeCode: Code[20];
        lcdocumentNo: Code[20];
        lcBankAccountNo: Code[20];
        lcSecuenceCode: Code[20];
        lcLastEmployeeNo: Code[20];
        lclTexto: Text[1024];
        lclCampos: Text[1024];
        lclRefer: Text[240];
        lcltOTALtext: Text;
        FA: Text;
        FM: Text;
        FD: Text;
        lclTextFormatCuenta: Text;
        lclAmountTxt: Text;
        lcFullName: Text;
        lcDay: Text;
        lcMonth: Text;
        lcYear: Text;
        lcCity: Text;
        lcLastName1: Text;
        lcLastName2: Text;
        lcBankTelecridt: Text;
        lcTextAmount: Text;
        lclStartDate: Date;
        lclendDate: Date;
        lclCount: integer;
        lcOption: integer;
        lcI: integer;
        lclBool1: Boolean;
        lcFile: File;
        lclAmount: Decimal;
        lclAmountLCY: Decimal;
        lclTotalCheckSum: Decimal;
        lclCheckSumDec: Decimal;
        lclAmountAux: Decimal;
        lcTotalAmount: Decimal;
        CompanyInf: Record "Company inFormation";
        lclLine: integer;
        lclNotaCargo: Text;
        lclGenJLine2: Record "Gen. Journal Line";
        lclTipoPago: Text;
        lclBank: Record "Bank Account";
        lclSoles: Boolean;
        lclChekSum: Text[1024];
        lclNumCount2: integer;
        pBankAmount: Decimal;
        lclFile: File;
        lclWindow: Dialog;
        ConcatBanco: Text;
        lclGenJnlLine: Record "Gen. Journal Line";
        lclVendorBankAccount: Record "Vendor Bank Account";
        Checksum: Biginteger;
        lclCampos2: Text;
        lcMultiple: Boolean;
        lclVendor: Record Vendor;
        lcNameVendor: Text;
        lcVendorinvoiceNo: Code[30];
        lcRecPurchinvHeader: Record "Purch. inv. Header";
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcRecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lcAdditionalReference: Text;
        gNewAcc: Text;
        lclint: integer;
        lcAmount: Decimal;
        lcAmountText: Text;
        lcFileName: Text;
        lclRecVendor: Record Vendor;
        lclRecGenJournalLine: Record "Gen. Journal Line";
        VendorBankAccount: Record "Vendor Bank Account";
        lcTotalLineText: Text[1024];
        lcCurrentsRecords: integer;
        lcText0007: Label 'La Longitud del Núm. de Cuenta para un Tipo Cuenta Pago Normal debe ser de 13 caracteres.';
        lcText0008: Label 'La Longitud del Núm. de Cuenta para un Tipo Cuenta Pago interbancaria debe ser de 20 caracteres.';
        lcText0011: Label 'ingrese Cod. de documento identidad del Proveedor %1 en su ficha Proveedor.';
        lcText0012: Label 'No se encontra el Cód. Proveedor %1 en la ficha de Proveedores.';
        lcText0013: Label 'Para Cod. documento Identidad 1, la longitud debe ser de 8 caracteres.';
        lcText0014: Label 'ingrese nombre del proveedor de la línea %1 en la ficha de proveedores.';
    begin
        Clear(lclínearray);
        Clear(lcFile);

        //ULN::PC 001  2020.06.01 v.001 begin 
        CreateTempFile();
        //ULN::PC 001  2020.06.01 v.001 end

        lcWindow.Open(Processing);

        with GenJnlLine do begin
            Reset();
            SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
            SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
            SetRange("Account Type", "Account Type"::Vendor);
            lcTotalRecords := COUNT;
            if FindSet() then
                repeat
                    Clear(lclínearray);
                    //Cod. Registro
                    lclínearray[1] := '02';
                    //Cod. Benefiario
                    TestField("Account No.");

                    lclínearray[2] := "Account No.";
                    if StrLen(lclínearray[2]) < 20 then
                        lclínearray[2] := lclínearray[2] + PadStr('', 20 - StrLen(lclínearray[2]), ' ');

                    //Tipo Operacion
                    if "Applies-to Entry No." <> 0 then begin
                        TestField("Applies-to doc. No.");
                        lcRecVendLedgrEntry.Reset();
                        lcRecVendLedgrEntry.SetRange("Entry No.", "Applies-to Entry No.");
                        if lcRecVendLedgrEntry.FindSet() then begin //Open 0001
                            case lcRecVendLedgrEntry."Legal document" of
                                '08':
                                    lclínearray[3] := 'D';
                                '07':
                                    lclínearray[3] := 'C';
                                else
                                    lclínearray[3] := 'F';
                            end;

                            //doc-Número
                            if lcRecVendLedgrEntry."External document No." <> '' then begin
                                lclínearray[4] := CopyStr(Format(lcRecVendLedgrEntry."External document No."), 1, 20);
                                if StrLen(lclínearray[4]) < 20 then
                                    lclínearray[4] := lclínearray[4] + PadStr('', 20 - StrLen(lclínearray[4]), ' ');
                            end else
                                Error(ErrorNoExistVendorEntryForAppliedEntryNo, "Applies-to doc. No.", "Line No.");

                            //Fecha Vencimiento documento
                            if lcRecVendLedgrEntry."Due Date" <> 0D then begin
                                lcYear := Format(Date2DMY(lcRecVendLedgrEntry."Due Date", 3));
                                lcMonth := Format(Date2DMY(lcRecVendLedgrEntry."Due Date", 2));
                                lcDay := Format(Date2DMY(lcRecVendLedgrEntry."Due Date", 1));
                                if StrLen(lcMonth) < 2 then
                                    lcMonth := PadStr('', 2 - StrLen(lcMonth), '0') + lcMonth;

                                if StrLen(lcDay) < 2 then
                                    lcDay := PadStr('', 2 - StrLen(lcDay), '0') + lcDay;

                                lclínearray[5] := lcYear + lcMonth + lcDay;
                            end;

                            if StrLen(lclínearray[5]) < 8 then
                                lclínearray[5] := lclínearray[5] + PadStr('', 8 - StrLen(lclínearray[5]), ' ');

                        end else
                            Error(FieldDiferentValueinLine, FieldCaption("Applies-to Entry No."), "Applies-to Entry No.", "Line No.");// Close 0001
                    end else begin
                        //** ANTICIPOS begin ****
                        lclínearray[3] := 'C';
                        //doc-Número
                        if "External document No." <> '' then begin
                            lclínearray[4] := CopyStr(Format("External document No."), 1, 20);
                            if StrLen(lclínearray[4]) < 20 then
                                lclínearray[4] := lclínearray[4] + PadStr('', 20 - StrLen(lclínearray[4]), ' ');
                        end else
                            Error(ErrorNoExistVendorEntryForAppliedEntryNo, "Applies-to doc. No.", "Line No.");

                        //Fecha Vencimiento documento
                        if "Due Date" <> 0D then
                            lclínearray[5] := Format("Due Date", 0, '<Year4><Month,2><Day,2>')
                        else
                            lclínearray[5] := '        ';
                        //** ANTICIPOS end ****
                    end;


                    //Divisa Operación
                    case "Currency Code" of
                        '':
                            lclínearray[6] := '01';
                        else
                            lclínearray[6] := '10';
                    end;

                    //Importe Operación
                    Clear(lcOperationAmount);
                    if lclínearray[3] = 'C' then
                        lcOperationAmount := Amount + ABS("Retention Amount")
                    else
                        lcOperationAmount := Amount - ABS("Retention Amount");

                    lclínearray[7] := DelChr(Format(lcOperationAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.');
                    if StrLen(lclínearray[7]) < 15 then
                        lclínearray[7] := PadStr('', 15 - StrLen(lclínearray[7]), '0') + lclínearray[7];

                    //indicador interbancario
                    TestField("Recipient Bank Account");
                    if VendorBankAccount.Get("Account No.", "Recipient Bank Account") then begin
                        if VendorBankAccount."Bank Account Type" in [VendorBankAccount."Bank Account Type"::"Current Account",
                                                                     VendorBankAccount."Bank Account Type"::"Master Account",
                                                                     VendorBankAccount."Bank Account Type"::"Savings Account"] then
                            lclínearray[8] := '0'
                        else
                            lclínearray[8] := '1';
                    end else
                        lclínearray[8] := '0';

                    //Tipo Abono
                    if Not VendorBankAccount."Check Manager" then
                        lclínearray[9] := '09'
                    else
                        lclínearray[9] := '11';
                    if lclínearray[8] = '1' then
                        lclínearray[9] := '99';

                    //Tipo de cuenta
                    //(0),(1)Cuenta Corriente,(2)Cuenta Maestra,(3)Cuenta Ahorros,(4)Cuenta interbancaria
                    if Not VendorBankAccount."Check Manager" then begin
                        case VendorBankAccount."Bank Account Type" of
                            VendorBankAccount."Bank Account Type"::"Current Account":
                                lclínearray[10] := '001';
                            VendorBankAccount."Bank Account Type"::"Master Account":
                                lclínearray[10] := '001';
                            VendorBankAccount."Bank Account Type"::"Savings Account":
                                lclínearray[10] := '002';
                        end;
                    end else
                        lclínearray[10] := '   ';

                    //Cód. Divisa
                    if VendorBankAccount."Currency Code" = '' then
                        lclínearray[11] := '01'
                    else
                        lclínearray[11] := '10';

                    //Tienda
                    if Not VendorBankAccount."Check Manager" then begin
                        if lclínearray[9] = '09' then
                            lclínearray[12] := CopyStr(DelChr(VendorBankAccount."Bank Account No.", '=', '-'), 1, 3)
                        else
                            lclínearray[12] := '   ';
                    end else
                        lclínearray[12] := '000';


                    //Cuenta Numero
                    if Not VendorBankAccount."Check Manager" then begin
                        if VendorBankAccount."Bank Account Type" in [VendorBankAccount."Bank Account Type"::"Current Account",
                                                                     VendorBankAccount."Bank Account Type"::"Master Account",
                                                                     VendorBankAccount."Bank Account Type"::"Savings Account"] then begin
                            if (StrLen(VendorBankAccount."Bank Account No.") <> 13) then
                                Error(lcText0007)
                            else
                                lclínearray[13] := CopyStr(DelChr(VendorBankAccount."Bank Account No.", '=', '-'), 4, StrLen(VendorBankAccount."Bank Account No."));
                        end else
                            if (VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account") then begin
                                if (StrLen(VendorBankAccount."Bank Account CCI") <> 20) then
                                    Error(lcText0008)
                                else
                                    lclínearray[13] := DelChr(VendorBankAccount."Bank Account CCI", '=', '-');
                            end;
                    end else
                        lclínearray[13] := '                    ';

                    if StrLen(lclínearray[13]) < 20 then
                        lclínearray[13] := lclínearray[13] + PadStr('', 20 - StrLen(lclínearray[13]), ' ');

                    lclRecVendor.Reset();
                    lclRecVendor.SetRange("No.", "Account No.");
                    if lclRecVendor.FindSet() then begin
                        //Tipo Persona
                        case lclRecVendor."VAT Registration Type" of
                            '6':
                                lclínearray[14] := 'C';
                            else
                                lclínearray[14] := 'P';
                        end;

                        //Tipo de documento de identidad
                        if lclRecVendor."VAT Registration Type" <> '' then begin
                            case lclRecVendor."VAT Registration Type" of
                                '0':
                                    lclínearray[15] := '  ';
                                '1':
                                    lclínearray[15] := '01';
                                '4':
                                    lclínearray[15] := '03';
                                '6':
                                    lclínearray[15] := '02';
                                '7':
                                    lclínearray[15] := '05';
                                'A':
                                    lclínearray[15] := '04';
                                else
                                    lclínearray[14] := ' ';
                            end;
                        end else
                            Error(lcText0011, lclRecGenJournalLine."Account No.");
                    end else
                        Error(lcText0012, lclRecGenJournalLine."Account No.");

                    //documento de Identidad
                    lclRecVendor.TestField("VAT Registration No.");
                    lclínearray[16] := lclRecVendor."VAT Registration No.";
                    if (lclRecVendor."VAT Registration Type" = '1') and (StrLen(lclínearray[16]) <> 8) then
                        Error(lcText0013);

                    if (lclínearray[14] = 'P') and (StrLen(lclínearray[16]) = 11) and (lclRecVendor."VAT Registration Type" = '6') then begin
                        lclínearray[16] := CopyStr("Account No.", 3, 8);
                        lclínearray[2] := lclínearray[16];
                        if StrLen(lclínearray[2]) < 20 then
                            lclínearray[2] := lclínearray[2] + PadStr('', 20 - StrLen(lclínearray[2]), ' ');
                        lclínearray[15] := '01';
                    end;

                    if StrLen(lclínearray[16]) < 15 then
                        lclínearray[16] := lclínearray[16] + PadStr('', 15 - StrLen(lclínearray[16]), ' ');

                    //Nombre del Beneficiario
                    if lclRecGenJournalLine."Check Name" <> '' then//if Description <> '' then
                        lclínearray[17] := CopyStr(lclRecGenJournalLine."Check Name", 1, 60)
                    else
                        if lclRecVendor.Name <> '' then
                            lclínearray[17] := CopyStr(lclRecVendor.Name + ' ' + lclRecVendor."Name 2", 1, 60)
                        else
                            Error(lcText0014, "Line No.");


                    if StrLen(lclínearray[17]) < 60 then
                        lclínearray[17] := lclínearray[17] + PadStr('', 60 - StrLen(lclínearray[17]), ' ');

                    //En Blanco
                    lclínearray[18] := '00';
                    //Retención
                    lclínearray[19] := '0000000000000';
                    //Espacios en Blanco
                    lclínearray[20] := '';
                    lcTotalLineText := '';
                    For lcI := 1 TO 20 do begin
                        lcTotalLineText += lclínearray[lcI];
                    end;
                    //ULN::PC 001  2020.06.01 v.001 begin 
                    //lcFile.WRITE(lcTotalLineText); Obsolete
                    insertLineToTempFile(lcTotalLineText);
                    //ULN::PC 001  2020.06.01 v.001 end

                    lcCurrentsRecords += 1;
                    lcWindow.UPDATE(1, ROUND(lcTotalRecords / lcCurrentsRecords * 10000, 1));
                until NEXT = 0;
        end;


        lcWindow.CLOSE;
        PostFileToControlFileRecord(pGenJnlLine."document No.", STRSUBSTNO(TeleCreditdocumentLabel, 'interbank', pGenJnlLine."document No."), 'interbank');


    end;

    local procedure fnDefineTypeTelecredit(pGenJnlLine: Record "Gen. Journal Line"): integer
    var
        GenJnlLine: Record "Gen. Journal Line";
        lcIsVendor: Boolean;
        lcIsEmployee: Boolean;
        lcText0001: Label 'El diario solo debe contener empleados o proveedores, no se puede generar TXT para ambos.1';
    // ESP = 'El diario solo debe contener empleados o proveedores, no se puede generar TXT para ambos.', ESM = 'El diario solo debe contener empleados o proveedores, no se puede generar TXT para ambos.';
    begin
        //(0) = Employee
        //(1) = Vendor   
        lcIsVendor := false;
        lcIsEmployee := false;

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
        lcIsVendor := GenJnlLine.FinD('-');

        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", pGenJnlLine."Account Type"::Employee);
        lcIsEmployee := GenJnlLine.FinD('-');

        if lcIsEmployee and lcIsVendor then
            Error(lcText0001);

        if lcIsEmployee then
            exit(0);

        if lcIsVendor then
            exit(1);
    end;

    local procedure fnCheckVendorBankAccount(VAR VendorBankAccount: Record "Vendor Bank Account")
    var
        BankAccount: Record "Bank Account";
        lcText0001: Label 'El banco preferido %1 del proveedor %2, se encuentra mal configurado.';
    //, ESP = 'El banco preferido %1 del proveedor %2, se encuentra mal configurado.';
    begin
        case VendorBankAccount."Bank Account Type" of
            VendorBankAccount."Bank Account Type"::"Interbank Account":
                begin
                    BankAccount.Reset();
                    BankAccount.SetRange("No.", VendorBankAccount."Reference Bank Acc. No.");
                    if BankAccount.FinD('-') then begin
                        if BankAccount."Legal Document" = VendorBankAccount."Legal Document" then
                            Error(lcText0001, VendorBankAccount.Code, VendorBankAccount."Vendor No.");
                    end;
                end;
        end;
    end;

    local procedure fnCheckEmployeeBankAccount(VAR EmployeeBankAccount: Record "ST Employee Bank Account")
    var
        BankAccount: Record "Bank Account";
        lcText0001: Label 'El banco preferido %1 del proveedor %2, se encuentra mal configurado.';
    //, ESP = 'El banco preferido %1 del proveedor %2, se encuentra mal configurado.';
    begin
        case EmployeeBankAccount."Bank Account Type" of
            EmployeeBankAccount."Bank Account Type"::"Interbank Account":
                begin
                    BankAccount.Reset();
                    BankAccount.SetRange("No.", EmployeeBankAccount."Reference Bank Acc. No.");
                    if BankAccount.FinD('-') then begin
                        // if BankAccount."Legal Document" = EmployeeBankAccount."Legal Document" then
                        Error(lcText0001, EmployeeBankAccount.Code, EmployeeBankAccount."Employee No.");
                    end;
                end;
        end;
    end;

    local procedure fnGenerateSalaryTelecreditVendor(pGenJnlLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TelecreditUtility: Codeunit "Telecredit Utility";
        lcNameCode: Code[75];
        lcLasNameCode: Code[75];
        lcLasname2Code: Code[75];
        lcdocumentNo: Code[20];
        lcBankAccountNo: Code[20];
        lcSecuenceCode: Code[20];
        lcLastEmployeeNo: Code[20];
        lclTexto: Text[1024];
        lclCampos: array[50] of Text[1024];
        lclNombreString: Text[1024];
        lclRefer: Text[240];
        lcltOTALtext: Text;
        FA: Text;
        FM: Text;
        FD: Text;
        lclTextFormatCuenta: Text;
        lclAmountTxt: Text;
        lcFullName: Text;
        lcDay: Text;
        lcMonth: Text;
        lcYear: Text;
        lcCity: Text;
        lcLastName1: Text;
        lcLastName2: Text;
        lcBankTelecridt: Text;
        lcTextAmount: Text;
        lclStartDate: Date;
        lclendDate: Date;
        lclCount: integer;
        lcOption: integer;
        lcI: integer;
        lclBool1: Boolean;
        lcFile: File;
        lclAmount: Decimal;
        lclAmountLCY: Decimal;
        lclTotalCheckSum: Decimal;
        lclCheckSumDec: Decimal;
        lclAmountAux: Decimal;
        lcTotalAmount: Decimal;
        lcOutStreamObj: OutStream;
        lcTxtBase64Code: BigText;
    begin
        Clear(lcFile);
        Clear(lclCampos);
        lcdocumentNo := '';
        lcLastEmployeeNo := '';
        CreateTempFile();

        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        BankAccount2.Get(GenJnlBatch."Bank Account No. FICO");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        if GenJnlLine.FindSet() then begin
            lclStartDate := GenJnlLine."Posting Date";
            lclendDate := GenJnlLine."Posting Date";
            case GenJnlLine."Journal Batch Name" of
                'BCP-MN', 'BCP-ME':
                    begin
                        lcBankTelecridt := 'BCP';
                        lcdocumentNo := GenJnlLine."document No.";
                        lclTexto := '';
                        lclCount := 0;
                        lclAmount := 0;
                        lclAmountLCY := 0;
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Account No.");
                        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Vendor);
                        if GenJnlLine2.FindSet() then
                            repeat
                                lclRefer := Format(GenJnlLine2."document No.");
                                Vendor.Get(GenJnlLine2."Account No.");
                                Vendor.TestField("Preferred Bank Account Code");
                                VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                fnCheckVendorBankAccount(VendorBankAccount);
                                if (VendorBankAccount."Bank Account No." <> '') or (VendorBankAccount."Bank Account CCI" <> '') then begin
                                    lclCheckSumDec := 0;
                                    if (VendorBankAccount."Bank Account No." <> '') then
                                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', TextNumbers));
                                    if (VendorBankAccount."Bank Account CCI" <> '')
                                      and (VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account") then
                                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', TextNumbers));
                                    EVALUATE(lclCheckSumDec, CopyStr(lcBankAccountNo, 4, StrLen(lcBankAccountNo) - 3));
                                    lclTotalCheckSum += lclCheckSumDec;
                                end else
                                    Error('Cuenta Banco o CCI del empleado %1 no existe', Vendor."No.");
                                if lcLastEmployeeNo <> GenJnlLine2."Account No." then
                                    lclCount += 1;
                                lclAmount += GenJnlLine2.Amount;
                            //lcLastEmployeeNo := GenJnlLine2."Account No.";//15-02-2019
                            until GenJnlLine2.NEXT = 0;
                        BankAccount.Reset();
                        BankAccount.Get(GenJnlLine."Journal Batch Name");
                        EVALUATE(lclCheckSumDec, DelChr(CopyStr(BankAccount."Bank Account No.", 5, StrLen(BankAccount."Bank Account No.")), '=', '-'));
                        lclTotalCheckSum := lclTotalCheckSum + lclCheckSumDec;
                        lclTextFormatCuenta := DelChr(Format(lclTotalCheckSum), '=', ',');
                        lclCampos[1] := '#1H';//001-003
                        case BankAccount."Bank Account Type" of
                            BankAccount."Bank Account Type"::"Current Account":
                                lclCampos[2] := 'C';//004-004
                            BankAccount."Bank Account Type"::"Master Account":
                                lclCampos[2] := 'M';//004-004
                            else
                                lclCampos[2] := ' ';//004-004
                        end;
                        lcBankAccountNo := DelChr(BankAccount."Bank Account No.", '=', DelChr(BankAccount."Bank Account No.", '=', TextNumbers + '-'));
                        lclCampos[3] := lcBankAccountNo + PadStr('', 20 - StrLen(lcBankAccountNo), ' ');//005-024
                        if BankAccount."Currency Code" = '' then
                            lclCampos[4] := 'S/'//025-026
                        else
                            lclCampos[4] := 'US';//025-026
                        lclCampos[5] := PadStr('', 15 - StrLen(Format(fnGetFormatAmt(false, lclAmount))), '0') + fnGetFormatAmt(false, lclAmount);//027-041
                        lclCampos[6] := Format(lclendDate, 0, '<Day,2><Month,2><Year4>');//042-049
                        lclRefer := DelChr(lclRefer, '=', DelChr(lclRefer, '=', CharandNumbersandSpace));
                        lclCampos[7] := lclRefer + PadStr('', 20 - StrLen(lclRefer), ' ');//050-069
                        lclCampos[8] := PadStr('', 15 - StrLen(lclTextFormatCuenta), '0') + lclTextFormatCuenta;//070-084
                        lclCampos[9] := PadStr('', 6 - StrLen(Format(lclCount)), '0') + Format(lclCount);//085-090
                        lclCampos[10] := '1';//091-091
                        lclCampos[11] := PadStr('', 15 - StrLen(Format(lclCount)), ' ') + '0';//092-106
                        lclCampos[12] := '0';//107-107
                        For lcI := 1 TO 12 do
                            lclCampos[13] += lclCampos[lcI];
                        //lcFile.WRITE(lclCampos[13]);RPA
                        //ULN::PC 001  2020.06.01 v.001 begin 
                        insertLineToTempFile(lclCampos[13]);
                        //ULN::PC 001  2020.06.01 v.001 end
                        lcNameCode := '';
                        lcLastEmployeeNo := '';
                        Clear(lclCampos);
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetCurrentKey("Journal Template Name", "Journal Batch Name", "Account No.");
                        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Employee);
                        if GenJnlLine2.FindSet() then
                            repeat
                                //if lcLastEmployeeNo <> GenJnlLine2."Account No." then begin
                                Vendor.Get(GenJnlLine2."Account No.");
                                //Vendor.TestField("Preferred Bank Account Code");
                                GenJnlLine2.TestField("Recipient Bank Account");
                                VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                fnCheckVendorBankAccount(VendorBankAccount);
                                Clear(lclCampos);
                                lcNameCode := '';

                                lclNombreString := Vendor.Name;
                                //RPA               lclNombreString:=Vendor."Middle Name"+' ' +Vendor."Last Name" +', ' + Vendor."First Name";
                                //RPA lcNameCode := lclNombreString.Replace('Ñ', 'N');
                                lcNameCode := DelChr(lcNameCode, '=', DelChr(lcNameCode, '=', CharandNumbersandSpace));
                                lclAmount := 0;
                                fnGetNetAmount(GenJnlLine2, Vendor."No.", lclAmount, lclAmountLCY);
                                lclCampos[1] := ' ';//001-001
                                lclCampos[2] := '2';//002-002
                                case VendorBankAccount."Bank Account Type" of
                                    VendorBankAccount."Bank Account Type"::"Current Account":
                                        lclCampos[3] := 'C';//003-003
                                    VendorBankAccount."Bank Account Type"::"Master Account":
                                        lclCampos[3] := 'M';//003-003
                                    VendorBankAccount."Bank Account Type"::"Savings Account":
                                        lclCampos[3] := 'A';//003-003
                                    else
                                        lclCampos[3] := ' ';//003-003
                                end;
                                if VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account" then
                                    lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', TextNumbers))
                                else
                                    lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', TextNumbers));
                                lclCampos[4] := lcBankAccountNo + PadStr('', 20 - StrLen(lcBankAccountNo), ' ');//005-023

                                if StrLen(lcNameCode) > 40 then
                                    lclCampos[5] := CopyStr(lcNameCode, 1, 40)//024-063
                                else
                                    lclCampos[5] := lcNameCode + PadStr('', 40 - StrLen(lcNameCode), ' ');//024-063

                                if GenJnlLine2."Currency Code" = '' then
                                    lclCampos[6] := 'S/'//064-065
                                else
                                    lclCampos[6] := 'US';//064-065
                                lclCampos[7] := PadStr('', 15 - StrLen(fnGetFormatAmt(false, GenJnlLine2.Amount)), '0') + fnGetFormatAmt(false, GenJnlLine2.Amount);//066-080
                                lclRefer := 'Ref. Beneficiario ' + Vendor."No.";
                                lclRefer := CopyStr(lclRefer, 1, 40);
                                lclCampos[8] := lclRefer + PadStr('', 40 - StrLen(lclRefer), ' ');//081-120
                                lclCampos[9] := '0';//121-121
                                case Vendor."VAT Registration Type" of
                                    '1':
                                        lclCampos[10] := 'DNI';//122-124
                                    '4':
                                        lclCampos[10] := 'CE ';//122-124
                                    'A':
                                        lclCampos[10] := 'CI ';//122-124
                                    '7':
                                        lclCampos[10] := 'PAS';//122-124
                                    else
                                        Error(ErrorVendorSetupLegalDocument, Vendor."No.", Vendor."VAT Registration Type");
                                end;
                                lclCampos[11] := Vendor."No." + PadStr('', 12 - StrLen(Vendor."No."), ' ');//125-136
                                lclCampos[12] := '1';//137-137
                                For lcI := 1 TO 12 do
                                    lclCampos[13] += DelChr(lclCampos[lcI], '=', DelChr(lclCampos[lcI], '=', TextPermissionCharacters));

                                //RPA lcFile.WRITE(lclCampos[13]);
                                //ULN::PC 001  2020.06.01 v.001 begin 
                                insertLineToTempFile(lclCampos[13]);
                            //ULN::PC 001  2020.06.01 v.001 end                          
                            //end;
                            //lcLastEmployeeNo :=  GenJnlLine2."Account No.";
                            until GenJnlLine2.NEXT = 0;
                    end;// end case 'BCP-MN','BCP-ME'
                'BBVA-MN', 'BBVA-ME':
                    begin
                        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                        //RPA lcFile.CREATEOUTSTREAM(lcOutStreamObj);
                        //ULN::PC 001  2020.06.01 v.001 begin 
                        CreateTempFile();
                        //ULN::PC 001  2020.06.01 v.001 end
                        BankAccount.Get(GenJnlLine."Journal Batch Name");
                        lcOption := StrMenu('Premiun,Net', 1, 'Seleccione el tipo de telecrédito:');
                        case lcOption of
                            1:
                                begin
                                    lcBankTelecridt := 'BBVA-PREMIUN';
                                    lcdocumentNo := GenJnlLine."document No.";
                                    lclTexto := '';
                                    lclCount := 0;
                                    lclAmount := 0;
                                    GenJnlLine2.Reset();
                                    GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                                    GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                                    GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Employee);
                                    lclCount := GenJnlLine2.COUNT;
                                    fnGetNetAmount(pGenJnlLine, '', lclAmount, lclAmountLCY);

                                    lcltOTALtext := fnGetFormatAmt(false, lclAmount);
                                    lclCampos[1] := '700';
                                    lclCampos[2] := lclCampos[1] + DelChr(BankAccount."Bank Account No.", '=', DelChr(BankAccount."Bank Account No.", '=', TextNumbers));
                                    lclCampos[3] := lclCampos[2] + 'PEN' + PadStr('', 15 - StrLen(Format(lcltOTALtext)), '0') + lcltOTALtext;
                                    lclCampos[4] := lclCampos[3] + 'A';
                                    //if StrLen(Format(Date2DMY(lclStartDate,2))) = 1 then
                                    //lclCampos[5] := lclCampos[4]+ Format(Date2DMY(lclendDate,3)) + '0'+Format(Date2DMY(lclendDate,2)) + Format(Date2DMY(lclendDate,1))
                                    //else
                                    //lclCampos[5] := lclCampos[4]+ Format(Date2DMY(lclendDate,3)) + Format(Date2DMY(lclendDate,2)) + Format(Date2DMY(lclendDate,1));
                                    lclCampos[5] := lclCampos[4] + '00000000';
                                    lclCampos[6] := lclCampos[5] + ' ';
                                    lclCampos[7] := lclCampos[6] + lclRefer + PadStr('', 25 - StrLen(lclRefer), ' ') + PadStr('', 6 - StrLen(Format(lclCount)), '0') + Format(lclCount);
                                    lclCampos[7] := lclCampos[7] + 'S' + '000000000000000000' + PadStr('', 50 - StrLen(lclRefer), ' ');
                                    //lcOutStreamObj.WRITETEXT(lclCampos[7]);
                                    //lcTxtBase64Code.ADDTEXT(lclCampos[7]);
                                    //RPA lcFile.WRITE(lclCampos[7]);
                                    //ULN::PC 001  2020.06.01 v.001 begin 
                                    insertLineToTempFile(lclCampos[7]);
                                    //ULN::PC 001  2020.06.01 v.001 end
                                    GenJnlLine2.Reset();
                                    GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                                    GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                                    GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Employee);
                                    if GenJnlLine2.FindSet() then
                                        repeat
                                            //if lcLastEmployeeNo <> GenJnlLine2."Account No." then begin
                                            Vendor.Get(GenJnlLine2."Account No.");
                                            GenJnlLine2.TestField("Recipient Bank Account");
                                            VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                            fnCheckVendorBankAccount(VendorBankAccount);
                                            //                      if VendorBankAccount."Bank Account Type"=VendorBankAccount."Bank Account Type"::"Interbank Account" then
                                            //                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI",'=',DelChr(VendorBankAccount."Bank Account CCI",'=','0123456789 '))
                                            //                      else
                                            //                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.",'=',DelChr(VendorBankAccount."Bank Account No.",'=','0123456789 '));

                                            //                      lcLasNameCode := CONVERTSTR(Vendor."Middle Name",'Ñ','N');
                                            //                      lcLasNameCode := DelChr(lcLasNameCode,'=',DelChr(lcLasNameCode,'=',lcText0001));
                                            //                      lcLasname2Code := CONVERTSTR(Vendor."Last Name",'Ñ','N');
                                            //                      lcLasname2Code := DelChr(lcLasname2Code,'=',DelChr(lcLasname2Code,'=',lcText0001));
                                            //                      lcNameCode := CONVERTSTR(Vendor."First Name",'Ñ','N');
                                            //                      lcNameCode := DelChr(lcNameCode,'=',DelChr(lcNameCode,'=',lcText0001));
                                            Clear(lclCampos);
                                            lclCampos[1] := '002';
                                            case Vendor."VAT Registration Type" of
                                                '0':
                                                    lclCampos[1] += 'M';//Otros documentos
                                                '1':
                                                    lclCampos[1] += 'L';//DNI
                                                '4':
                                                    lclCampos[1] += 'E';//Carnet de extranjeria
                                                '6':
                                                    lclCampos[1] += 'R';//RUC
                                                '7':
                                                    lclCampos[1] += 'P';//Passaporte
                                            end;
                                            fnGetNetAmount(GenJnlLine2, Vendor."No.", lclAmount, lclAmountLCY);
                                            lclCampos[1] := lclCampos[1] + Vendor."No." + PadStr('', 12 - StrLen(Vendor."No."), ' ');
                                            if (VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account") then begin
                                                lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', '0123456789 '));
                                                lclCampos[1] := lclCampos[1] + 'I';
                                            end else begin
                                                lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', '0123456789 '));
                                                lclCampos[1] := lclCampos[1] + 'P';
                                            end;
                                            lclCampos[1] := lclCampos[1] + DelChr(lcBankAccountNo, '=', '-') + PadStr('', 20 - StrLen(DelChr(lcBankAccountNo, '=', '-')), ' ');
                                            lclCampos[1] += fnGetTextAdjust(Vendor.Name, 40, '<', ' ');
                                            lclCampos[1] += fnGetTextAdjust(fnGetFormatAmt(false, GenJnlLine2.Amount), 15, '>', '0');
                                            //                      lclCampos[1] := lclCampos[1] + PadStr('',15-StrLen(fnGetFormatAmt(false,GenJnlLine2.Amount)),'0') + fnGetFormatAmt(false,GenJnlLine2.Amount);
                                            lclCampos[1] := lclCampos[1] + lclRefer + PadStr('', 141 - StrLen(lclRefer), ' ');
                                            //lcOutStreamObj.WRITETEXT(lclCampos[1]);
                                            //lcTxtBase64Code.ADDTEXT(lclCampos[1]);
                                            //RPA lcFile.WRITE(lclCampos[1]);
                                            //ULN::PC 001  2020.06.01 v.001 begin 
                                            insertLineToTempFile(lclCampos[1]);
                                        //ULN::PC 001  2020.06.01 v.001 end                                          

                                        //end;
                                        //lcLastEmployeeNo :=  GenJnlLine2."Account No.";
                                        until GenJnlLine2.NEXT = 0;

                                    Clear(lcTxtBase64Code);
                                    Clear(lcOutStreamObj);
                                end;
                            2:
                                begin
                                    lcBankTelecridt := 'BBVA-NET';
                                    lcdocumentNo := GenJnlLine."document No.";
                                    lclTexto := '';
                                    lclCount := 0;
                                    lclAmount := 0;
                                    GenJnlLine2.Reset();
                                    GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                                    GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                                    GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Employee);
                                    if GenJnlLine2.FindSet() then
                                        repeat
                                            Vendor.Get(GenJnlLine2."Account No.");
                                            GenJnlLine2.TestField("Recipient Bank Account");
                                            VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                            fnCheckVendorBankAccount(VendorBankAccount);
                                            //                  lcLasNameCode := CONVERTSTR(Vendor."Middle Name",'Ñ','N');
                                            //                  lcLasNameCode := DelChr(lcLasNameCode,'=',DelChr(lcLasNameCode,'=',lcText0001));
                                            //                  lcLasname2Code := CONVERTSTR(Vendor."Last Name",'Ñ','N');
                                            //                  lcLasname2Code := DelChr(lcLasname2Code,'=',DelChr(lcLasname2Code,'=',lcText0001));
                                            //                  lcNameCode := CONVERTSTR(Vendor."First Name",'Ñ','N');
                                            //                  lcNameCode := DelChr(lcNameCode,'=',DelChr(lcNameCode,'=',lcText0001));
                                            Clear(lclCampos);

                                            lclCampos[1] := fnGetTextAdjust(GenJnlLine2."Account No.", 7, '<', ' ');
                                            lclCampos[1] += fnGetTextAdjust(Vendor.Name, 31, '<', ' ');
                                            //                  lclCampos[1] += CopyStr(lcLasNameCode + ' ' + lcLasname2Code + ' ' + lcNameCode,1,31)
                                            //                  + PadStr('',31-StrLen(CopyStr(lcLasNameCode + ' ' + lcLasname2Code + ' ' + lcNameCode,1,31)),' ');
                                            lclCampos[1] += 'LIMA      LIMA             LIMA      LIMA      REMUNERACIONES    REMUNERACIONES    ';
                                            lclCampos[1] += fnGetTextAdjust(CONVERTSTR(fnGetFormatAmt(true, GenJnlLine2.Amount), '.', ','), 10, '>', '0');
                                            //                  lclCampos[1] += PadStr('',10-StrLen(fnGetFormatAmt(true,GenJnlLine2.Amount)),'0') + 
                                            //                  CONVERTSTR(fnGetFormatAmt(true,GenJnlLine2.Amount),'.',',');
                                            if (VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account") then
                                                lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', '0123456789 '))
                                            else
                                                lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', '0123456789 '));
                                            lclCampos[1] := lclCampos[1] + DelChr(lcBankAccountNo, '=', '-') + PadStr('', 20 - StrLen(DelChr(lcBankAccountNo, '=', '-')), ' ');
                                            lclCampos[1] := DelChr(lclCampos[1], '=', DelChr(lclCampos[1], '=', TextPermissionCharacters));
                                            //RPA lcFile.WRITE(lclCampos[1]);
                                            //ULN::PC 001  2020.06.01 v.001 begin 
                                            insertLineToTempFile(lclCampos[1]);
                                        //ULN::PC 001  2020.06.01 v.001 end
                                        until GenJnlLine2.NEXT = 0;
                                end;
                            0:
                                Error('Debe seleccionar un tipo de telecrédito');
                        end;

                        //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
                    end;// end case 'BBVA-MN','BBVA-ME'
                'inTER-MN', 'inTER-ME':
                    begin
                        BankAccount.Get(GenJnlLine."Journal Batch Name");
                        lcBankTelecridt := 'inTER';
                        lcdocumentNo := GenJnlLine."document No.";
                        lclTexto := '';
                        lclCount := 0;
                        lclAmount := 0;
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Employee);
                        if GenJnlLine2.FindSet() then
                            repeat
                                //if lcLastEmployeeNo <> GenJnlLine2."Account No." then begin
                                Vendor.Get(GenJnlLine2."Account No.");
                                GenJnlLine2.TestField("Recipient Bank Account");
                                VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                fnCheckVendorBankAccount(VendorBankAccount);
                                lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', TextNumbers));

                                fnGetNetAmount(GenJnlLine2, Vendor."No.", lclAmount, lclAmountLCY);
                                lclCampos[1] := '02';//001-002
                                lclCampos[1] += Vendor."No." + PadStr('', 20 - StrLen(Vendor."No."), ' ');//003-022
                                lclCampos[1] += PadStr('', 29, ' ');//023-051
                                if BankAccount2."Currency Code" = '' then
                                    lclCampos[1] += '01'//052-053
                                else
                                    lclCampos[1] += '10';//052-053
                                lcTextAmount := fnGetFormatAmt(false, GenJnlLine2.Amount);
                                lclCampos[1] += PadStr('', 15 - StrLen(lcTextAmount), '0') + lcTextAmount;//054-068
                                if VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account" then begin
                                    lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', TextNumbers));
                                    lclCampos[1] += '1';//069-069
                                    lclCampos[1] += '99'//070-071
                                end else
                                    if VendorBankAccount."Check Manager" then begin
                                        lclCampos[1] += '0';//069-069
                                        lclCampos[1] += '11'//070-071
                                    end else begin
                                        lclCampos[1] += '0';//069-069
                                        lclCampos[1] += '09';//070-071
                                        case VendorBankAccount."Bank Account Type" of
                                            VendorBankAccount."Bank Account Type"::"Current Account":
                                                lclCampos[1] += '001';//072-074
                                            VendorBankAccount."Bank Account Type"::"Savings Account":
                                                lclCampos[1] += '002';//072-074
                                        end;
                                    end;
                                if GenJnlLine2."Currency Code" = '' then
                                    lclCampos[1] += '01'//075-076
                                else
                                    lclCampos[1] += '10';//075-076
                                lclCampos[1] += lcBankAccountNo + PadStr('', 23 - StrLen(lcBankAccountNo), ' ');//077-099
                                lclCampos[1] += 'P';//100-100
                                case Vendor."VAT Registration Type" of
                                    //                  '0' : lclCampos[1] += '';//101-102 Otros documentos
                                    '1':
                                        lclCampos[1] += '01';//101-102 DNI
                                    '4':
                                        lclCampos[1] += '03';//101-102 Carnet de extranjeria
                                    '6':
                                        lclCampos[1] += '02';//101-102 RUC
                                                             //                  '7' : lclCampos[1] += '';//101-102 Passaporte
                                    'A':
                                        lclCampos[1] += '04';//101-102 CI
                                    else
                                        Error(ErrorVendorSetupLegalDocument, Vendor."No.", Vendor."VAT Registration Type");
                                end;
                                lclCampos[1] += Vendor."No." + PadStr('', 15 - StrLen(Vendor."No."), ' ');//103-117
                                lcLastName1 := '';
                                lcLastName2 := '';

                                //                if STRPOS(Vendor.Name,' ')>0 then begin
                                //                  lcLastName1 := CopyStr(Vendor."Last Name",1,STRPOS(Vendor."Last Name",' ')-1);
                                //                  lcLastName2 := CopyStr(Vendor."Last Name",STRPOS(Vendor."Last Name",' ')+1,20);
                                //                  lcLastName1 := CopyStr(lcLastName1,1,20);
                                //                  lcLastName2 := CopyStr(lcLastName2,1,20);
                                //                  lclCampos[1] += lcLastName1 +  PadStr('',20-StrLen(lcLastName1),' ');//118-137
                                //                  lclCampos[1] += lcLastName2 +  PadStr('',20-StrLen(lcLastName2),' ');//138-157
                                //                end else begin
                                //                  if StrLen(Vendor."Last Name")>20 then 
                                //                    lclCampos[1] += CopyStr(Vendor."Last Name",1,20)
                                //                  else
                                //                    lclCampos[1] += Vendor."Last Name" +  PadStr('',20-StrLen(Vendor."Last Name"),' ');
                                //                end;
                                //                lclCampos[1] += Vendor."First Name" +  PadStr('',20-StrLen(Vendor."First Name"),' ');//158-177
                                lclCampos[1] += fnGetTextAdjust(Vendor.Name, 60, '<', ' ');//118-177
                                lclCampos[1] += '01000000000000000      ';//PadStr('',23,' ');//178-200
                                lclCampos[1] := DelChr(lclCampos[1], '=', DelChr(lclCampos[1], '=', TextPermissionCharacters));
                                //RPA lcFile.WRITE(lclCampos[1]);
                                //ULN::PC 001  2020.06.01 v.001 begin 
                                insertLineToTempFile(lclCampos[1]);
                            //ULN::PC 001  2020.06.01 v.001 end
                            //end;
                            //lcLastEmployeeNo :=  GenJnlLine2."Account No.";
                            until GenJnlLine2.NEXT = 0;
                    end;// end case 'inTER-MN','inTER-ME'
            end;
        end;

        if lclStartDate = 0D then
            exit;

        FA := Format(Date2DMY(lclStartDate, 3));
        FD := Format(Date2DMY(lclendDate, 1));
        if StrLen(Format(Date2DMY(lclendDate, 2))) = 1 then
            FM := '0' + Format(Date2DMY(lclendDate, 2))
        else
            FM := Format(Date2DMY(lclendDate, 2));


        case lcBankTelecridt of
            'BCP':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BCP-%1-%2-%3', FD, FM, FA), 'BCP');
            'BBVA-PREMIUN':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BBVA-PREMIUN-%1-%2-%3', FD, FM, FA), 'BBVA-PREMIUN');
            'BBVA-NET':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BBVA-NET-%1-%2-%3', FD, FM, FA), 'BBVA-NET');
            'inTER':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('inTERBANK-%1-%2-%3', FD, FM, FA), 'inTER');
            'SCOT':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('SCOTIABANK-%1-%2-%3', FD, FM, FA), 'SCOT');
            'CITI':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('CITIBANK-%1-%2-%3', FD, FM, FA), 'CITI');
        end;
    end;

    procedure fnGenerateVendorTelecreditScotiabank(pGenJnlLine: Record "Gen. Journal Line")
    var
        lclínearray: array[50] of Text[80];
        lcWindow: Dialog;
        lcTotalRecords: integer;
        lcRecVendLedgrEntry: Record "Vendor Ledger Entry";
        lcText0001: Label 'Número Factura Proveedor no existe en Mov. Proveedor para la factura a liquidar %1 en la línea %2.';
        lcOperationAmount: Decimal;
        Employee: Record Employee;
        //EmployeeBankAccount: Record "Employee Bank Account";
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TelecreditUtility: Codeunit "Telecredit Utility";
        lcNameCode: Code[75];
        lcLasNameCode: Code[75];
        lcLasname2Code: Code[75];
        lclEmployeeCode: Code[20];
        lcdocumentNo: Code[20];
        lcBankAccountNo: Code[20];
        lcSecuenceCode: Code[20];
        lcLastEmployeeNo: Code[20];
        lclTexto: Text[1024];
        lclCampos: Text[1024];
        lclRefer: Text[240];
        lcltOTALtext: Text;
        FA: Text;
        FM: Text;
        FD: Text;
        lclTextFormatCuenta: Text;
        lclAmountTxt: Text;
        lcFullName: Text;
        lcDay: Text;
        lcMonth: Text;
        lcYear: Text;
        lcCity: Text;
        lcLastName1: Text;
        lcLastName2: Text;
        lcBankTelecridt: Text;
        lcTextAmount: Text;
        lclStartDate: Date;
        lclendDate: Date;
        lclCount: integer;
        lcOption: integer;
        lcI: integer;
        lclBool1: Boolean;
        lcFile: File;
        lclAmount: Decimal;
        lclAmountLCY: Decimal;
        lclTotalCheckSum: Decimal;
        lclCheckSumDec: Decimal;
        lclAmountAux: Decimal;
        lcTotalAmount: Decimal;
        lcOutStreamObj: OutStream;
        lcTxtBase64Code: BigText;
        //lcText0002: Label 'El campo %1 debe unl valor distinto a %2.', ESP = 'El campo %1 debe unl valor distinto a %2.', ESM = 'El campo %1 debe unl valor distinto a %2.';
        //lcText0003: Label 'El banco %1 solo puede ser configurado como tipo: "Current Account" o "Master Account".', ESP = 'El banco %1 solo puede ser configurado como tipo: "Current Account" o "Master Account".', ESM = 'El banco %1 solo puede ser configurado como tipo: "Current Account" o "Master Account".';
        //lcText0004: Label 'Error de configuración. El empleado %1, tiene configurado tipo de documento de identidad "%2". BCP solo soporta los tipos "1","4","7" y "A".', ESM = 'Error de configuración. El empleado %1, tiene configurado tipo de documento de identidad "%2". BCP solo soporta los tipos "1","4","7" y "A".', ESP = 'Error de configuración. El empleado %1, tiene configurado tipo de documento de identidad "%2". BCP solo soporta los tipos "1","4","7" y "A".';
        //lcText0005: Label 'El empleado %1 no puede tener los valores (0,7) en "documento SUNAT"', ESP = 'El empleado %1 no puede tener los valores (0,7) en "documento SUNAT"', ESM = 'El empleado %1 no puede tener los valores (0,7) en "documento SUNAT"';
        CompanyInf: Record "Company inFormation";
        lclLine: integer;
        lclNotaCargo: Text;
        lclGenJLine2: Record "Gen. Journal Line";
        lclTipoPago: Text;
        lclBank: Record "Bank Account";
        lclSoles: Boolean;
        lclChekSum: Text[1024];
        lclNumCount2: integer;
        pBankAmount: Decimal;
        lclFile: File;
        lclWindow: Dialog;
        ConcatBanco: Text;
        lclGenJnlLine: Record "Gen. Journal Line";
        lclVendorBankAccount: Record "Vendor Bank Account";
        Checksum: Biginteger;
        lclCampos2: Text;
        lcMultiple: Boolean;
        lclVendor: Record Vendor;
        lcNameVendor: Text;
        lcVendorinvoiceNo: Code[30];
        lcRecPurchinvHeader: Record "Purch. inv. Header";
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcRecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lcAdditionalReference: Text;
        gNewAcc: Text;
        lclint: integer;
        lcAmount: Decimal;
        lcAmountText: Text;
        lcFileName: Text;
        lclRecVendor: Record Vendor;
        lclRecGenJournalLine: Record "Gen. Journal Line";
        VendorBankAccount: Record "Vendor Bank Account";
        lcTotalLineText: Text[1024];
        lcCurrentsRecords: integer;
        lclRecVendorBankAccount: Record "Vendor Bank Account";
        lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcSerieinvoice: Text;
        lcNumberinvoice: array[2] of Text;
        lclNumdoc: Text;
        lcRecGenJnlBatch: Record "Gen. Journal Batch";
    begin
        Clear(lclínearray);
        Clear(lcFile);
        //--
        CreateTempFile();
        //--
        lcWindow.Open(Processing);

        lcRecGenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        lcRecGenJnlBatch.TestField("Bank Account No. FICO");

        lclRecGenJournalLine.Reset();
        lclRecGenJournalLine.Reset();
        lclRecGenJournalLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        lclRecGenJournalLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        lclRecGenJournalLine.SetRange("Account Type", pGenJnlLine."Account Type"::Vendor);
        lcTotalRecords := lclRecGenJournalLine.COUNT;
        if lclRecGenJournalLine.FindSet() then begin
            repeat
                Clear(lclínearray);
                lclRecVendor.Reset();
                lclRecVendor.SetRange("No.", lclRecGenJournalLine."Account No.");
                if lclRecVendor.FindSet() then begin
                    case lclRecVendor."VAT Registration Type" of
                        '1':
                            begin
                                //1. Ruc del proveedor
                                lclínearray[1] := Format(lclRecVendor."VAT Registration No.");
                                if StrLen(lclRecVendor."VAT Registration No.") <> 8 then
                                    Error(FieldDiferentValueinLine, lclRecVendor.FieldCaption("VAT Registration No."), lclRecVendor."VAT Registration No.", lclRecGenJournalLine."Line No.");
                            end;

                        '6':
                            begin
                                //1. Ruc del proveedor
                                lclínearray[1] := Format(lclRecVendor."VAT Registration No.");
                                if StrLen(lclRecVendor."VAT Registration No.") <> 11 then
                                    Error(FieldDiferentValueinLine, lclRecVendor.FieldCaption("VAT Registration No."), lclRecVendor."VAT Registration No.", lclRecGenJournalLine."Line No.");
                            end;
                        else
                            lclínearray[1] := ' ';
                    end;


                    if StrLen(lclínearray[1]) < 11 then
                        lclínearray[1] := lclínearray[1] + PadStr('', 11 - StrLen(lclínearray[1]), ' ');

                    //2. Nombre del Proveedor
                    lclínearray[2] := lclRecVendor.Name;
                    if StrLen(lclínearray[2]) < 60 then
                        lclínearray[2] := lclínearray[2] + PadStr('', 60 - StrLen(lclínearray[2]), ' ');

                    //6. Forma de Pago
                    lclRecGenJournalLine.TestField("Recipient Bank Account");
                    if lclRecVendorBankAccount.Get(lclRecGenJournalLine."Account No.", lclRecGenJournalLine."Recipient Bank Account") then begin
                        if lclRecVendorBankAccount."Check Manager" then
                            lclínearray[6] := '1'
                        else begin
                            if lcRecGenJnlBatch."Bank Account No. FICO" = lclRecVendorBankAccount."Reference Bank Acc. No." then begin
                                case lclRecVendorBankAccount."Bank Account Type" of
                                    lclRecVendorBankAccount."Bank Account Type"::"Current Account":
                                        lclínearray[6] := '2';
                                    lclRecVendorBankAccount."Bank Account Type"::"Savings Account":
                                        lclínearray[6] := '3';
                                    lclRecVendorBankAccount."Bank Account Type"::"Interbank Account":
                                        begin
                                            lclínearray[6] := '4';
                                            if StrLen(DelChr(lclRecVendorBankAccount."Bank Account CCI", '=', '-')) = 20 then
                                                Error(BankAccountTypeError, lclRecVendor.Name, lclRecVendorBankAccount.Code);
                                            lclínearray[9] := DelChr(lclRecVendorBankAccount."Bank Account CCI", '=', '-');
                                        end;
                                end;
                            end else
                                lclínearray[6] := '4';
                            if lclínearray[6] in ['2', '3'] then
                                lcBankAccountNo := lclRecVendorBankAccount."Bank Account No.";
                        end;
                    end else
                        Error(VendorWihtoutBank, lclRecVendor."No.", lclRecGenJournalLine."Line No.");
                    //lclínearray[9] := '01234567891234567890';

                    //10. Email proveedor
                    lclínearray[8] := CopyStr(lclRecVendor."E-Mail", 1, 30);
                    if StrLen(lclínearray[8]) < 30 then
                        lclínearray[8] := lclínearray[8] + PadStr('', 30 - StrLen(lclínearray[8]), ' ');

                end else
                    Error('El Cód. Proveedor ingresado en la línea %1, no existe ne la ficha de Proveedores', lclRecGenJournalLine."Line No.");

                if lclRecGenJournalLine."Applies-to doc. No." <> '' then begin
                    lclRecVendorLedgerEntry.Reset();
                    lclRecVendorLedgerEntry.SetRange("Vendor No.", lclRecGenJournalLine."Account No.");
                    lclRecVendorLedgerEntry.SetRange(Open, true);
                    lclRecVendorLedgerEntry.SetRange("Currency Code", lclRecGenJournalLine."Currency Code");
                    lclRecVendorLedgerEntry.SetRange("document No.", lclRecGenJournalLine."Applies-to doc. No.");
                    if lclRecVendorLedgerEntry.FindSet() then begin

                        //3. Numero de Factura
                        if lclRecVendorLedgerEntry."External document No." <> '' then begin
                            lcSerieinvoice := CopyStr(lclRecVendorLedgerEntry."External document No.", 1, STRPOS(lclRecVendorLedgerEntry."External document No.", '-'));
                            lcNumberinvoice[1] := CopyStr(lclRecVendorLedgerEntry."External document No.",
                                                          STRPOS(lclRecVendorLedgerEntry."External document No.", '-') + 1,
                                                          StrLen(lclRecVendorLedgerEntry."External document No."));
                            lcI := 1;
                            WHILE CopyStr(lcNumberinvoice[1], lcI, 1) = '0' do
                                lcI += 1;

                            lcNumberinvoice[2] := CopyStr(lcNumberinvoice[1], lcI, StrLen(lcNumberinvoice[1]));
                            lclNumdoc := lcSerieinvoice + lcNumberinvoice[2];
                            lclNumdoc := DelChr(lclNumdoc, '=', 'ACDGHIJKLMNÑOPQSTUVWXYZ');
                            if StrLen(lclNumdoc) < 14 then
                                lclínearray[3] := lclNumdoc + PadStr('', 14 - StrLen(lclNumdoc), ' ');
                        end else
                            Error('El Num. doc. a Liquidar en la línea %1, no tiene un Núm. doc. Externo de Proveedor'
                               , lclRecGenJournalLine."Line No.");

                        //4. Fecha Emision Factura
                        if lclRecVendorLedgerEntry."document Date" <> 0D then
                            lclínearray[4] := Format(lclRecVendorLedgerEntry."document Date", 0, '<Year4><Month,2><Day,2>')
                        else
                            Error('El Num. doc. a Liquidar en la línea %1, no tiene fecha emisión'
                               , lclRecGenJournalLine."Line No.");

                        //13. Fecha vencimiento Factura
                        if lclRecVendorLedgerEntry."Due Date" <> 0D then begin
                            lclínearray[13] := Format(lclRecVendorLedgerEntry."Due Date", 0, '<Year4><Month,2><Day,2>')
                        end else
                            Error('Debe seleccionar fecha vencimiento para la línea %1.', lclRecGenJournalLine."Line No.");

                    end;
                end else begin
                    //++ begin Anticipos
                    if lclRecGenJournalLine."External document No." <> '' then begin
                        if STRPOS(lclRecGenJournalLine."External document No.", '-') > 0 then begin
                            lcSerieinvoice := CopyStr(lclRecGenJournalLine."External document No.", 1,
                                                      STRPOS(lclRecGenJournalLine."External document No.", '-'));
                            lcNumberinvoice[1] := CopyStr(lclRecGenJournalLine."External document No.",
                                                          STRPOS(lclRecGenJournalLine."External document No.", '-') + 1,
                                                          StrLen(lclRecGenJournalLine."External document No."));

                            //lcNumberinvoice[2] := CopyStr(lcNumberinvoice[1],lcI,StrLen(lcNumberinvoice[1]));
                            lclNumdoc := lcSerieinvoice + lcNumberinvoice[1];
                            if StrLen(lclNumdoc) < 14 then
                                lclínearray[3] := lclNumdoc + PadStr('', 14 - StrLen(lclNumdoc), ' ');
                        end else begin
                            if StrLen(lclRecGenJournalLine."External document No.") < 14 then
                                lclínearray[3] := lclRecGenJournalLine."External document No." + PadStr('', 14 - StrLen(lclRecGenJournalLine."External document No."), ' ')
                            else
                                lclínearray[3] := lclRecGenJournalLine."External document No.";
                        end;
                    end else
                        Error('El Num. doc. a Liquidar en la línea %1, no tiene un Núm. doc. Externo de Proveedor'
                           , lclRecGenJournalLine."Line No.");

                    //4. Fecha Emision Factura
                    if lclRecGenJournalLine."document Date" <> 0D then
                        lclínearray[4] := Format(lclRecGenJournalLine."document Date", 0, '<Year4><Month,2><Day,2>')
                    else
                        Error('El Num. doc. a Liquidar en la línea %1, no tiene fecha emisión'
                           , lclRecGenJournalLine."Line No.");

                    //13. Fecha vencimiento Factura
                    if lclRecGenJournalLine."Due Date" <> 0D then
                        lclínearray[13] := Format(lclRecGenJournalLine."Due Date", 0, '<Year4><Month,2><Day,2>')
                    else
                        Error('Debe ingresar fecha de vencimiento para la línea %1.', lclRecGenJournalLine."Line No.");
                    //++ end
                end;

                //5. Monto a Pagar o Descontar
                if lclRecGenJournalLine.Amount < 0 then
                    lclínearray[5] := fnGetFormatAmt(false, lclRecGenJournalLine.Amount + ABS(lclRecGenJournalLine."Retention Amount"))
                else
                    lclínearray[5] := fnGetFormatAmt(false, lclRecGenJournalLine.Amount - ABS(lclRecGenJournalLine."Retention Amount"));
                //     DelChr(Format(lclRecGenJournalLine.Amount-ABS(lclRecGenJournalLine."Retention Amount")),'=',',.-');
                if StrLen(lclínearray[5]) < 11 then
                    lclínearray[5] := PadStr('', 11 - StrLen(lclínearray[5]), '0') + lclínearray[5];

                if (lclRecGenJournalLine.Amount - lclRecGenJournalLine."Retention Amount") < 0 then
                    lclínearray[5] := '-' + lclínearray[5];

                //7. Codigo de oficina

                //8. Codigo de Cuenta
                if StrLen(lcBankAccountNo) > 11 then
                    lclínearray[7] := CopyStr(lcBankAccountNo, StrLen(lcBankAccountNo) - 11, StrLen(lcBankAccountNo))
                else
                    lclínearray[7] := lcBankAccountNo + PadStr('', (11 - StrLen(lcBankAccountNo)), ' ');

                //9. Flag Simple Pay
                //lclínearray[9] := '*';

                //11. Codigo de cuenta interbancaria
                lclínearray[9] := lclínearray[9] + PadStr('', (20 - StrLen(lclínearray[9])), ' ');

                //12. Marca Factoring Electronico
                lclínearray[12] := PadStr('', (30 - StrLen(lclínearray[8])), ' ');
                lcTotalLineText := '';
                For lcI := 1 TO 20 do
                    lcTotalLineText += lclínearray[lcI];
                //ULN::PC 001  2020.06.01 v.001 begin 
                /*  lcFile.WRITE(lcTotalLineText); Obsolete*/
                insertLineToTempFile(lcTotalLineText);
                //ULN::PC 001  2020.06.01 v.001 end


                lcCurrentsRecords += 1;
                lcWindow.UPDATE(1, ROUND(lcTotalRecords / lcCurrentsRecords * 10000, 1));

            until lclRecGenJournalLine.NEXT = 0;
        end;

        lcWindow.CLOSE;
        PostFileToControlFileRecord(pGenJnlLine."document No.", STRSUBSTNO(TeleCreditdocumentLabel, 'ScotiaBank', pGenJnlLine."document No."), 'ScotiaBank');


    end;

    procedure fnGeneratePaymentTelecredit(pGenJnlLine: Record "Gen. Journal Line")
    var
        lcLastVendorNo: Code[20];
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        lclínearray: array[50] of Text[80];
        lcWindow: Dialog;
        lcTotalRecords: integer;
        lcRecVendLedgrEntry: Record "Vendor Ledger Entry";
        lcText0001: Label 'Número Factura Proveedor no existe en Mov. Proveedor para la factura a liquidar %1 en la línea %2.';
        lcOperationAmount: Decimal;
        Employee: Record Employee;
        //EmployeeBankAccount: Record "Employee Bank Account";
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TelecreditUtility: Codeunit "Telecredit Utility";
        lcNameCode: Code[75];
        lcLasNameCode: Code[75];
        lcLasname2Code: Code[75];
        lclEmployeeCode: Code[20];
        lcdocumentNo: Code[20];
        lcBankAccountNo: Code[20];
        lcSecuenceCode: Code[20];
        lcLastEmployeeNo: Code[20];
        lclTexto: Text[1024];
        lclCampos: array[50] of Text[1024];
        lclRefer: Text[240];
        lcltOTALtext: Text;
        FA: Text;
        FM: Text;
        FD: Text;
        lclTextFormatCuenta: Text;
        lclAmountTxt: Text;
        lcFullName: Text;
        lcDay: Text;
        lcMonth: Text;
        lcYear: Text;
        lcCity: Text;
        lcLastName1: Text;
        lcLastName2: Text;
        lcBankTelecridt: Text;
        lcTextAmount: Text;
        lclStartDate: Date;
        lclendDate: Date;
        lclCount: integer;
        lcOption: integer;
        lcI: integer;
        lclBool1: Boolean;
        lcFile: File;
        lclAmount: Decimal;
        lclAmountLCY: Decimal;
        lclTotalCheckSum: Decimal;
        lclCheckSumDec: Decimal;
        lclAmountAux: Decimal;
        lcTotalAmount: Decimal;
        lcOutStreamObj: OutStream;
        lcTxtBase64Code: BigText;
        lclLine: integer;
        lclNotaCargo: Text;
        lclGenJLine2: Record "Gen. Journal Line";
        lclTipoPago: Text;
        lclBank: Record "Bank Account";
        lclSoles: Boolean;
        lclChekSum: Text[1024];
        lclNumCount2: integer;
        pBankAmount: Decimal;
        lclFile: File;
        lclWindow: Dialog;
        ConcatBanco: Text;
        lclGenJnlLine: Record "Gen. Journal Line";
        lclVendorBankAccount: Record "Vendor Bank Account";
        Checksum: Biginteger;
        lclCampos2: Text;
        lcMultiple: Boolean;
        lclVendor: Record Vendor;
        lcNameVendor: Text;
        lcVendorinvoiceNo: Code[30];
        lcRecPurchinvHeader: Record "Purch. inv. Header";
        lclVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcRecPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        lcAdditionalReference: Text;
        gNewAcc: Text;
        lclint: integer;
        lcAmount: Decimal;
        lcAmountText: Text;
        lcFileName: Text;
        lclRecVendor: Record Vendor;
        lclRecGenJournalLine: Record "Gen. Journal Line";
        lcTotalLineText: Text[1024];
        lcCurrentsRecords: integer;
        lclRecVendorBankAccount: Record "Vendor Bank Account";
        lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcSerieinvoice: Text;
        lcNumberinvoice: array[2] of Text;
        lclNumdoc: Text;
        lcRecGenJnlBatch: Record "Gen. Journal Batch";
    begin
        Clear(lcFile);
        Clear(lclCampos);
        lcdocumentNo := '';
        lcLastVendorNo := '';
        //ULN::PC 001  2020.06.01 v.001 begin 
        /*               lcFile.CREATETEMPFILE(TEXTENCODinG::UTF8);
                lcFile.TEXTMODE(true); Obsolete*/
        CreateTempFile();
        //ULN::PC 001  2020.06.01 v.001 end      

        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        BankAccount2.Get(GenJnlBatch."Bank Account No. FICO");
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        if GenJnlLine.FindSet() then begin
            lclStartDate := GenJnlLine."Posting Date";
            lclendDate := GenJnlLine."Posting Date";
            case GenJnlLine."Journal Batch Name" of
                'CITI-MN', 'CITI-ME':
                    begin
                        //****************************************** CITIBANK *******************************************
                        BankAccount.Get(GenJnlLine."Journal Batch Name");
                        lcBankTelecridt := 'CITI';
                        lcdocumentNo := GenJnlLine."document No.";
                        lclTexto := '';
                        lcSecuenceCode := '00000001';
                        lclTotalCheckSum := 0;
                        lclCount := 0;
                        lclAmount := 0;
                        GenJnlLine2.Reset();
                        GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                        GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                        GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Vendor);
                        if GenJnlLine2.FindSet() then
                            repeat
                                if lcLastVendorNo <> GenJnlLine2."Account No." then begin
                                    lclCount += 1;
                                    Vendor.Get(GenJnlLine2."Account No.");
                                    GenJnlLine2.TestField("Recipient Bank Account");
                                    VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                                    if (VendorBankAccount."Reference Bank Acc. No." <> GenJnlBatch."Bank Account No. FICO") then
                                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', '0123456789 '))
                                    else
                                        lcBankAccountNo := DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', '0123456789 '));
                                    //lcBankAccountNo := DelChr(EmployeeBankAccount."Bank Account No.",'=',DelChr(EmployeeBankAccount."Bank Account No.",'=','0123456789'));
                                    //if StrLen(lcBankAccountNo)>10 then
                                    //   Error('El número de digitos debe ser menor o igual a 10 para la cuenta bancaria del empleado %1.',Employee."No.");


                                    lcFullName := Vendor.Name;

                                    lcDay := Format(Date2DMY(lclStartDate, 1));
                                    lcMonth := Format(Date2DMY(lclStartDate, 2));
                                    lcYear := CopyStr(Format(Date2DMY(lclStartDate, 3)), 3, 4);
                                    if StrLen(lcDay) < 2 then
                                        lcDay += '0' + lcDay;
                                    if StrLen(lcMonth) < 2 then
                                        lcMonth += '0' + lcMonth;

                                    fnGetNetAmountVendor(GenJnlLine2, Vendor."No.", lclAmount, lclAmountLCY);
                                    lclTotalCheckSum += lclAmount;
                                    lclCampos[1] := 'PAY604';
                                    lclCampos[3] += PadStr('', 10 - StrLen(BankAccount2."Bank Account No."), '0') + BankAccount2."Bank Account No.";
                                    lclCampos[4] += lcYear + lcMonth + lcDay;

                                    if VendorBankAccount."Check Manager" then
                                        lclCampos[2] := '073'
                                    else
                                        if (VendorBankAccount."Reference Bank Acc. No." <> GenJnlBatch."Bank Account No. FICO") then
                                            lclCampos[2] := '071'
                                        else
                                            lclCampos[2] := '072';

                                    lclCampos[5] += lclCampos[2];
                                    if GenJnlLine."Applies-to doc. No." <> '' then
                                        lclCampos[6] += PadStr('', 15 - StrLen(CopyStr(GenJnlLine."Applies-to doc. No.", 1, 15)), ' ') + CopyStr(GenJnlLine."Applies-to doc. No.", 1, 15)
                                    else begin
                                        if GenJnlLine."External document No." <> '' then
                                            lclCampos[6] += PadStr('', 15 - StrLen(CopyStr(GenJnlLine."External document No.", 1, 15)), ' ') + CopyStr(GenJnlLine."External document No.", 1, 15)
                                        else
                                            lclCampos[6] += PadStr('', 15, ' ');
                                    end;
                                    //lclCampos[1] += lcSecuenceCode;
                                    lclCampos[7] += PadStr('', 8 - StrLen(CopyStr(lcSecuenceCode, 1, 8)), ' ') + CopyStr(lcSecuenceCode, 1, 8);
                                    lclCampos[8] += PadStr('', 20 - StrLen(CopyStr(Vendor."VAT Registration No.", 1, 20)), ' ') + CopyStr(Vendor."VAT Registration No.", 1, 20);
                                    if GenJnlLine."Currency Code" = '' then
                                        lclCampos[9] += 'PEN'
                                    else
                                        lclCampos[9] += 'USD';
                                    lclCampos[10] += PadStr('', 20 - StrLen(CopyStr(Vendor."VAT Registration No.", 1, 20)), ' ') + CopyStr(Vendor."VAT Registration No.", 1, 20);
                                    lclCampos[11] += PadStr('', 15 - StrLen(fnGetFormatAmt(false, lclAmount)), '0') + fnGetFormatAmt(false, lclAmount);
                                    lclCampos[12] += PadStr('', 6, ' ');
                                    if GenJnlLine."Posting Text" <> '' then
                                        lclCampos[13] += PadStr('', 35 - StrLen(CopyStr(GenJnlLine."Posting Text", 1, 35)), ' ') + CopyStr(GenJnlLine."Posting Text", 1, 35)
                                    else
                                        lclCampos[13] += PadStr('', 35, ' ');
                                    lclCampos[14] += PadStr('', 105, ' ');
                                    if lclCampos[2] = '073' then
                                        lclCampos[15] += '00'
                                    else
                                        lclCampos[15] += '21';
                                    if VendorBankAccount."Check Manager" then
                                        lclCampos[16] += '  '
                                    else begin
                                        case VendorBankAccount."Bank Account Type" of
                                            VendorBankAccount."Bank Account Type"::"Current Account":
                                                lclCampos[16] += '01';
                                            VendorBankAccount."Bank Account Type"::"Savings Account":
                                                lclCampos[16] += '02';
                                            else
                                                lclCampos[16] += '  ';
                                        end;
                                    end;
                                    lclCampos[17] += PadStr('', 80 - StrLen(CopyStr(lcFullName, 1, 80)), ' ') + CopyStr(lcFullName, 1, 80);
                                    lclCampos[18] += PadStr('', 35 - StrLen(CopyStr(Vendor.Address, 1, 35)), ' ') + CopyStr(Vendor.Address, 1, 35);
                                    lclCampos[19] += PadStr('', 35, ' ');//Fila 28
                                    lcCity := UbigeoMgt.Province(VendorBankAccount."Country/Region Code", VendorBankAccount."Post Code", VendorBankAccount.City);
                                    lclCampos[20] += PadStr('', 15 - StrLen(CopyStr(lcCity, 1, 15)), ' ') + CopyStr(lcCity, 1, 15);
                                    lclCampos[21] += PadStr('', 30, ' ');
                                    if lclCampos[2] = '071' then begin
                                        lclCampos[22] += '00200000000';
                                        lclCampos[23] += PadStr('', 35 - StrLen(CopyStr(VendorBankAccount."Bank Account CCI", 1, 35)), ' ') + CopyStr(VendorBankAccount."Bank Account CCI", 1, 35);
                                        case VendorBankAccount."Bank Account Type" of
                                            VendorBankAccount."Bank Account Type"::"Current Account":
                                                lclCampos[24] += '01';
                                            VendorBankAccount."Bank Account Type"::"Savings Account":
                                                lclCampos[24] += '02';
                                            else
                                                lclCampos[24] += '  ';
                                        end;
                                    end else
                                        lclCampos[22] += PadStr('', 48, ' ');
                                    //                case EmployeeBankAccount."Bank Account Type" of
                                    //                  EmployeeBankAccount."Bank Account Type"::"Current Account" : lclCampos[1] += '01';
                                    //                  EmployeeBankAccount."Bank Account Type"::"Savings Account" : lclCampos[1] += '02';
                                    //                end;
                                    if lclCampos[2] = '072' then begin
                                        lclCampos[25] += PadStr('', 122, ' ');
                                        lclCampos[26] += PadStr('', 10 - StrLen(CopyStr(VendorBankAccount."Bank Account No.", 1, 10)), ' ') + CopyStr(VendorBankAccount."Bank Account No.", 1, 10);
                                        //MESSAGE(Format(StrLen(lclCampos[1])));
                                        case VendorBankAccount."Bank Account Type" of
                                            VendorBankAccount."Bank Account Type"::"Current Account":
                                                lclCampos[27] += '01';
                                            VendorBankAccount."Bank Account Type"::"Savings Account":
                                                lclCampos[27] += '02';
                                            else
                                                lclCampos[27] := '  ';
                                        end;
                                        lclCampos[28] += '009';
                                    end else
                                        lclCampos[25] += PadStr('', 134, ' ') + '009';

                                    //lclCampos[1] += PadStr('',122,' ') + '099';
                                    lclCampos[29] += PadStr('', 105, ' ');
                                    lclCampos[30] += PadStr('', 15 - StrLen(fnGetFormatAmt(false, lclAmount)), '0') + fnGetFormatAmt(false, lclAmount);
                                    //lclCampos[1] += '2' + PadStr('',267,' ');
                                    lclCampos[31] += '3' + PadStr('', 266, ' ');

                                    lcSecuenceCode := inCSTR(lcSecuenceCode);
                                    //MESSAGE(lcSecuenceCode);
                                    lclCampos[2] := '';
                                    For lcI := 1 TO 31 do begin
                                        lcTotalLineText += lclCampos[lcI];
                                    end;
                                    //ULN::PC 001  2020.06.01 v.001 begin 
                                    //  lcFile.WRITE(lclCampos[1]); Obsolete
                                    insertLineToTempFile(lcTotalLineText);
                                    //ULN::PC 001  2020.06.01 v.001 end 

                                end;
                                lcLastVendorNo := GenJnlLine2."Account No.";
                            until GenJnlLine2.NEXT = 0;
                        if lclCount <> 0 then begin
                            lclCampos[1] := 'TRL';
                            lclCampos[1] += PadStr('', 15 - StrLen(Format(lclCount)), '0') + Format(lclCount);
                            lclCampos[1] += PadStr('', 15 - StrLen(fnGetFormatAmt(false, lclTotalCheckSum)), '0') + fnGetFormatAmt(false, lclTotalCheckSum);
                            lclCampos[1] += PadStr('', 15, '0');
                            lclCampos[1] += PadStr('', 15 - StrLen(Format(lclCount)), '0') + Format(lclCount);
                            lclCampos[1] += PadStr('', 37, ' ');
                            //ULN::PC 001  2020.06.01 v.001 begin 
                            //  lcFile.WRITE(lclCampos[1]); Obsolete
                            insertLineToTempFile(lclCampos[1]);
                            //ULN::PC 001  2020.06.01 v.001 end                         

                        end;
                        //****************************************** CITIBANK *******************************************
                    end;// end case 'CITI-MN','CITI-ME'
            end;
        end;

        FA := Format(Date2DMY(lclStartDate, 3));
        FD := Format(Date2DMY(lclendDate, 1));
        if StrLen(Format(Date2DMY(lclendDate, 2))) = 1 then
            FM := '0' + Format(Date2DMY(lclendDate, 2))
        else
            FM := Format(Date2DMY(lclendDate, 2));

        case lcBankTelecridt of
            'BCP':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BCP-%1-%2-%3', FD, FM, FA), 'BCP');
            'BBVA-PREMIUN':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BBVA-PREMIUN-%1-%2-%3', FD, FM, FA), 'BBVA-PREMIUN');
            'BBVA-NET':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('BBVA-NET-%1-%2-%3', FD, FM, FA), 'BBVA-NET');
            'inTER':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('inTERBANK-%1-%2-%3', FD, FM, FA), 'inTER');
            'SCOT':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('SCOTIABANK-%1-%2-%3', FD, FM, FA), 'SCOT');
            'CITI':
                PostFileToControlFileRecord(lcdocumentNo, STRSUBSTNO('CITIBANK-%1-%2-%3', FD, FM, FA), 'CITI');
        end;

    end;

    procedure fnGenerateRegisterAccountsPayable(pGenJnlLine: Record "Gen. Journal Line")
    var
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLineTemp: Record "Gen. Journal Line" temporary;
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        lcText0001: Label 'Número Factura Proveedor no existe en Mov. Proveedor para la factura a liquidar %1 en la línea %2.';
        lclCampos: array[5] of Text[1024];
        importeacum: Decimal;
    begin
        GenJnlLineTemp.Reset();
        CreateTempFile();
        GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
        BankAccount2.Get(GenJnlBatch."Bank Account No. FICO");
        GenJnlLine.Reset();
        GenJnlLine.SetCurrentKey("Account No.");
        GenJnlLine.SetAscending("Account No.", true);
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        if GenJnlLine.FindSet then begin
            repeat
                clear(GenJnlLineTemp);
                GenJnlLineTemp.SetRange("Account No.", GenJnlLine."Account No.");
                if not GenJnlLineTemp.FindSet then begin
                    GenJnlLineTemp.Init();
                    GenJnlLineTemp.copy(GenJnlLine);
                    GenJnlLineTemp.Insert();
                end;

            until GenJnlLine.next = 0;
        end;


        clear(GenJnlLineTemp);
        if GenJnlLineTemp.FindSet() then
            repeat
                GenJnlBatch.Get(pGenJnlLine."Journal Template Name", pGenJnlLine."Journal Batch Name");
                BankAccount2.Get(GenJnlBatch."Bank Account No. FICO");
                GenJnlLine.Reset();
                GenJnlLine.SetCurrentKey("Account No.");
                GenJnlLine.SetAscending("Account No.", true);
                GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
                GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
                GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
                GenJnlLine.SetRange("Account No.", GenJnlLineTemp."Account No.");
                if GenJnlLine.FindSet then begin
                    importeacum := 0;
                    repeat
                        importeacum += GenJnlLine."Amount (LCY)";
                    until GenJnlLine.Next = 0;

                    if not Vendor.get(GenJnlLineTemp."Account No.") then
                        clear(Vendor);
                    lclCampos[1] := Vendor."VAT Registration No.";
                    lclCampos[2] := fnGetFormatAmt(true, importeacum);
                    insertLineToTempFile(lclCampos[1] + '|' + lclCampos[2]);

                end;
            until GenJnlLineTemp.next = 0;
        PostFileToRegisterAccountsPayable();

    end;


    local procedure fnGetNetAmountVendor(pGenJnlLine: Record "Gen. Journal Line"; pVendorNo: Code[20]; VAR pAmount: Decimal; VAR pAmountLCY: DecimaL)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        pAmount := 0;
        pAmountLCY := 0;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        if pVendorNo <> '' then
            GenJnlLine.SetRange("Account No.", pVendorNo);
        if GenJnlLine.FindSet() then
            repeat
                case true of
                    (GenJnlLine.Amount < 0) and (GenJnlLine."Currency Code" <> ''):
                        pAmount += GenJnlLine.Amount + ABS(GenJnlLine."Retention Amount" * GenJnlLine."Currency Factor");
                    (GenJnlLine.Amount < 0) and (GenJnlLine."Currency Code" = ''):
                        pAmount += GenJnlLine.Amount + ABS(GenJnlLine."Retention Amount");
                    (GenJnlLine.Amount > 0) and (GenJnlLine."Currency Code" <> ''):
                        pAmount += GenJnlLine.Amount - ABS(GenJnlLine."Retention Amount" * GenJnlLine."Currency Factor");
                    (GenJnlLine.Amount > 0) and (GenJnlLine."Currency Code" = ''):
                        pAmount += GenJnlLine.Amount - ABS(GenJnlLine."Retention Amount");
                end;

                if GenJnlLine.Amount < 0 then
                    pAmountLCY += GenJnlLine."Amount (LCY)" + ABS(GenJnlLine."Retention Amount")
                else
                    pAmountLCY += GenJnlLine."Amount (LCY)" - ABS(GenJnlLine."Retention Amount");

            //pAmountLCY += GenJnlLine."Amount (LCY)";
            until GenJnlLine.NEXT = 0;
    end;

    local procedure fnGetFormatAmt(Parwithdot: Boolean; ParAmount: Decimal): Text[100]
    var
        txtFormatImp: Text[30];
    begin
        if Not Parwithdot then
            exit(DelChr(Format(ParAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ',.'))
        else
            exit(DelChr(Format(ParAmount, 0, '<Precision,2:2><Standard Format,0>'), '=', ','));
    end;

    local procedure fnGetNetAmount(pGenJnlLine: Record "Gen. Journal Line"; pEmployeeNo: Code[20]; VAR pAmount: Decimal; VAR pAmountLCY: Decimal)
    var
        GenJnlLine: Record "Gen. Journal Line";
    begin
        pAmount := 0;
        pAmountLCY := 0;
        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Employee);
        if pEmployeeNo <> '' then
            GenJnlLine.SetRange("Account No.", pEmployeeNo);
        if GenJnlLine.FindSet() then
            repeat
                pAmount += GenJnlLine.Amount;
                pAmountLCY += GenJnlLine."Amount (LCY)";
            until GenJnlLine.NEXT = 0;
    end;

    local PROCEDURE SetFormatDate(pDate: Date; pPeriod: Boolean): Text[20]
    VAR
        lclYear: Text;
        lclMonth: Text;
        lclDay: Text;
    BEGIN
        lclYear := FORMAT(DATE2DMY(pDate, 3));
        lclMonth := FORMAT(DATE2DMY(pDate, 2));
        IF STRLEN(lclMonth) < 2 THEN
            lclMonth := '0' + lclMonth;
        lclDay := FORMAT(DATE2DMY(pDate, 1));
        IF STRLEN(lclDay) < 2 THEN
            lclDay := '0' + lclDay;

        IF pPeriod THEN
            EXIT(lclYear + lclMonth + lclDay)
        ELSE
            EXIT(lclDay + '/' + lclMonth + '/' + lclYear);
    END;

    local procedure fnGetTextAdjust(pinputText: Text; pLenght: integer; pDirection: Text[10]; pCharacter: Text[10]): Text
    begin

        case true of
            (StrLen(pinputText) = 0):
                exit(PadStr('', pLenght, pCharacter));
            (StrLen(pinputText) < pLenght) and (pDirection = '<'):
                exit(pinputText + PadStr('', pLenght - StrLen(pinputText), pCharacter));
            (StrLen(pinputText) < pLenght) and (pDirection = '>'):
                exit(PadStr('', pLenght - StrLen(pinputText), pCharacter) + pinputText);
            (StrLen(pinputText) > pLenght) and (pDirection = '<'):
                exit(CopyStr(pinputText, 1, pLenght));
            (StrLen(pinputText) > pLenght) and (pDirection = '>'):
                exit(CopyStr(pinputText, StrLen(pinputText) - pLenght, pLenght));
            (StrLen(pinputText) = pLenght):
                exit(pinputText);
        end;
    end;

    procedure fnCreateNetCash(pGenJnlLine: Record "Gen. Journal Line")
    var
        Vendor: Record Vendor;
        VendorBankAccount: Record "Vendor Bank Account";
        BankAccount: Record "Bank Account";
        BankAccount2: Record "Bank Account";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlLine2: Record "Gen. Journal Line";
        TelecreditUtility: Codeunit "Telecredit Utility";
        lcFile: File;
        lcOutStreamObj: OutStream;
        lcdocumentNo: Code[20];
        lcPaymentMethod: Text[1];
        lcAccountType: Text[2];
        lclCampos: Array[50] of Text[1024];
        lcFileName: Text;
        lcFileName2: Text;
        lcBankTelecridt: Text;
        lcNewFormatBank: Text;
        lclStartDate: Date;
        lcTotalLines: integer;
        lcTotalOperations: integer;
        lcTotalAmount: Decimal;
        lcAmount: Decimal;
        lcNombreEmpresa: Text;
    begin
        Clear(lcFile);
        Clear(lclCampos);
        lcdocumentNo := '';
        lcTotalLines := 0;
        lcTotalOperations := 0;
        lcTotalAmount := 0;
        CompanyInf.GET;

        //ULN::PC 001  2020.06.01 v.001 begin 
        /*          lcFile.CREATETEMPFILE(TEXTENCODinG::MSdos);
                lcFile.TEXTMODE(true);   */
        CreateTempFile();
        //ULN::PC 001  2020.06.01 v.001 end       
        lcFileName2 := 'NET' + Format(CURRENTDATETIME, 0, '<Day,2><Month,2><Year,2><Hours24,2><Minutes,2><Seconds,2>');
        //lcFileName := 'BBVAProc1288.txt';


        GenJnlLine.Reset();
        GenJnlLine.SetRange("Journal Template Name", pGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange("Journal Batch Name", pGenJnlLine."Journal Batch Name");
        GenJnlLine.SetRange("Account Type", GenJnlLine."Account Type"::Vendor);
        if GenJnlLine.FindSet() then begin
            lcFileName := 'BBVAProc' + CopyStr(GenJnlLine."document No.", 7, 4);//'BBVAProc2139.txt    ';

            GenJnlBatch.Get(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
            GenJnlBatch.TestField("Bank Account No. FICO");
            BankAccount.Get(GenJnlBatch."Bank Account No. FICO");
            BankAccount.TestField("Bank Account No.");
            lclStartDate := GenJnlLine."Posting Date";

            //ULN::PC 001  2020.06.01 v.001 begin 
            /*    lcFile.CREATEOUTSTREAM(lcOutStreamObj);   */
            TempTenantMedia.Content.CreateOutStream(lcOutStreamObj);
            //ULN::PC 001  2020.06.01 v.001 end    
            BankAccount.Get(GenJnlLine."Journal Batch Name");
            lcBankTelecridt := 'BBVA-NET';
            lcdocumentNo := GenJnlLine."document No.";

            //------------------------- Primer Registro de Cabecera Obligatorio ----------------------------
            lcTotalLines += 1;
            lclCampos[1] := '3110';//1-4
            lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
            lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
            lclCampos[1] += Format(lclStartDate, 0, '<Day,2><Month,2><Year4>');//18-25
            lclCampos[1] += Format(lclStartDate, 0, '<Day,2><Month,2><Year4>');//26-33
            lcNewFormatBank := CopyStr(BankAccount."Bank Account No.", StrLen(BankAccount."Bank Account No.") - 1, 2);
            lcNewFormatBank := lcNewFormatBank + CopyStr(BankAccount."Bank Account No.", StrLen(BankAccount."Bank Account No.") - 11, 10);
            lcNewFormatBank := CopyStr(BankAccount."Bank Account No.", 1, 8) + lcNewFormatBank;
            lclCampos[1] += fnGetTextAdjust(lcNewFormatBank, 20, '<', ' ');//34-53
            lclCampos[1] += fnGetCurrencyCode(BankAccount."Currency Code");//54-56
            lclCampos[1] += fnGetTextAdjust('', 12, '<', ' ');//57-68
            lclCampos[1] += '0';//69-69
            lclCampos[1] += '0';//70-70
            lclCampos[1] += lcFileName;//71-90
            lclCampos[1] += 'SER';//91-93
            lclCampos[1] += fnGetTextAdjust('LIBRE2', 161, '<', ' ');//94-254 --- PadStr('',161,' ')  

            //ULN::PC 001  2020.06.01 v.001 begin 
            // lcFile.WRITE(lclCampos[1]); Obsoleto
            insertLineToTempFile(lclCampos[1]);
            //ULN::PC 001  2020.06.01 v.001 end         
            //--------------------------------------------------------------------------------------------

            //------------------------ Segundo Registro de Cabecera Obligatorio --------------------------
            //begin ULN::RHF 001(++)
            case CompanyInf."VAT Registration No." of
                '20329545459':
                    lcNombreEmpresa := 'MANPOWER PRofESSIONAL SERVICES S.A';
                '20304289512':
                    lcNombreEmpresa := 'MANPOWER PERU';
                '20524079403':
                    lcNombreEmpresa := 'RIGHT MANAGEMENT';
            end;
            //end ULN::RHF 001(++)

            lcTotalLines += 1;
            lclCampos[1] := '3120';//1-4
            lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
            lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
            lclCampos[1] += fnGetTextAdjust(lcNombreEmpresa, 35, '<', ' ');//18-52//fnGetTextAdjust(CompanyInf.Name,35,'<',' ');//18-52 //'MANPOWER PRofESSIONAL'
            lclCampos[1] += fnGetTextAdjust('', 35, '<', ' ');//53-87
            lclCampos[1] += PadStr('', 167, ' ');//88-254

            //ULN::PC 001  2020.06.01 v.001 begin 
            // lcFile.WRITE(lclCampos[1]); Obsoleto
            insertLineToTempFile(lclCampos[1]);
            //ULN::PC 001  2020.06.01 v.001 end             
            //--------------------------------------------------------------------------------------------

            //---------------- Tercer Registro Cabecera Opcional (Antes Obligatorio) ---------------------
            lcTotalLines += 1;
            lclCampos[1] := '3130';//1-4
            lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
            lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17 
            lclCampos[1] += fnGetTextAdjust(UbigeoMgt.District(CompanyInf."Country/Region Code", CompanyInf."Post Code", CompanyInf.City, CompanyInf.County), 35, '<', ' ');
            lclCampos[1] += fnGetTextAdjust(UbigeoMgt.Province(CompanyInf."Country/Region Code", CompanyInf."Post Code", CompanyInf.City), 25, '<', ' ');//53-77
            lclCampos[1] += fnGetTextAdjust(UbigeoMgt.Departament(CompanyInf."Country/Region Code", CompanyInf."Post Code"), 25, '<', ' ');//78-102
                                                                                                                                           //lclCampos[1] += PadStr('',153,' ');//103-255 

            //ULN::PC 001  2020.06.01 v.001 begin 
            // lcFile.WRITE(lclCampos[1]); Obsoleto
            insertLineToTempFile(lclCampos[1]);
            //ULN::PC 001  2020.06.01 v.001 end            
            //--------------------------------------------------------------------------------------------

            //******************************** 2.2  Datos del Proveedor **********************************
            //********************************************************************************************
            GenJnlLine2.Reset();
            GenJnlLine2.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
            GenJnlLine2.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
            GenJnlLine2.SetRange("Account Type", GenJnlLine2."Account Type"::Vendor);
            if GenJnlLine2.FindSet() then
                repeat
                    Vendor.Get(GenJnlLine2."Account No.");
                    GenJnlLine2.TestField("Recipient Bank Account");
                    VendorBankAccount.Get(Vendor."No.", GenJnlLine2."Recipient Bank Account");
                    fnCheckVendorBankAccount(VendorBankAccount);
                    lcTotalOperations += 1;

                    //------------------------ Primer Registro individual Obligatorio ----------------------------
                    lcTotalLines += 1;
                    //lcTotalAmount += GenJnlLine2.Amount;
                    lclCampos[1] := '3210';//1-4
                    lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
                    lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
                    lclCampos[1] += fnGetdocumentType(Vendor."VAT Registration Type");//18-18
                    lclCampos[1] += fnGetTextAdjust(Vendor."VAT Registration No.", 12, '<', ' ');//19-30
                    lclCampos[1] += fnGetTextAdjust(Vendor.Name, 35, '<', ' ');//31-65 

                    //++ begin ULN::RRR 09.07.2019
                    lcAmount := 0;
                    case true of
                        (GenJnlLine2.Amount < 0) and (GenJnlLine2."Currency Code" <> ''):
                            lcAmount := GenJnlLine2.Amount + ABS(GenJnlLine2."Retention Amount" * GenJnlLine2."Currency Factor");
                        (GenJnlLine2.Amount < 0) and (GenJnlLine2."Currency Code" = ''):
                            lcAmount := GenJnlLine2.Amount + ABS(GenJnlLine2."Retention Amount");
                        (GenJnlLine2.Amount > 0) and (GenJnlLine2."Currency Code" <> ''):
                            lcAmount := GenJnlLine2.Amount - ABS(GenJnlLine2."Retention Amount" * GenJnlLine2."Currency Factor");
                        (GenJnlLine2.Amount > 0) and (GenJnlLine2."Currency Code" = ''):
                            lcAmount := GenJnlLine2.Amount - ABS(GenJnlLine2."Retention Amount");
                    end;
                    lcTotalAmount += lcAmount;
                    //++ end ULN::RRR 09.07.2019

                    lclCampos[1] += fnGetTextAdjust(fnGetFormatAmt(false, lcAmount), 12 + 2, '>', '0');//66-77 & 78-79
                    lclCampos[1] += fnGetCurrencyCode(GenJnlLine2."Currency Code");//80-82
                    lclCampos[1] += fnGetTextAdjust('', 12, '<', ' ');//83-94
                    lclCampos[1] += '0000';//95-98
                    lclCampos[1] += fnGetTextAdjust('', 40, '<', ' ');//99-138
                    lclCampos[1] += fnGetTextAdjust('', 117, '<', ' ');//139-255 //begin RHF 20190701 SE AJUSTO UN CARACTER ADICIONAL
                                                                       //ULN::PC 001  2020.06.01 v.001 begin 
                                                                       // lcFile.WRITE(lclCampos[1]); Obsoleto
                    insertLineToTempFile(lclCampos[1]);
                    //ULN::PC 001  2020.06.01 v.001 end 
                    //--------------------------------------------------------------------------------------------


                    //----------------------- Segundo Registro individual Obligatorio ----------------------------
                    lcTotalLines += 1;
                    lclCampos[1] := '3220';//1-4
                    lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
                    lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
                    lclCampos[1] += fnGetdocumentType(Vendor."VAT Registration Type");//18-18
                    lclCampos[1] += fnGetTextAdjust(Vendor."VAT Registration No.", 12, '<', ' ');//19-30
                    lclCampos[1] += fnGetTextAdjust(VendorBankAccount."Legal Document", 4, '>', '0');//31-34
                    lcPaymentMethod := 'P';
                    lcAccountType := '00';
                    if VendorBankAccount."Bank Account Type" = VendorBankAccount."Bank Account Type"::"Interbank Account" then begin
                        lcPaymentMethod := 'I';
                        lcAccountType := '01';
                        lclCampos[1] += fnGetTextAdjust(DelChr(VendorBankAccount."Bank Account CCI", '=', DelChr(VendorBankAccount."Bank Account CCI", '=', TextNumbers)), 20, '>', ' ')//35-54
                    end else
                        lclCampos[1] += fnGetTextAdjust(DelChr(VendorBankAccount."Bank Account No.", '=', DelChr(VendorBankAccount."Bank Account No.", '=', TextNumbers)), 20, '>', ' ');//35-54

                    lclCampos[1] += CONVERTSTR(fnGetTextAdjust(Vendor.Address, 35, '<', ' '), '?', 'Ñ');//55-89 GNR
                    lclCampos[1] += lcPaymentMethod;//90-90
                    lclCampos[1] += fnGetTextAdjust('', 24, '<', ' ');//91-114
                    lclCampos[1] += lcAccountType;//115-116
                    lclCampos[1] += fnGetTextAdjust('', 139, '<', ' ');//117-255 //begin RHF 20190701 SE AJUSTO UN CARACTER ADICIONAL

                    //ULN::PC 001  2020.06.01 v.001 begin 
                    // lcFile.WRITE(lclCampos[1]); Obsoleto
                    insertLineToTempFile(lclCampos[1]);
                    //ULN::PC 001  2020.06.01 v.001 end 
                    //--------------------------------------------------------------------------------------------

                    //------------------------- Tercer Registro individual Opcional ------------------------------
                    lcTotalLines += 1;
                    lclCampos[1] := '3230';//1-4
                    lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
                    lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
                    lclCampos[1] += fnGetdocumentType(Vendor."VAT Registration Type");//18-18
                    lclCampos[1] += fnGetTextAdjust(Vendor."VAT Registration No.", 12, '<', ' ');//19-30 
                    lclCampos[1] += fnGetTextAdjust(UbigeoMgt.District(CompanyInf."Country/Region Code", CompanyInf."Post Code", CompanyInf.City, CompanyInf.County), 35, '<', ' ');//31-65
                    lclCampos[1] += fnGetTextAdjust(UbigeoMgt.Province(CompanyInf."Country/Region Code", CompanyInf."Post Code", CompanyInf.City), 25, '<', ' ');//66-90
                    lclCampos[1] += fnGetTextAdjust(UbigeoMgt.Departament(CompanyInf."Country/Region Code", CompanyInf."Post Code"), 25, '<', ' ');//91-115
                    if Vendor."E-Mail" <> '' then
                        lclCampos[1] += 'E'//116-116
                    else
                        if Vendor."Phone No." <> '' then
                            lclCampos[1] += 'S'//116-116
                        else
                            lclCampos[1] += 'N';//116-116

                    lclCampos[1] += fnGetTextAdjust(Vendor."E-Mail", 60, '<', ' ');//117-176
                    lclCampos[1] += fnGetTextAdjust(Vendor."Phone No.", 12, '<', ' ');//177-188
                    lclCampos[1] += fnGetTextAdjust('', 67, '<', ' ');//189-255
                                                                      //ULN::PC 001  2020.06.01 v.001 begin 
                                                                      // lcFile.WRITE(lclCampos[1]); Obsoleto
                    insertLineToTempFile(lclCampos[1]);
                    //ULN::PC 001  2020.06.01 v.001 end 
                    //--------------------------------------------------------------------------------------------

                    //----------------------------- Registro individual Opcional ---------------------------------
                    lcTotalLines += 1;
                    lclCampos[1] := '3240';//1-4
                    lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
                    lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
                    lclCampos[1] += fnGetdocumentType(Vendor."VAT Registration Type");//18-18
                    lclCampos[1] += fnGetTextAdjust(Vendor."VAT Registration No.", 12, '<', ' ');//19-30 
                    lclCampos[1] += fnGetTextAdjust(GenJnlLine2.Description, 35, '<', ' ');//31-65
                    lclCampos[1] += fnGetTextAdjust(GenJnlLine2."Posting Text", 35, '<', ' ');//66-100
                    lclCampos[1] += fnGetTextAdjust('', 155, '<', ' ');//101-255
                                                                       //ULN::PC 001  2020.06.01 v.001 begin 
                                                                       // lcFile.WRITE(lclCampos[1]); Obsoleto
                    insertLineToTempFile(lclCampos[1]);
                //ULN::PC 001  2020.06.01 v.001 end 
                //--------------------------------------------------------------------------------------------

                until GenJnlLine2.NEXT = 0;
            //**********************************************************************************************
            //**********************************************************************************************

            //------------------------------- 2.4 Datos de Control del Fichero -----------------------------
            lcTotalLines += 1;
            lclCampos[1] := '3910';//1-4
            lclCampos[1] += fnGetdocumentType(CompanyInf."VAT Registration Type");//5-5
            lclCampos[1] += fnGetTextAdjust(CompanyInf."VAT Registration No.", 12, '<', ' ');//6-17
            lclCampos[1] += fnGetTextAdjust(Format(lcTotalLines), 10, '>', '0');//18-27
            lclCampos[1] += fnGetTextAdjust(Format(lcTotalOperations), 8, '>', '0');//28-35
            lclCampos[1] += fnGetTextAdjust(fnGetFormatAmt(false, lcTotalAmount), 12 + 2, '>', '0');//36-47 & 48-49
            lclCampos[1] += fnGetTextAdjust('', 106, '<', ' ');//50-255
                                                               //ULN::PC 001  2020.06.01 v.001 begin 
                                                               // lcFile.WRITE(lclCampos[1]); Obsoleto
            insertLineToTempFile(lclCampos[1]);
            //ULN::PC 001  2020.06.01 v.001 end 
            //----------------------------------------------------------------------------------------------
        end;

        PostFileToControlFileRecord(lcdocumentNo, lcFileName2, 'NETCASH')
    end;
    //File Funcionts---------------------------------------------------------------------//
    //ULN::PC 001  2020.06.01 v.001 begin 
    procedure CreateTempFile()
    begin
        //TempTenantMedia.Content.CreateOutStream(ConstrutOutStream, TextEncoding::UTF8);
        gCuTempFileBlob.CreateOutStream(ConstrutOutStream, TextEncoding::UTF8);
    end;

    procedure fnGetdocumentType(pdocumentType: Text[10]): Text
    begin
        case pdocumentType of
            '0':
                exit('S');//5-5
            '1':
                exit('L');//5-5                  
            '4':
                exit('E');//5-5
            '6':
                exit('R');//5-5
            '7':
                exit('P');//5-5                
        end;
    end;

    procedure fnGetCurrencyCode(pCurrencyCode: Code[10]): Text
    begin
        if pCurrencyCode = '' then
            exit('PEN')
        else
            exit('USD');
    end;

    procedure insertLineToTempFile(LineText: Text[1024])
    begin
        ConstrutOutStream.WriteText(LineText);
        ConstrutOutStream.WriteText;
    end;

    procedure PostFileToControlFileRecord(pdocumentNo: code[20]; pFileName: code[250]; pBook: Code[50])
    var
        NewFileinStream: inStream;
        FileName: Text;
        FileExt: Text;
        EntryNo: integer;
        Confirmdownload: Label 'do you want to download the following file?';
    begin
        CompanyInf.Get();
        gCuTempFileBlob.CreateinStream(NewFileinStream);
        //FileName := 'LE' + CompanyInf."VAT Registration No." + Format(endDate, 0, '<Year4><Month,2>000') + BookCode + '00001111';
        FileName := pFileName;
        FileExt := 'txt';
        BookCode := pBook;
        EntryNo := ControlFile.CreateControlFileRecord(BookCode, FileName, FileExt, WorkDate, WorkDate, NewFileinStream);
        if EntryNo <> 0 then
            if Confirm(Confirmdownload, false) then begin
                ControlFile.Get(EntryNo);
                ControlFile.downLoadFile(ControlFile);
            end;
        TelecreditUtility.fnMessageNotificationRemittanceFiles(pFileName, STRSUBSTNO('Se creó el archivo para el documento %1', pdocumentNo));

    end;

    procedure PostFileToRegisterAccountsPayable()
    var
        NewFileinStream: inStream;
        STLocalization: Record "Setup Localization";
        FileName: Text;
        FileExt: Text;
        EntryNo: integer;
        Confirmdownload: Label 'do you want to download the following file?';
        ControlFile: Record "ST Control File";
        SerieLast: Text;
        Serie: Text;
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NewFileOutStream: OutStream;
        NextEntryNo: Integer;
    begin
        //Iniciamos var
        CompanyInf.Get();
        STLocalization.Get();
        gCuTempFileBlob.CreateinStream(NewFileinStream);
        STLocalization.TestField("ST Coactiva No. Serie");
        //Iniciamos EntryNo
        ControlFile.Reset();
        ControlFile.SetCurrentKey("Entry No.");
        if ControlFile.FindLast() then
            NextEntryNo := ControlFile."Entry No." + 1
        else
            NextEntryNo := 1;

        //Iniciamos Serie
        ControlFile.Init();
        NoSeriesMgt.InitSeries(STLocalization."ST Coactiva No. Serie", STLocalization."ST Coactiva No. Serie"
        , WorkDate(), ControlFile."File ID", STLocalization."ST Coactiva No. Serie");
        ControlFile."Entry No." := NextEntryNo;
        //  ControlFile."File ID" := FileID;
        //-----------------

        //Asignamos Serie
        SerieLast := ControlFile."File ID";
        Serie := copystr(SerieLast, StrPos(SerieLast, '-') + 1, StrLen(SerieLast));
        FileName := 'RCP' + SetFormatDate(WorkDate(), true) + Serie;
        FileExt := 'txt';
        EntryNo := NextEntryNo;

        //Creamos archivo
        ControlFile."File Name" := FileName;
        ControlFile."File Extension" := FileExt;
        ControlFile."Start Date" := WorkDate;
        ControlFile."End Date" := WorkDate;
        ControlFile."File Blob".CreateOutStream(NewFileOutStream);
        CopyStream(NewFileOutStream, NewFileInStream);
        ControlFile."Create DateTime File" := CurrentDateTime;
        ControlFile."Create User ID" := UserId;
        ControlFile.Insert();
        if EntryNo <> 0 then
            if Confirm(Confirmdownload, false) then begin
                ControlFile.Get(EntryNo);
                ControlFile.downLoadFile(ControlFile);
            end;
        TelecreditUtility.fnMessageNotificationRemittanceFiles(FileName, STRSUBSTNO('Se creó el archivo para el documento %1', FileName));

    end;



    var
        CompanyInf: Record "Company inFormation";
        ControlFile: Record "ST Control File";
        BookCode: Code[10];
        NotRequestDate: Boolean;
        Windows: Dialog;
        ConstrutOutStream: OutStream;
        gCuTempFileBlob: Codeunit "Temp Blob";
        UbigeoMgt: Codeunit "Ubigeo Management";
        VendorWihtoutBank: Label 'El proveedor %1 de de línea %2 no tiene un banco creado en ficha de Banco Proveedores';
        FieldDiferentValueinLine: label 'Field %1 must have a value different from %2 for line %3', Comment = 'ESM="El campo %1 debe tener un valor diferente a %2 para la line %3."';
        ErrorEmployeeSetupLegalDocument: Label 'Error de configuración. El empleado %1, tiene configurado tipo de documento de identidad "%2". BCP solo soporta los tipos "1","4","7" y "A".';
        ErrorVendorSetupLegalDocument: Label 'Error de configuración. El Proveedor %1, tiene configurado tipo de documento de identidad "%2". BCP solo soporta los tipos "1","4","7" y "A".';
        ErrorNoExistVendorEntryForAppliedEntryNo: Label 'Número Factura Proveedor no existe en Mov. Proveedor para la factura a liquidar %1 en la línea %2.';
        BankAccountTypeError: Label 'El banco %1 solo puede ser configurado como tipo: (Current Account) o (Master Account).', Comment = 'ESM="El banco %1 solo puede ser configurado como tipo: (Cuenta corriente) o (Cuenta maestra)."';
        TextPermissionCharacters: Label 'ABCDEFGHIJKLMNÑOPQRSTUVWXYZ abcdefghijklmnñopqrstuvwxyz 0123456789./,áéíóúÁÉÍÓÚ';
        CharandNumbersandSpace: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789';
        TextCharacters: Label 'ABCDEFGHIJKLMNOPQRSTUVWXYZ-';
        TextNumbers: Label '0123456789';
        TeleCreditdocumentLabel: Label 'Telécredito %1 documento %2';
        CheckDateExistsMessage: Label 'Enter Start Date and end Date to continue.', Comment = 'ESM="Ingrese fecha de inicio y fin para continuar."';
        ErrorSelectedDate: Label 'You can only generate the Electronic Book for one period at a time.', Comment = 'ESM="Solo puede generar un periodo a la vez para el libro electrónico."';
        Processing: Label 'Processing  #1#######################\', Comment = 'ESM="Procesando  #1#######################\"';
        CreatingFile: Label 'CreatingFile  #2#######################\', Comment = 'ESM="Creando archivo  #2#######################\"';
        TelecreditUtility: Codeunit "Telecredit Utility";
        TempTenantMedia: Record "Tenant Media";


}