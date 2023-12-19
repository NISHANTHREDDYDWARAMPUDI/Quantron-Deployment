codeunit 50003 "Send Email Stream"
{
    procedure RecipientStringToList(DelimitedRecipients: Text; var Recipients: List of [Text])
    var
        Seperators: Text;
    begin
        if DelimitedRecipients = '' then
            exit;

        Seperators := '; ,';
        Recipients := DelimitedRecipients.Split(Seperators.Split());
    end;

    procedure GetEmailBody(PurchHdr: Record "Purchase Header") BodyTxt: Text;
    var
        CustomReportLayout: Record "Custom Report Layout";
        ReportLayoutSelection: Record "Report Layout Selection";
        ReportSelection: Record "Report Selections";
        TempBlob: Codeunit "Temp Blob";
        RecRef: RecordRef;
        InStreamVar: InStream;
        OutStreamVar: OutStream;
    begin
        if not ReportSelection.Get(ReportSelection.Usage::"P.Order", 1) then
            error('Email body report selection cannot found');
        ReportSelection.TestField("Email Body Layout Code");

        if not RecRef.Get(PurchHdr.RecordId) then
            RecRef.Find();
        RecRef.SetRecFilter();
        if CustomReportLayout.GET(ReportSelection."Email Body Layout Code") then begin
            ReportLayoutSelection.SetTempLayoutSelected(CustomReportLayout.Code);
            TempBlob.CreateOutStream(OutStreamVar);
            Report.SaveAs(CustomReportLayout."Report ID", '', ReportFormat::Html, OutStreamVar, RecRef);
            ReportLayoutSelection.SetTempLayoutSelected('');
            TempBlob.CREATEINSTREAM(InStreamVar);
            InStreamVar.READ(BodyTxt);
        end;
    end;

    procedure ReportSendMailPhyInvAttachment(ToAddr: Text): Boolean
    var
        ItemJnlBatch: Record "Item Journal Batch";
        PurchHeader: Record "Purchase Header";
        PurchSetup: Record "Purchases & Payables Setup";
        ReportLayoutSelection: Record "Report Layout Selection";
        PhyInvList: Report "Phys. Inventory List";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        TempBlobAtc: Array[10] of Codeunit "Temp Blob";
        inStreamReport: InStream;
        inStreamReportAtc: Array[10] of InStream;
        Recordr: RecordRef;
        i: Integer;
        outStreamReport: OutStream;
        outStreamReportAtc: Array[10] of OutStream;
        // Attachments
        FullFileName: Text;
        Parameters: Text;
        AttachmentNameLbl: Label 'Physical Inventory List.pdf';
        GreetingLbl: Label 'Dear Sir/Madam,';
        BodyTxtLbl: Label 'Please find below attached list of physical inventory list generated for this week.';
        Subject: Label 'Physical inventory.';
        EmailList: Text;
        ToList: List of [Text];
    begin
        //Email Config     
        clear(EmailMessage);
        EmailList := DelChr(ToAddr, '>', ';');
        RecipientStringToList(EmailList, ToList);
        EmailMessage.Create(ToList, Subject, '', true);
        EmailMessage.AppendToBody(GreetingLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(BodyTxtLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');

        PurchSetup.Get();
        PurchSetup.TestField("Def. Phy. Inv Template");
        PurchSetup.TestField("Def. Phy. Inv Batch");
        ItemJnlBatch.Reset();
        ItemJnlBatch.SetRange("Journal Template Name", PurchSetup."Def. Phy. Inv Template");
        ItemJnlBatch.SetRange(Name, PurchSetup."Def. Phy. Inv Batch");
        ItemJnlBatch.FindFirst();
        Recordr.GetTable(ItemJnlBatch);
        //Recordr.Find();

        //Generate blob from report
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);
        //Report.SaveAs(Report::"Phys. Inventory List", Parameters, ReportFormat::Pdf, outStreamReport, Recordr);
        PhyInvList.Initialize(true);
        PhyInvList.SaveAs(Parameters, ReportFormat::Pdf, outStreamReport, Recordr);
        EmailMessage.AddAttachment(AttachmentNameLbl, 'PDF', inStreamReport);

        //Send mail
        exit(Email.Send(EmailMessage, Enum::"Email Scenario"::Default));
    end;

    procedure ReportSendMailWithExternalAttachment(ReportToSend: Integer; Recordr: RecordRef; TableID: Integer; DocNo: Text; ToAddr: List of [Text]; Subject: Text[100]; Body: Text; AttachmentName: Text[100]): Boolean
    var
        DocumentAttachment: record "Document Attachment";
        PurchHeader: Record "Purchase Header";
        ReportLayoutSelection: Record "Report Layout Selection";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        TempBlob: Codeunit "Temp Blob";
        TempBlobAtc: Array[10] of Codeunit "Temp Blob";
        inStreamReport: InStream;
        inStreamReportAtc: Array[10] of InStream;
        i: Integer;
        outStreamReport: OutStream;
        outStreamReportAtc: Array[10] of OutStream;
        // Attachments
        FullFileName: Text;
        Parameters: Text;
        MailSent: Boolean;
        TempEmailModuleAccount: Record "Email Account" temporary;
        EmailScenarios: Codeunit "Email Scenario";
    begin
        //Email Config     
        clear(EmailMessage);
        PurchHeader.Get(PurchHeader."Document Type"::Order, DocNo);
        Body := GetEmailBody(PurchHeader);
        EmailMessage.Create(ToAddr, Subject, Body, true);

        //Generate blob from report
        TempBlob.CreateOutStream(outStreamReport);
        TempBlob.CreateInStream(inStreamReport);
        Report.SaveAs(ReportToSend, Parameters, ReportFormat::Pdf, outStreamReport, Recordr);
        EmailMessage.AddAttachment(AttachmentName, 'PDF', inStreamReport);
        i := 1;

        //Get attachment from the document - streams
        DocumentAttachment.Reset();
        DocumentAttachment.setrange("Table ID", TableID);
        DocumentAttachment.setrange("No.", DocNo);
        DocumentAttachment.SetRange("Include in Mail(Purch.)", true);
        if DocumentAttachment.FindSet() then begin
            repeat
                if DocumentAttachment."Document Reference ID".HasValue then begin
                    TempBlobAtc[i].CreateOutStream(outStreamReportAtc[i]);
                    TempBlobAtc[i].CreateInStream(inStreamReportAtc[i]);
                    FullFileName := DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension";
                    if DocumentAttachment."Document Reference ID".ExportStream(outStreamReportAtc[i]) then begin
                        //Mail Attachments
                        EmailMessage.AddAttachment(FullFileName, DocumentAttachment."File Extension", inStreamReportAtc[i]);
                    end;
                    i += 1;
                end;
            until DocumentAttachment.NEXT = 0;
        end;

        //Send mail
        Commit();
        EmailScenarios.GetEmailAccount(Enum::"Email Scenario"::Default, TempEmailModuleAccount);
        MailSent := Email.OpenInEditorModallyWithScenario(EmailMessage, TempEmailModuleAccount, Enum::"Email Scenario"::Default) = Enum::"Email Action"::Sent;
        exit(MailSent);
    end;

    procedure SendMailWithPOExpectedRcptDate(DocNo: Code[20]; ToAddr: List of [Text]): Boolean
    var
        PurchHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        ConfirmedExpectedDateLbl: Label 'Confirmed Expected Receipt Date';
        FooterLbl: Label 'ERP Administrator';
        GreetingLbl: Label 'Dear Sir/Madam,';
        HeaderLbl: Label 'Please find the below list of purchase lines with expected receipt dates.';
        RegardsLbl: Label 'Regards';
        Subject: Label 'Purchase order with expected receipt dates.';
        MailSent: Boolean;
        TempEmailModuleAccount: Record "Email Account" temporary;
        EmailScenarios: Codeunit "Email Scenario";
    begin
        clear(EmailMessage);
        PurchHeader.Get(PurchHeader."Document Type"::Order, DocNo);

        EmailMessage.Create(ToAddr, Subject, '', true);
        EmailMessage.AppendToBody(GreetingLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(HeaderLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<table border = "1" cellpadding = "0" cellspacing = "0">');
        EmailMessage.AppendToBody('<tr>');
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + PurchaseLine.FieldCaption("Document No.") + '</b>'));
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + PurchaseLine.FieldCaption("No.") + '</b>'));
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + PurchaseLine.FieldCaption(Description) + '</b>'));
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + PurchaseLine.FieldCaption(Quantity) + '</b>'));
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + PurchaseLine.FieldCaption("Expected Receipt Date") + '</b>'));
        EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', '<b>' + ConfirmedExpectedDateLbl + '</b>'));
        EmailMessage.AppendToBody('</tr>');

        PurchaseLine.Reset();
        PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchaseLine.SetRange("Document No.", PurchHeader."No.");
        if PurchaseLine.FindSet() then
            repeat
                EmailMessage.AppendToBody('<tr>');
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', PurchaseLine."Document No."));
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', PurchaseLine."No."));
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', PurchaseLine.Description));
                EmailMessage.AppendToBody(StrSubstNo('<td><center>%1</center></td>', PurchaseLine.Quantity));
                EmailMessage.AppendToBody(StrSubstNo('<td><center>%1</center></td>', PurchaseLine."Expected Receipt Date"));
                EmailMessage.AppendToBody(StrSubstNo('<td><center>%1</center></td>', PurchaseLine."Expected Receipt Date"));
                EmailMessage.AppendToBody('</tr>');
            until PurchaseLine.Next() = 0;

        EmailMessage.AppendToBody('</table>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(RegardsLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(FooterLbl);
        Commit();
        EmailScenarios.GetEmailAccount(Enum::"Email Scenario"::Default, TempEmailModuleAccount);
        MailSent := Email.OpenInEditorModallyWithScenario(EmailMessage, TempEmailModuleAccount, Enum::"Email Scenario"::Default) = Enum::"Email Action"::Sent;
        exit(MailSent);
    end;

    procedure SendMailForQuality(WarehouseReceiptLine: Record "Warehouse Receipt Line"): Boolean
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        FooterLbl: Label 'ERP Administrator';
        GreetingLbl: Label 'Dear Sir/Madam,';
        HeaderLbl: Label 'Please note that item no %1 has been received and ready for quality check &  Quality Spec ID - %2';
        Header2Lbl: label 'Purchase Order No. :  %1';
        Header3Lbl: Label 'Warehouse Receipt No. %1';
        RegardsLbl: Label 'Regards';
        Subject: Label 'Quality check required.';
        MailSent: Boolean;
        TempEmailModuleAccount: Record "Email Account" temporary;
        EmailScenarios: Codeunit "Email Scenario";
        ToAddr: Text;
        PurchPay: Record "Purchases & Payables Setup";
        PurchHeader: Record "Purchase Header";
        RecRef: RecordRef;
        DocumentURL: Text;
        PageManagement: Codeunit "Page Management";
        EmailList: Text;
        ToList: List of [Text];
        ItemRec: Record Item;
    begin
        PurchPay.Get();
        if PurchPay."Quality Check Incoming Email" = '' then
            exit;
        clear(EmailMessage);
        ToAddr := PurchPay."Quality Check Incoming Email";
        EmailList := DelChr(ToAddr, '>', ';');
        RecipientStringToList(EmailList, ToList);
        EmailMessage.Create(ToList, Subject, '', true);
        EmailMessage.AppendToBody(GreetingLbl);
        EmailMessage.AppendToBody('<br></br>');
        if not ItemRec.Get(WarehouseReceiptLine."Item No.") then
            Clear(ItemRec);
        EmailMessage.AppendToBody(StrSubstNo(HeaderLbl, WarehouseReceiptLine."Item No.", ItemRec."Quality Spec ID"));
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(StrSubstNo(Header2Lbl, WarehouseReceiptLine."Source No."));
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(StrSubstNo(Header3Lbl, WarehouseReceiptLine."No."));
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(RegardsLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(FooterLbl);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default);
        exit(MailSent);
    end;
}
