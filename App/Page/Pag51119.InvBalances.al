page 51119 "Inv. Balances"
{

    UsageCategory = Lists;
    ApplicationArea = All;
    Caption = 'Inv. Saldos';

    PageType = List;
    SourceTable = "Inv. Balances";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Period Number"; "Period Number")
                {
                    ApplicationArea = All;
                }
                field("Sunat Doc. Type"; "Sunat Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Sunat Doc. No."; "Sunat Doc. No.")
                {
                    ApplicationArea = All;
                }
                field(Denomination; Denomination)
                {
                    ApplicationArea = All;
                }
                field("Unit Value"; "Unit Value")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Total Cost"; "Total Cost")
                {
                    ApplicationArea = All;
                }
                field("Total Provision"; "Total Provision")
                {
                    ApplicationArea = All;
                }
                field("Net Total"; "Net Total")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Period Name"; "Period Name")
                {
                    ApplicationArea = All;
                }
                field("Imp Capital Social"; "Imp Capital Social")
                {
                    ApplicationArea = All;
                }
                field("Valor Nominal Por Accion"; "Valor Nominal Por Accion")
                {
                    ApplicationArea = All;
                }
                field("Share Type"; "Share Type")
                {
                    ApplicationArea = All;
                }
                field("Share Number"; "Share Number")
                {
                    ApplicationArea = All;
                }
                field("Share Percentage"; "Share Percentage")
                {
                    ApplicationArea = All;
                }
                field("Shared Number 2"; "Shared Number 2")
                {
                    ApplicationArea = All;
                }
                field("Shared Number 3"; "Shared Number 3")
                {
                    ApplicationArea = All;
                }
                field("Acc. No Type"; "Acc. No Type")
                {
                    ApplicationArea = All;
                }
                field("G/L Entry No."; "G/L Entry No.")
                {
                    ApplicationArea = All;
                }
                field("G/L Entry Date"; "G/L Entry Date")
                {
                    ApplicationArea = All;
                }
                field("Sunat Share Type"; "Sunat Share Type")
                {
                    ApplicationArea = All;
                }
                field("ID Balance"; "ID Balance")
                {
                    ApplicationArea = All;
                }
                field(Capital; Capital)
                {
                    ApplicationArea = All;
                }
                field("Acciones de Inversion"; "Acciones de Inversion")
                {
                    ApplicationArea = All;
                }
                field("Resultado No Realizados"; "Resultado No Realizados")
                {
                }
                field("Reservas Legales"; "Reservas Legales")
                {
                    ApplicationArea = All;
                }
                field("Capital Adicional"; "Capital Adicional")
                {
                    ApplicationArea = All;
                }
                field("Otras Reservas"; "Otras Reservas")
                {
                    ApplicationArea = All;
                }
                field("Resultados Acomulados"; "Resultados Acomulados")
                {
                    ApplicationArea = All;
                }
                field("Resultado Neto Del Ejercicio"; "Resultado Neto Del Ejercicio")
                {
                    ApplicationArea = All;
                }
                field("Excedente de revaluacion"; "Excedente de revaluacion")
                {
                    ApplicationArea = All;
                }
                field("Resultado del Ejercicio"; "Resultado del Ejercicio")
                {
                    ApplicationArea = All;
                }
                field("Nro Fila"; "Nro Fila")
                {
                    ApplicationArea = All;
                }
                field(Descripcion; Descripcion)
                {
                    ApplicationArea = All;
                }
                field("Tipo de Acciones"; "Tipo de Acciones")
                {
                    ApplicationArea = All;
                }
                field("Tipo de Acciones Fisico"; "Tipo de Acciones Fisico")
                {
                    ApplicationArea = All;
                }
                field("Tipo de Acciones Descripcion"; "Tipo de Acciones Descripcion")
                {
                    ApplicationArea = All;
                }
            }
        }
    }





    trigger OnOpenPage()
    begin

    end;

    var

}

