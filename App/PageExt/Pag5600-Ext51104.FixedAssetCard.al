pageextension 51104 "Setup Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("Invoice Sales No"; "Invoice Sales No")
            {
                Description = 'ULN:PC 18.01.21 Activos Fijos|Amortizaciòn';
                ApplicationArea = All;
            }
        }
        addafter(Maintenance)
        {
            group(SetupLocalization)
            {
                Caption = 'Setup Localization';
                field(FirstField; FirstField)
                {
                    Visible = false;
                    Editable = false;
                }
            }
        }
        //Legal Document Begin
        addafter(General)
        {
            group(Locatization)
            {
                Caption = 'Localization', Comment = 'ESM="Localización"';
                field("Acquisition date"; "Acquisition date")
                {
                    editable = false;
                    ApplicationArea = All;
                }
                field("LD Fixed Asset Type"; "LD Fixed Asset Type")
                {
                    ApplicationArea = All;
                }
                field("LD Fixed Asset Status"; "LD Fixed Asset Status")
                {
                    ApplicationArea = All;
                }
                field("LD Depreciation Method"; "LD Depreciation Method")
                {
                    ApplicationArea = All;
                }
                field("LD Brand"; "LD Brand")
                {
                    ApplicationArea = All;
                }
                field("LD Model"; "LD Model")
                {
                    ApplicationArea = All;
                }
                field("LD Intagible Type"; "LD Intagible Type")
                {
                    ApplicationArea = All;
                    Editable = "LD Intangible Status";
                }
                field("LD Job No."; "LD Job No.")
                {
                    ApplicationArea = All;
                }
                field("LD Job Task No."; "LD Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Current Asset"; "Current Asset")
                {
                    ApplicationArea = All;
                    Caption = 'Current Asset', Comment = 'ESM="Activo en curso"';
                    trigger OnValidate()
                    begin
                        CurrPage.Update();
                    end;
                }
            }
        }
        //Legal Document End
        //Legal Document Begin
        addafter(General)
        {
            group(Atria)
            {
                Caption = 'Atria', Comment = 'ESM="Atria"';
                field("Tag Number"; "Tag Number")
                {
                    ApplicationArea = All;
                }
                field("Country/Region Code"; "Country/Region Code")
                {
                    ApplicationArea = All;
                }
                field("Departament Code"; "Departament Code")
                {
                    ApplicationArea = All;
                }
                field("Province Code"; "Province Code")
                {
                    ApplicationArea = All;
                }
                field("District Code"; "District Code")
                {
                    Caption = 'District', Comment = 'ESM="Distrito"';
                    ApplicationArea = All;
                }
                field("Ubigeo Description "; "Ubigeo Description")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Location; Location)
                {
                    ApplicationArea = All;
                }
                field(Floor; Floor)
                {
                    ApplicationArea = All;
                }
                field(Color; Color)
                {
                    ApplicationArea = All;
                }
                field("Status AF"; "Status AF")
                {
                    ApplicationArea = All;
                }
                field("Length"; "Length")
                {
                    ApplicationArea = All;
                }
                field("Width"; "Width")
                {
                    ApplicationArea = All;
                }
                field("High"; "High")
                {
                    ApplicationArea = All;
                }
                field("Motor"; "Motor")
                {
                    ApplicationArea = All;
                }
                field("Power"; "Power")
                {
                    ApplicationArea = All;
                }
                field("Plate"; "Plate")
                {
                    ApplicationArea = All;
                }
                field("Fabrication date"; "Fabrication date")
                {
                    ApplicationArea = All;
                }
                field("Father Code"; "Father Code")
                {
                    ApplicationArea = All;
                }

                field("ST AF Leasing"; "ST AF Leasing")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                    begin
                        CurrPage.Update();
                    end;
                }
                group("Leasing")
                {
                    Visible = "ST AF Leasing";
                    Enabled = "ST AF Leasing";
                    field("ST Contract No."; "ST Contract No.")
                    {
                        ApplicationArea = All;
                        Visible = "ST AF Leasing";
                        Enabled = "ST AF Leasing";
                    }
                    field("ST Contract Date"; "ST Contract Date")
                    {
                        ApplicationArea = All;
                        Visible = "ST AF Leasing";
                        Enabled = "ST AF Leasing";
                    }
                    field("ST Lease Start Date"; "ST Lease Start Date")
                    {
                        ApplicationArea = All;
                        Visible = "ST AF Leasing";
                        Enabled = "ST AF Leasing";
                    }
                    field("ST Number of Quotas"; "ST Number of Quotas")
                    {
                        ApplicationArea = All;
                        Visible = "ST AF Leasing";
                        Enabled = "ST AF Leasing";
                    }
                    field("ST Amount"; "ST Amount")
                    {
                        ApplicationArea = All;
                        Visible = "ST AF Leasing";
                        Enabled = "ST AF Leasing";
                    }
                }

            }
        }
        //Atria
        modify(DepreciationStartingDate)
        {
            Editable = not gCurrentAsset;
        }
        modify(NumberOfDepreciationYears)
        {
            Editable = not gCurrentAsset;
        }
        modify(DepreciationEndingDate)
        {
            Editable = not gCurrentAsset;
        }
    }
    trigger OnClosePage()
    begin

    end;

    trigger OnOpenPage()
    begin
        fnvalidateClaseFA();
        fnvalidateAcquisitiondate();
    end;

    trigger OnAfterGetRecord()
    begin
        gCurrentAsset := "Current Asset";
    end;

    trigger OnAfterGetCurrRecord()
    begin
        gCurrentAsset := "Current Asset";
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        fnValidateBookAmortizations;
        fnvalidateValuesClaseFA();
    end;

    procedure fnValidateBookAmortizations()
    var
        lcSetupLocalization: Record "Setup Localization";
        lcFADepreciationBook: Record "FA Depreciation Book";
        lclText001: Label 'Activo fijo debe tener configurado el libro de amortización %1', Comment = 'Foo', MaxLength = 999, Locked = true;
    begin
        lcSetupLocalization.get;

        if lcSetupLocalization."Book Amortization Accounting" <> '' then begin
            lcFADepreciationBook.Reset();
            lcFADepreciationBook.SetRange("FA No.", Rec."No.");
            lcFADepreciationBook.SetRange("Depreciation Book Code", lcSetupLocalization."Book Amortization Accounting");
            if not lcFADepreciationBook.FindSet() then
                Error(StrSubstNo(lclText001, lcSetupLocalization."Book Amortization Accounting"));
        end;

        if lcSetupLocalization."Book Amortization tributary" <> '' then begin
            lcFADepreciationBook.Reset();
            lcFADepreciationBook.SetRange("FA No.", Rec."No.");
            lcFADepreciationBook.SetRange("Depreciation Book Code", lcSetupLocalization."Book Amortization tributary");
            if not lcFADepreciationBook.FindSet() then
                Error(StrSubstNo(lclText001, lcSetupLocalization."Book Amortization tributary"));
        end;
    end;

    local procedure fnvalidateAcquisitiondate()
    var
        lcFALedgerEntry: Record "FA Ledger Entry";
        lcPurchInvHeader: Record "Purch. Inv. Header";
    begin
        lcFALedgerEntry.Reset();
        lcFALedgerEntry.SetRange("FA No.", Rec."No.");
        lcFALedgerEntry.SetRange("FA Posting Type", lcFALedgerEntry."FA Posting Type"::"Acquisition Cost");
        lcFALedgerEntry.SetRange("Document Type", lcFALedgerEntry."Document Type"::Invoice);
        if lcFALedgerEntry.FindSet() then begin
            lcPurchInvHeader.Reset();
            lcPurchInvHeader.SetRange("No.", lcFALedgerEntry."Document No.");
            if lcPurchInvHeader.FindSet() then begin
                Rec."Acquisition date" := lcPurchInvHeader."Document Date";
                Rec.Modify();
            end;
        end;
    end;

    local procedure fnvalidateClaseFA()
    var
        FAClass: Record "FA Class";
    BEGIN
        FAClass.Reset();
        FAClass.SetRange(Code, Rec."FA Class Code");
        if FAClass.FindSet() then begin
            case FAClass.Leasing of
                true:
                    begin
                        if not Rec."ST AF Leasing" then begin
                            Rec."ST AF Leasing" := TRUE;
                            CurrPage.Update();
                        end;
                    end;
                false:
                    begin
                        if Rec."ST AF Leasing" then begin
                            Rec."ST AF Leasing" := false;
                            CurrPage.Update();
                        end
                    end;
            end

        end;
    END;

    local procedure fnvalidateValuesClaseFA()
    var
        FAClass: Record "FA Class";
    BEGIN

        if Rec."ST AF Leasing" then begin
            Rec.TestField("ST Contract No.");
            Rec.TestField("ST Contract Date");
            Rec.TestField("ST Lease Start Date");
            Rec.TestField("ST Number of Quotas");

        end;


    END;

    var
        FirstField: Text;
        FADepreciationBook: Record "FA Depreciation Book";
        gCurrentAsset: Boolean;

}