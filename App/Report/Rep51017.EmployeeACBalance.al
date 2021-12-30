report 51017 "Employee AC Balance"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Employee AC Balance.rdl';

    Caption = 'Employee AC Balance', Comment = 'ESM="Saldo GC Empleado"';

    dataset
    {
        dataitem("Employee Ledger Entry"; "Employee Ledger Entry")
        {
            RequestFilterFields = "Employee No.", "Currency Code", "Employee Posting Group";
            column(EmployeeNo; "Employee Ledger Entry"."Employee No.")
            {
            }
            column(ExternalDocument; "Employee Ledger Entry"."External Document No.")
            {
            }
            column(DocumentDate; "Employee Ledger Entry"."Posting Date")
            {
            }
            column(DueDateEmployeeAGR; gDueDate)
            {
            }
            column(OpenEmployeeLedgerEntry; "Employee Ledger Entry".Open)
            {
            }
            column(EmployeePostingGroup; "Employee Ledger Entry"."Employee Posting Group")
            {
            }
            column(DocumentNo; "Employee Ledger Entry"."Document No.")
            {
            }
            column(RemainingAmtLCY; "Employee Ledger Entry"."Remaining Amt. (LCY)")
            {
            }
            column(RemainingAmount; "Employee Ledger Entry"."Remaining Amount")
            {
            }
            column(TipoDocumento; "Employee Ledger Entry"."Document Type")
            {
            }
            column(OriginalAmtLCY; "Employee Ledger Entry"."Original Amt. (LCY)")
            {
            }
            column(TipoDoc; '00')
            {
            }
            column(GrupoContableEmpleado; "Employee Ledger Entry"."Employee Posting Group")
            {
            }
            column(OriginalAmount; "Employee Ledger Entry"."Original Amount")
            {
            }
            column(FechaEmision; "Employee Ledger Entry"."Posting Date")
            {
            }
            column(CurrencyCode; "Employee Ledger Entry"."Currency Code")
            {
            }
            column(PostingDate; "Employee Ledger Entry"."Posting Date")
            {
            }
            column(DiasVencidos; DiasVencidos)
            {
            }
            column(Description; gDescription)
            {
            }
            dataitem(Employee; Employee)
            {
                DataItemLink = "No." = FIELD("Employee No.");
                column(VATRegistrationNo_Employee; Employee."VAT Registration No.")
                {
                }
                column(Name_Employee; Employee."Search Name")
                {
                }
                column(Logo_rep; Logo_rep.Picture)
                {
                }
                column(CtaEmpleado; gCtaEmployee)
                {
                }
                column(Razon_social; Logo_rep.Name)
                {
                }
                column(Direc_fis; Logo_rep.Address)
                {
                }
                column(ruc_1; Logo_rep."VAT Registration No.")
                {
                }
                column(Fecha_ini; StartDate)
                {
                }
                column(Fecha_fin; EndDate)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                //ER001-ULN240216

                if gRecGrEmployee.GET("Employee Posting Group") then;
                gCtaEmployee := gRecGrEmployee."Payables Account";

                //IF COPYSTR(ErNoCta,1,2) <> '16' THEN CurrReport.SKIP;

                CALCFIELDS("Remaining Amount", "Remaining Amt. (LCY)", "Original Amount", "Original Amt. (LCY)");

                if "Remaining Amount" = 0 then CurrReport.SKIP;

                //ER001-ULN240216

                //002
                gDescription := '';
                //  IF "Employee Ledger Entry". ."Text Registro"<>'' THEN
                //     gDescription := "Vendor Ledger Entry"."Text Registro"
                //  ELSE
                gDescription := "Employee Ledger Entry".Description;
                //002

                DiasVencidos := 0;
                gDueDate := 0D;
                OnAfterGetRecordEmployeeLedgerEntry("Entry No.", gDueDate, EndDate, DiasVencidos);
                /*if EAPExpAdvToPayEntry.GET("Entry No.") then begin
                    gDueDate := EAPExpAdvToPayEntry."Due Date";
                    if (EndDate > gDueDate) then
                        DiasVencidos := EndDate - gDueDate;
                end;*/
                //EAPExpAdvToPayEntry: Record "EAP Expense Adv. to Pay Entry";
            end;

            trigger OnPreDataItem();
            begin
                Logo_rep.GET;
                Logo_rep.CALCFIELDS(Picture);

                SETFILTER("Employee Ledger Entry"."Date Filter", '%1..%2', 0D, EndDate)
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(StartDate; StartDate)
                {
                    ApplicationArea = All;
                    Caption = 'Start Date', Comment = 'ESM="Fecha Inicio"';
                }
                field(EndDate; EndDate)
                {
                    ApplicationArea = All;
                    Caption = 'End Date', Comment = 'ESM="Fecha Fin"';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        gRecGrEmployee: Record "Employee Posting Group";
        Logo_rep: Record "Company Information";
        //EAPExpAdvToPayEntry: Record "EAP Expense Adv. to Pay Entry";
        gCtaEmployee: Code[20];
        StartDate: Date;
        EndDate: Date;
        gDescription: Text[250];
        DiasVencidos: Integer;
        gDueDate: Date;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecordEmployeeLedgerEntry(EmployeeEntryNo: Integer; var DueDate: Date; var EndDate: Date; var DiasVencidos: Integer)
    begin
    end;
}

