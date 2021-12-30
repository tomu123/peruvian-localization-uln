page 51001 "Accountant Book"
{
    PageType = List;
    ApplicationArea = All;
    Caption = 'Accountant Book', Comment = 'ESM="Libros contables"';
    UsageCategory = Lists;
    SourceTable = "Accountant Book";

    layout
    {
        area(Content)
        {
            repeater(ListRepeater)
            {
                IndentationColumn = IdentationColumAB;
                IndentationControls = "Book Code";
                FreezeColumn = "Book Name";
                ShowAsTree = true;

                field("Book Code"; Rec."Book Code")
                {
                    ApplicationArea = All;
                }
                field("Book Name"; Rec."Book Name")
                {
                    ApplicationArea = All;
                }
                field("Format DateTime"; Rec."Format DateTime")
                {
                    ApplicationArea = All;
                }
                field("Report ID"; Rec."Report ID")
                {
                    ApplicationArea = All;
                }
            }
            group(EBooksFiles)
            {
                Caption = 'Ebooks Files', Comment = 'ESM="Libro Electrónicos"';
                part(LinesFiles; "ST Control File List")
                {
                    ApplicationArea = All;
                    SubPageLink = "File ID" = field("EBook Code");
                    SubPageView = WHERE("Entry Type" = FILTER(<> "Recaudación"));
                }
            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {

            action(PrintBooks)
            {
                ApplicationArea = All;
                Caption = 'Books', Comment = 'ESM="Libros Físicos"';
                Promoted = true;
                PromotedIsBig = true;
                Image = PrintReport;

                trigger OnAction()
                begin
                    if not Rec.IsEmpty then
                        if Rec."Report ID" <> 0 then
                            Report.RunModal(Rec."Report ID", true, true)
                        else
                            Message(MsgNotPrintFormat);
                end;
            }
            action(EBooks)
            {
                ApplicationArea = All;
                Caption = 'E-Books', Comment = 'ESM="Libros Electrónicos"';
                Promoted = true;
                PromotedIsBig = true;
                Image = ElectronicDoc;

                trigger OnAction()
                var
                    AccBookMgt: Codeunit "Accountant Book Management";
                    Page6520: page 6520;
                begin
                    case Rec."EBook Code" of
                        '501', '503', '601':
                            AccBookMgt.GenJournalBooks(Rec."EBook Code", true);
                        '801', '802':
                            AccBookMgt.PurchaserRecord(Rec."EBook Code", true);
                        '1401':
                            AccBookMgt.SalesRecord(Rec."EBook Code", true);
                    end;
                end;
            }
            action(CreateLines)
            {
                ApplicationArea = All;
                Caption = 'Create Lines', Comment = 'ESM="Crear lineas"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    Page43: Page 43;
                    AccountantBookMgt: Codeunit "Accountant Book Management";
                begin
                    AccountantBookMgt.InitializeConfigurationAccountantBook();
                end;
            }
            action(CopyLines)
            {
                ApplicationArea = All;
                Caption = 'Copy Lines', Comment = 'ESM="Copiar lineas"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    AccountantBookMgt: Codeunit "Accountant Book Management";
                begin
                    AccountantBookMgt.CopyConfigurationAccountantBook();
                end;
            }
            action("Actualizar cuentas de movs.")
            {
                ApplicationArea = All;
                Caption = '"Actualizar cuentas de movs', Comment = 'ESM=""Actualizar cuentas de movs"';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    lcRecEmployeeLedgerEntry: Record "Employee Ledger Entry";
                    lclRecVendorLedgerEntry: Record "Vendor Ledger Entry";
                    lclCustLedgerEntry: Record "Cust. Ledger Entry";
                    lclRecEmployeePostingGroup: Record "Employee Posting Group";
                    lclRecVendorPostingGroup: Record "Vendor Posting Group";
                    lclRecCustomerPostingGroup: Record "Customer Posting Group";
                begin
                    lcRecEmployeeLedgerEntry.Reset();
                    lcRecEmployeeLedgerEntry.SetFilter("Payables Account", '%1', '');
                    if lcRecEmployeeLedgerEntry.FindSet() then
                        repeat
                            if lclRecEmployeePostingGroup.get(lcRecEmployeeLedgerEntry."Employee Posting Group") then begin
                                lcRecEmployeeLedgerEntry."Payables Account" := lclRecEmployeePostingGroup."Payables Account";
                                lcRecEmployeeLedgerEntry.Modify();
                            end;
                        until lcRecEmployeeLedgerEntry.Next() = 0;


                    lclRecVendorLedgerEntry.Reset();
                    lclRecVendorLedgerEntry.SetFilter("Payables Account", '%1', '');
                    if lclRecVendorLedgerEntry.FindSet() then
                        repeat
                            if lclRecVendorPostingGroup.get(lclRecVendorLedgerEntry."Vendor Posting Group") then begin
                                lclRecVendorLedgerEntry."Payables Account" := lclRecVendorPostingGroup."Payables Account";
                                lclRecVendorLedgerEntry.Modify();
                            end;
                        until lclRecVendorLedgerEntry.Next() = 0;

                    lclCustLedgerEntry.Reset();
                    lclCustLedgerEntry.SetFilter("Receivables Account", '%1', '');
                    if lclCustLedgerEntry.FindSet() then
                        repeat
                            if lclRecCustomerPostingGroup.get(lclCustLedgerEntry."Customer Posting Group") then begin
                                lclCustLedgerEntry."Receivables Account" := lclRecCustomerPostingGroup."Receivables Account";
                                lclCustLedgerEntry.Modify();
                            end;
                        until lclCustLedgerEntry.Next() = 0;
                    Message('Movs. Actualizados');
                end;
            }
        }
    }

    var
        IdentationColumAB: Integer;
        MsgNotPrintFormat: Label 'The book does not have a printed representation.', Comment = 'ESM="El libro no tiene una reporte asociado"';

    trigger OnAfterGetRecord()
    begin
        IdentationColumAB := Rec.Level;
    end;
}