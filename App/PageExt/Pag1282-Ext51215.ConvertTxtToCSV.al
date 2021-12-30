pageextension 51215 "Select Bank Convert Txt to CSV" extends "Payment Bank Account List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        // addlast(processing)
        // {
        //     group(ConvertTxtCSV)
        //     {
        //         Caption = 'Convert Txt To CSV', Comment = 'ESM="Convertir archivo Txt a CSV."';
        //         Image = Filed;
        //         action("Seleccionar archivo...")
        //         {
        //             trigger OnAction()
        //             var
        //                 BankAccount: Record "Bank Account";
        //             begin
        //                 BankCollection := '';
        //                 if BankAccount.Get("No.") then
        //                     BankCollection := format(BankAccount."Process Bank");

        //                 MgmtCollection.SetBankCollection(BankCollection);
        //             end;
        //         }
        //     }
        // }
    }
    var
        MgmtCollection: Codeunit "Mgmt Collection";
        BankCollection: Text;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        BankAccount: Record "Bank Account";
        SLSetup: Record "Setup Localization";
    begin
        if not (CloseAction IN [ACTION::OK, ACTION::LookupOK]) then
            exit;
        BankAccount.Get("No.");
        SLSetup.Get();
        SLSetup."Current Bank Selected" := Format(BankAccount."Process Bank");
        SLSetup."Curr. Bank Code Selected" := BankAccount."No.";
        SLSetup."Curr. Bank Statement No" := IncStr(BankAccount."Last Payment Statement No.");
        SLSetup."Curr. Bank Selected User Id." := UserId;
        SLSetup.Modify();
    end;

}