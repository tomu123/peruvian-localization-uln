pageextension 51099 "Setup G/L Account Card" extends "G/L Account Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cost Accounting")
        {
            group(SetupLocalization)
            {
                Caption = 'Setup Localization';
                field(FirstField; FirstField)
                {
                    Visible = false;
                    Editable = false;
                }
                field(Analitycs; Analitycs)
                {
                    ApplicationArea = All;
                }
            }
        }

        //Purchase Request
        addafter("Omit Default Descr. in Jnl.")
        {
            field("PR Generic Purchase"; "PR Generic Purchase")
            {
                ApplicationArea = All;
                trigger OnValidate()
                var
                    GLAccount: Record "G/L Account";
                    Text001: label 'Only one account is allowed for generic purchase', Comment = 'ESM="Solo se permite una cuenta para compras genéricas"';
                begin
                    GLAccount.Reset();
                    GLAccount.SetRange("PR Generic Purchase", true);
                    if GLAccount.Count() > 1 then begin
                        Message(Text001);
                        exit;
                    end;
                end;
            }
        }
    }

    var
        FirstField: Text;

}