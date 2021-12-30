page 51107 "CB Bank Acc. Recon. Line Obs"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Bank Acc. Reconciliation Observed', Comment = 'ESM="Lineas de conciliación observadas"';
    UsageCategory = Lists;
    Editable = false;
    SourceTable = "Bank Acc. Reconciliation Line";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Suministro No."; "Suministro No")
                {
                    ApplicationArea = All;
                    Caption = 'Suministro No.', Comment = 'ESM="Suministro No."';

                }
                field("Customer No."; GetCustData(1))
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.', Comment = 'ESM="Cliente No."';

                }
                field("Customer Nmae"; GetCustData(2))
                {
                    ApplicationArea = All;
                    Caption = 'Name', Comment = 'ESM="Nombre"';

                }
                field(RemainingAmt; GetCustData(4))
                {
                    ApplicationArea = All;
                    Caption = 'Remaining Amount', Comment = 'ESM="Importe Pendiente"';
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field("Statement Amount"; "Statement Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetRecordTemporary();
    end;

    var
        BankAccReconLineTemp: Record "Bank Acc. Reconciliation Line" temporary;
        SuministroNo: Code[20];

    local procedure SetRecordTemporary()
    begin
        Reset();
        DeleteAll();

        BankAccReconLineTemp.Reset();
        if BankAccReconLineTemp.FindFirst() then
            repeat
                Init();
                TransferFields(BankAccReconLineTemp, true);
                Insert();
            until BankAccReconLineTemp.Next() = 0;

        Reset();
    end;

    procedure SaveRecordTemporary(var pBankAccReconLineTemp: Record "Bank Acc. Reconciliation Line" temporary)
    begin
        BankAccReconLineTemp.Reset();
        BankAccReconLineTemp.DeleteAll();

        pBankAccReconLineTemp.Reset();
        if pBankAccReconLineTemp.FindFirst() then
            repeat
                BankAccReconLineTemp.Init();
                BankAccReconLineTemp.TransferFields(pBankAccReconLineTemp, true);
                BankAccReconLineTemp."Suministro No" := pBankAccReconLineTemp."Suministro No";
                BankAccReconLineTemp.Insert();
            until pBankAccReconLineTemp.Next() = 0;
    end;

    local procedure GetCustData(param: Integer): Text
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetAutoCalcFields("Remaining Amount");
        CustLedgEntry.SetRange("Document No.", "Document No.");
        if CustLedgEntry.FindFirst() then
            case param of
                1:
                    exit(CustLedgEntry."Customer No.");
                2:
                    exit(CustLedgEntry."Customer Name");
                3:
                    exit('----');
                4:
                    exit(format(CustLedgEntry."Remaining Amount"));
            end;
    end;
}