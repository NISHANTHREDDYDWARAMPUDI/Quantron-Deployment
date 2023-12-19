report 50003 "Email POs Not Received"
{
    ApplicationArea = All;
    Caption = 'Email POs Not Received';
    UsageCategory = ReportsAndAnalysis;
    ProcessingOnly = true;

    dataset
    {
        dataitem(PurchaseLine; "Purchase Line")
        {
            DataItemTableView = order(ascending) where("Document Type" = const(order), "Completely Received" = const(false), Type = const(item));
            trigger OnPreDataItem()
            var
                ToAddr: List of [Text];
                CCAddr: List of [Text];
                BCCAddr: List of [Text];
                EmailListPurchLogTeam: Text;
                EmailListProjectTeam: Text;
                ToList: List of [Text];
                EventSubs: Codeunit "Event Subscribers";
            begin
                SetFilter("Expected Receipt Date", '<%1', WorkDate());
                PurchPayableSetup.Get();
                PurchPayableSetup.TestField("Purch./LogisticsTeam E-Mail");
                EmailListPurchLogTeam := DelChr(PurchPayableSetup."Purch./LogisticsTeam E-Mail", '>', ';');
                EmailListPurchLogTeam := CopyStr(EmailListPurchLogTeam, 1, MaxStrLen(PurchPayableSetup."Purch./LogisticsTeam E-Mail"));
                EventSubs.RecipientStringToList(EmailListPurchLogTeam, ToAddr);

                EmailListProjectTeam := DelChr(PurchPayableSetup."Project Team E-Mail", '>', ';');
                EmailListProjectTeam := CopyStr(EmailListProjectTeam, 1, MaxStrLen(PurchPayableSetup."Project Team E-Mail"));
                EventSubs.RecipientStringToList(EmailListProjectTeam, CCAddr);

                EmailMessage.Create(ToAddr, Subject, '', true, CCAddr, BCCAddr);
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
                EmailMessage.AppendToBody('</tr>');
                SendMail := FALSE;
            end;

            trigger OnAfterGetRecord()
            begin
                if Quantity = 0 then
                    CurrReport.Skip();
                EmailMessage.AppendToBody('<tr>');
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', "Document No."));
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', "No."));
                EmailMessage.AppendToBody(StrSubstNo('<td>%1</td>', Description));
                EmailMessage.AppendToBody(StrSubstNo('<td><center>%1</center></td>', Quantity));
                EmailMessage.AppendToBody(StrSubstNo('<td><center>%1</center></td>', "Expected Receipt Date"));
                EmailMessage.AppendToBody('</tr>');
                SendMail := true;
            end;

            trigger OnPostDataItem()
            begin
                EmailMessage.AppendToBody('</table>');
                EmailMessage.AppendToBody('<br></br>');
                EmailMessage.AppendToBody('<br></br>');
                EmailMessage.AppendToBody(RegardsLbl);
                EmailMessage.AppendToBody('<br></br>');
                EmailMessage.AppendToBody('<br></br>');
                EmailMessage.AppendToBody(FooterLbl);
                IF SendMail THEN
                    Email.Send(EmailMessage, Enum::"Email Scenario"::Default)
            end;
        }
    }
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        PurchPayableSetup: Record "Purchases & Payables Setup";
        SendMail: Boolean;
        Subject: Label 'POs not received within expected receipt date.';
        GreetingLbl: Label 'Dear Sir/Madam,';
        HeaderLbl: Label 'Please find the below list of purchase lines which are not yet received as per expected receipt date.';
        RegardsLbl: Label 'Regards';
        FooterLbl: Label 'ERP Administrator';
}
