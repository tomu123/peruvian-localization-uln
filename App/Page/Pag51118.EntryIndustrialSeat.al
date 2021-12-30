page 51118 "Entry Industrial Seat"
{
    ApplicationArea = Jobs;
    Caption = 'Entry Industrial Seat', Comment = 'ESM="Mov. Costeo"';
    DataCaptionFields = "Job No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Entry';
    SourceTable = "Entry Industrial Seat";

    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the posting date for the entry.';
                }
                field("Process Date"; "Process Date")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("USERID Process"; "USERID Process")
                {
                    ApplicationArea = Jobs;
                }
                field("ST Entry No. Related Sales"; "ST Entry No. Related Sales")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }
                field("ST Related Document"; "ST Related Document")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                }



                field("Job No."; "Job No.")
                {
                    ApplicationArea = Jobs;
                    Editable = false;
                    ToolTip = 'Specifies the number of the job.';
                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the number of the related job task.';
                }

                field(Quantity; Quantity)
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the quantity that was posted on the entry.';
                }

                field("Total Cost (LCY)"; "Total Cost (LCY)")
                {
                    ApplicationArea = Jobs;
                    ToolTip = 'Specifies the total cost of the posted entry in local currency. If you update the job ledger costs for item ledger cost adjustments, this field will be adjusted to include the item cost adjustments.';
                }



                field("ST Processed Cost (LCY)"; "ST Processed Cost (LCY)")
                { }
                field("ST Percentage"; "ST Percentage")
                {

                }
                field("ST Percentage Process"; "ST Percentage Process")
                {

                }

            }
        }

    }



    var
        Navigate: Page Navigate;
        DimensionSetIDFilter: Page "Dimension Set ID Filter";
}
