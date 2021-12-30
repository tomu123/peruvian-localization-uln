page 51026 "Posted Payment Schedule"
{
    Editable = false;
    Caption = 'Posted Payment Schedule', Comment = 'ESM="Hist. Cronograma de Pagos"';
    PageType = List;
    SourceTable = "Posted Payment Schedule";
    SourceTableView = WHERE(Status = FILTER(Pagado));
    UsageCategory = Lists;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No. Post"; "Document No. Post")
                {
                    ApplicationArea = All;
                    //StyleExpr = StyleText;
                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                }
                field("Business Name"; "Business Name")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Receipt Date"; "Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Delay Days"; "Delay Days")
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Amount LCY"; "Amount LCY")
                {
                    ApplicationArea = All;
                }
                field("Total a Pagar"; "Total a Pagar")
                {
                    ApplicationArea = All;
                }
                field("Preferred Bank Account Code"; "Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Calculate Date"; "Calculate Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Fecha Banco"; BankLedgEntryPostingDate)
                {
                    ApplicationArea = All;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                }
                field("gAccountBankNation"; "gAccountBankNation")
                {
                    Caption = 'Cód. Cuenta Banco de la Nación Proveedor', Comment = 'ESM="Cód. Cuenta Banco de la Nación Proveedor"';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Process Date"; "Process Date")
                {
                    ApplicationArea = All;
                }
                field("Reversed Vendor"; "Reversed Vendor")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Source Currency Factor" := Rec."Source Currency Factor";
                    end;

                    trigger OnDrillDown()
                    begin
                        Rec."Source Currency Factor" := Rec."Source Currency Factor";
                    end;
                }
                field("Reversed Employee"; "Reversed Employee")
                {
                    ApplicationArea = All;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Source Currency Factor" := Rec."Source Currency Factor";
                    end;

                    trigger OnDrillDown()
                    begin
                        Rec."Source Currency Factor" := Rec."Source Currency Factor";
                    end;
                }
                field("Type Source"; "Type Source")
                {
                    ApplicationArea = All;
                }
                field("Source User Id."; "Source User Id.")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Navegar)
            {
                ApplicationArea = All;
                Caption = 'Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    Navigate: Page Navigate;
                    lcTxtMenu: Text;
                    lcIntSelected: Integer;
                    PostingDate: Date;
                    GLEntry: Record "G/L Entry";
                begin
                    lcIntSelected := 0;
                    IF "Document No. Post" <> '' THEN
                        lcTxtMenu += 'N° Documento Reg.,';
                    IF STRLEN(lcTxtMenu) > 0 THEN
                        lcTxtMenu := COPYSTR(lcTxtMenu, 1, STRLEN(lcTxtMenu) - 1);

                    IF STRLEN(lcTxtMenu) > 0 THEN BEGIN
                        GLEntry.SetRange("Document No.", "Document No. Post");
                        if GLEntry.FindFirst() then
                            PostingDate := GLEntry."Posting Date";
                        lcIntSelected := STRMENU(lcTxtMenu, 1, 'Seleccione documento a navegar:');
                        CASE lcIntSelected OF
                            1:
                                BEGIN
                                    Navigate.SetDoc(PostingDate, "Document No. Post");
                                    Navigate.RUN;
                                END;
                        END;
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        BankLedgEntryPostingDate := 0D;
        GetBank();
        fnGetVendorInfo;
    end;



    var
        BankLedgEntryPostingDate: Date;
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        StyleText: Text;
        gAccountBankNation: Text;


    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        //StyleText := 'Favorable';
    end;

    local procedure GetBank();
    begin
        BankAccLedgEntry.RESET;
        BankAccLedgEntry.SETRANGE("Document No.", "Document No. Post");
        IF BankAccLedgEntry.FINDFIRST THEN
            BankLedgEntryPostingDate := BankAccLedgEntry."Posting Date";
    end;

    procedure fnGetVendorInfo()
    var
        lcvendor: Record vendor;
    begin
        gAccountBankNation := '';
        lcvendor.Reset();
        lcvendor.SetRange("VAT Registration No.", "VAT Registration No.");
        if lcvendor.FindFirst() then
            gAccountBankNation := lcvendor."Currenct Account BNAC";

    end;
}

