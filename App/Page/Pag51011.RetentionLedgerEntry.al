page 51011 "Retention Ledger Entry"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Retention Ledger Entry";
    Editable = false;
    Caption = 'Retention Ledger Entry', Comment = 'ESM="Mov. Retención"';
    layout
    {
        area(Content)
        {
            repeater(RetentionRepeater)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Retention Legal Document"; Rec."Retention Legal Document")
                {
                    ApplicationArea = All;
                }
                field("Retention No."; Rec."Retention No.")
                {
                    ApplicationArea = All;
                }
                field("Retention Posting Date"; Rec."Retention Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Legal Status"; "Legal Status")
                {
                    ApplicationArea = All;
                }
                field("Amount Retention"; Rec."Amount Retention")
                {
                    ApplicationArea = All;
                }
                field("Amount Retention LCY"; Rec."Amount Retention LCY")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid"; Rec."Amount Paid")
                {
                    ApplicationArea = All;
                }
                field("Amount Paid LCY"; Rec."Amount Paid LCY")
                {
                    ApplicationArea = All;
                }
                field("Amount Invoice"; Rec."Amount Invoice")
                {
                    ApplicationArea = All;
                }
                field("Amount Invoice LCY"; Rec."Amount Invoice LCY")
                {
                    ApplicationArea = All;
                }
                field("Manual Retention"; "Manual Retention")
                {
                    ApplicationArea = All;
                }
                field("Source Document No."; "Source Document No.")
                {
                    ApplicationArea = All;
                }
                field(Reversed; Rec.Reversed)
                {
                    ApplicationArea = All;
                }
                field("Reversion Date"; Rec."Reversion Date")
                {
                    ApplicationArea = All;
                }
                field("Reversion Motive"; Rec."Reversion Motive")
                {
                    ApplicationArea = All;
                }
                field("Elec. Response Description"; Rec."Elec. Response Description")
                {
                    ApplicationArea = All;
                    Visible = ShowElectronic;
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Navigation)
        {
            //Caption = '&Navigate',Comment = 'ESM="Navegar"';
            action(Navigate)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Navigate', Comment = 'ESM="Navegar"';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    NavigateDoc;
                end;
            }
            action(Detailed)
            {
                ApplicationArea = All;
                Caption = 'Detailed', Comment = 'ESM="Detallado"';
                Image = ViewDetails;
                RunObject = page "Detailed Retention Ledg. Entry";
                RunPageLink = "Retention No." = field("Retention No.");
            }
            action(RetentionReport)
            {
                ApplicationArea = All;
                Caption = 'Retention Report', Comment = 'ESM="Reporte Retenciones"';
                Image = Report;
                RunObject = report "RET Retention Report";
            }
            action(UnApply)
            {
                ApplicationArea = All;
                Caption = 'Desliquidar', Comment = 'ESM="Desliquidar"';
                Image = UnApply;
                trigger OnAction()
                var
                    VendEntryApplyPostedEntries: Codeunit "VendEntry-Apply Posted Entries";
                    VendLE: Record "Vendor Ledger Entry";
                begin
                    VendLE.Reset();
                    VendLE.SetRange("Vendor No.", "Vendor No.");
                    VendLE.SetRange("Document No.", "Source Document No.");
                    if VendLE.FindFirst() then
                        VendEntryApplyPostedEntries.UnApplyVendLedgEntry(VendLE."Entry No.");
                end;
            }
        }
        area(Processing)
        {
            //Caption = '&Processing',Comment = 'ESM="Procesamiento"';
            group(RetentionActions)
            {
                Caption = 'Retention Action', Comment = 'ESM="Rentenciones"';
                action(Extornar)
                {
                    ApplicationArea = All;
                    Caption = 'Correct Ext.', Comment = 'ESM="Extornar"';
                    Image = Cancel;
                    trigger OnAction()
                    var
                        lcRetencionNo: Code[20];
                    begin
                        if Rec.IsEmpty then
                            exit;
                        if Rec.Reversed then
                            Error('La retención tiene el estado revertido.');

                        lcRetencionNo := Rec."Retention No.";
                        CorrectPostedDocument.RenameRetentionDocument(lcRetencionNo, Rec."Entry No.");
                        CurrPage.Update();
                        Message('Retención N° %1 anulada correctamente.', lcRetencionNo);
                    end;
                }

                action(ElectronicReversed)
                {
                    ApplicationArea = All;
                    Caption = 'Reverse Retention', Comment = 'ESM="Reversión Retención"';
                    Image = Cancel;
                    trigger OnAction()
                    var
                        VendLE: Record "Vendor Ledger Entry";
                    begin
                        VendLE.Reset();
                        VendLE.SetRange("Document No.", "Source Document No.");
                        VendLE.SetRange("Vendor No.", "Vendor No.");
                        VendLE.SetRange(Open, false);
                        if VendLE.FindFirst() then
                            Error('Debe de desliquidar la retención antes de revertir el documento.');
                        ReverseRetention(Rec);
                    end;
                }
            }
            /*
            group(GroupPDT626)
            {
                Caption = 'PDT 626';
                action(PDT626)
                {
                    ApplicationArea = All;
                    Caption = 'PDT - 626';
                    Image = Export1099;
                    trigger OnAction()
                    begin
                        RetentionMgt.CreatePDT626();
                    end;
                }
                action(ShowFilesPDT626)
                {
                    ApplicationArea = All;
                    Caption = 'Show File PDT', Comment = 'ESM="Mostrar Archivo PDT"';
                    Image = Table;
                    RunObject = page "ST Control File List";
                    RunPageLink = "File ID" = const('0626');
                }
            }
*/
        }
    }

    trigger OnOpenPage()
    begin
        SLSetup.Get();
        ShowElectronic := SLSetup."Retention Agent Option" in [SLSetup."Retention Agent Option"::"Only Electronic", SLSetup."Retention Agent Option"::"Physical and Electronics"];
    end;

    procedure NavigateDoc()
    var
        NavigatePage: Page Navigate;
    begin
        NavigatePage.SetDoc("Retention Posting Date", "Source Document No.");
        NavigatePage.SetRec(Rec);
        NavigatePage.Run;
    end;

    local procedure ReverseRetention(RetentionLE: Record "Retention Ledger Entry")
    var
        VendorLE: Record "Vendor Ledger Entry";
        Vendor: Record Vendor;
        UserSetup: Record "User Setup";
        Num: Integer;
        j_line: Record "Gen. Journal Line";
        SetupLoca: Record "Setup Localization";
        ImporteProvRet: Decimal;
        BoolCurrencyCode: Boolean;
        Diario: Code[20];
        Seccion: Code[20];
    begin
        SetupLoca.Get();
        Diario := SetupLoca."Retention Journal Template";
        Seccion := SetupLoca."Retention Journal Batch";
        BoolCurrencyCode := false;
        VendorLE.RESET;
        VendorLE.SetRange("Vendor No.", RetentionLE."Vendor No.");
        VendorLE.SetRange("Document No.", RetentionLE."Source Document No.");
        VendorLE.SetRange(Open, true);
        VendorLE.SetAutoCalcFields("Remaining Amount");
        IF VendorLE.FINDSET THEN
            REPEAT
                if VendorLE."Currency Code" <> '' then
                    BoolCurrencyCode := true;
                Vendor.GET(VendorLE."Vendor No.");
                Vendor.TestField(Blocked, Vendor.Blocked::" ");
                UserSetup.GET(USERID);
                Num := Num + 1000;
                j_line.INIT;
                j_line."Journal Template Name" := Diario;
                j_line."Journal Batch Name" := Seccion;
                j_line."Line No." := Num;
                //    j_line."Document Type":=j_line."Document Type"::Payment;
                j_line."Posting Date" := TODAY;
                j_line."Document Date" := TODAY;
                j_line."Account Type" := j_line."Account Type"::Vendor;
                j_line.VALIDATE("Account No.", VendorLE."Vendor No.");
                j_line.Description := VendorLE.Description;
                j_line.VALIDATE("Applies-to Doc. No.", VendorLE."Document No.");
                j_line.VALIDATE("Posting Group", VendorLE."Vendor Posting Group");
                j_line."Applies-to Doc. Type" := VendorLE."Document Type";
                j_line."Document No." := VendorLE."Document No.";
                j_line."External Document No." := VendorLE."External Document No.";
                j_line.VALIDATE(Amount, -VendorLE."Remaining Amount");
                ImporteProvRet += -VendorLE."Remaining Amount";
                //  j_line."Amount (LCY)" :=-Importe;
                j_line."Source Code" := 'DIAPAGOS';
                j_line.VALIDATE("Dimension Set ID", VendorLE."Dimension Set ID");
                j_line."Posting Text" := VendorLE."Posting Text";
                j_line."Applies-to Entry No." := VendorLE."Entry No.";
                j_line.INSERT;
                if VendorLE."Retention No." <> '' then begin
                    j_line.INIT;
                    Num := Num + 1000;
                    j_line."Journal Template Name" := Diario;
                    j_line."Journal Batch Name" := Seccion;
                    j_line."Line No." := Num;
                    j_line."Posting Date" := TODAY;
                    //  j_line."Document Date":=CustLedgerEntry."Document Date";
                    j_line."Account Type" := j_line."Account Type"::"G/L Account";
                    j_line.VALIDATE("Account No.", SetupLoca."Retention G/L Account No.");
                    j_line.Description := 'REVERSION DE RETENCION' + VendorLE."Document No.";
                    j_line."Document No." := VendorLE."Document No.";
                    j_line."External Document No." := VendorLE."External Document No.";
                    j_line.VALIDATE(Amount, VendorLE."Retention Amount" * SetupLoca."Retention Percentage %" / 100);
                    ImporteProvRet += VendorLE."Retention Amount" * SetupLoca."Retention Percentage %" / 100;
                    j_line."Source Code" := 'DIACOBROS';
                    //  j_line."Payment Terms Code":=CustLedgerEntry."Payment Terms Code";
                    //  j_line.VALIDATE("Dimension Set ID",CustLedgerEntry."Dimension Set ID");
                    j_line."Posting Text" := 'REVERSION DE RETENCION' + VendorLE."Document No.";
                    j_line.INSERT;
                end;
            UNTIL VendorLE.NEXT = 0;
        j_line.INIT;
        Num := Num + 1000;
        j_line.INIT;
        j_line."Journal Template Name" := Diario;
        j_line."Journal Batch Name" := Seccion;
        j_line."Line No." := Num;
        //    j_line."Document Type":=j_line."Document Type"::Payment;
        j_line."Posting Date" := TODAY;
        j_line."Document Date" := TODAY;
        j_line."Account Type" := j_line."Account Type"::Vendor;
        j_line.VALIDATE("Account No.", RetentionLE."Vendor No.");
        j_line.Description := 'PROVISION DE RETENCION' + RetentionLE."Retention No.";
        if not BoolCurrencyCode then
            j_line.VALIDATE("Posting Group", SetupLoca."Rev. Ret. Posting Group MN")
        else
            j_line.VALIDATE("Posting Group", SetupLoca."Rev. Ret. Posting Group ME");
        j_line."Document No." := RetentionLE."Source Document No.";
        j_line."External Document No." := VendorLE."External Document No.";
        j_line.VALIDATE(Amount, -ImporteProvRet);
        //  j_line."Amount (LCY)" :=-Importe;
        j_line."Source Code" := 'DIAPAGOS';
        j_line."Posting Text" := 'REVERSION DE RETENCION' + RetentionLE."Retention No.";
        j_line.INSERT;
    end;


    var
        SLSetup: Record "Setup Localization";
        RetentionMgt: Codeunit "Retention Management";
        ShowElectronic: Boolean;
        CorrectPostedDocument: Codeunit "LD Correct Posted Documents";

}