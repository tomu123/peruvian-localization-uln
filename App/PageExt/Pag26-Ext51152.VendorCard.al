pageextension 51152 "ST Vendor Card" extends "Vendor Card"
{
    layout
    {
        // Add changes to page layout here
        addafter("Preferred Bank Account Code")
        {
            field("Preferred Bank Account Code ME"; Rec."Preferred Bank Account Code ME")
            {
                ApplicationArea = All;
            }
            field("Currenct Account BNAC"; Rec."Currenct Account BNAC")
            {
                ApplicationArea = All;
            }
        }
        modify("Last Date Modified")
        {
            Visible = false;
        }
        addlast(General)
        {
            field(Last_Date_Modified; "Last Date Modified")
            {
                ApplicationArea = All;
                Importance = Additional;
            }
            field("Insert Date"; "Insert Date")
            {
                ApplicationArea = All;
                Importance = Additional;
                Editable = false;
            }
            field("User Insert"; "User Insert")
            {
                ApplicationArea = All;
                Importance = Additional;
                Editable = false;
            }
        }
        modify("Preferred Bank Account Code")
        {
            Caption = 'Preferred Bank Account Code', Comment = 'ESM="Banco destino MN"';
        }
        addafter("Vendor Posting Group")
        {
            field("Vendor Posting Group ME"; Rec."Vendor Posting Group ME")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("VAT Registration No.")
        {
            field("SUNAT Status"; Rec."SUNAT Status")
            {
                ApplicationArea = All;
            }
            field("SUNAT Condition"; Rec."SUNAT Condition")
            {
                ApplicationArea = All;
            }
            field(Ubigeo; Rec.Ubigeo)
            {
                ApplicationArea = All;
            }
        }
        addbefore("VAT Registration No.")
        {
            field("VAT Registration Type"; Rec."VAT Registration Type")
            {
                ApplicationArea = All;
            }
        }
        addlast("Posting Details")
        {
            group(RetentionAgent)
            {
                Caption = 'Retention Agent', Comment = 'ESM="Agente de retención"';
                field("Retention Agent"; Rec."Retention Agent")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Retention Agent Start Date"; "Retention Agent Start Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Retention Agent End Date"; "Retention Agent End Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Retention Agent Resolution"; "Retention Agent Resolution")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("withholding File Date"; "withholding File Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Date of last withholding load"; "Date of last withholding load")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
            }
            group(PerceptionAgent)
            {
                Caption = 'Perception Agent', Comment = 'ESM="Agente de percepción"';
                field("Perception Agent"; Rec."Perception Agent")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Perception Agent Start Date"; "Perception Agent Start Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Perception Agent End Date"; "Perception Agent End Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Perception Agent Resolution"; "Perception Agent Resolution")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Perception File Date"; "Perception File Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Date of last Perception load"; "Date of last Perception load")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
            }
            group(GoodContributor)
            {
                Caption = 'Good Contributor', Comment = 'ESM="Buen contribuyente"';
                field("Good Contributor"; Rec."Good Contributor")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Good Contributor Start Date"; "Good Contributor Start Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Good Contributor End Date"; "Good Contributor End Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Good Contributor Resolution"; "Good Contributor Resolution")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Good contrib. File Date"; "Good contrib. File Date")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field("Date last good contrib. load"; "Date last good contrib. load")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
            }
        }
        //Ubigeo Begin
        addafter("Address 2")
        {
            field(CountryRegionCode; Rec."Country/Region Code")
            {
                ApplicationArea = All;
                trigger OnValidate()
                begin
                    CurrPage.Update(true);
                end;
            }
            field(PostCode; Rec."Post Code")
            {
                Caption = 'Departament', comment = 'ESM="Departamento"';
                ApplicationArea = All;
            }
            field(City2; Rec.City)
            {
                Caption = 'City', comment = 'ESM="Ciudad"';
                ApplicationArea = All;
            }
        }
        addafter(County)
        {
            field(UbigeoDescription; UbigeoMgt.ShowUbigeoDescription(Rec."Country/Region Code", Rec."Post Code", Rec.City, Rec.County))
            {
                ApplicationArea = All;
            }
        }
        //PosCode = Departamento
        //City = Provincia
        //County = County
        modify("Country/Region Code")
        {
            Visible = false;
        }
        modify("Post Code")
        {
            Visible = false;
        }
        modify(City)
        {
            Visible = false;
        }
        modify("Currency Code")
        {
            Editable = false;
        }
        modify("Vendor Posting Group")
        {
            trigger OnAfterValidate()
            var
                lclVendorPostingGroup: Record "Vendor Posting Group";
            begin
                if lclVendorPostingGroup.get("Vendor Posting Group") then begin
                    "Currency Code" := lclVendorPostingGroup."Currency Code";
                    Rec.Modify();
                end;

            end;
        }
        //Ubigeo End

        //Import
        addlast(Invoicing)
        {
            group("DoubleTaxationAgreements")
            {
                Caption = 'Double Taxation Aggrements', Comment = 'ESM="Convenios Doble Tributación"';
                grid(DoubleTaxationAgreementsGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupDAT1")
                    {
                        ShowCaption = false;
                        field("Double Taxation Agreements"; Rec."Double Taxation Agreements")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            begin
                                gRecLegalDocument.Reset();
                                gRecLegalDocument.SetRange("Option Type", gRecLegalDocument."Option Type"::"SUNAT Table");
                                gRecLegalDocument.SetRange("Type Code", '25');
                                gRecLegalDocument.SetRange("Legal No.", Rec."Double Taxation Agreements");
                                if gRecLegalDocument.FindSet() then
                                    gTextDoubleTaxationAgreements := gRecLegalDocument.Description;


                            end;
                        }
                    }
                    group("GridGroupDAT2")
                    {
                        ShowCaption = false;
                        field(gTextDoubleTaxationAgreements; gTextDoubleTaxationAgreements)
                        {
                            ApplicationArea = All;
                            Editable = false;
                            ShowCaption = false;
                        }
                    }
                }
            }
            group(EconomicLinkagesType)
            {
                Caption = 'Economic Linkages Type', Comment = 'ESM="Tipo Vinculación Económica"';
                grid(EconomicLinkagesTypeGrid)
                {
                    GridLayout = Columns;
                    group(GridGroupELT1)
                    {
                        ShowCaption = false;
                        field("Economic Linkages Type"; Rec."Economic Linkages Type")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            trigger OnValidate()
                            begin
                                gRecLegalDocument.Reset();
                                gRecLegalDocument.SetRange("Option Type", gRecLegalDocument."Option Type"::"SUNAT Table");
                                gRecLegalDocument.SetRange("Type Code", '27');
                                gRecLegalDocument.SetRange("Legal No.", Rec."Economic Linkages Type");
                                if gRecLegalDocument.FindSet() then
                                    gTextEconomicLinkagesType := gRecLegalDocument.Description;
                            end;
                        }
                    }
                    group(GridGroupELT2)
                    {
                        ShowCaption = false;
                        field(gTextEconomicLinkagesType; gTextEconomicLinkagesType)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            Editable = false;
                        }
                    }
                }
            }
        }

        //Purchase Request
        addafter("Purchaser Code")
        {
            field("PR Generic Purchase"; Rec."PR Generic Purchase")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
        addlast(processing)
        {
            action(ConsultRuc)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Consult Ruc';
                Image = ElectronicNumber;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Create Basic Line';

                trigger OnAction()
                var
                    CnsltRucMgt: Codeunit "Cnslt. Ruc Management";
                    Vendor: Record Vendor;
                begin
                    CnsltRucMgt.VendorConsultRuc(Rec);
                end;
            }
            action(SaldoGCProveedor)
            {
                ApplicationArea = All;
                Caption = 'Vendor AC Balance', Comment = 'ESM="Salgo GC Proveedor"';
                Image = Report;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = report "Vendor AC Balance";
            }
        }
        modify(SendApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                "Status approved" := true;
                Modify();
            end;
        }
        modify(CancelApprovalRequest)
        {
            trigger OnBeforeAction()
            begin
                "Status approved" := false;
                Modify();
            end;
        }
    }
    var
        UbigeoMgt: Codeunit "Ubigeo Management";
        gTextDoubleTaxationAgreements: Text;
        gTextEconomicLinkagesType: Text;
        gRecLegalDocument: Record "Legal Document";

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagement: Codeunit "Workflow Management";
    begin
        if not "Status approved" then begin
            //if WorkflowManagement.EnabledWorkflowExist(DATABASE::Vendor, WorkflowEventHandling.RunWorkflowOnVendorChangedCode()) then
            if ApprovalsMgmt.CheckVendorApprovalsWorkflowEnabled(Rec) then begin
                ApprovalsMgmt.OnSendVendorForApproval(Rec);
                "Status approved" := true;
                Modify();
            end;
        end;
    end;

}