page 51005 "Detraction Services/Operation"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 51004;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Type Servicies/Operation"; Rec."Type Services/Operation")
                {
                    ApplicationArea = All;

                }
                field(Code; Rec.Code)
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }
                field("Detraction Percentage"; Rec."Detraction Percentage")
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }
                field("Detraction Amount"; Rec."Detraction Amount")
                {
                    ApplicationArea = All;
                    //FieldPropertyName = FieldPropertyValue;
                }
            }
        }
    }
}