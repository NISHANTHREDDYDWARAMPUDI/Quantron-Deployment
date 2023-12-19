pageextension 50051 PurchaseOrder extends "Purchase Order"
{
    layout
    {
        addafter("Order Address Code")
        {
            field("VAT Registration No."; Rec."VAT Registration No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the VAT Registration No. field.';
                Editable = false;
            }
        }
        addafter(Prepayment)
        {
            group(EmailLog)
            {
                Caption = 'E-Mail Log';
                field("PO Mail Status"; Rec."PO Mail Status")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Mail Status field.';
                }
                field("PO Mail Sent By"; Rec."PO Mail Sent By")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Mail Sent By field.';
                }
                field("PO Mail Sent DateTime"; Rec."PO Mail Sent DateTime")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the PO Mail Sent DateTime field.';
                }
                field("PO Mail Error"; Rec."PO Mail Error")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the PO Mail Error field.';
                }

            }

        }


    }
    actions
    {
        modify("&Print")
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
        modify(SendCustom)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
        modify(AttachAsPDF)
        {
            trigger OnBeforeAction()
            begin
                Rec.TestField(Status, Rec.Status::Released);
            end;
        }
        addlast(Print)
        {
            Action("SendOrder&Details")
            {
                ApplicationArea = All;
                Caption = 'Send E-Mail With expected receipt dates';
                Image = SendEmailPDF;

                trigger OnAction()
                begin
                    rec.EmailVendor(false);
                    CurrPage.Update(false);
                end;
            }
            Action("SendOrder&Attachment")
            {
                ApplicationArea = All;
                Caption = 'Send E-Mail With Attachments';
                Image = SendEmailPDF;

                trigger OnAction()
                begin
                    rec.EmailVendor(true);
                    CurrPage.Update(false);
                end;
            }
        }
        addlast(Category_Process)
        {
            actionref("SendOrder&Attachment_Promoted"; "SendOrder&Attachment")
            {
            }
            actionref("SendOrder&Details_Promoted"; "SendOrder&Details")
            {
            }
        }

    }

    var
        cuSendMail: Codeunit "Send Email Stream";
        RecRef: RecordRef;
        text001: Label 'Email Sent';
        text002: Label 'Email address not present, go to vendor page and fill Email field. or please check the log fields';
}
