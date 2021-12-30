page 51104 "CustLedgerEntry Collection"
{
    Caption = 'Selección Multiple';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Collection Payment Buffer";
    SourceTableTemporary = true;
    Editable = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(CollectionBank; CollectionBank)
                {
                    Caption = 'Banco Proceso';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    Editable = false;
                }

                field(TipoRegistro; TipoRegistro)
                {
                    Caption = 'Tipo Registro';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    Editable = EnbaledList;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        MasterData: Record "Master Data";
                    begin
                        text := MgmtCollection.MasterDataLookup(CollectionBank);

                        MasterData.SetRange("Type Table", CollectionBank);
                        MasterData.SetRange(Description, Text);
                        if MasterData.FindFirst() then
                            TRecordCode := MasterData.Code;

                        if TRecordCode = '0' then
                            TRecordCode := ' ';
                        if EnbaledList then
                            if MgmtCollection.ValidateRecordType(TFileCode, TRecordCode) then begin
                                TipoRegistro := '';
                                TRecordCode := '';
                                exit;
                            end;
                        exit(true);
                    end;
                }
                field(CustomerNo; CustomerNo)
                {
                    Caption = 'Mov. Cliente';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    trigger OnValidate()
                    begin
                        if EnbaledList then
                            if TipoRegistro = '' then
                                Error('Selecciones primero: Tipo de Registro, para continuar.');
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if EnbaledList then
                            if TipoRegistro = '' then
                                Error('Selecciones primero: Tipo de Registro, para continuar.');

                        CustomerLookup();
                    end;
                }
            }
            repeater(GroupName)
            {
                field("Entry No."; "Entry No.")
                {
                    Caption = 'No. Mov. Cliente.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Post Type Descripción"; "Post Type Descripción")
                {
                    Caption = 'Tipo Registro';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Bank Account No."; "Bank Account No.")
                {
                    Caption = 'Banco Recaudo No.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Customer No."; "Customer No.")
                {
                    Caption = 'Cliente No.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Customer Name"; "Customer Name")
                {
                    Caption = 'Nombre Cliente.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    Caption = 'Importe Pendiente.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Posting Date"; "Posting Date")
                {
                    Caption = 'Fecha Emisión';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
                field("Due Date"; "Due Date")
                {
                    Caption = 'Fecha Vcto.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }

                field("Document No."; "Document No.")
                {
                    Caption = 'Documento No.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(GenerateFile)
            {
                Caption = 'Generar (.txt)';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    ValidateCollectionBuffer;//PC 24.05.21
                    GenerateMultipleTxt(Rec);
                end;
            }
        }
    }

    var
        CustomerNo: Code[20];
        TipoRegistro: Text;
        TRecordCode: Text;
        TFileCode: Text;
        CollectionBank: Text;
        CurrencyCode: text;
        BankAccountNO: Code[20];
        MgmtCollection: Codeunit "Mgmt Collection";
        gTotalRecords: Integer;
        gTotalAmount: Decimal;
        RecCollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
        EnbaledList: Boolean;

    trigger OnOpenPage()
    var
        MasterData: Record "Master Data";
    begin
        if not EnbaledList then begin
            MasterData.SetRange("Type Table", CollectionBank);
            MasterData.SetRange(Code, TRecordCode);
            if MasterData.FindFirst() then
                TipoRegistro := MasterData.Description;
        end;
    end;

    procedure SetColletionBank(var pCollectionBank: Text;
                                var pBankAccountNo: code[20];
                                var pCurrencyCode: code[10];
                                var pTFileCode: text;
                                var pTRecord: Text)
    var
    begin
        CollectionBank := pCollectionBank;
        BankAccountNo := pBankAccountNO;
        CurrencyCode := pCurrencyCode;
        TFileCode := pTFileCode;
        TRecordCode := pTRecord;
    end;

    local procedure CustomerLookup()
    var
        pageCustLedgerEntry: Page "Customer Ledger Entries";
        RecCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        RecCustLedgerEntry.Reset();
        RecCustLedgerEntry.SetRange("Currency Code", CurrencyCode);
        RecCustLedgerEntry.SetFilter("Remaining Amount", '<>%1', 0);
        RecCustLedgerEntry.SetRange(RecCustLedgerEntry."Document Type", RecCustLedgerEntry."Document Type"::Invoice);
        if RecCustLedgerEntry.FindSet() then begin
            pageCustLedgerEntry.SetTableView(RecCustLedgerEntry);
            pageCustLedgerEntry.LookupMode(true);
            if pageCustLedgerEntry.RunModal() = Action::LookupOK then begin
                SetRange("Entry No.", 0);
                DeleteAll();
                pageCustLedgerEntry.SetSelectionFilter(RecCustLedgerEntry);
                pageCustLedgerEntry.GetRecord(RecCustLedgerEntry);
                if RecCustLedgerEntry.FindFirst then
                    repeat
                        // InsertCollectionBuffer(RecCustLedgerEntry, TRecordCode, TFileCode);PC 24.05.21 Comentado
                        InsertCollectionBuffer(RecCustLedgerEntry, TRecordCode, TipoRegistro, TFileCode); //   PC 24.05.21 add

                    until RecCustLedgerEntry.Next = 0;
            end;
        end;
    end;

    local procedure InsertCollectionBuffer(var pCustLedgerEntry: Record "Cust. Ledger Entry";
                                            pPostType: Text; pPostTypeDescription: Text;
                                            pTFileCode: Text)
    var
        CollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
    // pageCollectionBuffer: Page "Collection Buffer Lookup";
    begin
        CollectionPaymentBuffer.Reset();
        pCustLedgerEntry.FindSet();
        repeat
            CollectionPaymentBuffer.Init();
            CollectionPaymentBuffer.TransferFields(pCustLedgerEntry, true);
            CollectionPaymentBuffer.onAfterCopyFromCustLedgEntry(CollectionPaymentBuffer, pCustLedgerEntry);
            CollectionPaymentBuffer."Post File" := pTFileCode;
            CollectionPaymentBuffer."Post Type" := pPostType;
            CollectionPaymentBuffer."Post Type Descripción" := pPostTypeDescription;
            CollectionPaymentBuffer."Collection Bank" := CollectionBank;
            CollectionPaymentBuffer."Bank Account No." := BankAccountNO;
            CollectionPaymentBuffer.Insert();
        until pCustLedgerEntry.Next() = 0;
        SetRecordTemp(CollectionPaymentBuffer);
        // pageCollectionBuffer.SetRecordTemp(CollectionPaymentBuffer);
        // pageCollectionBuffer.Run();
    end;

    procedure ValidateCollectionBuffer()
    var
        CollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
        lclRecLegalDocument: Record "Legal Document";
        lclRecCustLedgerEntry: Record "Cust. Ledger Entry";
        lclSerieText: Text;
        lclDocumentNumber: Text;
        workString: Text;
        LabelError1: Label 'Nº Serie supera la longitud máxima del tipo documento legal %1 en el Mov.Cliente %2';
        LabelError2: Label 'Nº Documento %1 supera la longitud máxima del tipo documento legal %2 en el Mov.Cliente %3';
        ArrayText: List of [Text];
    begin
        //PC 24.05.21 +++++ 
        Rec.Reset();
        IF Rec.FindSet() then
            repeat
                Clear(workString);
                lclSerieText := '';
                lclDocumentNumber := '';
                if lclRecCustLedgerEntry.Get(rec."Entry No.") then begin
                    lclRecLegalDocument.Reset();
                    lclRecLegalDocument.SetRange("Option Type", lclRecLegalDocument."Option Type"::"SUNAT Table");
                    lclRecLegalDocument.SetRange("Type Code", '10');
                    lclRecLegalDocument.SetRange("Legal No.", lclRecCustLedgerEntry."Legal Document");
                    lclRecLegalDocument.SetFilter("Serie Lenght", '<>%1', 0);
                    if lclRecLegalDocument.FindSet() then begin

                        workString := Rec."Document No.";
                        ArrayText := workString.Split('-');
                        lclSerieText := ArrayText.Get(1);
                        lclDocumentNumber := ArrayText.Get(2);
                        if StrLen(lclSerieText) > lclRecLegalDocument."Serie Lenght" then
                            Error(StrSubstNo(LabelError1, lclRecLegalDocument."Legal No.", Rec."Entry No."));
                        if StrLen(lclDocumentNumber) > lclRecLegalDocument."Number Lenght" then
                            Error(StrSubstNo(LabelError2, Rec."Document No.", lclRecLegalDocument."Legal No.", Rec."Entry No."));
                    end;
                end;
            until Rec.Next() = 0;
        //PC 24.05.21 +++++ 
    end;

    procedure SetRecordTemp(var CollectionPaymentBuffer: Record "Collection Payment Buffer" temporary)
    var
    begin
        Reset();
        CollectionPaymentBuffer.Reset();
        if CollectionPaymentBuffer.FindFirst() then
            repeat
                Init();
                TransferFields(CollectionPaymentBuffer, true);
                Insert();
            until CollectionPaymentBuffer.Next = 0;
    end;

    local procedure FillCollectionPayment(var pCollectionPaymentBuffer: Record "Collection Payment Buffer" temporary)
    var
    begin
        gTotalRecords := 0;
        gTotalAmount := 0;

        pCollectionPaymentBuffer.Reset();
        if pCollectionPaymentBuffer.FindFirst() then
            repeat
                pCollectionPaymentBuffer.CalcFields("Remaining Amount", "Remaining Amt. (LCY)");

                gTotalRecords += 1;
                case pCollectionPaymentBuffer."Currency Code" of
                    'USD':
                        gTotalAmount += pCollectionPaymentBuffer."Remaining Amount";
                    '':
                        gTotalAmount += pCollectionPaymentBuffer."Remaining Amt. (LCY)";
                end;
            until pCollectionPaymentBuffer.Next = 0;
    end;

    local procedure GenerateMultipleTxt(var pCollectionPaymentBuffer: Record "Collection Payment Buffer" temporary)
    var
        ControlFile: Record "ST Control File";
        CollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
    begin
        Clear(MgmtCollection);
        FillCollectionPayment(pCollectionPaymentBuffer);
        MgmtCollection.SetTotal(gTotalRecords, gTotalAmount);
        MgmtCollection.SetInfoAditional(CollectionBank, BankAccountNo, CurrencyCode, TipoArchivo::"Archivo de Reemplazo", TipoRegistro, TipoOperacion::Adicionar);//PC 26.05.21 ADD
        MgmtCollection.GenerateFilePaymentCollection(ControlFile,
                                                        pCollectionPaymentBuffer,
                                                        CollectionBank,
                                                        BankAccountNo);
        pCollectionPaymentBuffer.DeleteAll();
        pCollectionPaymentBuffer.Reset();
    end;

    procedure SetEnabledList(var pEnabled: Boolean)
    var
    begin
        EnbaledList := pEnabled;
    end;

    var
        TipoOperacion: option " ","Adicionar","Modificar","Eliminar","Descargar";
        TipoArchivo: option " ","Archivo de Reemplazo","Archivo de Actualización";
}