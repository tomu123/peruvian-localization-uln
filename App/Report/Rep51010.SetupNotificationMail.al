report 51010 "Setup Notification Email"
{
    WordLayout = './App/Report/WordLayout/NotificationEmail.docx';
    Caption = 'Notification Email', Comment = 'ESM="Notificación Email"';
    DefaultLayout = Word;

    dataset
    {
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = SORTING(Number) WHERE(Number = CONST(1));
            column(Line1; Line1)
            {
            }
            column(Line2; Line2)
            {
            }
            column(Line3; Line3Lbl)
            {
            }
            column(Line4; Line4Lbl)
            {
            }
            column(Line5; Line5Lbl)
            {
            }
            column(Line6; Line6Lbl)
            {
            }
            column(Line7; Line7Lbl)
            {
            }
            column(Settings_UrlText; SettingsLbl)
            {
            }
            column(Settings_Url; SettingsURL)
            {
            }
            column(SettingsWin_UrlText; SettingsWinLbl)
            {
            }
            column(SettingsWin_Url; SettingsWinURL)
            {
            }
            dataitem("Notification Entry"; "Notification Entry")
            {
                column(UserName; RecipientUser."Full Name")
                {
                }
                column(DocumentType; DocumentType)
                {
                }
                column(DocumentNo; DocumentNo)
                {
                }
                column(Document_UrlText; DocumentName)
                {
                }
                column(Document_Url; DocumentURL)
                {
                }
                column(CustomLink_UrlText; CustomLinkLbl)
                {
                }
                column(CustomLink_Url; "Custom Link")
                {
                }
                column(ActionText; ActionText)
                {
                }
                column(Field1Label; Field1Label)
                {
                }
                column(Field1Value; Field1Value)
                {
                }
                column(Field2Label; Field2Label)
                {
                }
                column(Field2Value; Field2Value)
                {
                }
                column(Field3Label; Field3Label)
                {
                }
                column(Field3Value; Field3Value)
                {
                }
                column(Field4Label; Field4Label)
                {
                }
                column(Field4Value; Field4Value)
                {
                }
                column(Field5Label; Field5Label)
                {
                }
                column(Field5Value; Field5Value)
                {
                }
                column(Field6Label; Field6Label)
                {
                }
                column(Field6Value; Field6Value)
                {
                }
                column(Field7Label; Field7Label)
                {
                }
                column(Field7Value; Field7Value)
                {
                }
                dataitem(PurchLinesTemp; "Purchase Line")
                {
                    UseTemporary = true;

                    //Lines
                    column(No_; gCodeLine)
                    {
                    }
                    column(Description; Description + ' ' + "Description 2" + ' ' + gPurchaseComment)
                    {
                    }
                    column(Unit_of_Measure; "Unit of Measure")
                    {
                    }
                    column(Quantity; Quantity)
                    {
                    }
                    column(Unit_Price__LCY_; "Unit Cost (LCY)")
                    {
                    }
                    column(Line_Discount_Amount; "Line Discount Amount")
                    {
                    }
                    column(Amount; Amount)
                    {
                    }
                    column(Expected_Receipt_Date; Format("Expected Receipt Date", 0, '<Day,2>/<Month,2>/<Year4>'))
                    {
                    }
                    column(Purchase_Standar_Code; "Purchase Standard Code")
                    {
                    }
                    trigger OnAfterGetRecord()
                    begin
                        if StrLen("Purchase Standard Code") > 0 then begin
                            gCodeLine := "Purchase Standard Code";
                        end else begin
                            gCodeLine := "No.";
                        end;

                        gPurchaseComment := '';
                        gRecPurchaseComment.Reset();
                        gRecPurchaseComment.SetRange("Setup Type Purch. Comment Line", PurchLinesTemp."Document Type");
                        gRecPurchaseComment.SetRange("No.", "Document No.");
                        gRecPurchaseComment.SetRange("Document Line No.", "Line No.");
                        if gRecPurchaseComment.FindSet then begin
                            repeat
                                gPurchaseComment += gRecPurchaseComment.Comment + ' ';
                            until gRecPurchaseComment.Next() = 0;
                        end;
                    end;
                    //
                }
                //Approval Entry
                dataitem(ApprovalEntryTemp; "Approval Entry")
                {
                    UseTemporary = true;

                    column(Sender_ID; "Sender ID")
                    {

                    }
                    column(Approver_ID; "Approver ID")
                    {

                    }
                    column(Status; Status)
                    {

                    }
                    column(Date_Time_Sent_for_Approval; "Date-Time Sent for Approval")
                    {

                    }
                    column(Last_Date_Time_Modified; "Last Date-Time Modified")
                    {

                    }
                    column(Sequence_No_; "Sequence No.")
                    {

                    }
                }
                //
                column(DetailsLabel; DetailsLabel)
                {
                }
                column(DetailsValue; DetailsValue)
                {
                }

                trigger OnAfterGetRecord()
                var
                    RecRef: RecordRef;
                begin
                    FindRecipientUser();
                    CreateSettingsLink();
                    DataTypeManagement.GetRecordRef("Triggered By Record", RecRef);
                    SetDocumentTypeAndNumber(RecRef);
                    SetActionText();
                    SetReportFieldPlaceholders(RecRef);
                    SetReportLinePlaceholders();
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        CompanyInformation.Get;
    end;

    var
        CompanyInformation: Record "Company Information";
        PurchLine: Record "Purchase Line";
        RecipientUser: Record User;
        PageManagement: Codeunit "Page Management";
        DataTypeManagement: Codeunit "Data Type Management";
        NotificationManagement: Codeunit "Notification Management";
        SettingsURL: Text;
        SettingsWinURL: Text;
        DocumentType: Text;
        DocumentNo: Text;
        DocumentName: Text;
        DocumentURL: Text;
        ActionText: Text;
        Field1Label: Text;
        Field1Value: Text;
        Field2Label: Text;
        Field2Value: Text;
        Field3Label: Text;
        Field3Value: Text;
        Field4Label: Text;
        Field4Value: Text;
        Field5Label: Text;
        Field5Value: Text;
        Field6Label: Text;
        Field6Value: Text;
        Field7Label: Text;
        Field7Value: Text;
        Field1LinePL: Text;
        Field2LinePL: Text;
        Field3LinePL: Text;
        Field4LinePL: Text;
        Field5LinePL: Text;
        Field6LinePL: Text;
        Field7LinePL: Text;
        Field8LinePL: Text;
        SettingsLbl: Label 'Notification Settings', Comment = 'ESM="Configuración de las notificaciones"';
        SettingsWinLbl: Label '(Windows Client)', Comment = 'ESM="Cliente windows"';
        CustomLinkLbl: Label '(Custom Link)', Comment = 'ESM="(Vínculo personalizado)"';

        Line1Lbl: Label 'Hello %1,', Comment = 'ESM="Hola %1"';
        Line2Lbl: Label 'You are registered to receive notifications related to %1.', comment = 'ESM="Está registrado para recibir notificaciones relacionadas con %1."';
        Line3Lbl: Label 'This is a message to notify you that:', Comment = 'ESM="Este es un mensaje para notificarle que:"';
        Line4Lbl: Label 'Notification messages are sent automatically and cannot be replied to.', Comment = 'ESM="Los mensajes de notificación se envían automáticamente y no se pueden responder."';
        Line5Lbl: Label 'But you can change when and how you receive notifications:', Comment = 'ESM="Pero puede cambiar cuándo y cómo recibe las notificaciones:"';
        Line6Lbl: Label 'Next, the detail of the ', Comment = 'ESM="A continuación, el detalle de la"';
        Line7Lbl: Label 'Following is the approval history:', Comment = 'ESM="A continuación se muestra el historial de aprobaciones:"';
        DetailsLabel: Text;
        DetailsValue: Text;
        Line1: Text;
        Line2: Text;
        DetailsLbl: Label 'Request to: ', Comment = 'ESM="Solicitar a:"';
        gRecPurchaseComment: Record "Purch. Comment Line";
        gPurchaseComment: Text;
        gPurchaseCommentHeader: Text;
        gCodeLine: Text;
    //DetailsLbl: Label 'Details';

    local procedure FindRecipientUser()
    begin
        RecipientUser.SetRange("User Name", "Notification Entry"."Recipient User ID");
        if not RecipientUser.FindFirst then
            RecipientUser.Init;
    end;

    local procedure CreateSettingsLink()
    begin
        if SettingsURL <> '' then
            exit;

        SettingsURL := GetUrl(CLIENTTYPE::Web, CompanyName, OBJECTTYPE::Page, Page::"Notification Setup");
    end;

    local procedure SetDocumentTypeAndNumber(SourceRecRef: RecordRef)
    var
        RecRef: RecordRef;
        IsHandled: Boolean;
        PurchaseHeader: Record "Purchase Header";
    begin
        GetTargetRecRef(SourceRecRef, RecRef);
        IsHandled := false;
        OnBeforeGetDocumentTypeAndNumber("Notification Entry", RecRef, DocumentType, DocumentNo, IsHandled);
        if not IsHandled then
            NotificationManagement.GetDocumentTypeAndNumber(RecRef, DocumentType, DocumentNo);
        DocumentName := DocumentType + ' ' + DocumentNo;
    end;

    local procedure SetActionText()
    begin
        ActionText := NotificationManagement.GetActionTextFor("Notification Entry");
    end;

    local procedure SetReportFieldPlaceholders(SourceRecRef: RecordRef)
    var
        Customer: Record Customer;
        Vendor: Record Vendor;
        Item: Record Item;
        IncomingDocument: Record "Incoming Document";
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        RecordDetails: Text;
        HasApprovalEntryAmount: Boolean;
    begin
        Clear(Field1Label);
        Clear(Field1Value);
        Clear(Field2Label);
        Clear(Field2Value);
        Clear(Field3Label);
        Clear(Field3Value);
        Clear(Field4Label);
        Clear(Field4Value);
        Clear(Field5Label);
        Clear(Field5Value);
        Clear(Field6Label);
        Clear(Field6Value);
        Clear(Field7Label);
        Clear(Field7Value);
        Clear(DetailsLabel);
        Clear(DetailsValue);
        Clear(Field1LinePL);
        Clear(Field2LinePL);
        Clear(Field3LinePL);
        Clear(Field4LinePL);
        Clear(Field5LinePL);
        Clear(Field6LinePL);
        Clear(Field7LinePL);
        Clear(Field8LinePL);

        DetailsLabel := DetailsLbl;
        //DetailsValue := "Notification Entry".FieldCaption("Created By") + ' ' + GetCreatedByText;
        DetailsValue := GetCreatedByText;

        if SourceRecRef.Number = DATABASE::"Approval Entry" then begin
            HasApprovalEntryAmount := true;
            SourceRecRef.SetTable(ApprovalEntry);
        end;

        GetTargetRecRef(SourceRecRef, RecRef);

        case RecRef.Number of
            DATABASE::"Incoming Document":
                begin
                    Field1Label := IncomingDocument.FieldCaption("Entry No.");
                    FieldRef := RecRef.Field(IncomingDocument.FieldNo("Entry No."));
                    Field1Value := Format(FieldRef.Value);
                    Field2Label := IncomingDocument.FieldCaption(Description);
                    FieldRef := RecRef.Field(IncomingDocument.FieldNo(Description));
                    Field2Value := Format(FieldRef.Value);
                end;
            DATABASE::"Sales Header",
          DATABASE::"Sales Invoice Header",
          DATABASE::"Sales Cr.Memo Header":
                GetSalesDocValues(Field1Label, Field1Value, Field2Label, Field2Value, RecRef, SourceRecRef);
            DATABASE::"Purchase Header",
          DATABASE::"Purch. Inv. Header",
          DATABASE::"Purch. Cr. Memo Hdr.":
                GetPurchaseDocValues(Field1Label, Field1Value, Field2Label, Field2Value, RecRef, SourceRecRef);
            DATABASE::"Gen. Journal Line":
                begin
                    RecRef.SetTable(GenJournalLine);
                    Field1Label := GenJournalLine.FieldCaption("Document No.");
                    Field1Value := Format(GenJournalLine."Document No.");
                    Field2Label := GenJournalLine.FieldCaption(Amount);
                    if GenJournalLine."Currency Code" <> '' then
                        Field2Value := GenJournalLine."Currency Code" + ' ';
                    if HasApprovalEntryAmount then
                        Field2Value += FormatAmount(ApprovalEntry.Amount)
                    else
                        Field2Value += FormatAmount(GenJournalLine.Amount)
                end;
            DATABASE::"Gen. Journal Batch":
                begin
                    Field1Label := GenJournalBatch.FieldCaption(Description);
                    FieldRef := RecRef.Field(GenJournalBatch.FieldNo(Description));
                    Field1Value := Format(FieldRef.Value);
                    Field2Label := GenJournalBatch.FieldCaption("Template Type");
                    FieldRef := RecRef.Field(GenJournalBatch.FieldNo("Template Type"));
                    Field2Value := Format(FieldRef.Value);
                end;
            DATABASE::Customer:
                begin
                    Field1Label := Customer.FieldCaption("No.");
                    FieldRef := RecRef.Field(Customer.FieldNo("No."));
                    Field1Value := Format(FieldRef.Value);
                    Field2Label := Customer.FieldCaption(Name);
                    FieldRef := RecRef.Field(Customer.FieldNo(Name));
                    Field2Value := Format(FieldRef.Value);
                end;
            DATABASE::Vendor:
                begin
                    Field1Label := Vendor.FieldCaption("No.");
                    FieldRef := RecRef.Field(Vendor.FieldNo("No."));
                    Field1Value := Format(FieldRef.Value);
                    Field2Label := Vendor.FieldCaption(Name);
                    FieldRef := RecRef.Field(Vendor.FieldNo(Name));
                    Field2Value := Format(FieldRef.Value);
                end;
            DATABASE::Item:
                begin
                    Field1Label := Item.FieldCaption("No.");
                    FieldRef := RecRef.Field(Item.FieldNo("No."));
                    Field1Value := Format(FieldRef.Value);
                    Field2Label := Item.FieldCaption(Description);
                    FieldRef := RecRef.Field(Item.FieldNo(Description));
                    Field2Value := Format(FieldRef.Value);
                end;
            else
                OnSetReportFieldPlaceholders(RecRef, Field1Label, Field1Value, Field2Label, Field2Value, Field3Label, Field3Value);
        end;

        case "Notification Entry".Type of
            "Notification Entry".Type::Approval:
                begin
                    SourceRecRef.SetTable(ApprovalEntry);
                    Field3Label := ApprovalEntry.FieldCaption("Due Date");
                    Field3Value := Format(ApprovalEntry."Due Date");
                    RecordDetails := ApprovalEntry.GetChangeRecordDetails;
                    if RecordDetails <> '' then
                        DetailsValue += RecordDetails;
                end;
            "Notification Entry".Type::Overdue:
                begin
                    Field3Label := OverdueApprovalEntry.FieldCaption("Due Date");
                    FieldRef := SourceRecRef.Field(OverdueApprovalEntry.FieldNo("Due Date"));
                    Field3Value := Format(FieldRef.Value);
                end;
        end;

        DocumentURL := PageManagement.GetWebUrl(RecRef, "Notification Entry"."Link Target Page");
    end;

    local procedure SetReportLinePlaceholders()
    begin
        Line1 := StrSubstNo(Line1Lbl, RecipientUser."Full Name");
        Line2 := StrSubstNo(Line2Lbl, CompanyInformation.Name);
    end;

    local procedure GetTargetRecRef(RecRef: RecordRef; var TargetRecRefOut: RecordRef)
    var
        ApprovalEntry: Record "Approval Entry";
        OverdueApprovalEntry: Record "Overdue Approval Entry";
    begin
        case "Notification Entry".Type of
            "Notification Entry".Type::"New Record":
                TargetRecRefOut := RecRef;
            "Notification Entry".Type::Approval:
                begin
                    RecRef.SetTable(ApprovalEntry);
                    TargetRecRefOut.Get(ApprovalEntry."Record ID to Approve");
                end;
            "Notification Entry".Type::Overdue:
                begin
                    RecRef.SetTable(OverdueApprovalEntry);
                    TargetRecRefOut.Get(OverdueApprovalEntry."Record ID to Approve");
                end;
        end;
    end;

    local procedure GetSalesDocValues(var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; RecRef: RecordRef; SourceRecRef: RecordRef)
    var
        SalesHeader: Record "Sales Header";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        PaymentTerms: Record "Payment Terms";
        Customer: Record Customer;
        AmountFieldRef: FieldRef;
        CurrencyCode: Code[10];
        CustomerNo: Code[20];
        PaymentText: Label 'Payment to', Comment = 'ESM="Pagar a"';
    begin
        case RecRef.Number of
            DATABASE::"Sales Header":
                begin
                    RecRef.SetTable(SalesHeader);
                    AmountFieldRef := RecRef.Field(SalesHeader.FieldNo(Amount));
                    CurrencyCode := SalesHeader."Currency Code";
                    CustomerNo := SalesHeader."Sell-to Customer No.";
                    if PaymentTerms.Get(SalesHeader."Payment Terms Code") then begin
                        Field4Label := PaymentText;
                        if PaymentTerms.Description <> '' then
                            Field4Value := PaymentTerms.Description
                        else
                            Field4Value := SalesHeader."Payment Terms Code";
                    end;
                end;
            DATABASE::"Sales Invoice Header":
                begin
                    RecRef.SetTable(SalesInvoiceHeader);
                    AmountFieldRef := RecRef.Field(SalesInvoiceHeader.FieldNo(Amount));
                    CurrencyCode := SalesInvoiceHeader."Currency Code";
                    CustomerNo := SalesInvoiceHeader."Sell-to Customer No.";
                end;
            DATABASE::"Sales Cr.Memo Header":
                begin
                    RecRef.SetTable(SalesCrMemoHeader);
                    AmountFieldRef := RecRef.Field(SalesCrMemoHeader.FieldNo(Amount));
                    CurrencyCode := SalesCrMemoHeader."Currency Code";
                    CustomerNo := SalesCrMemoHeader."Sell-to Customer No.";
                end;
        end;

        GetSalesPurchDocAmountValue(Field1Label, Field1Value, SourceRecRef, AmountFieldRef, CurrencyCode);

        Field2Label := Customer.TableCaption;
        if Customer.Get(CustomerNo) then
            Field2Value := Customer.Name + ' (#' + Format(Customer."No.") + ')';
    end;

    local procedure GetPurchaseDocValues(var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; RecRef: RecordRef; SourceRecRef: RecordRef)
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        ApprovalEntryNew: Record "Approval Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        Vendor: Record Vendor;
        AmountFieldRef: FieldRef;
        CurrencyCode: Code[10];
        VendorNo: Code[20];
        MethodPayment: Label 'Method of payment: ', Comment = 'ESM="Forma de pago: "';
        MethodTerms: Label 'Method of payment: ', Comment = 'ESM="Término de pago: "';
        CurrencyCodeTxt: Text;

    begin
        case RecRef.Number of
            DATABASE::"Purchase Header":
                begin
                    RecRef.SetTable(PurchaseHeader);
                    AmountFieldRef := RecRef.Field(PurchaseHeader.FieldNo(Amount));
                    case PurchaseHeader."Currency Code" of
                        '':
                            CurrencyCodeTxt := ' (Soles)';
                        'USD':
                            CurrencyCodeTxt := ' (Dólares)';
                        'EUR':
                            CurrencyCodeTxt := ' (Euros)'
                    end;

                    VendorNo := PurchaseHeader."Buy-from Vendor No.";
                    Field6Value := CurrencyCodeTxt;

                    if PaymentTerms.Get(PurchaseHeader."Payment Terms Code") then begin
                        Field4Label := MethodTerms;
                        if PaymentTerms.Description <> '' then
                            Field4Value := PaymentTerms.Description
                        else
                            Field4Value := PurchaseHeader."Payment Terms Code";
                    end;
                    if PaymentMethod.Get(PurchaseHeader."Payment Method Code") then begin
                        Field5Label := MethodPayment;
                        if PaymentMethod.Description <> '' then
                            Field5Value := PaymentMethod.Description
                        else
                            Field5Value := PurchaseHeader."Payment Method Code";
                    end;
                    Field7Label := PurchaseHeader.FieldCaption("Requested Receipt Date");
                    Field7Value := format(PurchaseHeader."Requested Receipt Date");

                    //////
                    PurchLinesTemp.Reset();
                    PurchLinesTemp.DeleteAll();
                    PurchaseLine.Reset;
                    PurchaseLine.SetRange("Document Type", PurchaseHeader."Document Type");
                    PurchaseLine.SetRange("Document No.", PurchaseHeader."No.");
                    if PurchaseLine.FindSet then begin
                        repeat
                        begin
                            PurchLinesTemp.Init();
                            PurchLinesTemp.TransferFields(PurchaseLine, true);
                            PurchLinesTemp.Insert();
                        end
                        until PurchaseLine.Next = 0;
                    end;
                    ////
                    ApprovalEntryTemp.Reset();
                    ApprovalEntryTemp.DeleteAll();

                    ApprovalEntryNew.Reset;
                    ApprovalEntryNew.SetCurrentKey("Sequence No.");

                    ApprovalEntryNew.SetRange("Table ID", Database::"Purchase Header");
                    ApprovalEntryNew.SetRange("Document Type", PurchaseHeader."Document Type");
                    ApprovalEntryNew.SetRange("Document No.", PurchaseHeader."No.");
                    ApprovalEntryNew.SetAscending("Sequence No.", true);
                    if ApprovalEntryNew.FindSet then begin
                        repeat
                            ApprovalEntryTemp.Init();
                            ApprovalEntryTemp.TransferFields(ApprovalEntryNew, true);
                            ApprovalEntryTemp.Insert();
                        until ApprovalEntryNew.Next = 0;
                    end;
                    //////
                end;
            DATABASE::"Purch. Inv. Header":
                begin
                    RecRef.SetTable(PurchInvHeader);
                    AmountFieldRef := RecRef.Field(PurchInvHeader.FieldNo(Amount));
                    CurrencyCode := PurchInvHeader."Currency Code";
                    VendorNo := PurchInvHeader."Buy-from Vendor No.";
                end;
            DATABASE::"Purch. Cr. Memo Hdr.":
                begin
                    RecRef.SetTable(PurchCrMemoHdr);
                    AmountFieldRef := RecRef.Field(PurchCrMemoHdr.FieldNo(Amount));
                    CurrencyCode := PurchCrMemoHdr."Currency Code";
                    VendorNo := PurchCrMemoHdr."Buy-from Vendor No.";
                end;
            DATABASE::"Purchase Line":
                begin

                end;
        end;

        GetSalesPurchDocAmountValue(Field1Label, Field1Value, SourceRecRef, AmountFieldRef, CurrencyCode);

        Field2Label := Vendor.TableCaption + ': ';
        if Vendor.Get(VendorNo) then
            Field2Value := Vendor.Name + ' (Ruc: ' + Format(Vendor."No.") + ')';
    end;

    local procedure GetSalesPurchDocAmountValue(var Field1Label: Text; var Field1Value: Text;
    SourceRecRef:
        RecordRef;
    AmountFieldRef:
        FieldRef;
    CurrencyCode:
        Code[10])
    var
        ApprovalEntry:
            Record "Approval Entry";
        Amount:
                Decimal;
    begin
        Field1Label := AmountFieldRef.Caption;
        if CurrencyCode <> '' then
            Field1Value := CurrencyCode + ' ';

        if SourceRecRef.Number = DATABASE::"Approval Entry" then begin
            SourceRecRef.SetTable(ApprovalEntry);
            Field1Value += FormatAmount(ApprovalEntry.Amount);
        end else begin
            AmountFieldRef.CalcField;
            Amount := AmountFieldRef.Value;
            Field1Value += FormatAmount(Amount);
        end;
    end;

    local procedure FormatAmount(Amount: Decimal): Text
    begin
        exit(Format(Amount, 0, '<Precision,2><Standard Format,0>'));
    end;

    local procedure GetCreatedByText(): Text
    begin
        if "Notification Entry"."Sender User ID" <> '' then
            exit(GetUserFullName("Notification Entry"."Sender User ID"));
        exit(GetUserFullName("Notification Entry"."Created By"));
    end;

    local procedure GetUserFullName(NotificationUserID: Code[50]): Text[80]
    var
        User: Record User;
    begin
        User.SetRange("User Name", NotificationUserID);
        if User.FindFirst and (User."Full Name" <> '') then
            exit(User."Full Name");
        exit(NotificationUserID);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetDocumentTypeAndNumber(var NotificationEntry: Record "Notification Entry"; var RecRef: RecordRef; var DocumentType: Text; var DocumentNo: Text; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnSetReportFieldPlaceholders(RecRef: RecordRef; var Field1Label: Text; var Field1Value: Text; var Field2Label: Text; var Field2Value: Text; var Field3Label: Text; var Field3Value: Text)
    begin
    end;
}
