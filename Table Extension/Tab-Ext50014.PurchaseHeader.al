tableextension 50014 PurchaseHeader extends "Purchase Header"
{
    fields
    {
        field(50000; "PO Mail Sent By"; Code[80])
        {
            Caption = 'PO Mail Sent By';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50001; "PO Mail Sent DateTime"; DateTime)
        {
            Caption = 'PO Mail Sent DateTime';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50003; "PO Mail Status"; Option)
        {
            Caption = 'PO Mail Status';
            Editable = false;
            OptionMembers = " ",Success,Failed;
            OptionCaption = ' ,Success,Failed';
            DataClassification = ToBeClassified;
        }
        field(50004; "PO Mail Error"; Text[500])
        {
            Caption = 'PO Mail Error';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(50005; "Document Capturing No."; Code[20])
        {
            Caption = 'Document Capturing No.';
            DataClassification = ToBeClassified;
        }
        field(50006; "Approval Route"; Code[20])
        {
            TableRelation = "Workflow User Group".Code;
            Caption = 'Approval Department';
            DataClassification = ToBeClassified;
        }
    }
    procedure EmailVendor(IsOrderMail: Boolean)
    var
        VendorRec: Record Vendor;
        ToAddr: List of [Text];
        PurchaseHeader: Record "Purchase Header";
        ReportSelections: Record "Report Selections";
        MailSent: Boolean;
        User: Record User;
    begin
        ReportSelections.Reset();
        ReportSelections.SetRange(Usage, ReportSelections.Usage::"P.Order");
        ReportSelections.SetRange("Use for Email Attachment", true);
        if ReportSelections.FindLast() then
            if ReportSelections."Report ID" = 0 then
                exit;
        if VendorRec.Get(Rec."Buy-from Vendor No.") and (VendorRec."E-Mail" <> '') then begin
            ToAddr.Add(VendorRec."E-Mail");
            clear(RecRef);
            PurchaseHeader.Reset();
            PurchaseHeader.SetRange("Document Type", Rec."Document Type");
            PurchaseHeader.SetRange("No.", Rec."No.");
            if PurchaseHeader.FindFirst() then;
            RecRef.GetTable(PurchaseHeader);
            MailSent := false;
            if IsOrderMail then begin
                if cuSendMail.ReportSendMailWithExternalAttachment(ReportSelections."Report ID", RecRef, RecRef.number, Rec."No.", ToAddr, 'Purchase order - ' + Rec."No.", '', Rec."No." + ' ' + Rec."Pay-to Name" + '.pdf') then begin
                    MailSent := true;
                    PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                    User.Get(UserSecurityId());
                    if User."Full Name" <> '' then
                        PurchaseHeader."PO Mail Sent By" := User."Full Name"
                    else
                        PurchaseHeader."PO Mail Sent By" := User."User Name";
                    PurchaseHeader."PO Mail Sent DateTime" := CurrentDateTime();
                    PurchaseHeader."PO Mail Status" := PurchaseHeader."PO Mail Status"::Success;
                end else begin
                    PurchaseHeader.Get(Rec."Document Type", Rec."No.");
                    PurchaseHeader."PO Mail Sent By" := '';
                    PurchaseHeader."PO Mail Sent DateTime" := 0DT;
                    PurchaseHeader."PO Mail Status" := PurchaseHeader."PO Mail Status"::Failed;
                    PurchaseHeader."PO Mail Error" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Rec."PO Mail Error"));
                end;
                PurchaseHeader.Modify();
            end else begin
                if cuSendMail.SendMailWithPOExpectedRcptDate(Rec."No.", ToAddr) then
                    MailSent := true;
            end;
        end;
        if MailSent then
            Message(text001)
        else
            Message(text002);
    end;

    var
        cuSendMail: Codeunit "Send Email Stream";
        RecRef: RecordRef;
        text001: Label 'Email Sent';
        text002: Label 'Email address not present, go to vendor page and fill Email field. or please check the log fields';
}
