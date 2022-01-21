pageextension 51034 "Detrac Posted Pucharse Invoice" extends "Posted Purchase Invoice"
{
    Editable = false;
    layout
    {
        addafter("Vendor Invoice No.")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
        // Add changes to page layout here
        addafter("Shipping and Payment")
        {
            group(Detractions)
            {
                Caption = 'Detractions';
                field("Purch. Detraction"; "Purch. Detraction")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                group(TypeOfService)
                {
                    Caption = 'Type Of Service';
                    grid(Mygrid)
                    {
                        GridLayout = Columns;
                        field("Type of Service"; "Type of Service")
                        {
                            Editable = false;
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                        field("Detrac. Service. Name"; CalcDetraction.GetTypeOfSO("Type of Service", false))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            //FieldPropertyName = FieldPropertyValue;
                        }
                    }
                }
                group(TypeOfOperation)
                {
                    Caption = 'Type Of Operation';
                    grid(Mygrid2)
                    {
                        GridLayout = Columns;
                        field("Type of Operation"; "Type of Operation")
                        {
                            Editable = false;
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                        field("Detrac.Oper. Name"; CalcDetraction.GetTypeOfSO("Type of Operation", true))
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            //FieldPropertyName = FieldPropertyValue;
                        }

                    }
                }
                field("Purch. % Detraction"; "Purch. % Detraction")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purch. Amount Detraction"; "Purch. Amount Detraction")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purch Amount Detraction LCY"; "Purch Amount Detraction LCY")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Purch. Detraction Operation"; "Purch. Detraction Operation")
                {
                    ApplicationArea = All;
                    Editable = "Purch. Detraction";
                }
                field("Purch Date Detraction"; "Purch Date Detraction")
                {
                    ApplicationArea = All;
                    Editable = "Purch. Detraction";
                }
            }
        }
        addlast(General)
        {
            group("IncomeType")
            {
                Caption = 'Income Type', Comment = 'ESM="Tipo Renta"';
                Visible = false; //FMM::24-12-21 Pedido por Lizeth
                grid(IncomeTypeGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND1")
                    {
                        //GridLayout = Rows;
                        ShowCaption = false;
                        field("Income Type"; "Income Type")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    group("GridGroupND2")
                    {
                        ShowCaption = false;
                        field(gTextIncomeType; gTextIncomeType)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                        }
                    }
                }
            }

            group("ServiceProvidedMode")
            {
                Caption = 'Service Provided Mode', Comment = 'ESM="Modalidad Servicio Prestado"';
                Visible = false; //FMM::24-12-21 Pedido por Lizeth
                grid(ServiceProvidedModeGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND3")
                    {
                        ShowCaption = false;
                        field("Service Provided Mode"; "Service Provided Mode")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                    group("GridGroupND4")
                    {
                        ShowCaption = false;
                        field(gTextServiceProvidedMode; gTextServiceProvidedMode)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                        }
                    }
                }
            }

            group("ExemptionsfromOperations")
            {
                Caption = 'Exemptions from Operations', Comment = 'ESM="Exoneraciones de Operaciones"';
                Visible = false; //FMM::24-12-21 Pedido por Lizeth
                grid(ExemptionsfromOperationsGrid)
                {
                    GridLayout = Columns;
                    group("GridGroupND5")
                    {
                        ShowCaption = false;
                        field("Exemptions from Operations"; "Exemptions from Operations")
                        {
                            ApplicationArea = All;
                        }
                    }
                    group("GridGroupND6")
                    {
                        ShowCaption = false;
                        field(gTextExemptionsfromOperations; gTextExemptionsfromOperations)
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                        }
                    }
                }
            }
        }
        addafter("Posting Date")
        {
            field("Accountant receipt date"; "Accountant receipt date")
            {
                ApplicationArea = All;
            }
        }
        addafter(Corrective) //FMM::24-12-21 Pedido por Lizeth
        {
            field("Posting Text"; "Posting Text")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Posting Description"; "Posting Description")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("User ID"; "User ID")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Vendor Posting Group"; "Vendor Posting Group")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Legal Status"; "Legal Status")
            {
                ApplicationArea = All;
                Editable = false;
            }
            group(LegalPropertyType)
            {
                Caption = 'Legal Property Type', Comment = 'ESM="Tipo bien"';
                grid(LegalPropertyTypeGrid)
                {
                    GridLayout = Columns;
                    group(GridGroupLPT1)
                    {
                        ShowCaption = false;
                        field("Legal Property Type"; "Legal Property Type")
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                            trigger OnValidate()
                            begin
                                CurrPage.Update();
                            end;
                        }
                    }
                    group(GridGroupLPT2)
                    {
                        ShowCaption = false;
                        field("Legal Property Type Name"; ShowLegalPropertyName())
                        {
                            ApplicationArea = All;
                            ShowCaption = false;
                            Editable = false;
                        }
                    }
                }
            }
        }
        modify("Responsibility Center")
        {
            Visible = false; //FMM::24-12-21 Pedido por Lizeth
        }
    }

    actions
    {
        // Add changes to page actions here
        modify(Correct)
        {
            Visible = false;
            Enabled = false;
        }
        modify(CreateCreditMemo)
        {
            Visible = false;
            Enabled = false;
        }
        modify(CorrectInvoice)
        {
            Enabled = false;
            Visible = false;
        }

        modify(CancelInvoice)
        {
            Enabled = false;
            Visible = false;
        }
        addafter(Approvals)
        {
            action(ModifyDetraction)
            {
                Caption = 'Modify Detraction', Comment = 'ESM="Modificar Detracción"';
                Image = SalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'To modify the data of the deduction.', Comment = 'ESM="Modificar los datos de la detracción."';

                // trigger OnAction()
                // begin
                //     FillGenericPurchase();
                // end;
            }
        }
    }
    procedure ShowLegalPropertyName(): Text[250]
    var
        MyLegalDocument: Record "Legal Document";
    begin
        MyLegalDocument.Reset();
        MyLegalDocument.SetRange("Option Type", MyLegalDocument."Option Type"::"SUNAT Table");
        MyLegalDocument.SetRange("Type Code", '30');
        MyLegalDocument.SetRange("Legal No.", "Legal Property Type");
        if MyLegalDocument.Find('-') then
            exit(MyLegalDocument.Description);
        exit('');
    end;

    var
        myInt: Integer;
        CalcDetraction: Codeunit "DetrAction Calculation";
        gTextIncomeType: Text;
        gTextExemptionsfromOperations: Text;
        gTextServiceProvidedMode: Text;
}