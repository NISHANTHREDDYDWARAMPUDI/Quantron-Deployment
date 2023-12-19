page 50013 "Purch. Rcpt QS"
{
    ApplicationArea = All;
    Caption = 'Purchase Receipt Quality Spec';
    PageType = Document;
    SourceTable = "Purch. Rcpt QS Header";
    InsertAllowed = false;
    DeleteAllowed = false;
    Permissions = tabledata "Purch. Rcpt. Line" = RIMD;
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Spec ID"; Rec."Spec ID")
                {
                    ToolTip = 'Specifies the value of the Spec ID field.';
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field("Update Status"; Rec."Update Status")
                {
                    Caption = 'Status';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Update Status field.';
                }
                field("Time (Hours)"; Rec."Time (Hours)")
                {
                    ToolTip = 'Specifies the value of the Time (Hours) field.';
                }
                field("Resource ID"; Rec."Resource ID")
                {
                    ToolTip = 'Specifies the value of the Resource ID field.';
                }

            }
            part(Control1000000006; "Purch. Rcpt QS Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = "Document No." = field("Document No."), "Rcpt. Line No." = field("Rcpt. Line No."), "Spec ID" = field("Spec ID");
                UpdatePropagation = Both;
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(Post)
            {
                ApplicationArea = All;
                Image = Post;

                trigger OnAction()
                var
                    ConfirmPost: Label 'Do you want to confirm & post the Quality Specification Check.?';
                begin
                    if not Confirm(ConfirmPost) then
                        exit;
                    CheckMandatoryAttachments();
                    UpdatePurchRcptQSLine();
                    Rec."Update Status" := Rec."Update Status"::Posted;
                    Rec.Modify();
                end;
            }
            action(Print)
            {
                ApplicationArea = All;
                Image = Print;

                trigger OnAction()
                var
                    PurchRcptQSLine: Record "Purch. Rcpt QS Line";
                begin
                    PurchRcptQSLine.Reset();
                    PurchRcptQSLine.SetRange("Document No.", Rec."Document No.");
                    PurchRcptQSLine.SetRange("Rcpt. Line No.", Rec."Rcpt. Line No.");
                    PurchRcptQSLine.SetRange("Spec ID", Rec."Spec ID");
                    Report.Run(Report::"Purch Rcpt. Quality Spec Print", true, false, PurchRcptQSLine);
                end;
            }
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attachments;

                trigger OnAction()
                begin
                    CurrPage.Control1000000006.Page.OpenAttachments();
                end;
            }
        }
        area(Promoted)
        {
            group(Category_Process)
            {
                Caption = 'Process';
                actionref(Attachments_ref; Attachments)
                { }
                actionref(Print_ref; Print)
                { }
                actionref(Post_ref; Post)
                { }
            }
        }
    }


    local procedure UpdatePurchRcptQSLine()
    var
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        if PurchRcptLine.Get(Rec."Document No.", Rec."Rcpt. Line No.") then begin
            PurchRcptLine."Quality Check Completed" := true;
            PurchRcptLine.Modify();
        end;
    end;

    local procedure CheckMandatoryAttachments()
    var
        PurchRcptQSLine: Record "Purch. Rcpt QS Line";
        DocAttachRec: Record "Document Attachment";
        AttachErr: Label 'Attachment is missing for specification %1';
    begin
        PurchRcptQSLine.Reset();
        PurchRcptQSLine.SetRange("Document No.", Rec."Document No.");
        PurchRcptQSLine.SetRange("Rcpt. Line No.", Rec."Rcpt. Line No.");
        PurchRcptQSLine.SetRange("Spec ID", Rec."Spec ID");
        PurchRcptQSLine.SetRange("Document Mandatory", true);
        if PurchRcptQSLine.FindSet() then
            repeat
                DocAttachRec.Reset();
                DocAttachRec.SetRange("Record ID", PurchRcptQSLine.RecordId);
                if DocAttachRec.IsEmpty then
                    Error(AttachErr, PurchRcptQSLine.Specification);
            until PurchRcptQSLine.Next() = 0;
    end;
}
