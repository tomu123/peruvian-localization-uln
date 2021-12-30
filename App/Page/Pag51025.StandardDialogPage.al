page 51025 "Standard Dialog Page"
{
    // version AGR2
    //ULN::PC    002  Function Add fnGetStartDate,fnGetEndDate
    Caption = 'Standard Dialog Page', Comment = 'ESM="Opciones"';
    PageType = StandardDialog;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(CompanyName; CompanyName)
                {
                    ApplicationArea = All;
                    Caption = 'CompanyName', Comment = 'ESM="Nombre Empresa origen"';
                    TableRelation = Company.Name;
                    Visible = CompanyNameVisible;
                }
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Initial Date', Comment = 'ESM="Fecha Inicial"';
                    Visible = ExtractBankVisible;
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'Final Date', Comment = 'ESM="Fecha Final"';
                    Visible = ExtractBankVisible;
                }
                field(DocumentNo; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.', Comment = 'ESM="N° Documento"';
                    Visible = BankPaymentScheduleVisible;
                }
                field(PaymentMethodCode; PaymentMethodCode)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Method Code', Comment = 'ESM="Cód. Forma Pago"';
                    Visible = BankPaymentScheduleVisible;
                }
                field(PreferredBankAccNoPaySch; PreferredBankAccNoPaySch)
                {
                    ApplicationArea = All;
                    Caption = 'Reference Bank No.', Comment = 'ESM="N° Banco Referencia"';
                    Visible = BankPaymentScheduleVisible;
                }
                field(ReverseDate; ReverseDate)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Date', Comment = 'ESM="Fecha Reversión"';
                    Visible = ReverseInfoVisible;
                }
                field(ReverseReason; ReverseReason)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse reason', Comment = 'ESM="Motivo Reversión"';
                    Visible = ReverseInfoVisible;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
    end;

    trigger OnOpenPage();
    begin
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin
        if CloseAction in [Action::LookupOK, Action::OK] then begin
            if ReverseInfoVisible then begin
                if ReverseDate = 0D then
                    Error('Requiere ingresar una fecha de reversión válida.');
                if ReverseReason = '' then
                    Error('Requiere ingresar una motivo de descripción válido.');
            end;
        end;
    end;

    var
        DocumentNo: Code[20];
        PaymentMethodCode: Code[20];
        PreferredBankAccNoPaySch: Code[20];
        StartDate: Date;
        EndDate: Date;
        ReverseDate: Date;
        ReverseReason: Text[100];
        CompanyName: Text[100];
        BankPaymentScheduleVisible: Boolean;
        ExtractBankVisible: Boolean;
        ReverseInfoVisible: Boolean;
        CompanyNameVisible: Boolean;
        PaymentSchedule: Record "Payment Schedule";


    procedure SetType(pType: Integer);
    begin
        ExtractBankVisible := pType = 1;
        BankPaymentScheduleVisible := pType = 2;
        ReverseInfoVisible := pType = 3;
        CompanyNameVisible := pType = 4;
    end;

    procedure GetBankInformation(var pPaymentMethodCode: Code[20]; var pPreferredBankAccountNo: Code[20]);
    begin
        pPaymentMethodCode := PaymentMethodCode;
        pPreferredBankAccountNo := PreferredBankAccNoPaySch;
    end;

    procedure GetReverseInfo(var pReverseDate: Date; var pReverseReason: Text)
    begin
        pReverseDate := ReverseDate;
        pReverseReason := ReverseReason;
    end;

    procedure SetPaymentScheduleEntryNo(pPaymentScheduleEntryNo: Integer);
    begin
        PaymentSchedule.Get(pPaymentScheduleEntryNo);
        DocumentNo := PaymentSchedule."Document No.";
        PaymentMethodCode := PaymentSchedule."Payment Method Code";
        PreferredBankAccNoPaySch := PaymentSchedule."Preferred Bank Account Code";
    end;

    procedure SetReverseDate(pReverseDate: date)
    begin
        ReverseDate := pReverseDate;
    end;

    procedure SetReverseReason(pReverseReason: Text)
    begin
        ReverseReason := pReverseReason;
    end;

    procedure GetStartDate(): Date;
    begin
        if StartDate = 0D then
            Error('Debe seleccionar Fecha Incial.');
        exit(StartDate)
    end;

    procedure GetEndDate(): Date;
    begin
        if EndDate = 0D then
            Error('Debe seleccionar Fecha Final.');
        exit(EndDate);
    end;

    procedure GetCompanyName(): text;
    begin
        exit(CompanyName);
    end;
}

