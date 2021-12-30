report 51011 "Generate Payment Schedule"
{
    Caption = 'Generate Payment Schedule', Comment = 'ESM="Generar Pagos"';
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            DataItemTableView = where(number = const(1));
            trigger OnPreDataItem();
            begin
                EmplLedgerEntry.Reset();
                EmplLedgerEntry.SetRange("PS Due Date", 0D);
                if EmplLedgerEntry.FindFirst() then
                    repeat
                        EmplLedgerEntry."PS Due Date" := EmplLedgerEntry."Posting Date";
                        EmplLedgerEntry.Modify();
                    until EmplLedgerEntry.Next() = 0;
                Commit();
                if DueDate = 0D then
                    ERROR('Ingresar una fecha correspondiente');
            end;

            trigger OnAfterGetRecord();
            begin
                CreateLinesFromCustomerLedgerEntries();
                CreateLinesFromVendorLedgerEntries();
                CreateLinesFromEmployeeLedgerEntries();
            end;

        }
    }

    requestpage
    {
        layout
        {
            area(content)
            {
                group(GroupName)
                {
                    Caption = 'Options', Comment = 'ESM="Opciones"';

                    field("Fecha Vencimiento"; DueDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Due Date', Comment = 'ESM="Fecha vencimiento"';
                    }
                    field("Grupo Contable"; VendorPostingGroupCode)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor Posting Group', Comment = 'ESM="Grupo registro Proveedor."';
                        TableRelation = "Vendor Posting Group".Code where("PS Not Show" = const(false));
                    }
                    field(VendorNo; VendorNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Vendor No.', Comment = 'ESM="N° Proveedor"';
                        TableRelation = Vendor."No.";
                    }
                    field(EmplPstgGroup; EmplPostingGroupCode)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Employee Posting Group', Comment = 'ESM="Grupo registro empleado"';
                        TableRelation = "Employee Posting Group".Code where("PS Not Show" = const(false));
                    }
                    field(EmployeeNo; EmployeeNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Employee No.', Comment = 'ESM="N° Empleado"';
                        TableRelation = Employee;
                    }
                    //
                    field(CustPstgGroup; CustPostingGroupCode)
                    {
                        ApplicationArea = ALl;
                        Caption = 'Customer Posting Group', Comment = 'ESM="Grupo registro Cliente"';
                        TableRelation = "Customer Posting Group".Code where("Say Cronograma" = const(true));
                    }
                    field(CustomerNo; CustomerNo)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer No.', Comment = 'ESM="N° Cliente"';
                        TableRelation = Customer;
                    }
                    field("Devolucion NC"; ReturnCrMemo)
                    {
                        ApplicationArea = All;
                        Caption = 'Return Cr. Memo No.', Comment = 'ESM="Devolución NC"';
                        Visible = false;
                    }

                    field("T.C. DOLARIZADO"; gExchangeRateReference)
                    {
                        ApplicationArea = All;
                        Caption = 'T.C. DOLARIZADO', Comment = 'ESM="T.C. DOLARIZADO"';
                        Visible = true;
                        DecimalPlaces = 0 : 3;
                    }
                }
            }
        }
    }


    trigger OnPostReport();
    var
    begin
        MESSAGE('Proceso Finalizado');
    end;

    trigger OnInitReport()
    begin
        fnInitExchangeRateReference;
    end;

    local procedure CreateLinesFromVendorLedgerEntries()
    var
        RetentionMgt: Codeunit "Retention Management";
        IsInvoice: Boolean;
    begin
        if not ReturnCrMemo then begin
            if DueDate <> 0D then
                VendorLedgerEntry.SetRange(VendorLedgerEntry."Due Date", 0D, DueDate);

            if VendorPostingGroupCode <> '' then
                VendorLedgerEntry.SetRange(VendorLedgerEntry."Vendor Posting Group", VendorPostingGroupCode);

            if VendorNo <> '' then
                VendorLedgerEntry.SetRange(VendorLedgerEntry."Vendor No.", VendorNo);
            VendorLedgerEntry.SetAutoCalcFields("PS Not Show Payment Schedule");
            //VendorLedgerEntry.SetRange("Filter Grupo Contable", FALSE);
            VendorLedgerEntry.CalcFields("Remaining Amount");
            VendorLedgerEntry.SetFilter("Remaining Amount", '<%1', 0);
            VendorLedgerEntry.SetRange("PS Not Show Payment Schedule", false);
            /*VendorLedgerEntry.SetRange("Status Entry", VendorLedgerEntry."Status Entry"::" ");
            VendorLedgerEntry.SetFilter("Setup Source Code", '<>%1|<>%2|<>%3|<>%4|<>%5|<>%6|<>%7|<>%8',
                                            VendorLedgerEntry."Setup Source Code"::"Pagare Det",
                                            VendorLedgerEntry."Setup Source Code"::Provision,
                                            VendorLedgerEntry."Setup Source Code"::"Carta Fianza Cab",
                                            VendorLedgerEntry."Setup Source Code"::"Carta Fianza Det",
                                            VendorLedgerEntry."Setup Source Code"::Leasing,
                                            VendorLedgerEntry."Setup Source Code"::"Leasing-Sure",
                                            VendorLedgerEntry."Setup Source Code"::"Compesation Leasing",
                                            VendorLedgerEntry."Setup Source Code"::"Leasing-default");*/
            if VendorLedgerEntry.FindSet() then
                repeat
                //VALIDACION NO GENERAR REGISTROS REPETIDOS AL CRONOGRAMA
                /*if VendorLedgerEntry."Setup Source Code" IN
                               [VendorLedgerEntry."Setup Source Code"::"Provision AGR",
                                VendorLedgerEntry."Setup Source Code"::"Provision Purch. Order Items",
                                VendorLedgerEntry."Setup Source Code"::"Provision Alquiler",
                                VendorLedgerEntry."Setup Source Code"::"Provision General"] then begin
                end else */
                begin
                    PaymentSchedule2.Reset();
                    PaymentSchedule2.SetRange("Source Entry No.", VendorLedgerEntry."Entry No.");
                    PaymentSchedule2.SetFilter(Status, '<>%1', PaymentSchedule2.Status::Pagado);
                    if not PaymentSchedule2.FindSet() then begin
                        IsInvoice := false;
                        VendorLedgerEntry.CalcFields(VendorLedgerEntry.Amount);
                        VendorLedgerEntry.CalcFields(VendorLedgerEntry."Remaining Amount");
                        VendorLedgerEntry.CalcFields(VendorLedgerEntry."Remaining Amt. (LCY)");

                        PaymentSchedule.Reset();
                        if PaymentSchedule.FindLast() then
                            LineNo := PaymentSchedule."Entry No.";

                        LineNo += 1;
                        PaymentSchedule.Init();
                        PaymentSchedule."Entry No." := LineNo;
                        PaymentSchedule."Posting Date" := VendorLedgerEntry."Posting Date";
                        PaymentSchedule."Document Date" := VendorLedgerEntry."Document Date";
                        PaymentSchedule."VAT Registration No." := VendorLedgerEntry."Vendor No.";
                        PaymentSchedule."Business Name" := VendorLedgerEntry."Vendor Name";
                        PaymentSchedule.Description := VendorLedgerEntry.Description;
                        PaymentSchedule."Document No." := VendorLedgerEntry."Document No.";

                        //---Importe Original
                        VendLedgEntry2.Reset();
                        VendLedgEntry2.SetRange("Document No.", VendorLedgerEntry."Document No.");
                        VendLedgEntry2.SetRange("Document Type", VendLedgEntry2."Document Type"::Invoice);
                        if VendLedgEntry2.FindFirst() then begin
                            VendLedgEntry2.CalcFields(Amount);
                            PaymentSchedule."Original Amount" := VendLedgEntry2.Amount;
                            IsInvoice := true;
                        end;

                        //---

                        //--Tipo Detraccion 
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", VendorLedgerEntry."Document No.");
                        PurchInvHeader.SetRange("Purch. Detraction", TRUE);
                        if PurchInvHeader.FindFirst() then begin
                            PaymentSchedule."Service Type" := PurchInvHeader."Type of Service";
                            PaymentSchedule."Operation Type" := PurchInvHeader."Type of Operation";
                            //(Servicio)
                            DetractionSerOperation.Reset();
                            DetractionSerOperation.SetFilter(DetractionSerOperation."Type Services/Operation", '%1', 0);
                            DetractionSerOperation.SetFilter(Code, PurchInvHeader."Type of Service");
                            if DetractionSerOperation.FindSet() then begin
                                PaymentSchedule."% Detraction" := DetractionSerOperation."Detraction Percentage";
                                PaymentSchedule."Description Service" := DetractionSerOperation.Description;
                            end;

                            //(Operacion)
                            DetractionSerOperation.Reset();
                            DetractionSerOperation.SetFilter(DetractionSerOperation."Type Services/Operation", '%1', 1);
                            DetractionSerOperation.SetFilter(Code, PurchInvHeader."Type of Operation");
                            if DetractionSerOperation.FindSet() then
                                PaymentSchedule."Description OP." := DetractionSerOperation.Description;
                        end;

                        PaymentSchedule."External Document No." := VendorLedgerEntry."External Document No.";
                        PaymentSchedule."Accountant receipt Date" := VendorLedgerEntry."Accountant receipt date";
                        PaymentSchedule."Due Date" := VendorLedgerEntry."Due Date";
                        PaymentSchedule."Calculate Date" := DueDate;
                        PaymentSchedule."Posting Group" := VendorLedgerEntry."Vendor Posting Group";
                        PaymentSchedule."Payment Method Code" := VendorLedgerEntry."Payment Method Code";//++ULN::RRR 002  2018.12.26  v.001
                        PaymentSchedule."Vend./Cust. Account No." := VendorLedgerEntry."Payables Account";
                        PaymentSchedule."Delay Days" := (CALCDATE('<-CD>', PaymentSchedule."Due Date") - CALCDATE('<CD>', DueDate));
                        PaymentSchedule."Currency Code" := VendorLedgerEntry."Currency Code";
                        PaymentSchedule.Amount := VendorLedgerEntry."Remaining Amount";
                        PaymentSchedule."Amount LCY" := VendorLedgerEntry."Remaining Amt. (LCY)";
                        PaymentSchedule."Total a Pagar" := VendorLedgerEntry."Remaining Amount";
                        PaymentSchedule."Source Entry No." := VendorLedgerEntry."Entry No.";
                        PaymentSchedule."Setup Source Code" := VendorLedgerEntry."Setup Source Code";
                        PaymentSchedule."Type Source" := PaymentSchedule."Type Source"::"Vendor Entries";
                        //PaymentSchedule."Payment Terms Code" := VendorLedgerEntry."Payment Terms Code";
                        PaymentSchedule."Preferred Bank Account Code" := '';
                        PaymentSchedule."Bank Account No." := '';

                        // Vendor.Reset();
                        // Vendor.SetRange("No.", PaymentSchedule."VAT Registration No.");
                        if VendorLedgerEntry."Payment Bank Account No." <> '' then
                            PaymentSchedule."Preferred Bank Account Code" := VendorLedgerEntry."Payment Bank Account No."
                        else
                            if Vendor.Get(PaymentSchedule."VAT Registration No.") then begin
                                if VendorLedgerEntry."Currency Code" = '' then
                                    PaymentSchedule.validate("Preferred Bank Account Code", Vendor."Preferred Bank Account Code")
                                else
                                    PaymentSchedule.validate("Preferred Bank Account Code", Vendor."Preferred Bank Account Code ME");
                            end;
                        PaymentSchedule."User ID" := UserId;
                        PaymentSchedule."Source User Id." := VendorLedgerEntry."User ID";
                        //RetentionMgt.SetAutomateRetentionCheck(PaymentSchedule.Retention, PaymentSchedule."VAT Registration No.", PaymentSchedule."Document Date", '', ABS(PaymentSchedule."Total a Pagar"));
                        //Posting Group-----------------------------------------------
                        Clear(gVariant);
                        gVariant := VendorLedgerEntry;
                        fnInsertDataExt(PaymentSchedule, gVariant);
                        //Posting Group-----------------------------------------------
                        //Dollarized-----------------------------------------------
                        Clear(gVariant);
                        gVariant := VendorLedgerEntry;
                        fnInsertDollarized(PaymentSchedule, gVariant);
                        //Dollarized-----------------------------------------------

                        PaymentSchedule.Insert();
                    end;
                end;
                until VendorLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure CreateLinesFromCustomerLedgerEntries()
    begin

        //=====MOV CLIENTES
        if DueDate <> 0D then
            CustLedgerEntry.SetRange(CustLedgerEntry."Due Date", 0D, DueDate);

        if CustPostingGroupCode <> '' then begin
            CustLedgerEntry.SetFilter("Customer Posting Group", CustPostingGroupCode);
        end else begin
            fnCustPostingGroupCronog();
            CustLedgerEntry.SetFilter("Customer Posting Group", gCustPostGroupCronog);
        end;

        if CustomerNo <> '' then
            CustLedgerEntry.SetRange(CustLedgerEntry."Customer No.", CustomerNo);
        CustLedgerEntry.CalcFields(CustLedgerEntry."Remaining Amount");
        CustLedgerEntry.SetFilter(CustLedgerEntry."Remaining Amount", '<%1', 0);
        //CustLedgerEntry.SetRange(CustLedgerEntry.Return, TRUE);
        //CustLedgerEntry.SetRange("Legal Document", '07');
        //CustLedgerEntry.SetFilter("Setup Source Code", '<>%1|<>%2|<>%3|<>%4', CustLedgerEntry."Setup Source Code"::"Pagare Det", CustLedgerEntry."Setup Source Code"::Provision, CustLedgerEntry."Setup Source Code"::"Carta Fianza Cab",
        //                              CustLedgerEntry."Setup Source Code"::"Carta Fianza Det");
        if CustLedgerEntry.FindSet() then
            repeat

                //VALIDACION NO GENERAR REGISTROS REPETIDOS AL CRONOGRAMA
                PaymentSchedule2.Reset();
                PaymentSchedule2.SetRange("Source Entry No.", CustLedgerEntry."Entry No.");
                if not PaymentSchedule2.FindSet() then begin
                    CustLedgerEntry.CalcFields(CustLedgerEntry.Amount);
                    CustLedgerEntry.CalcFields(CustLedgerEntry."Remaining Amount");
                    CustLedgerEntry.CalcFields(CustLedgerEntry."Remaining Amt. (LCY)");

                    PaymentSchedule.Reset();
                    if PaymentSchedule.FindLast() then
                        LineNo := PaymentSchedule."Entry No.";

                    LineNo += 1;
                    PaymentSchedule.Init();
                    PaymentSchedule."Entry No." := LineNo;
                    PaymentSchedule."Posting Date" := CustLedgerEntry."Posting Date";
                    PaymentSchedule."Document Date" := CustLedgerEntry."Document Date";
                    PaymentSchedule."VAT Registration No." := CustLedgerEntry."Customer No.";
                    PaymentSchedule."Business Name" := CustLedgerEntry."Customer Name";
                    PaymentSchedule.Description := CustLedgerEntry.Description;

                    PaymentSchedule."Document No." := CustLedgerEntry."Document No.";
                    PaymentSchedule."External Document No." := CustLedgerEntry."External Document No.";
                    //PaymentSchedule."Receipt Date" := CustLedgerEntry."Accounting Receipt Date";
                    PaymentSchedule."Due Date" := CustLedgerEntry."Due Date";
                    PaymentSchedule."Calculate Date" := DueDate;
                    PaymentSchedule."Payment Method Code" := CustLedgerEntry."Payment Method Code";//++ULN::RRR 002  2018.12.26  v.001
                                                                                                   //--
                    PaymentSchedule."Delay Days" := (CalcDate('<-CD>', PaymentSchedule."Due Date") - CalcDate('<CD>', DueDate));
                    PaymentSchedule."Currency Code" := CustLedgerEntry."Currency Code";
                    //--

                    PaymentSchedule.Amount := CustLedgerEntry."Remaining Amount";
                    PaymentSchedule."Amount LCY" := CustLedgerEntry."Remaining Amt. (LCY)";
                    PaymentSchedule."Total a Pagar" := CustLedgerEntry."Remaining Amount";
                    PaymentSchedule."Source Entry No." := CustLedgerEntry."Entry No.";
                    //----
                    PaymentSchedule."Setup Source Code" := CustLedgerEntry."Setup Source Code";
                    PaymentSchedule."Type Source" := PaymentSchedule."Type Source"::"Customer Entries";
                    PaymentSchedule."Payment Terms Code" := CustLedgerEntry."Payment Terms Code";
                    //-------------------------
                    PaymentSchedule."Preferred Bank Account Code" := '';
                    PaymentSchedule."Bank Account No." := '';
                    PaymentSchedule."Posting Group" := CustLedgerEntry."Customer Posting Group";
                    PaymentSchedule."Vend./Cust. Account No." := CustLedgerEntry."Receivables Account";
                    if CustLedgerEntry."Bank Cash Outly" <> '' then begin
                        PaymentSchedule.validate("Preferred Bank Account Code", CustLedgerEntry."Bank Cash Outly");

                    end else begin
                        Customer.Reset();
                        Customer.SetRange("No.", PaymentSchedule."VAT Registration No.");
                        if Customer.FindSet() then begin
                            if CustLedgerEntry."Currency Code" = '' then
                                PaymentSchedule.validate("Preferred Bank Account Code", Customer."Preferred Bank Account Code")
                            else
                                PaymentSchedule.validate("Preferred Bank Account Code", Customer."Preferred Bank Account Code ME");
                        end;
                    end;

                    //------------------------
                    PaymentSchedule."User ID" := UserId;
                    PaymentSchedule."Source User Id." := CustLedgerEntry."User ID";
                    //
                    //Posting Group-----------------------------------------------
                    Clear(gVariant);
                    gVariant := CustLedgerEntry;
                    fnInsertDataExt(PaymentSchedule, gVariant);
                    //Posting Group-----------------------------------------------
                    //Dollarized-----------------------------------------------
                    Clear(gVariant);
                    gVariant := CustLedgerEntry;
                    fnInsertDollarized(PaymentSchedule, gVariant);
                    //Dollarized-----------------------------------------------
                    PaymentSchedule.Insert();
                end;
            until CustLedgerEntry.NEXT = 0;
    end;

    local procedure CreateLinesFromEmployeeLedgerEntries()
    begin
        if not ReturnCrMemo then begin
            if DueDate <> 0D then
                EmplLedgerEntry.SetRange("PS Due Date", 0D, DueDate);

            if VendorPostingGroupCode <> '' then
                EmplLedgerEntry.SetRange("Employee Posting Group", VendorPostingGroupCode);

            if EmployeeNo <> '' then
                EmplLedgerEntry.SetFilter("Employee No.", EmployeeNo);
            EmplLedgerEntry.SetAutoCalcFields("PS Not Show Payment Schedule");
            //EmplLedgerEntry.SetRange("Filter Grupo Contable", FALSE);
            EmplLedgerEntry.CalcFields("Remaining Amount");
            EmplLedgerEntry.SetFilter("Remaining Amount", '<%1', 0);
            EmplLedgerEntry.SetRange("PS Not Show Payment Schedule", false);
            /*EmplLedgerEntry.SetRange("Status Entry", EmplLedgerEntry."Status Entry"::" ");
            EmplLedgerEntry.SetFilter("Setup Source Code", '<>%1|<>%2|<>%3|<>%4|<>%5|<>%6|<>%7|<>%8',
                                            EmplLedgerEntry."Setup Source Code"::"Pagare Det",
                                            EmplLedgerEntry."Setup Source Code"::Provision,
                                            EmplLedgerEntry."Setup Source Code"::"Carta Fianza Cab",
                                            EmplLedgerEntry."Setup Source Code"::"Carta Fianza Det",
                                            EmplLedgerEntry."Setup Source Code"::Leasing,
                                            EmplLedgerEntry."Setup Source Code"::"Leasing-Sure",
                                            EmplLedgerEntry."Setup Source Code"::"Compesation Leasing",
                                            EmplLedgerEntry."Setup Source Code"::"Leasing-default");*/
            if EmplLedgerEntry.FindSet() then
                repeat
                //VALIDACION NO GENERAR REGISTROS REPETIDOS AL CRONOGRAMA
                /*if EmplLedgerEntry."Setup Source Code" IN
                               [EmplLedgerEntry."Setup Source Code"::"Provision AGR",
                                EmplLedgerEntry."Setup Source Code"::"Provision Purch. Order Items",
                                EmplLedgerEntry."Setup Source Code"::"Provision Alquiler",
                                EmplLedgerEntry."Setup Source Code"::"Provision General"] then begin
                end else */
                begin
                    Employee.Get(EmplLedgerEntry."Employee No.");
                    PaymentSchedule2.Reset();
                    PaymentSchedule2.SetRange("Source Entry No.", EmplLedgerEntry."Entry No.");
                    PaymentSchedule2.SetFilter(Status, '<>%1', PaymentSchedule2.Status::Pagado);
                    if not PaymentSchedule2.FindSet() then begin
                        EmplLedgerEntry.CalcFields(EmplLedgerEntry.Amount);
                        EmplLedgerEntry.CalcFields(EmplLedgerEntry."Remaining Amount");
                        EmplLedgerEntry.CalcFields(EmplLedgerEntry."Remaining Amt. (LCY)");

                        PaymentSchedule.Reset();
                        if PaymentSchedule.FindLast() then
                            LineNo := PaymentSchedule."Entry No.";

                        LineNo += 1;
                        PaymentSchedule.Init();
                        PaymentSchedule."Entry No." := LineNo;
                        PaymentSchedule."Posting Date" := EmplLedgerEntry."Posting Date";
                        PaymentSchedule."Document Date" := EmplLedgerEntry."Posting Date";//EmplLedgerEntry."Document Date";
                        PaymentSchedule."VAT Registration No." := EmplLedgerEntry."Employee No.";
                        PaymentSchedule."Business Name" := Employee.FullName();
                        PaymentSchedule.Description := EmplLedgerEntry.Description;
                        PaymentSchedule."Document No." := EmplLedgerEntry."Document No.";

                        //---Importe Original
                        EmplLedgerEntry2.Reset();
                        EmplLedgerEntry2.SetRange("Document No.", EmplLedgerEntry."Document No.");
                        //EmplLedgerEntry2.SetRange("Document Type", EmplLedgerEntry2."Document Type"::Invoice);
                        if EmplLedgerEntry2.FindFirst() then begin
                            EmplLedgerEntry2.CalcFields(Amount);
                            PaymentSchedule."Original Amount" := EmplLedgerEntry2.Amount;
                        end;

                        //---

                        //--Tipo Detraccion 
                        PurchInvHeader.Reset();
                        PurchInvHeader.SetRange("No.", EmplLedgerEntry."Document No.");
                        PurchInvHeader.SetRange("Purch. Detraction", TRUE);
                        if PurchInvHeader.FindFirst() then begin
                            PaymentSchedule."Service Type" := PurchInvHeader."Type of Service";
                            PaymentSchedule."Operation Type" := PurchInvHeader."Type of Operation";
                            //(Servicio)
                            DetractionSerOperation.Reset();
                            DetractionSerOperation.SetFilter(DetractionSerOperation."Type Services/Operation", '%1', 0);
                            DetractionSerOperation.SetFilter(Code, PurchInvHeader."Type of Service");
                            if DetractionSerOperation.FindSet() then begin
                                PaymentSchedule."% Detraction" := DetractionSerOperation."Detraction Percentage";
                                PaymentSchedule."Description Service" := DetractionSerOperation.Description;
                            end;

                            //(Operacion)
                            DetractionSerOperation.Reset();
                            DetractionSerOperation.SetFilter(DetractionSerOperation."Type Services/Operation", '%1', 1);
                            DetractionSerOperation.SetFilter(Code, PurchInvHeader."Type of Operation");
                            if DetractionSerOperation.FindSet() then
                                PaymentSchedule."Description OP." := DetractionSerOperation.Description;
                        end;

                        PaymentSchedule."External Document No." := EmplLedgerEntry."External Document No.";
                        //PaymentSchedule."Accountant receipt Date" := EmplLedgerEntry."Accountant receipt Date";
                        PaymentSchedule."Due Date" := EmplLedgerEntry."PS Due Date";
                        PaymentSchedule."Calculate Date" := DueDate;
                        PaymentSchedule."Posting Group" := EmplLedgerEntry."Employee Posting Group";
                        PaymentSchedule."Payment Method Code" := EmplLedgerEntry."Payment Method Code";//++ULN::RRR 002  2018.12.26  v.001
                        PaymentSchedule."Vend./Cust. Account No." := EmplLedgerEntry."Payables Account";
                        PaymentSchedule."Delay Days" := (CALCDATE('<-CD>', PaymentSchedule."Due Date") - CALCDATE('<CD>', DueDate));
                        PaymentSchedule."Currency Code" := EmplLedgerEntry."Currency Code";
                        PaymentSchedule.Amount := EmplLedgerEntry."Remaining Amount";
                        PaymentSchedule."Amount LCY" := EmplLedgerEntry."Remaining Amt. (LCY)";
                        PaymentSchedule."Total a Pagar" := EmplLedgerEntry."Remaining Amount";
                        PaymentSchedule."Source Entry No." := EmplLedgerEntry."Entry No.";
                        PaymentSchedule."Setup Source Code" := EmplLedgerEntry."Setup Source Code";
                        PaymentSchedule."Type Source" := PaymentSchedule."Type Source"::"Employee Entries";
                        //PaymentSchedule."Payment Terms Code" := EmplLedgerEntry."Payment Terms Code";
                        PaymentSchedule."Preferred Bank Account Code" := '';
                        PaymentSchedule."Bank Account No." := '';

                        Employee.Reset();
                        Employee.SetRange("No.", PaymentSchedule."VAT Registration No.");
                        if Employee.FindSet() then begin
                            if EmplLedgerEntry."Currency Code" = '' then
                                PaymentSchedule.validate("Preferred Bank Account Code", Employee."Preferred Bank Account Code MN")
                            else
                                PaymentSchedule.validate("Preferred Bank Account Code", Employee."Preferred Bank Account Code ME");
                        end;
                        PaymentSchedule."User ID" := UserId;
                        PaymentSchedule."Source User Id." := EmplLedgerEntry."User ID";
                        //Posting Group-----------------------------------------------
                        Clear(gVariant);
                        gVariant := EmplLedgerEntry;
                        fnInsertDataExt(PaymentSchedule, gVariant);
                        //Posting Group-----------------------------------------------
                        //Dollarized-----------------------------------------------
                        Clear(gVariant);
                        gVariant := EmplLedgerEntry;
                        fnInsertDollarized(PaymentSchedule, gVariant);
                        //Dollarized-----------------------------------------------
                        PaymentSchedule.Insert();
                    end;
                end;
                until EmplLedgerEntry.NEXT = 0;
        end;
    end;

    local procedure fnCustPostingGroupCronog()
    var
        CustPostGroup: Record "Customer Posting Group";

    begin
        Clear(gCustPostGroupCronog);
        CustPostGroup.Reset();
        CustPostGroup.SetRange("Say Cronograma", true);
        if CustPostGroup.FindSet() then
            repeat
                if gCustPostGroupCronog = '' then begin
                    gCustPostGroupCronog := Format(CustPostGroup.Code);
                end else begin
                    gCustPostGroupCronog += '|' + Format(CustPostGroup.Code);
                end;
            until CustPostGroup.Next() = 0;
        if gCustPostGroupCronog = '' then
            gCustPostGroupCronog := '-';
    end;

    local procedure fnInitExchangeRateReference()
    var
        lcCurrencyExchangeRate: Record "Currency Exchange Rate";
        lcExchangeRateReference: Decimal;
    begin
        gExchangeRateReference := 0;
        lcCurrencyExchangeRate.Reset();
        gExchangeRateReference := lcCurrencyExchangeRate.GetCurrentCurrencyFactor('USD');
        if gExchangeRateReference <> 0 then
            gExchangeRateReference := 1 / gExchangeRateReference;
    end;

    local procedure fnInsertDollarized(var parPaymentSchedule: Record "Payment Schedule"; var Variant: Variant)
    var
        lcCurrencyExchangeRate: Record "Currency Exchange Rate";
        lcExchangeRateReference: Decimal;
        RecRef: RecordRef;
        lcRecEmployeeLedgerEntry: Record "Employee Ledger Entry";
        lcRecVendorLedgerEntry: Record "Vendor Ledger Entry";
        lcRecCustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        RecRef.GetTable(Variant);
        parPaymentSchedule."T.C. Dollarized" := gExchangeRateReference;
        case RecRef.Number() of
            DATABASE::"Employee Ledger Entry":
                begin
                    RecRef.SetTable(lcRecEmployeeLedgerEntry);
                    parPaymentSchedule.Dollarized := lcRecEmployeeLedgerEntry."Remaining Amount";
                    parPaymentSchedule."Source Currency Factor" := lcRecEmployeeLedgerEntry."Original Currency Factor";
                    CASE parPaymentSchedule."Currency Code" of
                        'USD':
                            parPaymentSchedule.Dollarized := lcRecEmployeeLedgerEntry."Remaining Amount";
                        ELSE
                            parPaymentSchedule.Dollarized := ROUND(lcRecEmployeeLedgerEntry."Remaining Amt. (LCY)" / gExchangeRateReference, 0.01, '=');
                    END;
                end;
            DATABASE::"Vendor Ledger Entry":
                begin
                    RecRef.SetTable(lcRecVendorLedgerEntry);
                    parPaymentSchedule.Dollarized := lcRecVendorLedgerEntry."Remaining Amount";
                    parPaymentSchedule."Source Currency Factor" := lcRecVendorLedgerEntry."Original Currency Factor";
                    CASE parPaymentSchedule."Currency Code" of
                        'USD':
                            parPaymentSchedule.Dollarized := lcRecVendorLedgerEntry."Remaining Amount";
                        ELSE
                            parPaymentSchedule.Dollarized := ROUND(lcRecVendorLedgerEntry."Remaining Amt. (LCY)" / gExchangeRateReference, 0.01, '=');
                    END;
                end;
            DATABASE::"Cust. Ledger Entry":
                begin
                    RecRef.SetTable(lcRecCustLedgerEntry);
                    parPaymentSchedule.Dollarized := lcRecCustLedgerEntry."Remaining Amount";
                    parPaymentSchedule."Source Currency Factor" := lcRecCustLedgerEntry."Original Currency Factor";
                    CASE parPaymentSchedule."Currency Code" of
                        'USD':
                            parPaymentSchedule.Dollarized := lcRecCustLedgerEntry."Remaining Amount";
                        ELSE
                            parPaymentSchedule.Dollarized := ROUND(lcRecCustLedgerEntry."Remaining Amt. (LCY)" / gExchangeRateReference, 0.01, '=');
                    END;
                end;
        end;

    end;

    local procedure fnInsertDataExt(var parPaymentSchedule: Record "Payment Schedule"; var Variant: Variant)
    var
        RecRef: RecordRef;
        lcRecEmployeePostingGroup: Record "Employee Posting Group";
        lcRecVendorPostingGroup: Record "Vendor Posting Group";
        lcRecCustomerPostingGroup: Record "Customer Posting Group";
        lcRecPurchInvHeader: Record "Purch. Inv. Header";
    begin
        IF parPaymentSchedule."Posting Group" = '' then
            EXIT;

        RecRef.GetTable(Variant);

        case RecRef.Number() of
            DATABASE::"Employee Ledger Entry":
                begin
                    IF lcRecEmployeePostingGroup.GET(parPaymentSchedule."Posting Group") then
                        parPaymentSchedule."Vend./Cust. Account No." := lcRecEmployeePostingGroup."Payables Account";
                end;
            DATABASE::"Vendor Ledger Entry":
                begin
                    IF lcRecVendorPostingGroup.GET(parPaymentSchedule."Posting Group") then
                        parPaymentSchedule."Vend./Cust. Account No." := lcRecVendorPostingGroup."Payables Account";

                    if lcRecPurchInvHeader.get(parPaymentSchedule."Document No.") then
                        parPaymentSchedule."Payment Terms Code" := lcRecPurchInvHeader."Payment Terms Code"
                end;
            DATABASE::"Cust. Ledger Entry":
                begin
                    IF lcRecCustomerPostingGroup.GET(parPaymentSchedule."Posting Group") then
                        parPaymentSchedule."Vend./Cust. Account No." := lcRecCustomerPostingGroup."Receivables Account";


                end;
        end;

    end;

    var
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        Employee: Record Employee;
        Tabla81: Record 81;
        PaymentSchedule: Record "Payment Schedule";
        PaymentSchedule2: Record "Payment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        EmplLedgerEntry: Record "Employee Ledger Entry";
        EmplLedgerEntry2: Record "Employee Ledger Entry";
        CustBankAccount: Record "Customer Bank Account";
        VendorBankAccount: Record "Vendor Bank Account";
        EmplBankAccount: Record "ST Employee Bank Account";
        PurchInvHeader: Record "Purch. Inv. Header";
        VendLedgEntry2: Record "Vendor Ledger Entry";
        DetractionSerOperation: Record "Detraction Services Operation";
        VendorNo: Code[250];
        EmployeeNo: Code[250];
        CustomerNo: Code[250];
        VendorPostingGroupCode: Code[250];
        gCustPostGroupCronog: Text;
        EmplPostingGroupCode: Code[250];
        CustPostingGroupCode: Code[250];
        DueDate: Date;
        LineNo: Integer;
        ReturnCrMemo: Boolean;
        gExchangeRateReference: Decimal;

        gVariant: Variant;
}
