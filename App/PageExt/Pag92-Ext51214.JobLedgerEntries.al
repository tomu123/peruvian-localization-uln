pageextension 51214 "ST Job Ledger Entries" extends "Job Ledger Entries"
{
    PromotedActionCategories = 'New,Process,Report,Entry,Industrial Seat', Comment = 'ESM="Nuevo,Proceso,Reporte,Mov.,Asiento Industrial"';

    layout
    {
        // Add changes to page layout here
        addafter("Dimension Set ID")
        {
            field("ST Sale Cost to process"; "ST Sale Cost to process")
            {
                ApplicationArea = All;
            }
            field("ST Sale Cost processed"; "ST Sale Cost processed")
            {
                ApplicationArea = All;
            }
            field("ST Entry No. Cost of Sale"; "ST Entry No. Cost of Sale")
            {
                ApplicationArea = All;
                Description = 'ULN::PC:ASIND';
                Caption = 'No. Mov Cost of Sale', Comment = 'ESM="No. Mov Costo Venta"';

            }
            field("ST Sales Process Cost (LCY)"; "ST Sales Process Cost (LCY)")
            {
                ApplicationArea = All;
                Caption = 'Sales Process Cost (LCY)', Comment = 'ESM="Costo Procesado Ventas (DL)"';

            }
            field(CalculateCostReaming; CalculateCostReaming)
            {
                ApplicationArea = All;
                Caption = 'Sales Process Cost (LCY)', Comment = 'ESM="Costo pendiente Ventas (DL)"';

            }
            field("#GetRatioCost"; "#GetRatioCost")
            {

                ApplicationArea = All;
                Caption = 'Percentage Costed', Comment = 'ESM="Porcentaje Costeado"';
                ExtendedDatatype = Ratio;
            }
            field(CalculateCostReamingPorce; CalculateCostReamingPorce)
            {

                ApplicationArea = All;
                Caption = 'CalculateCostReamingPorce', Comment = 'ESM="Porcentaje pendiente"';
                ExtendedDatatype = Ratio;
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
        addafter("F&unctions")
        {
            group(IndustrialSeat)
            {
                action(SalesCostToProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Sales Cost to process', Comment = 'ESM="Procesar costo de venta"';
                    Image = PostApplication;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        if not Confirm('¿Desea procesar costo de venta?', false) then
                            exit;
                        SalesCostToProcess();
                    end;
                }
                action(MarkJobNonProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Mark job non process', Comment = 'ESM="Marcar proy. no procesado"';
                    Image = SelectLineToApply;
                    Visible = false;
                    Promoted = true;
                    //PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        if not Confirm('¿Desea marcar selección para proyecto no procesado?', false) then
                            exit;
                        MarkJobNonProcess();
                    end;
                }
                action(UnMarkJobNonProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Unmark job non process', Comment = 'ESM="Desmarcar proy. no procesado"';
                    Image = RemoveLine;
                    Visible = false;
                    Promoted = true;
                    //PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    begin
                        if not Confirm('¿Desea desmarcar selección para proyecto no procesado?', false) then
                            exit;
                        UnMarkJobNonProcess();
                    end;
                }
                action(PostCV)
                {
                    ApplicationArea = All;
                    Caption = 'Post CV', Comment = 'ESM="Registrar CV"';
                    Image = Post;
                    Promoted = true;
                    //PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        lclJob: Report "Register Cost of Sales";
                        lclJobEntry: Record "Job Ledger Entry";
                    begin
                        IF "Entry Type" = "Entry Type"::Sale THEN BEGIN
                            CLEAR(lclJob);
                            lclJob."#GetDocNo"("Document No.");
                            lclJob."#getMov"("Entry No.");
                            lclJob."#gETjOBnO"(Rec."Job No.");
                            lclJobEntry.Reset();
                            lclJobEntry.SetRange("Job No.", Rec."Job No.");
                            lclJobEntry.FindSet();
                            lclJob.SetTableView(lclJobEntry);
                            lclJob.RUNMODAL;
                        END;
                    end;
                }
                action(ViewS)
                {
                    ApplicationArea = All;
                    Caption = 'Entry Industrial Seat', Comment = 'ESM="Mov. Costeo"';
                    Image = LedgerEntries;
                    Promoted = true;
                    //PromotedIsBig = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    trigger OnAction()
                    var
                        lclRecEntryIndustrialSeat: Record "Entry Industrial Seat";
                        lclPageEntryIndustrialSeat: Page "Entry Industrial Seat";
                    begin
                        Clear(lclPageEntryIndustrialSeat);
                        lclRecEntryIndustrialSeat.Reset();
                        lclRecEntryIndustrialSeat.SetRange("ST Entry No. Related", "Entry No.");
                        lclPageEntryIndustrialSeat.SetRecord(lclRecEntryIndustrialSeat);
                        lclPageEntryIndustrialSeat.SetTableView(lclRecEntryIndustrialSeat);
                        lclPageEntryIndustrialSeat.RunModal();
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;

    local procedure SalesCostToProcess()
    var
        lclRecSelection: Record "Job Ledger Entry";
        lclRecSelectionReview: Record "Job Ledger Entry";
        lcProcesara: Integer;
        lcNotProcesara: Integer;
        lclText002: Label 'Document No. %1, does not have Industrial Entry, selection not allowed.', Comment = 'ESM="Nº Documento %1, no cuenta con Asiento Industrial , selección no permitida ."';
    begin
        lclRecSelectionReview.RESET;
        CurrPage.SETSELECTIONFILTER(lclRecSelectionReview);
        lclRecSelectionReview.SETRANGE("Entry Type", lclRecSelectionReview."Entry Type"::Usage);
        lclRecSelectionReview.SETRANGE("ST I.S. Processed", false);
        if lclRecSelectionReview.FindFirst() then
            Error(StrSubstNo(lclText002, lclRecSelectionReview."Document No."));

        lclRecSelection.RESET;
        CurrPage.SETSELECTIONFILTER(lclRecSelection);
        lclRecSelection.SETRANGE("Entry Type", lclRecSelection."Entry Type"::Usage);
        IF lclRecSelection.FINDSET THEN BEGIN
            REPEAT
                lclRecSelection.CalcFields("ST Percentage Costed");
                //IF ("Procesar costo de venta"=FALSE ) AND  ("Costo de venta Procesado" = FALSE) THEN BEGIN
                IF (lclRecSelection."ST Sale Cost to process" = FALSE) AND (lclRecSelection."ST Percentage Costed" <> 100) THEN BEGIN
                    lclRecSelection."ST Sale Cost to process" := TRUE;
                    lclRecSelection.MODIFY;
                    lcProcesara += 1;
                    //MESSAGE('Se procesara');
                END ELSE
                    IF (lclRecSelection."ST Sale Cost to process" = TRUE) THEN BEGIN
                        lclRecSelection.VALIDATE("ST Sale Cost to process", FALSE);
                        lclRecSelection.MODIFY;
                        lcNotProcesara += 1;
                        //MESSAGE('No se procesara');
                    END;

            UNTIL lclRecSelection.NEXT = 0;
            MESSAGE('Se procesara ' + FORMAT(lcProcesara) + ' | No se procesara ' + FORMAT(lcNotProcesara));
        END;

    end;

    local procedure MarkJobNonProcess()
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        JobLedgerEntry2: Record "Job Ledger Entry";
        ProcessedJobLineCount: Integer;
    begin
        ProcessedJobLineCount := 0;
        JobLedgerEntry.CopyFilters(Rec);
        if JobLedgerEntry.FindFirst() then
            repeat
                if (not JobLedgerEntry."ST Sale Cost to process") and (not JobLedgerEntry."ST Sale Cost processed") and (JobLedgerEntry."Entry Type" <> JobLedgerEntry."Entry Type"::Sale) then begin
                    JobLedgerEntry2.Get(JobLedgerEntry."Entry No.");
                    JobLedgerEntry2."ST Sale Cost to process" := true;
                    JobLedgerEntry2.Modify();
                    ProcessedJobLineCount += 1;
                end;
            until JobLedgerEntry.Next() = 0;
        Message('Se ha marcado %1 lineas.', ProcessedJobLineCount);
    end;

    local procedure CalculateCostReaming(): Decimal
    begin
        IF "ST I.S. Processed" then begin
            CalcFields("ST Sales Process Cost (LCY)");
            exit("Total Cost (LCY)" - "ST Sales Process Cost (LCY)");
        end else
            exit(0);

    end;

    local procedure CalculateCostReamingPorce(): Decimal
    var
        lclPorcentaje: Decimal;
    begin
        CALCFIELDS("ST Percentage Costed");
        lclPorcentaje := 100 - "ST Percentage Costed";

        IF Rec."ST I.S. Processed" then begin
            EXIT(ROUND(lclPorcentaje / 100 * 10000, 1));
        end else
            exit(0);


    end;

    local procedure UnMarkJobNonProcess()
    var
        JobLedgerEntry: Record "Job Ledger Entry";
        JobLedgerEntry2: Record "Job Ledger Entry";
        ProcessedJobLineCount: Integer;
    begin
        ProcessedJobLineCount := 0;
        JobLedgerEntry.CopyFilters(Rec);
        if JobLedgerEntry.FindFirst() then
            repeat
                if (JobLedgerEntry."ST Sale Cost to process") and (not JobLedgerEntry."ST Sale Cost processed") and (JobLedgerEntry."Entry Type" <> JobLedgerEntry."Entry Type"::Sale) then begin
                    JobLedgerEntry2.Get(JobLedgerEntry."Entry No.");
                    JobLedgerEntry2."ST Sale Cost to process" := false;
                    JobLedgerEntry2.Modify();
                    ProcessedJobLineCount += 1;
                end;
            until JobLedgerEntry.Next() = 0;
        Message('Se ha desmarcado %1 lineas.', ProcessedJobLineCount);
    end;
}