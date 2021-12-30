page 51008 "Ret. RH Posted Purch. Invoices"
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Purchase Invoices', Comment = 'ESM="Histórico Recibo por honorario"';
    CardPageID = "Posted Purchase Invoice";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Correct,Invoice,Print,Print/Send,Navigate';
    QueryCategory = 'Posted Purchase Invoices';
    RefreshOnActivate = true;
    SourceTable = "Purch. Inv. Header";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending) where("Legal Document" = const('02'));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; Rec."No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Order No."; Rec."Order No.")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor No.', Comment = 'ESM="N° Proveedor"';
                }
                field("Order Address Code"; Rec."Order Address Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Buy-from Vendor Name"; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor', Comment = 'ESM="Proveedor"';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    ApplicationArea = Suite;
                }
                field("Retention RH Gross amount"; Rec."Retention RH Gross amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Retention RH Fourth Amount"; Rec."Retention RH Fourth Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field("Buy-from Post Code"; Rec."Buy-from Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Buy-from Country/Region Code"; Rec."Buy-from Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Buy-from Contact"; Rec."Buy-from Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Vendor No."; Rec."Pay-to Vendor No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Name"; Rec."Pay-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Post Code"; Rec."Pay-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Country/Region Code"; Rec."Pay-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Pay-to Contact"; Rec."Pay-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Name"; Rec."Ship-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Post Code"; Rec."Ship-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Country/Region Code"; Rec."Ship-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Contact"; Rec."Ship-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    ApplicationArea = Location;
                }
                field("No. Printed"; Rec."No. Printed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Discount %"; Rec."Payment Discount %")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Shipment Method Code"; Rec."Shipment Method Code")
                {
                    ApplicationArea = Suite;
                    Visible = false;
                }
                field("Remaining Amount"; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Closed; Rec.Closed)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Cancelled; Rec.Cancelled)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT IsCancel;
                    Style = Unfavorable;
                    StyleExpr = IsCancel;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowCorrectiveCreditMemo;
                    end;
                }
                field(Corrective; Rec.Corrective)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT IsCorrective;
                    Style = Unfavorable;
                    StyleExpr = IsCorrective;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowCancelledCreditMemo;
                    end;
                }
            }
        }
        area(factboxes)
        {
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Basic, Suite;
                ShowFilter = false;
                Visible = NOT IsOfficeAddin;
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
            group("&Invoice")
            {
                Caption = '&Invoice', Comment = 'ESM="Factura"';
                Image = Invoice;
                action(Statistics)
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics', Comment = 'ESM="Estadistica"';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    RunObject = Page "Purchase Invoice Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments', Comment = 'ESM="Comentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category5;
                    RunObject = Page "Purch. Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Invoice"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions', Comment = 'ESM="Dimensiones"';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incoming Document', Comment = 'ESM="Documentos de entrada"';
                    Image = Document;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard(Rec."No.", Rec."Posting Date");
                    end;
                }
            }
        }
        area(processing)
        {
            action("&Print")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Print', Comment = 'ESMP="Imprimir"';
                Ellipsis = true;
                Image = Print;
                Promoted = true;
                PromotedCategory = Category7;
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                var
                    PurchInvHeader: Record "Purch. Inv. Header";
                begin
                    CurrPage.SetSelectionFilter(PurchInvHeader);
                    PurchInvHeader.PrintRecords(true);
                end;
            }
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate', Comment = 'ESM="Navegar"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category5;
                Scope = Repeater;
                Visible = NOT IsOfficeAddin;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
            group(RelatedInformationNavigation)
            {
                Caption = 'Navigation', Comment = 'ESM="Navegación"';
                Image = Invoice;
                action(Vendor)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendor', Comment = 'ESM="Proveedor"';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Category8;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                }
            }
            group(Correct)
            {
                Caption = 'Correct', Comment = 'ESM="Corregir"';
                action(CorrectInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correct', Comment = 'ESM="Corregir"';
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Correct PstdPurchInv (Yes/No)", Rec);
                    end;
                }
                action(CancelInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel', Comment = 'ESM="Cancelar"';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = Repeater;
                    Visible = false;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel PstdPurchInv (Yes/No)", Rec);
                    end;
                }
                action(CorrectLegalDocAction)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correct Ext.', Comment = 'ESM="Extornar"';
                    ToolTip = 'Reverse this posted invoice and automatically create a new invoice with the same information that you can correct before posting. This posted invoice will automatically be canceled.';
                    Image = Undo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Scope = "Repeater";
                    trigger OnAction()
                    var
                        NewDocumentNo: Code[20];
                    begin
                        NewDocumentNo := Rec."No.";
                        LDCorrectPstdDoc.PurchCorrectInvoice(Rec);
                        //Get(NewDocumentNo);
                        SelectLatestVersion();
                    end;
                }

                action(CreateCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Create Corrective Credit Memo', Comment = 'ESM="Crear nota de crédito corrección "';
                    Image = CreateCreditMemo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        PurchaseHeader: Record "Purchase Header";
                        CorrectPostedPurchInvoice: Codeunit "Correct Posted Purch. Invoice";
                    begin
                        if CorrectPostedPurchInvoice.CreateCreditMemoCopyDocument(Rec, PurchaseHeader) then
                            PAGE.Run(PAGE::"Purchase Credit Memo", PurchaseHeader);
                    end;
                }
                action(ShowCreditMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Canceled/Corrective Credit Memo', Comment = 'ESM="Mostrar nota de crédito cancelada/corregida"';
                    Image = CreditMemo;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Scope = Repeater;
                    Visible = IsCancelAndCorrect;

                    trigger OnAction()
                    begin
                        Rec.ShowCanceledOrCorrCrMemo;
                    end;
                }
            }
            action("Update Document")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Update Document', Comment = 'ESM="Actualizar documento"';
                Image = Edit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    PostedPurchInvoiceUpdate: Page "Posted Purch. Invoice - Update";
                begin
                    PostedPurchInvoiceUpdate.LookupMode := true;
                    //PostedPurchInvoiceUpdate.SetRec(Rec);
                    //PostedPurchInvoiceUpdate.RunModal;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        IsCancelAndCorrect := Rec.Cancelled OR Rec.Corrective;
        IsCancel := Rec.Cancelled;
        IsCorrective := Rec.Corrective;
    end;

    trigger OnOpenPage()
    var
        OfficeMgt: Codeunit "Office Management";
        HasFilters: Boolean;
    begin
        HasFilters := Rec.GetFilters <> '';
        Rec.SetSecurityFilterOnRespCenter;
        if HasFilters then
            if Rec.FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
    end;

    local procedure DoDrillDown()
    var
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        PurchInvHeader.Copy(Rec);
        PurchInvHeader.SetRange("No.");
        PAGE.Run(PAGE::"Posted Purchase Invoice", PurchInvHeader);
    end;

    var
        IsOfficeAddin: Boolean;
        IsCancel: Boolean;
        IsCorrective: Boolean;
        IsCancelAndCorrect: Boolean;
        LDCorrectPstdDoc: Codeunit "LD Correct Posted Documents";
}