tableextension 51127 "PR Type Purch. Comment Line" extends "Purch. Comment Line"
{
    fields
    {
        field(51006; "Setup Type Purch. Comment Line"; Option)
        {
            Caption = 'Source Type', Comment = 'ESM="Tipo origen"';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Receipt,Posted Invoice,Posted Credit Memo,Posted Return Shipment',
            Comment = 'ESM="Solicitud,Pedido,Factura,Nota Crédito,Blanket Order,Devolución pedido,Recepción,Factura registrada,Nota de crédito registrada,Devolución de envío registrada"';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Posted Invoice","Posted Credit Memo","Posted Return Shipment";
            trigger OnValidate()
            begin
                Validate("Document Type", "Setup Type Purch. Comment Line");
            end;
        }

    }

    var

}