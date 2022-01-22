page 51123 "Modify Detraction"
{
    PageType = Card;
    //ApplicationArea = All;
    //UsageCategory = Administration;
    //SourceTable = TableName;
    Caption = 'Modify Detraction', Comment = 'ESM="Modificar detracción"';

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(DocumentNo_; DocumentNo)
                {
                    ApplicationArea = All;
                    Caption = 'Document No.', Comment = 'ESM="N° Comprobante"';
                    Editable = false;
                }
                group(Detraction)
                {
                    Caption = 'Detraction', Comment = 'ESM="Detracción"';
                    field(DetractionOperationNo_; DetractionOperationNo)
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                        Caption = 'Detraction Operation No', Comment = 'ESM="Detracción Operación"';
                    }
                    field(DetractionEmisionDate_; DetractionEmisionDate)
                    {
                        ApplicationArea = All;
                        ShowMandatory = true;
                        Caption = 'Detraction Emision Date', Comment = 'ESM="Fecha Detracción"';
                    }
                }
            }
        }
    }
    procedure SetParameters(DocumentNo_: Code[20])
    begin
        DocumentNo := DocumentNo_;
        PurchInvHeader.Get(DocumentNo);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
    begin
        if not (CloseAction in [Action::OK, Action::LookupOK]) then
            exit else begin
            if not ((DetractionOperationNo <> '') and (DetractionEmisionDate <> 0D)) then
                Error('Todos los campos deben estar llenos.')
        end;
        PurchInvHeader."Purch. Detraction Operation" := DetractionOperationNo;
        PurchInvHeader."Purch Date Detraction" := DetractionEmisionDate;
        PurchInvHeader.Modify();
    end;

    var
        myInt: Integer;
        DetractionEmisionDate: Date;
        DetractionOperationNo: Code[20];
        PurchInvHeader: Record "Purch. Inv. Header";
        DocumentNo: Code[20];
}