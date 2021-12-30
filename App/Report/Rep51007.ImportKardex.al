report 51007 "Import Kardex"
{
    Caption = 'Kardex to Excel', Comment = 'ESM="Cardex en Excel"';
    UsageCategory = Administration;
    ApplicationArea = All;
    ProcessingOnly = true;
    //RDLCLayout = 'MyRDLImportacionKardex.rdl';

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            trigger OnPreDataItem()
            begin
                gExcelBuffer.DELETEALL;

                gExcelBuffer.AddColumn('COD. PRODUCTO', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('DESCRIPCION', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('TIPO DOCUMENTO', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('NRO DOCUMENTO', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('FECHA DE REGISTRO', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('CANTIDAD', FALSE, '', TRUE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn('STOCK', FALSE, '', TRUE, FALSE, FALSE, '', 1);

            end;

            trigger OnAfterGetRecord()
            begin
                "Item Ledger Entry".CALCFIELDS("Cost Amount (Actual)");
                IF gLastItemNo <> "Item No." THEN BEGIN
                    gQuantity := Quantity;
                    gExcelBuffer.NewRow;
                    gExcelBuffer.NewRow;
                    gItem.GET("Item No.");
                    gExcelBuffer.AddColumn(FORMAT("Item No."), FALSE, '', TRUE, FALSE, FALSE, '', 1);
                    gExcelBuffer.AddColumn(FORMAT(gItem.Description), FALSE, '', TRUE, FALSE, FALSE, '', 1);
                END ELSE BEGIN
                    gQuantity := gQuantity + Quantity;
                END;
                gItem.GET("Item Ledger Entry"."Item No.");
                gLastItemNo := "Item Ledger Entry"."Item No.";
                gExcelBuffer.NewRow;
                gExcelBuffer.AddColumn(FORMAT("Item No."), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT(gItem.Description), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT("Document Type"), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT("Document No."), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT("Posting Date"), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT(Quantity), FALSE, '', FALSE, FALSE, FALSE, '', 1);
                gExcelBuffer.AddColumn(FORMAT(gQuantity), FALSE, '', FALSE, FALSE, FALSE, '', 1);

            end;

            trigger OnPostDataItem()
            begin
                //gExcelBuffer.CreateBookAndOpenExcel(TEMPORARYPATH + 'Kardex en Excel.xlsx', 'Kardex en Excel', 'Kardex en Excel', COMPANYNAME, USERID);
                gExcelBuffer.CreateNewBook('Kardex en Excel');
                gExcelBuffer.WriteSheet('Kardex en Excel', CompanyName, UserId);
                gExcelBuffer.CloseBook;
                gExcelBuffer.OpenExcel;
            end;

        }
    }
    var
        gExcelBuffer: Record "Excel Buffer";
        gQuantity: Decimal;
        gLastItemNo: Code[20];
        gItem: Record Item;
}