report 50011 "Document Capturing List"
{
    ApplicationArea = All;
    Caption = 'Document Capturing List';
    DefaultLayout = RDLC;
    RDLCLayout = 'Reports\Layouts\DocumentCapturingList.rdl';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(DocumentCapturingHeader; "Document Capturing Header")
        {
            RequestFilterFields = Status;
            column(DocumentNo; "Document No.")
            {
                IncludeCaption = true;
            }
            column(VendorName; "Vendor Name")
            {
                IncludeCaption = true;
            }
            column(VendorInvoiceNo; "Vendor Invoice No.")
            {
                IncludeCaption = true;
            }
            column(VATRegistrationNo; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(PurchaseOrderNo; "Purchase Order No.")
            {
                IncludeCaption = true;
            }
            column(CustomerName; "Customer Name")
            {
                IncludeCaption = true;
            }
            column(CustomerAddress; "Customer Address")
            {
                IncludeCaption = true;
            }
            column(Amount; Amount)
            {
                IncludeCaption = true;
            }
            column(VATAmount; "VAT Amount")
            {
                IncludeCaption = true;
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
                IncludeCaption = true;
            }
            column(Status; Status)
            {
                IncludeCaption = true;
            }
            column(OrderDate; "Order Date")
            {
                IncludeCaption = true;
            }
            column(DocumentDate_DocumentCapturingHeader; "Document Date")
            {
                IncludeCaption = true;
            }
        }
    }
}
