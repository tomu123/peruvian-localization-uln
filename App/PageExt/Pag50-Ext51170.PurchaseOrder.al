pageextension 51170 "ST Purchase Order" extends "Purchase Order"
{
    layout
    {
        // Add changes to page layout here
        modify("Vendor Shipment No.")
        {
            ShowMandatory = true;
        }
        modify("Document Date")
        {
            Visible = false;
        }
        modify("Vendor Invoice No.")
        {
            Visible = false;
        }
        modify("Purchaser Code")
        {
            Visible = false;
        }
        modify("No. of Archived Versions")
        {
            Visible = false;
        }
        modify("Vendor Order No.")
        {
            Visible = false;
        }
        modify("Responsibility Center")
        {
            Visible = false;
        }
        modify("Expected Receipt Date")
        {
            Visible = false;
        }
        modify("Tax Liable")
        {
            Visible = false;
        }
        modify("Tax Area Code")
        {
            Visible = false;
        }
        modify("Shipment Method Code")
        {
            Visible = false;
        }
        modify("Payment Reference")
        {
            Visible = false;
        }
        modify("Creditor No.")
        {
            Visible = false;
        }
        modify("On Hold")
        {
            Visible = false;
        }
        modify("Inbound Whse. Handling Time")
        {
            Visible = false;
        }
        modify("Lead Time Calculation")
        {
            Visible = false;
        }
        modify("Requested Receipt Date")
        {
            Visible = false;
        }
        modify("Promised Receipt Date")
        {
            Visible = false;
        }
        modify("Payment Terms Code")
        {
            ShowMandatory = true;
        }
        modify("Payment Method Code")
        {
            ShowMandatory = true;
        }
        movebefore("Posting Date"; "Order Date")
        movebefore("Buy-from Address"; "Order Address Code")
        moveafter(Status; "Shortcut Dimension 2 Code")
        modify("Shortcut Dimension 2 Code")
        {
            ApplicationArea = Suite;
            Importance = Additional;
            Visible = true;
            ShowMandatory = true;
        }
        moveafter(Status; "Shortcut Dimension 1 Code")
        modify("Shortcut Dimension 1 Code")
        {
            ApplicationArea = Suite;
            Importance = Additional;
            Visible = false;
        }
        addafter("Shortcut Dimension 2 Code")
        {
            field("Shortcut Dimension 5 Code"; "Shortcut Dimension 5 Code")
            {
                ApplicationArea = Suite;
                Importance = Additional;
                Visible = true;
            }
        }

        modify(Prepayment)
        {
            Visible = false;
        }
        modify("Foreign Trade")
        {
            Visible = false;
        }
        addafter(Prepayment)
        {
            // group(Detractions)
            // {
            //     Caption = 'Detractions', Comment = 'ESM="Detracciones"';
            //     field("Purch. Detraction"; "Purch. Detraction")
            //     {
            //         ApplicationArea = All;
            //         trigger OnValidate()
            //         var
            //             myInt: Integer;
            //         begin
            //             CurrPage.Update();
            //         end;
            //     }
            //     group(TypeOfService)
            //     {
            //         Caption = 'Type Of Service', Comment = 'ESM="Tipo de servicio"';
            //         grid(Mygrid)
            //         {
            //             field("Type of Service"; "Type of Service")
            //             {
            //                 ApplicationArea = All;
            //                 ShowCaption = false;
            //                 trigger OnValidate()
            //                 var
            //                     myInt: Integer;
            //                 begin
            //                     CurrPage.Update();
            //                 end;
            //             }
            //         }
            //     }
            //     group(TypeOfOperation)
            //     {
            //         Caption = 'Type Of Operation', Comment = 'ESM="Tipo de operación"';
            //         grid(Mygrid2)
            //         {
            //             field("Type of Operation"; "Type of Operation")
            //             {
            //                 ApplicationArea = All;
            //                 ShowCaption = false;
            //                 trigger OnValidate()
            //                 var
            //                     myInt: Integer;
            //                 begin
            //                     CurrPage.Update();
            //                 end;
            //             }
            //         }
            //     }
            //     field("Purch. % Detraction"; "Purch. % Detraction")
            //     {
            //         ApplicationArea = All;
            //         trigger OnValidate()
            //         var
            //             myInt: Integer;
            //         begin
            //             CurrPage.Update();
            //         end;
            //     }
            //     field("Purch. Amount Detraction"; "Purch. Amount Detraction")
            //     {
            //         ApplicationArea = All;
            //         trigger OnValidate()
            //         var
            //             myInt: Integer;
            //         begin
            //             CurrPage.Update();
            //         end;
            //     }
            //     field("Purch Amount Detraction (DL)"; "Purch Amount Detraction (DL)")
            //     {
            //         ApplicationArea = All;
            //         trigger OnValidate()
            //         var
            //             myInt: Integer;
            //         begin
            //             CurrPage.Update();
            //         end;
            //     }
            //     field("Purch. Detraction Operation"; "Purch. Detraction Operation")
            //     {
            //         ApplicationArea = All;
            //     }
            //     field("Purch Date Detraction"; "Purch Date Detraction")
            //     {
            //         ApplicationArea = All;
            //         trigger OnValidate()
            //         var
            //             myInt: Integer;
            //         begin
            //             CurrPage.Update();
            //         end;
            //     }
            // }

        }
        addfirst("Invoice Details")
        {
            field("Pay-to Vendor No."; "Pay-to Vendor No.")
            {
                ApplicationArea = All;

            }
        }
        //Legal Document Begin
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
                    Visible = false;
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
        //Legal Document Begin

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
            field(BuyFromUbigeoDescription; UbigeoMgt.ShowUbigeoDescription("Buy-from Country/Region Code", "Buy-from Post Code", "Buy-from City", "Buy-from County"))
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

        //Import
        addlast("Foreign Trade")
        {
            // control with underlying datasource
            field("Importation No."; "Importation No.")
            {
                ApplicationArea = All;

            }
            field(Nationalization; Nationalization)
            {
                ApplicationArea = All;
            }
        }
        modify("Area")
        {
            Caption = 'Port / ', Comment = 'ESM="Puerto"';
            //TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('11'));
        }
        modify("Entry Point")
        {
            Caption = 'INCOTERM', Comment = 'ESM="INCOTERM"';
        }
        addafter("Due Date")
        {
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = All;
                Editable = true;
                Caption = 'Grupo Contable Proveedor', Comment = 'ESM="Grupo Contable Proveedor"';
                trigger OnValidate()
                var
                    VendPostingGroup: Record "Vendor Posting Group";
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
        addafter("Vendor Invoice No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Electronic Bill"; "Electronic Bill")
            {
                Visible = false;
                ApplicationArea = All;
                Caption = 'Electronic Bill', Comment = 'ESM="Factura electrónica"';
                trigger OnValidate()
                var
                    VendorInvNo: Text;
                    ErrorVendInvNo: label 'The first character must start with E for electronic and 0 for non-electronic.', Comment = 'ESM="El primer carácter debe comenzar con E para electrónico y 0 para no electrónico."';
                begin
                    if "Vendor Invoice No." = '' then
                        exit;
                    VendorInvNo := "Vendor Invoice No.";
                    if "Electronic Bill" then begin
                        if not (VendorInvNo[1] in ['F', 'E', 'B']) then
                            Error(ErrorVendInvNo);
                    end else
                        if VendorInvNo[1] <> '0' then
                            Error(ErrorVendInvNo);

                end;
            }
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
                Caption = 'Glosa Principal', Comment = 'ESM="Glosa Principal"';
                Importance = Promoted;
                NotBlank = true;
                ShowMandatory = true;
            }
            field("Posting Description2"; "Posting Description")
            {
                caption = 'Posting Text', Comment = 'ESM="Texto de registro"';
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
        addafter("Electronic Bill")
        {
            field("Excede Presupuesto contable"; "Excede Presupuesto contable")
            {
                ApplicationArea = All;
                Importance = Additional;
                Editable = false;
                Visible = true;
            }
        }
        addlast("Invoice Details")
        {
            field("Payment Bank Account No."; "Payment Bank Account No.")
            {
                ApplicationArea = All;
                ToolTip = 'The source of this field is based on a financing contract.', Comment = 'ESM="El origen de este campo es en base a un contrato de financiamiento."';
                Editable = false;
                Visible = false;
            }
        }
        modify("Buy-from Vendor Name")
        {
            trigger OnAfterValidate()
            begin
                "Legal Document" := '09';
            end;
        }
    }

    actions
    {
        // Add changes to page actions here
    }

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

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Assigned User ID" = '' then
            "Assigned User ID" := UserId;
        "Legal Document" := '09';
    end;

    trigger OnOpenPage()
    begin
        "Legal Document" := '09';
    end;

}