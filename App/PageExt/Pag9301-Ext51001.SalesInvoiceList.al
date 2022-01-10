pageextension 51001 "Legal Doc. Sales Invoice List" extends "Sales Invoice List"
{
    layout
    {
        // Add changes to page layout here
        addafter(Amount)
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = Basic, Suite;
            }

            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Setup Source Code to User"; "Setup Source Code to User")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
<<<<<<< HEAD
        modify(PostAndSend)
        {
            Visible = false;
            Enabled = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
            Enabled = false;
=======
        modify("Post &Batch")
        {
            Visible = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
>>>>>>> c60cf94c5a0ecfbd31e3031fc256189efba62bb3
        }
    }

    var
        myInt: Integer;

    trigger OnOpenPage()
    var
        myInt: Integer;
    begin
        FilterGroup(2);
        SetFilter("Internal Consumption", '%1', false);
        FilterGroup(0);
    end;
}