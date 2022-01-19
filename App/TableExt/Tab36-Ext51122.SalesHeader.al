tableextension 51122 "Setup Sales Header" extends "Sales Header"
{
    fields
    {
        // Add changes to table fields here 51050..51059
        //Legal Document Begin
        field(51000; "Legal Document"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Document', Comment = 'ESM="Documento Legal"';
            TableRelation = if ("Document Type" = const("Credit Memo")) "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'), "Legal No." = const('07'))
            else
            "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('10'));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                SerieNo: Code[20];
                NumberNo: Code[20];
            begin
                if "Legal Document" = '' then
                    exit;
                SetPostingSerieNo();
            end;
        }
        field(51001; "Legal Status"; Option)
        {
            DataClassification = CustomerContent;
            Caption = 'Legal Status', Comment = 'ESM="Estado legal"';
            OptionMembers = Success,Anulled,OutFlow;
            OptionCaption = 'Success,Anulled,OutFlow', Comment = 'ESM="Normal,Anulado,Extornado"';
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
            Caption = 'VAT Registration Type', Comment = 'ESM="Tipo Doc. Cliente"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('02'));
            ValidateTableRelation = false;
        }
        field(51012; "Legal Property Type"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Legal Property Type', Comment = 'ESM="Tipo de bien"';
            TableRelation = "Legal Document"."Legal No." where("Option Type" = const("SUNAT Table"), "Type Code" = const('30'));
            ValidateTableRelation = false;
        }
        field(51013; "Ext/Anul. User Id."; Code[50])
        {
            DataClassification = ToBeClassified;
            Caption = 'Ext/Anul. User Id.', Comment = 'ESM="Ext/Anulado por ID. Usuario"';
            TableRelation = User."User Name";
            ValidateTableRelation = false;
        }
        field(51030; "Manual Document Ref."; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Manual Document Ref.', Comment = 'ESM="Documento Manual Ref."';
        }
        field(51031; "Electronic Doc. Ref"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Electronic Doc. Ref.', Comment = 'ESM="Doc. Electrónico Ref."';
        }
        field(51032; "Applies-to Doc. No. Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Doc. No. Ref.', Comment = 'ESM="Liq. por N° Documento Ref."';
            TableRelation = if ("Manual Document Ref." = Const(false)) "Sales Invoice Header"."No." where("Legal Status" = const(Success), "Sell-to Customer No." = field("Sell-to Customer No."));
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                LegalDocMgt: Codeunit "Legal Document Management";
                MySalesInvHeader: Record "Sales Invoice Header";
            begin
                if MySalesInvHeader.get("Applies-to Doc. No. Ref.") then begin
                    Rec.Validate("Applies-to Document Date Ref.", MySalesInvHeader."Document Date");
                    "Legal Document Ref." := MySalesInvHeader."Legal Document";
                end;

                if ("Applies-to Doc. No. Ref." <> '') then
                    LegalDocMgt.ValidateLegalDocumentFormat("Applies-to Doc. No. Ref.",
                                                            '01',
                                                            "Applies-to Serie Ref.",
                                                            "Applies-to Number Ref.",
                                                            false,
                                                            not "Manual Document Ref.");
                //Clear Fields
                if "Applies-to Doc. No. Ref." = '' then begin
                    rec."Applies-to Document Date Ref." := 0D;
                    rec."Applies-to Number Ref." := '';
                    rec."Legal Document Ref." := '';
                    rec."Applies-to Serie Ref." := '';
                    FactorByPostingDateSales();
                end;
            end;
        }
        field(51033; "Applies-to Serie Ref."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Applies-to Serie Ref.', Comment = 'ESM="Liq. serie doc. Ref."';
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
            Caption = 'Applies-to Number Ref.', Comment = 'ESM="Liq. número doc. Ref."';
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
            Caption = 'Applies-to Document Date Ref.', Comment = 'ESM="Liq. Fecha Emisión Ref."';
            trigger OnValidate()
            begin
                FactorByApplicationSales("Manual Document Ref.");
            end;
        }
        //Legal Document End
        field(51050; "Setup Source Code"; Enum "ST Source Code Type")
        {
            DataClassification = ToBeClassified;
            Caption = 'Source Code ULN', Comment = 'ESM="Cód. Origen ULN"';
            //TableRelation = "Master Data".Code where("Type Table" = const('STPSOURCECODE'));
        }
        field(51051; "Posting Text"; Text[250])
        {
            DataClassification = ToBeClassified;
            Caption = 'Posting Text', Comment = 'ESM="Glosa Principal"';
        }
        field(51052; "Setup Source Code to User"; Enum "Source Code to User")
        {
            DataClassification = ToBeClassified;
            Caption = 'Setup Source Code to User', Comment = 'ESM="Cód. Origen Usuario"';
        }
        modify("Posting Description")
        {
            Caption = 'Posting Description', comment = 'ESM="Descripción"';
        }
        //Detracc Begin
        field(51020; "Sales Detraction"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Detraction', Comment = 'ESM="Detracción"';
            trigger OnValidate()
            begin
                case "Sales Detraction" of
                    true:
                        begin
                            if "Legal Document" = '03' then
                                Error(ErrorDetractLegalDoc);
                        end;
                    false:
                        begin
                            "Sales % Detraction" := 0;
                            "Sales Amt Detraction" := 0;
                            "Sales Amt Detraction (LCY)" := 0;
                            "Operation Type Detrac" := '';
                            "Service Type Detrac" := '';
                            "Payment Method Code Detrac" := '';
                        end;
                end;
            end;
        }
        field(51021; "Sales % Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales % Detraction', Comment = 'ESM="% Detracción"';
            trigger OnValidate()
            begin
                GLSetup.Get();
                SalesLine.Reset();
                SalesLine.SetCurrentKey("Document Type", "Document No.", "Location Code");
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange("Location Code");
                SalesLine.CalcSums("Amount Including VAT");

                if Round(("Sales % Detraction" * SalesLine."Amount Including VAT") / 100, GLSetup."Amount Rounding Precision") > SalesLine."Amount Including VAT" then
                    Error(ErrorOverflowAmt);
                if "Currency Code" = '' then
                    "Sales Amt Detraction" := Round(Round(("Sales % Detraction" * SalesLine."Amount Including VAT") / 100, GLSetup."Amount Rounding Precision"), 1, '=')
                else
                    "Sales Amt Detraction" := Round(("Sales % Detraction" * SalesLine."Amount Including VAT") / 100, GLSetup."Amount Rounding Precision");


                if "Currency Code" = '' then
                    "Sales Amt Detraction (LCY)" := Round("Sales Amt Detraction", 1, '=')
                else
                    "Sales Amt Detraction (LCY)" := Round("Sales Amt Detraction" / "Currency Factor", 1, '=');
            end;
        }

        field(51022; "Sales Amt Detraction"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Amt Detraction', Comment = 'ESM="Importe Detracción"';
            trigger OnValidate()
            begin
                GLSetup.Get();
                SalesLine.Reset();
                SalesLine.SetCurrentKey("Document Type", "Document No.", "Location Code");
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange("Location Code");
                SalesLine.CalcSums("Amount Including VAT");

                if "Sales Amt Detraction" > SalesLine."Amount Including VAT" then
                    Error(ErrorOverflowAmt);

                "Sales Amt Detraction" := Round(("Sales % Detraction" * SalesLine."Amount Including VAT") / 100, GLSetup."Amount Rounding Precision");
                if "Currency Code" <> '' then
                    "Sales Amt Detraction" := Round("Sales Amt Detraction" * "Currency Factor", GLSetup."Amount Rounding Precision")
                else
                    "Sales Amt Detraction" := "Sales Amt Detraction";
            end;
        }
        field(51023; "Sales Amt Detraction (LCY)"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Sales Amt Detraction (LCY)', Comment = 'ESM="Importe Detracción (DL)"';
            trigger OnValidate()
            begin
                GLSetup.Get();
                SalesLine.Reset();
                SalesLine.SetCurrentKey("Document Type", "Document No.", "Location Code");
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                SalesLine.SetRange("Location Code");
                SalesLine.CalcSums("Amount Including VAT");

                if "Sales Amt Detraction" > SalesLine."Amount Including VAT" then
                    Error(ErrorOverflowAmt);

                if "Currency Code" <> '' then
                    "Sales Amt Detraction" := Round("Sales Amt Detraction (LCY)" * "Currency Factor", GLSetup."Amount Rounding Precision")
                else
                    "Sales Amt Detraction" := Round("Sales Amt Detraction (LCY)" * 1, GLSetup."Amount Rounding Precision");
            end;
        }
        field(51024; "Operation Type Detrac"; Code[2])
        {
            DataClassification = ToBeClassified;
            Caption = 'Operation Type Detraction', Comment = 'ESM="Tipo de operación"';
            trigger OnLookup()
            begin
                DetractCalculation.ValidateTypeOfOperationSales("Operation Type Detrac");
            end;
        }

        field(51025; "Service Type Detrac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Service Type Detraction', Comment = 'ESM="Tipo de servicio"';
            trigger OnLookup()
            begin
                DetractCalculation.ValidateTypeOfServiceSales("Service Type Detrac", "Sales % Detraction");
                Validate("Service Type Detrac");
                Validate("Sales % Detraction");
            end;
        }
        field(51026; "Payment Method Code Detrac"; Code[10])
        {
            DataClassification = ToBeClassified;
            Caption = 'Payment Method Code Detrac', Comment = 'ESM="Cód. Forma de pago (Detrac.)"';
            TableRelation = "Payment Method";
        }
        //Detracc End

        //Ubigeo Begin
        modify("Sell-to County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Sell-to City"), "Departament Code" = field("Sell-to Post Code"));
        }
        modify("Ship-to County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Ship-to City"), "Departament Code" = field("Ship-to Post Code"));
        }
        modify("Bill-to County")
        {
            TableRelation = Ubigeo."District Code" where("Province Code" = field("Bill-to City"), "Departament Code" = field("Bill-to Post Code"));
        }
        //Ubigeo End

        //Free Title
        field(51015; "FT Free Title"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Free Title', Comment = 'ESM="Título gratuito"';
            trigger OnValidate()
            begin
                FreeTitleMgt.FreeTitleInvoice(Rec);
            end;
        }

        //Internal Consumption
        field(51060; "Internal Consumption"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Internal Consumption', Comment = 'ESM="Consumo Interno"';
        }

        //SUMINISTRO-ATRIA
        field(57100; "Active Supply No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Active Supply No.', Comment = 'ESM="No. Suministro Activo"';
        }
    }

    var
        SalesLine: Record "Sales Line";
        GLSetup: Record "General Ledger Setup";
        NoSeries: Record "No. Series";
        DetractCalculation: Codeunit "DetrAction Calculation";
        FreeTitleMgt: Codeunit "FT Free Title Management";
        LegalDocMgt: Codeunit "Legal Document Management";
        ErrorOverflowAmt: Label 'The detraction cannot exceed the Invoice', Comment = 'ESM="La detracción no de exceder la factura"';
        ErrorDetractLegalDoc: Label 'Can´t be applied to a document type 03', Comment = 'ESM="No puede aplicar un documento tipo 03"';

    local procedure FactorByPostingDateSales()
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin

        Rec."Currency Factor" := CurrExchRate.ExchangeRate(Rec."Posting Date", "Currency Code");
        Message('Divisa Actualizada');
    end;

    local procedure FactorByApplicationSales(pManualDocumentRef: Boolean)
    var

        lcSalesInvHeader: Record "Sales Invoice Header";
        lcSalesLine: Record "Sales Line";
        CurrExchRate: Record "Currency Exchange Rate";
    begin

        case pManualDocumentRef of
            true:
                begin
                    if Rec."Applies-to Document Date Ref." <> 0D THEN
                        Rec."Currency Factor" := CurrExchRate.ExchangeRate(rec."Applies-to Document Date Ref.", "Currency Code")
                    else
                        Rec."Currency Factor" := CurrExchRate.ExchangeRate(rec."Posting Date", "Currency Code");

                    Message('Divisa Actualizada');
                end;

            false:
                begin
                    lcSalesInvHeader.Reset();
                    lcSalesInvHeader.SetRange("No.", "Applies-to Doc. No. Ref.");
                    if lcSalesInvHeader.FindFirst() then begin
                        Rec."Currency Factor" := lcSalesInvHeader."Currency Factor";
                        Rec.Modify();
                        Message('Divisa Actualizada');
                    end;
                end;
        end;
    end;

    procedure SetPostingSerieNo()
    var
        NoSeriesLine: Record "No. Series Line";
    begin
        NoSeries.Reset();
        NoSeries.SetRange("Operation Type", NoSeries."Operation Type"::Sales);
        NoSeries.SetRange("Legal Document", "Legal Document");
        //PC 27.05.21 ++++
        if "Posting No. Series" <> '' then
            NoSeries.SetRange(code, "Posting No. Series");
        //PC 27.05.21 ----
        //NoSeries.SetRange("Legal Status", "Legal Status");
        NoSeries.SetRange("Internal Operation", "Legal Status" = "Legal Status"::OutFlow);
        OnBeforeFilterNoSeries(NoSeries, Rec);
        if NoSeries.FindFirst() then
            "Posting No. Series" := NoSeries.Code;
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeFilterNoSeries(var NoSeries: Record "No. Series"; var SalesHeader: Record "Sales Header")
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"G/L Entry", 'OnAfterCopyGLEntryFromGenJnlLine', '', true, true)]
    procedure SetCopyGLEntryFromGenJnlLine(var GLEntry: Record "G/L Entry"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GLEntry."Legal Document" := GenJournalLine."Legal Document";
        GLEntry."Legal Status" := GenJournalLine."Legal Status";
        GLEntry."Retention No." := GenJournalLine."Retention No.";
    end;
}