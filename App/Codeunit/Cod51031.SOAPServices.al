codeunit 51031 "SP SOAP Services"
{
    trigger OnRun()
    begin

    end;

    procedure GetDocumentsVendor(VendorNo: Code[20]; var XMLResult: XMLport "PS Vendor Documents");
    begin
        Clear(XMLResult);
        if VendorNo <> '' then
            XMLResult.SetVendor(VendorNo);
        XMLResult.Export;
    end;

    procedure GetVendorList(VendorNo: Code[20]; var XMLResult: XMLport "PS Vendor List");
    var
        lcVendorLedgerEntryTemp: Record "Vendor Ledger Entry" temporary;
    begin
        Clear(XMLResult);
        if VendorNo <> '' then
            XMLResult.SetVendor(VendorNo);
        XMLResult.Export;
    end;

    /*procedure SetContract(XMLMessage: XmlPort "Post Contract"; var XMLResult: XmlPort "Response XML")
    var
        ResponseXML: Record "Response XML";
    begin
        XMLMessage.Import();
        XMLMessage.GetResponse(ResponseXML);

        XMLResult.SetResponse(ResponseXML);
        XMLResult.Export();
    end;*/
}