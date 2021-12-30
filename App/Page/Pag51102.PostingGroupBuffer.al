page 51102 "SL Posting Group Buffer"
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "SL Posting Group Buffer";
    SourceTableTemporary = true;
    Editable = false;
    Caption = 'Posting Group', Comment = 'ESM="Grupo Registro"';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Type Source"; "Type Source")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Amount dollar"; "Amount dollar")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    procedure SetPostingBufferEntries()
    var
        PaymentSchedule: Record "Payment Schedule";
        EntryNo: Integer;
    begin
        EntryNo := 1;
        Rec.Reset();
        Rec.DeleteAll();
        PaymentSchedule.Reset();
        if PaymentSchedule.FindFirst() then
            repeat
                Rec.Reset();
                Rec.SetRange("Type Source", PaymentSchedule."Type Source");
                Rec.SetRange("Posting Group", PaymentSchedule."Posting Group");
                if Rec.IsEmpty then begin
                    Rec.Init();
                    Rec."Entry No." := EntryNo;
                    Rec."Type Source" := PaymentSchedule."Type Source";
                    Rec."Posting Group" := PaymentSchedule."Posting Group";
                    Rec.Insert();
                    EntryNo += 1;
                end;
            until PaymentSchedule.Next() = 0;
        Rec.Reset();
    end;
}