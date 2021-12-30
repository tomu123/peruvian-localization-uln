report 51028 "Register Cost of Sales"
{
    // version NAVW17.00

    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/RegisterCostSales.rdl';
    Caption = 'Job Post WIP to G/L', Comment = 'ESM="Resgistro costo de venta"';
    Permissions = TableData 169 = rm;
    ProcessingOnly = false;
    UseSystemPrinter = false;
    Description = 'ULN::PC:ASIND';
    dataset
    {
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = WHERE("ST Sale Cost to process" = CONST(true));
            RequestFilterFields = "Job No.";
            column(Procesado_JobLedgerEntry; "Job Ledger Entry"."ST Processed")
            {
            }
            column(Procesarcostodeventa_JobLedgerEntry; "Job Ledger Entry"."ST Sale Cost to process")
            {
            }
            column(CostodeventaProcesado_JobLedgerEntry; "Job Ledger Entry"."ST Sale Cost processed")
            {
            }
            column(TotalCostLCY_JobLedgerEntry; gToProcess)
            {
            }
            column(EntryNo_JobLedgerEntry; "Job Ledger Entry"."Entry No.")
            {
            }
            column(JobNo_JobLedgerEntry; "Job Ledger Entry"."Job No.")
            {
            }
            column(PostingDate_JobLedgerEntry; "Job Ledger Entry"."Posting Date")
            {
            }
            column(DocumentNo_JobLedgerEntry; "Job Ledger Entry"."Document No.")
            {
            }
            column(Type_JobLedgerEntry; "Job Ledger Entry".Type)
            {
            }
            column(No_JobLedgerEntry; "Job Ledger Entry"."No.")
            {
            }

            trigger OnAfterGetRecord()
            begin
                //BEGIN @CCL::8.1.18 ++
                "Job Ledger Entry".CALCFIELDS("Job Ledger Entry"."ST Percentage Costed");
                IF ("Job Ledger Entry"."ST Percentage Costed") = 100 THEN
                    ERROR('No puedes procesar un porcentaje mayor al disponible.');

                IF (gPercentage) = 0 THEN
                    ERROR('No puedes procesar un porcentaje 0.');
                //END @CCL::8.1.18 ++

                IF (Type = Type::"G/L Account") AND (COPYSTR("No.", 1, 1) <> '6') THEN
                    CurrReport.SKIP;
                "Job Ledger Entry".CALCFIELDS("ST Percentage Costed");
                IF "Job Ledger Entry"."ST Percentage Costed" = 100 THEN CurrReport.SKIP;

                //IF PostingDate < "Job Ledger Entry"."Posting Date"  THEN
                //  ERROR('No se puede procesar un costo de venta con consumo posterior');
                IF "Job Ledger Entry"."ST Percentage Costed" = 0 THEN
                    glCostAmount := "Job Ledger Entry"."Total Cost"
                ELSE BEGIN
                    "Job Ledger Entry".CALCFIELDS("ST Sales Process Cost (LCY)");
                    glCostAmount := "Job Ledger Entry"."Total Cost" - "Job Ledger Entry"."ST Sales Process Cost (LCY)";
                END;

                //gPercentage := (100 - "Job Ledger Entry"."ST Percentage Costed") * gPercentage / 100;


                IF gPercentage <> 0 THEN
                    gToProcess := ROUND(gPercentage * ("Job Ledger Entry"."Total Cost (LCY)" - "Job Ledger Entry"."ST Sales Process Cost (LCY)") / 100, 0.01);
                //gToProcess :=ROUND(gPercentage * glCostAmount/100,0.01)

                // IF "Job Ledger Entry"."Total Cost (LCY)"<0 THEN
                //  gToProcess := ABS(gToProcess);
                //History*****************
                gEntryIndustrialSeatTemp.Init();
                gEntryIndustrialSeatTemp.TransferFields("Job Ledger Entry");
                gEntryIndustrialSeatTemp."ST Entry No. Related" := "Job Ledger Entry"."Entry No.";
                gEntryIndustrialSeatTemp."ST Entry No. Related Sales" := NoMov;
                gEntryIndustrialSeatTemp."ST Related Document" := DocNo;
                gEntryIndustrialSeatTemp."Process Date" := WorkDate();
                gEntryIndustrialSeatTemp."Posting Date" := PostingDate;
                gEntryIndustrialSeatTemp."ST Processed Cost (LCY)" := gToProcess;
                gEntryIndustrialSeatTemp."Entry Type" := gEntryIndustrialSeatTemp."Entry Type"::Sale;
                gEntryIndustrialSeatTemp."USERID Process" := UserId;
                gPercentageCalculado := 0;
                gPercentageCalculado := Round((gToProcess * 100) / "Job Ledger Entry"."Total Cost (LCY)", 0.01);
                gEntryIndustrialSeatTemp."ST Percentage" := gPercentageCalculado;
                gEntryIndustrialSeatTemp."ST Percentage Process" := gPercentage;
                gEntryIndustrialSeatTemp.Insert();
                //History*****************
                MODIFY;


                IF Registrar = TRUE THEN BEGIN
                    num := num + 10000;
                    DEBIT := '';
                    CREDIT := '';

                    IF ("Entry Type" = "Entry Type"::Usage) THEN BEGIN
                        IF (Type = Type::"G/L Account") AND (COPYSTR("No.", 1, 1) = '4') THEN
                            CurrReport.SKIP;
                        //******************************************************************************************
                        // Busqueda configuracion
                        if gJob.Get("Job Ledger Entry"."Job No.") then begin
                            gJob.TestField("Job Posting Group");
                            "Gen. Prod. Posting Group" := "Job Posting Group";
                        end;

                        IF "Gen. Prod. Posting Group" = ''
                          THEN
                            "Gen. Prod. Posting Group" := 'PROYECTO';
                        GeneralPostingSetupProyecto.GET("Gen. Prod. Posting Group");
                        GeneralPostingSetupProyecto.TESTFIELD("WIP Costs Account");
                        GeneralPostingSetupProyecto.TESTFIELD("WIP Accrued Costs Account");
                        DEBIT := GeneralPostingSetupProyecto."WIP Accrued Costs Account";
                        CREDIT := GeneralPostingSetupProyecto."WIP Costs Account";
                        num := num + 10000;
                        j_line."Journal Template Name" := gSetupLocalization."ST Industrial Template";
                        j_line."Journal Batch Name" := gSetupLocalization."ST Industrial Batch Name";
                        j_line."Line No." := num;
                        j_line."Account Type" := j_line."Account Type"::"G/L Account";
                        j_line.VALIDATE("Account No.", DEBIT);
                        j_line.Description := 'Variacion de Proyecto Ventas';
                        j_line.VALIDATE("Bal. Account No.", CREDIT);
                        j_line."System-Created Entry" := TRUE;
                        j_line.VALIDATE("Dimension Set ID", "Dimension Set ID");
                        j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        j_line."Job No." := "Job No.";
                        j_line."Posting Date" := PostingDate;
                        //BEGIN @CCL::22.12.17 ++
                        j_line."ST Document CV" := "Job Ledger Entry"."Document No.";
                        j_line."ST Account CV" := "Job Ledger Entry"."No.";
                        j_line."ST Date CV" := TODAY;
                        //END @CCL::22.12.17 ++
                        j_line."Document No." := DocNo;
                        j_line."External Document No." := "External Document No.";//22.01 pruebas job entry
                        j_line."ST Job Process" := TRUE;
                        //  IF "Procesado DL" >0 THEN
                        //   j_line.VALIDATE("Debit Amount",gToProcess) ELSE
                        //     j_line.VALIDATE("Credit Amount",ABS(gToProcess))   ;
                        IF "Job Ledger Entry"."Total Cost (LCY)" < 0 THEN
                            j_line.VALIDATE("Debit Amount", ABS(gToProcess))
                        ELSE
                            j_line.VALIDATE("Credit Amount", gToProcess);
                        j_line."Source Code" := 'COSTPRO';
                        j_line.INSERT;
                        GeneralPostingSetupProyecto.TESTFIELD("ST Application Cost PT");
                        GeneralPostingSetupProyecto.TESTFIELD("Job Costs Applied Account");
                        DEBIT := GeneralPostingSetupProyecto."ST Application Cost PT";
                        CREDIT := GeneralPostingSetupProyecto."Job Costs Applied Account";
                        num := num + 10000;
                        j_line."Journal Template Name" := gSetupLocalization."ST Industrial Template";
                        j_line."Journal Batch Name" := gSetupLocalization."ST Industrial Batch Name";
                        j_line."Line No." := num;
                        j_line."Account Type" := j_line."Account Type"::"G/L Account";
                        j_line.VALIDATE("Account No.", DEBIT);
                        j_line.Description := 'Variacion de Proyecto Ventas';
                        j_line.VALIDATE("Bal. Account No.", CREDIT);
                        j_line."System-Created Entry" := TRUE;
                        j_line.VALIDATE("Dimension Set ID", "Dimension Set ID");
                        j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        j_line."Job No." := "Job No.";
                        j_line."Posting Date" := PostingDate;
                        j_line."Document No." := DocNo;
                        j_line."External Document No." := "External Document No.";//22.01 pruebas job entry
                        //BEGIN @CCL::22.12.17 ++
                        j_line."ST Document CV" := "Job Ledger Entry"."Document No.";
                        j_line."ST Account CV" := "Job Ledger Entry"."No.";
                        j_line."ST Date CV" := TODAY;
                        //END @CCL::22.12.17 ++
                        j_line."ST Job Process" := TRUE;
                        //  IF "Procesado DL" >0 THEN
                        //   j_line.VALIDATE("Debit Amount",gToProcess) ELSE
                        //     j_line.VALIDATE("Credit Amount",ABS(gToProcess))   ;
                        IF "Job Ledger Entry"."Total Cost (LCY)" < 0 THEN
                            j_line.VALIDATE("Debit Amount", ABS(gToProcess))
                        ELSE
                            j_line.VALIDATE("Credit Amount", gToProcess);
                        j_line."Source Code" := 'COSTPRO';
                        j_line.INSERT;
                        GeneralPostingSetupProyecto.TESTFIELD("Recognized Sales Account");
                        GeneralPostingSetupProyecto.TESTFIELD("Job Costs Applied Account");
                        CREDIT := GeneralPostingSetupProyecto."Recognized Sales Account";
                        DEBIT := GeneralPostingSetupProyecto."Job Costs Applied Account";
                        num := num + 10000;
                        j_line."Journal Template Name" := gSetupLocalization."ST Industrial Template";
                        j_line."Journal Batch Name" := gSetupLocalization."ST Industrial Batch Name";
                        j_line."Line No." := num;
                        j_line."Account Type" := j_line."Account Type"::"G/L Account";
                        j_line.VALIDATE("Account No.", DEBIT);
                        j_line.Description := 'Variacion de Proyecto Ventas';
                        j_line.VALIDATE("Bal. Account No.", CREDIT);
                        j_line."System-Created Entry" := TRUE;
                        j_line.VALIDATE("Dimension Set ID", "Dimension Set ID");
                        j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        j_line."Job No." := "Job No.";
                        j_line."Posting Date" := PostingDate;
                        //BEGIN @CCL::22.12.17 ++
                        j_line."ST Account CV" := "Job Ledger Entry"."No.";
                        j_line."ST Date CV" := TODAY;
                        j_line.Amount := "Job Ledger Entry"."ST Sales Process Cost (LCY)" * (gPercentage / 100);
                        //END @CCL::22.12.17 ++
                        j_line."Document No." := DocNo;
                        j_line."External Document No." := "External Document No.";//22.01 pruebas job entry
                        j_line."ST Job Process" := TRUE;
                        //  IF "Procesado DL">0 THEN
                        //   j_line.VALIDATE("Debit Amount",gToProcess) ELSE
                        //     j_line.VALIDATE("Credit Amount",ABS(gToProcess))   ;
                        IF "Job Ledger Entry"."Total Cost (LCY)" < 0 THEN
                            j_line.VALIDATE("Debit Amount", ABS(gToProcess))
                        ELSE
                            j_line.VALIDATE("Credit Amount", gToProcess);
                        j_line."Source Code" := 'COSTPRO';
                        j_line.INSERT;

                    END;
                    "ST Sale Cost processed" := TRUE;
                    "Job Ledger Entry"."ST Entry No. Cost of Sale" := NoMov;
                    "Job Ledger Entry"."ST Sales Process Cost (LCY)" := gToProcess;
                    //001
                    RecVentasRegistradas.RESET;
                    IF RecVentasRegistradas.FINDLAST THEN
                        lclEntryNo := RecVentasRegistradas."Entry No.";
                    lclEntryNo := lclEntryNo + 1;
                    RecVentasRegistradas.INIT;
                    RecVentasRegistradas."Entry No." := lclEntryNo;
                    RecVentasRegistradas."Job No." := "Job Ledger Entry"."Job No.";
                    RecVentasRegistradas."Job Task No." := "Job Ledger Entry"."Job Task No.";
                    RecVentasRegistradas."Pla Line No. Draft" := "Job Ledger Entry"."Entry No.";
                    RecVentasRegistradas."Processed Sales Cost" := gToProcess;
                    RecVentasRegistradas."Nro. Processed Sales" := NoMov;
                    RecVentasRegistradas."Process Date" := PostingDate;
                    IF gPercentage <> 0 THEN
                        RecVentasRegistradas.Percentage := gPercentageCalculado;
                    //ELSE
                    //      RecVentasRegistradas.Percentage := "Job Ledger Entry"."ST Percentage to cost";
                    RecVentasRegistradas.INSERT;
                    //001
                    MODIFY;
                END;
                IF Registrar THEN
                    "Job Ledger Entry"."ST Sale Cost to process" := FALSE;
                "Job Ledger Entry"."ST Percentage to cost" := 0;
                MODIFY;
            end;

            trigger OnPostDataItem()
            begin

                j_line.CALCSUMS(Amount);
                IF Registrar = TRUE THEN BEGIN
                    j_line.SETFILTER("Journal Template Name", gSetupLocalization."ST Industrial Template");
                    j_line.SETFILTER("Journal Batch Name", gSetupLocalization."ST Industrial Batch Name");
                    j_line.SETRANGE(Amount, 0);
                    j_line.DELETEALL;
                    j_line.RESET;
                    j_line.SETFILTER("Journal Template Name", gSetupLocalization."ST Industrial Template");
                    j_line.SETFILTER("Journal Batch Name", gSetupLocalization."ST Industrial Batch Name");
                    IF j_line.COUNT > 0 THEN
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", j_line);
                END;
                //History*****************
                gEntryIndustrialSeat.Reset();

                gEntryIndustrialSeat.SetAscending("Entry No.", true);
                if gEntryIndustrialSeat.FindLast() then
                    gLastLineNo += gEntryIndustrialSeat."Entry No." + 1
                else
                    gLastLineNo += 1;

                if Registrar then
                    if gEntryIndustrialSeatTemp.FindSet() then
                        repeat
                            gEntryIndustrialSeat.Init();
                            gEntryIndustrialSeat.Copy(gEntryIndustrialSeatTemp);
                            gEntryIndustrialSeat."Entry No." := gLastLineNo;
                            gEntryIndustrialSeat.Insert();
                        until gEntryIndustrialSeatTemp.Next() = 0;
                //History*****************
            end;

            trigger OnPreDataItem()
            begin
                IF Registrar = TRUE
                THEN BEGIN
                    gSetupLocalization.Get();
                    gSetupLocalization.TESTFIELD("ST Industrial Template");
                    gSetupLocalization.TESTFIELD("ST Industrial Batch Name");
                    j_line.SETFILTER("Journal Template Name", gSetupLocalization."ST Industrial Template");
                    j_line.SETFILTER("Journal Batch Name", gSetupLocalization."ST Industrial Batch Name");
                    //ULN:PC 28.11.20 Begin
                    //  j_line.SETFILTER("Journal Template Name",gSetupLocalization."ST Industrial Template");
                    // j_line.SETFILTER("Journal Batch Name",gSetupLocalization."ST Industrial Batch Name");
                    //ULN:PC 28.11.20 End
                    j_line.DELETEALL;
                    COMMIT;


                    "Job Ledger Entry".SetFilter("ST Percentage Costed", '<>%1', 100);
                    gEntryIndustrialSeatTemp.DeleteAll();
                END;

                IF gJobNo <> '' THEN
                    SETRANGE("Job No.", gJobNo);
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
                    Caption = 'Options';
                    field(ReversalPostingDate; PostingDate)
                    {
                        Caption = 'Reversal Posting Date';
                    }
                    field(ReversalDocumentNo; DocNo)
                    {
                        Caption = 'Reversal Document No.';
                        DrillDown = true;
                        DrillDownPageID = "Posted Sales Invoice";
                        Lookup = true;
                        LookupPageID = "Posted Sales Invoice";
                    }
                    field(gJobNo; gJobNo)
                    {
                        Caption = 'N° Proyecto';
                    }
                    field(Registrar; Registrar)
                    {
                    }
                    field(gPercentage; gPercentage)
                    {
                        Caption = 'Porcentaje Costo';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            IF PostingDate = 0D THEN
                PostingDate := WORKDATE;
            //DocNo := '';
            ReplacePostDate := FALSE;
            JustReverse := FALSE;
        end;


    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        IF DocNo = '' THEN ERROR('Falta el numero de documento, tiene que ser \ el numero de factura de venta');

        gSetupLocalization.Get();
        gSetupLocalization.TESTFIELD("ST Industrial Template");
        gSetupLocalization.TESTFIELD("ST Industrial Batch Name");
    end;

    procedure InitializeRequest(NewDocNo: Code[20])
    begin
    end;

    procedure "#GetDocNo"(pDOCNO: Code[20])
    begin
        DocNo := pDOCNO;
    end;

    procedure "#gETjOBnO"(pJobNo: Code[20])
    begin
        gJobNo := pJobNo;
    end;

    procedure "#getMov"(pJobNoMov: Integer)
    begin
        NoMov := pJobNoMov;
    end;

    var
        JobCalculateWIP: Codeunit "Job Calculate WIP";
        JobCalculateBatches: Codeunit "Job Calculate Batches";
        PostingDate: Date;
        DocNo: Code[20];
        JustReverse: Boolean;
        Text000: Label 'WIP was successfully posted to G/L.';
        ReplacePostDate: Boolean;
        POS: Integer;
        Vatentry: Record "VAT Entry";
        j_line: Record "Gen. Journal Line";
        num: Integer;
        GeneralPostingSetup: Record "General Posting Setup";
        DEBIT: Code[20];
        CREDIT: Code[10];
        InventoryPostingSetup: Record "Inventory Posting Setup";
        d: Dialog;
        GeneralPostingSetupProyecto: Record "Job Posting Group";
        Registrar: Boolean;
        gJobNo: Code[20];
        NoMov: Integer;
        RecVentasRegistradas: Record "Sales Cost Records";
        lclEntryNo: Integer;
        gToProcess: Decimal;
        gPercentage: Decimal;
        gPercentageCalculado: Decimal;
        glCostAmount: Decimal;
        gSetupLocalization: Record "Setup Localization";
        gJob: Record Job;
        gEntryIndustrialSeatTemp: Record "Entry Industrial Seat" temporary;
        gEntryIndustrialSeat: Record "Entry Industrial Seat";
        gLastLineNo: Integer;

}

