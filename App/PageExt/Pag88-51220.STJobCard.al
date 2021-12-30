pageextension 51220 "ST Job Card" extends "Job Card"
{
    layout
    {
        // Add changes to page layout here


    }
    actions
    {
        addlast(processing)
        {
            group(Proceso)
            {

                Caption = 'processing', Comment = 'ESM="Proceso"';
                action("Asiento industrial")
                {

                    Image = IndustryGroups;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        lcRepIndustrialSeat: Report "Industrial Seat";
                        lcRecJobLedgerEntry: Record "Job Ledger Entry";
                    begin
                        lcRecJobLedgerEntry.Reset();
                        lcRecJobLedgerEntry.SetRange("Job No.", Rec."No.");
                        lcRecJobLedgerEntry.FindSet();
                        Report.Run(51029, true, false, lcRecJobLedgerEntry);
                    end;
                }
            }
        }
    }
    var
        FirstField: Text;
}