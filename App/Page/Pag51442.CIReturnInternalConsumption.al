page 51442 "CI Return Int. Consumption"
{
    // ULN::RM.01  DSI.PE.20.03-01   2020.03.27  * Internal Consumption Process.

    Caption = 'Internal Consumption Return', Comment = 'ESM="Devolución del Consumo Interno"';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Release,Posting,Prepare,Invoice,Request Approval',
                                Comment = 'ESM = "Nuevo,Proceso,Informe,Aprobar,Lanzar,Registrar,Preparar,Factura,Solicitar aprobación"';
    RefreshOnActivate = true;
    SourceTable = "Sales Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General',
                            Comment = 'ESM = "General"';
                field("No."; "No.")
                {
                    Importance = Promoted;
                    Visible = DocNoVisible;

                    trigger OnAssistEdit();
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.UPDATE;
                    end;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    Caption = 'Sell-to Customer Name',
                                Comment = 'ESM = "Nombre"';
                    Editable = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    Importance = Promoted;
                }
                field("Document Date"; "Document Date")
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {

                    trigger OnValidate();
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {

                    trigger OnValidate();
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Internal Consumption"; "Internal Consumption")
                {
                    Editable = false;
                    Visible = false;
                }
                field("Posting Description"; "Posting Description")
                {
                    Caption = 'Posting Description',
                                Comment = 'ESM = "Glosa"';
                }
                field("External Document No."; "External Document No.")
                {
                    Caption = 'Document No.',
                                Comment = 'ESM = "Nº documento"';
                }
                field("Gen. Bus. Posting Group"; "Gen. Bus. Posting Group")
                {
                }
                group("N° Serie Registro")
                {
                    Caption = 'N° Serie Registro';
                    //The GridLayout property is only supported on controls of type Grid
                    //GridLayout = Rows;
                    grid(Control5)
                    {
                        GridLayout = Rows;
                        group(Control6)
                        {
                            //The GridLayout property is only supported on controls of type Grid
                            //GridLayout = Rows;
                            field("Posting No. Series"; "Posting No. Series")
                            {
                                ShowCaption = false;
                            }
                            field(SetLastSerieNoUsedToBe; gCUDSIUtilities.SetLastSerieNoUsedToBe(Rec))
                            {
                                ShowCaption = false;
                            }
                            field("Shipping No. Series"; "Shipping No. Series")
                            {
                                Visible = false;
                            }
                        }
                    }
                }
            }
            part(SalesLines; "CI Return Int. Cnsmpt. SubForm")
            {
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Invoice")
            {
                Caption = '&Invoice',
                            Comment = 'ESM = "&Factura"';
                Image = Invoice;
                action(CopyDocument)
                {
                    Caption = 'Copy Document',
                                Comment = 'ESM = "Copiar líneas"';
                    Ellipsis = true;
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction();
                    begin
                        CopySalesDoc.SetSalesHeader(Rec);
                        CopySalesDoc.RUNMODAL;
                        CLEAR(CopySalesDoc);
                    end;
                }
                action(Statistics)
                {
                    Caption = 'Statistics',
                                Comment = 'ESM = "Estadísticas"';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ShortCutKey = 'F7';

                    trigger OnAction();
                    begin
                        CalcInvDiscForHeader;
                        COMMIT;
                        PAGE.RUNMODAL(PAGE::"Sales Statistics", Rec);
                        SalesCalcDiscountByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    Caption = 'Dimensions',
                                Comment = 'ESM = "Dimensiones"';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category8;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction();
                    begin
                        ShowDocDim;
                        CurrPage.SAVERECORD;
                    end;
                }
                action(Customer)
                {
                    Caption = 'Customer',
                                Comment = 'ESM = "Cliente"';
                    Image = Customer;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    ShortCutKey = 'Shift+F7';
                }
                action(Approvals)
                {
                    Caption = 'Approvals',
                                Comment = 'ESM = "Aprobaciones"';
                    Image = Approvals;

                    trigger OnAction();
                    var
                        ApprovalEntries: Page "Approval Entries";
                    begin
                        ApprovalEntries.Setfilters(DATABASE::"Sales Header", "Document Type", "No.");
                        ApprovalEntries.RUN;
                    end;
                }
                action("Co&mments")
                {
                    Caption = 'Co&mments',
                                Comment = 'ESM = "C&omentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                separator(Separator34)
                {
                }
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval',
                            Comment = 'ESM = "Aprobación"';
                action(Approve)
                {
                    Caption = 'Approve',
                                Comment = 'ESM = "Aprobar"';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    Caption = 'Reject',
                                Comment = 'ESM = "Rechazar"';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    Caption = 'Delegate',
                                Comment = 'ESM = "Delegar"';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    Caption = 'Comments',
                                Comment = 'ESM = "Comentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Approval Comments";
                    RunPageLink = "Table ID" = CONST(36),
                                  "Document Type" = FIELD("Document Type"),
                                  "Document No." = FIELD("No.");
                    Visible = OpenApprovalEntriesExistForCurrUser;
                }
            }
            group(ActionGroup27)
            {
                Caption = 'Release',
                            Comment = 'ESM = "Lanzar"';
                Image = ReleaseDoc;
                action(Release)
                {
                    Caption = 'Re&lease',
                                Comment = 'ESM = "Lan&zar"';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    Caption = 'Re&open',
                                Comment = 'ESM = "&Volver a abrir"';
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

                    trigger OnAction();
                    var
                        ReleaseSalesDoc: Codeunit "Release Sales Document";
                    begin
                        ReleaseSalesDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("P&osting")
            {
                Caption = 'P&osting',
                            Comment = 'ESM = "&Registro"';
                Image = Post;
                action(Post2)
                {
                    Caption = 'P&ost',
                                Comment = 'ESM = "&Registrar"';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction();
                    begin
                        Post(CODEUNIT::"Sales-Post (Yes/No)");
                    end;
                }
                action(PostAndSend)
                {
                    Caption = 'Post and &Send',
                                Comment = 'ESM = "Registrar y &enviar"';
                    Ellipsis = true;
                    Image = PostSendTo;
                    Promoted = true;
                    PromotedCategory = Category6;
                    PromotedIsBig = true;

                    trigger OnAction();
                    begin
                        SendToPosting(CODEUNIT::"Sales-Post and Send");
                    end;
                }
                action("Post and &Print")
                {
                    Caption = 'Post and &Print',
                                Comment = 'ESM = "Registrar e &imprimir"';
                    Image = PostPrint;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category6;
                    //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction();
                    begin
                        Post(CODEUNIT::"Sales-Post + Print");
                    end;
                }
                action("Post and Email")
                {
                    Caption = 'Post and Email',
                                Comment = 'ESM = "Registrar y enviar por correo electrónico"';
                    Image = PostMail;

                    trigger OnAction();
                    var
                        SalesPostPrint: Codeunit "Sales-Post + Print";
                    begin
                        SalesPostPrint.PostAndEmail(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        SetControlAppearance;
    end;

    trigger OnDeleteRecord(): Boolean;
    begin
        CurrPage.SAVERECORD;
        exit(ConfirmDeletion);
    end;

    trigger OnInit();
    begin
        SetExtDocNoMandatoryCondition;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    var
        SLSetup: Record "Setup Localization";
    begin
        "Internal Consumption" := true;
        SLSetup.Get();
        SLSetup.TestField("Customer Int. Cons.");

        //if SLSetup."Serial No. Int. Cons." <> '' then
        //    VALIDATE("No.", NoSeriesMgt.GetNextNo(SLSetup."Serial No. Int. Cons.", WORKDATE, true));

        if ("Sell-to Customer No." = '') then
            VALIDATE("Sell-to Customer No.", SLSetup."Customer Int. Cons.");

        //if (SLSetup."SUNAT Document Consump Int" <> '') and ("Legal Document" = '') then
        //    VALIDATE("SUNAT Document", SLSetup."SUNAT Doc. Int. Cons. Return");

        //if (SLSetup."External Doc No. Cnsmp Int" <> '') and ("External Document No." = '') then
        //    VALIDATE("External Document No.", SLSetup."External Doc No. Cnsmp Int");

        //if (SLSetup."Motivo Contigencia Consump Int" <> '') and ("Motivo Contigencia" = '') then
        //    VALIDATE("Motivo Contigencia", SLSetup."Motivo Contigencia Consump Int");
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Responsibility Center" := UserMgt.GetSalesFilter;
        "Assigned User ID" := USERID;
        "Internal Consumption" := true;
    end;

    trigger OnOpenPage();
    begin
        if UserMgt.GetSalesFilter <> '' then begin
            FILTERGROUP(2);
            SETRANGE("Responsibility Center", UserMgt.GetSalesFilter);
            FILTERGROUP(0);
        end;

        SetDocNoVisible;
    end;

    var
        ChangeExchangeRate: Page "Change Exchange Rate";
        MoveNegSalesLines: Report "Move Negative Sales Lines";
        ReportPrint: Codeunit "Test Report-Print";
        UserMgt: Codeunit "User Setup Management";
        SalesCalcDiscountByType: Codeunit "Sales - Calc Discount By Type";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        ExternalDocNoMandatory: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        gCUDSIUtilities: Codeunit "Internal Consumption Utility";
        CopySalesDoc: Report "Copy Sales Document";
        NoSeriesMgt: Codeunit NoSeriesManagement;

    local procedure Post(PostingCodeunitID: Integer);
    begin
        SendToPosting(PostingCodeunitID);
        //if "Job Queue Status" = "Job Queue Status"::"Scheduled for Posting" then
        CurrPage.CLOSE;
        CurrPage.UPDATE(false);
    end;

    local procedure SelltoCustomerNoOnAfterValidat();
    begin
        if GETFILTER("Sell-to Customer No.") = xRec."Sell-to Customer No." then
            if "Sell-to Customer No." <> xRec."Sell-to Customer No." then
                SETRANGE("Sell-to Customer No.");
        CurrPage.UPDATE;
    end;

    local procedure SalespersonCodeOnAfterValidate();
    begin
        CurrPage.SalesLines.PAGE.UpdateForm(true);
    end;

    local procedure BilltoCustomerNoOnAfterValidat();
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension1CodeOnAfterV();
    begin
        CurrPage.UPDATE;
    end;

    local procedure ShortcutDimension2CodeOnAfterV();
    begin
        CurrPage.UPDATE;
    end;

    local procedure PricesIncludingVATOnAfterValid();
    begin
        CurrPage.UPDATE;
    end;

    local procedure SetDocNoVisible();
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.SalesDocumentNoIsVisible(DocType::Invoice, "No.");
    end;

    local procedure SetExtDocNoMandatoryCondition();
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
    begin
        SalesReceivablesSetup.GET;
        ExternalDocNoMandatory := SalesReceivablesSetup."Ext. Doc. No. Mandatory"
    end;

    local procedure ShowPreview();
    var
        SalesPostYesNo: Codeunit "Sales-Post (Yes/No)";
    begin
        SalesPostYesNo.Preview(Rec);
    end;

    local procedure SetControlAppearance();
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
        SetExtDocNoMandatoryCondition;

        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
    end;
}

