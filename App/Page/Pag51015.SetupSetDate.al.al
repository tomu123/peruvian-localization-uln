page 51015 "Setup Set Date"
{
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "General Ledger Setup";
    SourceTableTemporary = true;
    Caption = 'Set Date';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date', comment = 'ESM="Fecha Inicio"';
                    ;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
                }
                field(PDTNo; PDTNo)
                {
                    ApplicationArea = All;
                    Caption = 'PDT No.', Comment = 'ESM="N° PDT"';
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

    procedure SetBookCode(pPDTNo: Code[20])
    begin
        PDTNo := pPDTNo;
    end;

    var
        StartDate: Date;
        EndDate: Date;
        PDTNo: Code[20];
        ErrorEnterDate: Label 'Enter start date and end date to continue.', Comment = 'ESM="Ingrese fecha de inicio y fecha fin para continuar."';
}