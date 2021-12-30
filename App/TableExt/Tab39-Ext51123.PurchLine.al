tableextension 51123 "Purchase Standar Code" extends "Purchase Line"
{
    fields
    {
        field(51008; "Purchase Standard Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Purch. Standar Code', Comment = 'ESM="Cod. estandar compra"';
            TableRelation = "Standard Purchase Code";
            //Editable = false;
        }
        field(51001; "Importation No."; code[20])
        {
            DataClassification = ToBeClassified;
            Caption = 'Importation No.', Comment = 'ESM="N° Importación"';
            TableRelation = Importation;
            trigger OnValidate()
            var
                Importation: Record Importation;
            begin
                CalcFields("Qty. to Assign");
                if "Qty. to Assign" <> 0 then begin
                    if xRec."Importation No." <> "Importation No." then begin
                        Message('No pueden cambiar el código de importación a una línea ya asignado');
                        Error('No pueden cambiar el código de importación a una línea ya asignado');
                    end;
                end;
                Importation.Get("Importation No.");
                if Importation.Status = Importation.Status::Closed then
                    Message('El estado de la importación debe estar abierta para continuar con el proceso');
                Importation.TestField(Importation.Status, Importation.Status::Open);

            end;
        }

        modify("No.")
        {
            trigger OnAfterValidate()
            begin
                fnValidetaFixedAsset();
            end;
        }
        modify("FA Posting Type")
        {
            trigger OnAfterValidate()
            begin
                if "FA Posting Type" <> Rec."FA Posting Type"::"Acquisition Cost" then
                    "Duplicate in Depreciation Book" := '';
            end;
        }
    }
    procedure fnValidetaFixedAsset()
    var
        lclRecFixedAsset: Record "Fixed Asset";
        lclRecSetupLocalization: Record "Setup Localization";
        lcRecFADepreciationBook: Record "FA Depreciation Book";
    begin

        if Rec.Type <> Rec.Type::"Fixed Asset" then
            exit;

        lclRecSetupLocalization.Get();

        lclRecFixedAsset.Reset();
        lclRecFixedAsset.SetRange("No.", "No.");
        if lclRecFixedAsset.FindSet() then begin

            lcRecFADepreciationBook.Reset();
            lcRecFADepreciationBook.SetRange("FA No.", Rec."No.");
            lcRecFADepreciationBook.SetRange("Depreciation Book Code", lclRecSetupLocalization."Book Amortization tributary");
            if lcRecFADepreciationBook.FindSet() then begin
                "Duplicate in Depreciation Book" := lcRecFADepreciationBook."Depreciation Book Code";

            end;

        end;


        // rec.Modify();
    end;

    var

}