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
                    Caption = 'Electronic Reverse', Comment = 'ESM="Reversión Electrónica"';
                    Image = Cancel;
                    trigger OnAction()
                    begin
                        if Rec.IsEmpty then
                            exit;
                        if Rec.Reversed then
                            Error('La retención tiene el estado revertido.');
                        Error('Proveedor de facturación electrónica no seleccionado.');
                        Rec.Validate(Reversed, true);
                        Rec.Modify();
                        Message('Retención N° %1 anulada correctamente.', Rec."Retention No.");
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




    var
        SLSetup: Record "Setup Localization";
        RetentionMgt: Codeunit "Retention Management";
        ShowElectronic: Boolean;
        CorrectPostedDocument: Codeunit "LD Correct Posted Documents";

}