page 51120 "Set Date Currency"
{
    PageType = StandardDialog;

    layout
    {
        area(Content)
        {
            group(Parameters)
            {
                Caption = 'Parameters', Comment = 'ESM="Parametros"';
                field(CurrencyCode; CurrencyCode)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Code', Comment = 'ESM="Cód. Divisa"';
                    Editable = false;
                }
                field(CurrencyDate; CurrencyDate)
                {
                    ApplicationArea = All;
                    Caption = 'Currency Date', Comment = 'ESM="Fecha tipo de cambio"';
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if not (CloseAction in [Action::OK, Action::LookupOK]) then
            exit;
        if CurrencyCode = '' then
            Error('');
        if CurrencyDate = 0D then
            Error('');
        ConsultaTCMgt.SetParameters(CurrencyCode, CurrencyDate);

    end;

    var
        ConsultaTCMgt: Codeunit "Consulta TC Mgt.";
        CurrencyCode: Code[10];
        CurrencyDate: Date;
}