page 51004 "Set Date to Book"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Purchase Record Buffer";
    SourceTableTemporary = true;
    Caption = 'Set Date', Comment = 'ESM="Ingrese fecha"';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date', Comment = 'ESM="Fecha Inicio"';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
                }
                field(BookCode; BookCode)
                {
                    ApplicationArea = All;
                    Caption = 'Book Code', Comment = 'ESM="Cód. Libro"';
                    Editable = false;

                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        StartDate := CalcDate('<-CM>', Today());
        EndDate := CalcDate('<CM>', Today());
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if (StartDate = 0D) or (EndDate = 0D) then
            Error(ErrorEnterDate);
    end;

    procedure SetFilterDate(var pStartDate: Date; var pEndDate: Date)
    begin
        pStartDate := StartDate;
        pEndDate := EndDate;
    end;

    procedure SetBookCode(pBookCode: Code[20])
    begin
        BookCode := pBookCode;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        BookCode: Code[20];
        ErrorEnterDate: Label 'Enter start date and end date to continue.', Comment = 'ESM="Ingrese fecha de incio y fin para continuar."';
}