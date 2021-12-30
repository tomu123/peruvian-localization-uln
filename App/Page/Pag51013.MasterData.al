page 51013 "Master Data"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Master Data";
    Caption = 'Master Data';

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Visible = DfltFieldVisible;
                }
                field("Type Table"; "Type Table")
                {
                    ApplicationArea = All;
                    Visible = DfltFieldVisible;
                }
                field(Code; Code)
                {
                    ApplicationArea = All;
                    Visible = DfltFieldVisible;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Visible = DfltFieldVisible;
                }
                field("Amount %"; "Amount %")
                {
                    ApplicationArea = All;
                    Visible = DfltFieldVisible;
                }
                field("Dimension Code"; "Dimension Code")
                {
                    ApplicationArea = All;
                    Visible = DimDfltFieldsVisible;
                }
                field("Dimension Value Code"; "Dimension Value Code")
                {
                    ApplicationArea = All;
                    Visible = DimDfltFieldsVisible;
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

    trigger OnOpenPage()
    begin
        if not DimDfltFieldsVisible then
            DfltFieldVisible := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetDefaultValuesNewInsert();
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SetDefaultValuesNewInsert();
    end;

    var
        TypeTable: Text[30];
        TypeTableRef: Text[30];
        NoRef: Code[20];
        DfltFieldVisible: Boolean;
        DimDfltFieldsVisible: Boolean;

    procedure SetDimensionDefault(pTypeTable: Text[30]; pTypeTableRef: Text[30]; pNoRef: Code[20])
    begin
        DimDfltFieldsVisible := true;
        DfltFieldVisible := false;
        TypeTable := pTypeTable;
        TypeTableRef := pTypeTableRef;
        NoRef := pNoRef;
    end;

    local procedure SetDefaultValuesNewInsert()
    begin
        if "Entry No." = 0 then
            "Entry No." := NextLineNo();
        if TypeTable <> '' then
            "Type Table" := TypeTable;
        if TypeTableRef <> '' then
            "Type Table ref" := TypeTableRef;
        if NoRef <> '' then
            "Code ref" := NoRef;
    end;

    procedure NextLineNo(): Integer
    var
        MasterData: Record "Master Data";
    begin
        MasterData.Reset();
        MasterData.SetCurrentKey("Entry No.");
        MasterData.SetAscending("Entry No.", true);
        if MasterData.FindLast() then
            exit(MasterData."Entry No." + 1);
        exit(1);
    end;
}