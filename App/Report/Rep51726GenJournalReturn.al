report 51726 GenJournalReturn
{
    UsageCategory = Administration;
    Caption = 'Importar Planilla';
    ProcessingOnly = true;
    ApplicationArea = All;

    dataset
    {
        dataitem(Integer; 2000000026)
        {
            trigger OnPreDataItem()
            begin
                //FILA DE LECTURA DEL ARCHIVO (A PARTIR DE QUE FILA)
                gFirstLine += 1;
                //--

                IF gRecExcellBuf.FIND('+') THEN
                    SETRANGE(Number, gFirstLine, gRecExcellBuf."Row No.");

                gCountRow := gRecExcellBuf."Row No." - 1; //CANTIDAD TOTAL DE REGISTROS (-1 PARA NO CONTAR LA FILA DE LA CABECERA)
                gCountInsert := 0; //CANTIDAD REGISTRADOS
                gCount := 0; //CONTADOR
                gContBlock := 0;

            end;

            trigger OnAfterGetRecord()
            begin
                gCount += 1;
                "#InitValues"();
                FOR gIntDato := 1 TO 19 DO BEGIN
                    gTxtDato[gIntDato] := '';
                    IF gRecExcellBuf.GET(Number, gIntDato) THEN BEGIN
                        gTxtDato[gIntDato] := UpperCase(gRecExcellBuf."Cell Value as Text");
                        gTxtDato[gIntDato] := DELCHR(gTxtDato[gIntDato], '<>');
                    END;
                END;
                //LISTA DE IMPORTACIONES                
                fnInsertLineas();
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(gSelecDiario; gSelecDiario)
                    {
                        Caption = 'Seleccionar Seccion';
                        TableRelation = "Gen. Journal Batch".Name where("Journal Template Name" = const('PLLAS'));
                        ApplicationArea = All;

                    }
                    field(gFileName; gFileName)
                    {

                        Editable = false;
                        Caption = 'Nombre de fichero';
                        trigger OnAssistEdit()
                        var
                            Excel: InStream;
                            TempBloblocal: Codeunit "Temp Blob";

                        begin
                            FileName := gFileMgt.BLOBImportWithFilter(
                            TempBlob, ImportTxt, FileName, StrSubstNo(FileDialogTxt, FilterTxt), FilterTxt);
                            TempBloblocal := TempBlob;
                            TempBloblocal.CreateInStream(excel);
                            gFileName := FileName;
                            gSheetName := gExcelBuf.SelectSheetsNameStream(excel);
                            COMMIT;

                        end;
                    }
                    field(gSheetName; gSheetName)
                    {
                        Editable = false;
                        Caption = 'Nombre Hoja';
                        trigger OnAssistEdit()
                        var
                            Excel2: InStream;
                        begin
                            gFileName := FileName;
                            TempBlob.CreateInStream(Excel2);
                            gSheetName := gExcelBuf.SelectSheetsNameStream(Excel2);
                        end;

                    }
                }
            }

        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnPreReport()
    begin
        gExcelBuf.LOCKTABLE;
        gExcelBuf.DELETEALL;
        gRecExcellBuf.DeleteAll;
        Clear(gExcelBuf);
        Clear(gRecExcellBuf);

        gFirstLine := 1;
        //-------------------
        "#ReadExcelSheet"(1);
        //-------------------
        COMMIT;

    end;

    trigger OnPostReport()
    begin
        Clear(gExcelBuf);
        Clear(gRecExcellBuf);
    end;

    PROCEDURE "#InitValues"()
    BEGIN
        CLEAR(gTxtDato);
    END;

    LOCAL PROCEDURE "#ReadExcelSheet"(Opcion: Integer);
    var
        excel: InStream;
        TempBloblocal: Codeunit "Temp Blob";
    BEGIN
        TempBloblocal := TempBlob;
        TempBloblocal.CreateInStream(excel);
        //gSheetName := gExcelBuf.SelectSheetsNameStream(excel);
        gExcelBuf.OpenBookStream(excel, gSheetName);
        gExcelBuf.ReadSheet();
        COMMIT;

        //gExcelBuf.ReadSheetContinous(gSheetName, true);

        IF gRecExcellBuf.FINDLAST THEN
            gCountColumnCab := gExcelBuf."Column No.";
    END;

    PROCEDURE "#GetDimensionSetID"(): Integer;
    VAR
        lclDimensionSetEntry: Record 480;
        lclTempDimensionSetEntry: Record 480 temporary;
        lclCduDimMgt: Codeunit 408;
        lclI: Integer;
    BEGIN

        FOR lclI := 1 TO 10 DO BEGIN
            IF cuUtilities."#GetDimensionsSetup"(lclI) <> '' THEN BEGIN
                IF "#IsClear"(gGlobalDim[lclI]) THEN BEGIN
                    lclTempDimensionSetEntry.RESET;
                    lclTempDimensionSetEntry.SETRANGE("Dimension Code", cuUtilities."#GetDimensionsSetup"(lclI));
                    IF lclTempDimensionSetEntry.FINDFIRST THEN BEGIN
                        lclTempDimensionSetEntry.VALIDATE("Dimension Value Code", gGlobalDim[lclI]);
                        lclTempDimensionSetEntry.MODIFY;
                    END ELSE BEGIN
                        lclTempDimensionSetEntry.RESET;
                        lclTempDimensionSetEntry.INIT;
                        lclTempDimensionSetEntry.VALIDATE("Dimension Code", cuUtilities."#GetDimensionsSetup"(lclI));
                        lclTempDimensionSetEntry.VALIDATE("Dimension Value Code", gGlobalDim[lclI]);
                        lclTempDimensionSetEntry.INSERT;
                    END;
                END;
            END;
            if lclI = 9 then begin
                IF "#IsClear"(gGlobalDim[9]) THEN BEGIN
                    lclTempDimensionSetEntry.RESET;
                    lclTempDimensionSetEntry.SETRANGE("Dimension Code", 'FCT');
                    IF lclTempDimensionSetEntry.FINDFIRST THEN BEGIN
                        lclTempDimensionSetEntry.VALIDATE("Dimension Value Code", gGlobalDim[9]);
                        lclTempDimensionSetEntry.MODIFY;
                    END ELSE BEGIN
                        lclTempDimensionSetEntry.RESET;
                        lclTempDimensionSetEntry.INIT;
                        lclTempDimensionSetEntry.VALIDATE("Dimension Code", 'FCT');
                        lclTempDimensionSetEntry.VALIDATE("Dimension Value Code", gGlobalDim[9]);
                        lclTempDimensionSetEntry.INSERT;
                    END;
                END;
            end;
        END;
        EXIT(cuUtilities.fnMyGetDimensionSetID(lclTempDimensionSetEntry));
    END;

    PROCEDURE "#IsClear"(ParDocGlobal: Text[30]): Boolean;
    BEGIN
        //004
        IF ParDocGlobal <> '' THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
        //004
    END;

    LOCAL PROCEDURE fnGetDimensionJob();
    VAR
        recDefaulDimension: Record 352;
        recGeneralLedgerSetup: Record 98;
    BEGIN
        recGeneralLedgerSetup.GET();
        recDefaulDimension.RESET;
        recDefaulDimension.SETRANGE("No.", recGJLine."Job No.");
        IF recDefaulDimension.FINDSET THEN
            REPEAT
                IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 1 Code" THEN BEGIN
                    //DEPARTAMENTO
                    gGlobalDim[1] := recDefaulDimension."Dimension Value Code";

                END ELSE
                    IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 2 Code" THEN BEGIN
                        //SUCURSALES
                        gGlobalDim[2] := recDefaulDimension."Dimension Value Code";

                    END ELSE
                        IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 3 Code" THEN BEGIN
                            //CECO
                            gGlobalDim[3] := recDefaulDimension."Dimension Value Code";

                        END ELSE
                            IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 4 Code" THEN BEGIN
                                //CONDICION
                                gGlobalDim[4] := recDefaulDimension."Dimension Value Code";

                            END ELSE
                                IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 5 Code" THEN BEGIN
                                    //LINEA
                                    gGlobalDim[5] := recDefaulDimension."Dimension Value Code";

                                END ELSE
                                    IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 6 Code" THEN BEGIN
                                        //MARCA
                                        gGlobalDim[6] := recDefaulDimension."Dimension Value Code";

                                    END ELSE
                                        IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 7 Code" THEN BEGIN
                                            //DIVISION
                                            gGlobalDim[7] := recDefaulDimension."Dimension Value Code";

                                        END ELSE
                                            IF recDefaulDimension."Dimension Code" = recGeneralLedgerSetup."Shortcut Dimension 8 Code" THEN BEGIN
                                                //PROYECTO DESTINO
                                                gGlobalDim[8] := recDefaulDimension."Dimension Value Code";

                                            END;
            UNTIL recDefaulDimension.NEXT = 0;
    END;

    LOCAL PROCEDURE fnGetDimension();
    VAR
        recDefaulDimension: Record "Default Dimension";
        recGeneralLedgerSetup: Record 98;
        recDimensionSetEntry: Record 480;
        BOOCEBE: Text;
        BOOCECO: Text;
        BOOPPT: Text;
        BOOUNIDNEG: Text;
        BOOPROY: Text;
        BOOLIN: Text;
        BOOREGION: Text;
        BOOFE: Text;
        BOOFCT: Text;

    BEGIN
        recGeneralLedgerSetup.GET();
        recDimensionSetEntry.Reset();
        recDimensionSetEntry.SetRange("Dimension Set ID", recGJLine."Dimension Set ID");
        if recDimensionSetEntry.FindSet() then begin
            BOOCEBE := '';
            BOOCECO := '';
            BOOPPT := '';
            BOOUNIDNEG := '';
            BOOPROY := '';
            BOOLIN := '';
            BOOREGION := '';
            BOOFE := '';
            BOOFCT := '';
            repeat
                //--[CEBE]
                IF recDimensionSetEntry."Dimension Code" = 'CEBE' THEN
                    BOOCEBE := recDimensionSetEntry."Dimension Value Code";

                //--[CECO]
                IF recDimensionSetEntry."Dimension Code" = 'CECO' THEN
                    BOOCECO := recDimensionSetEntry."Dimension Value Code";

                //--[PPT]
                IF recDimensionSetEntry."Dimension Code" = 'PPTO' THEN
                    BOOPPT := recDimensionSetEntry."Dimension Value Code";

                //--[UNIDNEG]
                IF recDimensionSetEntry."Dimension Code" = 'UNIDNEG' THEN
                    BOOUNIDNEG := recDimensionSetEntry."Dimension Value Code";

                //--[PROY]
                //recGJLine."Shortcut Dimension 2 Code" := gTxtDato[9];
                IF recDimensionSetEntry."Dimension Code" = 'PROY' THEN
                    BOOPROY := recDimensionSetEntry."Dimension Value Code";

                //--[LIN]
                IF recDimensionSetEntry."Dimension Code" = 'LIN' THEN
                    BOOLIN := recDimensionSetEntry."Dimension Value Code";

                //--[REGION]
                IF recDimensionSetEntry."Dimension Code" = 'REGION' THEN
                    BOOREGION := recDimensionSetEntry."Dimension Value Code";

                //--[PROY. DESTINO]
                IF recDimensionSetEntry."Dimension Code" = 'FE' THEN
                    BOOFE := recDimensionSetEntry."Dimension Value Code";

                IF recDimensionSetEntry."Dimension Code" = 'FCT' THEN
                    BOOFCT := recDimensionSetEntry."Dimension Value Code";

            //--[FE]
            // gGlobalDim[9] := gTxtDato2[1];

            //--[CPN]
            //gGlobalDim[10] := gTxtDato2[1];
            until recDimensionSetEntry.Next = 0;

            IF BOOCEBE <> '' THEN BEGIN
                recGJLine."Shortcut Dimension 1 Code" := BOOCEBE;
                gGlobalDim[1] := BOOCEBE;
            END ELSE begin
                recGJLine."Shortcut Dimension 1 Code" := gTxtDato[7];
                gGlobalDim[1] := gTxtDato[7];
            END;
            IF BOOCECO <> '' THEN BEGIN
                recGJLine."Shortcut Dimension 2 Code" := BOOCECO;
                gGlobalDim[2] := BOOCECO;
            END ELSE begin
                recGJLine."Shortcut Dimension 2 Code" := gTxtDato[8];
                gGlobalDim[2] := gTxtDato[8];
            end;
            IF BOOPPT <> '' then begin
                gGlobalDim[3] := BOOPPT;
            END ELSE begin
                gGlobalDim[3] := gTxtDato[9];
            end;
            IF BOOUNIDNEG <> '' THEN begin
                gGlobalDim[4] := BOOUNIDNEG;
            END ELSE begin
                gGlobalDim[4] := gTxtDato[10];
            end;
            IF BOOPROY <> '' then begin
                gGlobalDim[5] := BOOPROY;
            END ELSE begin
                gGlobalDim[5] := gTxtDato[11];
            end;
            IF BOOLIN <> '' THEN begin
                gGlobalDim[6] := BOOLIN;
            END ELSE begin
                gGlobalDim[6] := gTxtDato[12];
            end;
            IF BOOREGION <> '' then begin
                gGlobalDim[7] := BOOREGION;
            END ELSE begin
                gGlobalDim[7] := gTxtDato[13];
            end;
            IF BOOFE <> '' THEN begin
                gGlobalDim[8] := BOOFE;
            END ELSE begin
                gGlobalDim[8] := gTxtDato[14];
            end;
            IF BOOFCT <> '' THEN begin
                gGlobalDim[9] := BOOFCT;
            END ELSE begin
                gGlobalDim[9] := '';
            end;
        END ELSE begin
            //--[CEBE]

            recGJLine."Shortcut Dimension 1 Code" := gTxtDato[7];
            gGlobalDim[1] := gTxtDato[7];


            //--[CECO]

            recGJLine."Shortcut Dimension 2 Code" := gTxtDato[8];
            gGlobalDim[2] := gTxtDato[8];


            //--[PPT]

            gGlobalDim[3] := gTxtDato[9];


            //--[UNIDNEG]

            gGlobalDim[4] := gTxtDato[10];


            //--[PROY]
            //recGJLine."Shortcut Dimension 2 Code" := gTxtDato[9];

            gGlobalDim[5] := gTxtDato[11];


            //--[LIN]

            gGlobalDim[6] := gTxtDato[12];


            //--[REGION]

            gGlobalDim[7] := gTxtDato[13];


            //--[PROY. DESTINO]

            gGlobalDim[8] := gTxtDato[14];


            //--[FCT]
            gGlobalDim[9] := '';

            //--[CPN]
            //gGlobalDim[10] := gTxtDato2[1];
        end;


    END;

    local procedure getNoDocumentSerie()
    var
        recGenJouBat: Record 232;
        //rec2
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Noserie: code[20];
        rec: Record 36;
        REC1: Record 80;
        pag: Page 101;
        recc81: Record 81;
    begin
        Clear(NoSeriesMgt);
        recGenJouBat.Reset();
        recGenJouBat.SetRange("Journal Template Name", recGJLine."Journal Template Name");
        recGenJouBat.SetRange(Name, recGJLine."Journal Batch Name");
        if recGenJouBat.FindSet() then begin
            Noserie := recGenJouBat."No. Series";
            //NoSeriesMgt.InitSeries(Noserie, xRec."No. Series", "Posting Date", "No.", "No. Series");

            //NoDocumentoSerieBatch := NoSeriesMgt.TryGetNextNo(recGenJouBat."No. Series", recGJLine."Posting Date");
            NoDocumentoSerieBatch := NoSeriesMgt.GetNextNo3(recGenJouBat."No. Series", Today, false, false);
            Commit();
        end;

    end;

    LOCAL PROCEDURE fnInsertLineas();
    VAR
        DimensionSetEntry: Record 480;
        RecGenJouLine: Record "Gen. Journal Line";
        SLSetupMgt: Codeunit "Setup Localization";
        EmplPostingGroup: Record "Employee Posting Group";
        VendPostingGroup: Record "Vendor Posting Group";
        CustPostingGroup: Record "Customer Posting Group";
        RecEmployeeLedgerEntry: Record 5222;

    BEGIN
        //-------------------
        RecGenJouLine.Reset();
        RecGenJouLine.SetRange("Journal Template Name", 'PLLAS');
        RecGenJouLine.SetRange("Journal Batch Name", gSelecDiario);
        IF RecGenJouLine.FindLast() then
            gLineNo := RecGenJouLine."Line No."
        ELSE
            gLineNo := 0;
        recGLedSetup.GET;
        recGJLine.RESET;
        recGJLine.INIT;
        gLineNo += 10000;


        //---------------------------------
        recGJLine."Line No." := gLineNo;
        recGJLine."Journal Template Name" := 'PLLAS';
        //BEGIN LOF:15.03.19 ++
        //recGJLine."Journal Batch Name"    :=recGLedSetup."Seccion Planilla";
        recGJLine."Journal Batch Name" := gSelecDiario;
        //BEGIN LOF:15.03.19 ++
        //--
        GenJnlBatch."Journal Template Name" := 'PLLAS';
        //BEGIN LOF:15.03.19 ++
        //GenJnlBatch.Name                    := recGLedSetup."Seccion Planilla";
        GenJnlBatch.Name := gSelecDiario;
        //BEGIN LOF:15.03.19 ++
        //--


        //--[FECHA REGISTRO]
        EVALUATE(gFechaRegistro, gTxtDato[1]);
        recGJLine.VALIDATE("Posting Date", gFechaRegistro);

        //--[TIPO MOVIMIENTO]
        CASE gTxtDato[2] OF
            'CUENTA':
                recGJLine."Account Type" := recGJLine."Account Type"::"G/L Account";
            'EMPLEADO':
                recGJLine."Account Type" := recGJLine."Account Type"::Employee;
            'PROVEEDOR':
                recGJLine."Account Type" := recGJLine."Account Type"::Vendor;
        END;

        //--[LIQ. POR NUMERO DE DOCUMENTO]

        recGJLine.VALIDATE("Applies-to Doc. No.", gTxtDato[3]);



        //recGJLine."Applies-to Doc. No." := gTxtDato[3];

        //--[NRO CUENTA]
        recGJLine.Validate("Account No.", gTxtDato[4]);

        //--[GRUPO CONTABLE]
        recGJLine.VALIDATE("Posting Group", gTxtDato[5]);
        //Validacion de Grupo Contable
        case recGJLine."Account Type" of
            recGJLine."Account Type"::Employee:
                begin

                    EmplPostingGroup.Reset();
                    EmplPostingGroup.SetRange(code, recGJLine."Posting Group");
                    if EmplPostingGroup.FindSet() then begin
                        recGJLine.Validate("Currency Code", EmplPostingGroup."Currency Code");
                    end;
                end;
            recGJLine."Account Type"::Customer:
                begin

                    CustPostingGroup.Reset();
                    CustPostingGroup.SetRange(code, recGJLine."Posting Group");
                    if EmplPostingGroup.FindSet() then begin
                        recGJLine.Validate("Currency Code", CustPostingGroup."Currency Code");
                    end;
                end;
            recGJLine."Account Type"::Vendor:
                begin

                    VendPostingGroup.Reset();
                    VendPostingGroup.SetRange(code, recGJLine."Posting Group");
                    if EmplPostingGroup.FindSet() then begin
                        recGJLine.Validate("Currency Code", VendPostingGroup."Currency Code");
                    end;
                end;
        end;
        //Valida No Mov Employe
        if recGJLine."Account Type" = recGJLine."Account Type"::Employee then begin
            RecEmployeeLedgerEntry.Reset();
            RecEmployeeLedgerEntry.SetRange("Employee No.", recGJLine."Account No.");
            RecEmployeeLedgerEntry.SetRange(Open, true);
            RecEmployeeLedgerEntry.SetRange("Document No.", recGJLine."Applies-to Doc. No.");
            RecEmployeeLedgerEntry.SetRange("Employee Posting Group", recGJLine."Posting Group");
            if RecEmployeeLedgerEntry.FindSet() then
                recGJLine."Applies-to Entry No." := RecEmployeeLedgerEntry."Entry No.";
        end;
        //--[DESCRIPCION]
        if gTxtDato[6] <> '' then
            recGJLine.Description := gTxtDato[6];

        //--[NRO PROYECTO]
        IF gTxtDato[18] <> '' THEN
            recGJLine.VALIDATE("Job No.", gTxtDato[18]);
        // -- [NRO TAREA PROYECTO]
        if gTxtDato[19] <> '' then
            recGJLine.validate("Job Task No.", gTxtDato[19]);


        //DIMENSION DEPARTAMENTO Y CECO
        fnGetDimension();
        //--OBTENIENDO LA "Dimension Set ID"
        recGJLine."Dimension Set ID" := "#GetDimensionSetID";
        //------,
        // -- Obteniendo Dimensión Set ID de la Dimensión FCT --
        // if recGJLine."Account Type" = recGJLine."Account Type"::Vendor then
        //     recGJLine."Dimension Set ID" := "#GetDimensionSetIDFCT";

        /*
                //-----Nro Proyecto --------------------//
                IF gTxtDato[10] <> '' THEN BEGIN
                    DimensionSetEntry.RESET;
                    DimensionSetEntry.SETRANGE("Dimension Set ID", recGJLine."Dimension Set ID");
                    DimensionSetEntry.SETRANGE("Dimension Code", 'PROYECTO');
                    IF NOT DimensionSetEntry.FINDSET THEN BEGIN
                        DimensionSetEntry.VALIDATE("Dimension Set ID", recGJLine."Dimension Set ID");
                        DimensionSetEntry.VALIDATE("Dimension Code", 'PROYECTO');
                        DimensionSetEntry.VALIDATE("Dimension Value Code", gTxtDato[10]);
                        DimensionSetEntry.INSERT;
                    END;
                END;
        */

        // //--FUNCION (OBTENIENDO LAS DIMENSIONES DEFINIDAS)
        // IF recGJLine."Job No." <> '' THEN BEGIN
        //    fnGetDimensionJob();
        //    //--OBTENIENDO LA "Dimension Set ID"
        //    recGJLine."Dimension Set ID" := "#GetDimensionSetID";
        //    //------
        // END;


        //--[IMPORTE]
        EVALUATE(gAmount, gTxtDato[15]);
        recGJLine.VALIDATE(Amount, gAmount);



        //--[TEXTO REGISTRO]
        recGJLine."Posting Text" := gTxtDato[17];

        recGJLine.VALIDATE(Quantity, 1);
        //--
        recGJLine.VALIDATE(recGJLine."Document Type", recGJLine."Document Type"::" ");

        //---------------
        IF (gTxtDato[18] <> '') and (gTxtDato[19] <> '') THEN
            recGJLine."Job Quantity" := 1;
        //--[NRO DOCUMENTO]
        if gTxtDato[16] <> '' then
            recGJLine."Document No." := gTxtDato[16]
        else begin
            if gCount = 1 then begin
                getNoDocumentSerie();
            end;
            Commit();
            recGJLine."Document No." := NoDocumentoSerieBatch;
        end;

        recGJLine.INSERT;
    END;

    var
        gExcelBuf: Record "Excel Buffer";
        gRecExcellBuf: Record "Excel Buffer";
        gServerFileName: Text;
        NoDocumentoSerieBatch: Text;
        gFileName: Text;
        gSheetName: Text;
        gFileMgt: Codeunit "File Management";
        gWindow: Dialog;
        gFirstLine: Integer;
        gLastLine: Integer;

        gTxtDato: array[39] of text;
        gPrimaryKey: Text;
        gForeingKEY: Text;
        gIntDato: integer;
        gColNo: Integer;
        gCountRow: Integer;
        gCount: Integer;
        gcant: Decimal;
        gCountColumnCab: Integer;
        gCountInsert: Integer;
        recPurchHeader: Record "Purchase Header";
        recPurchaseLine: Record "Purchase Line";
        recItemJnLine: Record "Item Journal Line";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        recGJLine: Record "Gen. Journal Line";
        gQuantity: Decimal;
        gPrice: Decimal;
        gPricePMP: Decimal;
        gValued: Decimal;
        gDirectUnitCost: Decimal;
        gDocumentNoGenerated: Code[45];
        gLineNo: Integer;
        gDocumentType: Code[5];
        gGlobalDim: ARRAY[10] OF Code[20];
        cuUtilities: Codeunit "Setup Localization";
        gCurrencyCode: Code[5];
        gNroProveedor: code[20];
        recPurchInvHeader: Record "Purch. Inv. Header";
        gNroFactProveedor: Code[45];
        gFechaRegistro: Date;
        gNroPedido: Code[20];
        gCostDirSinIva: Decimal;
        recPurchHeaderBlock: Record "Purchase Header";
        gContBlock: Integer;
        lcDocumentTypeNumber: Integer;
        gAmount: Decimal;
        recGLedSetup: Record "General Ledger Setup";
        GenJnlManagement: Codeunit GenJnlManagement;
        GenJnlBatch: Record "Gen. Journal Batch";
        gSelecDiario: Code[20];
        fileMGT: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        FileDialogTxt: Label 'Attachments (%1)|%1', Comment = '%1=file types, such as *.txt or *.docx';
        FilterTxt: Label '*.jpg;*.jpeg;*.bmp;*.png;*.gif;*.tiff;*.tif;*.pdf;*.docx;*.doc;*.xlsx;*.xls;*.pptx;*.ppt;*.msg;*.xml;*.*', Locked = true;
        ImportTxt: Label 'Attach a document.';

        gText0001: Label 'You must enter a file name';
        gText002: Label 'Import Excel File';
        gText003: Label 'Processing:\';
        gText004: Label 'File: #4########################################\';
        gText005: Label 'Sheet:              #1##############################\';
        gText006: Label 'Row:                                    #2########\';
        gText007: Label 'Column:                                 #3########\';
        gText008: Label 'Data:    #5########################################\';





}