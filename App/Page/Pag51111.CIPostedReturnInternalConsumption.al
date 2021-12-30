page 51111 "Posted Return Int. Consump."
{
    ApplicationArea = Basic, Suite;
    Caption = 'Posted Credit Memos Int. Consump.', Comment = 'ESM="Hist. Devolución Consumo Interno"';
    CardPageID = "Posted Sales Credit Memo";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Credit Memo,Cancel,Navigate,Print/Send';
    QueryCategory = 'Posted Sales Credit Memos';
    SourceTable = "Sales Cr.Memo Header";
    SourceTableView = SORTING("Posting Date")
                      ORDER(Descending)
                      where("Internal Consumption" = filter(true));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer No."; "Sell-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Sell-to Customer Name"; "Sell-to Customer Name")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer Name';
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Suite;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field("Amount Including VAT"; "Amount Including VAT")
                {
                    ApplicationArea = Basic, Suite;

                    trigger OnDrillDown()
                    begin
                        DoDrillDown;
                    end;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Paid; Paid)
                {
                    ApplicationArea = Basic, Suite;
                }
                field(Cancelled; Cancelled)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT Cancelled;
                    Style = Unfavorable;
                    StyleExpr = Cancelled;

                    trigger OnDrillDown()
                    begin
                        ShowCorrectiveInvoice;
                    end;
                }
                field(Corrective; Corrective)
                {
                    ApplicationArea = Basic, Suite;
                    HideValue = NOT Corrective;
                    Style = Unfavorable;
                    StyleExpr = Corrective;

                    trigger OnDrillDown()
                    begin
                        ShowCancelledInvoice;
                    end;
                }
                field("Sell-to Post Code"; "Sell-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Country/Region Code"; "Sell-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Sell-to Contact"; "Sell-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Name"; "Bill-to Name")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Post Code"; "Bill-to Post Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Country/Region Code"; "Bill-to Country/Region Code")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Bill-to Contact"; "Bill-to Contact")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Ship-to Code"; "Ship-to Code")
                {
                    ApplicationArea = Basic, Suite;
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
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Salesperson Code"; "Salesperson Code")
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
                    Visible = false;
                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = Location;
                }
                field("No. Printed"; "No. Printed")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                    ApplicationArea = Basic, Suite;
                    Visible = false;
                }
                field("Document Exchange Status"; "Document Exchange Status")
                {
                    ApplicationArea = Basic, Suite;
                    StyleExpr = DocExchStatusStyle;
                    Visible = DocExchStatusVisible;

                    trigger OnDrillDown()
                    var
                        DocExchServDocStatus: Codeunit "Doc. Exch. Serv.- Doc. Status";
                    begin
                        DocExchServDocStatus.DocExchStatusDrillDown(Rec);
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            group("&Credit Memo")
            {
                Caption = '&Credit Memo';
                Image = CreditMemo;
                action(Card)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Card';
                    Image = EditLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F7';

                    trigger OnAction()
                    begin
                        PAGE.Run(PAGE::"Posted Sales Credit Memo", Rec)
                    end;
                }
                action(Statistics)
                {
                    ApplicationArea = Suite;
                    Caption = 'Statistics';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    RunObject = Page "Sales Credit Memo Statistics";
                    RunPageLink = "No." = FIELD("No.");
                    ShortCutKey = 'F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    RunObject = Page "Sales Comment Sheet";
                    RunPageLink = "Document Type" = CONST("Posted Credit Memo"),
                                  "No." = FIELD("No.");
                }
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Dimensions;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';

                    trigger OnAction()
                    begin
                        ShowDimensions;
                    end;
                }
                action(IncomingDoc)
                {
                    AccessByPermission = TableData "Incoming Document" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Incoming Document';
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Category4;

                    trigger OnAction()
                    var
                        IncomingDocument: Record "Incoming Document";
                    begin
                        IncomingDocument.ShowCard("No.", "Posting Date");
                    end;
                }
                action(Customer)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Customer';
                    Image = Customer;
                    Promoted = true;
                    PromotedCategory = Category6;
                    RunObject = Page "Customer Card";
                    RunPageLink = "No." = FIELD("Sell-to Customer No.");
                    Scope = Repeater;
                    ShortCutKey = 'Shift+F7';
                }
                action("&Navigate")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Navigate';
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    Visible = NOT IsOfficeAddin;

                    trigger OnAction()
                    begin
                        Navigate;
                    end;
                }
            }
            group(Cancel)
            {
                Caption = 'Cancel';
                action(CancelCrMemo)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel';
                    Image = Cancel;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    Visible = not Cancelled and Corrective;

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::"Cancel PstdSalesCrM (Yes/No)", Rec);
                    end;
                }
                action(ShowInvoice)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Show Canceled/Corrective Invoice';
                    Image = Invoice;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    Visible = Cancelled OR Corrective;

                    trigger OnAction()
                    begin
                        ShowCanceledOrCorrInvoice;
                    end;
                }
            }
            group(Send)
            {
                Caption = 'Send';
                action(SendCustom)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send';
                    Ellipsis = true;
                    Image = SendToMultiple;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        SalesCrMemoHeader.SendRecords;
                    end;
                }
                action("&Print")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '&Print';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category7;
                    Scope = Repeater;
                    Visible = NOT IsOfficeAddin;

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        OnBeforePrintRecords(SalesCrMemoHeader);
                        SalesCrMemoHeader.PrintRecords(true);
                    end;
                }
                action("Send by &Email")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send by &Email';
                    Image = Email;
                    Scope = Repeater;

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        SalesCrMemoHeader.EmailRecords(true);
                    end;
                }
                action(AttachAsPDF)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Attach as PDF';
                    Image = PrintAttachment;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    var
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                    begin
                        SalesCrMemoHeader := Rec;
                        CurrPage.SetSelectionFilter(SalesCrMemoHeader);
                        PrintToDocumentAttachment(SalesCrMemoHeader);
                    end;
                }
            }
            action(ActivityLog)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Activity Log';
                Image = Log;

                trigger OnAction()
                begin
                    ShowActivityLog;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        if DocExchStatusVisible then
            DocExchStatusStyle := GetDocExchStatusStyle;
    end;

    trigger OnOpenPage()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        OfficeMgt: Codeunit "Office Management";
        HasFilters: Boolean;
    begin
        HasFilters := GetFilters <> '';
        SetSecurityFilterOnRespCenter;
        if HasFilters then
            if FindFirst then;
        IsOfficeAddin := OfficeMgt.IsAvailable;
        SalesCrMemoHeader.CopyFilters(Rec);
        SalesCrMemoHeader.SetFilter("Document Exchange Status", '<>%1', "Document Exchange Status"::"Not Sent");
        DocExchStatusVisible := not SalesCrMemoHeader.IsEmpty;
    end;

    local procedure DoDrillDown()
    var
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
    begin
        SalesCrMemoHeader.Copy(Rec);
        SalesCrMemoHeader.SetRange("No.");
        PAGE.Run(PAGE::"Posted Sales Credit Memo", SalesCrMemoHeader);
    end;

    var
        DocExchStatusStyle: Text;
        DocExchStatusVisible: Boolean;
        IsOfficeAddin: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePrintRecords(var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;
}
