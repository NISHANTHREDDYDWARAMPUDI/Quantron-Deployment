codeunit 50002 "Event Subscribers"
{
    Permissions =
        tabledata "Approval Entry" = R,
        tabledata Currency = R,
        tabledata "Direct Trans. Header" = R,
        tabledata "Document Attachment" = R,
        tabledata "Document Capturing Header" = RM,
        tabledata "Entry Summary" = R,
        tabledata "General Ledger Setup" = R,
        tabledata Item = R,
        tabledata "Item Application Entry" = R,
        tabledata "Item Journal Line" = R,
        tabledata "Item Ledger Entry" = R,
        tabledata "Item Revision" = RI,
        tabledata "Item Tracking Comment" = R,
        tabledata "Manufacturing Setup" = R,
        tabledata "Prod. Order Component" = R,
        tabledata "Prod. Order Line" = R,
        tabledata "Prod. Order Routing Line" = R,
        tabledata "Prod Ord. Routing QS Header" = RID,
        tabledata "Prod Ord. Routing QS Line" = RI,
        tabledata "Production BOM Line" = R,
        tabledata "Production Order" = RM,
        tabledata "Purch. Inv. Header" = R,
        tabledata "Purch. Rcpt. Line" = R,
        tabledata "Purch. Rcpt QS Header" = RID,
        tabledata "Purch. Rcpt QS Line" = RI,
        tabledata "Purchase Header" = R,
        tabledata "Purchase Line" = R,
        tabledata "Purchases & Payables Setup" = R,
        tabledata "Quality Specification Header" = R,
        tabledata "Quality Specification Line" = R,
        tabledata "Reservation Entry" = R,
        tabledata "Routing Line" = R,
        tabledata "Sales Header" = R,
        tabledata "Sales Invoice Line" = R,
        tabledata "Sales Line" = R,
        tabledata "Service Header" = R,
        tabledata "Service Item" = RM,
        tabledata "Service Item Comp.Trac Comment" = RID,
        tabledata "Service Item Component" = RI,
        tabledata "Tracking Specification" = R,
        tabledata "Transfer Header" = R,
        tabledata "User Setup" = R,
        tabledata "Work Center" = R,
        tabledata "Workflow Step Argument" = R,
        tabledata "Workflow User Group Member" = R;

    var
        NewLineNo: Integer;
        PurchReceiptDate: Date;
        RevisionGlobal: Code[20];
        ModifyRun: Boolean;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order from Sale", 'OnAfterCreateProdOrderFromSalesLine', '', true, true)]
    local procedure "Create Prod. Order from Sale_OnAfterCreateProdOrderFromSalesLine"
    (
        var ProdOrder: Record "Production Order";
        var SalesLine: Record "Sales Line"
    )
    var
        SalesHeader: Record "Sales Header";
    begin
        if not SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            exit;
        SalesHeader.CalcFields("Work Description");
        if SalesHeader."Work Description".HasValue then
            ProdOrder."Work Description" := SalesHeader."Work Description";
    end;

    [EventSubscriber(ObjectType::Report, Report::"Refresh Production Order", 'OnBeforeCalcProdOrder', '', true, true)]
    local procedure "Refresh Production Order_OnBeforeCalcProdOrder"
    (
        var ProductionOrder: Record "Production Order";
        Direction: Option
    )
    var
        SalesHeader: Record "Sales Header";
    begin
        if ProductionOrder.Status <> ProductionOrder.Status::Simulated then
            if not SalesHeader.Get(SalesHeader."Document Type"::Order, ProductionOrder."Source No.") then
                if not SalesHeader.Get(SalesHeader."Document Type"::Quote, ProductionOrder."Source No.") then
                    Clear(SalesHeader);
        SalesHeader.CalcFields("Work Description");
        if not SalesHeader."Work Description".HasValue then
            exit;
        if SalesHeader."Work Description".Length = ProductionOrder."Work Description".Length then
            exit;
        ProductionOrder."Work Description" := SalesHeader."Work Description";
        ProductionOrder.Modify(true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Routing Line", 'OnAfterCopyFromRoutingLine', '', true, true)]
    local procedure "Prod. Order Routing Line_OnAfterCopyFromRoutingLine"
    (
        var ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        RoutingLine: Record "Routing Line"
    )
    begin
        ProdOrderRoutingLine."Work Instruction" := RoutingLine."Work Instruction";
        ProdOrderRoutingLine."Quality Check" := RoutingLine."Quality Check";
        ProdOrderRoutingLine."Quality Spec ID" := RoutingLine."Quality Spec ID";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production Order", 'OnBeforeAssignSalesHeader', '', true, true)]
    local procedure "Production Order_OnBeforeAssignSalesHeader"
    (
        var ProdOrder: Record "Production Order";
        xProdOrder: Record "Production Order";
        var SalesHeader: Record "Sales Header";
        CallingFieldNo: Integer
    )
    begin
        SalesHeader.CalcFields("Work Description");
        if not SalesHeader."Work Description".HasValue then
            exit;
        if SalesHeader."Work Description".Length = ProdOrder."Work Description".Length then
            exit;
        ProdOrder."Work Description" := SalesHeader."Work Description";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Production BOM Line", 'OnValidateNoOnAfterAssignItemFields', '', true, true)]
    local procedure "Production BOM Line_OnValidateNoOnAfterAssignItemFields"
    (
        var ProductionBOMLine: Record "Production BOM Line";
        Item: Record "Item";
        var xProductionBOMLine: Record "Production BOM Line";
        CallingFieldNo: Integer
    )
    begin
        ProductionBOMLine."Description 2" := Item."Description 2";
        ProductionBOMLine.Revision := Item.Revision;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Standard Sales - Invoice", 'OnBeforeLineOnAfterGetRecord', '', true, true)]
    local procedure "Standard Sales - Invoice_OnBeforeLineOnAfterGetRecord"
    (
        var SalesInvoiceHeader: Record "Sales Invoice Header";
        var SalesInvoiceLine: Record "Sales Invoice Line"
    )
    var
        SalesInvLine: Record "Sales Invoice Line";
    begin
        if SalesInvLine.Get(SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No.") then
            SalesInvoiceLine."No." := SalesInvLine."No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calculate Prod. Order", 'OnAfterTransferTaskInfo', '', true, true)]
    local procedure "Calculate Prod. Order_OnAfterTransferTaskInfo"
    (
        var ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        VersionCode: Code[20]
    )
    begin
        if ProdOrderRoutingLine."Quality Check" then
            CopyQualitySpec(ProdOrderRoutingLine);
    end;

    local procedure CopyQualitySpec(ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        ProdOrderRoutingQSHdr: Record "Prod Ord. Routing QS Header";
        ProdOrderRoutingQSLine: Record "Prod Ord. Routing QS Line";
        QualitySpecHdr: Record "Quality Specification Header";
        QualitySpecLine: Record "Quality Specification Line";
    begin
        QualitySpecHdr.Get(ProdOrderRoutingLine."Quality Spec ID");
        if ProdOrderRoutingQSHdr.Get(ProdOrderRoutingLine.Status,
                                    ProdOrderRoutingLine."Prod. Order No.",
                                    ProdOrderRoutingLine."Routing Reference No.",
                                    ProdOrderRoutingLine."Routing No.",
                                    ProdOrderRoutingLine."Operation No.",
                                    QualitySpecHdr."Spec ID") then
            ProdOrderRoutingQSHdr.Delete(true);


        //Insert Routing Quality Spec Header
        ProdOrderRoutingQSHdr.Reset();
        ProdOrderRoutingQSHdr.Init();
        ProdOrderRoutingQSHdr.Status := ProdOrderRoutingLine.Status;
        ProdOrderRoutingQSHdr."Prod. Order No." := ProdOrderRoutingLine."Prod. Order No.";
        ProdOrderRoutingQSHdr."Routing Reference No." := ProdOrderRoutingLine."Routing Reference No.";
        ProdOrderRoutingQSHdr."Routing No." := ProdOrderRoutingLine."Routing No.";
        ProdOrderRoutingQSHdr."Operation No." := ProdOrderRoutingLine."Operation No.";
        ProdOrderRoutingQSHdr."Spec ID" := QualitySpecHdr."Spec ID";
        ProdOrderRoutingQSHdr.Description := QualitySpecHdr.Description;
        ProdOrderRoutingQSHdr."Time (Hours)" := QualitySpecHdr."Time (Hours)";
        ProdOrderRoutingQSHdr."Update Status" := ProdOrderRoutingQSHdr."Update Status"::New;
        ProdOrderRoutingQSHdr.Insert();

        //Insert Routing Quality Spec Line
        QualitySpecLine.Reset();
        QualitySpecLine.SetRange("Spec ID", QualitySpecHdr."Spec ID");
        if QualitySpecLine.FindSet() then
            repeat
                ProdOrderRoutingQSLine.Reset();
                ProdOrderRoutingQSLine.Init();
                ProdOrderRoutingQSLine.Status := ProdOrderRoutingLine.Status;
                ProdOrderRoutingQSLine."Prod. Order No." := ProdOrderRoutingLine."Prod. Order No.";
                ProdOrderRoutingQSLine."Routing Reference No." := ProdOrderRoutingLine."Routing Reference No.";
                ProdOrderRoutingQSLine."Routing No." := ProdOrderRoutingLine."Routing No.";
                ProdOrderRoutingQSLine."Operation No." := ProdOrderRoutingLine."Operation No.";
                ProdOrderRoutingQSLine."Spec ID" := QualitySpecLine."Spec ID";
                ProdOrderRoutingQSLine."Line No." := QualitySpecLine."Line No.";
                ProdOrderRoutingQSLine."Specification Group" := QualitySpecLine."Specification Group";
                ProdOrderRoutingQSLine.Specification := QualitySpecLine.Specification;
                ProdOrderRoutingQSLine.Responsibility := QualitySpecLine.Responsibility;
                ProdOrderRoutingQSLine."Document Mandatory" := QualitySpecLine."Document Mandatory";
                ProdOrderRoutingQSLine.Insert();
            until QualitySpecLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeRunWithCheck', '', false, false)]
    local procedure OnBeforeRunWithCheck(var ItemJournalLine: Record "Item Journal Line"; CalledFromAdjustment: Boolean; CalledFromInvtPutawayPick: Boolean; CalledFromApplicationWorksheet: Boolean; PostponeReservationHandling: Boolean; var IsHandled: Boolean)
    var
        ProdOrderLine: Record "Prod. Order Line";
        PurchRecptLine: Record "Purch. Rcpt. Line";
        Error0001: Label 'Output quantity cannot be posted as the quality check is enable and quality specification is not completed for \ operation no. : %1';
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";

    begin
        if ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Output then
            exit;

        if not (ProdOrderLine.Get(ProdOrderLine.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.")) then
            exit;
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRoutingLine.SetRange("Quality Check", true);
        ProdOrderRoutingLine.SetRange("Operation No.", ItemJournalLine."Operation No.");
        if ProdOrderRoutingLine.FindSet() then
            repeat
                if not ProdOrderRoutingLine."Quality Check Completed" then
                    Error(Error0001, ProdOrderRoutingLine."Operation No.");
            until ProdOrderRoutingLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
        SpecID: Code[20];
        SpecLineNo: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Work Center":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            Database::"Purch. Rcpt QS Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    FieldRef := RecRef.Field(2);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.Validate("Line No.", LineNo);

                    DocumentAttachment."Record ID" := RecRef.RecordId;
                end;
            Database::"Prod Ord. Routing QS Line":
                begin
                    FieldRef := RecRef.Field(4);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);

                    FieldRef := RecRef.Field(5);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.Validate("Line No.", LineNo);

                    DocumentAttachment."Record ID" := RecRef.RecordId;
                end;
            Database::"Document Capturing Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.Validate("No.", RecNo);
                end
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef; var FlowFieldsEditable: Boolean)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        LineNo: Integer;
        SpecID: Code[20];
        SpecLineNo: Integer;
    begin
        case RecRef.Number of
            Database::"Work Center":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            Database::"Purch. Rcpt QS Line":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FieldRef := RecRef.Field(2);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", LineNo);

                    DocumentAttachment.SetRange("Record ID", RecRef.RecordId);
                end;
            Database::"Prod Ord. Routing QS Line":
                begin
                    FieldRef := RecRef.Field(4);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);

                    FieldRef := RecRef.Field(5);
                    LineNo := FieldRef.Value;
                    DocumentAttachment.SetRange("Line No.", LineNo);

                    DocumentAttachment.SetRange("Record ID", RecRef.RecordId);
                end;
            Database::"Document Capturing Header":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', true, true)]
    local procedure "Document Attachment Factbox_OnBeforeDrillDown"
    (
        DocumentAttachment: Record "Document Attachment";
        var RecRef: RecordRef
    )
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        WorkCenter: Record "Work Center";
        LineNo: Integer;
        PurchRcptQSLine: Record "Purch. Rcpt QS Line";
        DocumentCapturingHdr: Record "Document Capturing Header";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Work Center":
                begin
                    RecRef.Open(DATABASE::"Work Center");
                    if WorkCenter.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(WorkCenter);
                end;
            Database::"Document Capturing Header":
                begin
                    RecRef.Open(Database::"Document Capturing Header");
                    if DocumentCapturingHdr.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(DocumentCapturingHdr);
                end;
        end;

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInsertCapLedgEntry', '', true, true)]
    local procedure "Item Jnl.-Post Line_OnAfterInsertCapLedgEntry"
    (
        var CapLedgEntry: Record "Capacity Ledger Entry";
        ItemJournalLine: Record "Item Journal Line"
    )
    var
        ManufacturingSetup: Record "Manufacturing Setup";
        ProdOrderLine: Record "Prod. Order Line";
        PurchRecptLine: Record "Purch. Rcpt. Line";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
    begin
        if ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Output then
            exit;
        ManufacturingSetup.Get();
        if (ManufacturingSetup."Sales Team Email" = '') and (ManufacturingSetup."Account Team Email" = '') then
            exit;
        if not (ProdOrderLine.Get(ProdOrderLine.Status::Released, ItemJournalLine."Order No.", ItemJournalLine."Order Line No.")) then
            exit;
        ProdOrderRoutingLine.Reset();
        ProdOrderRoutingLine.SetRange(Status, ProdOrderLine.Status);
        ProdOrderRoutingLine.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderRoutingLine.SetRange("Routing Reference No.", ProdOrderLine."Routing Reference No.");
        ProdOrderRoutingLine.SetRange("Routing No.", ProdOrderLine."Routing No.");
        ProdOrderRoutingLine.SetRange("Operation No.", ItemJournalLine."Operation No.");
        if (ProdOrderRoutingLine.FindFirst()) and (ProdOrderRoutingLine."Send Operation Completion Mail") then begin
            if ManufacturingSetup."Sales Team Email" <> '' then
                SendMail(ManufacturingSetup."Sales Team Email", ProdOrderRoutingLine);
            Sleep(1000);
            if ManufacturingSetup."Account Team Email" <> '' then
                SendMail(ManufacturingSetup."Account Team Email", ProdOrderRoutingLine);
        end;


    end;

    local procedure SendMail(EmailID: Text; ProdOrderRoutingLine: Record "Prod. Order Routing Line")
    var
        Email: Codeunit Email;
        EmailMessage: Codeunit "Email Message";
        Subject: Text;
        SubjectLbl: Label '';
        GreetingLbl: Label 'Dear Sir/Madam,';
        HeaderLbl: Label 'Please note that routing operation completed - %1,%2 against the production order %3.';
        RegardsLbl: Label 'Regards';
        FooterLbl: Label 'ERP Administrator';
    begin
        Subject := ProdOrderRoutingLine.Description;
        EmailMessage.Create(EmailID, Subject, '', true);
        EmailMessage.AppendToBody(GreetingLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(StrSubstNo(HeaderLbl, ProdOrderRoutingLine."Routing No.", ProdOrderRoutingLine.Description, ProdOrderRoutingLine."Prod. Order No."));
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(RegardsLbl);
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody('<br></br>');
        EmailMessage.AppendToBody(FooterLbl);
        Email.Send(EmailMessage, Enum::"Email Scenario"::Default)
    end;

    procedure RecipientStringToList(DelimitedRecipients: Text; var Recipients: List of [Text])
    var
        Seperators: Text;
    begin
        if DelimitedRecipients = '' then
            exit;

        Seperators := '; ,';
        Recipients := DelimitedRecipients.Split(Seperators.Split());
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', true, true)]
    local procedure "Purch.-Post_OnAfterPurchRcptLineInsert"
    (
        PurchaseLine: Record "Purchase Line";
        var PurchRcptLine: Record "Purch. Rcpt. Line";
        ItemLedgShptEntryNo: Integer;
        WhseShip: Boolean;
        WhseReceive: Boolean;
        CommitIsSupressed: Boolean;
        PurchInvHeader: Record "Purch. Inv. Header";
        var TempTrackingSpecification: Record "Tracking Specification";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        TempWhseRcptHeader: Record "Warehouse Receipt Header";
        xPurchLine: Record "Purchase Line";
        var TempPurchLineGlobal: Record "Purchase Line"
    )
    begin
        if PurchaseLine."Quality Check" then
            CopyPurchRcptQualitySpec(PurchaseLine, PurchRcptLine);

    end;

    local procedure CopyPurchRcptQualitySpec(PurchaseLine: Record "Purchase Line"; PurchRcptLine: Record "Purch. Rcpt. Line")
    var
        PurchRcptQSHdr: Record "Purch. Rcpt QS Header";
        PurchRcptQSLine: Record "Purch. Rcpt QS Line";
        QualitySpecHdr: Record "Quality Specification Header";
        QualitySpecLine: Record "Quality Specification Line";
    begin
        QualitySpecHdr.Get(PurchaseLine."Quality Spec ID");
        if PurchRcptQSHdr.Get(PurchRcptLine."Document No.") then
            PurchRcptQSHdr.Delete(true);

        //Insert Routing Quality Spec Header
        PurchRcptQSHdr.Reset();
        PurchRcptQSHdr.Init();
        PurchRcptQSHdr."Document No." := PurchRcptLine."Document No.";
        PurchRcptQSHdr."Rcpt. Line No." := PurchRcptLine."Line No.";
        PurchRcptQSHdr."Spec ID" := QualitySpecHdr."Spec ID";
        PurchRcptQSHdr.Description := QualitySpecHdr.Description;
        PurchRcptQSHdr."Time (Hours)" := QualitySpecHdr."Time (Hours)";
        PurchRcptQSHdr."Update Status" := PurchRcptQSHdr."Update Status"::New;
        PurchRcptQSHdr.Insert();

        //Insert Routing Quality Spec Line
        QualitySpecLine.Reset();
        QualitySpecLine.SetRange("Spec ID", QualitySpecHdr."Spec ID");
        if QualitySpecLine.FindSet() then
            repeat
                PurchRcptQSLine.Reset();
                PurchRcptQSLine.Init();
                PurchRcptQSLine."Document No." := PurchRcptLine."Document No.";
                PurchRcptQSLine."Rcpt. Line No." := PurchRcptLine."Line No.";
                PurchRcptQSLine."Spec ID" := QualitySpecLine."Spec ID";
                PurchRcptQSLine."Line No." := QualitySpecLine."Line No.";
                PurchRcptQSLine."Specification Group" := QualitySpecLine."Specification Group";
                PurchRcptQSLine.Specification := QualitySpecLine.Specification;
                PurchRcptQSLine.Responsibility := QualitySpecLine.Responsibility;
                PurchRcptQSLine."Document Mandatory" := QualitySpecLine."Document Mandatory";
                PurchRcptQSLine.Insert();
            until QualitySpecLine.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure "Purchase Line_OnAfterAssignItemValues"
    (
        var PurchLine: Record "Purchase Line";
        Item: Record "Item";
        CurrentFieldNo: Integer;
        PurchHeader: Record "Purchase Header"
    )
    begin
        PurchLine."Quality Check" := Item."Quality Check";
        PurchLine."Quality Spec ID" := Item."Quality Spec ID";
        PurchLine.Revision := Item.Revision;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Component", 'OnValidateItemNoOnAfterUpdateUOMFromItem', '', true, true)]
    local procedure "Prod. Order Component_OnValidateItemNoOnAfterUpdateUOMFromItem"
    (
        var ProdOrderComponent: Record "Prod. Order Component";
        xProdOrderComponent: Record "Prod. Order Component";
        Item: Record "Item"
    )
    var
        ManufacturingSetup: Record "Manufacturing Setup";
    begin
        ManufacturingSetup.Get();
        if ProdOrderComponent."Description 2" = '' then
            ProdOrderComponent."Description 2" := Item."Description 2";
        ProdOrderComponent.Revision := Item.Revision;
        if ProdOrderComponent."Transfer-from Location Code" = '' then
            ProdOrderComponent."Transfer-from Location Code" := ManufacturingSetup."Def. Pick List Transfer From";
        if ProdOrderComponent."Transfer-from Bin Code" = '' then
            ProdOrderComponent."Transfer-from Bin Code" := ManufacturingSetup."Def. Pick List Bin Code";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Transfer", 'OnInsertDirectTransHeaderOnBeforeDirectTransHeaderInsert', '', true, true)]
    local procedure "TransferOrder-Post Transfer_OnInsertDirectTransHeaderOnBeforeDirectTransHeaderInsert"
    (
        var DirectTransHeader: Record "Direct Trans. Header";
        TransferHeader: Record "Transfer Header"
    )
    begin
        DirectTransHeader."Prod. Order No." := TransferHeader."Released Prod. Order No,";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', true, true)]
    local procedure "Item Jnl.-Post Line_OnAfterInitItemLedgEntry"
    (
        var NewItemLedgEntry: Record "Item Ledger Entry";
        var ItemJournalLine: Record "Item Journal Line";
        var ItemLedgEntryNo: Integer
    )
    begin
        NewItemLedgEntry.Comment := ItemJournalLine.Comment;
        NewItemLedgEntry."Comment Description" := ItemJournalLine."Comment Description";
    end;
    //B2BDNROn18May2023>>
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Format Document", 'OnAfterSetSalesPurchaseLine', '', false, false)]
    local procedure OnAfterSetSalesPurchaseLine(Quantity: Decimal; UnitPrice: Decimal; VATPercentage: Decimal; LineAmount: Decimal; CurrencyCode: Code[10]; var FormattedQuantity: Text; var FormattedUnitPrice: Text; var FormattedVATPercentage: Text; var FormattedLineAmount: Text; CommentLine: Boolean)
    var
        PurchaseHeader: Record "Purchase Header";
        CurrencyRec: Record Currency;
        GeneralLedgerSetup: Record "General Ledger Setup";
        CurrecySymbol1: Text[10];
        PurchaseLine: Record "Purchase Line";
    begin
        GeneralLedgerSetup.Get();
        if CurrencyRec.Get(CurrencyCode) then
            CurrecySymbol1 := CurrencyRec.GetCurrencySymbol()
        else
            CurrecySymbol1 := GeneralLedgerSetup.GetCurrencySymbol();
        if FormattedUnitPrice <> '' then
            FormattedUnitPrice := FormattedUnitPrice + ' ' + CurrecySymbol1;
        if FormattedLineAmount <> '' then
            FormattedLineAmount := FormattedLineAmount + ' ' + CurrecySymbol1;
    end;
    //B2BDNROn18May2023<<

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post", 'OnBeforeCode', '', true, true)]
    local procedure "Item Jnl.-Post_OnBeforeCode"
    (
        var ItemJournalLine: Record "Item Journal Line";
        var HideDialog: Boolean;
        var SuppressCommit: Boolean;
        var IsHandled: Boolean
    )
    var
        PurchPaySetup: Record "Purchases & Payables Setup";
    begin
        PurchPaySetup.Get();
        if (ItemJournalLine."Journal Template Name" = PurchPaySetup."Reclass Journal Template") and
           (ItemJournalLine."Journal Batch Name" = PurchPaySetup."Reclass Journal Batch") then
            HideDialog := true;
    end;

    [EventSubscriber(ObjectType::Report, Report::"Standard Sales - Pro Forma Inv", 'OnAfterLineOnPreDataItem', '', true, true)]
    local procedure "Standard Sales - Pro Forma Inv_OnAfterLineOnPreDataItem"
    (
        var SalesHeader: Record "Sales Header";
        var SalesLine: Record "Sales Line"
    )
    begin
        SalesLine.SetRange(Type);
    end;

    [EventSubscriber(ObjectType::Report, Report::"Standard Sales - Pro Forma Inv", 'OnBeforeGetItemForRec', '', true, true)]
    local procedure "Standard Sales - Pro Forma Inv_OnBeforeGetItemForRec"
    (
        ItemNo: Code[20];
        var IsHandled: Boolean
    )
    var
        ItemLRec: Record Item;
    begin
        If not ItemLRec.Get(ItemNo) then
            IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Fact_B2B", 'OnBeforeDrillDownCust', '', true, true)]
    local procedure "Document Attachment Factbox_OnBeforeDrillDownCust"
        (
            DocumentAttachment: Record "Document Attachment";
            var RecRef: RecordRef
        )
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        WorkCenter: Record "Work Center";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Work Center":
                begin
                    RecRef.Open(DATABASE::"Work Center");
                    if WorkCenter.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(WorkCenter);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Det_B2B", 'OnAfterOpenForRecRefCust', '', false, false)]
    local procedure OnAfterOpenForRecRefCust(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            Database::"Work Center":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value();
                    DocumentAttachment.SetRange("No.", RecNo);
                end
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"ServItemManagement", 'OnCreateServItemOnSalesLineShptOnAfterAddServItemComponents', '', true, true)]
    local procedure "ServItemManagement_OnCreateServItemOnSalesLineShptOnAfterAddServItemComponents"
    (
        var SalesHeader: Record "Sales Header";
        var SalesLine: Record "Sales Line";
        var SalesShipmentLine: Record "Sales Shipment Line";
        var ServiceItem: Record "Service Item";
        var TempServiceItem: Record "Service Item";
        var TempServiceItemComp: Record "Service Item Component"
    )
    var
        ProdOrder: Record "Production Order";
        ProdOrderLine: Record "Prod. Order Line";
        PrevItemNo: Code[20];
        ServiceItemComp: Record "Service Item Component";
    begin
        NewLineNo := 0;
        ProdOrder.Reset();
        ProdOrder.SetRange("Source Type", ProdOrder."Source Type"::"Sales Header");
        ProdOrder.SetRange("Source No.", SalesHeader."No.");
        if not ProdOrder.FindFirst() then
            exit;

        ServiceItemComp.Reset();
        ServiceItemComp.SetRange("Parent Service Item No.", ServiceItem."No.");
        if ServiceItemComp.FindLast() then
            NewLineNo := ServiceItemComp."Line No."
        else
            NewLineNo := 0;
        ProdOrderLine.Reset();
        ProdOrderLine.SetRange(Status, ProdOrder.Status);
        ProdOrderLine.SetRange("Prod. Order No.", ProdOrder."No.");
        ProdOrderLine.SetRange("Item No.", SalesLine."No.");
        ProdOrderLine.SetRange("SO Line No.", SalesLine."Line No.");
        ProdOrderLine.SetCurrentKey("Item No.");
        if ProdOrderLine.FindSet() then
            repeat
                TransferComponentsToServiceItems(ProdOrderLine, ServiceItem);
                ServiceItem."Prod. Order No." := ProdOrderLine."Prod. Order No.";
                ServiceItem."Prod. Order Line No." := ProdOrderLine."Line No.";
                ServiceItem.Modify();
            until ProdOrderLine.Next() = 0;
    end;

    procedure TransferComponentsToServiceItems(ProdOrderLine: Record "Prod. Order Line"; ServiceItem: Record "Service Item")
    var
        ProdOrderComponent: Record "Prod. Order Component";
        ServiceItemComp: Record "Service Item Component";
        ServiceItemCompTracComment: Record "Service Item Comp.Trac Comment";
        ItemLRec: Record Item;
        ILE: Record "Item Ledger Entry";
    begin
        ProdOrderComponent.Reset();
        ProdOrderComponent.SetRange(Status, ProdOrderLine.Status);
        ProdOrderComponent.SetRange("Prod. Order No.", ProdOrderLine."Prod. Order No.");
        ProdOrderComponent.SetRange("Prod. Order Line No.", ProdOrderLine."Line No.");
        ProdOrderComponent.SetCurrentKey("Line No.");
        if ProdOrderComponent.FindSet() then
            repeat
                FilterILE(ILE, ProdOrderComponent);
                if ILE.FindSet() then
                    repeat
                        NewLineNo += 10000;
                        ServiceItemComp.Init();
                        ServiceItemComp.Active := true;
                        ServiceItemComp."Parent Service Item No." := ServiceItem."No.";
                        ServiceItemComp."Line No." := NewLineNo;
                        ServiceItemComp.Type := ServiceItemComp.Type::Item;
                        ServiceItemComp."No." := ProdOrderComponent."Item No.";
                        ServiceItemComp."Date Installed" := WorkDate();
                        ServiceItemComp."Date Installed" := WorkDate();
                        Clear(PurchReceiptDate);
                        FindApplication(ILE);
                        ServiceItemComp."Purchase Recepit Date" := PurchReceiptDate;
                        ServiceItemComp.Description := ProdOrderComponent.Description;
                        ServiceItemComp."Serial No." := ILE."Serial No.";
                        ServiceItemComp."Variant Code" := ProdOrderComponent."Variant Code";
                        ServiceItemComp.Insert();
                    until ILE.Next() = 0;
            until ProdOrderComponent.Next() = 0;
    end;

    local procedure FilterILE(var ItemLedgEntry: Record "Item Ledger Entry"; var ProdOrderComp: Record "Prod. Order Component")
    begin
        ItemLedgEntry.Reset();
        ItemLedgEntry.SetCurrentKey("Order Type", "Order No.", "Order Line No.",
           "Entry Type", "Prod. Order Comp. Line No.");
        ItemLedgEntry.SetRange("Order Type", ItemLedgEntry."Order Type"::Production);
        ItemLedgEntry.SetRange("Order No.", ProdOrderComp."Prod. Order No.");
        ItemLedgEntry.SetRange("Order Line No.", ProdOrderComp."Prod. Order Line No.");
        ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."Entry Type"::Consumption);
        ItemLedgEntry.SetRange("Prod. Order Comp. Line No.", ProdOrderComp."Line No.");
    end;

    local procedure InsertServiceItemTrackingComments(ILE: Record "Item Ledger Entry")
    var
        ItemTrackingComment: Record "Item Tracking Comment";
        NewItemTrackingComment: Record "Service Item Comp.Trac Comment";
    begin
        ItemTrackingComment.Reset();
        if ILE."Serial No." <> '' then
            ItemTrackingComment.SetRange(Type, ItemTrackingComment.Type::"Serial No.")
        else
            ItemTrackingComment.SetRange(Type, ItemTrackingComment.Type::"Lot No.");
        ItemTrackingComment.SetRange("Item No.", ILE."Item No.");
        ItemTrackingComment.SetRange("Variant Code", ILE."Variant Code");
        if ILE."Serial No." <> '' then
            ItemTrackingComment.SetRange("Serial/Lot No.", ILE."Serial No.")
        else
            ItemTrackingComment.SetRange("Serial/Lot No.", ILE."Lot No.");
        if ItemTrackingComment.IsEmpty() then
            exit;

        if ILE."Serial No." <> '' then
            NewItemTrackingComment.SetRange(Type, NewItemTrackingComment.Type::"Serial No.")
        else
            NewItemTrackingComment.SetRange(Type, NewItemTrackingComment.Type::"Lot No.");
        NewItemTrackingComment.SetRange("Item No.", ILE."Item No.");
        NewItemTrackingComment.SetRange("Variant Code", ILE."Variant Code");
        if ILE."Serial No." <> '' then
            NewItemTrackingComment.SetRange("Serial/Lot No.", ILE."Serial No.")
        else
            NewItemTrackingComment.SetRange("Serial/Lot No.", ILE."Lot No.");
        if not NewItemTrackingComment.IsEmpty() then
            NewItemTrackingComment.DeleteAll();

        if ItemTrackingComment.FindSet() then
            repeat
                NewItemTrackingComment.Init();
                NewItemTrackingComment.TransferFields(ItemTrackingComment);
                NewItemTrackingComment.Insert();
            until ItemTrackingComment.Next() = 0;
    end;

    local procedure FindApplication(ItemLedgerEntry: Record "Item Ledger Entry")
    var
        ILE: Record "Item Ledger Entry";
        Application: Record "Item Application Entry";
    begin
        Application.Reset();
        Application.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        if Application.FindFirst() then begin
            if Application."Outbound Item Entry No." = Application."Item Ledger Entry No." then begin
                if ILE.get(Application."Inbound Item Entry No.") then begin
                    if ILE."Entry Type" in [ILE."Entry Type"::Purchase, ILE."Entry Type"::"Positive Adjmt.", ILE."Entry Type"::Output] then
                        PurchReceiptDate := ILE."Posting Date"
                    else
                        FindApplication(ILE);
                end;
            end else
                if ILE.get(Application."Outbound Item Entry No.") then begin
                    if ILE."Entry Type" in [ILE."Entry Type"::Purchase, ILE."Entry Type"::"Positive Adjmt.", ILE."Entry Type"::Output] then
                        PurchReceiptDate := ILE."Posting Date"
                    else
                        FindApplication(ILE);
                end;
        end;
    end;
    //CarryrevisionProcess
    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromPurchLine', '', True, True)]
    local procedure OnAfterCopyItemJnlLineFromPurchLine(var ItemJnlLine: Record "Item Journal Line"; PurchLine: Record "Purchase Line")
    begin
        ItemJnlLine.Revision := PurchLine.Revision;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', True, True)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    begin
        ItemJnlLine.Revision := SalesLine.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', True, True)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer)
    begin
        NewItemLedgEntry.Revision := ItemJournalLine.Revision;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Tracking Specification", 'OnAfterInitFromPurchLine', '', True, True)]
    local procedure OnAfterInitFromPurchLine(var TrackingSpecification: Record "Tracking Specification"; PurchaseLine: Record "Purchase Line")
    begin
        TrackingSpecification.Revision := PurchaseLine.Revision;
    end;

    [EventSubscriber(ObjectType::page, Page::"Item Tracking Lines", 'OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry', '', true, true)]
    local procedure OnRegisterChangeOnChangeTypeInsertOnBeforeInsertReservEntry(var TrackingSpecification: Record "Tracking Specification"; var OldTrackingSpecification: Record "Tracking Specification"; var NewTrackingSpecification: Record "Tracking Specification"; FormRunMode: Option)
    begin
        ModifyRun := false;
        RevisionGlobal := NewTrackingSpecification.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnAfterSetDates', '', True, True)]
    local procedure OnAfterSetDates(var ReservationEntry: Record "Reservation Entry")
    begin
        ReservationEntry.Revision := RevisionGlobal;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnCreateReservEntryExtraFields', '', True, True)]
    local procedure OnCreateReservEntryExtraFields(var InsertReservEntry: Record "Reservation Entry"; OldTrackingSpecification: Record "Tracking Specification"; NewTrackingSpecification: Record "Tracking Specification")
    begin
        InsertReservEntry.Revision := NewTrackingSpecification.Revision;
    end;

    [EventSubscriber(ObjectType::page, Page::"Item Tracking Lines", 'OnAfterEntriesAreIdentical', '', true, true)]
    local procedure OnAfterEntriesAreIdentical(ReservEntry1: Record "Reservation Entry"; ReservEntry2: Record "Reservation Entry"; var IdenticalArray: array[2] of Boolean)
    begin
        IdenticalArray[2] := (ReservEntry1.Revision = ReservEntry2.Revision);
    end;

    [EventSubscriber(ObjectType::page, Page::"Item Tracking Lines", 'OnAfterCopyTrackingSpec', '', true, true)]
    local procedure OnAfterCopyTrackingSpec(var SourceTrackingSpec: Record "Tracking Specification"; var DestTrkgSpec: Record "Tracking Specification")
    begin
        if ModifyRun then
            DestTrkgSpec.Revision := SourceTrackingSpec.Revision
        else
            SourceTrackingSpec.Revision := DestTrkgSpec.Revision;
    end;

    [EventSubscriber(ObjectType::page, Page::"Item Tracking Lines", 'OnAfterMoveFields', '', true, true)]
    local procedure OnAfterMoveFields(var TrkgSpec: Record "Tracking Specification"; var ReservEntry: Record "Reservation Entry")
    begin
        ReservEntry.Revision := TrkgSpec.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertSetupTempSplitItemJnlLine', '', True, True)]
    local procedure OnBeforeInsertSetupTempSplitItemJnlLine(var TempTrackingSpecification: Record "Tracking Specification" temporary; var TempItemJournalLine: Record "Item Journal Line" temporary; var PostItemJnlLine: Boolean; var ItemJournalLine2: Record "Item Journal Line"; SignFactor: Integer; FloatingFactor: Decimal)
    begin
        TempItemJournalLine.Revision := TempTrackingSpecification.Revision;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', true, true)]
    local procedure "Sales Line_OnAfterAssignItemValues"
    (
        var SalesLine: Record "Sales Line";
        Item: Record "Item";
        SalesHeader: Record "Sales Header"
    )
    begin
        SalesLine.Revision := Item.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnTransferItemLedgToTempRecOnBeforeInsert', '', true, true)]
    local procedure "Item Tracking Data Collection_OnTransferItemLedgToTempRecOnBeforeInsert"
    (
        var TempGlobalReservEntry: Record "Reservation Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        TrackingSpecification: Record "Tracking Specification";
        var IsHandled: Boolean
    )
    begin
        TempGlobalReservEntry.Revision := ItemLedgerEntry.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterCreateEntrySummary2', '', true, true)]
    local procedure "Item Tracking Data Collection_OnAfterCreateEntrySummary2"
    (
        var TempGlobalEntrySummary: Record "Entry Summary";
        var TempGlobalReservEntry: Record "Reservation Entry"
    )
    begin
        TempGlobalEntrySummary.Revision := TempGlobalReservEntry.Revision;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeInsertConsumptionJnlLine', '', true, true)]
    local procedure "Production Journal Mgt_OnBeforeInsertConsumptionJnlLine"
    (
        var ItemJournalLine: Record "Item Journal Line";
        ProdOrderComp: Record "Prod. Order Component";
        ProdOrderLine: Record "Prod. Order Line";
        Level: Integer
    )
    begin
        ItemJournalLine.Revision := ProdOrderComp.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Production Journal Mgt", 'OnBeforeInsertOutputJnlLine', '', true, true)]
    local procedure "Production Journal Mgt_OnBeforeInsertOutputJnlLine"
    (
        var ItemJournalLine: Record "Item Journal Line";
        ProdOrderRtngLine: Record "Prod. Order Routing Line";
        ProdOrderLine: Record "Prod. Order Line"
    )
    begin
        ItemJournalLine.Revision := ProdOrderLine.Revision;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Prod. Order Line", 'OnAfterCopyFromItem', '', true, true)]
    local procedure "Prod. Order Line_OnAfterCopyFromItem"
    (
        var ProdOrderLine: Record "Prod. Order Line";
        Item: Record "Item";
        var xProdOrderLine: Record "Prod. Order Line";
        CurrentFieldNo: Integer
    )
    begin
        ProdOrderLine.Revision := Item.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Prod. Order Lines", 'OnCopyFromSalesOrderOnBeforeProdOrderLineModify', '', true, true)]
    local procedure "Create Prod. Order Lines_OnCopyFromSalesOrderOnBeforeProdOrderLineModify"
    (
        var ProdOrderLine: Record "Prod. Order Line";
        SalesLine: Record "Sales Line";
        SalesPlanningLine: Record "Sales Planning Line";
        var NextProdOrderLineNo: Integer
    )
    begin
        ProdOrderLine."SO Line No." := SalesLine."Line No.";
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Service-Post (Yes/No)", 'OnAfterConfirmPost', '', false, false)]
    local procedure OnAfterConfirmPost(var ServiceHeader: Record "Service Header"; Ship: Boolean; Consume: Boolean; Invoice: Boolean)
    var
        DimensionErr: Label 'Both %1 & %2 is empty';
        Dimension2Err: Label 'Both %1 & %2 cannot be filled';
    begin
        if Invoice then begin
            if (ServiceHeader."Shortcut Dimension 1 Code" = '') and (ServiceHeader."Shortcut Dimension 2 Code" = '') then
                Error(DimensionErr, ServiceHeader.FieldCaption("Shortcut Dimension 1 Code"), ServiceHeader.FieldCaption("Shortcut Dimension 2 Code"));
        end;

    end;


    [EventSubscriber(ObjectType::Page, Page::"Item Tracking Lines", 'OnAfterAssignNewTrackingNo', '', true, true)]
    local procedure "Item Tracking Lines_OnAfterAssignNewTrackingNo"
    (
        var TrkgSpec: Record "Tracking Specification";
        xTrkgSpec: Record "Tracking Specification";
        FieldID: Integer
    )
    var
        ItemRec: Record Item;
    begin
        if TrkgSpec.Revision <> '' then
            exit;
        if ItemRec.Get(TrkgSpec."Item No.") then
            TrkgSpec.Revision := ItemRec.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Tracking Data Collection", 'OnAfterAssistEditTrackingNo', '', true, true)]
    local procedure "Item Tracking Data Collection_OnAfterAssistEditTrackingNo"
    (
        var TrackingSpecification: Record "Tracking Specification";
        var TempGlobalEntrySummary: Record "Entry Summary";
        CurrentSignFactor: Integer;
        MaxQuantity: Decimal;
        var TempGlobalReservationEntry: Record "Reservation Entry";
        LookupMode: Enum "Item Tracking Type"
    )
    var
        ItemRec: Record Item;
    begin
        TrackingSpecification.Revision := TempGlobalReservationEntry.Revision;
    end;

    procedure CreateItemRevisionEntry(ItemNo: Code[20]; RevisionVar: Code[20])
    var
        ItemRec: Record Item;
        ItemRevision: Record "Item Revision";
    begin
        if not ItemRec.Get(ItemNo) then
            exit;
        if (ItemNo = '') and (RevisionVar = '') then
            exit;
        if not ItemRevision.Get(ItemNo, RevisionVar) then begin
            ItemRevision.Reset();
            ItemRevision.Init();
            ItemRevision."Item No." := ItemNo;
            ItemRevision.Revision := RevisionVar;
            ItemRevision."Item Description" := ItemRec.Description;
            ItemRevision.Insert();
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnValidateItemNoOnAfterGetItem', '', true, true)]
    local procedure "Item Journal Line_OnValidateItemNoOnAfterGetItem"
    (
        var ItemJournalLine: Record "Item Journal Line";
        Item: Record "Item"
    )
    begin
        if not (ItemJournalLine."Entry Type" IN [ItemJournalLine."Entry Type"::Purchase,
                                            ItemJournalLine."Entry Type"::"Positive Adjmt.",
                                            ItemJournalLine."Entry Type"::Output]) then
            exit;
        if ItemJournalLine.Revision = '' then
            ItemJournalLine.Revision := Item.Revision;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnCreateApprovalRequestsOnElseCase', '', true, true)]
    local procedure "Approvals Mgmt._OnCreateApprovalRequestsOnElseCase"
   (
       WorkflowStepArgument: Record "Workflow Step Argument";
       var ApprovalEntryArgument: Record "Approval Entry"
   )
    begin
        if WorkflowStepArgument."Approver Type" = WorkflowStepArgument."Approver Type"::"Custom User Group" then
            CreateApprReqForApprTypeCustomUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
    end;

    local procedure CreateApprReqForApprTypeCustomUserGroup(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        WorkflowUserGroupMember: Record "Workflow User Group Member";
        ApproverId: Code[50];
        SequenceNo: Integer;
        IsHandled: Boolean;
        ApprovalMgt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
        PurchHeader: Record "Purchase Header";
        DocumentCapturingHdr: Record "Document Capturing Header";
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';
        NoWFUserGroupMembersErr: Label 'A Custom user group with at least one member must be set up.';
        WFUserGroupNotInSetupErr: Label 'The Custom user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The Custom user group member with user ID NAVUser does not exist in the Approval User Setup window.';
    begin
        if not UserSetup.Get(UserId) then
            Error(UserIdNotInSetupErr, UserId);
        SequenceNo := ApprovalMgt.GetLastSequenceNo(ApprovalEntryArgument);

        WorkflowUserGroupMember.SetCurrentKey("Workflow User Group Code", "Sequence No.");
        WorkflowUserGroupMember.SetRange("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");
        IF NOT RecRef.GET(ApprovalEntryArgument."Record ID to Approve") THEN
            WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code")
        ELSE BEGIN
            case RecRef.Number of
                database::"Purchase Header":
                    begin
                        RecRef.SETTABLE(PurchHeader);
                        WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", PurchHeader."Approval Route");
                    end;
                database::"Document Capturing Header":
                    begin
                        RecRef.SETTABLE(DocumentCapturingHdr);
                        WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", DocumentCapturingHdr."Approval Route");
                    end;
                else
                    WorkflowUserGroupMember.SETRANGE("Workflow User Group Code", WorkflowStepArgument."Workflow User Group Code");
            end;
        end;

        if not WorkflowUserGroupMember.FindSet then
            Error(NoWFUserGroupMembersErr);

        repeat
            ApproverId := WorkflowUserGroupMember."User Name";
            if not UserSetup.Get(ApproverId) then
                Error(WFUserGroupNotInSetupErr, ApproverId);
            ApprovalMgt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo + WorkflowUserGroupMember."Sequence No.", ApproverId, WorkflowStepArgument);
        until WorkflowUserGroupMember.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', true, true)]
    local procedure "Purch.-Post_OnBeforePostPurchaseDoc"
    (
        var PurchaseHeader: Record "Purchase Header";
        PreviewMode: Boolean;
        CommitIsSupressed: Boolean;
        var HideProgressWindow: Boolean;
        var ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        var IsHandled: Boolean
    )
    var
        DimensionErr: Label 'Both %1 & %2 is empty';
    begin
        if (PurchaseHeader."Document Type" = PurchaseHeader."Document Type"::Invoice) or (PurchaseHeader.Invoice) then begin
            if (PurchaseHeader."Shortcut Dimension 1 Code" = '') and (PurchaseHeader."Shortcut Dimension 2 Code" = '') then
                Error(DimensionErr, PurchaseHeader.FieldCaption("Shortcut Dimension 1 Code"), PurchaseHeader.FieldCaption("Shortcut Dimension 2 Code"));
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeDeleteAfterPosting', '', true, true)]
    local procedure "Purch.-Post_OnBeforeDeleteAfterPosting"
    (
        var PurchaseHeader: Record "Purchase Header";
        var PurchInvHeader: Record "Purch. Inv. Header";
        var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        var SkipDelete: Boolean;
        CommitIsSupressed: Boolean;
        var TempPurchLine: Record "Purchase Line";
        var TempPurchLineGlobal: Record "Purchase Line"
    )
    var
        DocumentCapturing: Record "Document Capturing Header";
    begin
        if PurchaseHeader."Document Capturing No." = '' then
            exit;
        DocumentCapturing.Reset();
        DocumentCapturing.SetRange("Document No.", PurchaseHeader."Document Capturing No.");
        if DocumentCapturing.FindFirst() then begin
            DocumentCapturing.Posted := true;
            DocumentCapturing."ERP Posted Document No." := PurchInvHeader."No.";
            DocumentCapturing.Modify();
        end;
    end;

    procedure GetUserName(UserGUID: Guid): Text
    var
        UserLRec: Record User;
    begin
        if UserLRec.Get(UserGUID) then
            if UserLRec."Full Name" <> '' then
                exit(UserLRec."Full Name");
        exit(UserLRec."User Name");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeValidatePromisedReceiptDate', '', true, true)]
    local procedure "Purchase Header_OnBeforeValidatePromisedReceiptDate"
    (
        var PurchaseHeader: Record "Purchase Header";
        xPurchaseHeader: Record "Purchase Header";
        var IsHandled: Boolean;
        CUrrentFieldNo: Integer
    )
    begin
        if PurchaseHeader."Promised Receipt Date" <> xPurchaseHeader."Promised Receipt Date" then
            PurchaseHeader.UpdatePurchLinesByFieldNo(PurchaseHeader.FieldNo("Promised Receipt Date"), CUrrentFieldNo <> 0);
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Whse.-Post Receipt", 'OnCodeOnAfterPostSourceDocuments', '', true, true)]
    local procedure "Whse.-Post Receipt_OnCodeOnAfterPostSourceDocuments"
    (
        var WarehouseReceiptHeader: Record "Warehouse Receipt Header";
        WarehouseReceiptLine: Record "Warehouse Receipt Line"
    )
    var
        ItemRec: Record Item;
        SendEmailStream: Codeunit "Send Email Stream";
        WarehouseReceiptLine2: Record "Warehouse Receipt Line";
    begin
        WarehouseReceiptLine2.Reset();
        WarehouseReceiptLine2.SetRange("No.", WarehouseReceiptLine."No.");
        WarehouseReceiptLine2.SetFilter("Qty. to Receive", '>%1', 0);
        if WarehouseReceiptLine2.FindSet() then
            repeat
                if ItemRec.Get(WarehouseReceiptLine2."Item No.") and (ItemRec."Quality Check") and (ItemRec."Quality Spec ID" <> '') then
                    SendEmailStream.SendMailForQuality(WarehouseReceiptLine2);
            until WarehouseReceiptLine2.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeMarkAllWhereUserisApproverOrSender', '', true, true)]
    local procedure "Approval Entry_OnBeforeMarkAllWhereUserisApproverOrSender"
    (
        var ApprovalEntry: Record "Approval Entry";
        var IsHandled: Boolean
    )
    var
        TableIDFilterTxt: Text;
        TableID: Integer;
    begin
        TableIDFilterTxt := ApprovalEntry.GetFilter("Table ID");
        if TableIDFilterTxt = '' then
            exit;
        if Evaluate(TableID, TableIDFilterTxt) then
            if TableID = Database::"Document Capturing Header" then
                IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Prod. Order Status Management", 'OnBeforeOnRun', '', true, true)]
    local procedure "Prod. Order Status Management_OnBeforeOnRun"
    (
        var ChangeStatusOnProdOrderPage: Page "Change Status on Prod. Order";
        var ProductionOrder: Record "Production Order";
        var IsHandled: Boolean;
        NewStatus: Enum "Production Order Status";
        NewPostingDate: Date;
        NewUpdateUnitCost: Boolean
    )
    begin
        Commit();
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCopyAddressInfoFromOrderAddress', '', true, false)]
    local procedure OnAfterCopyAddressInfoFromOrderAddress(var OrderAddress: Record "Order Address"; var PurchHeader: Record "Purchase Header")
    begin
        if (PurchHeader."Document Type" = PurchHeader."Document Type"::Order) or (PurchHeader."Document Type" = PurchHeader."Document Type"::Invoice) or (PurchHeader."Document Type" = PurchHeader."Document Type"::"Credit Memo") or (PurchHeader."Document Type" = PurchHeader."Document Type"::"Return Order") then begin
            OrderAddress.Reset();
            OrderAddress.SetRange("Vendor No.", PurchHeader."Buy-from Vendor No.");
            OrderAddress.SetRange(code, PurchHeader."Order Address Code");
            if OrderAddress.FindFirst() then begin
                OrderAddress.TestField("VAT Registration No.");
                PurchHeader."VAT Registration No." := OrderAddress."VAT Registration No.";
            end;
        end;
    end;







}
