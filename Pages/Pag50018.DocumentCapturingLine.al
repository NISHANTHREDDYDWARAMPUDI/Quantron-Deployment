page 50018 "Document Capturing Line API"
{
    APIGroup = 'line';
    APIPublisher = 'quantron';
    APIVersion = 'v1.0';
    ApplicationArea = All;
    Caption = 'Document Capturing Line';
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityName = 'linedata';
    EntitySetName = 'linedata';
    PageType = API;
    SourceTable = "Document Capturing Line";


    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(documentID; Rec.DocumentID)
                {
                    Caption = 'Document ID';
                }
                field(amount; Rec.Amount)
                {
                    Caption = 'Amount';
                }
                field(amountIncludingVAT; Rec."Amount Including VAT")
                {
                    Caption = 'Amount Including VAT';
                }
                field(currencyCode; Rec."Currency Code")
                {
                    Caption = 'Currency Code';
                }
                field(description; Rec.Description)
                {
                    Caption = 'Description';
                }
                field(description2; Rec."Description 2")
                {
                    Caption = 'Description 2';
                }
                field(lineDiscount; Rec."Line Discount %")
                {
                    Caption = 'Line Discount %';
                }
                field(lineDiscountAmount; Rec."Line Discount Amount")
                {
                    Caption = 'Line Discount Amount';
                }
                field(productCode; Rec."Product Code")
                {
                    Caption = 'Product Code';
                }
                field(quantity; Rec.Quantity)
                {
                    Caption = 'Quantity';
                }
                field(unitCost; Rec."Direct Unit Cost")
                {
                    Caption = 'Unit Cost';
                }
                field(unitOfMeasure; Rec."Unit of Measure")
                {
                    Caption = 'Unit of Measure';
                }
                field(vat; Rec."VAT %")
                {
                    Caption = 'VAT %';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec.Description = 'Übertrag' then
            exit(false);
    end;
}
