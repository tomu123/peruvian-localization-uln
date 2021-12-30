report 51062 "Reg.Perm. Inv.Val."
{
    //LIBRO 13.1
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Reg.Perm. Inv.Val..rdl';
    Caption = 'Reg.Perm. Inv.Val.', Comment = 'ESM="Registro de Inv. Perm. Val."';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            column(recCompany__VAT_Registration_No__; recCompany."VAT Registration No.")
            {
            }
            column(recCompany_Name; recCompany.Name)
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(Mes; MesPeriodo)
            {
            }
            column(UserInfo; UsuarioInfo)
            {
            }
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(MetodoValuacion; MetodoValuacion)
            {
            }
            column(UndMedida; UndMedida)
            {
            }
            column(recItem_Description; recItem.Description)
            {
            }
            column(Description2; _Description2)
            {
            }
            column(CodigoExistencia; gCodigoExistencia)
            {
            }
            column(tipoProdPdt; tipoProdPdt)
            {
            }
            column(Item_Ledger_Entry__Item_No__; "Item No.")
            {
            }
            column(Establecimiento; Establecimiento)
            {
            }
            column(NombreAlmacen; gNombreAlmacen)
            {
            }
            column(Item_Ledger_Entry__Location_Code_; "Location Code")
            {
            }
            column(Item_Ledger_Entry__Posting_Date_; "Posting Date")
            {
            }
            column(tipoOperacion; tipoOperacion)
            {
            }
            column(gBoolNoVa; gBoolNoVa)
            {
            }
            column(NoDocumento; NoDocumento)
            {
            }
            column(serie; serie)
            {
            }
            column(cantidadEnt; cantidadEnt)
            {
            }
            column(costoUnitarioEnt; costoUnitarioEnt)
            {
            }
            column(costoTotalEnt; costoTotalEnt)
            {
            }
            column(cantidadSal; cantidadSal)
            {
            }
            column(costoUnitarioSal; costoUnitarioSal)
            {
            }
            column(costoTotalSal; costoTotalSal)
            {
            }
            column(CantidadFinal; CantidadFinal)
            {
            }
            column(cantidadEnt_Control1000000026; cantidadEnt)
            {
            }
            column(SaldoFinal; SaldoFinal)
            {
            }
            column(tipoDocumente; tipoDocumente)
            {
            }
            column(APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_Caption; APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(REGISTRO_DE_INVENTARIO_PERMANENTE_VALORIZADO___DETALLE_DEL_INVENTARIO_VALORIZADOCaption; REGISTRO_DE_INVENTARIO_PERMANENTE_VALORIZADO___DETALLE_DEL_INVENTARIO_VALORIZADOCaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(TIPO_DE_EXISTENCIA_Caption; TIPO_DE_EXISTENCIA_CaptionLbl)
            {
            }
            column(DESCRIPCION_Caption; DESCRIPCION_CaptionLbl)
            {
            }
            column(COD__DE_UND__DE_MEDIDA_Caption; COD__DE_UND__DE_MEDIDA_CaptionLbl)
            {
            }
            column(METODO_DE_VALUACION_Caption; METODO_DE_VALUACION_CaptionLbl)
            {
            }
            column(ESTABLECIMIENTO_Caption; ESTABLECIMIENTO_CaptionLbl)
            {
            }
            column(CODIGO_DE_EXISTENCIA_Caption; CODIGO_DE_EXISTENCIA_CaptionLbl)
            {
            }
            column(COSTO_TOTALCaption; COSTO_TOTALCaptionLbl)
            {
            }
            column(COSTO_UNITARIOCaption; COSTO_UNITARIOCaptionLbl)
            {
            }
            column(CANTIDADCaption; CANTIDADCaptionLbl)
            {
            }
            column(COSTO_TOTALCaption_Control1000000034; COSTO_TOTALCaption_Control1000000034Lbl)
            {
            }
            column(COSTO_UNITARIOCaption_Control1000000035; COSTO_UNITARIOCaption_Control1000000035Lbl)
            {
            }
            column(COSTO_TOTALCaption_Control1000000017; COSTO_TOTALCaption_Control1000000017Lbl)
            {
            }
            column(COSTO_UNITARIOCaption_Control1000000019; COSTO_UNITARIOCaption_Control1000000019Lbl)
            {
            }
            column(CANTIDADCaption_Control1000000036; CANTIDADCaption_Control1000000036Lbl)
            {
            }
            column(TIPO_DE_OPERACIONCaption; TIPO_DE_OPERACIONCaptionLbl)
            {
            }
            column(ENTRADASCaption; ENTRADASCaptionLbl)
            {
            }
            column(CANTIDADCaption_Control1000000020; CANTIDADCaption_Control1000000020Lbl)
            {
            }
            column(SALIDASCaption; SALIDASCaptionLbl)
            {
            }
            column(SALDO_FINALCaption; SALDO_FINALCaptionLbl)
            {
            }
            column(DOCUMENTO_DE_TRASLADO__COMPROBANTE_DE_PAGO__DOCUMENTO_INTERNO_SIMILARCaption; DOCUMENTO_DE_TRASLADO__COMPROBANTE_DE_PAGO__DOCUMENTO_INTERNO_SIMILARCaptionLbl)
            {
            }
            column(NUMEROCaption; NUMEROCaptionLbl)
            {
            }
            column(TIPOCaption; TIPOCaptionLbl)
            {
            }
            column(SERIECaption; SERIECaptionLbl)
            {
            }
            column(FECHACaption; FECHACaptionLbl)
            {
            }
            column(Item_Ledger_Entry_Entry_No_; "Entry No.")
            {
            }
            column(gInicial; gInicial)
            {
            }
            column(gInicialAmt; gInicialAmt)
            {
            }
            column(cantidadCostFinal; cantidadCostFinal)
            {
            }
            column(cantidadCostInicial; cantidadCostInicial)
            {
            }
            column(CodigoEstablecimiento; gCodigoEstablecimiento + ' - ' + Establecimiento)
            {
            }
            column(TipoDeExistencia; _TipoDeExistencia)
            {
            }
            column(UnidadMedida; _UnidadMedida)
            {
            }
            column(MetodoValuacion2; _MetodoValuacion)
            {
            }

            trigger OnAfterGetRecord()
            var
                lclItemLedgerEntry: Record "Item Ledger Entry";
            begin
                gRevertido := FALSE;
                recItem.GET("Item Ledger Entry"."Item No.");


                gNroMov := "Item Ledger Entry"."Entry No.";

                gInicial := 0;
                gInicialAmt := 0;
                cantidadCostInicial := 0;
                cantidadCostFinal := 0;

                gvalor1 := "Item Ledger Entry"."Item No.";
                gvalor2 := "Item Ledger Entry"."Location Code";

                //------------------
                lclItemLedgerEntry.RESET;
                lclItemLedgerEntry.SETRANGE("Item No.", "Item No.");
                lclItemLedgerEntry.SETRANGE("Posting Date", 0D, CALCDATE('< -1D>', fechaIni));
                // lclItemLedgerEntry.SETRANGE("Date Filter", 0D, CALCDATE('< -1D>', fechaIni));
                IF lclItemLedgerEntry.FINDSET THEN
                    REPEAT
                        lclItemLedgerEntry.CALCFIELDS("Cost Amount (Actual)");
                        gInicial += lclItemLedgerEntry.Quantity;
                        gInicialAmt += lclItemLedgerEntry."Cost Amount (Actual)";
                    UNTIL lclItemLedgerEntry.NEXT = 0;

                IF (gInicialAmt <> 0) THEN
                    cantidadCostInicial := gInicialAmt / gInicial;

                gvalor2 := "Item Ledger Entry"."Location Code";

                cantidadEnt := 0;
                costoUnitarioEnt := 0;
                costoTotalEnt := 0;
                cantidadSal := 0;
                costoUnitarioSal := 0;
                costoTotalSal := 0;

                IF GiTEMtEMP <> "Item No." THEN BEGIN
                    SaldoFinal := gInicialAmt;
                END;


                GiTEMtEMP := "Item No.";
                gBoolNoVa := '1';


                //--------
                //-------
                _CatalogoUtilizado := '';
                _TipoDeExistencia := '';
                _ExistenciaCodeBSO := '';
                _Description2 := '';
                _UnidadMedida := '';
                _MetodoValuacion := '';
                _TipoProducto := '';
                gCodigoExistencia := '';

                //-----------------------------------------------------------------------------------------------
                recItem.RESET;
                recItem.SETRANGE(recItem."No.", "Item Ledger Entry"."Item No.");
                IF recItem.FINDFIRST THEN BEGIN
                    _CatalogoUtilizado := recItem.Catalog;
                    _TipoDeExistencia := recItem."Type of Existence";
                    _ExistenciaCodeBSO := recItem."Existence Code BSO";
                    _Description2 := recItem."Description 2"; //--Descripcion
                    _UnidadMedida := recItem."Base Unit of Measure";

                    gSUNATTables.RESET;
                    gSUNATTables.SETRANGE("Type Code", '14');
                    gSUNATTables.SETRANGE("Option Type", gSUNATTables."Option Type"::"Catalogue SUNAT");
                    gSUNATTables.SETRANGE("Legal No.", recItem."Value Method");
                    IF gSUNATTables.FINDSET THEN BEGIN
                        _MetodoValuacion := recItem."Value Method" + ' - ' + gSUNATTables.Description
                    END ELSE BEGIN
                        _MetodoValuacion := recItem."Value Method";
                    END;

                    //BEGIN ULN::CCL 001 --
                    //_TipoProducto      := recItem."Tipo Producto";
                    //END ULN::CCL 001 --
                    gCodigoExistencia := recItem."No.";
                END;

                //-----------------------------------------------------------------------------------------------
                recAlmacen.RESET;
                recAlmacen.SETRANGE(recAlmacen.Code, "Location Code");
                IF recAlmacen.FINDSET THEN BEGIN
                    recMaestroDatos.RESET;
                    recMaestroDatos.SETRANGE(recMaestroDatos."Type Table", 'ESTABLECIMIENTOS');
                    //BEGIN ULN::CCL 001 --
                    //recMaestroDatos.SETRANGE(recMaestroDatos.Code,recAlmacen."Codigo Establecimiento");
                    //END ULN::CCL 001 --
                    IF recMaestroDatos.FINDSET THEN BEGIN
                        Establecimiento := recMaestroDatos.Description;
                        gCodigoEstablecimiento := recMaestroDatos.Code;
                    END;
                END ELSE BEGIN
                    Establecimiento := '';
                    gCodigoEstablecimiento := '';
                END;
                //-----------------------------------------------------------------------------------------------

                gAnulado := FALSE;

                IF "Posting Date" >= fechaIni THEN BEGIN
                    gBoolNoVa := '0';

                    //VALIDAR TIPO DE DOCUMENTO
                    CASE "Document Type" OF
                        2, 6, 12:  //Factura venta, Factura compra,Factura ventas,
                            BEGIN
                                tipoDocumente := '01';
                            END;
                        4, 8, 13, 3, 7:  //Abono venta,Abono compra,Abono ventas,Recep. devol. venta ,Envío devolución compr
                            BEGIN
                                tipoDocumente := '07';
                            END;
                        1, 5:      //Albarán venta,Albarán compra,
                            BEGIN
                                tipoDocumente := '09'
                            END;
                        9:        //Envío transfer.,
                            BEGIN
                                tipoDocumente := '31'
                            END;
                        0, 10, 11:  //  , Recep. transfer.,Servicio regis
                            BEGIN
                                tipoDocumente := '00'
                            END;
                    END;


                    "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)");
                    gValueEntry.RESET;
                    gValueEntry.SETRANGE("Item Ledger Entry No.", "Item Ledger Entry"."Entry No.");
                    gValueEntry.SETFILTER("Document Type", '%1|%2|%3|%4', "Document Type"::"Purchase Credit Memo", "Document Type"::"Purchase Invoice", "Document Type"::"Sales Credit Memo", "Document Type"::"Sales Invoice");
                    IF gValueEntry.FINDSET THEN BEGIN
                        CASE gValueEntry."Document Type" OF
                            //-------------------------------------------------
                            gValueEntry."Document Type"::"Purchase Credit Memo"
                            :
                                BEGIN
                                    gPurchCrMemoHdr.RESET;
                                    gPurchCrMemoHdr.SETRANGE("No.", gValueEntry."Document No.");
                                    IF gPurchCrMemoHdr.FINDSET THEN BEGIN
                                        //  IF (gValueEntry."Legal Document" = '') AND (gPurchCrMemoHdr."Legal Document" <> '') THEN BEGIN
                                        tipoDocumente := gPurchCrMemoHdr."Legal Document";
                                        //END;

                                        //RHF
                                        gAnulado := FALSE;
                                        IF gPurchCrMemoHdr."Legal Status" = gPurchCrMemoHdr."Legal Status"::OutFlow THEN BEGIN
                                            gAnulado := TRUE;
                                        END;
                                        //--
                                        gNoSeries.RESET;
                                        gNoSeries.SETRANGE(Code, gPurchCrMemoHdr."No. Series");
                                        gNoSeries.SETRANGE("Internal Operation", TRUE);
                                        gRevertido := gNoSeries.FINDFIRST;
                                    END;
                                    NoDocumento := gValueEntry."External Document No.";
                                END;

                            //-------------------------------------------------
                            gValueEntry."Document Type"::"Purchase Invoice"
                            :
                                BEGIN
                                    gPurchInvHeader.RESET;
                                    gPurchInvHeader.SETRANGE("No.", gValueEntry."Document No.");
                                    IF gPurchInvHeader.FINDSET THEN BEGIN
                                        // IF (gValueEntry."Legal Document" = '') AND (gPurchInvHeader."Legal Document" <> '') THEN BEGIN
                                        tipoDocumente := gPurchInvHeader."Legal Document";
                                        // END;

                                        //RHF
                                        gAnulado := FALSE;
                                        IF gPurchInvHeader."Legal Status" = gPurchInvHeader."Legal Status"::OutFlow THEN BEGIN
                                            gAnulado := TRUE;
                                        END;
                                        //--

                                        gNoSeries.RESET;
                                        gNoSeries.SETRANGE(Code, gPurchInvHeader."No. Series");
                                        gNoSeries.SETRANGE("Internal Operation", TRUE);
                                        gRevertido := gNoSeries.FINDFIRST;
                                    END;
                                    NoDocumento := gValueEntry."External Document No.";
                                END;

                            //-------------------------------------------------
                            gValueEntry."Document Type"::"Sales Credit Memo"
                            :
                                BEGIN
                                    gSalesCrMemoHeader.RESET;
                                    gSalesCrMemoHeader.SETRANGE("No.", gValueEntry."Document No.");
                                    IF gSalesCrMemoHeader.FINDSET THEN BEGIN
                                        gTituloGratuito := gSalesCrMemoHeader."FT Free Title";
                                        gNoSeries.RESET;
                                        gNoSeries.SETRANGE(Code, gSalesCrMemoHeader."No. Series");
                                        gNoSeries.SETRANGE("Internal Operation", TRUE);
                                        gRevertido := gNoSeries.FINDFIRST;

                                        //RHF
                                        gAnulado := FALSE;
                                        IF gSalesCrMemoHeader."Legal Status" = gSalesCrMemoHeader."Legal Status"::Anulled THEN BEGIN
                                            gAnulado := TRUE;
                                        END;
                                        //--

                                    END;

                                    NoDocumento := gValueEntry."Document No.";
                                    tipoDocumente := gSalesCrMemoHeader."Legal Document";
                                    /*
                                  IF (gTituloGratuito) OR (gValueEntry."Legal Document" <> '') THEN BEGIN
                                      IF gTituloGratuito THEN
                                          tipoDocumente := gSalesCrMemoHeader."Legal Document"
                                      ELSE
                                          tipoDocumente := gValueEntry."Legal Document";
                                  END;*/

                                    // IF (gValueEntry."Legal Document" = '') AND (gSalesCrMemoHeader."Legal Document" <> '') THEN BEGIN
                                    tipoDocumente := gSalesCrMemoHeader."Legal Document";
                                    //END;
                                END;

                            //-------------------------------------------------
                            gValueEntry."Document Type"::"Sales Invoice"
                            :
                                BEGIN
                                    gSalesInvoiceHeader.RESET;
                                    gSalesInvoiceHeader.SETRANGE("No.", gValueEntry."Document No.");
                                    IF gSalesInvoiceHeader.FINDSET THEN BEGIN
                                        gTituloGratuito := gSalesInvoiceHeader."FT Free Title";
                                        gNoSeries.RESET;
                                        gNoSeries.SETRANGE(Code, gSalesInvoiceHeader."No. Series");
                                        gNoSeries.SETRANGE("Internal Operation", TRUE);
                                        gRevertido := gNoSeries.FINDFIRST;

                                        //RHF
                                        gAnulado := FALSE;
                                        IF gSalesInvoiceHeader."Legal Status" = gSalesInvoiceHeader."Legal Status"::Anulled THEN BEGIN
                                            gAnulado := TRUE;
                                        END;
                                        //--
                                    END;

                                    NoDocumento := gValueEntry."Document No.";
                                    IF (gTituloGratuito) THEN BEGIN
                                        IF gTituloGratuito THEN
                                            tipoDocumente := gSalesInvoiceHeader."Legal Document";

                                    END;

                                    IF (gSalesInvoiceHeader."Legal Document" <> '') THEN BEGIN
                                        tipoDocumente := gSalesInvoiceHeader."Legal Document";
                                    END;
                                END;
                        END;
                    END ELSE
                        NoDocumento := FORMAT("Document No.");

                    gCodigoExistencia := "Item Ledger Entry"."Item No.";

                    IF COPYSTR("Document No.", 1, 7) = 'OPENING' THEN
                        tipoOperacion := '16';

                    IF STRPOS(NoDocumento, '-') <> 0 THEN BEGIN
                        serie := COPYSTR(NoDocumento, 1, STRPOS(NoDocumento, '-') - 1);
                        NoDocumento := COPYSTR(NoDocumento, STRPOS(NoDocumento, '-') + 1, 20);
                    END ELSE BEGIN
                        serie := '';
                    END;

                    IF NoDocumento = '0000243' THEN
                        gCodigoExistencia := "Item Ledger Entry"."Item No.";

                    //VALIDAR TIPO DE OPERACION
                    CASE "Entry Type" OF
                        0:    //COMPRA
                            BEGIN
                                IF ("Document Type" = 8) OR ("Document Type" = 7) THEN
                                    tipoOperacion := '06'
                                ELSE
                                    tipoOperacion := '02';
                            END;
                        1:    //VENTA
                            BEGIN
                                IF ("Document Type" = 4) OR ("Document Type" = 3) OR ("Document Type" = 13) THEN
                                    tipoOperacion := '05'
                                ELSE
                                    tipoOperacion := '01';
                            END;
                        6:   //SALDIA FABRI
                            BEGIN
                                tipoOperacion := '10'
                            END;
                        2, 3, 5:   //AJUS + , AJUST -, CONSUM
                            BEGIN
                                tipoOperacion := '99'
                            END;
                        4:     //Transferencia
                            BEGIN
                                IF "Item Ledger Entry"."Document Type" = 10 THEN BEGIN
                                    recRecepcion.SETRANGE("No.", "Item Ledger Entry"."Document No.");
                                    IF recRecepcion.FIND('-') THEN
                                        tipoOperacion := '03'  //RECEPCION
                                END ELSE
                                    recEnvio.SETRANGE("No.", "Item Ledger Entry"."Document No.");

                                IF recEnvio.FIND('-') THEN
                                    tipoOperacion := '04'  //ENVIO
                            END;
                    END;



                    IF gTituloGratuito THEN
                        tipoOperacion := '91';

                    IF NOT gRevertido THEN BEGIN
                        IF "Item Ledger Entry".Correction THEN BEGIN
                            gRevertido := "Item Ledger Entry".Correction
                        END ELSE BEGIN
                            gItemLedgerEntry.RESET;
                            gItemLedgerEntry.SETRANGE("Document No.", "Item Ledger Entry"."Document No.");
                            gItemLedgerEntry.SETRANGE("Posting Date", "Item Ledger Entry"."Posting Date");
                            gItemLedgerEntry.SETRANGE("Document Type", "Item Ledger Entry"."Document Type");
                            gItemLedgerEntry.SETRANGE("Item No.", "Item Ledger Entry"."Item No.");
                            gItemLedgerEntry.SETRANGE(Quantity, "Item Ledger Entry".Quantity * -1);
                            gItemLedgerEntry.SETRANGE(Correction, TRUE);
                            gRevertido := gItemLedgerEntry.FINDSET;
                        END;
                    END;


                    IF (serie = 'FVTA') OR (serie = 'ENSR') OR (gRevertido AND gAnulado) THEN BEGIN
                        tipoOperacion := '99';
                        tipoDocumente := '00';
                    END;

                    gEntrada := FALSE;
                    gSalida := FALSE;
                    IF "Item Ledger Entry".Quantity > 0 THEN BEGIN
                        gEntrada := TRUE;
                        cantidadEnt := "Item Ledger Entry".Quantity;
                        costoUnitarioEnt := "Item Ledger Entry"."Cost Amount (Actual)" / "Item Ledger Entry".Quantity;
                        costoTotalEnt := "Item Ledger Entry"."Cost Amount (Actual)";
                        cantidadSal := 0;
                        costoUnitarioSal := 0;
                        costoTotalSal := 0;
                    END ELSE BEGIN
                        gSalida := TRUE;
                        cantidadEnt := 0;
                        costoUnitarioEnt := 0;
                        costoTotalEnt := 0;
                        cantidadSal := ("Item Ledger Entry".Quantity);
                        costoUnitarioSal := ("Item Ledger Entry"."Cost Amount (Actual)" / "Item Ledger Entry".Quantity);
                        costoTotalSal := ("Item Ledger Entry"."Cost Amount (Actual)");
                    END;


                    //SALDO FINALES
                    cantidadCostFinal := 0;

                    EVALUATE(lclCantidad, FORMAT(ROUND("Item Ledger Entry".Quantity, 1)));
                    //----------------


                    //---Obteniendo la cantidad inicial y monto incial
                    IF (gItemNo <> "Item Ledger Entry"."Item No.") THEN BEGIN

                        IF gEntrada THEN
                            gCantFinal := gInicial + ABS(cantidadEnt);//ABS(lclCantidad);

                        IF gSalida THEN
                            gCantFinal := gInicial - ABS(cantidadSal);

                    END ELSE BEGIN
                        IF gEntrada THEN
                            gCantFinal := gCantFinal + ABS(cantidadEnt);//ABS(lclCantidad);

                        IF gSalida THEN
                            gCantFinal := gCantFinal - ABS(cantidadSal); //ABS(lclCantidad);

                    END;
                    //---

                    CantidadFinal := gCantFinal;

                    SaldoFinal := SaldoFinal + (costoTotalSal + costoTotalEnt);
                    IF CantidadFinal <> 0 THEN
                        cantidadCostFinal := SaldoFinal / CantidadFinal;


                    IF CantidadFinal = 0 THEN
                        SaldoFinal := 0;

                    MetodoValuacion := FORMAT(recItem."Costing Method");
                    IF MetodoValuacion = 'Especial' THEN BEGIN
                        MetodoValuacion := 'Idntif.Espcf.Esp.';
                    END ELSE BEGIN
                        MetodoValuacion := 'Prom.Pond.Mdio.';
                    END;

                    //-------------------------------------------
                    gItemNo := "Item Ledger Entry"."Item No.";

                END;
            end;

            trigger OnPreDataItem()
            begin
                Ejercicio := FORMAT(fechaIni) + '..' + FORMAT(FechaFin);

                recCompany.GET();

                IF fechaIni = 0D THEN BEGIN
                    MESSAGE(text012);
                END;

                year := DATE2DMY(fechaIni, 3);

                "Item Ledger Entry".SETCURRENTKEY("Item Ledger Entry"."Item No.", "Posting Date");
                SETRANGE("Item Ledger Entry"."Posting Date", 0D, FechaFin);
                "Item Ledger Entry".ASCENDING;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(mosfr; mosfr)
                {
                    Caption = 'Enable Referential year', Comment = 'ESM="Habilitar aõo Referencial"';

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            //RequestOptionsPage.ARef.ENABLED(TRUE);
                            mescab := DATE2DMY(TODAY, 3)
                        END ELSE BEGIN
                            //RequestOptionsPage.ARef.ENABLED:=FALSE;
                            mescab := 0;
                        END;
                    end;
                }
                field(mescab; mescab)
                {
                    Caption = 'Referential Year', Comment = 'ESM="Aõo Referencial"';
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Referential Date', Comment = 'ESM="Fecha Referencial"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                    end;
                }
                field(fechaIni; fechaIni)
                {
                    Caption = 'Starting Date', Comment = 'ESM="Fecha Inicial"';
                }
                field(FechaFin; FechaFin)
                {
                    Caption = 'End Date', Comment = 'ESM="Fecha Final"';
                }
                field(MesPeriodo; MesPeriodo)
                {
                    Caption = 'Month Period', Comment = 'ESM="Mes Periodo"';
                }
                field(MostrarInfo; MostrarInfo)
                {
                    Caption = 'Show Inf. Audit', Comment = 'ESM="Mostrar Inf. Audit."';
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
        recCompany: Record "Company Information";
        serie: Code[10];
        NoDocumento: Code[20];
        cantidadEnt: Decimal;
        costoUnitarioEnt: Decimal;
        costoTotalEnt: Decimal;
        cantidadSal: Decimal;
        costoUnitarioSal: Decimal;
        costoTotalSal: Decimal;
        tipoOperacion: Text[2];
        tipoDocumente: Text[2];
        recTranferHeader: Record "Transfer Header";
        recItem: Record Item;
        fechaIni: Date;
        FechaFin: Date;
        CantidadFinal: Decimal;
        SaldoFinal: Decimal;
        text012: Label 'Ingrese un rango de fechas.';
        year: Integer;
        tipoProdPdt: Text[30];
        recEnvio: Record "Transfer Shipment Header";
        recRecepcion: Record "Transfer Receipt Header";
        Ejercicio: Text[30];
        recAlmacen: Record Location;
        Establecimiento: Text[100];
        recConfigSunat: Record "Master Data";
        UndMedida: Text[30];
        Mes: Text[30];
        MetodoValuacion: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        Text001: Label 'Trial Balance';
        Text002: Label 'Data';
        Text003: Label 'Debit';
        Text004: Label 'Credit';
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        APELLIDOS_Y_NOMBRES__DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label 'APELLIDOS Y NOMBRES, DENOMINACION O RAZON SOCIAL:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        RUC_CaptionLbl: Label 'RUC:';
        REGISTRO_DE_INVENTARIO_PERMANENTE_VALORIZADO___DETALLE_DEL_INVENTARIO_VALORIZADOCaptionLbl: Label 'REGISTRO DE INVENTARIO PERMANENTE VALORIZADO - DETALLE DEL INVENTARIO VALORIZADO';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        TIPO_DE_EXISTENCIA_CaptionLbl: Label 'TIPO DE EXISTENCIA:';
        DESCRIPCION_CaptionLbl: Label 'DESCRIPCION:';
        COD__DE_UND__DE_MEDIDA_CaptionLbl: Label 'COD. DE UND. DE MEDIDA:';
        METODO_DE_VALUACION_CaptionLbl: Label 'METODO DE VALUACION:';
        ESTABLECIMIENTO_CaptionLbl: Label 'ESTABLECIMIENTO:';
        CODIGO_DE_EXISTENCIA_CaptionLbl: Label 'CODIGO DE EXISTENCIA:';
        COSTO_TOTALCaptionLbl: Label 'COSTO TOTAL';
        COSTO_UNITARIOCaptionLbl: Label 'COSTO UNITARIO';
        CANTIDADCaptionLbl: Label 'CANTIDAD';
        COSTO_TOTALCaption_Control1000000034Lbl: Label 'COSTO TOTAL';
        COSTO_UNITARIOCaption_Control1000000035Lbl: Label 'COSTO UNITARIO';
        COSTO_TOTALCaption_Control1000000017Lbl: Label 'COSTO TOTAL';
        COSTO_UNITARIOCaption_Control1000000019Lbl: Label 'COSTO UNITARIO';
        CANTIDADCaption_Control1000000036Lbl: Label 'CANTIDAD';
        TIPO_DE_OPERACIONCaptionLbl: Label 'TIPO DE OPERACION';
        ENTRADASCaptionLbl: Label 'ENTRADAS';
        CANTIDADCaption_Control1000000020Lbl: Label 'CANTIDAD';
        SALIDASCaptionLbl: Label 'SALIDAS';
        SALDO_FINALCaptionLbl: Label 'SALDO FINAL';
        DOCUMENTO_DE_TRASLADO__COMPROBANTE_DE_PAGO__DOCUMENTO_INTERNO_SIMILARCaptionLbl: Label 'DOCUMENTO DE TRASLADO, COMPROBANTE DE PAGO, DOCUMENTO INTERNO SIMILAR';
        NUMEROCaptionLbl: Label 'NUMERO';
        TIPOCaptionLbl: Label 'TIPO';
        SERIECaptionLbl: Label 'SERIE';
        FECHACaptionLbl: Label 'FECHA';
        gInicial: Decimal;
        gInicialAmt: Decimal;
        GiTEMtEMP: Text;
        gBoolNoVa: Text;
        gQuantity: array[3] of Decimal;
        cantidadCostFinal: Decimal;
        cantidadCostInicial: Decimal;
        gItemNo: Code[20];
        gvalor1: Code[25];
        gvalor2: Code[25];
        gNombreAlmacen: Code[45];
        recMaestroDatos: Record "Master Data";
        gCodigoExistencia: Code[35];
        gDescripcion: Code[35];
        _CatalogoUtilizado: Code[45];
        _TipoDeExistencia: Code[45];
        _ExistenciaCodeBSO: Code[45];
        _Description2: Code[45];
        _UnidadMedida: Code[45];
        _MetodoValuacion: Code[45];
        _TipoProducto: Code[45];
        gNroMov: Integer;
        gCodigoEstablecimiento: Code[10];
        gValueEntry: Record "Value Entry";
        gSalesInvoiceHeader: Record "Sales Invoice Header";
        gSalesCrMemoHeader: Record "Sales Cr.Memo Header";
        gTituloGratuito: Boolean;
        gSUNATTables: Record "Legal Document";
        gRevertido: Boolean;
        gItemLedgerEntry: Record "Item Ledger Entry";
        gPurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        gNoSeries: Record "No. Series";
        gPurchInvHeader: Record "Purch. Inv. Header";
        gAnulado: Boolean;
        gEntrada: Boolean;
        gSalida: Boolean;
        lclCantidad: Integer;
        gInicial_: Integer;
        gCantFinal: Integer;

    procedure LookUpPeriodo()
    var
        recAccountingPeriod: Record "Accounting Period";
        fini: Date;
        ffin: Date;
    begin

        fini := DMY2DATE(1, 1, DATE2DMY(WORKDATE, 3));
        ffin := DMY2DATE(31, 12, DATE2DMY(WORKDATE, 3));
        IF mosfr = TRUE THEN BEGIN
            fini := DMY2DATE(1, 1, mescab);
            ffin := DMY2DATE(31, 12, mescab);
        END;
        recAccountingPeriod.SETFILTER(recAccountingPeriod."Starting Date", '>=%1&<=%2', fini, ffin);
        IF PAGE.RUNMODAL(PAGE::"Accounting Periods", recAccountingPeriod) = ACTION::LookupOK THEN
            verperiodo := '';
        fechaIni := 0D;
        FechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        fechaIni := recAccountingPeriod."Starting Date";
        EVALUATE(FechaFin, FunctionFechaFin(recAccountingPeriod."Starting Date"));
        MesPeriodo := recAccountingPeriod.Name + ' del ' + FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaño": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaño := DATE2DMY(fechaing, 3);
        IF calaño MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaño));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaño));
        END;
    end;
}

