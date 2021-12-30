page 51061 "PR ConsultBudget"
{
    PageType = List;
    Editable = false;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "PR Purch. Line Buffer";
    SourceTableTemporary = true;
    Caption = 'Request Budget', Comment = 'ESM="Consultar Presupuesto"';
    // SourceTableView = WHERE("Document Type" = FILTER(Order));
    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Document No."; "Document No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Document No.', Comment = 'ESM="N° Documento"';
                    Editable = false;
                    Visible = true;
                }
                field("Line No."; "Line No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Line No.', Comment = 'ESM="N° Linea"';
                    Editable = false;
                    Visible = true;
                }
                field(Type; Type)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Type', Comment = 'ESM="Tipo"';
                    Editable = false;
                    Visible = true;
                }
                field("No."; "No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'No.', Comment = 'ESM="N°"';

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
                    Caption = 'Description', Comment = 'ESM="Descripción"';
                    Editable = false;
                    Visible = true;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                    Caption = 'Location Code', Comment = 'ESM="Cód. Almacén"';
                    Editable = false;
                    Visible = false;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = Suite;
                    Caption = 'Quantity', Comment = 'ESM="Cantidad"';
                    BlankZero = true;
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
                    Visible = false;
                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, ShortcutDimCode[3]);
                    end;
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
                        // ValidateShortcutDimCode(3, ShortcutDimCode[4]);
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
                        // ValidateShortcutDimCode(3, ShortcutDimCode[5]);
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
                        // ValidateShortcutDimCode(3, ShortcutDimCode[6]);
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
                    Caption = 'Cost Amount', Comment = 'ESM="Importe Costo"';
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Suite;
                    Caption = 'Amount', Comment = 'ESM="Importe"';

                    Editable = false;
                    Visible = true;
                }
                field(DimPPTO; DimPPTO)
                {
                    Caption = 'Cod. Dimens. Ppto.';
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(DimCECO; DimCECO)
                {
                    Caption = 'Cod. Dimens. CECO.';
                    ApplicationArea = Suite;
                    Editable = false;
                    Visible = true;
                }
                field(Amount1; Amount1)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field(Amount2; Amount2)
                {
                    Caption = 'Amount approval orders', Comment = 'ESM="Importe pedidos aprobados"';
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;
                }
                field("Net Budget Balance"; "Net Budget Balance")
                {
                    ApplicationArea = All;
                    ToolTip = 'Importe Presupuesto - Importe Pedido aprobados - Importe linea Pedido actual';
                    Editable = false;
                    StyleExpr = StyleExp;
                }
                field("Status within Budget"; "Status within Budget")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                Caption = 'Ver detalle del Ppto,';
                trigger OnAction()
                var
                    Budget: Page Budget;
                begin
                    Budget.SetBudgetName(NamePPTO);
                    Budget.Run;
                end;
            }
            action(ShowDetailPurchaseOrder)
            {
                ApplicationArea = All;
                Caption = 'Ver detalle de Pedido Aprobados';
                trigger OnAction()
                var
                begin
                    FillList(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    var
    begin
        ShowShortcutDimCode(ShortcutDimCode);
        if not "Status within Budget" then
            StyleExp := 'StrongAccent'
        else
            StyleExp := 'Unfavorable';
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if not "Status within Budget" then
            StyleExp := 'StrongAccent'
        else
            StyleExp := 'Unfavorable';
    end;

    var
        ShortcutDimCode: array[8] of Code[20];
        StyleExp: Text;

    procedure SetRecordTemp(var PurchLineTemp: Record "PR Purch. Line Buffer" temporary)
    var
        myInt: Integer;
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
    end;

    procedure FillList(VAR PurchaseLineAll: Record "PR Purch. Line Buffer" temporary)
    var
        PurchaseLineBuffer: Record "PR Purch. Line Buffer" temporary;
        PurchaseOrdrerStatusList: page "PR Purchase Order Release List";
    begin
        EntryNo := 0;
        PurchaseLineAll.Reset();
        if PurchaseLineAll.FindSet() then begin
            repeat
                InsertFromPPTO(PurchaseLineBuffer, PurchaseLineAll.DimPPTO, PurchaseLineAll."Document No.");
            until PurchaseLineAll.Next = 0;
            PurchaseOrdrerStatusList.SetRecordTemp(PurchaseLineBuffer);
            PurchaseOrdrerStatusList.Run();
        end;
    end;

    local procedure InsertFromPPTO(VAR pPurchaseLineBuffer: Record "PR Purch. Line Buffer" temporary; PPTOCode: Code[20]; DocNo: Code[20])
    var
        PurchaseLineAll: Record "Purchase Line";
        DimSetEntry: Record "Dimension Set Entry";
    begin
        PurchaseLineAll.SetRange("Document Type", PurchaseLineAll."Document Type"::Order);
        // PurchaseLineAll.SetFilter("Document No.", '<>%1', DocNo);
        if PurchaseLineAll.FindSet() then begin
            repeat
                if (ISRealease(PurchaseLineAll."Document No.")) then begin
                    DimSetEntry.Reset();
                    DimSetEntry.SetRange("Dimension Code", 'PPTO');
                    DimSetEntry.SetRange("Dimension Set ID", PurchaseLineAll."Dimension Set ID");
                    DimSetEntry.SetRange("Dimension Value Code", PPTOCode);
                    if DimSetEntry.FindFirst() then begin
                        DimSetEntry.CalcFields("Dimension Value Name");
                        EntryNo += 1;
                        pPurchaseLineBuffer.Init();
                        pPurchaseLineBuffer.TransferFields(PurchaseLineAll, true);
                        pPurchaseLineBuffer.EntryNo := EntryNo;
                        pPurchaseLineBuffer.DimPPTO := DimSetEntry."Dimension Value Code";
                        pPurchaseLineBuffer."Dimension Name" := DimSetEntry."Dimension Value Name";
                        pPurchaseLineBuffer.Status := 'Release';
                        pPurchaseLineBuffer.Insert();
                    end;
                end;
            until PurchaseLineAll.NEXT = 0;
        end;
    end;

    local procedure ISRealease(DocNO: Code[20]): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
    begin
        PurchaseHeader.SetRange("No.", DocNO);
        PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
        exit(PurchaseHeader.FindFirst());
    end;
}