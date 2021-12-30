pageextension 51158 "ST Purchase Credit Memo" extends "Purchase Credit Memo"
{
    layout
    {
        // Add changes to page layout here
        addafter("Due Date")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Vendor Posting Group';
                trigger OnValidate()
                var
                    VendPostingGroup: Record "Vendor Posting Group";
                    Table38: Record 38;
                begin
                    if "Vendor Posting Group" = '' then
                        exit;
                    VendPostingGroup.Get("Vendor Posting Group");
                    Validate("Currency Code", VendPostingGroup."Currency Code");
                end;
            }
            field("Currency Code2"; "Currency Code")
            {
                ApplicationArea = Suite;
                Importance = Promoted;
                Editable = false;
                ToolTip = 'Specifies the currency code for amounts on the purchase lines.';

                trigger OnAssistEdit()
                var
                    ChangeExchangeRate: Page "Change Exchange Rate";
                    DocumentTotals: Codeunit "Document Totals";
                begin
                    Clear(ChangeExchangeRate);
                    if "Posting Date" <> 0D then
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", "Posting Date")
                    else
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WorkDate);
                    if ChangeExchangeRate.RunModal = ACTION::OK then begin
                        Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                        CurrPage.SaveRecord;
                        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmountsOnDocument(Rec);
                        CurrPage.Update(false);
                        //SaveInvoiceDiscountAmount;
                    end;
                    Clear(ChangeExchangeRate);
                end;

                trigger OnValidate()
                var
                    PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
                begin
                    CurrPage.SaveRecord;
                    PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                end;
            }
        }

        addbefore("Vendor Cr. Memo No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = All;
            }
            field("Electronic Bill"; "Electronic Bill")
            {
                ApplicationArea = All;
                Caption = 'Electronic Bill';
                trigger OnValidate()
                begin
                    Validate("Vendor Cr. Memo No.");
                end;
            }
        }
        addafter("Vendor Cr. Memo No.")
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
                Caption = 'Posting Text';
                Importance = Promoted;
                NotBlank = true;
            }
            field("Posting Description2"; "Posting Description")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies additional posting information for the document. After you post the document, the description can add detail to vendor and customer ledger entries.';
                Importance = Promoted;
                Visible = true;
            }
        }
        modify("Currency Code")
        {
            Visible = false;
            Editable = false;
        }
        modify("Posting Description")
        {
            Visible = false;
        }
        modify("Vendor Cr. Memo No.")
        {
            trigger OnAfterValidate()
            begin
                ValidateVendorCrMemoNo();
            end;
        }

        //Legal Document Begin
        addlast(General)
        {
            group(Localization)
            {
                Caption = 'Peruvian Localization';
                field("Legal Document"; "Legal Document")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Legal Status"; "Legal Status")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration Type"; "VAT Registration Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = Basic, Suite;
                }
                group(LegalPropertyType)
                {
                    Caption = 'Legal Property Type';
                    grid(LegalPropertyTypeGrid)
                    {
                        GridLayout = Columns;
                        group(GridGroupLPT1)
                        {
                            ShowCaption = false;
                            field("Legal Property Type"; "Legal Property Type")
                            {
                                ApplicationArea = All;
                                ShowCaption = false;
                                trigger OnValidate()
                                begin
                                    CurrPage.Update();
                                end;
                            }
                        }
                        group(GridGroupLPT2)
                        {
                            ShowCaption = false;
                            field("Legal Property Type Name"; ShowLegalPropertyName())
                            {
                                ApplicationArea = All;
                                ShowCaption = false;
                                Editable = false;
                            }
                        }
                    }
                }
            }

        }
        addlast(Application)
        {
            field("Manual Document Ref."; "Manual Document Ref.")
            {
                ApplicationArea = All;
            }
            field("Electronic Doc. Ref"; "Electronic Doc. Ref")
            {
                ApplicationArea = All;
                Visible = false;
            }
            field("Applies-to Doc. No. Ref."; "Applies-to Doc. No. Ref.")
            {
                ApplicationArea = All;
            }
            field("Legal Document Ref."; "Legal Document Ref.")
            {
                ApplicationArea = All;
                Editable = "Manual Document Ref.";
            }
            field("Applies-to Number Ref."; "Applies-to Number Ref.")
            {
                ApplicationArea = All;
                Editable = "Manual Document Ref.";
            }

            field("Applies-to Serie Ref."; "Applies-to Serie Ref.")
            {
                ApplicationArea = All;
                Editable = "Manual Document Ref.";
            }
            field("Applies-to Document Date Ref."; "Applies-to Document Date Ref.")
            {
                ApplicationArea = All;
                Editable = "Manual Document Ref.";
            }

        }
        modify("Assigned User ID")
        {
            Visible = true;
        }
        //Legal Document End

        //Ubigeo Begin **********************************************************************************************************
        // Add changes to page layout here
        //PosCode = Departamento
        //City = Provincia
        //County = County

        //******************************* BEGIN Buy-from ***********************************
        addafter("Buy-from Address 2")
        {
            field(BuyFromCountryRegionCode; "Buy-from Country/Region Code")
            {
                ApplicationArea = All;
                Editable = false;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(BuyFromPostCode; "Buy-from Post Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(BuyFromCity2; "Buy-from City")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(BuyFromCounty; "Buy-from County")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Pay-to Country/Region Code", "Pay-to Post Code", "Pay-to City", "Pay-to County"))
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Buy-from Country/Region Code")
        {
            Visible = false;
        }
        modify("Buy-from Post Code")
        {
            Visible = false;
        }
        modify("Buy-from City")
        {
            Visible = false;
        }
        modify("Buy-from County")
        {
            Visible = false;
        }
        //******************************* END Buy-from *************************************

        //******************************* BEGIN Ship-to ***********************************
        addafter("Ship-to Address 2")
        {
            field(ShipToCountryRegionCode; "Ship-to Country/Region Code")
            {
                ApplicationArea = All;
                Editable = false;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(ShipToPostCode; "Ship-to Post Code")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ShipToCity2; "Ship-to City")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ShipToCounty; "Ship-to County")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field(ShipToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Ship-to Country/Region Code", "Ship-to Post Code", "Ship-to City", "Ship-to County"))
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        modify("Ship-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Ship-to Post Code")
        {
            Visible = false;
        }
        modify("Ship-to City")
        {
            Visible = false;
        }
        modify("Ship-to County")
        {
            Visible = false;
        }
        //******************************* END Ship-to *************************************

        //******************************* BEGIN Pay-to *************************************
        addafter("Pay-to Address 2")
        {
            field(PayToCountryRegionCode; "Pay-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PayToPostCode; "Pay-to Post Code")
            {
                ApplicationArea = All;
            }
            field(PayToCity2; "Pay-to City")
            {
                ApplicationArea = All;
            }
            field(PayToCounty; "Pay-to County")
            {
                ApplicationArea = All;
            }
            field(PayToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Pay-to Country/Region Code", "Pay-to Post Code", "Pay-to City", "Pay-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Pay-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Pay-to Post Code")
        {
            Visible = false;
        }
        modify("Pay-to City")
        {
            Visible = false;
        }
        modify("Pay-to County")
        {
            Visible = false;
        }
        //******************************* END Pay-to *************************************
        //Ubigeo End **********************************************************************************************************
    }
    actions
    {
        // Add changes to page actions here
        modify(GetPostedDocumentLinesToReverse)
        {
            Enabled = false;
        }
        modify(ApplyEntries)
        {
            Enabled = false;
        }
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                ValidateVendorCrMemoNo();
            end;
        }
        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                ValidateVendorCrMemoNo();
            end;
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Validate("Legal Document", '07');
        if "Assigned User ID" = '' then
            "Assigned User ID" := UserId;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Validate("Legal Document", '07');
    end;

    var
        UbigeoMgt: Codeunit "Ubigeo Management";

    procedure ShowLegalPropertyName(): Text[250]
    var
        MyLegalDocument: Record "Legal Document";
    begin
        MyLegalDocument.Reset();
        MyLegalDocument.SetRange("Option Type", MyLegalDocument."Option Type"::"SUNAT Table");
        MyLegalDocument.SetRange("Type Code", '30');
        MyLegalDocument.SetRange("Legal No.", "Legal Property Type");
        if MyLegalDocument.Find('-') then
            exit(MyLegalDocument.Description);
        exit('');
    end;

    local procedure ValidateVendorCrMemoNo()
    var
        VendorInvNo: Text;
        ErrorVendInvNo: label 'The first character must start with E, F for electronic.', Comment = 'ESM="El primer caracter para la serie debe de ser E ó F solo para electrónicos."';
        ErrorVendInvNo2: label 'The first character must start with E, F for electronic.', Comment = 'ESM="Si la seríe de [N° Nóta Crédito proveedor] inicia con F ó E, debe de activar el check de [Factura Electrónica]."';
    begin
        if "Vendor Cr. Memo No." = '' then
            exit;
        VendorInvNo := "Vendor Cr. Memo No.";
        if "Electronic Bill" then begin
            if not (VendorInvNo[1] in ['F', 'E', 'B']) then
                Error(ErrorVendInvNo);
        end else
            if VendorInvNo[1] in ['E', 'F'] then
                Error(ErrorVendInvNo2);
    end;
}