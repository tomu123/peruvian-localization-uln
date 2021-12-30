page 51018 "Imports Card"
{
    PageType = Card;
    SourceTable = Importation;
    ContextSensitiveHelpPage = 'my-feature';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        "#AssistEditMini"(Rec);
                        IF "No." = '' THEN BEGIN
                            SLSetup.GET();
                            "No." := gNoSeriesMng.GetNextNo(SLSetup."Importation No. Series", TODAY, TRUE);
                        END;

                    end;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        VALIDATE(Description, UPPERCASE(Description));
                    end;
                }
                field("Import Date"; "Import Date")
                {
                    ApplicationArea = All;
                }
                field("Import Manager"; "Import Manager")
                {
                    ApplicationArea = All;
                }
                field("Registered Cost (DL)"; "Registered Cost (DL)")
                {
                    ApplicationArea = All;
                }
                field("Transit Cost (LCY)"; "Transit Cost (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Nationalization; Nationalization)
                {
                    ApplicationArea = All;
                }
                field("Entry Point"; "Entry Point")
                {
                    ApplicationArea = All;
                }
            }
            part(ItemLedgerEntries; "Item Ledger Entries")
            {
                SubPageLink = "Importation No." = field("No.");
                UpdatePropagation = SubPart;
                Editable = false;
                Visible = true;
                ApplicationArea = All;

            }
            group("Nuevo Cargo")
            {
                Caption = 'Importation Entyties', Comment = 'ESM="Entidades de Importación"';
                field("Importation Vendor No."; "Importation Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("DUA Vendor No."; "DUA Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Freight Vendor No."; "Freight Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Other Vendor No. 1"; "Other Vendor No. 1")
                {
                    ApplicationArea = All;
                }
                field("Other Vendor No. 2"; "Other Vendor No. 2")
                {
                    ApplicationArea = All;
                }
                field("Perception Vendor No."; "Perception Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Handling"; "Vendor Handling")
                {
                    ApplicationArea = All;
                }

            }

            group(Log)
            {
                field("Quantity Order Transit"; "Quantity Order Transit")
                {
                    ApplicationArea = All;
                }
                field("Quantity Invoices"; "Quantity Invoices")
                {
                    ApplicationArea = All;
                }
                field("User Modify"; "User Modify")
                {
                    ApplicationArea = All;
                }
                field(Hour; Hour)
                {
                    ApplicationArea = All;
                }

            }
            group(Nacionalizacion)
            {
                Caption = 'Nationalization';
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Date Nationalization"; "Date Nationalization")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(FactBoxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }

    }

    actions
    {
        area(Navigation)
        {
            group(Reportes)
            {
                action(Costeo)
                {
                    ApplicationArea = All;
                    Caption = 'Import Costing';
                    Image = Report;
                    trigger OnAction();
                    var
                        ItemLedgerEntry: Record "Item Ledger Entry";
                    begin
                        Clear(ItemLedgerEntry);
                        ItemLedgerEntry.SetRange("Importation No.", "No.");
                        Report.RunModal(Report::"Import Costing", true, false, ItemLedgerEntry);
                    end;
                }
                action(Costeo2)
                {
                    ApplicationArea = All;
                    Caption = 'Cost Detail', Comment = 'ESM="Detalle de costeo"';
                    Image = Report;
                    trigger OnAction();
                    var
                        Imrportation: Record Importation;

                    begin
                        Clear(Imrportation);
                        Imrportation.SetRange("No.", "No.");
                        Report.RunModal(Report::Import, true, false, Imrportation);
                    end;
                }
            }

        }
    }
    procedure Control()
    begin
        IF Status = Status::Closed THEN
            Error('Importacion ' + "No." + ': esta cerrada')

    end;

    procedure Calculate()
    begin
        TESTFIELD(Description);
        TESTFIELD("Import Manager");
        TESTFIELD("Import Date");
        "Real+Esperado" := "Registered Cost (DL)" + "Transit Cost (LCY)";

    end;

    local procedure GetCurrencyCode(pProveedor: Code[20]): code[20]
    var
        lclRecVendor: Record Vendor;
        lclRecVendorPostingGroup: Record "Vendor Posting Group";
    begin
        lclRecVendor.GET(pProveedor);
        lclRecVendorPostingGroup.GET(lclRecVendor."Vendor Posting Group");
        EXIT(lclRecVendorPostingGroup."Currency Code");

    end;

    var
        "Real+Esperado": Decimal;
        headerP: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        recSerieNos: Record "No. Series";
        TEMP: Code[20];
        PurchaseL: Record "Purchase Line";
        "Real+Esperado USD": Decimal;
        Currency: Record "Currency Exchange Rate";
        TIPOCAMBIODELDIA: Decimal;
        gPurchSetup: Record "Purchases & Payables Setup";
        gNoSeriesMng: Codeunit NoSeriesManagement;
        SLSetup: Record "Setup Localization";


}