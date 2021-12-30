codeunit 51022 "PR Purchase Validate"
{
    trigger OnRun()
    begin
        DelegateAutomatic();
    end;

    var

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ReportManagement, 'OnAfterSubstituteReport', '', false, false)]
    local procedure SetOnAfterSubstituteReport(ReportId: Integer; RunMode: Option Normal,ParametersOnly,Execute,Print,SaveAs,RunModal; RequestPageXml: Text; RecordRef: RecordRef; var NewReportId: Integer)
    begin
        if ReportId = 1320 then
            NewReportId := 51010;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignHeaderValues', '', true, true)]
    local procedure OnAfterAssignHeaderValues(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        GLAcc: Record "G/L Account";
        Text001: label 'Account No.: %1, type %2, it is not allowed', Comment = 'ESM="N° Cuenta: %1, tipo %2, no está permitida."';

    begin
        if PurchLine."Document Type" = PurchLine."Document Type"::Order then begin
            if PurchLine.Type = PurchLine.Type::"G/L Account" then begin
                GLAcc.Reset;
                GLAcc.SetRange("No.", PurchLine."No.");
                GLAcc.SetRange("PR Generic Purchase", true);
                if GLAcc.FindSet() then begin
                    Message(Text001, GLAcc."No.", lowercase(GLAcc.FieldCaption("PR Generic Purchase")));
                    PurchLine."No." := '';
                    PurchLine.Modify();
                    Exit;
                end;
            end;
        end;
    end;

    procedure fnValidateGenericPurchase(var pRecPurchasHeader: Record "Purchase Header")
    var
        lclRecVendor: Record Vendor;
        lclRecPurchaseLine: Record "Purchase Line";
        lclRecGLAccount: Record "G/L Account";
        Text001: label 'Convert to purchase order with vendor and/or generic purchase line is not allowed.', Comment = 'ESM="No se permite convertir a pedido de compra con proveedor y/o línea de compra genérica."';
    //  ESM = 'No se permite convertir a pedido de compra con proveedor y/o línea de compra genérica.';
    begin
        //Begin Validate...
        //Vendor validate "Compra genérica"
        lclRecVendor.Reset();
        lclRecVendor.SetRange("No.", pRecPurchasHeader."Buy-from Vendor No.");
        lclRecVendor.SetRange("PR Generic Purchase", true);
        IF lclRecVendor.FindFirst() then begin
            Error(Text001);
        end;
        //Purchase line, validate "Compra genérica"
        lclRecPurchaseLine.Reset();
        lclRecPurchaseLine.SetRange("Document Type", lclRecPurchaseLine."Document Type"::Quote);
        lclRecPurchaseLine.SetRange("Document No.", pRecPurchasHeader."No.");
        lclRecPurchaseLine.SetRange(type, lclRecPurchaseLine.Type::"G/L Account");
        if lclRecPurchaseLine.FindSet() then begin
            repeat
                lclRecGLAccount.Reset();
                lclRecGLAccount.SetRange("No.", lclRecPurchaseLine."No.");
                lclRecGLAccount.SetRange("PR Generic Purchase", true);
                if lclRecGLAccount.FindFirst then begin
                    Error(Text001);
                end;
            until lclRecPurchaseLine.Next() = 0;
        end;
        pRecPurchasHeader."Legal Document" := '09';
        pRecPurchasHeader."Assigned User ID" := UserId;
        pRecPurchasHeader.Modify();
        //End Validate....
    end;

    local procedure DelegateAutomatic()
    var
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
    begin
        UserSetup.Reset();
        UserSetup.SetRange("PR Automatic Delegate Active", true);
        UserSetup.SetFilter(Substitute, '<>%1', '');
        if UserSetup.FindFirst() then
            repeat
                ApprovalEntry.Reset();
                ApprovalEntry.SetRange("Approver ID", UserSetup."User ID");
                if ApprovalEntry.FindSet(true, true) then
                    repeat
                        SubstituteUserIdForApprovalEntry(ApprovalEntry);
                    until ApprovalEntry.Next() = 0;
            until UserSetup.Next() = 0;
    end;

    local procedure SubstituteUserIdForApprovalEntry(var ApprovalEntry: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        ApprovalAdminUserSetup: Record "User Setup";
        ApproverUserIdNotInSetupErr: Label 'You must set up an approver for user ID %1 in the Approval User Setup window.', Comment = 'ESM="Debe configurar un aprobador para el ID de usuario %1 en la ventana Configuración de usuario de aprobación."';
        SubstituteNotFoundErr: Label 'There is no substitute, direct approver, or approval administrator for user ID %1 in the Approval User Setup window.', Comment = 'ESM="No hay ningún sustituto, aprobador directo o administrador de aprobación para el ID de usuario %1 en la ventana Configuración de usuario de aprobación."';
    begin
        if not UserSetup.Get(ApprovalEntry."Approver ID") then
            Error(ApproverUserIdNotInSetupErr, ApprovalEntry."Sender ID");

        if UserSetup.Substitute = '' then
            if UserSetup."Approver ID" = '' then begin
                ApprovalAdminUserSetup.SetRange("Approval Administrator", true);
                if ApprovalAdminUserSetup.FindFirst then
                    UserSetup.Get(ApprovalAdminUserSetup."User ID")
                else
                    Error(SubstituteNotFoundErr, UserSetup."User ID");
            end else
                UserSetup.Get(UserSetup."Approver ID")
        else
            UserSetup.Get(UserSetup.Substitute);

        ApprovalEntry."Approver ID" := UserSetup."User ID";
        ApprovalEntry.Modify(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeGetFullDocTypeTxt', '', false, false)]
    procedure SetOnBeforeGetFullDocTypeTxt(var PurchaseHeader: Record "Purchase Header"; var FullDocTypeTxt: Text; var IsHandled: Boolean)
    var
        FullDocTypeTxtLabel: Label 'Request purchase', Comment = 'ESM="Solicitud de compra"';
    begin
        if not PurchaseHeader."PR Purchase Request" then
            exit;
        FullDocTypeTxt := FullDocTypeTxtLabel;
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnBeforeConfirmPostCU91(PurchaseHeader: Record "Purchase Header")
    var
        DocumentAttachment: Record "Document Attachment";
    begin
        if PurchaseHeader."Document Type" <> PurchaseHeader."Document Type"::Order then
            exit;
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::"Purchase Header");
        DocumentAttachment.SetRange("No.", PurchaseHeader."No.");
        DocumentAttachment.SetRange("Document Type", DocumentAttachment."Document Type"::Order);
        if DocumentAttachment.IsEmpty then begin
            Message('Para poder dar recepción al documento, se solicita de forma obligatoria un documento adjunto');
            exit;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterCheckPurchaseApprovalPossible', '', false, false)]
    local procedure OnAfterCheckPurchaseApprovalPossible(var PurchaseHeader: Record "Purchase Header")
    begin
        SearchAndUpdate(PurchaseHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCancelPurchaseApprovalRequest', '', false, false)]
    procedure OnCancelPurchaseApprovalRequest(var PurchaseHeader: Record "Purchase Header")
    var
        PurchaseHeader2: Record "Purchase Header";
    begin
        if PurchaseHeader2.get(PurchaseHeader."Document Type"::Order, PurchaseHeader."No.") then begin
            PurchaseHeader2."Excede Presupuesto contable" := false;
            PurchaseHeader2.Modify;
        end;
    end;

    procedure SearchAndUpdate(var pPurchaseHeader: Record "Purchase Header")
    var
        ConsultBudget: Page "PR ConsultBudget";
        DimSetEntry: Record "Dimension Set Entry";
        DimValue: Record "Dimension Value";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLineAll: Record "Purchase Line";
        PurchaseLineBuffer: Record "PR Purch. Line Buffer" temporary;
        EntryNo: Integer;
        DimCodePPTO: Code[20];
        DimCECO: Code[20];
        StatusPO: Code[20];
        BudgetName: Text;
        Excede: Boolean;
    begin
        Excede := false;
        PurchaseLineBuffer.Reset();
        PurchaseLineBuffer.DeleteAll();

        PurchaseLineAll.Reset();
        PurchaseLineAll.SetRange("Document Type", PurchaseLineAll."Document Type"::Order);
        PurchaseLineAll.SetRange("Document No.", pPurchaseHeader."No.");
        if PurchaseLineAll.FindSet() then begin
            repeat
                if PurchaseHeader.get(PurchaseHeader."Document Type"::Order, PurchaseLineAll."Document No.") then
                    StatusPO := Format(PurchaseHeader.Status);
                DimCECO := PurchaseLineAll."Shortcut Dimension 2 Code";
                BudgetName := '';
                DimValue.SetRange("Dimension Code", 'PPTO');
                DimValue.SetRange("Dimension Value Type", DimValue."Dimension Value Type"::Standard);
                DimValue.SetRange(Blocked, false);
                if DimValue.FindSet() then
                    repeat
                        if DimSetEntry.Get(PurchaseLineAll."Dimension Set ID", DimValue."Dimension Code") then begin
                            EntryNo += 1;
                            DimCodePPTO := DimSetEntry."Dimension Value Code";
                            PurchaseLineBuffer.Reset();
                            PurchaseLineBuffer.SetRange(DimPPTO, DimCodePPTO);
                            PurchaseLineBuffer.SetRange("Line No.", PurchaseLineAll."Line No.");
                            if PurchaseLineBuffer.IsEmpty then begin
                                PurchaseLineBuffer.Init();
                                PurchaseLineBuffer.TransferFields(PurchaseLineAll, true);
                                PurchaseLineBuffer.EntryNo := EntryNo;
                                PurchaseLineBuffer.DimPPTO := DimCodePPTO;
                                PurchaseLineBuffer.DimCECO := DimCECO;
                                PurchaseLineBuffer."Dimension Name" := DimValue.Name;
                                PurchaseLineBuffer.Amount1 := SetAmountBudgedCode(DimCodePPTO, DimCECO);
                                PurchaseLineBuffer.Amount2 := SetAmountPurchaseOrders(DimCodePPTO, DimCECO, PurchaseLineAll."Document No.");
                                PurchaseLineBuffer.NamePPTO := BudgetName;
                                PurchaseLineBuffer."Net Budget Balance" := PurchaseLineBuffer.Amount1 - PurchaseLineBuffer.Amount2 - PurchaseLineBuffer.Amount;
                                PurchaseLineBuffer."Status within Budget" := PurchaseLineBuffer."Net Budget Balance" < 0;
                                PurchaseLineBuffer.Insert();
                            end;
                            if PurchaseLineBuffer."Net Budget Balance" < 0 then
                                Excede := true
                        end;
                    until DimValue.NEXT = 0;
            until PurchaseLineAll.NEXT = 0;
        end;

        // PurchaseLineBuffer.SetRange("Status within Budget", true);
        // Excede := PurchaseLineBuffer.Count > 0;
        pPurchaseHeader."Excede Presupuesto contable" := Excede;
        pPurchaseHeader.Modify();
    end;

    procedure SetAmountBudgedCode(Var DimPPTOs: Code[20]; var DimCECO: Code[20]) AmountBudgetPO: Decimal
    var
        GLBudgetName: Record "G/L Budget Name";
        GLBudgetEntry: Record "G/L Budget Entry";
    begin
        GLBudgetName.SetRange(Blocked, false);
        if GLBudgetName.FindFirst() then begin
            GLBudgetEntry.SetRange("Budget Name", GLBudgetName.Name);
            GLBudgetEntry.SetRange("Budget Dimension 1 Code", DimPPTOs);
            GLBudgetEntry.SetRange("Global Dimension 2 Code", DimCECO);
            GLBudgetEntry.CalcSums(Amount);
            AmountBudgetPO := GLBudgetEntry.Amount;
        end;
        exit(AmountBudgetPO);
    end;

    procedure SetAmountPurchaseOrders(Var DimPPTOs: Code[20]; var DimCECO: Code[20]; var DocNo: Code[20]) AmountPurchaseOrder: Decimal
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLineAll: Record "Purchase Line";
        DimSetEntry: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
    begin
        AmountPurchaseOrder := 0;
        PurchaseLineAll.SetRange("Document Type", PurchaseLineAll."Document Type"::Order);
        if PurchaseLineAll.FindSet() then begin
            repeat
                // if PurchaseLineAll."Document No." <> DocNo then begin
                PurchaseHeader.SetRange("No.", PurchaseLineAll."Document No.");
                PurchaseHeader.SetRange(Status, PurchaseHeader.Status::Released);
                if PurchaseHeader.FindFirst() then begin
                    DimSetEntry.SetRange("Dimension Code", 'PPTO');
                    DimSetEntry.SetRange("Dimension Set ID", PurchaseLineAll."Dimension Set ID");
                    DimSetEntry.SetRange("Dimension Value Code", DimPPTOs);
                    if DimSetEntry.FindFirst() then begin
                        AmountPurchaseOrder += PurchaseLineAll.Amount
                    end;
                end;
            // end;
            until PurchaseLineAll.NEXT = 0;
            exit(AmountPurchaseOrder);
        end;
    end;
    //Agregar el No de Orden de Compra en la primera línea, al momento de tomar lineas
    [EventSubscriber(ObjectType::Table, DataBase::"Purch. Rcpt. Line", 'OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine', '', false, false)]
    local procedure OnBeforeInsertInvLineFromRcptLineBeforeInsertTextLine(var PurchRcptLine: Record "Purch. Rcpt. Line"; var PurchLine: Record "Purchase Line"; var NextLineNo: Integer; var Handled: Boolean)
    begin
        PurchLine.Description += '- ' + PurchRcptLine."Order No.";
    end;

}