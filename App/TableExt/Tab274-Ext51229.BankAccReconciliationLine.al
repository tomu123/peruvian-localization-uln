tableextension 51229 "ST Bank AccReconciliation Line" extends "Bank Acc. Reconciliation Line"
{
    fields
    {
        // Add changes to table fields here 51000..51010
        field(51000; "Import Extract The Bank"; Boolean)
        {
            DataClassification = ToBeClassified;
            Caption = 'Imported from bank statement', Comment = 'ESM="Importado desde extracto de banco"';

        }
        field(51001; "EB Statement Line No."; Integer)
        {
            DataClassification = ToBeClassified;
            Caption = 'Statement Line No.', Comment = 'ESM="Nº lín. Extracto de cta. banco"';

        }
        field(51002; "Description 2"; Text[100])
        {
            Caption = 'Description Atria', Comment = 'ESM="Descripción Atria"';
        }
        field(51003; "Suministro No"; Text[50])
        {
            Caption = 'Suministro No', Comment = 'ESM="Suministro No"';
        }
    }

    trigger OnBeforeDelete()
    var
    begin
        fnReviewExtracBank();
    end;


    local procedure fnReviewExtracBank()
    var
        lclRecExtractTheBank: Record "Extract The Bank";
        lcExtracBankError: Label '', Comment = 'ESM=""';
    begin
        lclRecExtractTheBank.Reset();
        lclRecExtractTheBank.SetFilter("Transaction Date", '%1', Rec."Transaction Date");
        lclRecExtractTheBank.SetFilter(Closed, '%1', true);
        lclRecExtractTheBank.SetFilter("Document No.", '%1', Rec."Document No.");
        lclRecExtractTheBank.SetFilter("Bank Account No.", '%1', Rec."Bank Account No.");
        lclRecExtractTheBank.SetFilter("Statement Type", '%1', Rec."Statement Type"::"Bank Reconciliation");
        lclRecExtractTheBank.SetFilter("Statement Line No.", '%1', Rec."EB Statement Line No.");
        lclRecExtractTheBank.SetFilter("Description 2", '%1', Rec."Description 2");
        if lclRecExtractTheBank.FindSet() then
            Error('Mov Cerrado no puede ser eliminado.!');
    end;
}