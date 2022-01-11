pageextension 51184 "Employee Ledger Entries" extends "Employee Ledger Entries"
{
    layout
    {
        // Add changes to page layout here
        addbefore("Payment Method Code")
        {
            field("Employee Posting Group"; "Employee Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }

            field("Currency Code"; "Currency Code")
            {
                ApplicationArea = All;
                Editable = false;
            }

        }

        //Payment Schedule
        addafter("Entry No.")
        {
            field("PS Due Date"; "PS Due Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("PS Not Show Payment Schedule"; "PS Not Show Payment Schedule")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        addafter("Employee No.")
        {
            field(FullName; fnFullName("Employee No."))
            {
                ApplicationArea = All;
                Caption = 'Employee Name', Comment = 'ESM="Nombre Empleado"';
                Editable = false;
            }
        }

    }

    actions
    {
        // Add changes to page actions here
    }

    trigger OnAfterGetCurrRecord()
    begin
        CalcFields("PS Not Show Payment Schedule");
    end;

    trigger OnAfterGetRecord()
    begin
        CalcFields("PS Not Show Payment Schedule");
    end;

    local procedure fnFullName(pEmployeeNo: Code[20]): Text
    var
        lcEmployee: Record Employee;
    begin
        lcEmployee.Get(pEmployeeNo);
        exit(lcEmployee.FullName());
    end;

    var
        myInt: Integer;
}