page 50019 "Document Capturing List"
{
    ApplicationArea = All;
    Caption = 'Document Capturing List';
    CardPageId = "Document Capturing Header";
    PageType = List;
    SourceTable = "Document Capturing Header";
    SourceTableView = SORTING("Document No.")
                      ORDER(Descending);
    UsageCategory = Lists;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Document No."; Rec."Document No.")
                {
                    ToolTip = 'Specifies the value of the Document No. field.';
                }
                field("Purchase Order No."; Rec."Purchase Order No.")
                {
                    ToolTip = 'Specifies the value of the Purchase Order No. field.';
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                    ToolTip = 'Specifies the value of the Vendor Name field.';
                }
                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                }
                field("VAT Amount"; Rec."VAT Amount")
                {
                    ToolTip = 'Specifies the value of the VAT Amount field.';
                }
                field("Amount Including VAT"; Rec."Amount Including VAT")
                {
                    ToolTip = 'Specifies the value of the Amount Including VAT field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = Rec.Status = Rec.Status::"PO Invoice";
                    ToolTip = 'Specifies the value of the Posted field.';
                }
                field("ERP Document No."; Rec."ERP Document No.")
                {
                    ToolTip = 'Specifies the value of the ERP Document No. field.';
                }

                field("Buy-from Vendor No."; Rec."Buy-from Vendor No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Vendor No. field.';
                }
                field("Currency Code"; Rec."Currency Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Currency Code field.';
                }
                field("Customer Address"; Rec."Customer Address")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Customer Address field.';
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Customer ID field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Customer Tax ID"; Rec."Customer Tax ID")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Customer Tax ID field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field("Location Code"; Rec."Location Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Payment Terms field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Approval Route"; Rec."Approval Route")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Approval Department field.';
                }
                field(Attachment; Rec.Attachment)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Attachment field.';
                }
                field("ERP Posted Document No."; Rec."ERP Posted Document No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the ERP Posted Document No. field.';
                }
                field("File Name"; Rec."File Name")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the File Name field.';
                }
                field("Last Status Change Date"; Rec."Last Status Change Date")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Last Status Change Date field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; EventSubs.GetUserName(Rec.SystemCreatedBy))
                {
                    Caption = 'Created By';
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; EventSubs.GetUserName(Rec.SystemModifiedBy))
                {
                    Caption = 'Modified By';
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Vendor Address"; Rec."Vendor Address")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Vendor Address field.';
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(ChangeStatus)
            {
                ApplicationArea = all;
                Caption = 'Change Status to New';
                Image = ChangeStatus;
                Visible = (Rec.Status = Rec.Status::Failed) or (Rec.Status = Rec.Status::Rejected);
                trigger OnAction()
                var
                    DocumentCapturingHdr: Record "Document Capturing Header";
                    StatusErr: Label 'Status must be Failed. current value is %1.';
                    ConfirmStatus: Label 'Do you want to change document status from %1 to New.?';
                begin
                    if not Confirm(ConfirmStatus, true, Rec.Status) then
                        exit;
                    CurrPage.SetSelectionFilter(DocumentCapturingHdr);
                    if DocumentCapturingHdr.FindSet() then
                        repeat
                            DocumentCapturingHdr.Status := DocumentCapturingHdr.Status::New;
                            DocumentCapturingHdr.Modify();
                        until DocumentCapturingHdr.Next() = 0;
                end;
            }
        }
    }
    var
        EventSubs: Codeunit "Event Subscribers";
}
