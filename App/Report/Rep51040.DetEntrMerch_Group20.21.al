report 51040 "Det.Entr.Merch.(Group 20.21)"
{
    //LIBRO 3.7
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det.Entr.Merch.(Group 20.21).rdl';
    Caption = 'Det.Entries.Merch. (Group 20.21)', Comment = 'ESM="Det. Mov. Mercad. (Grupo 20.21)"';
    ProcessingOnly = false;
    UseSystemPrinter = false;

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(rucCompany; rucCompany)
            {
            }
            column(Ejercicio; Ejercicio)
            {
            }
            column(MesPeriodo; MesPeriodo)
            {
            }

            trigger OnPreDataItem()
            begin
                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);

                NombreProv := CompanyInfo.Name;
                rucCompany := CompanyInfo."VAT Registration No.";
            end;
        }
        dataitem("Item"; "Item")
        {
            RequestFilterFields = "No.";
            column(UserInfo; UsuarioInfo)
            {
            }
            column(PaginaInfo; PaginaInfo)
            {
            }
            column(InfoFecha; FechaInfo)
            {
            }
            column(Inventory_Posting_Group______txtnomgrupo____; "Inventory Posting Group" + '(' + txtnomgrupo + ')')
            {
            }
            column(dtotalgrupo; dtotalgrupo)
            {
            }
            column(Total___txtnomgrupo___es____; 'Total ' + txtnomgrupo + ' es : ')
            {
            }
            column(SALDOTOTAL; SALDOTOTAL)
            {
            }
            column(txtmensaje; txtmensaje)
            {
            }
            column(deccostocta; deccostocta)
            {
            }
            column(DENOMINACION_O_RAZON_SOCIAL_Caption; DENOMINACION_O_RAZON_SOCIAL_CaptionLbl)
            {
            }
            column(RUC_Caption; RUC_CaptionLbl)
            {
            }
            column(EJERCICIO_Caption; EJERCICIO_CaptionLbl)
            {
            }
            column(PERIODO_Caption; PERIODO_CaptionLbl)
            {
            }
            column(LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_20___MERCADERIASCaption; LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_20___MERCADERIASCaptionLbl)
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
            column(CODIGO_DE_LA_UNIDAD_DE_MEDIDACaption; CODIGO_DE_LA_UNIDAD_DE_MEDIDACaptionLbl)
            {
            }
            column(DESCRIPCIONCaption; DESCRIPCIONCaptionLbl)
            {
            }
            column(TIPO_DE_EXISTENCIACaption; TIPO_DE_EXISTENCIACaptionLbl)
            {
            }
            column(METODO_EVALUAC__APLIC_Caption; METODO_EVALUAC__APLIC_CaptionLbl)
            {
            }
            column(CODIGO_DE_LA_EXISTENCIACaption; CODIGO_DE_LA_EXISTENCIACaptionLbl)
            {
            }
            column(Grupo_Contable_De_ExistenciaCaption; Grupo_Contable_De_ExistenciaCaptionLbl)
            {
            }
            column(COSTO_GENERAL_Caption; COSTO_GENERAL_CaptionLbl)
            {
            }
            column(Item_No_; "No.")
            {
            }
            column(Item_Inventory_Posting_Group; "Inventory Posting Group")
            {
            }
            column(sTipoExistencia; sTipoExistencia)
            {
            }
            column(dMontoCta20; dMontoCta20)
            {
            }
            column(Item_Description; Item_Description)
            {
            }
            column(Item__No__; Item."No.")
            {
            }
            column(Cantidad; _Inventory)
            {
            }
            column(TipodeExistencia; Item."Type of Existence")
            {
            }
            column(Description; Item.Description)
            {
            }
            column(CodigoUnidadMedida; Item."Base Unit of Measure")
            {
            }
            column(CostoUnitario; dMontoCta20 / _Inventory)
            {
            }
            column(FechaIni; FechaIni)
            {
            }
            column(FechaFin; FechaFin)
            {
            }

            trigger OnAfterGetRecord()
            begin

                //si es cuenta existencia
                //ULN:PC 25.06.21++++++++
                IF NOT fnisAccountExistence() THEN
                    CurrReport.Skip();
                //ULN:PC 25.06.21---------
                intcanttot := 0;
                deccostototal := 0;
                deccostounit := 0;
                intcant := 0;
                dMontoCta20 := 0;
                sTipoExistencia := '';

                InfoItem();

                _Inventory := 0;
                recItemLedgerEntry.RESET;
                recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Item No.", "No.");
                recItemLedgerEntry.SETRANGE(recItemLedgerEntry."Posting Date", 0D, FechaFin);
                IF recItemLedgerEntry.FINDSET THEN
                    REPEAT
                        _Inventory := _Inventory + recItemLedgerEntry.Quantity;
                    UNTIL recItemLedgerEntry.NEXT = 0;

                IF _Inventory <> 0 THEN BEGIN

                    dMontoCta20 := 0;
                    recItemLedgerEntry2.RESET;
                    recItemLedgerEntry2.SETRANGE(recItemLedgerEntry2."Item No.", "No.");
                    recItemLedgerEntry2.SETRANGE(recItemLedgerEntry2."Posting Date", 0D, FechaFin);
                    IF recItemLedgerEntry2.FINDSET THEN
                        REPEAT
                            recItemLedgerEntry2.CALCFIELDS(recItemLedgerEntry2."Cost Amount (Actual)");
                            dMontoCta20 := dMontoCta20 + recItemLedgerEntry2."Cost Amount (Actual)"
                        UNTIL recItemLedgerEntry2.NEXT = 0;


                END ELSE BEGIN
                    CurrReport.SKIP;
                END;
            end;

            trigger OnPreDataItem()
            begin

                Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);

                NombreProv := CompanyInfo.Name;
                rucCompany := CompanyInfo."VAT Registration No.";
                IF FechaIni = 0D THEN
                    ERROR(text001);
                IF FechaFin = 0D THEN
                    ERROR(text002);

                SALDOTOTAL := 0;

                SETRANGE("Date Filter", 0D, FechaFin);
                // SETFILTER("Cta Existencias", '%1|%2', '20*', '21*');
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
                    Caption = 'Año Referencial', Comment = 'ESM="Año Referencial"';

                    trigger OnValidate()
                    begin

                        IF mosfr = TRUE THEN BEGIN
                            mescab := DATE2DMY(TODAY, 3)
                        END ELSE BEGIN
                            mescab := 0;
                        END;
                    end;
                }
                field(ARef; mescab)
                {
                }
                field(verperiodo; verperiodo)
                {
                    Caption = 'Fecha Referencial', Comment = 'ESM="Fecha Referencial"';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        LookUpPeriodo();
                    end;
                }
                field(FechaIni; FechaIni)
                {
                    Caption = 'Fecha Inicio', Comment = 'ESM="Fecha Inicio"';
                }
                field(FechaFin; FechaFin)
                {
                    Caption = 'Fecha Fin', Comment = 'ESM="Fecha Fin"';
                }
                field(MesPeriodo; MesPeriodo)
                {
                    Caption = 'Periodo', Comment = 'ESM="Periodo"';
                }
                field(MostrarInfo; MostrarInfo)
                {
                    Caption = 'Mostrar Info Audit.', Comment = 'ESM="Mostrar Info Audit."';
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

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
    end;

    local procedure fnisAccountExistence(): Boolean
    var
        lcRecInventoryPostingSetup: Record "Inventory Posting Setup";

    begin
        lcRecInventoryPostingSetup.Reset();
        lcRecInventoryPostingSetup.SetRange("Invt. Posting Group Code", Item."Inventory Posting Group");
        lcRecInventoryPostingSetup.SETFILTER("Inventory Account", '%1|%2', '20*', '21*');
        if lcRecInventoryPostingSetup.FindSet() then
            exit(true);

        exit(false);
    end;

    var
        SALDOTOTAL: Decimal;
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        NombreProv: Text[100];
        recVendor: Record Vendor;
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        costoTotal: Decimal;
        text001: Label 'Por favor ingresar la fecha inicio del periodo.';
        recItemLE: Record "Item Ledger Entry";
        InvEjercicio: Decimal;
        text002: Label 'Por favor ingresar la fecha fin del periodo.';
        Mes: Text[30];
        MesPeriodo: Text[30];
        MostrarInfo: Boolean;
        FechaInfo: Text[30];
        PaginaInfo: Text[30];
        UsuarioInfo: Text[30];
        recConfigSunat: Record "Master Data";
        UndMedida: Text[30];
        RecItem: Record "Item";
        MetValuacion: Text[40];
        strMetValuacion: Text[40];
        "Product Group Code": Code[20];
        "Base Unit of Measure": Code[20];
        Item2: Record Item;
        verperiodo: Text[100];
        mescab: Integer;
        mosfr: Boolean;
        fini: Date;
        ffin: Date;
        intmetodo: Integer;
        blnGeneraTXT: Boolean;
        outfile: File;
        //   folder: Automation;
        strDirectorio: Text[100];
        strFile: Text[100];
        strPeriodo: Text[100];
        intestado: Integer;
        strprodant: Text[100];
        strprodnue: Text[100];
        intcant: Decimal;
        deccostounit: Decimal;
        deccostototal: Decimal;
        recprodrel: Record "G/L - Item Ledger Relation";
        recmovcta: Record "G/L Entry";
        intcanttot: Integer;
        txtmensaje: Text[1024];
        dMontoCta20: Decimal;
        bAfectoCta20: Boolean;
        recInvPostingSetup: Record "Inventory Posting Setup";
        deccostocta: Decimal;
        dtotalgrupo: Decimal;
        recInventoryPostingGroup: Record "Inventory Posting Group";
        txtnomgrupo: Text[50];
        recmovval: Record "Value Entry";
        PrintToExcel: Boolean;
        ExcelBuf: Record "Excel Buffer" temporary;
        Text005: Label 'Company Name';
        Text006: Label 'Report No.';
        Text007: Label 'Report Name';
        Text008: Label 'User ID';
        Text009: Label 'Date';
        Text010: Label 'G/L Filter';
        Text011: Label 'Period Filter';
        grupo: Text[100];
        Text012: Label 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 20 - MERCADERIAS';
        DENOMINACION_O_RAZON_SOCIAL_CaptionLbl: Label ' DENOMINACION O RAZON SOCIAL:';
        RUC_CaptionLbl: Label 'RUC:';
        EJERCICIO_CaptionLbl: Label 'EJERCICIO:';
        PERIODO_CaptionLbl: Label 'PERIODO:';
        LIBRO_DE_INVENTARIOS_Y_BALANCES___DETALLE_DEL_SALDO_DE_LA_CUENTA_20___MERCADERIASCaptionLbl: Label 'LIBRO DE INVENTARIOS Y BALANCES - DETALLE DEL SALDO DE LA CUENTA 20 - MERCADERIAS';
        COSTO_TOTALCaptionLbl: Label 'COSTO TOTAL';
        COSTO_UNITARIOCaptionLbl: Label 'COSTO UNITARIO';
        CANTIDADCaptionLbl: Label 'CANTIDAD';
        CODIGO_DE_LA_UNIDAD_DE_MEDIDACaptionLbl: Label 'CODIGO DE LA UNIDAD DE MEDIDA';
        DESCRIPCIONCaptionLbl: Label 'DESCRIPCION';
        TIPO_DE_EXISTENCIACaptionLbl: Label 'TIPO DE EXISTENCIA';
        METODO_EVALUAC__APLIC_CaptionLbl: Label 'METODO EVALUAC. APLIC.';
        CODIGO_DE_LA_EXISTENCIACaptionLbl: Label 'CODIGO DE LA EXISTENCIA';
        Grupo_Contable_De_ExistenciaCaptionLbl: Label 'Grupo Contable De Existencia';
        COSTO_GENERAL_CaptionLbl: Label 'COSTO GENERAL:';
        Item_Description: Text[500];
        Base_Unit_of_Measure_: Text[100];
        sTipoExistencia: Text[50];
        recItemLedgerEntry: Record "Item Ledger Entry";
        _Inventory: Decimal;
        costoUnitario: Decimal;
        recItemLedgerEntry2: Record "Item Ledger Entry";

    procedure InfoItem()
    begin

        "Base Unit of Measure" := UndMedida;
        MetValuacion := FORMAT(Item."Costing Method");
        IF MetValuacion = 'Especial' THEN BEGIN
            strMetValuacion := 'Idntif.Espcf.Esp.';
            intmetodo := 5;
        END
        ELSE BEGIN
            strMetValuacion := 'Prom.Pond.Mdio.';
            intmetodo := 1;
        END;
    end;

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
        FechaIni := 0D;
        FechaFin := 0D;
        MesPeriodo := '';
        verperiodo := recAccountingPeriod.Name;
        FechaIni := recAccountingPeriod."Starting Date";
        EVALUATE(FechaFin, FunctionFechaFin(recAccountingPeriod."Starting Date"));
        MesPeriodo := FORMAT(DATE2DMY(recAccountingPeriod."Starting Date", 3));
    end;

    procedure FunctionFechaFin(fechaing: Date): Text[30]
    var
        calmes: Integer;
        "calaõo": Integer;
        refmes: Integer;
    begin
        calmes := DATE2DMY(fechaing, 2);
        calaõo := DATE2DMY(fechaing, 3);
        IF calaõo MOD 4 = 0 THEN
            refmes := 29
        ELSE
            refmes := 28;
        CASE calmes OF
            1:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            2:
                EXIT(FORMAT(refmes) + '/' + FORMAT(calaõo) + '/' + FORMAT(calaõo));
            3:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            4:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            5:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            6:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            7:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            8:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            9:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            10:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            11:
                EXIT('30/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
            12:
                EXIT('31/' + FORMAT(calmes) + '/' + FORMAT(calaõo));
        END;
    end;
}

