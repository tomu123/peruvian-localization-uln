xmlport 51004 "PS Vendor List"
{
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/x51004';
    Direction = Both;
    Encoding = UTF8;
    FormatEvaluate = Xml;
    UseDefaultNamespace = true;

    schema
    {
        textelement(VendorList)
        {
            tableelement(Vendor; Vendor)
            {
                MinOccurs = Zero;
                XmlName = 'Vendor';

                //No, descripción 1 y 2, dirección 1 y 2, ubigeo, localizado, termino y forma de pago. bancos y contactos

                fieldelement(VendorNo_vl; Vendor."No.")
                {
                }
                fieldelement(Name1_vl; Vendor.Name)
                {
                }
                fieldelement(Name2_vl; Vendor."Name 2")
                {
                }
                textelement(UbigeoCode_vl)
                {
                    trigger OnBeforePassVariable()
                    begin
                        UbigeoCode_vl := Vendor."Post Code" + Vendor.City + Vendor.County;
                    end;
                }
                fieldelement(PaymentMethodCode_vl; Vendor."Payment Method Code")
                {
                }
                fieldelement(PaymentTermCode_vl; Vendor."Payment Terms Code")
                {
                }
                tableelement(VendorBankAccount; "Vendor Bank Account")
                {
                    LinkFields = "Vendor No." = field("No.");
                    LinkTable = Vendor;
                    XmlName = 'VendorBank';

                    fieldelement(VB_Code_vl; VendorBankAccount.Code)
                    { }
                    fieldelement(VB_Address_vl; VendorBankAccount.Address)
                    { }
                    fieldelement(VB_BankAccNo_vl; VendorBankAccount."Bank Account No.")
                    { }
                    fieldelement(VB_BankAccType_vl; VendorBankAccount."Bank Account Type")
                    { }
                }
                tableelement(VendorContact; Contact)
                {
                    LinkFields = "Company No." = field("No.");
                    LinkTable = Vendor;
                    XmlName = 'VendorContact';

                    fieldelement(VC_Code_vl; VendorContact."No.")
                    { }
                    fieldelement(VC_Name_vl; VendorContact.Name)
                    { }
                    fieldelement(VC_Name2_vl; VendorContact."Name 2")
                    { }
                    fieldelement(VC_PhoneNo_vl; VendorContact."Phone No.")
                    { }
                }

                trigger OnPreXmlItem()
                begin
                    if VendorNo <> '' then
                        Vendor.SetRange("No.", VendorNo);
                end;
            }
        }
    }

    var
        VendorNo: Code[20];

    procedure SetVendor(pVendorNo: Code[20])
    begin
        VendorNo := pVendorNo;
    end;
}