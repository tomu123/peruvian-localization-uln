report 51046 "Det. del Saldo de la Cta 50"
{
    //LIBRO 3.16

    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::CCL  001   2018.01.31  v.001     LPE
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Det. del Saldo de la Cta 50.rdl';


    dataset
    {
        dataitem("Inv. Balances"; "Inv. Balances")
        {
            column(TipoSunat; "Inv. Balances"."Sunat Share Type")
            {
            }
            column(Periodo; "Inv. Balances"."Period Number")
            {
            }
            column(Tipo; "Inv. Balances"."Sunat Doc. Type")
            {
            }
            column(Numero; "Inv. Balances"."Sunat Doc. No.")
            {
            }
            column(TipoDeAcciones; "Inv. Balances"."Tipo de Acciones")
            {
            }
            column(ApellidosyNombresDenominacionSocialoRazonSocialDelEmisor; "Inv. Balances".Name)
            {
            }
            column(NumeroDeAccionesoParticipaciones; "Inv. Balances"."Share Number")
            {
            }
            column(PorcentajeTotalDeParticipaciones; fnGetPorcentaje("Inv. Balances"."Share Percentage"))
            {
            }
            column(ImporteCapitalSocial; "Inv. Balances"."Imp Capital Social")
            {
            }
            column(ValorNominalPorAccion; "Inv. Balances"."Valor Nominal Por Accion")
            {
            }
            column(NroAccionesPartiSocialesPag; "Inv. Balances"."Shared Number 2")
            {
            }
            column(sumCapitaSocialOParticipacionesSociales; gCapitaSocialOParticipacionesSociales)
            {
            }
            column(sumValorNominalPorAccionOParticipacion; gValorNominalPorAccionOParticipacion)
            {
            }
            column(sumNumeroAccionesPartSocialesSuscritas; gNumeroAccionesPartSocialesSuscritas)
            {
            }
            column(sumNumeroAccionesPartSocialesPagadas; gNumeroAccionesPartSocialesPagadas)
            {
            }
            column(sumNumeroDeAccionesSocios; gNumeroDeAccionesSocios)
            {
            }
            column(RUC; gRUC)
            {
            }
            column(RAZONSOCIAL; gApellidoDenoRazonSocial)
            {
            }
            column(EJERCICIO; gEjercicio)
            {
            }
            column(TipoAccionesDescrip; gDesTipoAcc)
            {
            }
            column(TipodeAccionesFisico; "Inv. Balances"."Tipo de Acciones Descripcion")
            {
            }

            trigger OnAfterGetRecord()
            begin
                gNumeroDeAccionesSocios := 0;
                gEjercicio := COPYSTR("Period Number", 1, 4);
                recInvBal.RESET;
                recInvBal.SETRANGE("Period Number", "Period Number");
                //recInvBal.SETRANGE(recInvBal."Sunat Share Type","Inv. Balances"."Sunat Share Type"::"501");
                IF recInvBal.FINDFIRST THEN BEGIN
                    // gCapitaSocialOParticipacionesSociales := recInvBal."Imp Capital Social";
                    gValorNominalPorAccionOParticipacion := recInvBal."Valor Nominal Por Accion";
                END;
                fnRecalculateSaldoCapital;//PC 20.05.21
                gNumeroAccionesPartSocialesSuscritas := 0;
                gNumeroAccionesPartSocialesPagadas := 0;
                recInvBal.RESET;
                recInvBal.SETRANGE(recInvBal."Period Number", "Period Number");
                //recInvBal.SETRANGE(recInvBal."Sunat Share Type","Inv. Balances"."Sunat Share Type"::"502");

                IF recInvBal.FINDSET THEN
                    REPEAT
                        IF recInvBal."Shared Number 2" > 0 THEN BEGIN
                            gNumeroAccionesPartSocialesPagadas += recInvBal."Shared Number 2"
                        END;

                        IF recInvBal."Shared Number 3" > 0 THEN
                            gNumeroAccionesPartSocialesSuscritas += recInvBal."Shared Number 3";

                        IF recInvBal."Sunat Share Type" = recInvBal."Sunat Share Type"::"502" THEN
                            gNumeroDeAccionesSocios += 1;

                    UNTIL recInvBal.NEXT = 0;

                IF recInvBal."Shared Number 2" > 0 THEN
                    gCounter += 1;

                IF "Inv. Balances"."Sunat Share Type" = "Inv. Balances"."Sunat Share Type"::"501" THEN BEGIN
                    CurrReport.SKIP;
                END;

                gLegalDocument.RESET;
                gLegalDocument.SETRANGE("Option Type", gLegalDocument."Option Type"::"SUNAT Table");
                gLegalDocument.SETRANGE("Type Code", '16');
                gLegalDocument.SETRANGE("Legal No.", "Inv. Balances"."Tipo de Acciones");
                IF gLegalDocument.FINDSET THEN BEGIN
                    gDesTipoAcc := gLegalDocument.Description;
                END;

            end;

            trigger OnPreDataItem()
            begin
                tFechaInicio := FORMAT(DATE2DMY(gFechaInicio, 3));
                tFechaFin := FORMAT(DATE2DMY(gFechaFin, 3));
                "Inv. Balances".SETRANGE("Inv. Balances"."Period Number", tFechaInicio);
                gCounter := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Fecha Inicio"; gFechaInicio)
                {
                }
                field("Fecha Fin"; gFechaFin)
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

    trigger OnInitReport()
    begin

        recCompanyInformation.GET;
        gRUC := recCompanyInformation."VAT Registration No.";
        gApellidoDenoRazonSocial := recCompanyInformation.Name;
    end;

    var
        recInvBal: Record "Inv. Balances";
        gCapitaSocialOParticipacionesSociales: Decimal;
        gValorNominalPorAccionOParticipacion: Decimal;
        gNumeroAccionesPartSocialesSuscritas: Integer;
        gNumeroAccionesPartSocialesPagadas: Integer;
        gNumeroDeAccionesSocios: Integer;
        gEjercicio: Code[5];
        gRUC: Code[15];
        gApellidoDenoRazonSocial: Code[65];
        recCompanyInformation: Record "Company Information";
        gFechaInicio: Date;
        gFechaFin: Date;
        tFechaInicio: Text;
        tFechaFin: Text;
        gCounter: Integer;
        gDesTipoAcc: Code[50];
        gLegalDocument: Record "Legal Document";

    local procedure fnGetPorcentaje(pValudePorcentaje: Decimal): Decimal
    begin
        IF pValudePorcentaje = 0 THEN
            EXIT(0);

        EXIT(pValudePorcentaje / 100);
    end;

    local procedure fnRecalculateSaldoCapital()
    var
        lclRecGLAccount: Record "G/L Account";
    begin
        lclRecGLAccount.RESET;
        lclRecGLAccount.SETFILTER("No.", '%1', '50*');
        lclRecGLAccount.SETFILTER("Date Filter", '..%1', gFechaFin);
        IF lclRecGLAccount.FINDSET THEN
            REPEAT
                lclRecGLAccount.CALCFIELDS("Net Change");
                gCapitaSocialOParticipacionesSociales += lclRecGLAccount."Net Change";
            UNTIL lclRecGLAccount.NEXT = 0;
        gCapitaSocialOParticipacionesSociales := ABS(gCapitaSocialOParticipacionesSociales);
    end;
}

