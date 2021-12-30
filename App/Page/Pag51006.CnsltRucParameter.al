page 51006 "Consult RUC Parameter"
{
    Caption = 'Consult Ruc - Parameters', Comment = 'ESM="Consulta RUC - Parametros"';
    PageType = StandardDialog;
    ApplicationArea = All;
    UsageCategory = Administration;


    layout
    {
        area(Content)
        {
            field(Ruc; Ruc)
            {
                Caption = 'RUC';
                ApplicationArea = All;
            }
            field(TemplateCode; TemplateCode)
            {
                Caption = 'Template Code', Comment = 'ESM="Cód. Plantilla"';
                ApplicationArea = All;
                trigger OnValidate()
                var
                    ConfTempHdr: Record "Config. Template Header";
                begin
                    if TemplateCode = '' then
                        exit;
                    ConfTempHdr.Reset();
                    ConfTempHdr.SetRange("Table ID", TableID);
                    ConfTempHdr.SetRange(Code, TemplateCode);
                    ConfTempHdr.SetRange(Enabled, true);
                    ConfTempHdr.FindFirst();
                end;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    LookUpTemplate();
                end;
            }
        }
    }

    procedure SetParameters(pRuc: Code[20]; pTemplateCode: Code[20]; pTableID: Integer)
    begin
        Ruc := pRuc;
        TemplateCode := pTemplateCode;
        TableID := pTableID;
    end;

    procedure GetParameter(var pRuc: Code[20]; var ConfTemplHdr: Record "Config. Template Header")
    begin
        pRuc := Ruc;
        ConfTemplHdr.Reset();
        ConfTemplHdr.SetRange("Table ID", TableID);
        ConfTemplHdr.SetRange(Enabled, true);
        ConfTemplHdr.SetRange(Code, TemplateCode);
        ConfTemplHdr.FindSet();
    end;

    local procedure LookUpTemplate()
    var
        ConfTempHdr: Record "Config. Template Header";
        SLSetup: Record "Setup Localization";
        ConfigTemplates: Page "Config Templates";
        TemplateAlert: Label 'Select template to continued.', comment = 'ESP="Seleccione plantilla para continuar"';
    begin
        SLSetup.Get();
        Clear(ConfigTemplates);
        ConfTempHdr.Reset();
        ConfTempHdr.FilterGroup(2);
        ConfTempHdr.SetRange("Table ID", TableID);
        ConfTempHdr.SetRange(Enabled, true);
        case TableID of
            18:
                ConfTempHdr.SetFilter(Code, '%1|%2|%3', SLSetup."Customer MN Template Code", SLSetup."Customer ME Template Code", SLSetup."Customer Ext Template Code");
            23:
                ConfTempHdr.SetFilter(Code, '%1|%2|%3', SLSetup."Vendor MN Template Code", SLSetup."Vendor ME Template Code", SLSetup."Vendor Ext Template Code");
        end;
        ConfTempHdr.FilterGroup(0);
        ConfigTemplates.LookupMode(true);
        ConfigTemplates.SetTableView(ConfTempHdr);
        if ConfigTemplates.RunModal() in [Action::LookupOK, Action::OK, Action::Yes] then begin
            ConfigTemplates.GetRecord(ConfTempHdr);
            TemplateCode := ConfTempHdr.Code;
            if ConfTempHdr.IsEmpty then
                Error(TemplateAlert);
        end else
            Error(TemplateAlert);
    end;

    var
        Ruc: Code[20];
        TemplateCode: Code[20];
        TableID: Integer;
        Description: Text;
}