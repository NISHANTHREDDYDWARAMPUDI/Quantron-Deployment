page 50022 "Document Attachment Fact_B2B"
{
    Caption = 'Documents Attached';
    PageType = CardPart;
    SourceTable = "Document Attachment";

    layout
    {
        area(content)
        {
            group(Control2)
            {
                ShowCaption = false;
                field(Documents; NumberOfRecords)
                {
                    ApplicationArea = All;
                    Caption = 'Documents';
                    StyleExpr = TRUE;
                    ToolTip = 'Specifies the number of attachments.';

                    trigger OnDrillDown()
                    var
                        Customer: Record Customer;
                        Vendor: Record Vendor;
                        Item: Record Item;
                        Employee: Record Employee;
                        FixedAsset: Record "Fixed Asset";
                        Resource: Record Resource;
                        SalesHeader: Record "Sales Header";
                        PurchaseHeader: Record "Purchase Header";
                        Job: Record Job;
                        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
                        SalesInvoiceHeader: Record "Sales Invoice Header";
                        PurchInvHeader: Record "Purch. Inv. Header";
                        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
                        VATReportHeader: Record "VAT Report Header";
                        DocumentAttachmentDetails: Page "Document Attachment Det_B2B";
                        RecRef: RecordRef;
                    begin
                        case Rec."Table ID" of
                            0:
                                exit;
                            DATABASE::Customer:
                                begin
                                    RecRef.Open(DATABASE::Customer);
                                    if Customer.Get(Rec."No.") then
                                        RecRef.GetTable(Customer);
                                end;
                            DATABASE::Vendor:
                                begin
                                    RecRef.Open(DATABASE::Vendor);
                                    if Vendor.Get(Rec."No.") then
                                        RecRef.GetTable(Vendor);
                                end;
                            DATABASE::Item:
                                begin
                                    RecRef.Open(DATABASE::Item);
                                    if Item.Get(Rec."No.") then
                                        RecRef.GetTable(Item);
                                end;
                            DATABASE::Employee:
                                begin
                                    RecRef.Open(DATABASE::Employee);
                                    if Employee.Get(Rec."No.") then
                                        RecRef.GetTable(Employee);
                                end;
                            DATABASE::"Fixed Asset":
                                begin
                                    RecRef.Open(DATABASE::"Fixed Asset");
                                    if FixedAsset.Get(Rec."No.") then
                                        RecRef.GetTable(FixedAsset);
                                end;
                            DATABASE::Resource:
                                begin
                                    RecRef.Open(DATABASE::Resource);
                                    if Resource.Get(Rec."No.") then
                                        RecRef.GetTable(Resource);
                                end;
                            DATABASE::Job:
                                begin
                                    RecRef.Open(DATABASE::Job);
                                    if Job.Get(Rec."No.") then
                                        RecRef.GetTable(Job);
                                end;
                            DATABASE::"Sales Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Header");
                                    if SalesHeader.Get(Rec."Document Type", Rec."No.") then
                                        RecRef.GetTable(SalesHeader);
                                end;
                            DATABASE::"Sales Invoice Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Invoice Header");
                                    if SalesInvoiceHeader.Get(Rec."No.") then
                                        RecRef.GetTable(SalesInvoiceHeader);
                                end;
                            DATABASE::"Sales Cr.Memo Header":
                                begin
                                    RecRef.Open(DATABASE::"Sales Cr.Memo Header");
                                    if SalesCrMemoHeader.Get(Rec."No.") then
                                        RecRef.GetTable(SalesCrMemoHeader);
                                end;
                            DATABASE::"Purchase Header":
                                begin
                                    RecRef.Open(DATABASE::"Purchase Header");
                                    if PurchaseHeader.Get(Rec."Document Type", Rec."No.") then
                                        RecRef.GetTable(PurchaseHeader);
                                end;
                            DATABASE::"Purch. Inv. Header":
                                begin
                                    RecRef.Open(DATABASE::"Purch. Inv. Header");
                                    if PurchInvHeader.Get(Rec."No.") then
                                        RecRef.GetTable(PurchInvHeader);
                                end;
                            DATABASE::"Purch. Cr. Memo Hdr.":
                                begin
                                    RecRef.Open(DATABASE::"Purch. Cr. Memo Hdr.");
                                    if PurchCrMemoHdr.Get(Rec."No.") then
                                        RecRef.GetTable(PurchCrMemoHdr);
                                end;
                            DATABASE::"VAT Report Header":
                                begin
                                    RecRef.Open(DATABASE::"VAT Report Header");
                                    if VATReportHeader.Get(Rec."VAT Report Config. Code", Rec."No.") then
                                        RecRef.GetTable(VATReportHeader);
                                end;
                            else
                                OnBeforeDrillDownCust(Rec, RecRef);
                        end;

                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
        }
    }

    actions
    {
    }

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDrillDownCust(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    begin
    end;

    trigger OnAfterGetCurrRecord()
    var
        CurrentFilterGroup: Integer;
    begin
        CurrentFilterGroup := Rec.FilterGroup;
        Rec.FilterGroup := 4;

        NumberOfRecords := 0;
        if Rec.GetFilters() <> '' then begin
            if Evaluate(Rec."VAT Report Config. Code", Rec.GetFilter("VAT Report Config. Code")) then;
            NumberOfRecords := Rec.Count;
        end;
        Rec.FilterGroup := CurrentFilterGroup;
    end;

    var
        NumberOfRecords: Integer;
}

