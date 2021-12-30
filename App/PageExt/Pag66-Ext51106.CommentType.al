pageextension 51106 "PR CommentType" extends "Purch. Comment Sheet"
{
    layout
    {
        addafter(Comment)
        {
            // field("Document Type"; "Document Type")
            // {
            //     ApplicationArea = Comments;
            //     Caption = 'Tipo';
            // }
            field("Setup Type Purch. Comment Line"; "Setup Type Purch. Comment Line")
            {
                ApplicationArea = Comments;

            }

        }
    }

    actions
    {
        // Add changes to page actions here
    }

}