codeunit 50009 "Custom Approvals"
{
    trigger OnRun()
    begin

    end;


    [IntegrationEvent(false, false)]
    Procedure OnSendDocumentCapturingForApproval(var DocumentCapturing: Record "Document Capturing Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    Procedure OnCancelDocumentCapturingForApproval(var DocumentCapturing: Record "Document Capturing Header")
    begin
    end;

    //Create events for workflow
    procedure RunworkflowOnSendDocumentCapturingforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('RunworkflowOnSendDocumentCapturingforApproval'), 1, 128));
    end;


    [EventSubscriber(ObjectType::Codeunit, codeunit::"Custom Approvals", 'OnSendDocumentCapturingForApproval', '', true, true)]
    local procedure RunworkflowonsendDocumentCapturingForApproval(var DocumentCapturing: Record "Document Capturing Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOnSendDocumentCapturingforApprovalCode(), DocumentCapturing);
    end;

    procedure RunworkflowOnCancelDocumentCapturingforApprovalCode(): code[128]
    begin
        exit(CopyStr(UpperCase('OnCancelDocumentCapturingForApproval'), 1, 128));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Custom Approvals", 'OnCancelDocumentCapturingForApproval', '', true, true)]

    local procedure RunworkflowonCancelDocumentCapturingForApproval(var DocumentCapturing: Record "Document Capturing Header")
    begin
        WorkflowManagement.HandleEvent(RunworkflowOncancelDocumentCapturingforApprovalCode(), DocumentCapturing);
    end;

    //Add events to library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibraryDocumentCapturing();
    begin
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnSendDocumentCapturingforApprovalCode(), DATABASE::"Document Capturing Header",
          CopyStr(DocumentCapturingsendforapprovaleventdesctxt, 1, 250), 0, FALSE);
        WorkflowevenHandling.AddEventToLibrary(RunworkflowOnCancelDocumentCapturingforApprovalCode(), DATABASE::"Document Capturing Header",
          CopyStr(DocumentCapturingrequestcanceleventdesctxt, 1, 250), 0, FALSE);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddworkfloweventprodecessorstolibraryDocumentCapturing(EventFunctionName: code[128]);
    begin
        case EventFunctionName of
            RunworkflowOnCancelDocumentCapturingforApprovalCode():
                WorkflowevenHandling.AddEventPredecessor(RunworkflowOnCancelDocumentCapturingforApprovalCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnApproveApprovalRequestCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnRejectApprovalRequestCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
            WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode():
                WorkflowevenHandling.AddEventPredecessor(WorkflowevenHandling.RunWorkflowOnDelegateApprovalRequestCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
        end;
    end;

    procedure ISDocumentCapturingworkflowenabled(var DocumentCapturing: Record "Document Capturing Header"): Boolean
    begin
        if DocumentCapturing."Approval Status" <> DocumentCapturing."Approval Status"::Open then
            exit(false);
        exit(WorkflowManagement.CanExecuteWorkflow(DocumentCapturing, RunworkflowOnSendDocumentCapturingforApprovalCode()));
    end;

    Procedure CheckDocumentCapturingApprovalsWorkflowEnabled(var DocumentCapturing: Record "Document Capturing Header"): Boolean
    begin
        IF not ISDocumentCapturingworkflowenabled(DocumentCapturing) then
            Error((NoworkfloweableErr));
        exit(true);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnpopulateApprovalEntriesArgumentDocumentCapturing(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        DocumentCapturing: Record "Document Capturing Header";
    begin
        case RecRef.Number() of
            Database::"Document Capturing Header":
                begin
                    RecRef.SetTable(DocumentCapturing);
                    ApprovalEntryArgument."Document No." := DocumentCapturing."Document No.";
                    ApprovalEntryArgument.Amount := DocumentCapturing.Amount;
                    ApprovalEntryArgument."Amount (LCY)" := DocumentCapturing.Amount;
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', true, true)]
    local procedure OnopendocumentDocumentCapturing(RecRef: RecordRef; var Handled: boolean)
    var
        DocumentCapturing: Record "Document Capturing Header";
    begin
        case RecRef.Number() of
            Database::"Document Capturing Header":
                begin
                    RecRef.SetTable(DocumentCapturing);
                    DocumentCapturing."Approval Status" := DocumentCapturing."Approval Status"::Open;
                    DocumentCapturing.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', true, true)]
    local procedure OnReleasedocumentDocumentCapturing(RecRef: RecordRef; var Handled: boolean)
    var
        DocumentCapturing: Record "Document Capturing Header";
    begin
        case RecRef.Number() of
            Database::"Document Capturing Header":
                begin
                    RecRef.SetTable(DocumentCapturing);
                    CheckDimensionsValidation(DocumentCapturing);
                    DocumentCapturing."Approval Status" := DocumentCapturing."Approval Status"::Released;
                    DocumentCapturing.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    local procedure OnSetstatusToPendingApprovalDocumentCapturing(RecRef: RecordRef; var IsHandled: boolean)
    var
        DocumentCapturing: Record "Document Capturing Header";
    begin
        case RecRef.Number() of
            Database::"Document Capturing Header":
                begin
                    RecRef.SetTable(DocumentCapturing);
                    DocumentCapturing."Approval Status" := DocumentCapturing."Approval Status"::"Pending Approval";
                    DocumentCapturing.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', true, true)]
    local procedure OnaddworkflowresponseprodecessorstolibraryDocumentCapturing(ResponseFunctionName: Code[128])
    var
        workflowresponsehandling: Codeunit "Workflow Response Handling";
    begin
        case ResponseFunctionName of
            workflowresponsehandling.SetStatusToPendingApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SetStatusToPendingApprovalCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
            workflowresponsehandling.SendApprovalRequestForApprovalCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.SendApprovalRequestForApprovalCode(), RunworkflowOnSendDocumentCapturingforApprovalCode());
            workflowresponsehandling.CancelAllApprovalRequestsCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.CancelAllApprovalRequestsCode(), RunworkflowOnCancelDocumentCapturingforApprovalCode());
            workflowresponsehandling.OpenDocumentCode():
                workflowresponsehandling.AddResponsePredecessor(workflowresponsehandling.OpenDocumentCode(), RunworkflowOnCancelDocumentCapturingforApprovalCode());
        end;
    end;

    //Setup workflow

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', true, true)]
    local procedure OnaddworkflowCategoryTolibraryDocumentCapturing()
    begin
        workflowsetup.InsertWorkflowCategory(CopyStr(DocumentCapturingCategoryTxt, 1, 20), CopyStr(DocumentCapturingCategoryDescTxt, 1, 100));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', true, true)]
    local procedure OnInsertApprovaltablerelationsDocumentCapturing()
    Var
        ApprovalEntry: record "Approval Entry";
    begin
        workflowsetup.InsertTableRelation(Database::"Document Capturing Header", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', true, true)]
    local procedure OnInsertworkflowtemplateDocumentCapturing()
    begin
        InsertDocumentCapturingApprovalworkflowtemplate();
    end;



    local procedure InsertDocumentCapturingApprovalworkflowtemplate();
    var
        workflow: record Workflow;
    begin
        workflowsetup.InsertWorkflowTemplate(workflow, CopyStr(DocumentCapturingDocOCRWorkflowCodeTxt, 1, 17), CopyStr(DocumentCapturingApprWorkflowDescTxt, 1, 100), CopyStr(DocumentCapturingCategoryTxt, 1, 20));
        InsertDocumentCapturingApprovalworkflowDetails(workflow);
        workflowsetup.MarkWorkflowAsTemplate(workflow);
    end;

    local procedure InsertDocumentCapturingApprovalworkflowDetails(var workflow: record Workflow);
    var
        DocumentCapturing: Record "Document Capturing Header";
        workflowstepargument: record "Workflow Step Argument";
        Blankdateformula: DateFormula;
    begin
        workflowsetup.InitWorkflowStepArgument(workflowstepargument, workflowstepargument."Approver Type"::Approver, workflowstepargument."Approver Limit Type"::"Direct Approver", 0, '', Blankdateformula, true);

        workflowsetup.InsertDocApprovalWorkflowSteps(workflow, BuildDocumentCapturingtypecondition(DocumentCapturing."Approval Status"::Open), RunworkflowOnSendDocumentCapturingforApprovalCode(), BuildDocumentCapturingtypecondition(DocumentCapturing."Approval Status"::"Pending Approval"), RunworkflowOnCancelDocumentCapturingforApprovalCode(), workflowstepargument, true);
    end;


    local procedure BuildDocumentCapturingtypecondition(status: integer): Text
    var
        DocumentCapturing: Record "Document Capturing Header";
    Begin
        DocumentCapturing.SetRange("Approval Status", status);
        exit(StrSubstNo(DocumentCapturingTypeCondnTxt, workflowsetup.Encode(DocumentCapturing.GetView(false))));
    End;

    //Access record from the approval request page

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnAfterGetPageID', '', true, true)]
    local procedure OnaftergetpageidDocumentCapturing(RecordRef: RecordRef; var PageID: Integer)
    begin
        if PageID = 0 then
            PageID := GetConditionalcardPageidDocumentCapturing(RecordRef)
    end;

    local procedure GetConditionalcardPageidDocumentCapturing(RecordRef: RecordRef): Integer
    begin
        Case RecordRef.Number() of
            database::"Document Capturing Header":
                exit(page::"Document Capturing Header");
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnAfterRejectSelectedApprovalRequest', '', true, true)]
    local procedure "Approvals Mgmt._OnAfterRejectSelectedApprovalRequest"(var ApprovalEntry: Record "Approval Entry")
    var
        DocumentCapturing: Record "Document Capturing Header";
        RecRef: RecordRef;
    begin
        RecRef.Get(ApprovalEntry."Record ID to Approve");
        case RecRef.Number() of
            Database::"Document Capturing Header":
                begin
                    RecRef.SetTable(DocumentCapturing);
                    DocumentCapturing."Approval Status" := DocumentCapturing."Approval Status"::Declined;
                    DocumentCapturing.Modify();
                end;
        end;
    end;

    local procedure CheckDimensionsValidation(var DocumentCapturing: Record "Document Capturing Header")
    var
        BothHdrLineDimensionErr: Label 'Both header and line %1 & %2 is empty or atleast one line  %1 & %2 is empty';
        BothHdrDimensionErr: Label 'Both header %1 & %2 cannot have values';
        BothLineDimensionErr: Label 'Both line %1 & %2 cannot have values in line no. %3';
        DocumentCapturingLine: Record "Document Capturing Line";
        LineDimensionBlank: Boolean;
        HeaderDimensionBlank: Boolean;
    begin
        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", DocumentCapturing."Document No.");
        DocumentCapturingLine.SetRange("Shortcut Dimension 1 Code", '');
        DocumentCapturingLine.SetRange("Shortcut Dimension 2 Code", '');
        DocumentCapturingLine.SetFilter(Type, '<>%1', DocumentCapturingLine.Type::" ");
        if DocumentCapturingLine.FindFirst() then
            LineDimensionBlank := true;

        DocumentCapturingLine.Reset();
        DocumentCapturingLine.SetRange("Document No.", DocumentCapturing."Document No.");
        DocumentCapturingLine.SetFilter("Shortcut Dimension 1 Code", '<>%1', '');
        DocumentCapturingLine.SetFilter("Shortcut Dimension 2 Code", '<>%1', '');
        DocumentCapturingLine.SetFilter(Type, '<>%1', DocumentCapturingLine.Type::" ");
        if DocumentCapturingLine.FindFirst() then
            Error(BothLineDimensionErr, DocumentCapturing.FieldCaption("Shortcut Dimension 1 Code"), DocumentCapturing.FieldCaption("Shortcut Dimension 2 Code"), DocumentCapturingLine."Line No.");

        HeaderDimensionBlank := (DocumentCapturing."Shortcut Dimension 1 Code" = '') and (DocumentCapturing."Shortcut Dimension 2 Code" = '');

        if HeaderDimensionBlank and LineDimensionBlank then
            Error(BothHdrLineDimensionErr, DocumentCapturing.FieldCaption("Shortcut Dimension 1 Code"), DocumentCapturing.FieldCaption("Shortcut Dimension 2 Code"));
        if (DocumentCapturing."Shortcut Dimension 1 Code" <> '') and (DocumentCapturing."Shortcut Dimension 2 Code" <> '') and (LineDimensionBlank) then
            Error(BothHdrDimensionErr, DocumentCapturing.FieldCaption("Shortcut Dimension 1 Code"), DocumentCapturing.FieldCaption("Shortcut Dimension 2 Code"));
        if (not HeaderDimensionBlank) and (not LineDimensionBlank) then
            Error(BothHdrDimensionErr, DocumentCapturing.FieldCaption("Shortcut Dimension 1 Code"), DocumentCapturing.FieldCaption("Shortcut Dimension 2 Code"));
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals Mgmt.", 'OnBeforeApproveSelectedApprovalRequest', '', false, false)]
    local procedure RequesttoApproveCust(var ApprovalEntry: Record "Approval Entry")
    var
    begin
        ApprovalEntriesApproveSameLevel(ApprovalEntry);
    end;

    local procedure ApprovalEntriesApproveSameLevel(Var ApprovalEntry: Record "Approval Entry")
    var
        ApprovalEntryRec: record "Approval Entry";
    begin
        ApprovalEntryRec.Reset();
        ApprovalEntryRec.SetFilter("Approver ID", '<>%1', ApprovalEntry."Approver ID");
        ApprovalEntryRec.SetRange("Approval Code", ApprovalEntry."Approval Code");
        ApprovalEntryRec.SetRange("Table ID", ApprovalEntry."Table ID");
        ApprovalEntryRec.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntryRec.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
        ApprovalEntryRec.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
        ApprovalEntryRec.SetFilter(Status, '%1', ApprovalEntryRec.Status::Open);
        if ApprovalEntryRec.FindSet then
            repeat
                ApprovalEntryRec."Last Date-Time Modified" := CreateDateTime(Today, Time);
                ApprovalEntryRec."Last Modified By User ID" := UserId;
                ApprovalEntryRec.Status := ApprovalEntryRec.Status::Approved;
                ApprovalEntryRec.Modify();
            until ApprovalEntryRec.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"Approvals Mgmt.", 'OnBeforeApprovalEntryInsert', '', false, false)]
    local procedure OnBeforeApprovalEntryInsert(var ApprovalEntry: Record "Approval Entry"; ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepArgument: Record "Workflow Step Argument"; ApproverId: Code[50]; var IsHandled: Boolean)
    var
        ApprovalEntry2: Record "Approval Entry";
    begin
        if ApproverId = UserId then begin
            ApprovalEntry2.Reset();
            ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry2.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
            ApprovalEntry2.SetFilter(Status, '%1|%2', ApprovalEntry2.Status::Open, ApprovalEntry2.Status::Created);
            if ApprovalEntry2.FindSet() then
                repeat
                    ApprovalEntry2.Status := ApprovalEntry2.Status::Approved;
                    ApprovalEntry2.Modify();
                until ApprovalEntry2.Next() = 0;
        end else begin
            ApprovalEntry2.Reset();
            ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
            ApprovalEntry2.SetRange("Workflow Step Instance ID", ApprovalEntry."Workflow Step Instance ID");
            ApprovalEntry2.SetRange("Sequence No.", ApprovalEntry."Sequence No.");
            ApprovalEntry2.SetRange("Approver ID", UserId);
            ApprovalEntry2.SetRange(Status, ApprovalEntry2.Status::Approved);
            if ApprovalEntry2.FindFirst() then
                ApprovalEntry.Status := ApprovalEntry.Status::Approved;
        end;
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowevenHandling: Codeunit "Workflow Event Handling";
        workflowsetup: codeunit "Workflow Setup";

        DocumentCapturingsendforapprovaleventdescTxt: Label 'Approval of a Document Capturing Document is requested';
        DocumentCapturingCategoryDescTxt: Label 'DocumentCapturingDocuments';
        DocumentCapturingTypeCondnTxt: Label '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name=DocumentCapturing>%1</DataItem></DataItems></ReportParameters>';
        DocumentCapturingrequestcanceleventdescTxt: Label 'Approval of a Document Capturing Document is Cancelled';
        DocumentCapturingCategoryTxt: Label 'DocumentCapturinsgpecifications';
        DocumentCapturingDocOCRWorkflowCodeTxt: Label 'Document Capturing';
        DocumentCapturingApprWorkflowDescTxt: Label 'Document Capturing Approval Workflow';
        NoworkfloweableErr: Label 'No work flows enabled';

}