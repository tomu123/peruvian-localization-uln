codeunit 51035 "SL Auto Currency Exch. Update"
{
    trigger OnRun()
    begin
        Clear(RptUpdCurrExchRate);
        RptUpdCurrExchRate.SetHideDialog();
        RptUpdCurrExchRate.SetPostingDate();
        RptUpdCurrExchRate.CallUpdateCurrency();
    end;

    var
        RptUpdCurrExchRate: Report "AER Update Curr. Exch. Rate";
}