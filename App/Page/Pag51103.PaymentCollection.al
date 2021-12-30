page 51103 "Payment Collection"
{
    ApplicationArea = All;
    Editable = true;
    PageType = List;
    AutoSplitKey = true;
    Caption = 'Cobros - Recaudación', Comment = 'ESM="Cobros - Recaudación"';
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    SourceTable = "ST Control File";
    SourceTableView = WHERE("Entry Type" = FILTER("Recaudación"));
    RefreshOnActivate = true;
    UsageCategory = Lists;
    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(BankAccountNo; BankAccountNo)
                {
                    Caption = 'Cuenta recaudadora banco no.';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    TableRelation = "Bank Account" where("Process Bank" = filter(<> ''));
                    trigger OnValidate()
                    begin
                        GetBankProcessAndCurrencyCode(BankAccountNo);
                        TipoArchivo := TipoArchivo::" ";
                        TipoRegistro := '';
                        TRecordCode := '';
                    end;
                }
                field(TipoArchivo; TipoArchivo)
                {
                    Caption = 'Tipo de Archivo';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    Editable = EnabledList;
                    OptionCaption = ',Archivo de Reemplazo,Archivo de Actualización',
                                    Comment = '"ESM= ,Archivo de Reemplazo,Archivo de Actualización"';
                    trigger OnValidate()
                    var
                    begin

                        case TipoArchivo of
                            TipoArchivo::"Archivo de Actualización":
                                TFileCode := 'A';
                            TipoArchivo::"Archivo de Reemplazo":
                                if CollectionBank = 'INTERBANK' then
                                    TFileCode := 'M'
                                else
                                    TFileCode := 'R';
                        end;
                        TipoRegistro := '';
                        TRecordCode := '';
                    end;
                }
                field(TipoRegistro; TipoRegistro)
                {
                    Caption = 'Tipo Registro';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;

                    trigger OnValidate()
                    var
                    begin
                        if EnabledList then
                            if TipoArchivo = TipoArchivo::" " then
                                Error('Seleccione primero, Tipo de Archivo para continuar.');

                        if CollectionBank = 'INTERBANK' then
                            case TipoRegistro of
                                'Data Parcial':
                                    TipoFormato := '01';
                                'Data Completa':
                                    begin
                                        TipoFormato := '02';
                                        EnabledIBK := true;
                                    end;
                                'Pago Automatico':
                                    begin
                                        TipoFormato := '03';
                                        TRecordCode := ' ';
                                    end;
                                else
                                    TipoFormato := '';
                            end;
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        MasterData: Record "Master Data";
                    begin
                        EnabledIBK := false;
                        if EnabledList then
                            if TipoArchivo = TipoArchivo::" " then
                                Error('Seleccione primero, Tipo de Archivo para continuar.');

                        TipoRegistro := MgmtCollection.MasterDataLookup(CollectionBank);
                        if TipoRegistro <> '' then
                            Text := TipoRegistro;

                        MasterData.SetRange("Type Table", CollectionBank);
                        MasterData.SetRange(Description, Text);
                        if MasterData.FindFirst() then
                            TRecordCode := MasterData.Code;

                        if CollectionBank = 'BCP' THEN begin
                            if TRecordCode = '0' then
                                TRecordCode := ' ';

                            if MgmtCollection.ValidateRecordType(TFileCode, TRecordCode) then begin
                                TipoRegistro := '';
                                TRecordCode := '';
                                Text := '';
                            end;
                        end;

                        if CollectionBank = 'INTERBANK' then
                            case text of
                                'Data Parcial':
                                    TipoFormato := '01';
                                'Data Completa':
                                    begin
                                        TipoFormato := '02';
                                        EnabledIBK := true;
                                    end;
                                'Pago Automatico':
                                    begin
                                        TipoFormato := '03';
                                        TRecordCode := ' ';
                                    end;
                                else
                                    TipoFormato := '';
                            end;

                        exit(true)
                    end;
                }
                field(TipoOperacion; TipoOperacion)
                {
                    Caption = 'Tipo de Operación';
                    ApplicationArea = All;
                    Importance = Standard;
                    Visible = true;
                    Editable = EnabledIBK;

                    trigger OnValidate()
                    begin
                        TipoOp := '';
                        if TipoOperacion <> TipoOperacion::" " then
                            TipoOp := CopyStr(format(TipoOperacion), 1, 1);

                    end;
                }
                group(Filter)
                {
                    Caption = 'Filtros';

                    field(ApplyFilter; ApplyFilter)
                    {
                        Caption = 'Aplicar Filtros';
                        ApplicationArea = All;
                        Importance = Standard;
                        Visible = true;

                        trigger OnValidate()
                        var
                        begin
                            if not ApplyFilter then begin
                                DateFrom := 0D;
                                DateTo := 0D;
                                SerieDoc := '';
                            end;
                        end;
                    }
                    field(DateFrom; DateFrom)
                    {
                        Caption = 'Desde';
                        ApplicationArea = All;
                        Importance = Standard;
                        Visible = true;
                        Editable = ApplyFilter;
                    }

                    field(DateTo; DateTo)
                    {
                        Caption = 'Hasta';
                        ApplicationArea = All;
                        Importance = Standard;
                        Visible = true;
                        Editable = ApplyFilter;
                    }
                    field(SerieDoc; SerieDoc)
                    {
                        Caption = 'Serie Doc.';
                        ApplicationArea = All;
                        Importance = Standard;
                        Visible = true;
                        Editable = ApplyFilter;
                    }
                }

            }
            repeater(GroupName)
            {
                ShowCaption = false;
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Create User ID"; Rec."Create User ID")
                {
                    ApplicationArea = All;
                }
                field("Create DateTime File"; Rec."Create DateTime File")
                {
                    ApplicationArea = All;
                }
                field("Exists File"; Rec."File Blob".HasValue())
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Caption = 'Generar (txt)';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    if BankAccountNo = '' then
                        Error('Seleccione Banco recaudo no. para continuar!');
                    if format(TipoArchivo) = '' then
                        Error('Seleccione Tipo archivo para continuar!');
                    if TRecordCode = '' then
                        Error('Seleccione Tipo registro para continuar!');

                    if CollectionBank = 'INTERBANK' then begin
                        if TipoRegistro = 'Data Completa' then
                            if TipoOperacion = TipoOperacion::" " then
                                Error('Seleccione Tipo Operación para continuar!');
                    end;

                    Clear(MgmtCollection);
                    MgmtCollection.SetOpType(TipoOp, TipoFormato);
                    MgmtCollection.SetInfoAditional(CollectionBank, BankAccountNo, CurrencyCode, TipoArchivo, TipoRegistro, TipoOperacion);//PC 26.05.21 ADD
                    MgmtCollection.FindFillCollection(CollectionBank,
                                                    BankAccountNo,
                                                    CurrencyCode,
                                                    TFileCode,
                                                    TRecordCode,
                                                    DateFrom,
                                                    DateTo,
                                                    SerieDoc);
                    CurrPage.Update();
                end;
            }
            // action(UploadFile)
            // {
            //     ApplicationArea = All;
            //     Caption = 'Subir archivo respuesta';
            //     Image = ImportFile;
            //     Promoted = true;
            //     PromotedIsBig = true;

            //     trigger OnAction()
            //     var
            //     begin

            //     end;
            // }
            action(MultiSelect)
            {
                ApplicationArea = All;
                Caption = 'Seleccón multiple';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                var
                    pageCustLECollection: Page "CustLedgerEntry Collection";
                begin
                    if BankAccountNo = '' then
                        Error('Seleccione Banco recaudo no. para continuar');
                    if EnabledList then
                        if format(TipoArchivo) = '' then
                            Error('Seleccione Tipo archivo para continuar');
                    if TRecordCode = '' then
                        Error('Seleccione Tipo registro para continuar');

                    pageCustLECollection.SetEnabledList(EnabledList);
                    pageCustLECollection.SetColletionBank(CollectionBank, BankAccountNo, CurrencyCode, TFileCode, TRecordCode);
                    pageCustLECollection.RunModal();

                end;
            }
            action(DownloadFile)
            {
                ApplicationArea = All;
                Caption = 'Download File';
                Image = ExportFile;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    Rec.DownLoadFile(Rec);
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                Image = DeleteRow;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    if not Rec.IsEmpty then
                        Rec.Delete();
                end;
            }
        }
    }
    var
        BankAccountOption: Option " ",BCP,BBVA,SCOTIA,INTERBANK,BANBIF;
        CollectionBank: Text;
        BankAccountNo: Code[10];
        CurrencyCode: Code[10];
        TipoArchivo: option " ","Archivo de Reemplazo","Archivo de Actualización";
        TipoRegistro: Text;
        TRecordCode: Text;
        TFileCode: text;
        MgmtCollection: Codeunit "Mgmt Collection";
        RecCollectionPaymentBuffer: Record "Collection Payment Buffer" temporary;
        EnabledList: Boolean;
        DateFrom: Date;
        DateTo: Date;
        SerieDoc: text;
        ApplyFilter: Boolean;
        TipoOperacion: option " ","Adicionar","Modificar","Eliminar","Descargar";
        TipoOp: Text;
        TipoFormato: Text;
        EnabledIBK: Boolean;

    local procedure GetBankProcessAndCurrencyCode(pBankAccountNo: code[20])
    var
        BankAccount: Record "Bank Account";
    begin
        if BankAccount.get(pBankAccountNo) then begin
            CollectionBank := Format(BankAccount."Process Bank");
            case CollectionBank of
                'BBVA':
                    EnabledList := false;
                else
                    EnabledList := true;
            end;
            CurrencyCOde := BankAccount."Currency Code";
        end;
    end;
}