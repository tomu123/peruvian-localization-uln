page 51024 "Payment Schedule"
{
    Caption = 'Payment Schedule', Comment = 'ESM="Cronograma de Pagos"';
    PageType = List;
    Editable = true;
    SourceTable = "Payment Schedule";
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTableView = WHERE(Status = FILTER(<> Pagado));
    InsertAllowed = false;
    DeleteAllowed = false;
    DelayedInsert = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    Visible = true;

                }
                field("Document Date"; "Document Date")
                {
                    Editable = false;
                    Enabled = false;
                }

                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    Visible = false;
                }

                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("VAT Registration No."; "VAT Registration No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Business Name"; "Business Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                }
                field("Accountant Receipt Date"; "Accountant Receipt Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Delay Days"; "Delay Days")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Calculate Date"; "Calculate Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Original Amount"; "Original Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Amount LCY"; "Amount LCY")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Total a Pagar"; "Total a Pagar")
                {
                    ApplicationArea = All;
                    Editable = true;
                    Enabled = EnableTotalPay;
                    Visible = true;

                }
                field("Dollarized"; Dollarized)
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;

                }
                field("T.C. Dollarized"; "T.C. Dollarized")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = true;

                }
                field("Preferred Bank Account Code"; "Preferred Bank Account Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Bank Account No."; "Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("gAccountBankNation"; "gAccountBankNation")
                {
                    Caption = 'Cód. Cuenta Banco de la Nación', Comment = 'ESM="Cód. Cuenta Banco de la Nación Proveedor"';
                    ApplicationArea = All;
                    Editable = false;

                }
                field("Payment Method Code"; "Payment Method Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Reference Bank Acc. No."; "Reference Bank Acc. No.")
                {
                    ApplicationArea = All;
                    Editable = Status = Status::Pendiente;
                    Enabled = Status = Status::Pendiente;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                    Editable = false;
                    //Enabled = true;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Rec."Posting Group" := Rec."Posting Group";
                    end;

                    trigger OnDrillDown()
                    begin
                        Rec."Posting Group" := Rec."Posting Group";
                    end;
                }
                field("Service Type"; "Service Type")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Description Service"; "Description Service")
                {
                    ApplicationArea = All;
                    Enabled = false;

                }
                field("% Detraction"; "% Detraction")
                {
                    ApplicationArea = All;
                    Enabled = false;

                }
                field("Operation Type"; "Operation Type")
                {
                    ApplicationArea = All;

                    Enabled = false;

                }
                field("Description OP."; "Description OP.")
                {
                    ApplicationArea = All;

                    Enabled = false;

                }
                field("Vend./Cust. Account No."; "Vend./Cust. Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Source User Id."; "Source User Id.")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Source Entry No."; "Source Entry No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                    Visible = false;

                }
                field("Type Source"; "Type Source")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Setup Source Code"; "Setup Source Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;

                }
                field("Payment Terms Code"; "Payment Terms Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                }
                field("Process Date"; "Process Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                }
                field("Beneficiary Name"; "Beneficiary Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Enabled = false;
                }
            }
        }
        area(FactBoxes)
        {
            part(SLPostingGroupBuffer; "SL Posting Group Buffer")
            {
                ApplicationArea = All;
                Caption = 'Psoting Groups', Comment = 'ESM="Grupos de registro"';
            }
            systempart(notes; Mynotes)
            {
                ApplicationArea = all;
            }

        }
    }
    actions
    {
        area(Processing)
        {
            group(Process2)
            {
                Caption = 'Process', Comment = 'ESM="Procesar"';
                action(SuggestVendorPayments)
                {
                    ApplicationArea = All;
                    Caption = 'Prepayment vendors', Comment = 'ESM="Proponer Pagos"';
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = SuggestVendorPayments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = report "Generate Payment Schedule";
                    Ellipsis = true;
                }
                action(Process)
                {
                    ApplicationArea = All;
                    Caption = 'Process', Comment = 'ESM="Procesar"';
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        fnProcessAction;
                    end;

                }
                action(ReversalProcess)
                {
                    ApplicationArea = All;
                    Caption = 'Reversal Process', Comment = 'ESM="Revertir Proceso"';
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = ReverseRegister;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger
                    OnAction()
                    begin

                        recCronogramaPago.Reset();
                        recCronogramaPago.COPY(Rec);
                        CurrPage.SETSELECTIONFILTER(recCronogramaPago);


                        if not CONFIRM('¿Desea Revertir el registro(s) "Procesado" en estado "Pendiente"..?', false) then begin
                            exit;
                        end ELSE begin
                            recCronogramaPago.SETFILTER(Status, '%1', recCronogramaPago.Status::Procesado);
                            if recCronogramaPago.FINDSET then
                                repeat
                                    recCronogramaPago.Status := recCronogramaPago.Status::Pendiente;
                                    CLEAR(recCronogramaPago."Process Date");
                                    CLEAR(recCronogramaPago."Process Date 2");
                                    recCronogramaPago.Modify();
                                until recCronogramaPago.NEXT = 0;
                        end;

                        //---
                        SetStatusEntry;
                    end;
                }
                action(Card)
                {
                    ApplicationArea = All;
                    Caption = 'Ficha', Comment = 'ESM="Ficha"';
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        cuUtilities.fnShowCard(Rec);
                        ;
                    end;

                }
                action(Navigate)
                {
                    ApplicationArea = All;
                    Caption = 'Navegar', Comment = 'ESM="Navegar"';
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = Navigate;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        cuUtilities.fnNavigate(Rec);
                    end;

                }
                action(SaldoGCProveedor)
                {
                    ApplicationArea = All;
                    Caption = 'Vendor AC Balance', Comment = 'ESM="Salgo GC Proveedor"';
                    Image = Report;
                    RunObject = report "Vendor AC Balance";
                }
            }
            group(Actions2)
            {
                Caption = 'Actions', Comment = 'ESM="Acciones"';
                action(DeleteModify)
                {
                    ApplicationArea = All;
                    Caption = 'Delete entries', Comment = 'ESM="Eliminar mov."';
                    PromotedCategory = Process;
                    Visible = not NowShowActions;
                    Enabled = not NowShowActions;
                    Image = Reject;
                    Promoted = true;
                    PromotedIsBig = true;
                    trigger OnAction()
                    begin
                        if not CONFIRM('¿Desea eliminar el registro(s) seleccionado(s)...?', false) then begin
                            exit;
                        end ELSE begin
                            recSelectionFilter.COPY(Rec);
                            CurrPage.SETSELECTIONFILTER(recSelectionFilter);
                            cuUtilities.fnClosingControlCronograma(recSelectionFilter);
                        end;

                        CurrPage.UPDATE(true);
                    end;

                }
                action(CallModifyRecipientsBankAccount)
                {
                    ApplicationArea = All;
                    Caption = 'Modify recipients', Comment = 'ESM="Actualizar BancosNo definido"';
                    Visible = false;
                    Image = ChangeBatch;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger OnAction()
                    var

                        lcInputValueText: Text[100];
                        lcInputValue: Decimal;
                        lcSelectedOption: Integer;
                        lcSelectionOptionText: Text;
                        lcSelectionText: Text;
                        lcPgStandDialogPage: Page "Standard Dialog Page";
                        lcVoucherBankCode: Code[20];
                        lcBankCode: Code[20];
                        lcCurrencyCode: Code[10];
                        lcAmountVoucher: Decimal;
                        lcPaymentDate: Date;
                        lcCuMPWUtilities: Codeunit "Payment Schedule Utility";
                        lcRecPaymentSchedule: Record "Payment Schedule";
                    begin
                        CLEAR(lcCuMPWUtilities);
                        CLEAR(lcPgStandDialogPage);
                        lcPgStandDialogPage.SetType(2);
                        lcPgStandDialogPage.SetPaymentScheduleEntryNo("Entry No.");
                        lcPgStandDialogPage.LOOKUPMODE(true);
                        COMMIT;
                        if lcPgStandDialogPage.RUNMODAL IN [ACTION::LookupOK, ACTION::OK] then begin
                            lcRecPaymentSchedule.Get("Entry No.");
                            lcPgStandDialogPage.GetBankInformation(lcRecPaymentSchedule."Payment Method Code", lcRecPaymentSchedule."Preferred Bank Account Code");
                            lcRecPaymentSchedule.validate("Payment Method Code");
                            lcRecPaymentSchedule.validate("Preferred Bank Account Code");
                            lcRecPaymentSchedule.Modify();
                        end;
                    end;

                }
                action(UpdateBanks)
                {
                    ApplicationArea = All;
                    Caption = 'Update Banks', Comment = 'ESM="Actualizar bancos"';
                    Visible = not NowShowActions;
                    Image = RefreshLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    trigger
                    OnAction()
                    var
                        lcText0001: label '¿Desea actualizar el banco preferido para las lineas seleccionadas?';
                    begin
                        if CONFIRM(lcText0001, false) then
                            fnUpdateReferenceBank;

                    end;
                }
            }
        }
    }
    trigger OnOpenPage()
    var
        lcRecUserSetup: Record "User Setup";
    begin
        lcRecUserSetup.Get(UserId);
        if not lcRecUserSetup."View Schedule" then
            Error('No tienes permiso para ver cronograma de pagos.');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        SetStatusEntry;
        SetPostingGroupBuffer();
    end;

    trigger OnAfterGetRecord()
    begin
        fnGetVendorInfo;
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

    procedure SetStatusEntry()
    begin
        case Status of
            Status::Procesado:
                begin
                    sStyleRowStateShared := 'StandardAccent';
                    EnableTotalPay := false;
                end;

            Status::Pendiente:
                begin
                    sStyleRowStateShared := 'Standard';
                    EnableTotalPay := true;
                end;

            Status::"Por Pagar":
                begin
                    sStyleRowStateShared := 'Ambiguous';
                    EnableTotalPay := false;
                end;
        end

    end;

    procedure fnSetViewActions(pnotViewActions: Boolean)
    begin
        NowShowActions := pnotViewActions;
    end;

    procedure fnUpdateReferenceBank()
    var

        lcRecPaymentSchedule: Record "Payment Schedule";
        lcRecVendor: Record "Vendor";
        lcRecCustomer: Record "Customer";
        lcRecEmployee: Record Employee;
    begin
        lcRecPaymentSchedule.Reset();
        lcRecPaymentSchedule.SETFILTER(Status, '<>%1&<>%2', lcRecPaymentSchedule.Status::"Por Pagar", lcRecPaymentSchedule.Status::Pagado);
        if lcRecPaymentSchedule.FINDSET then
            repeat
                case "Type Source" of
                    "Type Source"::"Vendor Entries":
                        begin
                            lcRecVendor.Reset();
                            lcRecVendor.SetRange("No.", lcRecPaymentSchedule."VAT Registration No.");
                            if lcRecVendor.Find('-') then begin
                                case true of
                                    lcRecPaymentSchedule."Currency Code" = '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecVendor."Preferred Bank Account Code");
                                    lcRecPaymentSchedule."Currency Code" <> '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecVendor."Preferred Bank Account Code ME");
                                end;
                            end;
                        end;
                    "Type Source"::"Customer Entries":
                        begin
                            lcRecCustomer.Reset();
                            lcRecCustomer.SetRange("No.", lcRecPaymentSchedule."VAT Registration No.");
                            if lcRecCustomer.Find('-') then begin
                                case true of
                                    lcRecPaymentSchedule."Currency Code" = '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecCustomer."Preferred Bank Account Code");
                                    lcRecPaymentSchedule."Currency Code" <> '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecCustomer."Preferred Bank Account Code ME");
                                end;
                            end;
                        end;
                    "Type Source"::"Employee Entries":
                        begin
                            if lcRecEmployee.Get(lcRecPaymentSchedule."VAT Registration No.") then begin
                                case true of
                                    lcRecPaymentSchedule."Currency Code" = '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecEmployee."Preferred Bank Account Code MN");
                                    lcRecPaymentSchedule."Currency Code" <> '':
                                        lcRecPaymentSchedule.validate("Preferred Bank Account Code", lcRecEmployee."Preferred Bank Account Code ME");
                                end;
                            end;
                        end;
                end;
                lcRecPaymentSchedule.Modify();
            until lcRecPaymentSchedule.NEXT = 0;

    end;

    local procedure SetPostingGroupBuffer()
    begin
        CurrPage.SLPostingGroupBuffer.Page.SetPostingBufferEntries();
    end;

    procedure fnProcessAction()
    var

        lcRecPaymentSchedule: Record "Payment Schedule";
        lcCuMPWUtilities: Codeunit "Payment Schedule Utility";
        lcText0001: label 'Existen lineas del cronograma de pago con banco proveedor vacio, estas lineas no serán procesadas.';
        lcText0002: label '¿Desea enviar %1 registro(s) a "Procesar" para Pago?';
        lcText0003: label 'Existen lineas del cronograma de pago con N° Banco Ref vacio, estas lineas no pueden ser procesadas.';
    begin
        CLEAR(lcRecPaymentSchedule);
        CLEAR(lcCuMPWUtilities);

        CurrPage.SETSELECTIONFILTER(lcRecPaymentSchedule);


        lcRecPaymentSchedule.SETFILTER("Reference Bank Acc. No.", '%1|%2', '', '-');
        if lcRecPaymentSchedule.Count > 0 then begin
            lcCuMPWUtilities.fnMessagenotification(lcText0003);
            exit;
        end;

        CLEAR(lcRecPaymentSchedule);
        lcRecPaymentSchedule.SETFILTER("Preferred Bank Account Code", '%1', '');
        if lcRecPaymentSchedule.Count > 0 then
            lcCuMPWUtilities.fnMessagenotification(lcText0001);

        CLEAR(lcRecPaymentSchedule);
        CurrPage.SETSELECTIONFILTER(lcRecPaymentSchedule);
        lcRecPaymentSchedule.SETFILTER("Preferred Bank Account Code", '<>%1', '');
        lcRecPaymentSchedule.SETFILTER(Status, '%1', lcRecPaymentSchedule.Status::Pendiente);

        if lcRecPaymentSchedule.Count = 0 then
            exit;

        if not Confirm(StrSubstNo(lcText0002, lcRecPaymentSchedule.Count), false) then
            exit;

        lcRecPaymentSchedule.FindSet();
        repeat
            lcRecPaymentSchedule.Status := lcRecPaymentSchedule.Status::Procesado;
            lcRecPaymentSchedule."Process Date" := CurrentDateTime;
            lcRecPaymentSchedule."Process Date 2" := WorkDate();
            lcRecPaymentSchedule.Modify();
        until lcRecPaymentSchedule.Next() = 0;

        CurrPage.Update();
        //--
        //SetStatusEntry;
    end;

    var

        rptGenPaymentSchedule: Report "Generate Payment Schedule";
        recCronogramaPago: Record "Payment Schedule";
        cuUtilities: Codeunit "Payment Schedule Utility";
        recSelectionFilter: Record "Payment Schedule";
        recCustomer: Record "Customer";
        recCustomerBankAccount: Record "Customer Bank Account";
        recVendor: Record "Vendor";
        recVendorBankAccount: Record "Vendor Bank Account";
        sStyleRowStateShared: Text;
        EnableTotalPay: Boolean;
        NowShowActions: Boolean;
        Table81: Record 81;
        gAccountBankNation: Text;
}