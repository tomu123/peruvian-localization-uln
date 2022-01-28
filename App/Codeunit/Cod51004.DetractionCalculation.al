codeunit 51004 "DetrAction Calculation"
{
    trigger OnRun()
    Begin

    end;

    var
        myInt: integer;
        GLSetup: Record "General Ledger Setup";
        VendorPostingGroup: Record "Vendor Posting Group";
        SLSetup: Record "Setup Localization";
        TempFileBlob: Codeunit "Temp Blob";

    procedure CalcDetrAction(pPurchHeader: Record "Purchase Header"; var ParPurchAmtDetracc: Decimal; var ParPurchAmtDetraccLCY: Decimal)
    var
        TempPurchLine: Record "Purchase Line" temporary;
        PurchPost: Codeunit "Purch.-Post";
        totalPurchLine: Record "Purchase Line";
        totalPurchLineLCY: Record "Purchase Line";
        VATAmount: Decimal;
        VATAmountText: Text;
        totalAmount1: Decimal;
        totalAmount2: Decimal;
        RecCurrencyExchangeRate: Record "Currency Exchange Rate";
        TipoCambio: Decimal;
    Begin
        GLSetup.Get();
        PurchPost.GetPurchLines(pPurchHeader, TempPurchLine, 0);
        Clear(PurchPost);
        PurchPost.SumPurchLinesTemp(pPurchHeader, TempPurchLine, 0, totalPurchLine, totalPurchLineLCY, VATAmount, VATAmountText);

        if pPurchHeader."Prices including VAT" then Begin
            totalAmount2 := totalPurchLine.Amount;
            totalAmount1 := totalAmount2 + VATAmount;
            totalPurchLine."Line Amount" := totalAmount1 + totalPurchLine."Inv. Discount Amount";
        end else Begin
            totalAmount1 := totalPurchLine.Amount;
            totalAmount2 := totalPurchLine."Amount including VAT";
        end;

        pPurchHeader."Purch. Amount DetrAction" := Round((pPurchHeader."Purch. % DetrAction" * totalAmount2) / 100, GLSetup."Amount Rounding Precision");

        if (pPurchHeader."Currency Code" = '') AND (pPurchHeader."Prices including VAT") then Begin
            pPurchHeader."Purch. Amount DetrAction" := Round((pPurchHeader."Purch. % DetrAction" * totalAmount1) / 100, 1, '=');
        end;
        if (pPurchHeader."Currency Code" = '') AND Not (pPurchHeader."Prices including VAT") then Begin
            pPurchHeader."Purch. Amount DetrAction" := Round((pPurchHeader."Purch. % DetrAction" * totalAmount2) / 100, 1, '=');
        end;

        if (pPurchHeader."Currency Code" <> '') AND (pPurchHeader."Prices including VAT") then Begin
            pPurchHeader."Purch. Amount DetrAction" := Round((pPurchHeader."Purch. % DetrAction" * totalAmount1) / 100, GLSetup."Amount Rounding Precision");
        end;

        if (pPurchHeader."Currency Code" <> '') AND Not (pPurchHeader."Prices including VAT") then Begin
            pPurchHeader."Purch. Amount DetrAction" := Round((pPurchHeader."Purch. % DetrAction" * totalAmount2) / 100, GLSetup."Amount Rounding Precision");
        end;

        if pPurchHeader."Currency Factor" = 0 then Begin
            pPurchHeader."Purch Amount DetrAction (DL)" := pPurchHeader."Purch. Amount DetrAction";
            pPurchHeader."Purch Amount DetrAction (DL)" := Round(pPurchHeader."Purch Amount DetrAction (DL)", 1, '=');
        end else Begin
            if pPurchHeader."Currency Code" <> '' then Begin
                RecCurrencyExchangeRate.Reset();
                RecCurrencyExchangeRate.SetRange("Currency Code", pPurchHeader."Currency Code");
                RecCurrencyExchangeRate.SetRange("Starting Date", pPurchHeader."document Date");
                if RecCurrencyExchangeRate.FindSet then
                    TipoCambio := RecCurrencyExchangeRate."Relational Exch. Rate Amount";
            end else
                TipoCambio := 1;

            pPurchHeader."Purch Amount DetrAction (DL)" := pPurchHeader."Purch. Amount DetrAction" * TipoCambio;
            pPurchHeader."Purch Amount DetrAction (DL)" := Round(pPurchHeader."Purch Amount DetrAction (DL)", 1, '=');

            if pPurchHeader."Currency Code" = '' then
                pPurchHeader."Purch. Amount DetrAction" := Round(pPurchHeader."Purch Amount DetrAction (DL)" * pPurchHeader."Currency Factor", GLSetup."Amount Rounding Precision");
        end;
        ParPurchAmtDetracc := pPurchHeader."Purch. Amount DetrAction";
        ParPurchAmtDetraccLCY := pPurchHeader."Purch Amount DetrAction (DL)";
    end;

    procedure ValidateTypeOfService(pPurchHeader: Record "Purchase Header"; VAR ParTypeofService: Text; VAR ParPurchDetrac: Decimal)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeofService);
        Clear(ParPurchDetrac);
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            ParTypeofService := DetracServOpe.Code;
            ParPurchDetrac := DetracServOpe."DetrAction Percentage";
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfService(pPurchHeader: Record "Purchase Header"; VAR ParTypeofService: Text; VAR ParPurchDetrac: Decimal; TipoServicio: Code[10])
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeofService);
        Clear(ParPurchDetrac);
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        DetracServOpe.SetFilter(Code, TipoServicio);
        if DetracServOpe.FindSet then Begin
            ParTypeofService := DetracServOpe.Code;
            ParPurchDetrac := DetracServOpe."DetrAction Percentage";
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfService(pPurchHeader: Record "Purchase Header"; VAR ParTypeofService: Code[10]; VAR ParPurchDetrac: Decimal; LookUpMode: Boolean)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        case LookUpMode OF
            true:
                Begin
                    Clear(ParTypeofService);
                    Clear(ParPurchDetrac);
                    PgDetracServOpe.SetTableView(DetracServOpe);
                    PgDetracServOpe.SetRecord(DetracServOpe);
                    PgDetracServOpe.LookUpMode(true);
                    if PgDetracServOpe.RunModal = Action::LookupOK then Begin
                        PgDetracServOpe.GetRecord(DetracServOpe);
                        ParTypeofService := DetracServOpe.Code;
                        ParPurchDetrac := DetracServOpe."DetrAction Percentage";
                    end;
                end;
            false:
                Begin
                    if ParTypeofService <> '' then Begin
                        DetracServOpe.SetRange(Code, ParTypeofService);
                        DetracServOpe.FindSet;
                        ParTypeofService := DetracServOpe.Code;
                        ParPurchDetrac := DetracServOpe."DetrAction Percentage";
                    end;
                end;
        end;

        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfOperation(pPurchHeader: Record "Purchase Header"; VAR ParTypeOfOperation: Text)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeOfOperation);
        //pPurchHeader.SETCURRENTKEY("document Type","No.");
        //pPurchHeader.GET(pPurchHeader."document Type",pPurchHeader."No.");
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 1);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            ParTypeOfOperation := DetracServOpe.Code;
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfOperation(pPurchHeader: Record "Purchase Header"; VAR ParTypeOfOperation: Text; TipoOperacion: Code[10])
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeOfOperation);
        pPurchHeader.SETCURRENTKEY("document Type", "No.");

        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 1);
        DetracServOpe.SetRange(Code, TipoOperacion);
        if DetracServOpe.FindSet then Begin
            //lclPage.GetRecord(lclTypeOfSO);
            ParTypeOfOperation := DetracServOpe.Code;
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateDetrActionAmounts(pPurchHeader: Record "Purchase Header"; VAR ParPurchAmtDetracc: Decimal)
    var

    Begin
        ParPurchAmtDetracc := Round(pPurchHeader."Purch. Amount DetrAction" * pPurchHeader."Currency Factor", GLSetup."Amount Rounding Precision");
    end;

    procedure GetTypeOfSO(ParTypeOfSO: Text; pTipo: Boolean): Text[250]
    var
        DetracServOpe: Record "DetrAction Services Operation";
    Begin
        DetracServOpe.Reset();
        DetracServOpe.SetRange(Code, ParTypeOfSO);
        if pTipo then
            DetracServOpe.SetRange("Type Services/Operation", DetracServOpe."Type Services/Operation"::"Tipo Operacion")
        else
            DetracServOpe.SetRange("Type Services/Operation", DetracServOpe."Type Services/Operation"::"Tipo Servicio");
        if DetracServOpe.FindSet then Begin
            EXIT(DetracServOpe.Description);
        end
        else Begin
            EXIT('');
        end
    end;

    procedure MakeGenJnlDetrAction(pPurchHeader: Record "Purchase Header"; PardocumentNo: Text[30]; ParExternaldocNo: Text[30]; ParGenJnlType: integer; ParSrcCode: Code[10])
    var
        GenJnlLine: Record "Gen. Journal Line";
        VendorPostingGroup: Record "Vendor Posting Group";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        Vendor: Record "Vendor";
        intNum: integer;
        SymbolNum: integer;
        VendLedgerEntry: Record "Vendor Ledger Entry";
        FactorDivisa: Decimal;
        ImporteBase: Decimal;
        ImporteDL: Decimal;
        Text001: Label 'No se ha agregado el grupo contable de Detracción en la localización peruana.';
        Text002: Label 'No se ha agregado el proveedor Detraccion';
        Text003: Label ' DETRAC.';
    Begin
        SLSetup.Get();
        if (pPurchHeader."Purch. DetrAction") AND (pPurchHeader."document Type" in [pPurchHeader."document Type"::Invoice, pPurchHeader."document Type"::"Credit Memo"]) then Begin
            if SLSetup."DetrAction Posting Group" = '' then Begin
                Error(Text001);
            end;
            GetDetrActionAmounts(pPurchHeader, ImporteBase, ImporteDL, FactorDivisa);
            for intNum := 1 to 2 do Begin
                if intNum = 2 then
                    SymbolNum := -1 else
                    SymbolNum := 1;
                GenJnlLine.INIT;
                GenJnlLine."Posting Date" := pPurchHeader."Posting Date";
                GenJnlLine."document Date" := pPurchHeader."document Date";
                GenJnlLine.Description := CopyStr(pPurchHeader."Posting Description" + Text003, 1, 91) + Text003;
                case intNum OF
                    1:
                        Begin
                            GenJnlLine."Account No." := pPurchHeader."Buy-from Vendor No.";
                            GenJnlLine."Applies-to doc. No." := PardocumentNo;
                            GenJnlLine."Posting Group" := pPurchHeader."Vendor Posting Group";
                        end;
                    2:
                        Begin
                            GenJnlLine."document Type" := GenJnlLine."document Type"::" ";
                            GenJnlLine."Account No." := pPurchHeader."Buy-from Vendor No.";
                            if Vendor.GET(pPurchHeader."Buy-from Vendor No.") then Begin end;
                            GenJnlLine."Payment Terms Code" := Vendor."Payment Terms Code";
                            GenJnlLine."Payment Method Code" := Vendor."Payment Method Code";
                            GenJnlLine."Posting Group" := SLSetup."DetrAction Posting Group";
                            //Search the detracc vendor ledger entry
                            if (ParGenJnlType = 3) AND (pPurchHeader."Applies-to doc. No." <> '') then Begin
                                VendLedgerEntry.Reset();
                                VendLedgerEntry.SetRange("document No.", pPurchHeader."Applies-to doc. No.");
                                VendLedgerEntry.SetRange("Posting Date", pPurchHeader."Posting Date");
                                VendLedgerEntry.SetRange("Vendor No.", pPurchHeader."Buy-from Vendor No.");
                                VendLedgerEntry.SetRange("Vendor Posting Group", SLSetup."DetrAction Posting Group");
                                if VendLedgerEntry.FindSet then Begin
                                    if Not VendLedgerEntry.Open then
                                        Error('La detracción esta pagada! Cancele esa operación primero');

                                    GenJnlLine."Applies-to doc. Type" := GenJnlLine."Applies-to doc. Type"::" ";
                                    GenJnlLine."Applies-to doc. No." := VendLedgerEntry."document No.";
                                end;
                            end;
                        end;
                end;
                GenJnlLine."Reason Code" := pPurchHeader."Reason Code";
                GenJnlLine."document No." := PardocumentNo;
                GenJnlLine."External document No." := ParExternaldocNo;
                GenJnlLine."Dimension Set ID" := pPurchHeader."Dimension Set ID";
                GenJnlLine."System-Created Entry" := true;
                case intNum OF
                    1:
                        Begin
                            GenJnlLine."Source Currency Code" := pPurchHeader."Currency Code";
                            GenJnlLine."Currency Code" := pPurchHeader."Currency Code";
                            if pPurchHeader."Currency Code" = '' then
                                GenJnlLine."Currency Factor" := 1
                            else
                                GenJnlLine."Currency Factor" := FactorDivisa;
                            //GenJnlLine."Currency Factor" :=  pPurchHeader."Currency Factor";
                        end;
                    2:
                        Begin
                            GenJnlLine."Source Currency Code" := '';
                            GenJnlLine."Currency Code" := '';
                            GenJnlLine."Currency Factor" := 1;
                        end;
                end;
                GenJnlLine."Account Type" := GenJnlLine."Account Type"::Vendor;

                if ParGenJnlType = 3 then Begin
                    if (IntNum = 2) AND (pPurchHeader."Currency Code" <> '') then Begin
                        GenJnlLine.Amount := -((pPurchHeader."Purch. Amount DetrAction" / FactorDivisa)) * SymbolNum;
                        GenJnlLine."Amount (LCY)" := -Round((pPurchHeader."Purch. Amount DetrAction" / FactorDivisa),
                        GLSetup."Amount Rounding Precision") * SymbolNum;
                        if (ABS(GenJnlLine."Amount (LCY)" - GenJnlLine.Amount) < ABS(0.01))
                          AND (pPurchHeader."Legal Status" = pPurchHeader."Legal Status"::OutFlow) then
                            GenJnlLine.Amount := GenJnlLine."Amount (LCY)";
                    end else Begin
                        GenJnlLine.Amount := -pPurchHeader."Purch. Amount DetrAction" * SymbolNum;
                        GenJnlLine."Amount (LCY)" := -Round((pPurchHeader."Purch. Amount DetrAction" / GenJnlLine."Currency Factor"),
                        GLSetup."Amount Rounding Precision") * SymbolNum;
                        if (ABS(GenJnlLine."Amount (LCY)" - GenJnlLine.Amount) < ABS(0.01))
                          AND (pPurchHeader."Legal Status" = pPurchHeader."Legal Status"::OutFlow) then
                            GenJnlLine.Amount := GenJnlLine."Amount (LCY)";
                    end;

                    case intNum OF
                        1:
                            GenJnlLine."Applies-to doc. Type" := GenJnlLine."Applies-to doc. Type"::"Credit Memo";
                        2:
                            Begin
                                //GenJnlLine."Applies-to doc. Type":=0;
                                //GenJnlLine."Applies-to doc. No.":='';
                            end;
                    end;
                end else Begin
                    case intNum OF
                        1:
                            Begin
                                GenJnlLine.Amount := pPurchHeader."Purch. Amount DetrAction" * SymbolNum;
                                GenJnlLine."Amount (LCY)" := Round(pPurchHeader."Purch. Amount DetrAction" / GenJnlLine."Currency Factor",
                                GLSetup."Amount Rounding Precision") * SymbolNum;
                            end;
                        2:
                            Begin
                                GenJnlLine.Amount := ImporteDL * SymbolNum;
                                GenJnlLine."Amount (LCY)" := ImporteDL * SymbolNum;
                            end;
                    end;
                    if intNum = 1 then
                        GenJnlLine."Applies-to doc. Type" := GenJnlLine."Applies-to doc. Type"::Invoice;
                end;

                GenJnlLine."VAT Calculation Type" := GenJnlLine."VAT Calculation Type"::"Normal VAT";
                GenJnlLine."VAT Posting" := GenJnlLine."VAT Posting"::"Manual VAT Entry";
                GenJnlLine."Shortcut Dimension 1 Code" := pPurchHeader."Shortcut Dimension 1 Code";
                GenJnlLine."Shortcut Dimension 2 Code" := pPurchHeader."Shortcut Dimension 2 Code";
                GenJnlLine."Source Code" := ParSrcCode;
                GenJnlLine."Source Type" := GenJnlLine."Source Type"::Vendor;
                GenJnlLine."Source No." := pPurchHeader."Pay-to Vendor No.";
                GenJnlLine."Posting No. Series" := pPurchHeader."Posting No. Series";
                GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";
                GenJnlLine."Legal document" := pPurchHeader."Legal document";
                GenJnlLine."Legal Status" := pPurchHeader."Legal Status";
                GenJnlLine."Posting Text" := pPurchHeader."Posting Text";
                //Begin ULN::CRM 008 2018.07.03
                //GenJnlLine."document Type" := pPurchHeader."document Type";
                //Begin ULN::CRM 008 2018.07.03                

                GenJnlPostLine.RunWithCheck(GenJnlLine);
            end;
        end;
    end;

    procedure GenerateDetrActionFile(ParGenJnlLine: Record "Gen. Journal Line")
    var
        GenJnlLine: Record "Gen. Journal Line";
        PurchInvHeader: Record "Purch. inv. Header";
        VendLedgEntry: Record "Vendor Ledger Entry";
        VendLedgEntryTemp: Record "Vendor Ledger Entry" temporary;
        TelecreditUtility: Codeunit "Telecredit Utility";
        GenJnlLine2: Record "Gen. Journal Line";
        PENAmount: Decimal;
        StrPENAmount: Text;
        PurchasesSetup: Record "Purchases & Payables Setup";
        StrDirectory: Text;
        StrString: Text;
        StrLine: Text;
        intCount: integer;
        Company: Record "Company information";
        StrName: Text;
        intI: integer;
        LotNumber: integer;
        LotString: Text;
        StrLot: Text;
        Vendor: Record "Vendor";
        invoiceVend: Text;
        StrInvoiceVend: Text;
        CurrenctAcc: Text;
        StrCurrenctAcc: Text;
        NetPlus: Decimal;
        Month: integer;
        StrMonth: Text;
        YearText: Text;
        StrText: Text;
        ControlFile: Record "ST Control File";
        EntryNo: integer;
        FileInStream: inStream;
        FileOutStream: OutStream;
        Campos: array[5] of Text[30];
        Guion: integer;
        CSerie: Text[30];
        CNumero: Text[30];
        StrNumero: Text[30];
        i: integer;
        StrSerie: Text[30];
        FileName: Text;
        SLSetup: Record "Setup Localization";
        Text001: Label 'No existen Movimientos que Exportar';
        Text003: Label 'No hay Importes a Pagar';
        Text004: Label 'El Proveedor %1 no tiene asignado un Número de RUC';
        Text005: Label 'El RUC del Proveedor %1 debe tener una longitud de 11 Dígitos';
        Text006: Label 'Ya existe el Archivo Generado en ese rango de fechas, desea sobreescribirlo?';
        Text007: Label 'Se ha generado el archivo';
        Confirmdownload: Label 'do you want to download the following file?', comment = 'ESM="¿Desea descargar el archivo?"';
    Begin
        Clear(Campos);
        GLSetup.GET;
        SLSetup.Get();
        SLSetup.TestField("SUNAT Generation Date");
        VendLedgEntryTemp.DELETEALL;
        Clear(StrString);
        Clear(StrLine);
        TempFileBlob.CreateOutStream(FileOutStream, TextEncoding::UTF8);
        intCount := 1;
        GenJnlLine.Reset();
        GenJnlLine.SetRange(GenJnlLine."Journal Template Name", ParGenJnlLine."Journal Template Name");
        GenJnlLine.SetRange(GenJnlLine."Journal Batch Name", ParGenJnlLine."Journal Batch Name");
        GenJnlLine.SetFilter(GenJnlLine."Account Type", '=%1', GenJnlLine."Account Type"::Vendor);
        if GenJnlLine.FindSet then Begin
            repeat
                if GenJnlLine."Account Type" = GenJnlLine."Account Type"::Vendor then //Vendor
                    Begin
                    //if is a grouped Payment
                    if GenJnlLine."Applies-to doc. No." = '' then Begin
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange(VendLedgEntry."Applies-to ID", GenJnlLine."document No.");
                        if VendLedgEntry.FindSet then Begin
                            //Inserting the lines
                            repeat
                                VendLedgEntryTemp := VendLedgEntry;
                                VendLedgEntryTemp.Insert(true);
                            until VendLedgEntry.Next() = 0;
                        end
                        else
                            Error(Text001);
                    end
                    else Begin
                        //if is individual payment
                        VendLedgEntry.Reset();
                        VendLedgEntry.SetRange(VendLedgEntry."Vendor No.", GenJnlLine."Account No.");
                        VendLedgEntry.SetRange(VendLedgEntry."document No.", GenJnlLine."Applies-to doc. No.");
                        if VendLedgEntry.FindSet then Begin
                            VendLedgEntryTemp := VendLedgEntry;
                            VendLedgEntryTemp.Insert(true);
                        end
                        else
                            Error(Text001);
                    end;
                end;
                PENAmount += Round(GenJnlLine."Amount (LCY)", 1);
                StrPENAmount := format(GenJnlLine."Amount (LCY)", 0, 1);
            until GenJnlLine.Next() = 0;
            //Exporting to TXT
            VendLedgEntryTemp.Reset();
            if VendLedgEntryTemp.FindFirst then Begin
                //Indicator
                StrString := '*';
                //RUC
                Company.Get();
                StrString := StrString + Company."VAT Registration No.";
                StrName := GetTextAdjust(Company.Name, 35, '<', ' ');

                StrString := StrString + StrName;
                SLSetup.TestField("SUNAT Generation Date");
                if SLSetup."SUNAT Generation Date" <> 0D then Begin
                    if Date2DMY(SLSetup."SUNAT Generation Date", 3) < Date2DMY(WORKDATE, 3) then Begin
                        SLSetup."Correlative SUNAT" := 0;
                        SLSetup."SUNAT Generation Date" := CALCDATE('<-CY>', WORKDATE);
                        SLSetup.Modify(true);
                    end;
                end;
                if SLSetup."Correlative SUNAT" = 0 then Begin
                    LotNumber := 1;
                    SLSetup."Correlative SUNAT" := 1;
                    SLSetup.Modify(true);
                end
                else Begin
                    LotNumber := (SLSetup."Correlative SUNAT") + 1;
                    SLSetup."Correlative SUNAT" := LotNumber;
                    SLSetup.Modify(true);
                end;
                LotString := format(LotNumber);

                for intI := StrLen(format(LotNumber)) + 1 to 4 do
                    LotString := '0' + LotString;
                Campos[1] := 'D';
                Campos[2] := Company."VAT Registration No.";
                Campos[4] := format(LotString);
                VendLedgEntryTemp.Reset();
                if VendLedgEntryTemp.FindFirst() then
                    repeat
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", VendLedgEntryTemp."document No.");
                        PurchInvHeader.SetRange("Purch. DetrAction", true);
                        if PurchInvHeader.Find('-') then
                            if intCount = 1 then Begin
                                StrLot := CopyStr(format(Date2DMY(PurchInvHeader."document Date", 3)), 3, 2) + LotString;
                                Campos[3] := CopyStr(format(Date2DMY(PurchInvHeader."document Date", 3)), 3, 2);
                                StrString := StrString + StrLot;
                                intCount += 1;
                            end;
                    until VendLedgEntryTemp.Next() = 0;
                Campos[3] := format(SLSetup."SUNAT Generation Date", 0, '<Year,2>');
                if PENAmount > 0 then Begin
                    StrPENAmount := format(Round(PENAmount, 1)) + '00';
                    StrPENAmount := DelChr(StrPENAmount, '=', ',');
                    StrPENAmount := DelChr(StrPENAmount, '=', '.');
                end else
                    Error(Text003, PENAmount);

                StrPENAmount := GetTextAdjust(StrPENAmount, 15, '>', '0');

                StrString := StrString + StrPENAmount;
                FileOutStream.WriteText(StrString);
                FileOutStream.WriteText;
                ///////////////////DETAIL////////////////
                VendLedgEntryTemp.Reset();
                if VendLedgEntryTemp.FindSet then Begin
                    repeat
                        Clear(StrLine);
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange(PurchInvHeader."No.", VendLedgEntryTemp."document No.");
                        PurchInvHeader.SetRange(PurchInvHeader."Purch. DetrAction", true);
                        if PurchInvHeader.FindSet then Begin
                            REPEAT
                                //RUC
                                Vendor.Reset();
                                Vendor.SetRange(Vendor."No.", PurchInvHeader."Buy-from Vendor No.");
                                if Vendor.FindSet then Begin
                                    if Vendor."VAT Registration No." = '' then
                                        Error(Text004, PurchInvHeader."Buy-from Vendor No.");

                                    if StrLen(Vendor."VAT Registration No.") <> 11 then
                                        Error(Text005, PurchInvHeader."Buy-from Vendor No.");

                                    StrLine := StrLine + '6' + Vendor."VAT Registration No.";
                                end;
                                StrLine := StrLine + PadStr('', 35, ' ');
                                invoiceVend := CopyStr(DelChr(PurchInvHeader."Vendor invoice No.", '=', '-'), 1, 9);
                                StrInvoiceVend := invoiceVend;
                                for intI := StrLen(InvoiceVend) + 1 to 9 do
                                    StrInvoiceVend := StrInvoiceVend + ' ';

                                StrLine := StrLine + StrInvoiceVend;
                                //SERVICE CODE
                                StrLine := StrLine + PurchInvHeader."Type of Service";
                                //Account No.
                                Vendor.Reset();
                                Vendor.SetRange(Vendor."No.", PurchInvHeader."Buy-from Vendor No.");
                                if Vendor.FindSet then Begin
                                    Vendor.TestField("Currenct Account BNAC");
                                    CurrenctAcc := Vendor."Currenct Account BNAC";
                                end;
                                StrCurrenctAcc := CurrenctAcc;
                                for intI := StrLen(CurrenctAcc) + 1 to 11 do
                                    StrCurrenctAcc := StrCurrenctAcc + ' ';

                                StrLine := StrLine + StrCurrenctAcc;
                                //Getting amounts in DetrAction Local Currency

                                GenJnlLine2.Reset();
                                GenJnlLine2.SetRange("Journal Template Name", ParGenJnlLine."Journal Template Name");
                                GenJnlLine2.SetRange("Journal Batch Name", ParGenJnlLine."Journal Batch Name");
                                GenJnlLine2.SetRange(GenJnlLine2."Applies-to doc. No.", VendLedgEntryTemp."document No.");
                                if GenJnlLine2.FindSet then Begin
                                    NetPlus := Round(GenJnlLine2."Amount (LCY)", 1);
                                    StrPENAmount := format(GenJnlLine2."Amount (LCY)", 0, 1);
                                end else Begin
                                    NetPlus := Round(PurchInvHeader."Purch Amount Detraction LCY", 1);
                                    StrPENAmount := format(GenJnlLine2."Balance (LCY)", 0, 1);
                                end;
                                if NetPlus > 0 then Begin
                                    StrPENAmount := format(Round(NetPlus, 0.01)) + '00';
                                    StrPENAmount := DelChr(StrPENAmount, '=', ',');
                                    StrPENAmount := DelChr(StrPENAmount, '=', '.');
                                end
                                else
                                    Error(Text003, NetPlus);

                                for intI := (StrLen(StrPENAmount) + 1) to 15 do
                                    StrPENAmount := '0' + StrPENAmount;

                                StrLine := StrLine + StrPENAmount;

                                //Type of Operation
                                StrLine := StrLine + PurchInvHeader."Type of Operation";
                                //The year and month should Not be in the format of Sunat
                                Month := Date2DMY(PurchInvHeader."document Date", 2);
                                if Month < 10 then
                                    StrMonth := '0' + format(Month)
                                else
                                    StrMonth := format(Month);

                                YearText := format(Date2DMY(PurchInvHeader."document Date", 3));
                                StrText := YearText + StrMonth;
                                StrLine := StrLine + StrText;

                                //TIPO DE COMPROBANTE
                                StrLine := StrLine + PurchInvHeader."Legal document";

                                Guion := 0;
                                CSerie := '';
                                CNumero := '';
                                Guion := STRPOS(PurchInvHeader."Vendor invoice No.", '-');
                                if Guion <> 0 then Begin
                                    CSerie := CopyStr(PurchInvHeader."Vendor invoice No.", 1, Guion - 1);
                                    CSerie := CopyStr(CSerie, 1, 4);
                                    CNumero := CopyStr(PurchInvHeader."Vendor invoice No.", Guion + 1, 8);
                                end;

                                StrSerie := CSerie;
                                StrNumero := CNumero;
                                //SERIE COMPROBANTE
                                for i := StrLen(CSerie) + 1 to 4
                                do
                                    StrSerie := '0' + StrSerie;
                                StrLine := StrLine + StrSerie;

                                //NUMERO COMPROBANTE
                                for i := StrLen(CNumero) + 1 to 8
                                do Begin
                                    StrNumero := '0' + StrNumero;
                                end;
                                StrLine := StrLine + StrNumero;
                                FileOutStream.WriteText(StrLine);
                                FileOutStream.WriteText;
                            UNTIL PurchInvHeader.Next() = 0;
                        end;
                    until VendLedgEntryTemp.Next = 0;
                    ControlFile.Reset();
                    ControlFile.SetRange("File Name", Campos[1] + Campos[2] + Campos[3] + Campos[4] + '.txt');
                    if ControlFile.FindSet then Begin
                        if Confirm(Text006) then
                            ControlFile.DELETEALL;
                    end;
                    ControlFile.Reset();
                    if ControlFile.FindLAST then
                        EntryNo := ControlFile."Entry No." + 1
                    else
                        EntryNo := 1;

                    FileName := Campos[1] + Campos[2] + Campos[3] + Campos[4];
                    TempFileBlob.CreateInStream(FileInStream);
                    ControlFile.CreateControlFileRecord('DETRAC', FileName, 'txt', WorkDate, WorkDate, FileInStream);
                    if EntryNo <> 0 then
                        if Confirm(Confirmdownload, false) then Begin
                            ControlFile.Get(EntryNo);
                            ControlFile.downLoadFile(ControlFile);
                        end;
                    TelecreditUtility.fnMessageNotificationRemittanceFiles(FileName, STRSUBSTNO('Se creó el archivo para el documento %1', ParGenJnlLine."Document No."));
                end;
            end;
        end;
    end;

    local procedure GetTextAdjust(pInputText: Text; pLenght: Integer; pDirection: Text[10]; pCharacter: Text[10]): Text
    var
    begin
        case true OF
            (StrLen(pInputText) = 0):
                exit(PadStr('', pLenght, pCharacter));
            (StrLen(pInputText) < pLenght) AND (pDirection = '<'):
                exit(pInputText + PadStr('', pLenght - StrLen(pInputText), pCharacter));
            (StrLen(pInputText) < pLenght) AND (pDirection = '>'):
                exit(PadStr('', pLenght - StrLen(pInputText), pCharacter) + pInputText);
            (StrLen(pInputText) > pLenght) AND (pDirection = '<'):
                exit(CopyStr(pInputText, 1, pLenght));
            (StrLen(pInputText) > pLenght) AND (pDirection = '>'):
                exit(CopyStr(pInputText, StrLen(pInputText) - pLenght, pLenght));
            (StrLen(pInputText) = pLenght):
                exit(pInputText);
        END;
    end;


    procedure GetDetrActionAmounts(lrCabCompra: Record "Purchase Header"; VAR vImporteBase: Decimal; VAR vImporteDL: Decimal; VAR vFactorDivisa: Decimal)
    var
        myInt: integer;
        lrConfig: Record "General Ledger Setup";
        lrDivisa: Record Currency;
    Begin
        lrConfig.FindFirst;

        if lrCabCompra."Currency Code" = '' then Begin
            vImporteBase := Round(lrCabCompra."Purch. Amount DetrAction", lrConfig."Amount Rounding Precision");
            vImporteDL := vImporteBase;
            vFactorDivisa := 1;
        end
        else Begin
            lrDivisa.GET(lrCabCompra."Currency Code");
            lrDivisa.TestField("Amount Rounding Precision");
            vImporteDL := Round(lrCabCompra."Purch Amount DetrAction (DL)", lrConfig."Amount Rounding Precision");
            vImporteBase := Round(lrCabCompra."Purch. Amount DetrAction", lrDivisa."Amount Rounding Precision");
            vFactorDivisa := vImporteBase / vImporteDL;
        end;
    end;

    procedure ValidateTypeOfServiceSales(var pTypeofServiceCode: Code[10]; var pSalesDetracPerc: Decimal)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        //Clear(ParTypeofService);
        //Clear(pSalesDetracPerc);
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            pTypeofServiceCode := DetracServOpe.Code;
            pSalesDetracPerc := DetracServOpe."DetrAction Percentage";
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfOperationSales(var pTypeOperationCode: Code[10])
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 1);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            pTypeOperationCode := DetracServOpe.Code;
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfServiceItem(VAR ParTypeofService: Code[10]; LookUpMode: Boolean)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        case LookUpMode OF
            true:
                Begin
                    Clear(ParTypeofService);
                    PgDetracServOpe.SetTableView(DetracServOpe);
                    PgDetracServOpe.SetRecord(DetracServOpe);
                    PgDetracServOpe.LookUpMode(true);
                    if PgDetracServOpe.RunModal = Action::LookupOK then Begin
                        PgDetracServOpe.GetRecord(DetracServOpe);
                        ParTypeofService := DetracServOpe.Code;
                    end;
                end;
            false:
                Begin
                    if ParTypeofService <> '' then Begin
                        DetracServOpe.SetRange(Code, ParTypeofService);
                        DetracServOpe.FindSet;
                        ParTypeofService := DetracServOpe.Code;
                        //       ParPurchDetrac := lclTypeOfSO."DetrAction Percentage";
                    end;
                end;
        end;

        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfServiceItem(VAR ParTypeofService: Text)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeofService);
        // Clear(ParPurchDetrac);
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            ParTypeofService := DetracServOpe.Code;
            //  ParPurchDetrac := lclTypeOfSO."DetrAction Percentage";
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfOperationItem(VAR ParTypeOfOperation: Text)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeOfOperation);
        DetracServOpe.SetFilter("Type Services/Operation", '%1', 1);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            ParTypeOfOperation := DetracServOpe.Code;
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidateTypeOfServiceAnticipo(VAR ParTypeofService: Text; VAR ParPurchDetrac: Decimal)
    var
        DetracServOpe: Record "DetrAction Services Operation";
        PgDetracServOpe: Page "DetrAction Services/Operation";
    Begin
        Clear(ParTypeofService);
        Clear(ParPurchDetrac);
        DetracServOpe.SetFilter(DetracServOpe."Type Services/Operation", '%1', 0);
        PgDetracServOpe.SetTableView(DetracServOpe);
        PgDetracServOpe.SetRecord(DetracServOpe);
        PgDetracServOpe.LookUpMode(true);
        if PgDetracServOpe.RunModal = Action::LookupOK then Begin
            PgDetracServOpe.GetRecord(DetracServOpe);
            ParTypeofService := DetracServOpe.Code;
            ParPurchDetrac := DetracServOpe."DetrAction Percentage";
        end;
        Clear(PgDetracServOpe);
    end;

    procedure ValidatePurchInvoice(PurchHeader: Record "Purchase Header")
    var
        CurrExchangeRate: Record "Currency Exchange Rate";
        ExisteTipoCambio: Boolean;
    begin
        PurchHeader.TestField("Legal document");
        if PurchHeader."Legal document" = '01' then
            PurchHeader.TestField("Legal Property Type");
        if PurchHeader."Purch. Detraction" then begin
            PurchHeader.TestField("Type of Service");
            PurchHeader.TestField("Type of Operation");
            PurchHeader.TestField("Purch. % Detraction");
        end;
    end;

    local procedure Update()
    var
        myInt: integer;
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnRunOnBeforeFinalizePosting', '', true, true)]
    local procedure SetMakeDetractionGenJournalLine(var PurchaseHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShipmentHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean)
    var
        codeunit90: Codeunit 90;
        documentNo: Code[20];
        ExtdocumentNo: Code[30];
        GenJnlLinedocType: integer;
        SourceCodeSetup: Record "Source Code Setup";
        SrcCode: Code[10];
        GLEntry: Record "G/L Entry";
        TransactionNo: integer;
    begin
        if (PurchaseHeader."Purch. Detraction") and (not PurchaseHeader."Exclude Validation") then begin
            PurchaseHeader.TestField("Applies-to Doc. No.", '');
            PurchaseHeader.TestField("Applies-to Entry No.", 0);
        end;
        SourceCodeSetup.Get();
        SrcCode := SourceCodeSetup.Purchases;
        case PurchaseHeader."document Type" of
            PurchaseHeader."document Type"::Invoice:
                begin
                    documentNo := PurchInvHeader."No.";
                    ExtdocumentNo := PurchInvHeader."Vendor invoice No.";
                    GenJnlLinedocType := 2;
                end;
            PurchaseHeader."document Type"::"Credit Memo":
                begin
                    documentNo := PurchCrMemoHdr."No.";
                    ExtdocumentNo := PurchCrMemoHdr."Vendor Cr. Memo No.";
                    GenJnlLinedocType := 3;
                end;
        end;
        MakeGenJnlDetrAction(PurchaseHeader, documentNo, ExtdocumentNo, GenJnlLinedocType, SrcCode);
        // GLEntry.Reset();
        // GLEntry.SetRange("document No.", documentNo);
        // GLEntry.SetCurrentKey("Transaction No.");
        // IF GLEntry.FindFirst then
        //     TransactionNo := GLEntry."Transaction No.";
        // GLEntry.Reset();
        // GLEntry.SetRange("document No.", documentNo);
        // GLEntry.SetFilter("Transaction No.", '<>%1', TransactionNo);
        // IF GLEntry.FindSet then begin
        //     repeat
        //         GLEntry."Transaction No." := TransactionNo;
        //         GLEntry.Modify();
        //     until GLEntry.Next = 0;
        // end;
        //OnRunOnBeforeFinalizePosting(
        //  PurchHeader, PurchRcptHeader, PurchInvHeader, PurchCrMemoHeader, ReturnShptHeader, GenJnlPostLine, SuppressCommit);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterAppliesToDocNoOnLookup', '', true, true)]
    procedure OnAfterAppliesToDocNoOnLookup(var PurchaseHeader: Record "Purchase Header"; VendorLedgerEntry: Record "Vendor Ledger Entry")
    begin
        if PurchaseHeader."Purch. Detraction" then
            PurchaseHeader.TestField("Purch. Detraction", false);
        PurchaseHeader."Applies-to Entry No." := VendorLedgerEntry."Entry No.";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnBeforeConfirmPost', '', true, true)]
    local procedure SetPurchValidation(PurchaseHeader: Record "Purchase Header"; HideDialog: Boolean)
    begin
        ValidatePurchInvoice(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Accountant Book Management", 'OnAfterSetInformationFromPurchDocument', '', false, false)]
    local procedure SetOnAfterSetInformationFromPurchDocument(var PurchRecordBuffer: Record "Purchase Record Buffer" temporary; var VATEntry: Record "VAT Entry")
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
    begin
        if VATEntry.Type <> VATEntry.Type::Purchase then
            exit;
        if VATEntry."Legal Document" = '07' then begin
            //PurchCrMemoHdr.Get(VATEntry."Document No.");
        end else begin
            PurchInvHeader.Get(VATEntry."Document No.");
            PurchRecordBuffer."Detraction Emision Date" := PurchInvHeader."Purch Date Detraction";
            PurchRecordBuffer."Detraction Operation No." := PurchInvHeader."Purch. Detraction Operation";
        end;
    end;
}