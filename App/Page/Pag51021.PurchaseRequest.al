page 51021 "PR Purchase Request"
{
    Caption = 'Purchase Request', Comment = 'ESM="Solicitud de compra"';
    PageType = Document;
    PromotedActionCategories = 'New,Process,Report,Approve,Request Approval,Print/Send,Quote,Release,Navigate',
    Comment = 'ESM="Nuevo,Proceso,Reporte,Aprobación,Solicitud aprobación,Enviar/Imprimir,Solicitud,Lazar,Navegar"';
    RefreshOnActivate = true;
    SourceTable = "Purchase Header";
    SourceTableView = WHERE("Document Type" = FILTER(Quote));
    //, "PR Purchase Request" = filter(true));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General', Comment = 'ESM="General"';
                field("No."; "No.")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.',
                    Comment = 'ESM="Especifica el número de la entrada o registro involucrado, de acuerdo con la serie de números especificada."';
                    Visible = DocNoVisible;

                    trigger OnAssistEdit()
                    begin
                        if AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field("Buy-from Vendor No."; "Buy-from Vendor No.")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor No.', Comment = 'ESM="N° Proveedor"';
                    Importance = Additional;
                    NotBlank = true;
                    ToolTip = 'Specifies the number of the vendor who delivers the products.', Comment = 'ESM="Especifica el número del proveedor que entrega los productos."';
                    trigger OnValidate()
                    begin
                        OnAfterValidateBuyFromVendorNo(Rec, xRec);
                        CurrPage.Update;
                    end;
                }
                field("Buy-from Vendor Name"; "Buy-from Vendor Name")
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor Name', Comment = 'ESM="Nombre Proveedor"';
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the name of the vendor who delivers the products.', Comment = 'ESM="Especifica el nombre del proveedor que entrega los productos."';

                    trigger OnValidate()
                    var
                        page51: Page 51;
                    begin
                        OnAfterValidateBuyFromVendorNo(Rec, xRec);
                        CurrPage.Update;
                    end;
                }
                group("Buy-from")
                {
                    Caption = 'Buy-from', Comment = 'ESM="Dirección de compra"';
                    field("Buy-from Address"; "Buy-from Address")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address', Comment = 'ESM="Dirección"';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the address of the vendor who delivered the items.', Comment = 'ESM="Especifica la dirección del proveedor que entregó los artículos."';
                    }
                    field("Buy-from Address 2"; "Buy-from Address 2")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Address 2', Comment = 'ESM="Dirección 2"';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies an additional part of the address of the vendor who delivered the items.', Comment = 'ESM="Especifica una parte adicional de la dirección del proveedor que entregó los artículos."';
                    }
                    field("Buy-from Country/Region Code"; "Buy-from Country/Region Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Country/Region';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the country/region in the vendor''s address.';

                        trigger OnValidate()
                        begin
                            IsBuyFromCountyVisible := FormatAddress.UseCounty("Buy-from Country/Region Code");
                        end;
                    }
                    field("Buy-from Post Code"; "Buy-from Post Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Post Code', Comment = 'ESM="Cód. Departamento"';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the post code of the vendor who delivered the items.', Comment = 'ESM="Especifica el código departamento en la dirección del proveedor."';
                    }
                    field("Buy-from City"; "Buy-from City")
                    {
                        ApplicationArea = Suite;
                        Caption = 'City', Comment = 'ESM="Cód. Provincia"';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the city of the vendor who delivered the items.', Comment = 'ESM="Especifica el código provincia en la dirección del proveedor."';
                    }
                    field("Buy-from County"; "Buy-from County")
                    {
                        ApplicationArea = Suite;
                        Caption = 'County', Comment = 'ESM="Cód. Distrito"';
                        Importance = Additional;
                        QuickEntry = false;
                        ToolTip = 'Specifies the county in the vendor''s address.', Comment = 'ESM="Especifica el código distrito en la dirección del proveedor."';
                    }
                    field("Ubigeo"; UbigeoMgt.ShowUbigeoDescription("Buy-from Country/Region Code", "Buy-from Post Code", "Buy-from City", "Buy-from County"))
                    {
                        ApplicationArea = Suite;
                        Caption = 'Ubigeo';
                        Importance = Additional;
                        QuickEntry = false;
                    }
                    field("Buy-from Contact No."; "Buy-from Contact No.")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Contact No.', Comment = 'ESM="N° Contacto"';
                        Importance = Additional;
                        ToolTip = 'Specifies the number of contact person of the vendor who delivered the items.', Comment = 'ESM="Especifica el número de persona de contacto del proveedor que entregó los artículos."';
                    }
                }
                field("Buy-from Contact"; "Buy-from Contact")
                {
                    ApplicationArea = Suite;
                    Caption = 'Contact', Comment = 'ESM="Contacto"';
                    Editable = "Buy-from Vendor No." <> '';
                    ToolTip = 'Specifies the contact person at the vendor who delivered the items.', Comment = 'ESM="Especifica la persona de contacto del proveedor que entregó los artículos."';
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date when the related document was created.', Comment = 'ESM="Especifica la fecha en la que se creó el documento relacionado."';
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the related purchase invoice must be paid.', Comment = 'ESM="Especifica cuándo debe pagarse la factura de compra relacionada."';
                }
                field("Order Date"; "Order Date")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                    ToolTip = 'Specifies the date when the related order was created.', Comment = 'ESM="Especifica la fecha en la que se creó el pedido relacionado."';
                }
                field("No. of Archived Versions"; "No. of Archived Versions")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of archived versions for this document.', Comment = 'ESM="Especifica el número de versiones archivadas de este documento."';
                }
                field("Requested Receipt Date"; "Requested Receipt Date")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the date that you want the vendor to deliver to the ship-to address. The value in the field is used to calculate the latest date you can order the items to have them delivered on the requested receipt date. If you do not need delivery on a specific date, you can leave the field blank.', Comment = 'ESM="Especifica la fecha en la que desea que el proveedor entregue a la dirección de envío. El valor en el campo se usa para calcular la última fecha en la que puede pedir los artículos para que se entreguen en la fecha de recepción solicitada. Si no necesita la entrega en una fecha específica, puede dejar el campo en blanco."';
                }
                field("Vendor Order No."; "Vendor Order No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the vendor''s order number.', Comment = 'ESM="Especifica el número de pedido del proveedor."';
                }
                field("Vendor Shipment No."; "Vendor Shipment No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the vendor''s shipment number.', Comment = 'ESM="Especifica el número de envío del proveedor."';
                }
                field("Purchaser Code"; "Purchaser Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.', Comment = 'ESM="Especifica qué comprador está asignado al proveedor."';

                    trigger OnValidate()
                    begin
                        PurchaserCodeOnAfterValidate;
                    end;
                }
                field("Campaign No."; "Campaign No.")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the number of the campaign that the document is linked to.', Comment = 'ESM="Especifica el número de campaña a la que está vinculado el documento."';
                }
                field("Order Address Code"; "Order Address Code")
                {
                    ApplicationArea = Suite;
                    Caption = 'Alternate Vendor Address Code', Comment = 'ESM="Código de dirección de proveedor alternativo"';
                    Importance = Additional;
                    ToolTip = 'Specifies the code for an alternate address, which you can send the FRQ to is the primary address is not active.', Comment = 'ESM="Specifies the code for an alternate address, which you can send the FRQ to is the primary address is not active."';
                }
                field("Responsibility Center"; "Responsibility Center")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                }
                field(Status; Status)
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Dimensions;

                    trigger OnValidate()
                    begin
                        ShortcutDimension1CodeOnAfterV;
                    end;
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Dimensions;

                    trigger OnValidate()
                    begin
                        ShortcutDimension2CodeOnAfterV;
                    end;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
                {
                    ApplicationArea = All;
                    Editable = true;
                }
            }
            part(PurchLines; "Purchase Quote Subform")
            {
                ApplicationArea = Suite;
                Editable = "Buy-from Vendor No." <> '';
                Enabled = "Buy-from Vendor No." <> '';
                SubPageLink = "Document No." = FIELD("No.");
                UpdatePropagation = Both;
            }
            group("Invoice Details")
            {
                Caption = 'Invoice Details', Comment = 'ESM="Detalle de factura"';
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;

                    trigger OnAssistEdit()
                    begin
                        Clear(ChangeExchangeRate);
                        ChangeExchangeRate.SetParameter("Currency Code", "Currency Factor", WorkDate);
                        if ChangeExchangeRate.RunModal = ACTION::OK then begin
                            Validate("Currency Factor", ChangeExchangeRate.GetParameter);
                            SaveInvoiceDiscountAmount;
                        end;
                        Clear(ChangeExchangeRate);
                    end;

                    trigger OnValidate()
                    begin
                        CurrPage.SaveRecord;
                        PurchCalcDiscByType.ApplyDefaultInvoiceDiscount(0, Rec);
                    end;
                }
                field("Expected Receipt Date"; "Expected Receipt Date")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("Prices Including VAT"; "Prices Including VAT")
                {
                    ApplicationArea = VAT;

                    trigger OnValidate()
                    begin
                        PricesIncludingVATOnAfterValid;
                    end;
                }
                field("VAT Bus. Posting Group"; "VAT Bus. Posting Group")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = Suite;
                    Importance = Promoted;
                }
                field("Payment Method Code"; "Payment Method Code")
                {

                    ApplicationArea = Suite;
                    Importance = Additional;
                    trigger OnValidate()
                    begin
                        gPaymentMethod := '';
                        gRecPaymentMethodCode.Reset;
                        gRecPaymentMethodCode.SetRange(Code, "Payment Method Code");
                        if gRecPaymentMethodCode.FindSet then
                            gPaymentMethod := gRecPaymentMethodCode.Description;
                    end;
                }
                field("Payment Method"; gPaymentMethod)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payment Method', Comment = 'ESM="Cód. Forma pago"';
                    Editable = false;
                }
                field("Comment Header"; gPurchaseComment)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comment', Comment = 'ESM="Comentario"';
                    Editable = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Discount %"; "Payment Discount %")
                {
                    ApplicationArea = Suite;
                }
                field("Pmt. Discount Date"; "Pmt. Discount Date")
                {
                    ApplicationArea = Suite;
                    Importance = Additional;
                }
                field("Shipment Method Code"; "Shipment Method Code")
                {
                    ApplicationArea = Basic, Suite;
                }
                field("Payment Reference"; "Payment Reference")
                {
                    ApplicationArea = Suite;
                }
                field("Creditor No."; "Creditor No.")
                {
                    ApplicationArea = Suite;
                }
                field("On Hold"; "On Hold")
                {
                    ApplicationArea = Suite;
                }
                field("Tax Liable"; "Tax Liable")
                {
                    ApplicationArea = SalesTax;
                }
                field("Tax Area Code"; "Tax Area Code")
                {
                    ApplicationArea = SalesTax;

                    trigger OnValidate()
                    begin
                        CurrPage.PurchLines.PAGE.RedistributeTotalsOnAfterValidate;
                    end;
                }
            }
            group("Shipping and Payment")
            {
                Caption = 'Shipping and Payment', Comment = 'ESM="Envío y pago"';
                group(Control45)
                {
                    ShowCaption = false;
                    group(Control20)
                    {
                        ShowCaption = false;
                        field(ShippingOptionWithLocation; ShipToOptions)
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Ship-to', Comment = 'ESM="Enviar a"';
                            HideValue = NOT ShowShippingOptionsWithLocation AND (ShipToOptions = ShipToOptions::Location);
                            OptionCaption = 'Default (Company Address),Location,Customer Address,Custom Address', Comment = 'ESM="Predeterminado (dirección de la empresa), ubicación, dirección del cliente, dirección personalizada"';
                            ToolTip = 'Specifies the address that the products on the purchase document are shipped to. Default (Company Address): The same as the company address specified in the Company Information window. Location: One of the company''s location addresses. Customer Address: Used in connection with drop shipment. Custom Address: Any ship-to address that you specify in the fields below.', Comment = 'ESM="Especifica la dirección a la que se envían los productos del documento de compra. Predeterminado (Dirección de la empresa): la misma que la dirección de la empresa especificada en la ventana Información de la empresa. Ubicación: una de las direcciones de ubicación de la empresa. Dirección del cliente: se utiliza en relación con el envío directo. Dirección personalizada: cualquier dirección de envío que especifique en los campos a continuación."';

                            trigger OnValidate()
                            begin
                                ValidateShippingOption;
                            end;
                        }
                        group(Control57)
                        {
                            ShowCaption = false;
                            group(Control55)
                            {
                                ShowCaption = false;
                                Visible = ShipToOptions = ShipToOptions::Location;
                                field("Location Code"; "Location Code")
                                {
                                    ApplicationArea = Location;
                                    Importance = Promoted;
                                }
                            }
                            field("Ship-to Name"; "Ship-to Name")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Name', Comment = 'ESM="Envío a nombre"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                            }
                            field("Ship-to Address"; "Ship-to Address")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address', Comment = 'ESM="Dirección de envío"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                            }
                            field("Ship-to Address 2"; "Ship-to Address 2")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Address 2', Comment = 'ESM="Dirección de envío 2"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                            }
                            group(Control90)
                            {
                                ShowCaption = false;
                                Visible = IsShipToCountyVisible;
                                field("Ship-to County"; "Ship-to County")
                                {
                                    ApplicationArea = Basic, Suite;
                                    Caption = 'County', Comment = 'ESM="Cód. Distrito"';
                                    Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                    Importance = Additional;
                                    QuickEntry = false;
                                }
                            }
                            field("Ship-to Post Code"; "Ship-to Post Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Post Code', Comment = 'ESM="Cód. Departamento"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                            }
                            field("Ship-to City"; "Ship-to City")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'City', Comment = 'ESM="Cód. Provincia"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;
                            }
                            field("Ship-to Country/Region Code"; "Ship-to Country/Region Code")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Country/Region', Comment = 'ESM="Cód. Pais"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                                QuickEntry = false;

                                trigger OnValidate()
                                begin
                                    IsShipToCountyVisible := FormatAddress.UseCounty("Ship-to Country/Region Code");
                                end;
                            }
                            field("Ship-to Contact"; "Ship-to Contact")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'Contact', Comment = 'ESM="Contacto"';
                                Editable = ShipToOptions = ShipToOptions::"Custom Address";
                                Importance = Additional;
                            }
                            field("UbigeoShipTo"; UbigeoMgt.ShowUbigeoDescription(
                                "Ship-to Country/Region Code", "Ship-to Post Code", "Ship-to City",
                                "Ship-to County"))
                            {
                                ApplicationArea = Suite;
                                Caption = 'Ubigeo';
                                Importance = Additional;
                                QuickEntry = false;
                            }
                        }
                    }
                }
                group(Control51)
                {
                    ShowCaption = false;
                    field(PayToOptions; PayToOptions)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Pay-to', Comment = 'Pago-a';
                        OptionCaption = 'Default (Vendor),Another Vendor,Custom Address', Comment = 'ESM="Predeterminado (proveedor), otro proveedor, dirección personalizada"';

                        trigger OnValidate()
                        begin
                            if PayToOptions = PayToOptions::"Default (Vendor)" then
                                Validate("Pay-to Vendor No.", "Buy-from Vendor No.");
                        end;
                    }
                    group(Control67)
                    {
                        ShowCaption = false;
                        Visible = NOT (PayToOptions = PayToOptions::"Default (Vendor)");
                        field("Pay-to Name"; "Pay-to Name")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Name', Comment = 'ESM="Pago a nombre"';
                            Editable = PayToOptions = PayToOptions::"Another Vendor";
                            Enabled = PayToOptions = PayToOptions::"Another Vendor";
                            Importance = Promoted;

                            trigger OnValidate()
                            begin
                                if GetFilter("Pay-to Vendor No.") = xRec."Pay-to Vendor No." then
                                    if "Pay-to Vendor No." <> xRec."Pay-to Vendor No." then
                                        SetRange("Pay-to Vendor No.");

                                CurrPage.Update;
                            end;
                        }
                        field("Pay-to Address"; "Pay-to Address")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address', Comment = 'ESM="Pago a dirección"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                        }
                        field("Pay-to Address 2"; "Pay-to Address 2")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Address 2', Comment = 'ESM="Pago a dirección 2"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                        }
                        group(Control84)
                        {
                            ShowCaption = false;
                            Visible = IsPayToCountyVisible;
                            field("Pay-to County"; "Pay-to County")
                            {
                                ApplicationArea = Basic, Suite;
                                Caption = 'County', Comment = 'ESM="Pago a ciudad"';
                                Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                                Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                                Importance = Additional;
                                QuickEntry = false;
                            }
                        }
                        field("Pay-to Post Code"; "Pay-to Post Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Post Code', Comment = 'ESM="Pago a departamento"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                        }
                        field("Pay-to City"; "Pay-to City")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'City', Comment = 'ESM="Pago a provincia"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;
                        }
                        field("Pay-to Country/Region Code"; "Pay-to Country/Region Code")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Country/Region', Comment = 'ESM="Pago a país"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                            QuickEntry = false;

                            trigger OnValidate()
                            begin
                                IsPayToCountyVisible := FormatAddress.UseCounty("Pay-to Country/Region Code");
                            end;
                        }
                        field("Pay-to Contact No."; "Pay-to Contact No.")
                        {
                            ApplicationArea = Suite;
                            Caption = 'Contact No.', Comment = 'ESM="N° Contacto"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Importance = Additional;
                        }
                        field("Pay-to Contact"; "Pay-to Contact")
                        {
                            ApplicationArea = Basic, Suite;
                            Caption = 'Contact', Comment = 'ESM="Contacto"';
                            Editable = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                            Enabled = (PayToOptions = PayToOptions::"Custom Address") OR ("Buy-from Vendor No." <> "Pay-to Vendor No.");
                        }
                        field("UbigeoPayTo"; UbigeoMgt.ShowUbigeoDescription(
                                "Pay-to Country/Region Code", "Pay-to Post Code", "Pay-to City",
                                "Pay-to County"))
                        {
                            ApplicationArea = Suite;
                            Caption = 'Ubigeo';
                            Importance = Additional;
                            QuickEntry = false;
                        }
                    }
                }
            }
            group("Foreign Trade")
            {
                Caption = 'Foreign Trade', Comment = 'ESM="Comercio exterior"';
                field("Transaction Specification"; "Transaction Specification")
                {
                    ApplicationArea = BasicEU;
                }
                field("Transport Method"; "Transport Method")
                {
                    ApplicationArea = BasicEU;
                }
                field("Entry Point"; "Entry Point")
                {
                    ApplicationArea = BasicEU;
                }
                field("Area"; Area)
                {
                    ApplicationArea = BasicEU;
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments', Comment = 'ESM="Archivos adjuntos"';
                SubPageLink = "Table ID" = CONST(38),
                              "No." = FIELD("No."),
                              "Document Type" = FIELD("Document Type");
            }
            part(Control13; "Pending Approval FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "Table ID" = CONST(38),
                              "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("No.");
                Visible = OpenApprovalEntriesExistForCurrUser;
            }
            part(Control1901138007; "Vendor Details FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
                Visible = false;
            }
            part(Control1904651607; "Vendor Statistics FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
            }
            part(Control1903435607; "Vendor Hist. Buy-from FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Buy-from Vendor No.");
            }
            part(Control1906949207; "Vendor Hist. Pay-to FactBox")
            {
                ApplicationArea = Suite;
                SubPageLink = "No." = FIELD("Pay-to Vendor No.");
                Visible = false;
            }
            part(Control5; "Purchase Line FactBox")
            {
                ApplicationArea = Suite;
                Provider = PurchLines;
                SubPageLink = "Document Type" = FIELD("Document Type"),
                              "Document No." = FIELD("Document No."),
                              "Line No." = FIELD("Line No.");
            }
            part(ApprovalFactBox; "Approval FactBox")
            {
                ApplicationArea = Suite;
                Visible = false;
            }
            part(IncomingDocAttachFactBox; "Incoming Doc. Attach. FactBox")
            {
                ApplicationArea = Suite;
                ShowFilter = false;
                Visible = false;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
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
                    ApplicationArea = Suite;
                    Caption = 'Statistics', Comment = 'ESM="Estadistica"';
                    Image = Statistics;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ShortCutKey = 'F7';

                    trigger OnAction()
                    begin
                        CalcInvDiscForHeader;
                        Commit;
                        PAGE.RunModal(PAGE::"Purchase Statistics", Rec);
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                action(Vendor)
                {
                    ApplicationArea = Suite;
                    Caption = 'Vendor', Comment = 'ESM="Proveedor"';
                    Enabled = "Buy-from Vendor No." <> '';
                    Image = Vendor;
                    Promoted = true;
                    PromotedCategory = Category9;
                    RunObject = Page "Vendor Card";
                    RunPageLink = "No." = FIELD("Buy-from Vendor No.");
                    ShortCutKey = 'Shift+F7';
                }
                action("Co&mments")
                {
                    ApplicationArea = Comments;
                    Caption = 'Co&mments', Comment = 'ESM="Comentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category7;
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
                    Enabled = "No." <> '';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Category7;
                    PromotedIsBig = true;
                    ShortCutKey = 'Alt+D';

                    trigger OnAction()
                    begin
                        ShowDocDim;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals', comment = 'ESM="Aprobación"';
                    Image = Approvals;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    var
                        WorkflowsEntriesBuffer: Record "Workflows Entries Buffer";
                        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
                    begin
                        WorkflowsEntriesBuffer.RunWorkflowEntriesPage(RecordId, DATABASE::"Purchase Header", DocumentType::Quote, "No.");
                    end;
                }
                action(DocAttach)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments', Comment = 'ESM="Archivos adjuntos"';
                    Image = Attach;
                    Promoted = true;
                    PromotedCategory = Category7;

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal;
                    end;
                }
            }
        }
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval', comment = 'ESM="Aprobación"';
                action(Approve)
                {
                    ApplicationArea = Suite;
                    Caption = 'Approve', comment = 'ESM="Aprobar"';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = Suite;
                    Caption = 'Reject', Comment = 'ESM="Rechazar"';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = Suite;
                    Caption = 'Delegate', Comment = 'Delegar';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments', Comment = 'ESM="Comentarios"';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedOnly = true;
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Action92)
            {
                Caption = 'Print', Comment = 'ESM="Imprimir"';
                action(Print)
                {
                    ApplicationArea = Suite;
                    Caption = '&Print', Comment = 'ESM="Imprimir"';
                    Ellipsis = true;
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Category6;

                    trigger OnAction()
                    var
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
                    PromotedCategory = Category6;

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
                separator(Action148)
                {
                }
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease', Comment = 'ESM="Lanzar"';
                    Image = ReleaseDoc;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedIsBig = true;
                    PromotedOnly = true;
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
                    ApplicationArea = Suite;
                    Caption = 'Re&open', Comment = 'ESM="Reabrir"';
                    Enabled = Status <> Status::Open;
                    Image = ReOpen;
                    Promoted = true;
                    PromotedCategory = Category8;
                    PromotedOnly = true;

                    trigger OnAction()
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";

                    begin
                        fnValidateUserApprovalPurchase(Rec);
                        ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }
            group("F&unctions")
            {
                Caption = 'F&unctions', Comment = 'Funciones';
                Image = "Action";
                action(CalculateInvoiceDiscount)
                {
                    AccessByPermission = TableData "Vendor Invoice Disc." = R;
                    ApplicationArea = Suite;
                    Caption = 'Calculate &Invoice Discount', Comment = 'ESM="Calcular descuento factura"';
                    Image = CalculateInvoiceDiscount;

                    trigger OnAction()
                    begin
                        ApproveCalcInvDisc;
                        PurchCalcDiscByType.ResetRecalculateInvoiceDisc(Rec);
                    end;
                }
                separator(Action144)
                {
                }
                action("Get St&d. Vend. Purchase Codes")
                {
                    ApplicationArea = Suite;
                    Caption = 'Get St&d. Vend. Purchase Codes', Comment = 'ESM="Obtener linea de compra estandar"';
                    Ellipsis = true;
                    Image = VendorCode;

                    trigger OnAction()
                    var
                        StdVendPurchCode: Record "Standard Vendor Purchase Code";
                        lclRecPurchaseLine: Record "Purchase Line";

                    begin
                        StdVendPurchCode.InsertPurchLines(Rec);
                    end;
                }
                separator(Action146)
                {
                }
                action(CopyDocument)
                {
                    ApplicationArea = Suite;
                    Caption = 'Copy Document', Comment = 'ESM="Copiar documento"';
                    Ellipsis = true;
                    Enabled = "No." <> '';
                    Image = CopyDocument;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        CopyPurchDoc.SetPurchHeader(Rec);
                        CopyPurchDoc.RunModal;
                        Clear(CopyPurchDoc);
                        if Get("Document Type", "No.") then;
                    end;
                }
                action("Archive Document")
                {
                    ApplicationArea = Suite;
                    Caption = 'Archi&ve Document', Comment = 'ESM="Archivar documento"';
                    Image = Archive;

                    trigger OnAction()
                    begin
                        ArchiveManagement.ArchivePurchDocument(Rec);
                        CurrPage.Update(false);
                    end;
                }
                group(IncomingDocument)
                {
                    Caption = 'Incoming Document', Comment = 'ESM="Documento entrante"';
                    Image = Documents;
                    action(IncomingDocCard)
                    {
                        ApplicationArea = Suite;
                        Caption = 'View Incoming Document', Comment = 'ESM="Ver documento entrante"';
                        Enabled = HasIncomingDocument;
                        Image = ViewOrder;

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            IncomingDocument.ShowCardFromEntryNo("Incoming Document Entry No.");
                        end;
                    }
                    action(SelectIncomingDoc)
                    {
                        AccessByPermission = TableData "Incoming Document" = R;
                        ApplicationArea = Suite;
                        Caption = 'Select Incoming Document', Comment = 'ESM="Seleccionar documento entrante"';
                        Image = SelectLineToApply;

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            Validate("Incoming Document Entry No.", IncomingDocument.SelectIncomingDocument("Incoming Document Entry No.", RecordId));
                        end;
                    }
                    action(IncomingDocAttachFile)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Create Incoming Document from File', Comment = 'ESM="Crear documento entrante desde archivo"';
                        Ellipsis = true;
                        Enabled = ("Incoming Document Entry No." = 0) AND ("No." <> '');
                        Image = Attach;

                        trigger OnAction()
                        var
                            IncomingDocumentAttachment: Record "Incoming Document Attachment";
                        begin
                            IncomingDocumentAttachment.NewAttachmentFromPurchaseDocument(Rec);
                        end;
                    }
                    action(RemoveIncomingDoc)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Remove Incoming Document', Comment = 'Eliminar documentos de entrada';
                        Enabled = HasIncomingDocument;
                        Image = RemoveLine;

                        trigger OnAction()
                        var
                            IncomingDocument: Record "Incoming Document";
                        begin
                            if IncomingDocument.Get("Incoming Document Entry No.") then
                                IncomingDocument.RemoveLinkToRelatedRecord;
                            "Incoming Document Entry No." := 0;
                            Modify(true);
                        end;
                    }
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval', Comment = 'ESM="Solicitud de aprobación"';
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request', Comment = 'ESM="Enviar solicitud de aprobación"';
                    Enabled = NOT OpenApprovalEntriesExist;
                    Image = SendApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;
                    PromotedIsBig = true;

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
                    Caption = 'Cancel Approval Re&quest', Comment = 'ESM="Cancelar solictud de aprobación"';
                    Enabled = CanCancelApprovalForRecord;
                    Image = CancelApprovalRequest;
                    Promoted = true;
                    PromotedCategory = Category5;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OnCancelPurchaseApprovalRequest(Rec);
                    end;
                }
            }
            group("Make Order")
            {
                Caption = 'Make Order', Comment = 'ESM="Convertir a pedido"';
                Image = MakeOrder;
                action(MakeOrder)
                {
                    ApplicationArea = Suite;
                    Caption = 'Make &Order', Comment = 'ESM="Convertir a pedido"';
                    Image = MakeOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        cuValidatePurchase: Codeunit "PR Purchase Validate";

                        lclRecPurchaseHeader: Record "Purchase Header";
                        lclRecPurchaseLine: Record "Purchase line";
                    begin
                        cuValidatePurchase.fnValidateGenericPurchase(Rec);
                        if ApprovalsMgmt.PrePostApprovalCheckPurch(Rec) then
                            CODEUNIT.Run(CODEUNIT::"Purch.-Quote to Order (Yes/No)", Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        SetControlAppearance;
        CurrPage.IncomingDocAttachFactBox.PAGE.LoadDataFromRecord(Rec);
        CurrPage.ApprovalFactBox.PAGE.UpdateApprovalEntriesFromSourceRecord(RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(RecordId);
    end;

    trigger OnAfterGetRecord()
    begin
        CalculateCurrentShippingAndPayToOption;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        CurrPage.SaveRecord;
        exit(ConfirmDeletion);
    end;

    trigger OnInit()
    begin
        ShowShippingOptionsWithLocation := ApplicationAreaMgmtFacade.IsLocationEnabled or ApplicationAreaMgmtFacade.IsAllDisabled;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "PR Purchase Request" := true;
        "Responsibility Center" := UserMgt.GetPurchasesFilter;

        if (not DocNoVisible) and ("No." = '') then
            SetBuyFromVendorFromFilter;

        CalculateCurrentShippingAndPayToOption;
    end;

    trigger OnOpenPage()
    begin
        if UserMgt.GetPurchasesFilter <> '' then begin
            FilterGroup(2);
            SetRange("Responsibility Center", UserMgt.GetPurchasesFilter);
            FilterGroup(0);
        end;

        ActivateFields;

        SetDocNoVisible;

        gPurchaseComment := '';
        gRecPurchaseComment.Reset();
        gRecPurchaseComment.SetRange("Document Type", gRecPurchaseComment."Document Type"::Quote);
        gRecPurchaseComment.SetRange("No.", "No.");
        // gRecPurchaseComment.SetRange("Line No.", 0);
        if gRecPurchaseComment.FindFirst then
            gPurchaseComment := gRecPurchaseComment.Comment;

        gPaymentMethod := '';
        gRecPaymentMethodCode.Reset;
        gRecPaymentMethodCode.SetRange(Code, "Payment Method Code");
        if gRecPaymentMethodCode.FindSet then
            gPaymentMethod := gRecPaymentMethodCode.Description;

        ValidateShippingOption;
    end;

    var
        CopyPurchDoc: Report "Copy Purchase Document";
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        DocPrint: Codeunit "Document-Print";
        UserMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        PurchCalcDiscByType: Codeunit "Purch - Calc Disc. By Type";
        FormatAddress: Codeunit "Format Address";
        ChangeExchangeRate: Page "Change Exchange Rate";
        ShipToOptions: Option "Default (Company Address)",Location,"Custom Address";
        PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address";
        HasIncomingDocument: Boolean;
        DocNoVisible: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        CanCancelApprovalForRecord: Boolean;
        ShowShippingOptionsWithLocation: Boolean;
        IsBuyFromCountyVisible: Boolean;
        IsPayToCountyVisible: Boolean;
        IsShipToCountyVisible: Boolean;
        UbigeoMgt: Codeunit "Ubigeo Management";
        gRecPaymentMethodCode: Record "Payment Method";
        gPaymentMethod: Text;
        gRecPurchaseComment: Record "Purch. Comment Line";
        gPurchaseComment: Text;

    local procedure fnValidateUserApprovalPurchase(pPurchaseHeader: Record "Purchase Header")
    var
        lclRecApprovalEntry: Record "Approval Entry";
        lclRecuser: Record User;
    begin
        lclRecuser.Get(UserSecurityId());
        if pPurchaseHeader.Status = pPurchaseHeader.Status::Released then begin
            lclRecApprovalEntry.Reset();
            lclRecApprovalEntry.SetRange("Table ID", Database::"Purchase Header");
            lclRecApprovalEntry.SetRange("Document Type", "Document Type");
            lclRecApprovalEntry.SetRange("Document No.", pPurchaseHeader."No.");
            lclRecApprovalEntry.SetRange(Status, lclRecApprovalEntry.Status::Approved);
            if lclRecApprovalEntry.FindLast() then begin
                if lclRecApprovalEntry."Approver ID" <> lclRecuser."User Name" then begin
                    Error('Solo usuario aprobador %1, puede volver abrir este documento', lclRecApprovalEntry."Approver ID");
                    exit;
                end;
            end;
        end;
    end;

    local procedure ActivateFields()
    begin
        IsBuyFromCountyVisible := FormatAddress.UseCounty("Buy-from Country/Region Code");
        IsPayToCountyVisible := FormatAddress.UseCounty("Pay-to Country/Region Code");
        IsShipToCountyVisible := FormatAddress.UseCounty("Ship-to Country/Region Code");
    end;

    local procedure ApproveCalcInvDisc()
    begin
        CurrPage.PurchLines.PAGE.ApproveCalcInvDisc;
    end;

    local procedure SaveInvoiceDiscountAmount()
    var
        DocumentTotals: Codeunit "Document Totals";
    begin
        CurrPage.SaveRecord;
        DocumentTotals.PurchaseRedistributeInvoiceDiscountAmountsOnDocument(Rec);
        CurrPage.Update(false);
    end;

    local procedure PurchaserCodeOnAfterValidate()
    begin
        CurrPage.PurchLines.PAGE.UpdateForm(true);
    end;

    local procedure ShortcutDimension1CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure ShortcutDimension2CodeOnAfterV()
    begin
        CurrPage.Update;
    end;

    local procedure PricesIncludingVATOnAfterValid()
    begin
        CurrPage.Update;
    end;

    local procedure SetDocNoVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
        DocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Reminder,FinChMemo;
    begin
        DocNoVisible := DocumentNoVisibility.PurchaseDocumentNoIsVisible(DocType::Quote, "No.");
    end;

    local procedure SetControlAppearance()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RecordId);
        HasIncomingDocument := "Incoming Document Entry No." <> 0;
    end;

    local procedure ValidateShippingOption()
    begin
        case ShipToOptions of
            ShipToOptions::"Default (Company Address)":
                begin
                    "Ship-to Name" := "Buy-from Vendor Name";
                    "Ship-to Address" := "Buy-from Address";
                    "Ship-to Address 2" := "Buy-from Address 2";
                    "Ship-to County" := "Buy-from County";
                    "Ship-to Post Code" := "Buy-from Post Code";
                    "Ship-to City" := "Buy-from City";
                    "Ship-to Country/Region Code" := "Buy-from Country/Region Code";
                    "Ship-to Contact" := "Buy-from Contact";
                end;
            ShipToOptions::"Custom Address":
                begin
                    Validate("Location Code", '');

                end;
            ShipToOptions::Location:
                begin
                    // Validate("Location Code");
                end;
        end;
    end;

    local procedure CalculateCurrentShippingAndPayToOption()
    begin
        if "Location Code" <> '' then
            ShipToOptions := ShipToOptions::Location
        else
            if ShipToAddressEqualsCompanyShipToAddress then
                ShipToOptions := ShipToOptions::"Default (Company Address)"
            else
                ShipToOptions := ShipToOptions::"Custom Address";

        case true of
            ("Pay-to Vendor No." = "Buy-from Vendor No.") and BuyFromAddressEqualsPayToAddress:
                PayToOptions := PayToOptions::"Default (Vendor)";
            ("Pay-to Vendor No." = "Buy-from Vendor No.") and (not BuyFromAddressEqualsPayToAddress):
                PayToOptions := PayToOptions::"Custom Address";
            "Pay-to Vendor No." <> "Buy-from Vendor No.":
                PayToOptions := PayToOptions::"Another Vendor";
        end;

        OnAfterCalculateCurrentShippingAndPayToOption(ShipToOptions, PayToOptions, Rec);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalculateCurrentShippingAndPayToOption(var ShipToOptions: Option "Default (Company Address)",Location,"Custom Address"; var PayToOptions: Option "Default (Vendor)","Another Vendor","Custom Address"; PurchaseHeader: Record "Purchase Header")
    begin
    end;
}
