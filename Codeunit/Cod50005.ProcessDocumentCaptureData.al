codeunit 50005 ProcessDocumentCaptureData
{
    TableNo = "Job Queue Entry";
    trigger OnRun()
    begin
        case Rec."Parameter String" of
            'Verify':
                VerifyAttachmentData();
            'CreateInvoice':
                CreatePurchaseInvoice();
            'SendMail':
                SendEmail();
            else
                Error('Selection Mismatch.');
        end;
    end;

    var
        DocumentCapturingHdr: Record "Document Capturing Header";

    local procedure CreatePurchaseInvoice()
    var
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        DocumentCapturingHdr.Reset();
        DocumentCapturingHdr.SetRange(Status, DocumentCapturingHdr.Status::Validated);
        if DocumentCapturingHdr.FindFirst() then
            repeat
                ErrorMessage.Reset();
                ErrorMessage.SetRange("Context Record ID", DocumentCapturingHdr.RecordId);
                ErrorMessage.SetRange("Message Type", ErrorMessage."Message Type"::Error);
                if ErrorMessage.Count > 0 then
                    DocumentCapturingHdr.Status := DocumentCapturingHdr.Status::Failed
                else begin
                    DocumentCapturingHdr.CreateDoc();
                    DocumentCapturingHdr.Status := DocumentCapturingHdr.Status::Processed;
                end;
                DocumentCapturingHdr."Last Status Change Date" := WorkDate();
                DocumentCapturingHdr.Modify();
            until DocumentCapturingHdr.Next() = 0;
    end;

    local procedure VerifyAttachmentData()
    var
        ErrorMessage: Record "Error Message";
        TempErrorMessage: Record "Error Message" temporary;
    begin
        DocumentCapturingHdr.Reset();
        DocumentCapturingHdr.SetRange(Status, DocumentCapturingHdr.Status::New);
        if DocumentCapturingHdr.FindFirst() then
            repeat
                DocumentCapturingHdr.VerifyAttachmentData();
                DocumentCapturingHdr.Modify();
            until DocumentCapturingHdr.Next() = 0;
    end;

    local procedure SendEmail()
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FooterLbl: Label 'ERP Administrator';
        GreetingLbl: Label 'Dear Sir/Madam,';
        HeaderLbl: Label 'Please note that one or more than one document has been failed for validation in document capturing.';
        RegardsLbl: Label 'Regards';
        Subject: Label 'Document Capturing';
        MailSent: Boolean;
        TempEmailModuleAccount: Record "Email Account" temporary;
        EmailScenarios: Codeunit "Email Scenario";
        ToAddr: List of [Text];
    begin
        PurchPaySetup.Get();
        PurchPaySetup.TestField("Document Capturing Email");

        clear(EmailMessage);

        DocumentCapturingHdr.Reset();
        DocumentCapturingHdr.SetRange(Status, DocumentCapturingHdr.Status::Failed);
        if DocumentCapturingHdr.IsEmpty then
            exit;

        EmailMessage.Create(ToAddr, Subject, '', true);
        EmailMessage.AppendToBody(GreetingLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(HeaderLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(RegardsLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(FooterLbl);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
    end;
}
