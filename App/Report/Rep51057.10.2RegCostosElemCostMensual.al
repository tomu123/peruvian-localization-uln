report 51057 "Reg. Costos Elem.Cost.Mensual"
{
    //LIBRO 10.2
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Reg. Costos Elem.Cost.Mensual.rdl';
    dataset
    {
        dataitem("Purchases / Sales Records"; "Purchases / Sales Records")
        {
            column(ConsumoProduccion; "Purchases / Sales Records"."Consumo Produccion")
            {
            }
            column(MontoEnero; "Purchases / Sales Records".Enero)
            {
            }
            column(MontoFebrero; "Purchases / Sales Records".Febrero)
            {
            }
            column(MontoMarzo; "Purchases / Sales Records".Marzo)
            {
            }
            column(MontoAbril; "Purchases / Sales Records".Abril)
            {
            }
            column(MontoMayo; "Purchases / Sales Records".Mayo)
            {
            }
            column(MontoJunio; "Purchases / Sales Records".Junio)
            {
            }
            column(MontoJulio; "Purchases / Sales Records".Julio)
            {
            }
            column(MontoAgosto; "Purchases / Sales Records".Agosto)
            {
            }
            column(MontoSeptiembre; "Purchases / Sales Records".Septiembre)
            {
            }
            column(MontoOctubre; "Purchases / Sales Records".Octubre)
            {
            }
            column(MontoNoviembre; "Purchases / Sales Records".Noviembre)
            {
            }
            column(MontoDeciembre; "Purchases / Sales Records".Deciembre)
            {
            }
            column(Total; "Purchases / Sales Records".Total)
            {
            }
            column(Periodo; "Purchases / Sales Records".Periodo)
            {
            }
            column(RUC; gRUC)
            {
            }
            column(RAZONSOCIAL; gApellidoDenoRazonSocial)
            {
            }
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
                field("Fecha Final"; gFechaFinal)
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

    trigger OnPreReport()
    begin
        gCuPeru.GenerateCostRecordFormat(gFechaInicio, gFechaFinal, '10.2');

        recCompanyInformation.GET;
        gRUC := recCompanyInformation."VAT Registration No.";
        gApellidoDenoRazonSocial := recCompanyInformation.Name;
    end;

    var
        gCuPeru: Codeunit "Accountant Book Management";
        gFechaInicio: Date;
        gFechaFinal: Date;
        recCompanyInformation: Record "Company Information";
        gRUC: Code[15];
        gApellidoDenoRazonSocial: Code[55];
}

