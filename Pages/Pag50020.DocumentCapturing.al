page 50020 "Document Capturing Header"
{
    ApplicationArea = All;
    Caption = 'Document Capturing Header';
    DataCaptionFields = "Document No.";
    PageType = Document;
    SourceTable = "Document Capturing Header";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field("Vendor Address"; Rec."Vendor Address")
                {
                    ToolTip = 'Specifies the value of the Vendor Address field.';
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 1 Code field.';
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    ToolTip = 'Specifies the value of the Shortcut Dimension 2 Code field.';
                }
                field("Customer ID"; Rec."Customer ID")
                {
                    ToolTip = 'Specifies the value of the Customer ID field.';
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ToolTip = 'Specifies the value of the Customer Name field.';
                }
                field("Customer Tax ID"; Rec."Customer Tax ID")
                {
                    ToolTip = 'Specifies the value of the Customer Tax ID field.';
                }
                field("Customer Address"; Rec."Customer Address")
                {
                    ToolTip = 'Specifies the value of the Customer Address field.';
                }

                field("Document Date"; Rec."Document Date")
                {
                    ToolTip = 'Specifies the value of the Document Date field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ToolTip = 'Specifies the value of the Due Date field.';
                    Visible = false;
                }
                field("Location Code"; Rec."Location Code")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Location Code field.';
                }
                field("Order Date"; Rec."Order Date")
                {
                    ToolTip = 'Specifies the value of the Order Date field.';
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ToolTip = 'Specifies the value of the Posting Date field.';
                }
                field("Payment Terms"; Rec."Payment Terms")
                {
                    ToolTip = 'Specifies the value of the Payment Terms field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    Editable = false;
                    ToolTip = 'Specifies the value of the Approval Status field.';
                }
                field("Approval Route"; Rec."Approval Route")
                {
                    ToolTip = 'Specifies the value of the Approval Department field.';
                }
                field(Posted; Rec.Posted)
                {
                    Editable = Rec.Status = Rec.Status::"PO Invoice";
                    ToolTip = 'Specifies the value of the Posted field.';
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
                field("ERP Document No."; Rec."ERP Document No.")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the ERP Document No. field.';
                }
                field("No. Series"; Rec."No. Series")
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the No. Series field.';
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                }
                field(SystemId; Rec.SystemId)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemId field.';
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    Visible = false;
                    ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                }
                field("VAT Registration No."; Rec."VAT Registration No.")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the VAT Registration No. field.';
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    Importance = Additional;
                    ToolTip = 'Specifies the value of the Vendor Invoice No. field.';
                }
                field(WorkDescription; WorkDescription)
                {
                    Caption = 'Content';
                    ApplicationArea = all;
                    Visible = false;
                    Importance = Additional;
                    MultiLine = true;
                    ShowCaption = false;
                    ToolTip = 'Specifies the products or service being offered.';
                }
            }
            part(DocumentCapturingLine; "Document Capturing Line")
            {
                SubPageLink = "Document No." = field("Document No.");
            }
            part(ErrorMessagesPart; "Error Messages Part")
            {
                ApplicationArea = all;
                Caption = 'Errors and Warnings';
                ShowFilter = false;
            }
        }
        area(factboxes)
        {
            part(PDFViewer; PDFViewerPart)
            {
                Caption = 'PDF Viewer';
                ApplicationArea = All;
            }
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(Database::"Document Capturing Header"),
                              "No." = FIELD("Document No.");
            }
            systempart(Control38; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control39; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }
    actions
    {
        area(processing)
        {
            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Action21)
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. You must reopen the document before you can make changes to it.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals";
                        CannotReleaseaManual: Label 'Approvals enabled, document need to processed through approvals';
                    begin
                        if ApprovalsMgmt.CheckDocumentCapturingApprovalsWorkflowEnabled(Rec) then
                            Error(CannotReleaseaManual);
                        Rec."Approval Status" := Rec."Approval Status"::Released;
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Re&open';
                    Enabled = Rec."Approval Status" <> Rec."Approval Status"::Open;
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed.';

                    trigger OnAction()
                    begin
                        if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
                            exit;
                        Rec."Approval Status" := Rec."Approval Status"::Open;
                    end;
                }
                action(Approvals)
                {
                    AccessByPermission = TableData "Approval Entry" = R;
                    ApplicationArea = Suite;
                    Caption = 'Approvals';
                    Image = Approvals;
                    ToolTip = 'View a list of the records that are waiting to be approved. For example, you can see who requested the record to be approved, when it was sent, and when it is due to be approved.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }
            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                Visible = (Rec.Status <> Rec.Status::Verified);
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval of the document.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals";
                    begin
                        if Rec."Buy-from Vendor No." = '' then
                            Rec.GetVendorDetails();
                        if ApprovalsMgmt.CheckDocumentCapturingApprovalsWorkflowEnabled(Rec) then
                            ApprovalsMgmt.OnSendDocumentCapturingForApproval(Rec);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';

                    trigger OnAction()
                    var
                        ApprovalsMgmt: Codeunit "Custom Approvals";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelDocumentCapturingForApproval(Rec);
                    end;
                }
            }
        }
        area(Navigation)
        {
            action(VerifyInvoice)
            {
                ApplicationArea = all;
                Caption = 'Verify Document Capturing Invoice';
                Image = ValidateEmailLoggingSetup;
                Visible = (Rec.Status = Rec.Status::New) or (Rec.Status = Rec.Status::Failed);

                trigger OnAction()
                begin
                    Rec.VerifyAttachmentData();
                end;
            }
            action(ValidateInvoice)
            {
                ApplicationArea = all;
                Caption = 'Validate Document Capturing Invoice';
                Image = ValidateEmailLoggingSetup;
                Visible = (Rec.Status = Rec.Status::Verified) or (Rec.Status = Rec.Status::Failed);

                trigger OnAction()
                var
                    StatusErr: Label 'Please complete the approval process to validate the document';
                begin
                    if Rec."Approval Status" = Rec."Approval Status"::"Pending Approval" then
                        Error(StatusErr);
                    if Rec."Buy-from Vendor No." = '' then
                        Rec.GetVendorDetails();
                    Rec.ValidateData();
                end;
            }
            action(RejectInvoice)
            {
                ApplicationArea = all;
                Caption = 'Reject Document Capturing Invoice';
                Image = Reject;
                Visible = (Rec.Status <> Rec.Status::Processed) and (Rec.Status <> Rec.Status::Validated);
                trigger OnAction()
                var
                    StatusErr: Label 'Document status must be new or failed. Current status is %1';
                begin
                    if (Rec.Status = Rec.Status::Processed) or (Rec.Status = Rec.Status::Validated) then
                        Error(StatusErr);
                    Rec.Status := Rec.Status::Rejected;
                    Rec."Last Status Change Date" := WorkDate();
                end;
            }
            action(ChangeStatusNew)
            {
                ApplicationArea = all;
                Caption = 'Change Status to New';
                Image = ChangeStatus;
                Visible = (Rec.Status = Rec.Status::Failed) or (Rec.Status = Rec.Status::Rejected) or (Rec.Status = Rec.Status::"PO Invoice");
                trigger OnAction()
                var
                    DocumentCapturingHdr: Record "Document Capturing Header";
                    StatusErr: Label 'Status must be Failed. current value is %1.';
                    ConfirmStatus: Label 'Do you want to change document status from %1 to New.?';
                begin
                    if not Confirm(ConfirmStatus, true, Rec.Status) then
                        exit;
                    Rec.Status := Rec.Status::New;
                    Rec."Last Status Change Date" := WorkDate();
                end;
            }
            action(ChangeStatusVerified)
            {
                ApplicationArea = all;
                Caption = 'Change Status to Verified';
                Image = ChangeStatus;
                Visible = Rec.Status = Rec.Status::Validated;
                trigger OnAction()
                var
                    ConfirmStatus: Label 'Do you want to change document status from %1 to Verified.?';
                begin
                    if not Confirm(ConfirmStatus, true, Rec.Status) then
                        exit;
                    Rec.Status := Rec.Status::Verified;
                    Rec."Last Status Change Date" := WorkDate();
                end;
            }
            action(CreateInvoice)
            {
                ApplicationArea = all;
                Caption = 'Create Invoice';
                Image = CreateCreditMemo;
                Visible = Rec.Status = Rec.Status::Validated;
                ToolTip = 'Create a document, such as a purchase invoice, from information in the file that is attached to the power automate record.';

                trigger OnAction()
                begin
                    if Rec.Status = Rec.Status::Processed then
                        exit;
                    Rec.CreateDoc();
                end;
            }
            action(OpenInvoice)
            {
                ApplicationArea = all;
                Caption = 'Open Invoice';
                Visible = Rec.Status = Rec.Status::Processed;
                Image = CreditMemo;

                trigger OnAction()
                var
                    PH: Record "Purchase Header";
                begin
                    PH.Reset();
                    PH.SetRange("Document Type", PH."Document Type"::Invoice);
                    PH.SetRange("No.", Rec."ERP Document No.");
                    page.Run(0, PH);
                end;
            }
            action(OpenPostedInvoice)
            {
                ApplicationArea = all;
                Caption = 'Display Posted Invoice';
                Visible = Rec.Status = Rec.Status::Processed;
                Image = Invoice;

                trigger OnAction()
                var
                    PIH: Record "Purch. Inv. Header";
                begin
                    PIH.Reset();
                    PIH.SetRange("No.", Rec."ERP Posted Document No.");
                    page.Run(0, PIH);
                end;
            }
            action("Send Email")
            {
                ApplicationArea = all;
                Caption = 'Send Email';
                Image = SendMail;
                Visible = (Rec.Status = Rec.Status::Verified) or (Rec.Status = Rec.Status::Rejected) or (Rec.Status = Rec.Status::"PO Invoice");

                trigger OnAction()
                var
                    EmailScenarios: Codeunit "Email Scenario";
                    Email: Codeunit Email;
                    EmailMessage: Codeunit "Email Message";
                    AttAchInStream: InStream;
                    TempBlob: Codeunit "Temp Blob";
                    TempEmailModuleAccount: Record "Email Account" temporary;
                    MailSent: Boolean;
                    EmailSentSuccess: Label 'Email Sent Succesfully';
                begin
                    EmailMessage.Create('', '', '', true);
                    TempBlob.CreateInStream(AttAchInStream);
                    EmailMessage.AddAttachment(rec."File Name", 'PDF', ToBase64String());
                    EmailScenarios.GetEmailAccount(Enum::"Email Scenario"::Default, TempEmailModuleAccount);
                    MailSent := Email.OpenInEditorModallyWithScenario(EmailMessage, TempEmailModuleAccount, Enum::"Email Scenario"::Default) = Enum::"Email Action"::Sent;
                    if MailSent and GuiAllowed then
                        Message(EmailSentSuccess);
                end;
            }
            action(Export)
            {
                ApplicationArea = All;
                Image = Download;
                Visible = false;

                trigger OnAction()
                var
                    TempBlob: Codeunit "Temp Blob";
                    FileManagement: Codeunit "File Management";
                    DocumentStream: OutStream;
                    InstreamVar: InStream;
                    Base64CU: Codeunit "Base64 Convert";
                    fileContent: Text;
                begin
                    Rec.CalcFields(Attachment);
                    if Rec.Attachment.HasValue then begin
                        Rec.Attachment.CreateInStream(InstreamVar);
                        InstreamVar.ReadText(fileContent);
                        TempBlob.CreateOutStream(DocumentStream);
                        Base64CU.FromBase64(fileContent, DocumentStream);
                        FileManagement.BLOBExport(TempBlob, Rec."File Name", true);
                    end;
                end;
            }
            action(ViewPDF)
            {
                ApplicationArea = All;
                Caption = 'Preview';
                Image = View;
                Scope = "Repeater";

                trigger OnAction()
                begin
                    Rec.ViewInPdfViewer(false);
                end;
            }
            action("Move To PO Invoices")
            {
                ApplicationArea = All;
                Caption = 'Move To PO Invoices';
                Image = ChangeStatus;
                Visible = (Rec.Status = Rec.Status::Verified) or (Rec.Status = Rec.Status::Validated);

                trigger OnAction()
                var
                    ConfirmStatus: Label 'Do you want to change document status from %1 to PO Invoices.?';
                begin
                    if not Confirm(ConfirmStatus, true, Rec.Status) then
                        exit;
                    Rec.Status := Rec.Status::"PO Invoice";
                    Rec."Last Status Change Date" := WorkDate();
                end;
            }
        }

        area(Promoted)
        {
            group(Category_Document)
            {
                Caption = 'Document';

                actionref("VerifyDoc_Promoted"; VerifyInvoice)
                {
                }
                actionref("ValidateDoc_Promoted"; ValidateInvoice)
                {
                }
                actionref(RejectDoc_Promoted; RejectInvoice)
                {
                }
                actionref(ChangeStatusNew_Promoted; ChangeStatusNew)
                {
                }
                actionref(ChangeStatusVerified_Promoted; ChangeStatusVerified)
                {
                }
                actionref(MoveToPOInvoices_Promoted; "Move To PO Invoices")
                {
                }
            }
            group(Category_Invoice)
            {
                Caption = 'Invoice';

                actionref("CreateInvoice_Promoted"; CreateInvoice)
                {
                }
                actionref(OpenInvoice_Promoted; OpenInvoice)
                {
                }
                actionref(OpenPostedInvoice_Promoted; OpenPostedInvoice)
                {
                }
            }
            group(Category_Category5)
            {
                Caption = 'Release', Comment = 'Generated from the PromotedActionCategories property index 4.';
                ShowAs = SplitButton;

                actionref(Release_Promoted; Release)
                {
                }
                actionref(Reopen_Promoted; Reopen)
                {
                }
                actionref(Approvals_Promoted; Approvals)
                {
                }
            }
            group(Category_Category4)
            {
                Caption = 'Approve', Comment = 'Generated from the PromotedActionCategories property index 3.';

                actionref(Approve_Promoted; Approve)
                {
                }
                actionref(Reject_Promoted; Reject)
                {
                }
                actionref(Comment_Promoted; Comment)
                {
                }
                actionref(Delegate_Promoted; Delegate)
                {
                }
            }
            group(Category_Category9)
            {
                Caption = 'Request Approval', Comment = 'Generated from the PromotedActionCategories property index 8.';

                actionref(SendApprovalRequest_Promoted; SendApprovalRequest)
                {
                }
                actionref(CancelApprovalRequest_Promoted; CancelApprovalRequest)
                {
                }
            }
            group(Category_Preview)
            {
                Caption = 'Preview';

                actionref("ViewPDF_Promoted"; ViewPDF)
                {
                }
            }
            group(Category_Email)
            {
                Caption = 'Email';

                actionref("SendEmail_Promoted"; "Send Email")
                {
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        ShowErrors();
        ShowPdfInViewer();
        WorkDescription := GetWorkDescription();
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
    end;

    local procedure ShowPdfInViewer()
    begin
        if not Rec.Attachment.HasValue() then
            exit;

        CurrPage.PDFViewer.Page.LoadPdfFromBase64(ToBase64String(), Rec);
    end;

    trigger OnAfterGetRecord()
    begin
        ShowErrors();
        ShowPdfInViewer();
    end;

    local procedure ShowErrors()
    var
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        ErrorMessage.SetRange("Context Record ID", Rec.RecordId);
        ErrorMessage.CopyToTemp(TempErrorMessage);
        CurrPage.ErrorMessagesPart.PAGE.SetRecords(TempErrorMessage);
        CurrPage.ErrorMessagesPart.PAGE.Update();
    end;

    procedure GetWorkDescription() WorkDescription: Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        Rec.CalcFields(Rec.Attachment);
        Rec.Attachment.CreateInStream(InStream);
        exit(TypeHelper.TryReadAsTextWithSepAndFieldErrMsg(InStream, TypeHelper.LFSeparator(), Rec.FieldName(Rec.Attachment)));
    end;

    procedure ToBase64String() ReturnValue: Text
    var
        InStr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
        fileContent: Text;
    begin
        if not Rec.Attachment.HasValue() then
            exit;
        Rec.CalcFields(Attachment);
        Rec.Attachment.CreateInStream(InStr);
        InStr.ReadText(fileContent);
        ReturnValue := fileContent;
    end;

    var
        WorkDescription: Text;
        CanCancelApprovalForRecord: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
}

