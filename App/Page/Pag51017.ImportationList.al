page 51017 "Importation List"
{
    PageType = List;
    Caption = 'Import List';
    CardPageId = "Imports Card";
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = 51009;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Importation Vendor No."; "Importation Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    ApplicationArea = All;
                }
                field("Import Date"; "Import Date")
                {
                    ApplicationArea = All;
                }
                field("Import Manager"; "Import Manager")
                {
                    ApplicationArea = All;
                }
                field("Entry Point"; "Entry Point")
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
                field("Modification Date"; "Modification Date")
                {
                    ApplicationArea = All;
                }
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
                        recItemLedgerEntry: Record "Item Ledger Entry";
                        recImportacionCosteo: Report "Import Costing";
                    begin
                        CLEAR(recItemLedgerEntry);
                        recItemLedgerEntry.SETRANGE("Importation No.", "No.");
                        REPORT.RUNMODAL(REPORT::"Import Costing", TRUE, FALSE, recItemLedgerEntry);


                    end;
                }
                action(Costeo2)
                {
                    ApplicationArea = All;
                    Caption = 'Detailed Costing';
                    Image = Report;
                    trigger OnAction();
                    var
                        Importation: Record Importation;
                    begin
                        Clear(Importation);
                        Importation.SetRange("No.", "No.");
                        Report.RunModal(Report::Import, true, false, Importation);
                    end;
                }
            }

        }
    }
    var
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        SLSetup: Record "Setup Localization";

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        SLSetup.GET();
        "No." := NoSeriesMgt.GetNextNo(SLSetup."Importation No. Series", TODAY, TRUE);
    end;
}