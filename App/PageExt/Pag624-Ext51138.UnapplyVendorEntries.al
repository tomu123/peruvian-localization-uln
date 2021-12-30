pageextension 51138 "ST Unapply Vendor Entries" extends "Unapply Vendor Entries"
{
    layout
    {
        // Add changes to page layout here
        addafter(PostDate)
        {
            field(VendLedgEntryNo; VendLedgEntryNo)
            {
                ApplicationArea = All;
                Caption = 'Vendor Ledger Entry No.';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addafter(Unapply)
        {
            action(UnapplyUnique)
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Unapply Unique';
                Visible = Unapplied;
                Image = UnApply;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Unselect unique one or more ledger entries that you want to unapply this record.';

                trigger OnAction()
                var
                    STVendEntryApplyPostedEntries: Codeunit "ST VendEntry-Apply Posted Entr";
                    ConfirmManagement: Codeunit "Confirm Management";
                begin
                    if IsEmpty then
                        Error(Text010);
                    if not ConfirmManagement.GetResponseOrDefault(Text011, true) then
                        exit;

                    STVendEntryApplyPostedEntries.PostUnApplyUniqueVendor(DtldVendLedgEntry2, DocNo, PostingDate, FilterVendorLedgerEntryNos);
                    DeleteAll();
                    Message(Text009);

                    CurrPage.Close;
                end;
            }
        }
        modify(Unapply)
        {
            Visible = not Unapplied;
        }
    }

    local procedure InsertEntries()
    var
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        FindFilterVendorLedgerEntries(DtldVendLedgEntry);
        DtldVendLedgEntry.SetRange("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        if DtldVendLedgEntry.FindFirst() then
            Repeat
                if (DtldVendLedgEntry."Vendor Ledger Entry No." = VendLedgEntryNo) OR
                   (DtldVendLedgEntry."Applied Vend. Ledger Entry No." = VendLedgEntryNo) then
                    SetEntryNoToFilter(DtldVendLedgEntry."Entry No.");
            until DtldVendLedgEntry.Next() = 0;
        FindFilterVendorLedgerEntries(DtldVendLedgEntry);
        DtldVendLedgEntry.SetRange("Vendor No.", DtldVendLedgEntry2."Vendor No.");
        DtldVendLedgEntry.SetFilter("Entry No.", GetEntryNoToFilter());
        DeleteAll();
        if DtldVendLedgEntry.Find('-') then
            Repeat
                if (DtldVendLedgEntry."Entry Type" <> DtldVendLedgEntry."Entry Type"::"Initial Entry") and
                   not DtldVendLedgEntry.Unapplied
                then begin
                    Rec := DtldVendLedgEntry;
                    Insert;
                end;
            until DtldVendLedgEntry.Next() = 0;
    end;

    local procedure FindFilterVendorLedgerEntries(var DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry")
    begin
        if DtldVendLedgEntry2."Transaction No." = 0 then begin
            DtldVendLedgEntry.SetCurrentKey("Application No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Application No.", DtldVendLedgEntry2."Application No.");
        end else begin
            DtldVendLedgEntry.SetCurrentKey("Transaction No.", "Vendor No.", "Entry Type");
            DtldVendLedgEntry.SetRange("Transaction No.", DtldVendLedgEntry2."Transaction No.");
        end;
    end;

    procedure SetDtldVendLedgEntryUnique(EntryNo: Integer)
    begin
        DtldVendLedgEntry2.Get(EntryNo);
        VendLedgEntryNo := DtldVendLedgEntry2."Vendor Ledger Entry No.";
        PostingDate := DtldVendLedgEntry2."Posting Date";
        DocNo := DtldVendLedgEntry2."Document No.";
        Vend.GET(DtldVendLedgEntry2."Vendor No.");
    end;

    procedure SetUnapplyUnique()
    begin
        UniqueStatus := true;
    end;

    local procedure SetEntryNoToFilter(EntryNo: Integer)
    begin
        FilterVendorLedgerEntryNos += Format(EntryNo) + '|';
    end;

    local procedure GetEntryNoToFilter(): Text
    begin
        if StrLen(FilterVendorLedgerEntryNos) = 0 then
            exit('0');
        if FilterVendorLedgerEntryNos[StrLen(FilterVendorLedgerEntryNos)] = '|' then
            exit(FilterVendorLedgerEntryNos);
        exit(FilterVendorLedgerEntryNos);
    end;

    trigger OnOpenPage()
    begin
        if not UniqueStatus then
            exit;
        InsertEntries();
    end;

    var
        DtldVendLedgEntry2: Record "Detailed Vendor Ledg. Entry";
        Vend: Record Vendor;
        VendLedgEntryNo: Integer;
        DocNo: Code[20];
        PostingDate: Date;
        UniqueStatus: Boolean;
        FilterVendorLedgerEntryNos: Text;
        Text009: Label 'The entries were successfully unapplied.';
        Text010: Label 'There is nothing to unapply.';
        Text011: Label 'To unapply these entries, correcting entries will be posted.\Do you want to unapply the entries?';
}