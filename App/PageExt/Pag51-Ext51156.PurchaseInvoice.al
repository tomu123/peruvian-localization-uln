pageextension 51156 "ST Purchase Invoice" extends "Purchase Invoice"
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

        addbefore("Vendor Invoice No.")
        {
            field("Posting No. Series"; "Posting No. Series")
            {
                ApplicationArea = All;
            }
            field("Electronic Bill"; "Electronic Bill")
            {
                ApplicationArea = All;
                Caption = 'Electronic Bill', Comment = 'ESM="Factura electrónica"';
                trigger OnValidate()
                var
                    VendorInvNo: Text;
                    ErrorVendInvNo: label 'The first character must start with E, F for electronic.', Comment = 'ESM="El primer caracter para la serie debe de ser E ó F solo para electrónicos."';
                begin
                    Validate("Vendor Invoice No.");
                end;
            }
            field("Vendor Order No."; "Vendor Order No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Vendor Invoice No.")
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
                Caption = 'Posting Text', Comment = 'ESM="Glosa Principal"';
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
        modify("Vendor Invoice No.")
        {
            trigger OnAfterValidate()
            begin
                ValidateVendorInvoiceNo();
            end;
        }

        addafter("Foreign Trade")
        {
            group(Detractions)
            {
                Caption = 'Detractions', Comment = 'ESM="Detracciones"';
                field("Purch. Detraction"; "Purch. Detraction")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                    end;
                }
                group(TypeOfService)
                {
                    Caption = 'Type Of Service', Comment = 'ESM="Tipo de servicio"';
                    grid(Mygrid)
                    {
                        GridLayout = Columns;
                        field("Type of Service"; "Type of Service")
                        {
                            Editable = EditDetrac;
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            var
                                myInt: Integer;
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Detrac. Service. Name"; CalcDetraction.GetTypeOfSO("Type of Service", false))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            //FieldPropertyName = FieldPropertyValue;
                        }
                    }
                }
                group(TypeOfOperation)
                {
                    Caption = 'Type Of Operation', Comment = 'ESM="Tipo de operación"';
                    grid(Mygrid2)
                    {
                        GridLayout = Columns;
                        field("Type of Operation"; "Type of Operation")
                        {
                            Editable = EditDetrac;
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            var
                                myInt: Integer;
                            begin
                                CurrPage.Update();
                            end;
                        }
                        field("Detrac.Oper. Name"; CalcDetraction.GetTypeOfSO("Type of Operation", true))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            //FieldPropertyName = FieldPropertyValue;
                        }

                    }
                }
                field("Purch. % Detraction"; "Purch. % Detraction")
                {
                    Editable = EditDetrac;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Purch. Amount Detraction"; "Purch. Amount Detraction")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Purch Amount Detraction (DL)"; "Purch Amount Detraction (DL)")
                {
                    Editable = false;
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                    end;
                }
                field("Purch. Detraction Operation"; "Purch. Detraction Operation")
                {
                    ApplicationArea = All;
                    Editable = EditDetrac;
                }
                field("Purch Date Detraction"; "Purch Date Detraction")
                {
                    ApplicationArea = All;
                    Editable = EditDetrac;
                    trigger OnValidate()
                    var
                        myInt: Integer;
                    begin
                        CurrPage.Update();
                    end;
                }
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
                    Caption = 'Legal Property Type', Comment = 'ESM="Tipo bien"';
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
                Caption = 'Credit Memo', Comment = 'ESM="Nota Débito"';

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
                field("Applies-to Serie Ref."; "Applies-to Serie Ref.")
                {
                    ApplicationArea = All;
                    Editable = "Manual Document Ref.";
                }
                field("Applies-to Number Ref."; "Applies-to Number Ref.")
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
        //Legla document End
        modify("Assigned User ID")
        {
            Visible = true;
        }

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

        //Import Begin
        addlast(General)
        {
            group("IncomeType")
            {
                Caption = 'Tipo Renta';
                Visible = ShowField;
                grid(IncomeTypeGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND1")
                    {
                        //GridLayout = Rows;
                        ShowCaption = false;
                        field("Income Type"; "Income Type")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            begin
                                LegalDocument.Reset();
                                LegalDocument.SetRange("Option Type", LegalDocument."Option Type"::"SUNAT Table");
                                LegalDocument.SetRange("Type Code", '31');
                                LegalDocument.SetRange("Legal No.", "Income Type");
                                if LegalDocument.FindSet() then
                                    gTextIncomeType := LegalDocument.Description;


                            end;
                        }
                    }
                    group("GridGroupND2")
                    {
                        ShowCaption = false;
                        field(gTextIncomeType; gTextIncomeType)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }

            group("ServiceProvidedMode")
            {
                Caption = 'Modalidad Servicio Prestado';
                Visible = ShowField;
                grid(ServiceProvidedModeGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND3")
                    {
                        ShowCaption = false;
                        field("Service Provided Mode"; "Service Provided Mode")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            begin
                                LegalDocument.Reset();
                                LegalDocument.SetRange("Option Type", LegalDocument."Option Type"::"SUNAT Table");
                                LegalDocument.SetRange("Type Code", '32');
                                LegalDocument.SetRange("Legal No.", "Service Provided Mode");
                                if LegalDocument.FindSet() then
                                    gTextServiceProvidedMode := LegalDocument.Description;
                            end;
                        }
                    }
                    group("GridGroupND4")
                    {
                        ShowCaption = false;
                        field(gTextServiceProvidedMode; gTextServiceProvidedMode)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }

            group("ExemptionsfromOperations")
            {
                Caption = 'Exoneraciones de Operaciones';
                Visible = ShowField;
                grid(ExemptionsfromOperationsGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND5")
                    {
                        ShowCaption = false;
                        field("Exemptions from Operations"; "Exemptions from Operations")
                        {
                            ApplicationArea = All;
                            trigger OnValidate()
                            begin
                                LegalDocument.Reset();
                                LegalDocument.SetRange("Option Type", LegalDocument."Option Type"::"SUNAT Table");
                                LegalDocument.SetRange("Type Code", '33');
                                LegalDocument.SetRange("Legal No.", "Exemptions from Operations");
                                if LegalDocument.FindSet() then
                                    gTextExemptionsfromOperations := LegalDocument.Description;
                            end;
                        }
                    }
                    group("GridGroupND6")
                    {
                        ShowCaption = false;
                        field(gTextExemptionsfromOperations; gTextExemptionsfromOperations)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                        }
                    }
                }
            }
        }

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
            field(Destinacion; Destinacion)
            {
                ApplicationArea = All;
            }
            field(Modality; Modality)
            {
                ApplicationArea = All;
            }
            field("Via transport"; "Via transport")
            {
                ApplicationArea = All;
            }
            field("Shipping Method"; "Shipping Method")
            {
                ApplicationArea = All;
            }
        }
        modify("Area")
        {
            Caption = 'Puerto / Embarque';
            /*trigger OnLookup()
            var
                myInt: Integer;
                PagDocumentList: Page "Legal Document List";
                RecDocumentList: Record "Legal Document";
            begin
                RecDocumentList.Reset();
                RecDocumentList.SetRange("Option Type", RecDocumentList."Option Type"::"SUNAT Table");
                RecDocumentList.SetRange("Type Code", '11');
                if RecDocumentList.FindSet() then begin
                    Clear(PagDocumentList);
                    PagDocumentList.SetRecord(RecDocumentList);
                    PagDocumentList.SetTableView(RecDocumentList);
                    PagDocumentList.LookupMode(true);
                    if PagDocumentList.RunModal() = Action::LookupOK then begin
                        PagDocumentList.GetRecord(RecDocumentList);
                        "Area" := RecDocumentList."Legal No.";
                    end;
                end;
            end;*/
            //TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('11'));
        }
        modify("Entry Point")
        {
            Caption = 'INCOTERM';
        }
        //Import End

        addafter("Posting Date")
        {
            field("Accountant receipt date"; "Accountant receipt date")
            {
                ApplicationArea = All;
            }
        }
    }



    actions
    {
        // Add changes to page actions here
        modify(Post)
        {
            trigger OnBeforeAction()
            begin
                ValidateVendorInvoiceNo();
            end;

            trigger OnAfterAction()
            begin
                fnShowJournalAF;

            end;
        }

        modify(PostAndPrint)
        {
            trigger OnBeforeAction()
            begin
                ValidateVendorInvoiceNo();
            end;
        }
    }

    trigger OnAfterGetRecord()
    begin
        EditDetrac := true;
        IF "Purch. Detraction" THEN
            EditDetrac := true;
        IF "Purch. Detraction" THEN
            VALIDATE("Type of Service");
        ShowField := "Legal Document" in ['91', '97', '98'];
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if "Assigned User ID" = '' then
            "Assigned User ID" := UserId;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        ShowField := "Legal Document" in ['91', '97', '98'];
    end;

    var
        CalcDetraction: Codeunit "DetrAction Calculation";
        UbigeoMgt: Codeunit "Ubigeo Management";
        EditDetrac: Boolean;
        LegalDocument: Record "Legal Document";
        gTextIncomeType: Text;
        gTextServiceProvidedMode: text;
        gTextExemptionsfromOperations: text;
        gEnableNoDomiciliado: Boolean;
        RecPurchase: Record "Purchase Header";
        ShowField: Boolean;

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

    local procedure ValidateVendorInvoiceNo()
    var
        VendorInvNo: Text;
        ErrorVendInvNo: label 'The first character must start with E, F for electronic.', Comment = 'ESM="El primer caracter para la serie debe de ser E ó F solo para electrónicos."';
        ErrorVendInvNo2: label 'The first character must start with E, F for electronic.', Comment = 'ESM="Si la seríe de [N° Factura proveedor] inicia con F ó E, debe de activar el check de [Factura Electrónica]."';
    begin
        if "Vendor Invoice No." = '' then
            exit;
        VendorInvNo := "Vendor Invoice No.";
        if "Electronic Bill" then begin
            if not (VendorInvNo[1] in ['F', 'E', 'B']) then
                Error(ErrorVendInvNo);
        end else
            if VendorInvNo[1] in ['E', 'F'] then
                Error(ErrorVendInvNo2);
    end;

    procedure fnShowJournalAF()
    var
        lclRecPurchaseLine: Record "Purch. Inv. Line";
        lclRecFixedAsset: Record "Fixed Asset";
        lclRecFADepreciationBook: Record "FA Depreciation Book";
        lclCount: Integer;
        lclGenJnlManagement: Codeunit "GenJnlManagement";
        lclGenJnlBatch: Record "Gen. Journal Batch";
        lclDepreciationBook: Record "Depreciation Book";
        lclFAJournalSetup: Record "FA Journal Setup";
        lclDiario: Code[30];
        lclSeccion: Code[30];
        lcPgFixedAssetJournal: Page "Fixed Asset Journal";
        PurchInvHeader: Record "Purch. Inv. Header";
        lcRecFAJournalLine: Record "FA Journal Line";
        lcRecFAJournalLineClear: Record "FA Journal Line";
        lcRecSetupLocalization: Record "Setup Localization";
    begin
        lcRecSetupLocalization.Get();
        lcRecSetupLocalization.TestField("Book Amortization tributary");
        PurchInvHeader.SETRANGE("Pre-Assigned No.", "No.");
        PurchInvHeader.SETRANGE("Order No.", '');
        IF PurchInvHeader.FINDFIRST THEN begin
            lclRecPurchaseLine.RESET;
            lclRecPurchaseLine.SETRANGE(Type, lclRecPurchaseLine.Type::"Fixed Asset");
            lclRecPurchaseLine.SETRANGE("Document No.", PurchInvHeader."No.");
            IF lclRecPurchaseLine.FINDSET THEN BEGIN
                CLEAR(lcPgFixedAssetJournal);
                lcPgFixedAssetJournal.RUNMODAL;
                //Clear Jouarnal
                lcRecFAJournalLine.Reset();
                lcRecFAJournalLine.SetRange("Journal Template Name", 'AF');
                lcRecFAJournalLine.SetRange("Journal Batch Name", lcRecSetupLocalization."Book Amortization tributary");
                lcRecFAJournalLine.SetFilter("FA No.", '<>%1', '');
                if not lcRecFAJournalLine.FindSet() then begin
                    lcRecFAJournalLineClear.Reset();
                    lcRecFAJournalLineClear.SetRange("Journal Template Name", 'AF');
                    lcRecFAJournalLineClear.SetRange("Journal Batch Name", lcRecSetupLocalization."Book Amortization tributary");
                    lcRecFAJournalLineClear.DeleteAll();
                end;
            end;
        end;
    end;
}