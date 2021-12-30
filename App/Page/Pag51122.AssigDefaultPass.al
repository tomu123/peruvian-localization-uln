page 51122 "ST Assigned Default Pass"
{
    ApplicationArea = All;
    UsageCategory = Administration;
    AutoSplitKey = true;
    Caption = 'Assigned Default Pass', Comment = 'ESM="Default Contraseña"';
    Editable = false;
    DelayedInsert = false;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Assigned Default Pass";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Type Table"; "Type Table")
                {
                    Visible = true;
                    ApplicationArea = All;
                }

                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }

                field(Password; Password)
                {
                    ApplicationArea = All;
                }

            }
        }
    }
}