pageextension 51160 "LD Warehouse Receipt" extends "Warehouse Receipt"
{
    layout
    {
        // Add changes to page layout here
        addafter("Sorting Method")
        {
            field("Legal Document"; "Legal Document")
            {
                ApplicationArea = All;
            }
        }
        modify(Control1905767507)
        {
            Visible = false;
        }
        addlast(factboxes)
        {

            part(IncomingDocAttachFactBox; "ST Control File List")
            {
                Caption = 'ST Control File List', Comment = 'ESM="Archivos Adjuntos"';
                ApplicationArea = Advanced;
                ShowFilter = false;
                SubPageLink = "File ID" = field("No.");
            }
        }
    }

    actions
    {
        addlast(processing)
        {
            group(ManagementFile)
            {
                Caption = 'ManagementFile', Comment = 'ESM="Archivos"';
                Image = Filed;
                action(AttachmentFile)
                {
                    Caption = 'AttachmentFile', Comment = 'ESM="Archivo adjunto"';
                    ApplicationArea = Planning;
                    Ellipsis = true;
                    Image = Attachments;
                    trigger OnAction();
                    var

                    begin
                        CLEAR(gMgmtControlFile);
                        gMgmtControlFile.fnParameters("No.", UserId, "No.");
                        gMgmtControlFile.fnUploadAttachment(Rec);
                        CurrPage.UPDATE;
                    end;
                }
                action(ViewFiles)
                {
                    Caption = 'ViewFiles', Comment = 'ESM="Ver Archivos"';
                    ApplicationArea = Planning;
                    Ellipsis = true;
                    Image = Documents;
                    trigger OnAction();
                    var

                    begin
                        CLEAR(gMgmtControlFile);

                        gMgmtControlFile.fnOpenAttachment(Rec."No.");
                    end;
                }
            }
        }
    }

    var
        myInt: Integer;
        gMgmtControlFile: Codeunit "Mgmt Control File";
}