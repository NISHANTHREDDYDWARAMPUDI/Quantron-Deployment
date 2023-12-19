page 50017 "Document Capturing Header API"
{
    APIGroup = 'header';
    APIPublisher = 'quantron';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Document Capturing Header';
    DelayedInsert = true;
    EntityName = 'headerdata';
    EntitySetName = 'headerdata';
    PageType = API;
    SourceTable = "Document Capturing Header";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(systemId; Rec.SystemId)
                {
                    Caption = 'SystemId';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Including VAT';
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    Caption = 'Vendor No.';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(customerAddress; Rec."Customer Address")
                {
                    Caption = 'Customer Address';
                }
                field(customerID; Rec."Customer ID")
                {
                    Caption = 'Customer ID';
                }
                field(customerName; Rec."Customer Name")
                {
                    Caption = 'Customer Name';
                }
                field(customerTaxID; Rec."Customer Tax ID")
                {
                    Caption = 'Customer Tax ID';
                }
                field(documentDate; Rec."Document Date")
                {
                    Caption = 'Document Date';
                }
                field(dueDate; Rec."Due Date")
                {
                    Caption = 'Due Date';
                }
                field(locationCode; Rec."Location Code")
                {
                    Caption = 'Location Code';
                }
                field(orderDate; Rec."Order Date")
                {
                    Caption = 'Order Date';
                }
                field(paymentTerms; Rec."Payment Terms")
                {
                    Caption = 'Payment Terms';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(purchaseOrderNo; Rec."Purchase Order No.")
                {
                    Caption = 'Purchase Order No.';                    
                }
                field(vatAmount; Rec."VAT Amount")
                {
                    Caption = 'VAT Amount';
                }
                field(vatRegistrationNo; Rec."VAT Registration No.")
                {
                    Caption = 'VAT Registration No.';
                }
                field(vendorAddress; Rec."Vendor Address")
                {
                    Caption = 'Vendor Address';
                }
                field(vendorInvoiceNo; Rec."Vendor Invoice No.")
                {
                    Caption = 'Vendor Invoice No.';
                }
                field(vendorName; Rec."Vendor Name")
                {
                    Caption = 'Vendor Name';
                }
                field(attachment; Rec.Attachment)
                {
                    Caption = 'Attachment';
                }
                field(fileName; Rec."File Name")
                {
                    Caption = 'File Name';
                }
                field(ContentBase64; ContentBase64)
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    var
                        TempBlob: Codeunit "Temp Blob";
                        VarOutStream: OutStream;
                        Base64CU: Codeunit "Base64 Convert";
                    begin
                        Rec.Attachment.CreateOutStream(VarOutStream);
                        Base64CU.FromBase64(ContentBase64, VarOutStream);
                    end;
                }
            }
        }
    }


    var
        ContentBase64: Text;
}
