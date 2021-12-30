page 51105 "MasterData Lookup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Master Data";
    Editable = false;
    Caption = 'Seleccione Tipo registro';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Type Table"; "Type Table")
                {
                    ApplicationArea = All;
                    Visible = true;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Visible = true;
                }
            }
        }

    }

}
