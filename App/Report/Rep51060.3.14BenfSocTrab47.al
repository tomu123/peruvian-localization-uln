report 51060 "3.14 Benf. Soc. Trab .- 47"
{
    //LIBRO 3.14
    // Identify  Nro.  yyyy.MM.dd  Version   Description
    // -----------------------------------------------------
    // ULN::PC   001   2021.07.05    V.1     Peruvian Books (Copy From MT )
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/3.14 Benf. Soc. Trab .- 47.rdl';
    Caption = '3.14 Benf. Soc. Trab .- 47';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = WHERE(Number = CONST(1));
            column(Mes_Periodo; MesPeriodo)
            {
            }
            column(Ejercicio_; Ejercicio)
            {
            }
            column(ruc_Company; CompanyInfo."VAT Registration No.")
            {
            }
            column(Nombre_Company; CompanyInfo.Name)
            {
            }

            trigger OnPreDataItem()
            begin
                CompanyInfo.GET;
            end;
        }
        dataitem("Vendor Ledger Entry"; "Vendor Ledger Entry")
        {
            DataItemTableView = SORTING("Entry No.")
                                ORDER(Ascending)
                                WHERE("Vendor Posting Group" = FILTER('415*'),
                                      "Remaining Amount" = FILTER(<> 0));
            column(Amount_; 0)
            {
            }

            trigger OnPreDataItem()
            begin
                SETRANGE("Posting Date", FechaIni, FechaFin);
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
                    field("Fecha Inicio"; FechaIni)
                    {
                    }
                    field("Fecha Final"; FechaFin)
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
        IF FechaIni = 0D THEN
            ERROR(text001);

        IF FechaFin = 0D THEN
            ERROR(text002);

        MesPeriodo := FORMAT(FechaIni, 0, '<Month Text>');
        MesPeriodo := FformatMonth(MesPeriodo);
        Ejercicio := FORMAT(FechaIni) + '..' + FORMAT(FechaFin);
    end;

    var
        CompanyInfo: Record "Company Information";
        rucCompany: Text[30];
        NombreCompany: Text[30];
        Ejercicio: Text[30];
        FechaIni: Date;
        FechaFin: Date;
        FechaPeriodo: Date;
        MesPeriodo: Text[30];
        text001: Label 'Ingrese la Fecha de Inicio del Periodo';
        text002: Label '<Ingrese la Fecha Fin del Periodo>';
        Text005: Label 'Exportar';
        Text006: Label 'Todos los archivos (*.*)|*.*';

    local procedure FformatMonth(ParMonth: Text) ReturnMonth: Text[50]
    var
        LvarPart1: Text[50];
        LvarPart2: Text[50];
        LvarLong: Integer;
        Lvarpart1UP: Text[50];
    begin
        //++PC
        LvarLong := STRLEN(ParMonth);
        LvarPart1 := COPYSTR(ParMonth, 1, 1);
        Lvarpart1UP := UPPERCASE(LvarPart1);
        LvarPart2 := COPYSTR(ParMonth, 2, LvarLong);
        ReturnMonth := Lvarpart1UP + LvarPart2;
        //--PC
    end;
}

