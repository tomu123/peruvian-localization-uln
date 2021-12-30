codeunit 51045 "CUO Management"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInsertGLEntryBuffer', '', false, false)]
    local procedure SetOnBeforeInsertGLEntryBuffer_Codeunit12(var TempGLEntryBuf: Record "G/L Entry" temporary)
    var
        CUOEntry2: Record "ULN CUO Entry";
        EntryNo: Integer;
    begin
        SLSetup.Get();
        if (not SLSetup."Enabled Posting (CUO)") or (SLSetup."Type control posting CUO" = SLSetup."Type control posting CUO"::"After posting") then
            exit;

        CUOEntry2.SetCurrentKey("Entry No.");
        if CUOEntry2.FindLast() then
            EntryNo := CUOEntry2."Entry No.";

        case SLSetup."Type control filter CUO" of
            SLSetup."Type control filter CUO"::"Only Document No.":
                begin
                    CUOEntry.SetCurrentKey("Document No.");
                    CUOEntry.SetRange("Document No.", TempGLEntryBuf."Document No.");
                end;
            SLSetup."Type control filter CUO"::"Filter DocNo & Pstg. Date":
                begin
                    CUOEntry.SetCurrentKey("Document No.", "Posting Date");
                    CUOEntry.SetRange("Document No.", TempGLEntryBuf."Document No.");
                    CUOEntry.SetRange("Posting Date", TempGLEntryBuf."Posting Date");
                end;
            SLSetup."Type control filter CUO"::"Filter DocNo & Pstg. Date & Transaction No.":
                begin
                    CUOEntry.SetCurrentKey("Document No.", "Posting Date", "Transaction No.");
                    CUOEntry.SetRange("Document No.", TempGLEntryBuf."Document No.");
                    CUOEntry.SetRange("Posting Date", TempGLEntryBuf."Posting Date");
                    CUOEntry.SetRange("Transaction No.", TempGLEntryBuf."Transaction No.");
                end;
        end;
        if CUOEntry.IsEmpty then begin
            CUOEntry.Init();
            CUOEntry."Entry No." := EntryNo + 1;
            CUOEntry."Document No." := TempGLEntryBuf."Document No.";
            CUOEntry."Posting Date" := TempGLEntryBuf."Posting Date";
            CUOEntry."Transaction No." := TempGLEntryBuf."Transaction No.";

            CUOEntry."CUO Transaction No." := GetLastTransactionCUO() + 1;
            TempGLEntryBuf."Transaction CUO" := CUOEntry."CUO Transaction No.";

            CUOEntry."Last. used CUO Correlative" := GetLastCorrelativeCUO(TempGLEntryBuf);
            TempGLEntryBuf."Correlative CUO" := CUOEntry."Last. used CUO Correlative";
            CUOEntry."User Id." := UserId;
            CUOEntry.Insert()
        end else begin
            CUOEntry.FindFirst();
            TempGLEntryBuf."Transaction CUO" := CUOEntry."CUO Transaction No.";
            TempGLEntryBuf."Correlative CUO" := IncStr(GetLastCorrelativeCUO(TempGLEntryBuf));
            CUOEntry."Last. used CUO Correlative" := TempGLEntryBuf."Correlative CUO";
            CUOEntry.Modify()
        end;
    end;

    local procedure GetLastTransactionCUO(): Integer
    var
        LastTransactionCUO_: Integer;
    begin
        Clear(LastTransactionCUO);
        LastTransactionCUO_ := 0;
        LastTransactionCUO.Open();
        while LastTransactionCUO.Read() do
            LastTransactionCUO_ := LastTransactionCUO.CUO_Transaction_No_;
        LastTransactionCUO.Close();
        exit(LastTransactionCUO_)
    end;

    local procedure GetLastCorrelativeCUO(var TempGLEntryBuf: Record "G/L Entry" temporary): Code[20]
    var
        LastCorrelativeCUO_: Code[20];
        CharacterAssign: Code[1];
        ErrorSetup: Label 'An xx greater than 3 must be set.', Comment = 'ESM="Se debe de configurar %1 mayor a 3 para el correlativo CUO."';
    begin
        Clear(LastCorrelativeCUO);
        if SLSetup."Quantity characters Corr. CUO" < 4 then
            Error(ErrorSetup);
        LastCorrelativeCUO.SetRange(CUO_Transaction_No_Filter, TempGLEntryBuf."Transaction CUO");
        LastCorrelativeCUO.Open();
        while LastCorrelativeCUO.Read() do
            LastCorrelativeCUO_ := LastCorrelativeCUO.Last__used_CUO_Correlative;
        LastCorrelativeCUO.Close();
        if LastCorrelativeCUO_ <> '' then begin
            TempGLEntryBuf."Correlative CUO" := LastCorrelativeCUO_;
            exit(LastCorrelativeCUO_)
        end;

        case true of
            TempGLEntryBuf.Opening:
                CharacterAssign := 'A';
            (TempGLEntryBuf."Posting Date" = ClosingDate(TempGLEntryBuf."Posting Date")) and
                    (NOT TempGLEntryBuf.Opening):
                CharacterAssign := 'C';
            else
                CharacterAssign := 'M';
        end;
        LastCorrelativeCUO_ := CharacterAssign + GetTextWithAdjust('1', SLSetup."Quantity characters Corr. CUO", '>', '0');
        TempGLEntryBuf."Correlative CUO" := LastCorrelativeCUO_;
        exit(LastCorrelativeCUO_);
    end;

    procedure CorrectCUO(var pCUOEntry: Record "ULN CUO Entry")
    var
        GLEntry: Record "G/L Entry";
        LastCorrelativeCUO_: Code[20];
        CharacterAssign: Code[1];
        FirstLine: Boolean;
    begin
        SLSetup.Get();
        case SLSetup."Type control filter CUO" of
            SLSetup."Type control filter CUO"::"Only Document No.":
                begin
                    FirstLine := true;
                    CharacterAssign := CopyStr(pCUOEntry."Last. used CUO Correlative", 1, 1);
                    LastCorrelativeCUO_ := CharacterAssign + GetTextWithAdjust('1', SLSetup."Quantity characters Corr. CUO", '>', '0');
                    GLEntry.SetRange("Document No.", pCUOEntry."Document No.");
                    if GLEntry.FindFirst() then begin
                        repeat
                            if FirstLine then
                                FirstLine := false
                            else
                                LastCorrelativeCUO_ := IncStr(LastCorrelativeCUO_);
                            GLEntry."Transaction CUO" := pCUOEntry."CUO Transaction No.";
                            GLEntry."Correlative CUO" := LastCorrelativeCUO_;
                            GLEntry.Modify()
                        until GLEntry.Next() = 0;
                        pCUOEntry."Last. used CUO Correlative" := LastCorrelativeCUO_;
                        pCUOEntry.Modify()
                    end;
                end;
        end;
    end;


    procedure CreateCUOForBlankLines()
    var
        CUOEntry2: Record "ULN CUO Entry";
        GLEntry_: Record "G/L Entry";
        EntryNo: Integer;
    begin
        SLSetup.Get();
        if (not SLSetup."Enabled Posting (CUO)") then
            exit;

        CUOEntry2.SetCurrentKey("Entry No.");
        if CUOEntry2.FindLast() then
            EntryNo := CUOEntry2."Entry No.";

        GLEntry_.SetRange("Transaction No.", 0);
        if GLEntry_.FindFirst() then
            repeat
                CUOEntry.Reset();
                case SLSetup."Type control filter CUO" of
                    SLSetup."Type control filter CUO"::"Only Document No.":
                        begin
                            CUOEntry.SetCurrentKey("Document No.");
                            CUOEntry.SetRange("Document No.", GLEntry_."Document No.");
                        end;
                    SLSetup."Type control filter CUO"::"Filter DocNo & Pstg. Date":
                        begin
                            CUOEntry.SetCurrentKey("Document No.", "Posting Date");
                            CUOEntry.SetRange("Document No.", GLEntry_."Document No.");
                            CUOEntry.SetRange("Posting Date", GLEntry_."Posting Date");
                        end;
                    SLSetup."Type control filter CUO"::"Filter DocNo & Pstg. Date & Transaction No.":
                        begin
                            CUOEntry.SetCurrentKey("Document No.", "Posting Date", "Transaction No.");
                            CUOEntry.SetRange("Document No.", GLEntry_."Document No.");
                            CUOEntry.SetRange("Posting Date", GLEntry_."Posting Date");
                            CUOEntry.SetRange("Transaction No.", GLEntry_."Transaction No.");
                        end;
                end;
                if CUOEntry.IsEmpty then begin
                    CUOEntry.Init();
                    CUOEntry."Entry No." := EntryNo + 1;
                    CUOEntry."Document No." := GLEntry_."Document No.";
                    CUOEntry."Posting Date" := GLEntry_."Posting Date";
                    CUOEntry."Transaction No." := GLEntry_."Transaction No.";

                    CUOEntry."CUO Transaction No." := GetLastTransactionCUO() + 1;
                    GLEntry_."Transaction CUO" := CUOEntry."CUO Transaction No.";

                    CUOEntry."Last. used CUO Correlative" := GetLastCorrelativeCUO(GLEntry_);
                    GLEntry_."Correlative CUO" := CUOEntry."Last. used CUO Correlative";
                    CUOEntry."User Id." := UserId;
                    CUOEntry.Insert();
                end else begin
                    CUOEntry.FindFirst();
                    GLEntry_."Transaction CUO" := CUOEntry."CUO Transaction No.";
                    GLEntry_."Correlative CUO" := IncStr(GetLastCorrelativeCUO(GLEntry_));
                    CUOEntry."Last. used CUO Correlative" := GLEntry_."Correlative CUO";
                    CUOEntry.Modify();
                end;
                GLEntry_.Modify();
            until GLEntry_.Next() = 0;
    end;

    local procedure GetTextWithAdjust(pinputText: Text; pLenght: integer; pDirection: Text[10]; pCharacter: Text[10]): Text
    begin
        case true of
            (StrLen(pinputText) = 0):
                exit(PadStr('', pLenght, pCharacter));
            (StrLen(pinputText) < pLenght) and (pDirection = '<'):
                exit(pinputText + PadStr('', pLenght - StrLen(pinputText), pCharacter));
            (StrLen(pinputText) < pLenght) and (pDirection = '>'):
                exit(PadStr('', pLenght - StrLen(pinputText), pCharacter) + pinputText);
            (StrLen(pinputText) > pLenght) and (pDirection = '<'):
                exit(CopyStr(pinputText, 1, pLenght));
            (StrLen(pinputText) > pLenght) and (pDirection = '>'):
                exit(CopyStr(pinputText, StrLen(pinputText) - pLenght, pLenght));
            (StrLen(pinputText) = pLenght):
                exit(pinputText);
        end;
    end;

    var
        SLSetup: Record "Setup Localization";
        CUOEntry: Record "ULN CUO Entry";
        LastTransactionCUO: Query "ULN Get Last Transaction CUO";
        LastCorrelativeCUO: Query "ULN Get Last Correlative CUO";
}