page 59499 "ULN Page Buffer XML"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "XML Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field(RecType; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Path; Rec.Path)
                {
                    ApplicationArea = All;
                }
                field("Value"; Rec."Value")
                {
                    ApplicationArea = All;
                }
                field(Depth; Rec.Depth)
                {
                    ApplicationArea = All;
                }
                field("Parent Entry No."; "Parent Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Data Type"; "Data Type")
                {
                    ApplicationArea = All;
                }
                field("Node Number"; "Node Number")
                {
                    ApplicationArea = All;
                }
                field(Namespace; Namespace)
                {
                    ApplicationArea = All;
                }
                field("Import ID"; "Import ID")
                {
                    ApplicationArea = All;
                }
                field("Value BLOB"; "Value BLOB")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }

    procedure SetTempRecord(var XmlBuffer: Record "XML Buffer" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();

        XmlBuffer.Reset();
        if XmlBuffer.FindFirst() then
            repeat
                Rec := XmlBuffer;
                Rec.Insert()
            until XmlBuffer.Next() = 0;

        Rec.Reset()
    end;
}
