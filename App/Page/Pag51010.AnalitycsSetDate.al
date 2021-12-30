page 51010 "Analitycs Set Date"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
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
                    Caption = 'Start Date', Comment = 'ESM="Fecha inicio"';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Visible = not VisibleOnlyStartDate;
                    Caption = 'End Date', Comment = 'ESM="Fecha fin"';
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if StartDate = 0D then begin
            StartDate := CalcDate('<-CM>', Today());
            EndDate := CalcDate('<CM>', Today());
        end;

    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if ((StartDate = 0D) or (EndDate = 0D)) and (not VisibleOnlyStartDate) then
            Error(ErrorEnterDate);
        if VisibleOnlyStartDate and ((StartDate = 0D)) then
            Error(ErrorEnterStartDate);

        if not (CloseAction in [Action::OK, Action::LookupOK]) then
            exit;
    end;

    procedure SetFilterDate(var pStartDate: Date; var pEndDate: Date)
    begin
        pStartDate := StartDate;
        pEndDate := EndDate;
    end;

    procedure SetOnlyStartDate()
    begin
        StartDate := Today;
        VisibleOnlyStartDate := true
    end;

    procedure GetStartDate(var pStartDate: Date)
    begin
        pStartDate := StartDate
    end;

    var
        StartDate: Date;
        EndDate: Date;
        VisibleOnlyStartDate: Boolean;
        ErrorEnterDate: Label 'Enter start date and end date to continue.', Comment = 'ESM="Ingrese fecha de inicio y fecha fin para continuar."';
        ErrorEnterStartDate: Label 'Enter start date to continue.', Comment = 'ESM="Ingrese fecha de inicio para continuar"';
}