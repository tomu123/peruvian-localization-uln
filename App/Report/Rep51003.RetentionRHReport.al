report 51003 "Retention RH Report"
{
    UsageCategory = Administration;
    ApplicationArea = All;
    Caption = 'Retention RH Report';
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/RetentionRHReport.rdl';

    dataset
    {
        dataitem(PurchInvHeader; "Purch. Inv. Header")
        {
            column(StartDate; StartDate)
            {
            }
            column(EndDate; EndDate)
            {
            }
            column(VATRegNo_CI; CompInf."VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(Name_CI; CompInf.Name)
            {
                IncludeCaption = true;
            }
            column(VendInvNo; "Vendor Invoice No.")
            {
                IncludeCaption = true;
            }
            column(Document_Date; "Document Date")
            {
                IncludeCaption = true;
            }
            column(PaymentDate; PaymentDate)
            {
            }
            column(VATRegType; "VAT Registration Type")
            {
                IncludeCaption = true;
            }
            column(SerieNo; SerieNo)
            {

            }
            column(NumberNo; NumberNo)
            {

            }
            column(IdentityNo; IdentityNo)
            {

            }
            column(VATRegNo; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(Pay_to_Name; "Pay-to Name")
            {
                IncludeCaption = true;
            }
            column(GrossAmt; "Retention RH Gross Amount")
            {
                IncludeCaption = true;
            }
            column(FourthAmt; "Retention RH Fourth Amount")
            {
                IncludeCaption = true;
            }
            column(NetAmount; NetAmount)
            {

            }

            trigger OnAfterGetRecord()
            var
                PurchInvHdr2: Record "Purch. Inv. Header";
                VendLedgerEntry: Record "Vendor Ledger Entry";
                CloseByEntryNo: Integer;
                Position: Integer;
            begin
                NetAmount := "Retention RH Fourth Amount" + "Retention RH Gross Amount";
                VendLedgerEntry.SetFilter("Document No.", PurchInvHeader."No.");
                VendLedgerEntry.SetFilter("Closed by Entry No.", '<>%1', 0);
                if VendLedgerEntry.FindFirst() then
                    CloseByEntryNo := VendLedgerEntry."Closed by Entry No.";

                if VendLedgerEntry.Get(CloseByEntryNo) then
                    PaymentDate := VendLedgerEntry."Posting Date";
                Position := StrPos("Vendor Invoice No.", '-');
                if Position > 0 then begin
                    SerieNo := CopyStr("Vendor Invoice No.", 1, Position - 1);
                    NumberNo := CopyStr("Vendor Invoice No.", Position + 1, 20)
                end;
                if StrLen("VAT Registration No.") = 11 then
                    IdentityNo := CopyStr("VAT Registration No.", 3, 8);
            end;

            trigger OnPreDataItem()
            begin
                CompInf.Get();
                PurchInvHeader.SetRange("Posting Date", StartDate, EndDate);
                PurchInvHeader.SetRange("Legal Document", '02');
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Parameter';
                    field(StartDate; StartDate)
                    {
                        ApplicationArea = All;
                    }
                    field(EndDate; EndDate)
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    var
        StartDate: Date;
        EndDate: Date;
        PaymentDate: Date;
        IdentityNo: Code[8];
        SerieNo: Code[20];
        NumberNo: Code[20];
        NetAmount: Decimal;
        CompInf: Record "Company Information";
}