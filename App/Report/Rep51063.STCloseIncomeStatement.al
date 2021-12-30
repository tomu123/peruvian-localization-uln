report 51063 "ST  Close Income Statement"
{
    // version NAVW19.00

    // No. yyyy.mm.dd  Developer Company    DocNo.       Version     Description
    // -----------------------------------------------------------------------------------------------------
    // 001 2017 06 27  LOF       ULN                     V.001       Add condition for Closing Period.
    // -----------------------------------------------------------------------------------------------------

    Caption = 'Close Income Statement', Comment = 'ESM="Atria Asiento regularización"';
    ProcessingOnly = true;
    UsageCategory = Administration;
    ApplicationArea = All;
    dataset
    {
        dataitem("G/L Account"; "G/L Account")
        {
            DataItemTableView = SORTING("No.")
                                WHERE("Account Type" = CONST(Posting),
                                      "Income/Balance" = CONST("Income Statement"));
            dataitem("G/L Entry"; "G/L Entry")
            {
                DataItemLink = "G/L Account No." = FIELD("No.");
                DataItemTableView = SORTING("G/L Account No.", "Posting Date");

                trigger OnAfterGetRecord()
                var
                    TempDimBuf: Record "Dimension Buffer" temporary;
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    DimensionBufferID: Integer;
                    RowOffset: Integer;
                begin
                    EntryCount := EntryCount + 1;
                    IF TIME - LastWindowUpdate > 1000 THEN BEGIN
                        LastWindowUpdate := TIME;
                        Window.UPDATE(3, ROUND(EntryCount / MaxEntry * 10000, 1));
                    END;

                    IF GroupSum THEN BEGIN
                        CalcSumsInFilter("G/L Entry", RowOffset);
                        GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                    END;

                    IF (Amount <> 0) OR ("Additional-Currency Amount" <> 0) THEN BEGIN
                        IF NOT GroupSum THEN BEGIN
                            TotalAmount += Amount;
                            IF GLSetup."Additional Reporting Currency" <> '' THEN
                                if fnInsertAdicionalCurrencyGLEntry("G/L Entry") then //PC 25.08.21
                                    TotalAmountAddCurr += "Additional-Currency Amount";

                            GetGLEntryDimensions("Entry No.", TempDimBuf, "Dimension Set ID");
                        END;

                        IF TempSelectedDim.FIND('-') THEN
                            REPEAT
                                IF TempDimBuf.GET(DATABASE::"G/L Entry", "Entry No.", TempSelectedDim."Dimension Code")
                                THEN BEGIN
                                    TempDimBuf2."Table ID" := TempDimBuf."Table ID";
                                    TempDimBuf2."Dimension Code" := TempDimBuf."Dimension Code";
                                    TempDimBuf2."Dimension Value Code" := TempDimBuf."Dimension Value Code";
                                    TempDimBuf2.INSERT;
                                END;
                            UNTIL TempSelectedDim.NEXT = 0;

                        DimensionBufferID := DimBufMgt.GetDimensionId(TempDimBuf2);

                        EntryNoAmountBuf.RESET;
                        IF ClosePerBusUnit AND FIELDACTIVE("Business Unit Code") THEN
                            EntryNoAmountBuf."Business Unit Code" := "Business Unit Code"
                        ELSE
                            EntryNoAmountBuf."Business Unit Code" := '';
                        EntryNoAmountBuf."Entry No." := DimensionBufferID;
                        IF EntryNoAmountBuf.FIND THEN BEGIN
                            EntryNoAmountBuf.Amount := EntryNoAmountBuf.Amount + Amount;
                            EntryNoAmountBuf.Amount2 := EntryNoAmountBuf.Amount2 + "Additional-Currency Amount";
                            EntryNoAmountBuf.MODIFY;
                        END ELSE BEGIN
                            EntryNoAmountBuf.Amount := Amount;
                            EntryNoAmountBuf.Amount2 := "Additional-Currency Amount";
                            EntryNoAmountBuf.INSERT;
                        END;
                    END;

                    IF GroupSum THEN
                        NEXT(RowOffset);
                end;

                trigger OnPostDataItem()
                var
                    TempDimBuf2: Record "Dimension Buffer" temporary;
                    GlobalDimVal1: Code[20];
                    GlobalDimVal2: Code[20];
                    NewDimensionID: Integer;
                begin
                    EntryNoAmountBuf.RESET;
                    MaxEntry := EntryNoAmountBuf.COUNT;
                    EntryCount := 0;
                    Window.UPDATE(2, Text012);
                    Window.UPDATE(3, 0);

                    IF EntryNoAmountBuf.FIND('-') THEN
                        REPEAT
                            EntryCount := EntryCount + 1;
                            IF TIME - LastWindowUpdate > 1000 THEN BEGIN
                                LastWindowUpdate := TIME;
                                Window.UPDATE(3, ROUND(EntryCount / MaxEntry * 10000, 1));
                            END;

                            IF (EntryNoAmountBuf.Amount <> 0) OR (EntryNoAmountBuf.Amount2 <> 0) THEN BEGIN
                                GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                                GenJnlLine."Account No." := "G/L Account No.";
                                GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                                GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                                GenJnlLine.VALIDATE(Amount, -EntryNoAmountBuf.Amount);
                                GenJnlLine."Source Currency Amount" := -EntryNoAmountBuf.Amount2;
                                GenJnlLine."Business Unit Code" := EntryNoAmountBuf."Business Unit Code";

                                TempDimBuf2.DELETEALL;
                                DimBufMgt.RetrieveDimensions(EntryNoAmountBuf."Entry No.", TempDimBuf2);
                                NewDimensionID := DimMgt.CreateDimSetIDFromDimBuf(TempDimBuf2);
                                GenJnlLine."Dimension Set ID" := NewDimensionID;
                                DimMgt.UpdateGlobalDimFromDimSetID(NewDimensionID, GlobalDimVal1, GlobalDimVal2);
                                GenJnlLine."Shortcut Dimension 1 Code" := '';
                                IF ClosePerGlobalDim1 THEN
                                    GenJnlLine."Shortcut Dimension 1 Code" := GlobalDimVal1;
                                GenJnlLine."Shortcut Dimension 2 Code" := '';
                                IF ClosePerGlobalDim2 THEN
                                    GenJnlLine."Shortcut Dimension 2 Code" := GlobalDimVal2;

                                HandleGenJnlLine;
                            END;
                        UNTIL EntryNoAmountBuf.NEXT = 0;

                    EntryNoAmountBuf.DELETEALL;
                end;

                trigger OnPreDataItem()
                begin
                    Window.UPDATE(2, Text013);
                    Window.UPDATE(3, 0);

                    IF ClosePerGlobalDimOnly OR ClosePerBusUnit THEN
                        CASE TRUE OF
                            ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Business Unit Code",
                                  "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                            ClosePerBusUnit AND NOT (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Business Unit Code", "Posting Date");
                            NOT ClosePerBusUnit AND (ClosePerGlobalDim1 OR ClosePerGlobalDim2):
                                SETCURRENTKEY(
                                  "G/L Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date");
                        END;

                    SETRANGE("Posting Date", FiscalYearStartDate, FiscYearClosingDate);

                    MaxEntry := COUNT;

                    EntryNoAmountBuf.DELETEALL;
                    EntryCount := 0;

                    LastWindowUpdate := TIME;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ThisAccountNo := ThisAccountNo + 1;
                Window.UPDATE(1, "No.");
                Window.UPDATE(4, ROUND(ThisAccountNo / NoOfAccounts * 10000, 1));
                Window.UPDATE(2, '');
                Window.UPDATE(3, 0);
            end;

            trigger OnPostDataItem()
            begin
                gSetupLocalization.Get();
                IF (TotalAmount <> 0) OR ((TotalAmountAddCurr <> 0) AND (GLSetup."Additional Reporting Currency" <> '')) THEN BEGIN
                    GenJnlLine."Business Unit Code" := '';
                    GenJnlLine."Shortcut Dimension 1 Code" := '';
                    GenJnlLine."Shortcut Dimension 2 Code" := '';
                    GenJnlLine."Dimension Set ID" := 0;
                    GenJnlLine."Line No." := GenJnlLine."Line No." + 10000;
                    GenJnlLine."Account No." := RetainedEarningsGLAcc."No.";
                    GenJnlLine."Source Code" := SourceCodeSetup."Close Income Statement";
                    GenJnlLine."Reason Code" := GenJnlBatch."Reason Code";
                    GenJnlLine."Currency Code" := '';
                    GenJnlLine."Additional-Currency Posting" :=
                      GenJnlLine."Additional-Currency Posting"::None;
                    GenJnlLine.VALIDATE(Amount, TotalAmount);
                    GenJnlLine."Source Currency Amount" := TotalAmountAddCurr;
                    HandleGenJnlLine;
                    Window.UPDATE(1, GenJnlLine."Account No.");
                END;
            end;

            trigger OnPreDataItem()
            begin
                NoOfAccounts := COUNT;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options', Comment = 'ESM="Opciones"';
                    field(FiscalYearEndingDate; EndDateReq)
                    {
                        Caption = 'Fiscal Year Ending Date', Comment = 'ESM="Fecha final ejercicio"';
                        ToolTip = 'Especifica la última fecha del ejercicio cerrado. Esta fecha se usa para determinar la fecha de cierre.';

                        trigger OnValidate()
                        begin
                            ValidateEndDate(TRUE);
                        end;
                    }
                    field(GenJournalTemplate; GenJnlLine."Journal Template Name")
                    {
                        Caption = 'Gen. Journal Template', Comment = 'ESM="Libro del diario general"';
                        TableRelation = "Gen. Journal Template";
                        ToolTip = 'Especifica la plantilla de diario general que se usa en el proceso.';

                        trigger OnValidate()
                        begin
                            GenJnlLine."Journal Batch Name" := '';
                            DocNo := '';
                        end;
                    }
                    field(GenJournalBatch; GenJnlLine."Journal Batch Name")
                    {
                        Caption = 'Gen. Journal Batch', Comment = 'ESM="Sección diario general"';
                        Lookup = true;
                        ToolTip = 'Especifica la sección de diario general que se usa en el proceso.';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            GenJnlLine.TESTFIELD("Journal Template Name");
                            GenJnlTemplate.GET(GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(2);
                            GenJnlBatch.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
                            GenJnlBatch.FILTERGROUP(0);
                            GenJnlBatch."Journal Template Name" := GenJnlLine."Journal Template Name";
                            GenJnlBatch.Name := GenJnlLine."Journal Batch Name";
                            IF PAGE.RUNMODAL(0, GenJnlBatch) = ACTION::LookupOK THEN BEGIN
                                Text := GenJnlBatch.Name;
                                EXIT(TRUE);
                            END;
                        end;

                        trigger OnValidate()
                        begin
                            IF GenJnlLine."Journal Batch Name" <> '' THEN BEGIN
                                GenJnlLine.TESTFIELD("Journal Template Name");
                                GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                            END;
                            ValidateJnl;
                        end;
                    }
                    field(DocumentNo; DocNo)
                    {
                        Caption = 'Document No.', Comment = 'ESM="Nº documento"';
                        ToolTip = 'Especifica el número del documento procesado por el informe o el trabajo por lotes.';
                    }
                    field(RetainedEarningsAcc; RetainedEarningsGLAcc."No.")
                    {
                        Caption = 'Retained Earnings Acc.', Comment = 'ESM="Cta. ganancias retenidas"';
                        TableRelation = "G/L Account" WHERE("No." = CONST('591102|592102'));
                        ToolTip = 'Especifica la cuenta de remanentes en la que el proceso realiza el registro. Esta cuenta debe ser la misma que la que se usa en el proceso Asiento regularización.';

                        trigger OnValidate()
                        begin
                            IF RetainedEarningsGLAcc."No." <> '' THEN BEGIN
                                RetainedEarningsGLAcc.FIND;
                                RetainedEarningsGLAcc.CheckGLAcc;
                            END;
                        end;
                    }
                    field(PostingDescription; PostingDescription)
                    {
                        Caption = 'Posting Description', Comment = 'ESM="Texto de registro"';
                        ToolTip = 'Especifica la descripción que acompaña al registro.';
                    }
                    field(gGlosaPrincipal; gGlosaPrincipal)
                    {
                        Caption = 'Main gloss', Comment = 'ESM="Glosa principal"';
                        ToolTip = 'Especifica la glosa principal que acompaña al registro.';
                    }
                    group("Close by")
                    {
                        Caption = 'Close by', Comment = 'ESM="Cerrado por"';
                        field(ClosePerBusUnit; ClosePerBusUnit)
                        {
                            Caption = 'Business Unit Code', Comment = 'ESM="Cód. empresa"';
                            ToolTip = 'Especifica el código de la unidad de negocio.';
                        }
                        field(Dimensions; ColumnDim)
                        {
                            Caption = 'Dimensions', Comment = 'ESM="Dimensiones"';
                            Editable = false;
                            ToolTip = 'Especifica las dimensiones, como el área, el proyecto o el departamento, que se pueden asignar a los documentos de venta y compra para distribuir costos y analizar el historial de transacciones.';

                            trigger OnAssistEdit()
                            var
                                TempSelectedDim2: Record "Selected Dimension" temporary;
                                s: Text[1024];
                            begin
                                DimSelectionBuf.SetDimSelectionMultiple(3, REPORT::"Close Income Statement", ColumnDim);

                                SelectedDim.GetSelectedDim(USERID, 3, REPORT::"Close Income Statement", '', TempSelectedDim2);
                                s := CheckDimPostingRules(TempSelectedDim2);
                                IF s <> '' THEN
                                    MESSAGE(s);
                            end;
                        }
                    }
                    field(IsInvtPeriodClosed; IsInvtPeriodClosed)
                    {
                        Caption = 'Inventory Period Closed', Comment = 'ESM="Periodo inventario cerrado"';
                        ToolTip = 'Especifica que el periodo de inventario se ha cerrado.';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF PostingDescription = '' THEN
                PostingDescription :=
                  COPYSTR(ObjTransl.TranslateObject(ObjTransl."Object Type"::Report, REPORT::"Close Income Statement"), 1, 30);
            EndDateReq := 0D;
            AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
            AccountingPeriod.SETRANGE("Date Locked", TRUE);
            IF AccountingPeriod.FIND('+') THEN BEGIN
                EndDateReq := AccountingPeriod."Starting Date" - 1;
                IF NOT ValidateEndDate(FALSE) THEN
                    EndDateReq := 0D;
            END;
            ValidateJnl;
            ColumnDim := DimSelectionBuf.GetDimSelectionText(3, REPORT::"Close Income Statement", '');
        end;
    }

    labels
    {
    }

    trigger OnPostReport()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        Window.CLOSE;
        COMMIT;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            MESSAGE(Text016);
            UpdateAnalysisView.UpdateAll(0, TRUE);
        END ELSE
            MESSAGE(Text017);
    end;

    trigger OnPreReport()
    var
        s: Text[1024];
    begin
        IF EndDateReq = 0D THEN
            ERROR(Text000);
        ValidateEndDate(TRUE);
        IF DocNo = '' THEN
            ERROR(Text001);

        SelectedDim.GetSelectedDim(USERID, 3, REPORT::"Close Income Statement", '', TempSelectedDim);
        s := CheckDimPostingRules(TempSelectedDim);
        IF s <> '' THEN
            IF NOT CONFIRM(s + Text007, FALSE) THEN
                ERROR('');

        GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
        SourceCodeSetup.GET;
        GLSetup.GET;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            IF RetainedEarningsGLAcc."No." = '' THEN
                ERROR(Text002);
            IF NOT CONFIRM(
                 Text003 +
                 Text005 +
                 Text007, FALSE)
            THEN
                ERROR('');
        END;

        Window.OPEN(Text008 + Text009 + Text019 + Text010 + Text011);

        ClosePerGlobalDim1 := FALSE;
        ClosePerGlobalDim2 := FALSE;
        ClosePerGlobalDimOnly := TRUE;

        IF TempSelectedDim.FIND('-') THEN
            REPEAT
                IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 1 Code" THEN
                    ClosePerGlobalDim1 := TRUE;
                IF TempSelectedDim."Dimension Code" = GLSetup."Global Dimension 2 Code" THEN
                    ClosePerGlobalDim2 := TRUE;
                IF (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 1 Code") AND
                   (TempSelectedDim."Dimension Code" <> GLSetup."Global Dimension 2 Code")
                THEN
                    ClosePerGlobalDimOnly := FALSE;
            UNTIL TempSelectedDim.NEXT = 0;

        GenJnlLine.SETRANGE("Journal Template Name", GenJnlLine."Journal Template Name");
        GenJnlLine.SETRANGE("Journal Batch Name", GenJnlLine."Journal Batch Name");
        IF NOT GenJnlLine.FINDLAST THEN;
        GenJnlLine.INIT;
        GenJnlLine."Posting Date" := FiscYearClosingDate;
        GenJnlLine."Document No." := DocNo;
        GenJnlLine.Description := PostingDescription;
        GenJnlLine."Posting Text" := gGlosaPrincipal;
        GenJnlLine."Posting No. Series" := GenJnlBatch."Posting No. Series";
    end;

    var
        AccountingPeriod: Record "Accounting Period";
        SourceCodeSetup: Record "Source Code Setup";
        GenJnlTemplate: Record "Gen. Journal Template";
        GenJnlBatch: Record "Gen. Journal Batch";
        GenJnlLine: Record "Gen. Journal Line";
        RetainedEarningsGLAcc: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        DimSelectionBuf: Record "Dimension Selection Buffer";
        SelectedDim: Record "Selected Dimension";
        TempSelectedDim: Record "Selected Dimension" temporary;
        EntryNoAmountBuf: Record "Entry No. Amount Buffer" temporary;
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        DimMgt: Codeunit "DimensionManagement";
        DimBufMgt: Codeunit "Dimension Buffer Management";
        Window: Dialog;
        FiscalYearStartDate: Date;
        FiscYearClosingDate: Date;
        EndDateReq: Date;
        DocNo: Code[20];
        PostingDescription: Text[50];
        ClosePerBusUnit: Boolean;
        ClosePerGlobalDim1: Boolean;
        ClosePerGlobalDim2: Boolean;
        ClosePerGlobalDimOnly: Boolean;
        TotalAmount: Decimal;
        TotalAmountAddCurr: Decimal;
        ColumnDim: Text[250];
        ObjTransl: Record "Object Translation";
        NoOfAccounts: Integer;
        ThisAccountNo: Integer;
        Text000: Label 'Enter the ending date for the fiscal year.', Comment = 'ESM="Escriba la fecha final del ejercicio."';
        Text001: Label 'Enter a Document No.', Comment = 'ESM="Escriba un nº de documento."';
        Text002: Label 'Enter Retained Earnings Account No.', Comment = 'ESM="Escriba un n.º de cuenta de ganancias retenidas"';
        Text003: Label 'By using an additional reporting currency, this batch job will post closing entries directly to the general ledger.  ', Comment = 'ESM="Al utilizar una divisa adicional de informe, el proceso registrará movs. cerrados directamente a contabilidad.  "';
        Text005: Label 'These closing entries will not be transferred to a general journal before the program posts them to the general ledger.\\ ', Comment = 'ESM="Estos movs. cerrados no se transferirán al diario general antes de que el programa los registre en contabilidad.\\ "';
        Text007: Label '\Do you want to continue?', Comment = 'ESM="\¿Desea continuar?"';
        Text008: Label 'Creating general journal lines...\\', Comment = 'ESM="Creando líneas diario general....\\"';
        Text009: Label 'Account No.         #1##################\', Comment = 'ESM="Nº cuenta           #1##################\"';
        Text010: Label 'Now performing      #2##################\', Comment = 'ESM="Ejecutando          #2##################\"';
        Text011: Label '                    @3@@@@@@@@@@@@@@@@@@\';
        Text019: Label '                    @4@@@@@@@@@@@@@@@@@@\';
        Text012: Label 'Creating Gen. Journal lines', Comment = 'ESM="Creando líneas diario general"';
        Text013: Label 'Calculating Amounts', Comment = 'ESM="Calculando importes';
        Text014: Label 'The fiscal year must be closed before the income statement can be closed.', Comment = 'ESM="El ejercicio debe estar cerrado antes de ejecutar la regularización."';
        Text015: Label 'The fiscal year does not exist.', Comment = 'ESM="No existe el ejercicio."';
        Text017: Label 'The journal lines have successfully been created.', Comment = 'ESM="Las líneas de diario se han creado correctamente."';
        Text016: Label 'The closing entries have successfully been posted.', Comment = 'ESM="Las entradas de cierre se han publicado correctamente."';
        Text020: Label 'The following G/L Accounts have mandatory dimension codes that have not been selected:', Comment = 'ESM="No se han seleccionado los códigos de dimensión obligatorios en las siguientes cuentas:"';
        Text021: Label '\\In order to post to these accounts you must also select these dimensions:', Comment = 'ESM="\\Para realizar un registro en estas cuentas también debe seleccionar las siguientes dimensiones:"';
        MaxEntry: Integer;
        EntryCount: Integer;
        LastWindowUpdate: Time;
        gSetupLocalization: Record "Setup Localization";
        gGlosaPrincipal: Text;

    local procedure ValidateEndDate(RealMode: Boolean): Boolean
    var
        OK: Boolean;
    begin
        IF EndDateReq = 0D THEN
            EXIT;

        OK := AccountingPeriod.GET(EndDateReq + 1);
        IF OK THEN
            OK := AccountingPeriod."New Fiscal Year";
        IF OK THEN BEGIN
            IF NOT AccountingPeriod."Date Locked" THEN BEGIN
                IF NOT RealMode THEN
                    EXIT;
                ERROR(Text014);
            END;
            FiscYearClosingDate := CLOSINGDATE(EndDateReq);
            AccountingPeriod.SETRANGE("New Fiscal Year", TRUE);
            OK := AccountingPeriod.FIND('<');
            FiscalYearStartDate := AccountingPeriod."Starting Date";

        END;
        IF NOT OK THEN BEGIN
            IF NOT RealMode THEN
                EXIT;
            ERROR(Text015);
        END;
        EXIT(TRUE);
    end;

    local procedure ValidateJnl()
    begin
        DocNo := '';
        IF GenJnlBatch.GET(GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name") THEN
            IF GenJnlBatch."No. Series" <> '' THEN
                DocNo := NoSeriesMgt.TryGetNextNo(GenJnlBatch."No. Series", EndDateReq);
    end;

    local procedure HandleGenJnlLine()
    begin
        gSetupLocalization.Get();
        GenJnlLine."Additional-Currency Posting" :=
          GenJnlLine."Additional-Currency Posting"::None;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            GenJnlLine."Source Currency Code" := GLSetup."Additional Reporting Currency";
            IF ZeroGenJnlAmount THEN BEGIN
                GenJnlLine."Additional-Currency Posting" :=
                  GenJnlLine."Additional-Currency Posting"::"Additional-Currency Amount Only";
                GenJnlLine.VALIDATE(Amount, GenJnlLine."Source Currency Amount");
                GenJnlLine."Source Currency Amount" := 0;
            END;
            IF GenJnlLine.Amount <> 0 THEN BEGIN
                if gSetupLocalization."Register Regularization" then begin
                    if fnInsertAdicionalCurrency(GenJnlLine) then
                        GenJnlPostLine.RUN(GenJnlLine)
                end
                else begin
                    if fnInsertAdicionalCurrency(GenJnlLine) then
                        GenJnlLine.INSERT;
                end;

                IF GenJnlBatch."No. Series" <> '' THEN
                    IF DocNo = NoSeriesMgt.GetNextNo(GenJnlBatch."No. Series", EndDateReq, FALSE) THEN
                        NoSeriesMgt.SaveNoSeries;
            END;
        END ELSE
            IF NOT ZeroGenJnlAmount THEN
                GenJnlLine.INSERT;
    end;

    local procedure CalcSumsInFilter(var GLEntrySource: Record "G/L Entry"; var Offset: Integer)
    var
        GLEntry: Record "G/L Entry";
    begin
        GLEntry.COPYFILTERS(GLEntrySource);
        IF ClosePerBusUnit THEN BEGIN
            GLEntry.SETRANGE("Business Unit Code", GLEntrySource."Business Unit Code");
            GenJnlLine."Business Unit Code" := GLEntrySource."Business Unit Code";
        END;
        IF ClosePerGlobalDim1 THEN BEGIN
            GLEntry.SETRANGE("Global Dimension 1 Code", GLEntrySource."Global Dimension 1 Code");
            IF ClosePerGlobalDim2 THEN
                GLEntry.SETRANGE("Global Dimension 2 Code", GLEntrySource."Global Dimension 2 Code");
        END;

        GLEntry.CALCSUMS(Amount);
        GLEntrySource.Amount := GLEntry.Amount;
        TotalAmount += GLEntrySource.Amount;
        IF GLSetup."Additional Reporting Currency" <> '' THEN BEGIN
            GLEntry.CALCSUMS("Additional-Currency Amount");
            GLEntrySource."Additional-Currency Amount" := GLEntry."Additional-Currency Amount";
            if fnInsertAdicionalCurrencyGLEntry(GLEntry) then //PC 25.08.21
                TotalAmountAddCurr += GLEntrySource."Additional-Currency Amount";
        END;
        Offset := GLEntry.COUNT - 1;
    end;

    local procedure GetGLEntryDimensions(EntryNo: Integer; var DimBuf: Record "Dimension Buffer"; DimensionSetID: Integer)
    var
        DimSetEntry: Record "Dimension Set Entry";
    begin
        DimSetEntry.SETRANGE("Dimension Set ID", DimensionSetID);
        IF DimSetEntry.FINDSET THEN
            REPEAT
                DimBuf."Table ID" := DATABASE::"G/L Entry";
                DimBuf."Entry No." := EntryNo;
                DimBuf."Dimension Code" := DimSetEntry."Dimension Code";
                DimBuf."Dimension Value Code" := DimSetEntry."Dimension Value Code";
                DimBuf.INSERT;
            UNTIL DimSetEntry.NEXT = 0;
    end;

    local procedure CheckDimPostingRules(var SelectedDim: Record "Selected Dimension"): Text[1024]
    var
        DefaultDim: Record "Default Dimension";
        s: Text[1024];
        d: Text[1024];
        PrevAcc: Code[20];
    begin
        DefaultDim.SETRANGE("Table ID", DATABASE::"G/L Account");
        DefaultDim.SETFILTER(
          "Value Posting", '%1|%2',
          DefaultDim."Value Posting"::"Same Code", DefaultDim."Value Posting"::"Code Mandatory");

        IF DefaultDim.FIND('-') THEN
            REPEAT
                SelectedDim.SETRANGE("Dimension Code", DefaultDim."Dimension Code");
                IF NOT SelectedDim.FIND('-') THEN BEGIN
                    IF STRPOS(d, DefaultDim."Dimension Code") < 1 THEN
                        d := d + ' ' + FORMAT(DefaultDim."Dimension Code");
                    IF PrevAcc <> DefaultDim."No." THEN BEGIN
                        PrevAcc := DefaultDim."No.";
                        IF s = '' THEN
                            s := Text020;
                        s := s + ' ' + FORMAT(DefaultDim."No.");
                    END;
                END;
                SelectedDim.SETRANGE("Dimension Code");
            UNTIL (DefaultDim.NEXT = 0) OR (STRLEN(s) > MAXSTRLEN(s) - MAXSTRLEN(DefaultDim."No.") - STRLEN(Text021) - 1);
        IF s <> '' THEN
            s := COPYSTR(s + Text021 + d, 1, MAXSTRLEN(s));
        EXIT(s);
    end;

    local procedure IsInvtPeriodClosed(): Boolean
    var
        AccPeriod: Record "Accounting Period";
        InvtPeriod: Record "Inventory Period";
    begin
        //001
        IF EndDateReq = 0D THEN
            ERROR(Text014);
        //001
        AccPeriod.GET(EndDateReq + 1);
        AccPeriod.NEXT(-1);
        EXIT(InvtPeriod.IsInvtPeriodClosed(AccPeriod."Starting Date"));
    end;

    procedure InitializeRequestTest(EndDate: Date; GenJournalLine: Record "Gen. Journal Line"; GLAccount: Record "G/L Account"; CloseByBU: Boolean)
    begin
        EndDateReq := EndDate;
        GenJnlLine := GenJournalLine;
        ValidateJnl;
        RetainedEarningsGLAcc := GLAccount;
        ClosePerBusUnit := CloseByBU;
    end;

    local procedure ZeroGenJnlAmount(): Boolean
    begin
        EXIT((GenJnlLine.Amount = 0) AND (GenJnlLine."Source Currency Amount" <> 0))
    end;

    local procedure GroupSum(): Boolean
    begin
        EXIT(ClosePerGlobalDimOnly AND (ClosePerBusUnit OR ClosePerGlobalDim1));
    end;

    local procedure fnInsertAdicionalCurrency(var pGenJournalLine: Record "Gen. Journal Line"): Boolean
    var
        lclRecGLAccount: Record "G/L Account";
        lclRecGenJournalLine: Record "Gen. Journal Line";
    begin
        pGenJournalLine."Line No." := 10000;
        pGenJournalLine."Skip Dimensions" := true;
        //Reajuste Line No
        lclRecGenJournalLine.Reset();
        lclRecGenJournalLine.SetAscending("Line No.", true);
        lclRecGenJournalLine.SetRange("Journal Batch Name", pGenJournalLine."Journal Template Name");
        lclRecGenJournalLine.SetRange("Journal Batch Name", pGenJournalLine."Journal Batch Name");
        if lclRecGenJournalLine.FindLast() then
            pGenJournalLine."Line No." := lclRecGenJournalLine."Line No." + 10000;

        if pGenJournalLine."Account No." = '' then
            exit(false);


        if pGenJournalLine."Account No." = RetainedEarningsGLAcc."No." then
            exit(true);

        //Se revisa si saldo periodo debe ser diferente de 0 para ingresar la divisa adicional
        lclRecGLAccount.Reset();
        lclRecGLAccount.SetRange("No.", pGenJournalLine."Account No.");
        lclRecGLAccount.SetRange("Date Filter", FiscalYearStartDate, FiscYearClosingDate);
        if lclRecGLAccount.FindSet() then begin
            lclRecGLAccount.CalcFields("Balance at Date");
            if lclRecGLAccount."Balance at Date" <> 0 then
                exit(true);
        end;

        exit(false);
    end;

    local procedure fnInsertAdicionalCurrencyGLEntry(var pGLEntry: Record "G/L Entry"): Boolean
    var
        lclRecGLAccount: Record "G/L Account";
        lclRecGenJournalLine: Record "Gen. Journal Line";
    begin


        if pGLEntry."G/L Account No." = '' then
            exit(false);


        if pGLEntry."G/L Account No." = RetainedEarningsGLAcc."No." then
            exit(true);

        //Se revisa si saldo periodo debe ser diferente de 0 para ingresar la divisa adicional
        lclRecGLAccount.Reset();
        lclRecGLAccount.SetRange("No.", pGLEntry."G/L Account No.");
        lclRecGLAccount.SetRange("Date Filter", FiscalYearStartDate, FiscYearClosingDate);
        if lclRecGLAccount.FindSet() then begin
            lclRecGLAccount.CalcFields("Balance at Date");
            if lclRecGLAccount."Balance at Date" <> 0 then
                exit(true);
        end;

        exit(false);
    end;
}

