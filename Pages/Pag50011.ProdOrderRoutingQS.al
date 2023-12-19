page 50011 "Prod Order Routing QS"
{
    ApplicationArea = All;
    Caption = 'Prod Order Routing Quality Spec';
    PageType = Document;
    SourceTable = "Prod Ord. Routing QS Header";
    InsertAllowed = false;
    DeleteAllowed = false;

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
            part(Control1000000006; "Prod Order Routing QS Subform")
            {
                Caption = 'Lines';
                ApplicationArea = All;
                SubPageLink = Status = field(Status),
                            "Prod. Order No." = field("Prod. Order No."),
                            "Routing Reference No." = field("Routing Reference No."),
                            "Routing No." = field("Routing No."),
                            "Operation No." = field("Operation No."),
                            "Spec ID" = FIELD("Spec ID");
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
                    UpdateProdOrderRoutingLine();
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
                    ProdOrderRoutingQSLine: Record "Prod Ord. Routing QS Line";
                begin
                    ProdOrderRoutingQSLine.Reset();
                    ProdOrderRoutingQSLine.SetRange(Status, Rec.Status);
                    ProdOrderRoutingQSLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
                    ProdOrderRoutingQSLine.SetRange("Routing No.", Rec."Routing No.");
                    ProdOrderRoutingQSLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
                    ProdOrderRoutingQSLine.SetRange("Operation No.", Rec."Operation No.");
                    ProdOrderRoutingQSLine.SetRange("Spec ID", Rec."Spec ID");
                    Report.Run(Report::"Quality Spec Print", true, false, ProdOrderRoutingQSLine);
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
    local procedure UpdateProdOrderRoutingLine()
    var
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, Rec.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing No.", Rec."Routing No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
        ProdOrderRoutingLine.SetRange("Operation No.", Rec."Operation No.");
        if ProdOrderRoutingLine.FindFirst() then begin
            ProdOrderRoutingLine."Quality Check Completed" := true;
            ProdOrderRoutingLine.Modify();
        end;
    end;

    local procedure CheckMandatoryAttachments()
    var
        DocAttachRec: Record "Document Attachment";
        ProdOrderRoutingQSLine: Record "Prod Ord. Routing QS Line";
        AttachErr: Label 'Attachment is missing for specification %1';
    begin
        ProdOrderRoutingQSLine.Reset();
        ProdOrderRoutingQSLine.SetRange(Status, Rec.Status);
        ProdOrderRoutingQSLine.SetRange("Prod. Order No.", Rec."Prod. Order No.");
        ProdOrderRoutingQSLine.SetRange("Routing No.", Rec."Routing No.");
        ProdOrderRoutingQSLine.SetRange("Routing Reference No.", Rec."Routing Reference No.");
        ProdOrderRoutingQSLine.SetRange("Operation No.", Rec."Operation No.");
        ProdOrderRoutingQSLine.SetRange("Spec ID", Rec."Spec ID");
        ProdOrderRoutingQSLine.SetRange("Document Mandatory", true);
        if ProdOrderRoutingQSLine.FindSet() then
            repeat
                DocAttachRec.Reset();
                DocAttachRec.SetRange("Record ID", ProdOrderRoutingQSLine.RecordId);
                if DocAttachRec.IsEmpty then
                    Error(AttachErr, ProdOrderRoutingQSLine.Specification);
            until ProdOrderRoutingQSLine.Next() = 0;
    end;
}
