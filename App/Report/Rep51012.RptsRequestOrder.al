report 51012 "PR Rpts. Request Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './App/Report/RDLC/Rpts. Request Order.rdl';

    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            DataItemTableView = SORTING("Document Type", "No.");
            RequestFilterFields = "No.";
            column(NumCompra; "Purchase Header"."No.")
            {
            }
            column(Vendedr; gRecVendor.Name)
            {
            }
            column(Ubigeo; gUbigeoDes)
            {
            }
            column(Ubigeo_Vendor; gUbigeoVendor)
            {
            }
            column(Direcc_Vendedor; gRecVendor.Address)
            {
            }
            column(RUC_Vendedor; gRecVendor."VAT Registration No.")
            {
            }
            column(Correo; gRecVendor."E-Mail")
            {
            }
            column(Telefono; gContacPhone)
            {
            }
            column(Fax; gRecVendor."Fax No.")
            {
            }
            column(FechaOC; "Purchase Header"."Requested Receipt Date")
            {
            }
            column(Moneda; "Purchase Header"."Currency Code")
            {
            }
            column(Usuario; UserId)
            {
            }
            column(FechaHoy; Today)
            {
            }
            column(Hora; Time)
            {
            }
            column(LOGO; gRecCompanyInformation.Picture)
            {
            }
            column(Direcc_Empresa; gRecCompanyInformation.Address)
            {
            }

            column(RUC_Empresa; gRecCompanyInformation."VAT Registration No.")
            {
            }
            column(DireccionEntrega; "Purchase Header"."Ship-to Address")
            {
            }
            column(FechaEntrega; "Purchase Header"."Order Date")
            {
            }
            column(FormaPago; gDescripcionTermino)
            {
            }
            column(IncIVA; "Purchase Header"."Amount Including VAT")
            {
            }
            column(ExcIVA; "Purchase Header".Amount)
            {
            }
            column(IVA; "Purchase Header"."Amount Including VAT" - "Purchase Header".Amount)
            {
            }
            column(PorcentajeDescuento; SumPocDes)
            {
            }
            column(ImporteDescuento; SumImpDesc)
            {
            }
            column(ContactoName; gContacName)
            {
            }
            column(Colonia; gRecCompanyInformation."Address 2")
            {
            }
            column(ReceipDate; "Requested Receipt Date")
            {
            }
            column(AddressDocument; gAddressDoc)
            {
            }
            column(PaymentMethodCode; gPaymentMethod)
            {
            }
            column(PurchaseCommentHeader; gPurchaseCommentHeader)
            {
            }
            column(gNamePurchaseperson; gNamePurchaseperson)
            {

            }
            column(gPhonePurchaseperson; gPhonePurchaseperson)
            {

            }
            column(gEmailPurchaseperson; gEmailPurchaseperson)
            {

            }
            column(Purchaser_Code; "Purchaser Code")
            {

            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(Cod_Prod; "Purchase Line"."No.")
                {
                }
                column(Desc; "Purchase Line".Description + ' ' + "Purchase Line"."Description 2" +
                '  ' + gPurchaseComment)
                {
                }
                column(UM; "Purchase Line"."Unit of Measure")
                {
                }
                column(Cant; "Purchase Line".Quantity)
                {
                }
                column(UnPrice; "Purchase Line"."Unit Cost (LCY)")
                {
                }
                column(Descuento; "Purchase Line"."Line Discount Amount")
                {
                }
                column(Total; "Purchase Line".Amount)
                {
                }
                column(TotalProductos; gSumCantidades)
                {
                }
                column(StandarCode; "Purchase Line"."Purchase Standard Code")
                {
                }
                column(ExpectedDate; "Purchase Line"."Expected Receipt Date")
                {
                }
                column(gPurchaseComment; gPurchaseComment)
                {
                }
                column(Des2; "Description 2")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    SumPocDes += "Purchase Line"."Line Discount %";
                    SumImpDesc += "Purchase Line"."Line Discount Amount";
                    gSumCantidades += "Purchase Line".Quantity;

                    gPurchaseComment := '';
                    gRecPurchaseComment.Reset();
                    gRecPurchaseComment.SetRange("Document Type", gRecPurchaseComment."Document Type"::Quote);
                    gRecPurchaseComment.SetRange("No.", "Purchase Line"."Document No.");
                    gRecPurchaseComment.SetRange("Document Line No.", "Purchase Line"."Line No.");
                    if gRecPurchaseComment.FindSet then begin
                        repeat
                            gPurchaseComment += gRecPurchaseComment.Comment + ' ';
                        until gRecPurchaseComment.Next() = 0;
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Purchase Header".Status <> "Purchase Header".Status::Released then
                    Error(Error0001);

                gRecVendor.Reset;
                gRecVendor.Get("Purchase Header"."Buy-from Vendor No.");
                "Purchase Header".CalcFields("Amount Including VAT", Amount);

                gUbigeoVendor := UbigeoMgt.ShowUbigeoDescription(gRecVendor."Country/Region Code",
                                   gRecVendor."Post Code", gRecVendor.City, gRecVendor.County);

                gDescripcionTermino := '';
                gRecPaymentTerms.Reset;
                gRecPaymentTerms.SetRange(Code, "Purchase Header"."Payment Terms Code");
                if gRecPaymentTerms.FindSet then
                    gDescripcionTermino := gRecPaymentTerms.Description;

                gSumCantidades := 0;

                gContacName := '';
                gContacPhone := '';
                gRecContact.Reset;
                gRecContact.SetRange("No.", "Pay-to Contact No.");
                if gRecContact.FindSet then begin
                    gContacName := gRecContact.Name;
                    gContacPhone := gRecContact."Mobile Phone No.";
                end;

                gAddressDoc := "Purchase Header"."Buy-from Address" + ' - ' + "Purchase Header"."Buy-from Address 2" + ' - ' +
                gUbigeoVendor;

                gPaymentMethod := '';
                gRecPaymentMethodCode.Reset;
                gRecPaymentMethodCode.SetRange(Code, "Payment Method Code");
                if gRecPaymentMethodCode.FindSet then
                    gPaymentMethod := gRecPaymentMethodCode.Description;

                gPurchaseCommentHeader := '';
                gRecPurchaseComment.Reset();
                gRecPurchaseComment.SetRange("Document Type", gRecPurchaseComment."Document Type"::Quote);
                gRecPurchaseComment.SetRange("No.", "Purchase Header"."No.");
                gRecPurchaseComment.SetRange("Document Line No.", "Purchase Line"."Line No.");
                if gRecPurchaseComment.FindSet then begin
                    repeat
                        gPurchaseCommentHeader += gRecPurchaseComment.Comment + ' ';
                    until gRecPurchaseComment.Next() = 0;
                end;

                gRecSalespersonPurchase.Reset();
                gRecSalespersonPurchase.SetRange(Code, "Purchase Header"."Purchaser Code");
                if gRecSalespersonPurchase.FindFirst() then begin
                    gNamePurchaseperson := gRecSalespersonPurchase.Name;
                    gPhonePurchaseperson := gRecSalespersonPurchase."Phone No.";
                    gEmailPurchaseperson := gRecSalespersonPurchase."E-Mail";
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        gRecCompanyInformation.Get;
        gRecCompanyInformation.CalcFields(Picture);
        gUbigeoDes := UbigeoMgt.ShowUbigeoDescription(gRecCompanyInformation."Country/Region Code",
            gRecCompanyInformation."Post Code", gRecCompanyInformation.City, gRecCompanyInformation.County);


    end;

    var
        Error0001: Label 'El Documento debe estar lanzado para su impresión';
        gRecVendor: Record Vendor;
        gRecCompanyInformation: Record "Company Information";
        SumPocDes: Decimal;
        SumImpDesc: Decimal;
        gRecPaymentTerms: Record "Payment Terms";
        gSumCantidades: Integer;
        gDescripcionTermino: Text;
        UbigeoMgt: Codeunit "Ubigeo Management";
        gUbigeoDes: Text;
        gUbigeoVendor: Text;
        gRecContact: Record Contact;
        gContacName: Text;
        gContacPhone: Text;
        gAddressDoc: Text;
        gRecPaymentMethodCode: Record "Payment Method";
        gPaymentMethod: Text;
        gRecPurchaseComment: Record "Purch. Comment Line";
        gPurchaseComment: Text;
        gPurchaseCommentHeader: Text;
        gRecSalespersonPurchase: Record "Salesperson/Purchaser";
        gNamePurchaseperson: Text;
        gPhonePurchaseperson: Text;
        gEmailPurchaseperson: Text;
}