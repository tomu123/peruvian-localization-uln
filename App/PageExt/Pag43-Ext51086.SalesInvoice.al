pageextension 51086 "Detrac. Sales Invoice" extends "Sales Invoice"
{
    layout
    {
        // Add changes to page layout here
        addafter("Shipping and Billing")
        {
            group(Detraction)
            {
                Caption = 'Detraction', Comment = 'ESM="Detracción"';
                field("Sales Detraction"; "Sales Detraction")
                {
                    ApplicationArea = All;
                    //Caption = 'Detraction';
                }
                field("Operation Type Detrac"; "Operation Type Detrac")
                {
                    ApplicationArea = All;
                    //Caption = 'Operation Type';
                    Editable = "Sales Detraction";
                }
                field("Service Type Detrac"; "Service Type Detrac")
                {
                    ApplicationArea = All;
                    //Caption = 'Service Type';
                    Editable = "Sales Detraction";
                }
                field("Payment Method Code Detrac"; "Payment Method Code Detrac")
                {
                    ApplicationArea = All;
                    //Caption = 'Payment Method Detrac';
                    Editable = "Sales Detraction";
                }
                field("Sales % Detraction"; "Sales % Detraction")
                {
                    ApplicationArea = All;
                    //Caption = '% Detraction';
                    Editable = "Sales Detraction";
                }
                field("Sales Amt Detraction"; "Sales Amt Detraction")
                {
                    ApplicationArea = All;
                    //Caption = 'Amount Detraction';
                    Editable = false;
                }
                field("Sales Amt Detraction (LCY)"; "Sales Amt Detraction (LCY)")
                {
                    ApplicationArea = All;
                    //Caption = 'Amount Detraction (LCY)';
                    Editable = false;
                }
            }
        }

        addafter("External Document No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Shipping No. Series"; "Shipping No. Series")
            {
                ApplicationArea = All;
                Editable = true;
            }
            field("Customer Posting Group"; "Customer Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
                trigger OnValidate()
                var
                    CustPostingGroup: Record "Customer Posting Group";
                begin
                    if "Customer Posting Group" = '' then
                        exit;
                    CustPostingGroup.Get("Customer Posting Group");
                    Validate("Currency Code", CustPostingGroup."Currency Code");
                end;
            }
            field("Currency Code2"; "Currency Code")
            {
                ApplicationArea = Suite;
                Caption = 'Currency Code', Comment = 'ESM="Cód. Divisa"';
                Importance = Promoted;
                Editable = false;

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
                        DocumentTotals.SalesRedistributeInvoiceDiscountAmountsOnDocument(Rec);
                        CurrPage.Update(false);
                        //SaveInvoiceDiscountAmount;
                    end;
                    Clear(ChangeExchangeRate);
                end;

                trigger OnValidate()
                var
                    SalesCalcDiscByType: Codeunit "Sales - Calc Discount By Type";
                begin
                    CurrPage.SaveRecord;
                    SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                end;
            }
        }
        modify("Currency Code")
        {
            Visible = false;
            Editable = false;
        }

        //Legal Documents BEGIN
        addlast(General)
        {
            group(Localization)
            {
                Caption = 'Peruvian Localization', Comment = 'ESM="Localización peruana"';
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
                    Caption = 'Legal Property Type', Comment = 'ESM="Tipo de bien"';
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

        addafter("Foreign Trade")
        {

            group(NotaDebito)
            {
                Visible = true;
                Caption = 'Debit Note', Comment = 'Nota Débito';

                field("Applies-to Doc. Type"; "Applies-to Doc. Type")
                {
                    ApplicationArea = All;
                }
                field("Applies-to Doc. No."; "Applies-to Doc. No.")
                {
                    ApplicationArea = All;
                }
                field("Manual Document Ref."; "Manual Document Ref.")
                {
                    ApplicationArea = All;
                }
                field("Electronic Doc. Ref"; "Electronic Doc. Ref")
                {
                    ApplicationArea = All;
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
        }
        //Legal Document END


        //Ubigeo Begin *************************************************************************************************
        // Add changes to page layout here
        //PosCode = Departamento
        //City = Provincia
        //County = County

        //******************************* BEGIN Sell-to ***********************************
        addafter("Sell-to Address 2")
        {
            field(BuyFromCountryRegionCode; "Sell-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(BuyFromPostCode; "Sell-to Post Code")
            {
                ApplicationArea = All;
            }
            field(BuyFromCity2; "Sell-to City")
            {
                ApplicationArea = All;
            }
            field(BuyFromCounty; "Sell-to County")
            {
                ApplicationArea = All;
            }
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Sell-to Country/Region Code", "Sell-to Post Code", "Sell-to City", "Sell-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Sell-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Sell-to Post Code")
        {
            Visible = false;
        }
        modify("Sell-to City")
        {
            Visible = false;
        }
        modify("Sell-to County")
        {
            Visible = false;
        }
        //******************************* END Sell-to *************************************

        //******************************* BEGIN Ship-to ***********************************
        addafter("Ship-to Address 2")
        {
            field(ShipToCountryRegionCode; "Ship-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(ShipToPostCode; "Ship-to Post Code")
            {
                ApplicationArea = All;
            }
            field(ShipToCity2; "Ship-to City")
            {
                ApplicationArea = All;
            }
            field(ShipToCounty; "Ship-to County")
            {
                ApplicationArea = All;
            }
            field(ShipToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Ship-to Country/Region Code", "Ship-to Post Code", "Ship-to City", "Ship-to County"))
            {
                ApplicationArea = All;
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

        //******************************* BEGIN Bill-to *************************************
        addafter("Bill-to Address 2")
        {
            field(PayToCountryRegionCode; "Bill-to Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PayToPostCode; "Bill-to Post Code")
            {
                ApplicationArea = All;
            }
            field(PayToCity2; "Bill-to City")
            {
                ApplicationArea = All;
            }
            field(PayToCounty; "Bill-to County")
            {
                ApplicationArea = All;
            }
            field(PayToUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Bill-to Country/Region Code", "Bill-to Post Code", "Bill-to City", "Bill-to County"))
            {
                ApplicationArea = All;
            }
        }
        modify("Bill-to Country/Region Code")
        {
            Visible = false;
        }
        modify("Bill-to Post Code")
        {
            Visible = false;
        }
        modify("Bill-to City")
        {
            Visible = false;
        }
        modify("Bill-to County")
        {
            Visible = false;
        }
        //******************************* END Bill-to *************************************
        //Ubigeo End ***************************************************************************************************

        //Free title
        addafter("VAT Registration No.")
        {
            field("FT Free Title"; "FT Free Title")
            {
                ApplicationArea = All;
                Visible = FreeTitleEditable;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
        }

        modify("Payment Method Code")
        {
            Visible = true;
            Enabled = true;
        }
        modify("Document Date")
        {
            Editable = false;
        }
    }

    trigger OnOpenPage()
    begin
        LSetup.Get();
        FreeTitleEditable := LSetup."FT Free Title";

    end;

    trigger OnAfterGetRecord()
    begin
        fnGetCustomer;
    end;

    var
        LSetup: Record "Setup Localization";
        UbigeoMgt: Codeunit "Ubigeo Management";
        FreeTitleEditable: Boolean;

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

    procedure fnGetCustomer()
    var
        lclCustomer: Record Customer;
    begin
        if Rec."Sell-to Customer No." = '' then
            exit;

        if lclCustomer.get("Sell-to Customer No.") then
            "Sell-to E-Mail" := lclCustomer."E-Mail";
    end;
}