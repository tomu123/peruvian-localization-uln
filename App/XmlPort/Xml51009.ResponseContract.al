/*xmlport 51009 "Response XML"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/x51009';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(ResponseContract)
        {
            tableelement(Response; "Response XML")
            {
                MinOccurs = Zero;
                XmlName = 'Response';
                UseTemporary = true;
                fieldelement(Code; Response."Response Code") { MinOccurs = Zero; }
                fieldelement(Status; Response.Status) { MinOccurs = Zero; }
                fieldelement(Message; Response."Response Text") { MinOccurs = Zero; }
            }
        }
    }

    procedure SetResponse(var ResponseXML: Record "Response XML" temporary)
    begin
        Response.Reset();
        Response.DeleteAll();

        ResponseXML.Reset();
        if ResponseXML.FindFirst() then
            repeat
                Response.Init();
                Response.TransferFields(ResponseXML, true);
                Response.Insert();
            until ResponseXML.Next() = 0;

        ResponseXML.Reset();
        ResponseXML.DeleteAll();

        Response.Reset();
    end;
}*/