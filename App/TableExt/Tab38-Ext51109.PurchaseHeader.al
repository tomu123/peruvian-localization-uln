tableextension 51109 "Setup Purchase Header" extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here 51024..51025,51050..51059
        //Legal Document Begin
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                SerieNo: Code[20];
                NumberNo: Code[20];
            begin
                if "Legal Document" = '' then
                    exit;
                SetPostingSerieNo();
                LegalDocMgt.ValidateLegalDocumentFormat("Vendor Invoice No.", "Legal Document", SerieNo, NumberNo, false, false);
                if (StrLen(SerieNo) > 0) and (StrLen(NumberNo) > 0) then
                    "Vendor Invoice No." := SerieNo + '-' + NumberNo;
            end;
        }
        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            //OptionMembers = Success,Anulled,OutFlow;//'ULN:PC 18.01.21
            // OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';//'ULN:PC 18.01.21
            OptionMembers = Success,OutFlow;
            OptionCaption = 'Success,OutFlow', Comment = 'ESM="Normal,Extornado"';
            trigger OnValidate()
            begin
                if "Legal Document" = '' then
                    exit;
                SetPostingSerieNo();
            end;
        }
        field(51002; "Legal Document Ref."; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document Ref.', Comment = 'ESM="Documento Legal Ref."';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
        }
        field(51011; "VAT Registration Type"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'VAT Registration type', Comment = 'ESM="Doc. Legal de Identidad"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        field(51012; "Legal Property Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Property Type', Comment = 'ESM="Tipo bien"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('30'));
            ValidateTableRelation = false;
        }
        field(51013; "Ext/Anul. User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ext/Anul. User Id.', Comment = 'ESM="Ext/Anul. Id. Usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(51030; "Manual Document Ref."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual document Ref.', Comment = 'ESM="Doc. Ref. Manual"';
            trigger OnValidate()
            begin
                Validate("Applies-to Doc. No. Ref.", '');
            end;
        }
        field(51031; "Electronic Doc. Ref"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Doc. Ref', Comment = 'ESM="Doc. Electronica Ref."';
        }
        field(51032; "Applies-to Doc. No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Doc. No. Ref.', Comment = 'ESM="Liq. N° Documento Ref."';
            TableRelation = if ("Manual Document Ref." = Const(false)) "Purch. Inv. Header"."No." where("Legal Status" = const(Success), "Buy-from Vendor No." = field("Buy-from Vendor No."));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                LegalDocMgt: Codeunit "Legal Document Management";
                MyPurchInvHeader: Record "Purch. Inv. Header";
            begin
                MyPurchInvHeader.Reset();
                MyPurchInvHeader.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                MyPurchInvHeader.SetRange("Vendor Invoice No.", "Applies-to Doc. No. Ref.");
                if MyPurchInvHeader.Find('-') then begin
                    Rec.Validate("Applies-to Document Date Ref.", MyPurchInvHeader."Document Date");
                    "Legal Document Ref." := MyPurchInvHeader."Legal Document";
                end else begin
                    MyPurchInvHeader.Reset();
                    MyPurchInvHeader.SetRange("Buy-from Vendor No.", "Buy-from Vendor No.");
                    MyPurchInvHeader.SetRange("No.", "Applies-to Doc. No. Ref.");
                    if MyPurchInvHeader.Find('-') then begin
                        Rec.Validate("Applies-to Document Date Ref.", MyPurchInvHeader."Document Date");
                        "Legal Document Ref." := MyPurchInvHeader."Legal Document";
                    end;
                end;
                //ULN::PC 001  2020.06.05 v.001 Begin   
                if MyPurchInvHeader.FindSet() then begin
                    if ("Applies-to Doc. No. Ref." <> '') then
                        LegalDocMgt.ValidateLegalDocumentFormat(MyPurchInvHeader."Vendor Invoice No.",
                                                                '01',
                                                                "Applies-to Serie Ref.",
                                                                "Applies-to Number Ref.",
                                                                false,
                                                                not "Manual Document Ref.");
                end;


                //Clear Fields
                if "Applies-to Doc. No. Ref." = '' then begin
                    rec."Applies-to Document Date Ref." := 0D;
                    rec."Applies-to Number Ref." := '';
                    rec."Legal Document Ref." := '';
                    rec."Applies-to Serie Ref." := '';
                    if "Currency Code" = '' then
                        "Currency Factor" := 0;
                    if "Currency Code" <> '' then
                        FactorByPostingDatePurchases();
                end;
                //ULN::PC 001  2020.06.05 v.001 End  
            end;
        }
        field(51033; "Applies-to Serie Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Serie Ref.', Comment = 'ESM="Liq. N° Serie Ref."';
            trigger OnValidate()
            var
                LegalDocMgt: Codeunit "Legal Document Management";
                DocumentNo: Code[20];
            begin
            end;
        }
        field(51034; "Applies-to Number Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Number Ref.', Comment = 'ESM="Liq. Number Ref."';
            trigger OnValidate()
            var
                LegalDocMgt: Codeunit "Legal Document Management";
                DocumentNo: Code[20];
            begin
            end;
        }
        field(51035; "Applies-to Document Date Ref."; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Document Date Ref.', Comment = 'ESM="Liq. Fec. Emisión Ref."';
            trigger OnValidate()
            var
            begin
                if "Currency Code" = '' then
                    "Currency Factor" := 0;
                if "Currency Code" <> '' then
                    FactorByApplicationPurchases("Manual Document Ref.");
            end;
        }
        field(51036; MyField; Blob)
        {
            DataClassification = ToBeClassified;
        }

        modify("Vendor Invoice No.")
        {
            trigger OnBeforeValidate()
            var
                SerieNo: Code[20];
                NumberNo: Code[20];
            begin
                LegalDocMgt.ValidateLegalDocumentFormat("Vendor Invoice No.", "Legal Document", SerieNo, NumberNo, false, false);
                if (StrLen(SerieNo) > 0) and (StrLen(NumberNo) > 0) then
                    "Vendor Invoice No." := SerieNo + '-' + NumberNo;
            end;
        }
        modify("Vendor Cr. Memo No.")
        {
            trigger OnBeforeValidate()
            var
                SerieNo: Code[20];
                NumberNo: Code[20];
            begin
                LegalDocMgt.ValidateLegalDocumentFormat("Vendor Cr. Memo No.", "Legal Document", SerieNo, NumberNo, false, false);
                if (StrLen(SerieNo) > 0) and (StrLen(NumberNo) > 0) then
                    "Vendor Cr. Memo No." := SerieNo + '-' + NumberNo;
            end;
        }
        //Legal Document End
        field(51050; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód Origen ULN"';
            //TableRelation = "Master Data".Code where("Type Table" = const('STPSOURCECODE'));
        }
        field(51051; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Glosa Principal"';
        }
        modify("Posting Description")
        {
            Caption = 'Posting Description', comment = 'ESM="Descripción"';
        }
        field(51052; "Electronic Bill"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Bill', Comment = 'ESM="Factura electrónica"';
        }
        field(51053; "Shortcut Dimension 5 Code"; Code[20])
        {
            CaptionClass = '1,2,5';
            Caption = 'Shortcut Dimension 5 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(5), Blocked = CONST(false));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(5, "Shortcut Dimension 5 Code");
            end;
        }
        field(51054; "Applies-to Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Entry No.', Comment = 'ESM="Liq. por N° Movimiento"';
        }
        field(51055; "Accountant receipt date"; date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Accountant receipt date', Comment = 'ESM="Fecha recepción contabilidad"';

            trigger OnValidate()
            begin
                Validate("Payment Terms Code");
            end;
        }
        modify("Document Date")
        {
            trigger OnAfterValidate()
            begin
                SetHideValidationDialog(true);
                UpdateCurrencyFactor();
                SetHideValidationDialog(false);
                Validate("Accountant receipt date", "Document Date");
            end;
        }
        modify("Currency Code")
        {
            trigger OnBeforeValidate()
            begin
                SetHideValidationDialog(true);
            end;

            trigger OnAfterValidate()
            begin
                SetHideValidationDialog(false);
            end;
        }

        //Detracc BEIGN
        field(51003; "Purch. Detraction"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch Detraction', Comment = 'ESM="Detracción"';
            trigger OnValidate()
            begin
                if "Purch. Detraction" then begin
                    TestField("Applies-to Entry No.", 0);
                    TestField("Applies-to Doc. No.", '');
                end;
                // IF "Purch. Detraction" then
                //     TestField("Apply Retention");
                IF not "Purch. Detraction" then begin
                    Validate("Purch. % Detraction", 0);
                    Validate("Type of Operation", '');
                    Validate("Type of Service", '');
                end;
            end;
        }
        field(51004; "Purch. % Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. % Detraction', Comment = 'ESM="% Detracción"';
            trigger OnValidate()
            var
                myInt: Integer;
                lclPurchAmtDetracc: Decimal;
                lclPurchAmtDetraccLCY: Decimal;
            begin
                CLEAR(DetracCalculation);
                DetracCalculation.CalcDetraction(Rec, lclPurchAmtDetracc, lclPurchAmtDetraccLCY);
                "Purch. Amount Detraction" := lclPurchAmtDetracc;
                "Purch Amount Detraction (DL)" := lclPurchAmtDetraccLCY;
            end;
        }
        field(51005; "Purch. Detraction Operation"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Detraction Operation', Comment = 'ESM="Detracción Operación"';
        }
        field(51006; "Purch. Amount Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Detraction', Comment = 'ESM="Importe detracción"';

            trigger OnValidate()
            var
                myInt: Integer;
                lclPurchAmtDetracc: Decimal;
            begin
                CLEAR(DetracCalculation);
                DetracCalculation.ValidateDetractionAmounts(Rec, lclPurchAmtDetracc);
                VALIDATE("Purch. Amount Detraction", lclPurchAmtDetracc);
            end;
        }
        field(51007; "Purch Date Detraction"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'Detraction Date', Comment = 'ESM="Fecha Detracción"';
        }
        field(51008; "Type of Service"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type of service', Comment = 'ESM="Tipo de servicio"';
            trigger OnValidate()
            begin
                DetracCalculation.ValidateTypeOfService(Rec, "Type of Service", "Purch. % Detraction", FALSE);
                VALIDATE("Purch. % Detraction", "Purch. % Detraction");
                DetracCalculation.CalcDetraction(Rec, "Purch. Amount Detraction", "Purch Amount Detraction (DL)");

            end;

            trigger OnLookup()
            var
                lclParTypeOfServices: Text;
                lclPurchDetracc: Decimal;
            begin
                CLEAR(DetracCalculation);
                DetracCalculation.ValidateTypeOfService(Rec, lclParTypeOfServices, lclPurchDetracc);
                VALIDATE("Type of Service", lclParTypeOfServices);
                VALIDATE("Purch. % Detraction", lclPurchDetracc);
            end;
        }
        field(51009; "Type of Operation"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Type of operation', Comment = 'ESM="Tipo de operación"';
            TableRelation = "Detraction Services Operation".Code where("Type Services/Operation" = const(1));

            trigger OnLookup()
            var
                myInt: Integer;
                lclTypeOfOperation: Text;
            begin
                CLEAR(DetracCalculation);
                DetracCalculation.ValidateTypeOfOperation(Rec, lclTypeOfOperation);
                VALIDATE("Type of Operation", lclTypeOfOperation)
            end;
        }
        field(51010; "Purch Amount Detraction (DL)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Amount Detraction LCY', Comment = 'ESM="Importe detracción DL"';
            trigger OnValidate()
            var
                myInt: Integer;
                lclPurchAmtDetracc: Decimal;
            begin
                CLEAR(DetracCalculation);
                DetracCalculation.ValidateDetractionAmounts(Rec, lclPurchAmtDetracc);
                VALIDATE("Purch. Amount Detraction", lclPurchAmtDetracc);
            end;
        }
        modify("Applies-to Doc. No.")
        {
            trigger OnBeforeValidate()
            begin
                if not HideValidation then
                    if "Purch. Detraction" then
                        TestField("Purch. Detraction", false);
                if "Applies-to Doc. No." = '' then
                    "Applies-to Entry No." := 0;
            end;
        }
        //Detracc End

        //Retentions Begin
        field(51091; "RET Invoice Retention"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Invoice Retention', Comment = 'ESM="Factura Retención"';
        }
        field(51092; "RET"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        //Retentions End

        //Ubigeo Begin
        modify("Pay-to County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Pay-to City"), "Departament Code" = field("Pay-to Post Code"));
        }
        modify("Ship-to County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Ship-to City"), "Departament Code" = field("Ship-to Post Code"));
        }
        modify("Buy-from County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Buy-from City"), "Departament Code" = field("Buy-from Post Code"));
        }
        //Ubigeo End

        //Retention RH Begin
        field(51020; "Retention RH Gross amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Gross Amount', Comment = 'ESM="Importe bruto"';
        }
        field(51021; "Retention RH Fourth Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Fourth Amount', Comment = 'ESM="Importe 4ta"';
        }
        field(51022; "Retention RH Electronic"; Boolean)
        {
            Caption = 'Retention RH Electronic', Comment = 'ESM="Retención Electrónica RH"';
            DataClassification = ToBeClassified;
        }
        field(51060; "RH Suspension"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'RH Suspension', Comment = 'ESM="Suspención RH"';
        }
        field(51061; "RH Suspension Date"; Date)
        {
            DataClassification = ToBeClassified;
            Caption = 'RH Suspension Date', Comment = 'ESM="Fecha suspención RH"';
        }
        field(51062; "RH Suspension Number"; Text[30])
        {
            DataClassification = ToBeClassified;
            Caption = 'RH Suspension Number', Comment = 'ESM="Número suspención RH"';
        }
        //Retention RH End

        //Import Begin
        modify("Vendor Posting Group")
        {
            trigger OnAfterValidate()
            begin
                ImportCalculation.ValidateChangeinVPG(Rec);
            end;
        }
        modify("Area")
        {
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('11'));
        }

        field(51018; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESM="N° Importación"';
            TableRelation = Importation;
            trigger OnValidate()
            var
                Importation: Record Importation;
                OK: Boolean;
            begin
                Importation.Get("Importation No.");
                if Importation.Status = Importation.Status::Closed then
                    Message('El documento debe estar abierto para continuar con el proceso');
                Importation.TestField(Status, Importation.Status::Open);

            end;
        }

        field(51014; "Nationalization"; Option)
        {
            DataClassification = ToBeClassified;
            Caption = 'Nationalization', Comment = 'ESM="Nacionalización"';
            OptionMembers = " ",Yes,No;
            OptionCaption = ' ,Yes,No', Comment = 'ESM=" ,Sí,No"';
        }
        field(51015; "Income Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Income Type', Comment = 'ESM="Tipo de ingresos"';
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('31'));
        }
        field(51016; "Service Provided Mode"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Provider Mode', Comment = 'ESM="Modo de proveedor de servicios"';
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('32'));

        }
        field(51017; "Exemptions from Operations"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Exemptions from Operations', Comment = 'ESM="Exenciones de operaciones"';
            TableRelation = "Legal Document"."Legal No." WHERE("Option Type" = filter("SUNAT Table"), "Type Code" = filter('33'));
        }
        field(51070; "Destinacion"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Destination', Comment = 'ESM="Destino"';
            TableRelation = "Master Data".Code WHERE("Type Table" = filter('COM-EXT-DEST'));
            ValidateTableRelation = false;
        }
        field(51071; "Modality"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Modality', Comment = 'ESM="Modalidad"';
            TableRelation = "Master Data".Code WHERE("Type Table" = filter('COM-EXT-MOD'));
            ValidateTableRelation = false;
        }
        field(51072; "Via transport"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Via transport', Comment = 'ESM="Vía transporte"';
            TableRelation = "Master Data".Code WHERE("Type Table" = filter('COM-EXT-TRANSP'));
            ValidateTableRelation = false;
        }
        field(51073; "Shipping Method"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Shipping Method', Comment = 'ESM="Forma de envío"';
            TableRelation = "Master Data".Code WHERE("Type Table" = filter('COM-EXT-SHIPMET'));
            ValidateTableRelation = false;
        }
        field(51074; "Exclude Validation"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Exclude Validation', Comment = 'ESM="Excluir validación"';
        }
        field(51075; "Excede Presupuesto contable"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Excede Presupuesto contable', Comment = 'ESM="Excede Presupuesto contable"';
        }
        //Import End

        //Request Purchase
        field(51023; "PR Purchase Request"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Purchase Request', Comment = 'ESM="Compra genérica"';
        }
        modify("Buy-from Vendor No.")
        {
            trigger OnAfterValidate()
            begin
                ValidateVendorGenericPurchase(Rec);
            end;
        }
        field(51024; "Payment Bank Account No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Vendor Bank Account".Code where("Vendor No." = field("Pay-to Vendor No."));
            Caption = 'Payment Bank Account No.', Comment = 'ESM="N° banco de pago"';
        }

    }
    trigger OnAfterModify()
    begin
        if "Applies-to Doc. No." = '' then
            "Applies-to Entry No." := 0;
    end;

    trigger OnBeforeInsert()
    var
    begin
        ValidateVendorGenericPurchase(Rec);
    end;

    trigger OnInsert()
    begin
        "Legal Document" := '09';
    end;

    var
        DetracCalculation: Codeunit "Detraction Calculation";
        NoSeries: Record "No. Series";
        LegalDocMgt: Codeunit "Legal Document Management";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ImportCalculation: Codeunit "Importation Calculation";
        HideValidation: Boolean;

    local procedure SetPostingSerieNo()
    begin
        NoSeries.Reset();
        NoSeries.SetRange("Operation Type", NoSeries."Operation Type"::Purchase);
        NoSeries.SetRange("Legal Document", "Legal Document");
        //NoSeries.SetRange("Legal Status", "Legal Status");
        NoSeries.SetRange("Internal Operation", "Legal Status" = "Legal Status"::OutFlow);
        if NoSeries.FindFirst() then
            "Posting No. Series" := NoSeries.Code;
    end;

    //ULN::PC 001  2020.06.05 v.001 End
    local procedure FactorByApplicationPurchases(pManualDocumentRef: Boolean)
    var
        lcPurchInvHeaderTemp: Record "Purch. Inv. Header" temporary;
        lcPurchInvHeader: Record "Purch. Inv. Header";
        lcPurchLine: Record "Purchase Line";
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
    begin
        case pManualDocumentRef of
            true:
                begin
                    if Rec."Applies-to Document Date Ref." <> 0D THEN
                        CurrencyDate := "Applies-to Document Date Ref."
                    else
                        CurrencyDate := "Document Date";

                    "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
                    Message('Divisa Actualizada a la fecha %1', CurrencyDate);
                end;
            false:
                begin
                    lcPurchInvHeader.Reset();
                    lcPurchInvHeader.SetRange("No.", "Applies-to Doc. No. Ref.");
                    if lcPurchInvHeader.FindFirst() then begin
                        Rec."Currency Factor" := lcPurchInvHeader."Currency Factor";
                        Rec.Modify();
                        Message('Divisa Actualizada a la fecha %1', lcPurchInvHeader."Document Date");
                    end;
                end;
        end;
    end;

    local procedure FactorByPostingDatePurchases()
    var
        lcPurchHeader: Record "Purchase Header";
        lcPurchHeaderTemp: Record "Purchase Header" temporary;
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
    begin
        if (xRec."Currency Code" = Rec."Currency Code") and (xRec."Applies-to Document Date Ref." = Rec."Applies-to Document Date Ref.") then
            exit;
        if "Document Date" <> 0D then
            CurrencyDate := "Document Date"
        else
            CurrencyDate := "Posting Date";
        "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        Message('Divisa Actualizada a la fecha %1', CurrencyDate);
    end;
    //ULN::PC 001  2020.06.05 v.001 End

    //Request Purchase
    local procedure ValidateVendorGenericPurchase(pRecPurchaseHeader: Record "Purchase Header")
    var
        Vendor: Record Vendor;
        Text001: Label 'Vendor No.: %1, cannot generate Purchase order', Comment = 'ESM="N° Proveedor: %1, no puede generar pedido de compra"';
    begin
        if pRecPurchaseHeader."Document Type" = pRecPurchaseHeader."Document Type"::Order then begin
            Vendor.Reset();
            Vendor.SetRange("No.", pRecPurchaseHeader."Buy-from Vendor No.");
            Vendor.SetRange("PR Generic Purchase", true);
            if Vendor.FindFirst() then begin
                Message(Text001, pRecPurchaseHeader."Buy-from Vendor No.");
                pRecPurchaseHeader."Buy-from Vendor No." := '';
                pRecPurchaseHeader.Modify();
                exit;
            end;
        end;
    end;

    procedure SetHideValidation(pHideValidation: Boolean)
    begin
        HideValidation := pHideValidation;
    end;
}