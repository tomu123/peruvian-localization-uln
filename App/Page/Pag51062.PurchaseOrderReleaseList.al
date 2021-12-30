page 51062 "PR Purchase Order Release List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PR Purch. Line Buffer";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Caption = 'Detalle de Pedidos Aprobados';
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(Status; Status)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                    // trigger OnLookup(Var DocNo: Text): Boolean
                    // var
                    // begin
                    //     ShowDocument("Document No.");
                    // end;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(Type; Type)
                {
                    ApplicationArea = Advanced;
                    Editable = false;
                    Visible = true;
                }
                field("No."; "No.")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;

                    trigger OnValidate()
                    var
                    begin
                        // ShowShortcutDimCode(ShortcutDimCode);
                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Suite;
                    BlankZero = true;
                    Editable = false;
                    Visible = true;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,4';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(4),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[4]);
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[5]);
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(6),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[6]);
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(7),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[7]);
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(8),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[8]);
                    end;
                }
                field("Unit Cost (LCY)"; "Unit Cost (LCY)")
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,3';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(3),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = true;
                    trigger OnValidate()
                    var
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
                }
                field("Dimension Name"; "Dimension Name")
                {
                    Caption = 'Dimensión Ppto.';
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }

                field(ShortcutDimCode2; ShortcutDimCode[2])
                {
                    ApplicationArea = Dimensions;
                    CaptionClass = '1,2,2';
                    TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                                  "Dimension Value Type" = CONST(Standard),
                                                                  Blocked = CONST(false));
                    Editable = false;
                    Visible = true;
                    trigger OnValidate()
                    var
                    begin
                        ValidateShortcutDimCode(2, ShortcutDimCode[2]);
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ShowDetailBudget)
            {
                ApplicationArea = All;
                Caption = 'Ver Documento';
                trigger OnAction()
                var
                begin
                    ShowDocument("Document No.");
                end;
            }

        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        ShowShortcutDimCode(ShortcutDimCode);
    end;

    var
        ShortcutDimCode: array[8] of Code[20];

    procedure SetRecordTemp(var PurchLineTemp: Record "PR Purch. Line Buffer" temporary)
    var
    begin
        Reset();
        DeleteAll();
        PurchLineTemp.Reset();
        if PurchLineTemp.FindFirst() then
            repeat
                Init();
                TransferFields(PurchLineTemp, true);
                Insert();
            until PurchLineTemp.Next = 0;
        reset;
    end;

    local procedure ShowDocument(DocNo: Code[20])
    var
        PagePurchaseOrder: Page "Purchase Order";
        PurchaseHeader: Record "Purchase Header";
    begin
        if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, DocNo) then begin
            PagePurchaseOrder.SetRecord(PurchaseHeader);
            PagePurchaseOrder.Run();
        end;
    end;
}