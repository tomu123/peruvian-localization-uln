page 51022 "PR Purchase Request List"
{
    AdditionalSearchTerms = 'rfq,request for quote,purchase requisition';
    ApplicationArea = Suite;
    Caption = 'Purchase Request', Comment = 'ESM="Solicitud de compra"';

    CardPageID = "PR Purchase Request";
    DataCaptionFields = "Buy-from Vendor No.";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Request Approval,Print/Send,Quote', Comment = 'ESM="Nuevo,Proceso,Reporte,Solicitud aprobación,Enviar/Imprimir,Solicitud"';
    QueryCategory = 'Purchase Request';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = CONST(Quote), "PR Purchase Request" = filter(true));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = Suite;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = Suite;
                }
                field("Order Address Code"; "Order Address Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                }
                field("Vendor Authorization No."; "Vendor Authorization No.")
                {
                    ApplicationArea = Suite;
                }
                field("Buy-from Post Code"; "Buy-from Post Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Pay-to Vendor No."; "Pay-to Vendor No.")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Pay-to Name"; "Pay-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Post Code"; "Pay-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Pay-to Contact"; "Pay-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Ship-to Name"; "Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Post Code"; "Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Contact"; "Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    ApplicationArea = Suite;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Campaign No."; "Campaign No.")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Suite;
                ShowFilter = false;
                Visible = false;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No."),
                              "Date Filter" = FIELD("Date Filter");
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Quote")
            {
                Caption = '&Quote', Comment = 'ESM="Solicitud"';
                Image = Quote;
                action(Statistics)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statistics', Comment = 'Estadistica';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        CalcInvDiscForHeader;
                        Commit;
                        PAGE.RunModal(PAGE::"Purchase Statistics", Rec);
                    end;
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments', Comment = 'ESM="Comentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = FIELD("Document Type"),
                                  "No." = FIELD("No."),
                                  "Document Line No." = CONST(0);
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions', Comment = 'ESM="Dimensiones"';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category6;
                    ShortCutKey = 'Alt+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals', Comment = 'ESM="Aprobaciones"';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RecordId, DATABASE::"Purchase Header", DocumentType::Quote, "No.");
                    end;
                }
            }
        }
        area(processing)
        {
            action(MakeOrder)
            {
                ApplicationArea = Suite;
                Caption = 'Make &Order', Comment = 'ESM="Convertir a pedido"';
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    cuValidatePurchase: Codeunit "PR Purchase Validate";
                begin
                    cuValidatePurchase.fnValidateGenericPurchase(Rec);
                    if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                        CODEUNIT.Run(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                end;
            }
            group(Action12)
            {
                Caption = 'Print', Comment = 'ESM="Imprimir"';
                Image = Print;
                action(Print)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Print', Comment = 'ESM="Imprimir"';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
                        LinesInstructionMgt: Codeunit "Lines Instruction Mgt.";
                    begin
                        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
                            LinesInstructionMgt.PurchaseCheckAllLinesHaveQuantityAssigned(Rec);

                        DocPrint.PrintPurchHeader(Rec);
                    end;
                }
                action(Send)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send', Comment = 'ESM="Enviar"';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                    begin
                        PurchaseHeader := Rec;
                        CurrPage.SetSelectionFilter(PurchaseHeader);
                        PurchaseHeader.SendRecords;
                    end;
                }
            }
            group(Action3)
            {
                Caption = 'Release', Comment = 'ESM="Lanzar"';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease', Comment = 'ESM="Lanzar"';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open', Comment = 'ESM="Reabrir"';
                    Image = ReOpen;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval', Comment = 'ESM="Solicitar aprobación"';
                Image = "Action";
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request', Comment = 'ESM="Enviar solicitud de aprobación"';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        if ApprovalsMgmt.CheckPurchaseApprovalPossible(Rec) then
                            ApprovalsMgmt.OnSendPurchaseDocForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest', Comment = 'ESM="Cancelar solicitud de aprobación"';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnOpenPage()
    begin
        SetSecurityFilterOnRespCenter;

        CopyBuyFromVendorFilter;
    end;

    var
        DocPrint: Codeunit "Document-Print";
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForRecord: Boolean;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);

        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
    end;
}
