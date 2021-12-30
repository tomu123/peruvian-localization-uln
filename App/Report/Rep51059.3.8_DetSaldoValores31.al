report 51059 "3.8 Det. Saldo Valores .- 31"
{
    //LIBRO 3.8
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/3.8 Det. Saldo Valores .- 31.rdl';
    Caption = '3.8 Det. Saldo Valores .- 31';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(Nombre_Company; CompanyInfo.Name)
            {
            }
            column(ruc_Company; CompanyInfo."VAT Registration No.")
            {
            }
            column(Mes_Periodo; MesPeriodo)
            {
            }
            column(Ejercicio_; Ejercicio)
            {
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;

                MesPeriodo := FORMAT(Fechaini, 0, '<Month Text>');
                Ejercicio := FORMAT(Fechaini) + '..' + FORMAT(Fechafin);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Filtros)
                {
                    field("Fecha Inicio"; Fechaini)
                    {
                    }
                    field("Fecha Final"; Fechafin)
                    {
                    }
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
        IF Fechaini = 0D THEN
            ERROR(text001);

        IF Fechafin = 0D THEN
            ERROR(text002);

        MesPeriodo := FunGetMonthName(DATE2DMY(Fechaini, 2));//FORMAT(FechaIni,0,'<Month Text>');
        Ejercicio := FORMAT(Fechaini) + '..' + FORMAT(Fechafin);
    end;

    var
        text001: Label 'Por favor coloque la fecha inicial';
        text002: Label 'Por favor coloque la fecha final';
        Text005: Label 'Exportar';
        Text006: Label 'Todos los archivos (*.*)|*.*';
        Text007: Label 'SIN OPERACIONES';
        Fechaini: Date;
        Fechafin: Date;
        MesPeriodo: Text;
        Ejercicio: Text;
        CompanyInfo: Record "Company Information";

    local procedure FunGetMonthName(MonthNo: Integer): Text[250]
    begin
        CASE MonthNo OF
            1:
                EXIT('Enero');
            2:
                EXIT('Febrero');
            3:
                EXIT('Marzo');
            4:
                EXIT('Abril');
            5:
                EXIT('Mayo');
            6:
                EXIT('Junio');
            7:
                EXIT('Julio');
            8:
                EXIT('Agosto');
            9:
                EXIT('Setiembre');
            10:
                EXIT('Octubre');
            11:
                EXIT('Noviembre');
            12:
                EXIT('Diciembre');
        END;
    end;
}

