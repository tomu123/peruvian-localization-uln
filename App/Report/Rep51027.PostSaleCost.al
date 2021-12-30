/*report 51027 "Post cost sale"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/PostCostSale.rdl';
    Caption = 'Post sale cost', Comment = 'ESM="Registrar costo de venta"';
    Permissions = TableData "Job Ledger Entry" = rm;
    ProcessingOnly = false;
    UseSystemPrinter = false;

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

            trigger OnAfterGetRecord();
            begin
                //BEGIN @CCL::8.1.18 ++
                "Job Ledger Entry".CalcFields("ST Percentage Costed");
                if ("Job Ledger Entry"."ST Percentage Costed" + Percentage) > 100 then
                    Error('No puedes procesar un porcentaje mayor al disponible.');
                //END @CCL::8.1.18 ++

                if ((Type = Type::"G/L Account") and (COPYSTR("No.", 1, 1) <> '6')) or 
                    ("Job Ledger Entry"."ST Percentage Costed" = 100) then
                    CurrReport.Skip();

                if "Job Ledger Entry"."ST Percentage Costed" = 0 then
                    CostAmount := "Job Ledger Entry"."Total Cost"
                else begin
                    "Job Ledger Entry".CalcFields("Sales Process Cost (LCY)");
                    CostAmount := "Job Ledger Entry"."Total Cost" - "Job Ledger Entry"."Sales Process Cost (LCY)";
                end;

                Percentage := (100 - "Job Ledger Entry"."ST Percentage Costed") * Percentage / 100;

                if Percentage <> 0 then
                    gToProcess := ROUND(Percentage * "Job Ledger Entry"."Total Cost (LCY)" / 100, 0.01)
                //gToProcess :=ROUND(Percentage * CostAmount/100,0.01)
                else
                    gToProcess := ROUND("Job Ledger Entry"."ST Percentage to cost" * "Job Ledger Entry"."Procesado DL" / 100, 0.01);//"Job Ledger Entry"."Sales Process Cost (LCY)";

                MODIFY;


                if Registrar = true then begin
                    num := num + 10000;
                    DebitAmount := '';
                    CREDIT := '';

                    if ("Entry Type" = "Entry Type"::Usage) then begin
                        if (Type = Type::"G/L Account") and (COPYSTR("No.", 1, 1) = '4') then
                            CurrReport.SKIP;
                        //******************************************************************************************
                        // Busqueda configuracion
                        if "Gen. Prod. Posting Group" = ''
                          then
                            "Gen. Prod. Posting Group" := 'PROYECTO';
                        GPostSetupJob.Get("Gen. Prod. Posting Group");
                        GPostSetupJob.TestField("WIP Costs Account");
                        GPostSetupJob.TestField("WIP Accrued Costs Account");
                        DebitAmount := GPostSetupJob."WIP Accrued Costs Account";
                        CREDIT := GPostSetupJob."WIP Costs Account";
                        num := num + 10000;
                        GenJnlLine."Journal Template Name" := 'GENERAL';
                        GenJnlLine."Journal Batch Name" := 'S-PROYEC';
                        GenJnlLine."Line No." := num;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine.Validate("Account No.", DebitAmount);
                        GenJnlLine.Description := 'Variacion de Proyecto Ventas';
                        GenJnlLine.Validate("Bal. Account No.", CREDIT);
                        GenJnlLine."System-Created Entry" := true;
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        GenJnlLine."Job No." := "Job No.";
                        GenJnlLine."Posting Date" := PostingDate;
                        //BEGIN @CCL::22.12.17 ++
                        GenJnlLine."Document CV" := "Job Ledger Entry"."Document No.";
                        GenJnlLine."Account CV" := "Job Ledger Entry"."No.";
                        GenJnlLine."Date CV" := TODAY;
                        //END @CCL::22.12.17 ++
                        GenJnlLine."Document No." := DocNo;
                        GenJnlLine."Job Process" := true;
                        //  IF "Procesado DL" >0 THEN
                        //   GenJnlLine.Validate("Debit Amount",gToProcess) ELSE
                        //     GenJnlLine.Validate("Credit Amount",ABS(gToProcess))   ;
                        if "Job Ledger Entry"."Total Cost (LCY)" < 0 then
                            GenJnlLine.Validate("Debit Amount", ABS(gToProcess))
                        else
                            GenJnlLine.Validate("Credit Amount", gToProcess);
                        GenJnlLine."Source Code" := 'COSTPRO';
                        GenJnlLine.INSERT;
                        GPostSetupJob.TestField("Aplication Cost PT");
                        GPostSetupJob.TestField("Job Costs Applied Account");
                        DebitAmount := GPostSetupJob."Aplication Cost PT";
                        CREDIT := GPostSetupJob."Job Costs Applied Account";
                        num := num + 10000;
                        GenJnlLine."Journal Template Name" := 'GENERAL';
                        GenJnlLine."Journal Batch Name" := 'S-PROYEC';
                        GenJnlLine."Line No." := num;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine.Validate("Account No.", DebitAmount);
                        GenJnlLine.Description := 'Variacion de Proyecto Ventas';
                        GenJnlLine.Validate("Bal. Account No.", CREDIT);
                        GenJnlLine."System-Created Entry" := true;
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        GenJnlLine."Job No." := "Job No.";
                        GenJnlLine."Posting Date" := PostingDate;
                        GenJnlLine."Document No." := DocNo;
                        //BEGIN @CCL::22.12.17 ++
                        GenJnlLine."Document CV" := "Job Ledger Entry"."Document No.";
                        GenJnlLine."Account CV" := "Job Ledger Entry"."No.";
                        GenJnlLine."Date CV" := TODAY;
                        //END @CCL::22.12.17 ++
                        GenJnlLine."Job Process" := true;
                        //  IF "Procesado DL" >0 THEN
                        //   GenJnlLine.Validate("Debit Amount",gToProcess) ELSE
                        //     GenJnlLine.Validate("Credit Amount",ABS(gToProcess))   ;
                        if "Job Ledger Entry"."Total Cost (LCY)" < 0 then
                            GenJnlLine.Validate("Debit Amount", ABS(gToProcess))
                        else
                            GenJnlLine.Validate("Credit Amount", gToProcess);
                        GenJnlLine."Source Code" := 'COSTPRO';
                        GenJnlLine.INSERT;
                        GPostSetupJob.TestField("Recognized Sales Account");
                        GPostSetupJob.TestField("Job Costs Applied Account");
                        CREDIT := GPostSetupJob."Recognized Sales Account";
                        DebitAmount := GPostSetupJob."Job Costs Applied Account";
                        num := num + 10000;
                        GenJnlLine."Journal Template Name" := 'GENERAL';
                        GenJnlLine."Journal Batch Name" := 'S-PROYEC';
                        GenJnlLine."Line No." := num;
                        GenJnlLine."Account Type" := GenJnlLine."Account Type"::"G/L Account";
                        GenJnlLine.Validate("Account No.", DebitAmount);
                        GenJnlLine.Description := 'Variacion de Proyecto Ventas';
                        GenJnlLine.Validate("Bal. Account No.", CREDIT);
                        GenJnlLine."System-Created Entry" := true;
                        GenJnlLine.Validate("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        GenJnlLine.Validate("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                        GenJnlLine."Job No." := "Job No.";
                        GenJnlLine."Posting Date" := PostingDate;
                        //BEGIN @CCL::22.12.17 ++
                        GenJnlLine."Account CV" := "Job Ledger Entry"."No.";
                        GenJnlLine."Date CV" := TODAY;
                        GenJnlLine.Amount := "Job Ledger Entry"."Total Cost" * (Percentage / 100);
                        //END @CCL::22.12.17 ++
                        GenJnlLine."Document No." := DocNo;
                        GenJnlLine."Job Process" := true;
                        //  IF "Procesado DL">0 THEN
                        //   GenJnlLine.Validate("Debit Amount",gToProcess) ELSE
                        //     GenJnlLine.Validate("Credit Amount",ABS(gToProcess))   ;
                        if "Job Ledger Entry"."Total Cost (LCY)" < 0 then
                            GenJnlLine.Validate("Debit Amount", ABS(gToProcess))
                        else
                            GenJnlLine.Validate("Credit Amount", gToProcess);
                        GenJnlLine."Source Code" := 'COSTPRO';
                        GenJnlLine.INSERT;

                    end;
                    "Costo de venta Procesado" := true;
                    "Job Ledger Entry"."No. Mov Costo Venta" := JobLedgerEntryNo;
                    "Job Ledger Entry"."Sales Process Cost (LCY)" := gToProcess;
                    //001
                    RecVentasRegistradas.RESET;
                    if RecVentasRegistradas.FINDLAST then
                        lclEntryNo := RecVentasRegistradas."Entry No.";
                    lclEntryNo := lclEntryNo + 1;
                    RecVentasRegistradas.INIT;
                    RecVentasRegistradas."Entry No." := lclEntryNo;
                    RecVentasRegistradas."No. Proyecto" := "Job Ledger Entry"."Job No.";
                    RecVentasRegistradas."No. Tarea Proyecto" := "Job Ledger Entry"."Job Task No.";
                    RecVentasRegistradas."No. Linea Pla. Proyecto" := "Job Ledger Entry"."Entry No.";
                    RecVentasRegistradas."Costo Venta Procesado" := gToProcess;
                    RecVentasRegistradas."Nro. Venta Procesado" := JobLedgerEntryNo;
                    RecVentasRegistradas."Fecha Proceso" := PostingDate;
                    if Percentage <> 0 then
                        RecVentasRegistradas.Porcentaje := Percentage
                    else
                        RecVentasRegistradas.Porcentaje := "Job Ledger Entry"."ST Percentage to cost";
                    RecVentasRegistradas.INSERT;
                    //001
                    MODIFY;
                end;
                if Registrar then
                    "Job Ledger Entry"."ST Sale Cost to process" := false;
                "Job Ledger Entry"."ST Percentage to cost" := 0;
                MODIFY;
            end;

            trigger OnPostDataItem();
            begin

                GenJnlLine.CALCSUMS(Amount);
                if Registrar = true then begin
                    GenJnlLine.SETFILTER("Journal Template Name", 'GENERAL');
                    GenJnlLine.SETFILTER("Journal Batch Name", 'S-PROYEC');
                    GenJnlLine.SETRANGE(Amount, 0);
                    GenJnlLine.DELETEALL;
                    GenJnlLine.RESET;
                    GenJnlLine.SETFILTER("Journal Template Name", 'GENERAL');
                    GenJnlLine.SETFILTER("Journal Batch Name", 'S-PROYEC');
                    if GenJnlLine.COUNT > 0 then
                        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", GenJnlLine);
                end;
            end;

            trigger OnPreDataItem();
            begin
                if Registrar = true
                then begin

                    GenJnlLine.SETFILTER("Journal Template Name", 'GENERAL');
                    GenJnlLine.SETFILTER("Journal Batch Name", 'S-PROYEC');

                    GenJnlLine.DELETEALL;
                    COMMIT;

                end;

                if gJobNo <> '' then
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
                    CaptionML = ENU = 'Options',
                                ESM = 'Opciones';
                    field(ReversalPostingDate; PostingDate)
                    {
                        CaptionML = ENU = 'Reversal Posting Date',
                                    ESM = 'Fecha registro';
                    }
                    field(ReversalDocumentNo; DocNo)
                    {
                        CaptionML = ENU = 'Reversal Document No.',
                                    ESM = 'Nº documento';
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
                    field(Percentage; Percentage)
                    {
                        Caption = 'Porcentaje Costo';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage();
        begin
            if PostingDate = 0D then
                PostingDate := WORKDATE;
            //DocNo := '';
            ReplacePostDate := false;
            JustReverse := false;
        end;
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        if DocNo = '' then Error('Falta el numero de documento, tiene que ser \ el numero de factura de venta');
    end;

    var
        JobCalculateWIP: Codeunit "Job Calculate WIP";
        JobCalculateBatches: Codeunit "Job Calculate Batches";
        PostingDate: Date;
        DocNo: Code[20];
        JustReverse: Boolean;
        Text000: TextConst ENU = 'WIP was successfully posted to G/L.', ESM = 'WIP registrado correctamente en la contabilidad.';
        ReplacePostDate: Boolean;
        POS: Integer;
        Vatentry: Record "VAT Entry";
        GenJnlLine: Record "Gen. Journal Line";
        num: Integer;
        GeneralPostingSetup: Record "General Posting Setup";
        DebitAmount: Code[20];
        CREDIT: Code[10];
        InventoryPostingSetup: Record "Inventory Posting Setup";
        d: Dialog;
        GPostSetupJob: Record "Job Posting Group";
        Registrar: Boolean;
        gJobNo: Code[20];
        JobLedgerEntryNo: Integer;
        RecVentasRegistradas: Record Table50508;
        lclEntryNo: Integer;
        gToProcess: Decimal;
        Percentage: Decimal;
        CostAmount: Decimal;

    procedure InitializeRequest(NewDocNo: Code[20]);
    begin
    end;

    procedure "#GetDocNo"(pDOCNO: Code[20]);
    begin
        DocNo := pDOCNO;
    end;

    procedure "#gETjOBnO"(pJobNo: Code[20]);
    begin
        gJobNo := pJobNo;
    end;

    procedure "#getMov"(pJobLedgerEntryNo: Integer);
    begin
        JobLedgerEntryNo := pJobLedgerEntryNo;
    end;
}*/

