pageextension 51202 "SL Employee List" extends "Employee List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
        addafter(PayEmployee)
        {
            action(BalanceACEmployee)
            {
                ApplicationArea = All;
                Caption = 'Employee AC Balance', Comment = 'ESM="Salgo GC Empleado"';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Employee AC Balance";
            }
            action(EmployeeBanks)
            {
                ApplicationArea = All;
                Caption = 'Banks', Comment = 'ESM="Bancos"';
                Image = BankContact;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "ST Employee Bank Account List";
                RunPageLink = "Employee No." = field("No.");
            }
        }
    }
    var
        myInt: Integer;
}