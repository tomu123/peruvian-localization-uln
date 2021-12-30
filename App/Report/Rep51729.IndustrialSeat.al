report 51029 "Industrial Seat"
{
    // version ULN-V15.1,ULN:AINDUSTRIAL

    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/IndustrialSeat.rdl';
    Caption = 'Industrial Seat', Comment = 'ESM="Asiento industrial"';
    Permissions = TableData 169 = rimd,
                  TableData 5802 = rimd;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                WHERE("ST I.S. Processed" = CONST(false));

            trigger OnPreDataItem()
            begin
                d.OPEN(TEXT3);
                "Value Entry".SETFILTER("Posting Date", '%1..%2', 0D, gEndDate);
            end;
        }
        dataitem("Job Ledger Entry"; "Job Ledger Entry")
        {
            DataItemTableView = WHERE("ST I.S. Processed" = CONST(false));
            RequestFilterFields = "Job No.";

            trigger OnAfterGetRecord()
            begin
                num := num + 10000;
                DEBIT := '';
                CREDIT := '';
                //CONSUMO DE SERVICIO
                IF ("Entry Type" = "Job Ledger Entry"."Entry Type"::Usage) AND (Type = Type::"G/L Account") THEN BEGIN
                    IF COPYSTR("No.", 1, 1) = '6' THEN BEGIN
                        // Busqueda configuracion
                        IF "Gen. Prod. Posting Group" = '' THEN BEGIN
                            //"Gen. Prod. Posting Group":='PROYECTO';
                            glGLAccount.GET("Job Ledger Entry"."No.");
                            //     "Job Ledger Entry"."Gen. Prod. Posting Group" := glGLAccount."Gen. Prod. Posting Group";
                        END;

                        gJobPostingGroup := '';
                        if "Job Posting Group" = '' then begin
                            if gJob.Get("Job Ledger Entry"."Job No.") then begin
                                gJob.TestField("Job Posting Group");
                                gJobPostingGroup := gJob."Job Posting Group";
                            end;
                        end
                        else
                            gJobPostingGroup := "Job Ledger Entry"."Job Posting Group";

                        if gJobPostingGroup = '' then
                            Error('Grupo Registro Proyecto debe tener valor en mov. ' + Format("Job Ledger Entry"."Entry No."));

                        // Message('Tipo Cuenta ' + gJobPostingGroup);
                        GeneralPostingSetupProyecto.GET(gJobPostingGroup);//;"Gen. Prod. Posting Group");
                        GeneralPostingSetupProyecto.TESTFIELD("WIP Costs Account");
                        GeneralPostingSetupProyecto.TESTFIELD("WIP Accrued Costs Account");


                        CREDIT := GeneralPostingSetupProyecto."WIP Costs Account";
                        DEBIT := GeneralPostingSetupProyecto."WIP Accrued Costs Account";

                        //ULN:PC 28.11.20 Begin
                        j_line."Journal Template Name" := gRecGeneralLedgerSetup."ST Industrial Template";
                        ;
                        j_line."Journal Batch Name" := gRecGeneralLedgerSetup."ST Industrial Batch Name";
                        //j_line."Journal Template Name":='GENERAL';
                        //j_line."Journal Batch Name":='S-PROYEC';
                        //ULN:PC 28.11.20 End
                        j_line."Line No." := num;
                        j_line."Account Type" := j_line."Account Type"::"G/L Account";
                        j_line.VALIDATE("Account No.", DEBIT);
                        j_line.Description := 'Variacion de proyecto de Serv.';
                        j_line.VALIDATE("Bal. Account No.", CREDIT);
                        j_line."System-Created Entry" := TRUE;
                        j_line.Validate("Dimension Set ID", "Dimension Set ID");
                        j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                        j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");

                        j_line."Job No." := "Job No.";
                        j_line."Job Task No." := "Job Task No.";
                        j_line."Posting Date" := "Posting Date";
                        j_line."Document No." := "Document No.";
                        IF "Total Cost (LCY)" > 0 THEN
                            j_line.VALIDATE("Debit Amount", "Total Cost (LCY)") ELSE
                            j_line.VALIDATE("Credit Amount", ABS("Total Cost (LCY)"));
                        j_line."Source Code" := 'COSTPRO';

                        j_line.INSERT;
                        "ST I.S. Processed" := TRUE;
                        MODIFY;
                    END;
                END;

                IF ("Entry Type" = "Entry Type"::Usage) AND (Type = Type::Item) THEN BEGIN
                    CALCFIELDS("Total (LCY)");
                    IF "Job Ledger Entry"."Total (LCY)" <> 0 THEN
                        "Total Cost (LCY)" := "Total (LCY)";
                    IF "Job Ledger Entry"."Total Cost (LCY)" = 0 THEN
                        "Job Ledger Entry"."Total Cost (LCY)" := "Job Ledger Entry"."Total Cost";
                    //Grupo Registro Proyecto+++++
                    gJobPostingGroup := '';
                    if "Job Posting Group" = '' then begin
                        if gJob.Get("Job Ledger Entry"."Job No.") then begin
                            gJob.TestField("Job Posting Group");
                            gJobPostingGroup := gJob."Job Posting Group";
                        end;
                    end
                    else
                        gJobPostingGroup := "Job Ledger Entry"."Job Posting Group";

                    if gJobPostingGroup = '' then
                        Error('Grupo Registro Proyecto debe tener valor en mov. ' + Format("Job Ledger Entry"."Entry No."));
                    //------------------------
                    //Message('Tipo Producto ' + gJobPostingGroup);
                    GeneralPostingSetupProyecto.GET(gJobPostingGroup);//;"Gen. Prod. Posting Group");            

                    GeneralPostingSetupProyecto.TESTFIELD("ST Destination Prod. 79");
                    GeneralPostingSetupProyecto.TESTFIELD("ST Destination Prod. 92");

                    GeneralPostingSetupProyecto.TESTFIELD("WIP Costs Account");
                    GeneralPostingSetupProyecto.TESTFIELD("WIP Accrued Costs Account");

                    CREDIT := GeneralPostingSetupProyecto."ST Destination Prod. 79";
                    DEBIT := GeneralPostingSetupProyecto."ST Destination Prod. 92";
                    //ULN:PC 28.11.20 Begin
                    j_line."Journal Template Name" := gRecGeneralLedgerSetup."ST Industrial Template";
                    ;
                    j_line."Journal Batch Name" := gRecGeneralLedgerSetup."ST Industrial Batch Name";
                    //j_line."Journal Template Name":='GENERAL';
                    //j_line."Journal Batch Name":='S-PROYEC';
                    //ULN:PC 28.11.20 End
                    j_line."Line No." := num;
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", DEBIT);
                    j_line.Description := 'Variacion de proyecto';
                    j_line.VALIDATE("Bal. Account No.", CREDIT);
                    j_line."System-Created Entry" := TRUE;
                    j_line.Validate("Dimension Set ID", "Dimension Set ID");
                    j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                    j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");

                    j_line."Job No." := "Job No.";
                    j_line."Job Task No." := "Job Task No.";
                    j_line."Posting Date" := "Posting Date";
                    j_line."Document No." := "Document No.";
                    IF "Total Cost (LCY)" > 0 THEN
                        j_line.VALIDATE("Debit Amount", "Total Cost (LCY)")
                    ELSE
                        j_line.VALIDATE("Credit Amount", ABS("Total Cost (LCY)"));
                    j_line."Source Code" := 'COSTPRO';

                    //  j_line.INSERT; PC 27.08.21 OMITIR ASIENTO DESTINO


                    // Busqueda configuracion
                    num := num + 10000;
                    GeneralPostingSetupProyecto.GET(gJobPostingGroup);//;"Gen. Prod. Posting Group");            

                    CREDIT := GeneralPostingSetupProyecto."WIP Costs Account";
                    DEBIT := GeneralPostingSetupProyecto."WIP Accrued Costs Account";

                    //ULN:PC 28.11.20 Begin
                    j_line."Journal Template Name" := gRecGeneralLedgerSetup."ST Industrial Template";
                    ;
                    j_line."Journal Batch Name" := gRecGeneralLedgerSetup."ST Industrial Batch Name";
                    //j_line."Journal Template Name":='GENERAL';
                    //j_line."Journal Batch Name":='S-PROYEC';
                    //ULN:PC 28.11.20 End
                    j_line."Line No." := num;
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", DEBIT);
                    j_line.Description := 'Variacion de Proyecto Pr.';
                    j_line.VALIDATE("Bal. Account No.", CREDIT);
                    j_line."System-Created Entry" := TRUE;
                    j_line.Validate("Dimension Set ID", "Dimension Set ID");
                    j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                    j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                    j_line."Job No." := "Job No.";
                    j_line."Job Task No." := "Job Task No.";
                    j_line."Posting Date" := "Posting Date";
                    j_line."Document No." := "Document No.";
                    IF "Total Cost (LCY)" > 0 THEN
                        j_line.VALIDATE("Debit Amount", "Total Cost (LCY)") ELSE
                        j_line.VALIDATE("Credit Amount", ABS("Total Cost (LCY)"));
                    j_line."Source Code" := 'COSTPRO';

                    j_line.INSERT;
                    "ST I.S. Processed" := TRUE;
                    MODIFY;

                END;

                IF ("Entry Type" = "Entry Type"::Usage) AND (Type = "Job Ledger Entry".Type::Resource) THEN BEGIN
                    //CALCFIELDS("Total DL")  ;
                    //"Total Cost (LCY)":= "Total DL";
                    IF "Job Ledger Entry"."Total Cost (LCY)" = 0 THEN
                        "Job Ledger Entry"."Total Cost (LCY)" := "Job Ledger Entry"."Total Cost";
                    //Grupo Registro Proyecto+++++
                    gJobPostingGroup := '';
                    if "Job Posting Group" = '' then begin
                        if gJob.Get("Job Ledger Entry"."Job No.") then begin
                            gJob.TestField("Job Posting Group");
                            gJobPostingGroup := gJob."Job Posting Group";
                        end;
                    end
                    else
                        gJobPostingGroup := "Job Ledger Entry"."Job Posting Group";

                    if gJobPostingGroup = '' then
                        Error('Grupo Registro Proyecto debe tener valor en mov. ' + Format("Job Ledger Entry"."Entry No."));
                    //------------------------
                    // Message('Tipo Recurso ' + gJobPostingGroup);
                    GeneralPostingSetupProyecto.GET(gJobPostingGroup);//;"Gen. Prod. Posting Group");

                    GeneralPostingSetupProyecto.TESTFIELD("WIP Costs Account");
                    GeneralPostingSetupProyecto.TESTFIELD("WIP Accrued Costs Account");

                    // Busqueda configuracion

                    CREDIT := GeneralPostingSetupProyecto."WIP Costs Account";
                    DEBIT := GeneralPostingSetupProyecto."WIP Accrued Costs Account";

                    //ULN:PC 28.11.20 Begin
                    j_line."Journal Template Name" := gRecGeneralLedgerSetup."ST Industrial Template";
                    ;
                    j_line."Journal Batch Name" := gRecGeneralLedgerSetup."ST Industrial Batch Name";
                    //j_line."Journal Template Name":='GENERAL';
                    //j_line."Journal Batch Name":='S-PROYEC';
                    //ULN:PC 28.11.20 End
                    j_line."Line No." := num;
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", DEBIT);
                    j_line.Description := 'Variacion de Proyecto Pr.';
                    j_line.VALIDATE("Bal. Account No.", CREDIT);
                    j_line."System-Created Entry" := TRUE;
                    j_line.Validate("Dimension Set ID", "Dimension Set ID");
                    j_line.VALIDATE("Shortcut Dimension 1 Code", "Global Dimension 1 Code");
                    j_line.VALIDATE("Shortcut Dimension 2 Code", "Global Dimension 2 Code");
                    j_line."Job No." := "Job No.";
                    j_line."Job Task No." := "Job Task No.";
                    j_line."Posting Date" := "Posting Date";
                    j_line."Document No." := "Document No.";
                    IF "Total Cost (LCY)" > 0 THEN
                        j_line.VALIDATE("Debit Amount", "Total Cost (LCY)") ELSE
                        j_line.VALIDATE("Credit Amount", ABS("Total Cost (LCY)"));
                    j_line."Source Code" := 'COSTPRO';

                    j_line.INSERT;
                    "ST I.S. Processed" := TRUE;
                    MODIFY;

                END;
            end;

            trigger OnPostDataItem()
            begin
                //ULN:PC 28.11.20 Begin
                j_line.SETFILTER("Journal Template Name", gRecGeneralLedgerSetup."ST Industrial Template");
                j_line.SETFILTER("Journal Batch Name", gRecGeneralLedgerSetup."ST Industrial Batch Name");
                //j_line.SETFILTER("Journal Template Name",'GENERAL');
                //j_line.SETFILTER("Journal Batch Name",'S-PROYEC');
                //ULN:PC 28.11.20 End

                j_line.SETRANGE(Amount, 0);
                j_line.DELETEALL;
                j_line.RESET;
                //ULN:PC 28.11.20 Begin
                j_line.SETFILTER("Journal Template Name", gRecGeneralLedgerSetup."ST Industrial Template");
                j_line.SETFILTER("Journal Batch Name", gRecGeneralLedgerSetup."ST Industrial Batch Name");
                //j_line.SETFILTER("Journal Template Name",'GENERAL');
                //j_line.SETFILTER("Journal Batch Name",'S-PROYEC');
                //ULN:PC 28.11.20 End

                d.CLOSE();
                IF j_line.COUNT > 0 THEN
                    CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post Batch", j_line);
            end;

            trigger OnPreDataItem()
            begin
                //ULN:PC 28.11.20 Begin
                gRecGeneralLedgerSetup.GET;
                gRecGeneralLedgerSetup.TESTFIELD("ST Industrial Template");
                gRecGeneralLedgerSetup.TESTFIELD("ST Industrial Batch Name");
                j_line.SETFILTER("Journal Template Name", gRecGeneralLedgerSetup."ST Industrial Template");
                j_line.SETFILTER("Journal Batch Name", gRecGeneralLedgerSetup."ST Industrial Batch Name");
                //ULN:PC 28.11.20 End
                // j_line.SETFILTER("Journal Template Name",'GENERAL');
                // j_line.SETFILTER("Journal Batch Name",'S-PROYEC');
                j_line.DELETEALL;
                COMMIT;
                if gJobNo <> '' then
                    "Job Ledger Entry".SetRange("Job No.", gJobNo);

                "Job Ledger Entry".SETFILTER("Posting Date", '%1..%2', 0D, gEndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Fin"; gEndDate)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }


    var
        gJobNo: Code[20];
        POS: Integer;
        Vatentry: Record "VAT Entry";
        j_line: Record "Gen. Journal Line";
        num: Integer;
        GeneralPostingSetup: Record "General Posting Setup";
        DEBIT: Code[20];
        CREDIT: Code[10];
        InventoryPostingSetup: Record "Inventory Posting Setup";
        d: Dialog;
        Analytic: Label 'Analytic no active to account';
        TEXT2: Label 'No hay datos a registrar !';
        TEXT3: Label 'Location Peru, Analytic Process...';
        GeneralPostingSetupProyecto: Record "Job Posting Group";
        gGLEntry: Record "G/L Entry";
        gJobLedgerEntry: Record "Job Ledger Entry";
        GiNITquat: Integer;
        gPossibleAmt: Decimal;
        gGLEntry2: Record "G/L Entry";
        GjOBlEDGEReNTRY2: Record "Job Ledger Entry";
        GvALUEeNTRY: Record "Value Entry";
        glGLAccount: Record "G/L Account";
        gEndDate: Date;
        gRecGeneralLedgerSetup: Record "Setup Localization";
        gJob: Record Job;
        gJobPostingGroup: Text;
}

