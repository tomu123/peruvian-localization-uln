pageextension 51223 "Chart of Accounts" extends "Chart of Accounts"
{
    layout
    {
        // Add changes to page layout here
        addafter(Name)
        {
            field("Search Name"; "Search Name")
            {
                Visible = true;
                ApplicationArea = All;

            }
        }

        addafter("Additional-Currency Balance")
        {
            field("Add.-Currency Debit Amount"; "Add.-Currency Debit Amount")
            {
                Visible = true;
                ApplicationArea = All;
            }
            field("Add.-Currency Credit Amount"; "Add.-Currency Credit Amount")
            {
                Visible = true;
                ApplicationArea = All;
            }
        }
        addbefore("Account Type")
        {
            field(Analitycs; Analitycs)
            {
                Visible = true;
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter("Trial Balance by Period")
        {
            action("Trial Balance by Period in Dolars")
            {
                ApplicationArea = All;
                Caption = 'Trial Balance by Period in Dollars', comment = 'ESM="Bal. Sumas y Saldos/Periodo Dolarizado"';
                Image = "Report";
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Trial Balance by Period Dollar";
                ToolTip = 'View the opening balance by general ledger account, the movements in the selected period of month, quarter, or year, and the resulting closing balance in dollars.';
            }

        }
    }

}