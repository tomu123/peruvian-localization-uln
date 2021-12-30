pageextension 51221 "ST Job List" extends "Job List"
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
                    RunObject = Report "Industrial Seat";
                }
            }
        }
    }
    var
        FirstField: Text;
}